import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendance_tracker/main.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  String courseName = '';
  Map<String, bool> daysOfWeek = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  @override
  Widget build(BuildContext context) {
    var courseProvider = Provider.of<CourseProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Time Table Details'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Course Name',
              ),
              onSaved: (value) {
                courseName = value ?? '';
              },
            ),
            ...daysOfWeek.keys.map((day) {
              return CheckboxListTile(
                title: Text(day),
                value: daysOfWeek[day],
                onChanged: (bool? value) {
                  setState(() {
                    daysOfWeek[day] = value!;
                  });
                },
              );
            }).toList(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Convert the selected days to a string
                  String selectedDays = daysOfWeek.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .join(', ');
                  // Add the new course to the CourseProvider
                  courseProvider.addCourse(Course(name: courseName, days: selectedDays));
                  // Navigate back to the home screen
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        )),
      ),
    );
  }
}
