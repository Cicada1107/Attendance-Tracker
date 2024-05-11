import 'package:attendance_tracker/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const primaryColor = Color(0xFF191970);
const secondaryColor = Color(0xFFFFFFFF);
const tertiaryColor = Color(0xFF00FF00);

class Course {
  String name;
  String days;
  int totalClasses;
  int attendedClasses;
  Map<String, bool> attendance;

  Course({
    required this.name,
    required this.days,
    this.totalClasses = 0,
    this.attendedClasses = 0,
    Map<String, bool>? attendance,
  }) : this.attendance = attendance ?? {};

  // Convert a Course instance into a Map (for JSON)
  Map<String, dynamic> toJson() => {
    'name': name,
    'days': days,
    'totalClasses': totalClasses,
    'attendedClasses': attendedClasses,
    'attendance': attendance,
  };

  // Create a Course instance from a Map (from JSON)
  Course.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        days = json['days'],
        totalClasses = json['totalClasses'],
        attendedClasses = json['attendedClasses'],
        attendance = Map<String, bool>.from(json['attendance']);
}

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];

  CourseProvider() {
    _loadCourses();
  }

  // Getter method to expose the list of courses
  List<Course> get courses {
    return [..._courses];
  }

  Future<void> _saveCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_courses.map((item) => item.toJson()).toList());
    prefs.setString('courses', encodedData);
  }

  Future<void> _loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCourses = prefs.getString('courses');

    if (savedCourses != null) {
      final List<dynamic> decodedData = jsonDecode(savedCourses);
      _courses = decodedData.map((item) => Course.fromJson(item)).toList();
    }
  }

  Future<void> loadCourses() async {
    await _loadCourses();
  }//The sole purpose of this is to make the _loadCourses() function accessible globally and not just within the class


  void addCourse(Course course) {
    _courses.add(course);
    notifyListeners();
    _saveCourses();
  }

  void removeCourse(Course course) {
    _courses.remove(course);
    notifyListeners();
    _saveCourses();
  }

  void incrementTotalClasses(Course course) {
    course.totalClasses++;
    notifyListeners();
    _saveCourses();
  }

  void incrementAttendedClasses(Course course) {
    course.attendedClasses++;
    notifyListeners();
    _saveCourses();
  }

  void updateAttendance(Course course, String date, bool attended) {
    course.attendance[date] = attended;
    notifyListeners();
    _saveCourses();
  }

  void removeAttendance(Course course, String date) {
    if (course.attendance[date] == true) {
      course.attendedClasses--;
    }
    course.totalClasses--;
    course.attendance.remove(date);
    notifyListeners();
    _saveCourses();
  }
  //Also add a method to decrement/fix a mistake
  //also add a confirmation screen when deleting a course
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseProvider(),
      child: MaterialApp(
        home: Home(),
      ),
    ),
  );
}



