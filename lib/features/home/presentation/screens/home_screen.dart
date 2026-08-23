import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../mock/home_mock_data.dart';
import '../widgets/overall_attendance_card.dart';
import '../widgets/subject_attendance_card.dart';
//import '../widgets/today_class_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

   @override
  Widget build( 
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                32,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Morning 👋',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Mayank',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    OverallAttendanceCard(
                      percentage:
                          HomeMockData.overallAttendance,
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Subject Attendance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 14),

                    ...HomeMockData.subjects.map(
                      (subject) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: 12),
                          child: SubjectAttendanceCard(
                            subjectName:
                                subject['name'] as String,
                            percentage:
                                subject['attendance'] as double,
                            onTap: () {
                              context.push(
                                '/attendance/${subject['id']}',
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's Classes",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            context.go('/timetable');
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}