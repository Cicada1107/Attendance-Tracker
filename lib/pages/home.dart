import 'package:flutter/material.dart';
import 'package:attendance_tracker/pages/input_screen.dart';
import 'package:attendance_tracker/main.dart';
import 'package:provider/provider.dart';
import 'package:attendance_tracker/pages/attendance_screen.dart';


const primaryColor = Color(0xFF191970);
const secondaryColor = Color(0xFFFFFFFF);
const tertiaryColor = Color(0xFF00FF00);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var courseProvider = Provider.of<CourseProvider>(context, listen: false);
      courseProvider.loadCourses();
    });
  }
  Widget build(BuildContext context) {
    var courseProvider = Provider.of<CourseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Tracker"),
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: courseProvider.courses.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceScreen(course: courseProvider.courses[index]),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text(courseProvider.courses[index].name)),
                    Expanded(child: Text(courseProvider.courses[index].days)),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          String today = DateTime.now().toIso8601String().substring(0, 10);
                          courseProvider.incrementTotalClasses(courseProvider.courses[index]);
                          courseProvider.incrementAttendedClasses(courseProvider.courses[index]);
                          courseProvider.updateAttendance(courseProvider.courses[index], today, true);
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          String today = DateTime.now().toIso8601String().substring(0, 10);
                          courseProvider.incrementTotalClasses(courseProvider.courses[index]);
                          courseProvider.updateAttendance(courseProvider.courses[index], today, false);
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          courseProvider.removeCourse(courseProvider.courses[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        hoverColor: tertiaryColor,
        label: const Text("Add Course"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InputScreen()),
          );
        },
        icon: const Icon(Icons.add, color: secondaryColor),
      ),
    );
  }
}
