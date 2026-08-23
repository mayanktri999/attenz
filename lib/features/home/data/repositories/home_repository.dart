import '../models/home_data_model.dart';

class HomeRepository {
  Future<HomeDataModel> getHomeData() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    return const HomeDataModel(
      overallAttendance: 82,

      subjects: [
        SubjectAttendanceModel(
          id: 'dbms',
          name: 'Database Management System',
          attendance: 86,
        ),
        SubjectAttendanceModel(
          id: 'dsa',
          name: 'Data Structures and Algorithms',
          attendance: 72,
        ),
        SubjectAttendanceModel(
          id: 'os',
          name: 'Operating Systems',
          attendance: 54,
        ),
      ],

      todayClasses: [
        TodayClassModel(
          subject: 'Database Management System',
          time: '10:00 AM',
          room: 'Room 204',
        ),
      ],
    );
  }
}