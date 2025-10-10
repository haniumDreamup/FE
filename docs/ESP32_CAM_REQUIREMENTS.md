# ESP32-CAM 하드웨어 팀 전달 사항

**작성일**: 2025-10-03
**프로젝트**: BIF-AI 웨어러블 카메라
**대상**: 아두이노 하드웨어 개발팀

---

## 📋 요약

Flutter 앱에서 ESP32-CAM의 **실시간 영상을 보고 AI 분석**할 수 있도록 구현했습니다.
아두이노 펌웨어에서 **아래 3가지 엔드포인트만 제공**해주시면 됩니다.

---

## 🎯 필수 구현 사항

### **1. 연결 테스트 엔드포인트**

**URL**: `http://{ESP32_IP}/status`
**Method**: `GET`
**응답**: `200 OK`

```cpp
// Arduino 예시
server.on("/status", HTTP_GET, []() {
  server.send(200, "text/plain", "OK");
});
```

**목적**: Flutter 앱에서 ESP32-CAM 연결 확인

---

### **2. MJPEG 실시간 스트리밍 (★ 가장 중요)**

**URL**: `http://{ESP32_IP}:81/stream`
**Method**: `GET`
**Content-Type**: `multipart/x-mixed-replace; boundary=frame`

```cpp
// Arduino 예시
void streamHandler() {
  WiFiClient client = server.client();

  // HTTP 헤더
  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: multipart/x-mixed-replace; boundary=frame");
  client.println();

  while (client.connected()) {
    camera_fb_t *fb = esp_camera_fb_get();

    if (!fb) {
      Serial.println("Camera capture failed");
      break;
    }

    // JPEG 프레임 전송
    client.print("--frame\r\n");
    client.print("Content-Type: image/jpeg\r\n");
    client.printf("Content-Length: %u\r\n\r\n", fb->len);
    client.write(fb->buf, fb->len);
    client.print("\r\n");

    esp_camera_fb_return(fb);

    delay(33); // 30fps (1000ms / 30 = 33ms)
  }
}
```

**요구사항**:
- **포트**: 81 (스트리밍 전용)
- **프레임레이트**: 30fps 권장
- **해상도**: VGA (640x480) 권장
- **형식**: JPEG
- **품질**: 10-15 (낮을수록 고품질, 파일 크기 증가)

**주의사항**:
- `boundary=frame`은 정확히 이 문자열 사용
- 각 프레임 앞에 `--frame\r\n` 필수
- `Content-Length`는 실제 JPEG 크기와 일치해야 함

---

### **3. 정지 이미지 촬영**

**URL**: `http://{ESP32_IP}/capture`
**Method**: `GET`
**Content-Type**: `image/jpeg`

```cpp
// Arduino 예시
server.on("/capture", HTTP_GET, []() {
  camera_fb_t *fb = esp_camera_fb_get();

  if (!fb) {
    server.send(500, "text/plain", "Camera capture failed");
    return;
  }

  // JPEG 이미지 전송
  server.sendHeader("Content-Type", "image/jpeg");
  server.sendHeader("Content-Length", String(fb->len));
  server.send_P(200, "image/jpeg", (const char *)fb->buf, fb->len);

  esp_camera_fb_return(fb);
});
```

**요구사항**:
- **해상도**: VGA (640x480) 이상 권장
- **품질**: 10 (고품질 JPEG)
- **응답 시간**: 1초 이내

---

## 🔌 하드웨어 연결 (참고)

### **사용 부품**
| 부품명 | 용도 | 수량 |
|--------|------|------|
| ESP32-CAM | 카메라 + WiFi 모듈 | 1 |
| BNO085 9-DOF IMU | 자세 감지 (낙상 감지용) | 1 |
| TP4056 충전모듈 | 리튬배터리 충전 | 1 |
| MT3608 스텝업 컨버터 | 3.7V → 5V 승압 | 1 |
| 리튬폴리머 배터리 1000mAh | 전원 | 1 |

### **연결 다이어그램**
```
배터리 (3.7V)
    ↓
TP4056 충전모듈
    ↓
MT3608 스텝업 (5V 출력)
    ├─→ ESP32-CAM (5V)
    └─→ BNO085 IMU (I2C)
```

---

## 📡 WiFi 설정

### **필수 WiFi 정보 제공**

```cpp
const char* ssid = "YourWiFiSSID";        // WiFi 이름
const char* password = "YourWiFiPassword"; // WiFi 비밀번호
```

### **IP 주소 확인 방법**

```cpp
void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("WiFi Connected! IP: ");
  Serial.println(WiFi.localIP()); // ← 이 IP를 Flutter 앱에 입력
}
```

**예시 출력**:
```
WiFi Connected! IP: 192.168.1.100
```

---

## 🧪 테스트 방법

### **1. 시리얼 모니터 확인**
```
Connecting to WiFi...
WiFi Connected! IP: 192.168.1.100
Camera initialized
HTTP server started
Stream server started on port 81
```

### **2. 브라우저 테스트**

**연결 테스트**:
```
http://192.168.1.100/status
→ "OK" 표시되면 성공
```

**스트리밍 테스트**:
```
http://192.168.1.100:81/stream
→ 실시간 영상이 보이면 성공
```

**촬영 테스트**:
```
http://192.168.1.100/capture
→ 정지 이미지가 다운로드되면 성공
```

### **3. Flutter 앱 테스트**
1. 앱 실행
2. "실시간 카메라" 버튼 클릭
3. IP 주소 입력 (예: 192.168.1.100)
4. "연결하기" 클릭
5. 영상 확인

