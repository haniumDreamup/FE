import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// 기본 스켈레톤 컨테이너
class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// 리스트 아이템 스켈레톤
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const SkeletonContainer(
            width: 60,
            height: 60,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonContainer(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 16,
                ),
                const SizedBox(height: 8),
                SkeletonContainer(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 카드 스켈레톤
class SkeletonCard extends StatelessWidget {
  final double? height;

  const SkeletonCard({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: SkeletonContainer(
        width: double.infinity,
        height: height ?? 150,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

// 약물 리스트 스켈레톤
class MedicationSkeletonLoader extends StatelessWidget {
  const MedicationSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SkeletonContainer(
                width: 80,
                height: 80,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonContainer(
                      width: 150,
                      height: 20,
                    ),
                    const SizedBox(height: 8),
                    const SkeletonContainer(
                      width: 100,
                      height: 16,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        SkeletonContainer(
                          width: 60,
                          height: 24,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        SizedBox(width: 8),
                        SkeletonContainer(
                          width: 60,
                          height: 24,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SkeletonContainer(
                width: 40,
                height: 40,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 홈 화면 스켈레톤
class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 스켈레톤
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonContainer(width: 120, height: 24),
                SizedBox(height: 8),
                SkeletonContainer(width: 200, height: 32),
              ],
            ),
          ),
          
          // 오늘의 요약 카드 스켈레톤
          const SkeletonCard(height: 180),
          
          // 빠른 실행 섹션 스켈레톤
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonContainer(width: 100, height: 20),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: List.generate(
                    4,
                    (index) => const SkeletonContainer(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// 일정 리스트 스켈레톤
class ScheduleSkeletonLoader extends StatelessWidget {
  const ScheduleSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SkeletonContainer(
                width: 50,
                height: 50,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonContainer(width: 180, height: 18),
                    SizedBox(height: 8),
                    SkeletonContainer(width: 120, height: 14),
                    SizedBox(height: 4),
                    SkeletonContainer(width: 100, height: 14),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}