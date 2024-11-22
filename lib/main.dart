import 'package:flutter/material.dart';

void main() {
  runApp(GPACalculatorApp());
}

class GPACalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.teal, // Emerald green
          secondary: Colors.tealAccent,
        ),
      ),
      home: GPACalculator(),
    );
  }
}

class GPACalculator extends StatefulWidget {
  @override
  _GPACalculatorState createState() => _GPACalculatorState();
}

class _GPACalculatorState extends State<GPACalculator> {
  final List<Map<String, dynamic>> modules = [];
  final TextEditingController moduleNameController = TextEditingController();
  final TextEditingController moduleCreditController = TextEditingController();
  final TextEditingController moduleGradeController = TextEditingController();

  double totalCredits = 0;
  double totalGradePoints = 0;

  double convertGradeToPoint(double grade) {
    if (grade >= 95 && grade <= 100) {
      return 5.0;
    } else if (grade >= 90 && grade <= 94) {
      return 4.75;
    } else if (grade >= 85 && grade <= 89) {
      return 4.5;
    } else if (grade >= 80 && grade <= 84) {
      return 4.0;
    } else if (grade >= 75 && grade <= 79) {
      return 3.5;
    } else if (grade >= 70 && grade <= 74) {
      return 3.0;
    } else if (grade >= 65 && grade <= 69) {
      return 2.5;
    } else if (grade >= 60 && grade <= 64) {
      return 2.0;
    } else {
      return 1.0;
    }
  }

  void addModule() {
    String moduleName = moduleNameController.text;
    double? moduleCredit = double.tryParse(moduleCreditController.text);
    double? moduleGrade = double.tryParse(moduleGradeController.text);

    if (moduleCredit == null || moduleGrade == null || moduleName.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill out all fields correctly.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (moduleCredit < 1 ||
        moduleCredit > 10 ||
        moduleGrade < 0 ||
        moduleGrade > 100) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Input'),
          content: Text('Module credit must be 1-10 and grade must be 0-100.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (totalCredits + moduleCredit > 18) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Credit Limit Exceeded'),
          content: Text('You cannot exceed a total of 18 credits.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    double gradePoint = convertGradeToPoint(moduleGrade);

    setState(() {
      modules.add({
        'name': moduleName,
        'credit': moduleCredit,
        'grade': moduleGrade,
        'point': gradePoint,
      });

      totalCredits += moduleCredit;
      totalGradePoints += gradePoint * moduleCredit;
    });

    moduleNameController.clear();
    moduleCreditController.clear();
    moduleGradeController.clear();

    // add another module
    _askForAnotherModule();
  }

  void _askForAnotherModule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Another Module?'),
        content: Text('Do you want to enter another module?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleUserResponse('y');
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleUserResponse('n');
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  // Function to handle the user response to adding another module
  void _handleUserResponse(String response) {
    if (response == 'y') {
      // Do nothing, the user will continue entering modules
    } else if (response == 'n') {
      // Close the dialog and show the GPA
      Navigator.pop(context);
    }
  }

  double calculateGPA() {
    if (totalCredits == 0) return 0.0;
    return totalGradePoints / totalCredits;
  }

  void clearPage() {
    setState(() {
      modules.clear();
      totalCredits = 0;
      totalGradePoints = 0;
      moduleNameController.clear();
      moduleCreditController.clear();
      moduleGradeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('welcome to GPA calculator!'),
        backgroundColor: Colors.teal, // Emerald green
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: clearPage,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.teal),
              ),
              child: TextField(
                controller: moduleNameController,
                decoration: InputDecoration(
                  labelText: 'Module Name',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.teal),
              ),
              child: TextField(
                controller: moduleCreditController,
                decoration: InputDecoration(
                  labelText: 'Module Credit (1 to 10)',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.teal),
              ),
              child: TextField(
                controller: moduleGradeController,
                decoration: InputDecoration(
                  labelText: 'Module Grade (0 to 100)',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addModule,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, 
                foregroundColor: Colors.white, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text('Add Module'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return ListTile(
                    title: Text('${module['name']}'),
                    subtitle: Text(
                        'Credit: ${module['credit']}, Grade: ${module['grade']}'),
                    trailing: Text('Point: ${module['point']}'),
                  );
                },
              ),
            ),
            if (modules.isNotEmpty)
              Text(
                'GPA: ${calculateGPA().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
