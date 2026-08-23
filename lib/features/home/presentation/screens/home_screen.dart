import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/home_provider.dart';
import '../widgets/overall_attendance_card.dart';
import '../widgets/subject_attendance_card.dart';
import '../widgets/today_class_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final homeState = ref.watch(homeViewModelProvider);

    return homeState.when(
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },

      error: (error, stack) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Something went wrong',
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(
                      homeViewModelProvider,
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },

      data: (homeData) {
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(homeViewModelProvider.notifier)
                    .refreshHome();
              },

              child: CustomScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      32,
                    ),

                    sliver: SliverList(
                      delegate:
                          SliverChildListDelegate(
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
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons
                                      .notifications_none_rounded,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          OverallAttendanceCard(
                            percentage:
                                homeData
                                    .overallAttendance,
                          ),

                          const SizedBox(height: 28),

                          const Text(
                            'Subject Attendance',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 14),

                          ...homeData.subjects.map(
                            (subject) {
                              return Padding(
                                padding:
                                    const EdgeInsets
                                        .only(
                                  bottom: 12,
                                ),

                                child:
                                    SubjectAttendanceCard(
                                  subjectName:
                                      subject.name,

                                  percentage:
                                      subject.attendance,

                                  onTap: () {
                                    context.push(
                                      '/attendance/'
                                      '${subject.id}',
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            "Today's Classes",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 12),

                          ...homeData.todayClasses.map(
                            (classData) {
                              return Padding(
                                padding:
                                    const EdgeInsets
                                        .only(
                                  bottom: 12,
                                ),

                                child: TodayClassCard(
                                  subject:
                                      classData.subject,
                                  time:
                                      classData.time,
                                  room:
                                      classData.room,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}