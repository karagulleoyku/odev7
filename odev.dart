import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student CRUD App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF2F2F2),
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: StudentPage(),
    );
  }
}

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final String baseUrl = 'http://localhost:3000/students';

  List students = [];

  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController bolumIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  fetchStudents() async {
    var response = await http.get(Uri.parse(baseUrl));
    setState(() {
      students = json.decode(response.body);
    });
  }

  addStudent() async {
    var response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode({
        "ad": adController.text,
        "soyad": soyadController.text,
        "bolumId": int.parse(bolumIdController.text)
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      fetchStudents();
    }
  }

  deleteStudent(int id) async {
    var response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      fetchStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: adController,
              decoration: InputDecoration(labelText: 'Ad'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: soyadController,
              decoration: InputDecoration(labelText: 'Soyad'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: bolumIdController,
              decoration: InputDecoration(labelText: 'Bölüm ID'),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: addStudent,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Kırmızı buton
            ),
            child: Text(
              'Öğrenci Ekle',
              style: TextStyle(color: Colors.white), // Beyaz yazı
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                return ListTile(
                  title: Text('${student['ad']} ${student['soyad']}'),
                  subtitle: Text('Bölüm ID: ${student['bolumId']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteStudent(student['ogrenciID']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
