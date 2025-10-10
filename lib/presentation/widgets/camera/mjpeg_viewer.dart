import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// MJPEG 스트림을 표시하는 커스텀 위젯
/// ESP32-CAM의 multipart/x-mixed-replace 스트림 지원
class MjpegViewer extends StatefulWidget {
  final String streamUrl;
  final Widget Function(BuildContext context, Object error)? onError;

  const MjpegViewer({
    super.key,
    required this.streamUrl,
    this.onError,
  });

  @override
  State<MjpegViewer> createState() => _MjpegViewerState();
}

class _MjpegViewerState extends State<MjpegViewer> {
  http.Client? _httpClient;
  StreamSubscription? _subscription;
  Uint8List? _currentFrame;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startStream();
  }

  @override
  void dispose() {
    _stopStream();
    super.dispose();
  }

  /// MJPEG 스트림 시작
  Future<void> _startStream() async {
    try {
      _httpClient = http.Client();
      final request = http.Request('GET', Uri.parse(widget.streamUrl));

      final streamedResponse = await _httpClient!.send(request);

      if (streamedResponse.statusCode != 200) {
        setState(() {
          _errorMessage = 'HTTP ${streamedResponse.statusCode}';
          _isLoading = false;
        });
        return;
      }

      final List<int> buffer = [];
      const String boundary = '--frame';

      _subscription = streamedResponse.stream.listen(
        (chunk) {
          buffer.addAll(chunk);

          // JPEG 이미지 경계 찾기
          final data = Uint8List.fromList(buffer);
          final dataString = String.fromCharCodes(data);

          // JPEG 시작 (FF D8) 및 끝 (FF D9) 마커 찾기
          int startIndex = _findJpegStart(data);
          int endIndex = _findJpegEnd(data);

          if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
            // 완전한 JPEG 프레임 추출
            final frame = data.sublist(startIndex, endIndex + 2);

            setState(() {
              _currentFrame = frame;
              _isLoading = false;
            });

            // 처리된 데이터 제거
            buffer.clear();
            if (endIndex + 2 < data.length) {
              buffer.addAll(data.sublist(endIndex + 2));
            }
          }

          // 버퍼 크기 제한 (메모리 누수 방지)
          if (buffer.length > 1024 * 1024) {
            // 1MB 이상이면 초기화
            buffer.clear();
          }
        },
        onError: (error) {
          setState(() {
            _errorMessage = error.toString();
            _isLoading = false;
          });
        },
        onDone: () {
          setState(() {
            _errorMessage = '스트림 종료';
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// JPEG 시작 마커 찾기 (0xFF 0xD8)
  int _findJpegStart(Uint8List data) {
    for (int i = 0; i < data.length - 1; i++) {
      if (data[i] == 0xFF && data[i + 1] == 0xD8) {
        return i;
      }
    }
    return -1;
  }

  /// JPEG 끝 마커 찾기 (0xFF 0xD9)
  int _findJpegEnd(Uint8List data) {
    for (int i = 0; i < data.length - 1; i++) {
      if (data[i] == 0xFF && data[i + 1] == 0xD9) {
        return i;
      }
    }
    return -1;
  }

  /// 스트림 중지
  void _stopStream() {
    _subscription?.cancel();
    _httpClient?.close();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              '카메라 연결 중...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      if (widget.onError != null) {
        return widget.onError!(context, _errorMessage!);
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              '카메라 스트리밍 오류',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_currentFrame == null) {
      return const Center(
        child: Text(
          '프레임 대기 중...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
    }

    return Image.memory(
      _currentFrame!,
      gaplessPlayback: true, // 부드러운 재생
      fit: BoxFit.contain,
    );
  }
}