---

## 📝 권장 카메라 설정

```cpp
camera_config_t config;
config.ledc_channel = LEDC_CHANNEL_0;
config.ledc_timer = LEDC_TIMER_0;
config.pin_d0 = Y2_GPIO_NUM;
config.pin_d1 = Y3_GPIO_NUM;
config.pin_d2 = Y4_GPIO_NUM;
config.pin_d3 = Y5_GPIO_NUM;
config.pin_d4 = Y6_GPIO_NUM;
config.pin_d5 = Y7_GPIO_NUM;
config.pin_d6 = Y8_GPIO_NUM;
config.pin_d7 = Y9_GPIO_NUM;
config.pin_xclk = XCLK_GPIO_NUM;
config.pin_pclk = PCLK_GPIO_NUM;
config.pin_vsync = VSYNC_GPIO_NUM;
config.pin_href = HREF_GPIO_NUM;
config.pin_sccb_sda = SIOD_GPIO_NUM;
config.pin_sccb_scl = SIOC_GPIO_NUM;
config.pin_pwdn = PWDN_GPIO_NUM;
config.pin_reset = RESET_GPIO_NUM;
config.xclk_freq_hz = 20000000;
config.pixel_format = PIXFORMAT_JPEG; // ← JPEG 필수

// 품질 설정
config.frame_size = FRAMESIZE_VGA;    // 640x480
config.jpeg_quality = 12;             // 10-15 권장 (낮을수록 고품질)
config.fb_count = 2;                  // 프레임 버퍼 2개 (부드러운 스트리밍)

esp_camera_init(&config);
```

---

## ⚠️ 주의사항

### **1. 메모리 관리**
- `esp_camera_fb_get()` 후 반드시 `esp_camera_fb_return()` 호출
- 메모리 누수 방지 필수

```cpp
camera_fb_t *fb = esp_camera_fb_get();
if (fb) {
  // 사용
  esp_camera_fb_return(fb); // ← 필수!
}
```

### **2. WiFi 연결 안정성**
- WiFi 끊김 시 자동 재연결 로직 추가 권장
- `WiFi.status() != WL_CONNECTED` 체크

### **3. 스트리밍 성능**
- 30fps 유지가 어려우면 20fps로 조정 (delay(50))
- 해상도를 QVGA (320x240)로 낮추면 성능 향상

### **4. 전력 관리**
- 스트리밍 중 배터리 소모 큼 (약 300mA)
- 1000mAh 배터리로 약 2-3시간 작동
- 절전 모드 구현 권장

---

## 🔧 트러블슈팅

### **문제 1: "Brownout detector was triggered"**
**원인**: 전원 공급 부족
**해결**:
```cpp
// 카메라 클럭 주파수 낮추기
config.xclk_freq_hz = 10000000; // 20MHz → 10MHz
```

### **문제 2: WiFi 연결 실패**
**해결**:
```cpp
// 2.4GHz WiFi만 지원 (5GHz 안됨)
// SSID/비밀번호 재확인
// 라우터와의 거리 확인
```

### **문제 3: 스트리밍 끊김**
**해결**:
```cpp
// 프레임레이트 낮추기
delay(50); // 20fps

// 해상도 낮추기
config.frame_size = FRAMESIZE_QVGA; // 320x240
```

---

## 📞 통신 프로토콜 정리

| 항목 | 값 |
|------|-----|
| **WiFi 표준** | 802.11 b/g/n (2.4GHz) |
| **HTTP 포트** | 80 (메인 서버) |
| **스트리밍 포트** | 81 (MJPEG 스트림) |
| **프로토콜** | HTTP/1.1 |
| **스트림 타입** | multipart/x-mixed-replace |
| **이미지 형식** | JPEG |
| **프레임레이트** | 30fps 권장 |
| **해상도** | VGA (640x480) 권장 |

---

## 📦 참고 라이브러리

### **ESP32 Arduino Core**
```
https://github.com/espressif/arduino-esp32
```

### **ESP32-CAM 예제 코드**
```
Arduino IDE → 파일 → 예제 → ESP32 → Camera → CameraWebServer
```

### **추천 참고 자료**
- Random Nerd Tutorials: https://randomnerdtutorials.com/esp32-cam-video-streaming-web-server-camera-home-assistant/
- ESP32-CAM 공식 문서: https://github.com/espressif/esp32-camera

---

## 🎯 전달 체크리스트

하드웨어 팀에서 확인해야 할 사항:

- [ ] ESP32-CAM WiFi 연결 가능
- [ ] `/status` 엔드포인트 구현
- [ ] `/stream` (포트 81) MJPEG 스트리밍 구현
- [ ] `/capture` 정지 이미지 촬영 구현
- [ ] 시리얼 모니터에서 IP 주소 출력
- [ ] 브라우저에서 3가지 엔드포인트 테스트 완료
- [ ] 배터리로 2시간 이상 작동 확인

---

## 📧 문의 사항

**Flutter 앱 개발팀**:
- IP 주소 형식 확인 필요
- 엔드포인트 추가/변경 요청

**하드웨어 팀**:
- 펌웨어 업로드 문제
- WiFi 연결 이슈
- 카메라 설정 최적화

---

**이 문서를 하드웨어 팀에게 전달하시면 됩니다!** 🚀

필요한 것:
1. 위 3가지 엔드포인트만 구현
2. WiFi IP 주소만 알려주면 됨
3. 나머지는 Flutter 앱에서 처리함
