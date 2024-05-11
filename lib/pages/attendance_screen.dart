import 'package:flutter/material.dart';
import 'package:attendance_tracker/main.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatelessWidget {
  final Course course;

  AttendanceScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        double percentage = (course.attendedClasses / course.totalClasses) * 100;

        return Scaffold(
          appBar: AppBar(
            title: Text('${course.name} Attendance'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text('Total Classes: ${course.totalClasses}'),
                    Text('Classes Attended: ${course.attendedClasses}'),
                    Text('Attendance Percentage: ${percentage.toStringAsFixed(2)}%'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: course.attendance.length,
                  itemBuilder: (context, index) {
                    String date = course.attendance.keys.elementAt(index);
                    bool attended = course.attendance.values.elementAt(index);
                    return ListTile(
                      title: Text(date),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          attended ? Icon(Icons.check, color: Colors.green) : Icon(Icons.close, color: Colors.red),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              courseProvider.removeAttendance(course, date);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}