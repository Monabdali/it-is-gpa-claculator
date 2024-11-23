import 'package:flutter/material.dart';

void main() {
  runApp(GPACalculatorApp());
}

class GPACalculatorApp extends StatelessWidget {
  const GPACalculatorApp({super.key});

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
  const GPACalculator({super.key});

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
      // Show error for missing inputs
      setState(() {
        if (moduleName.isEmpty) {
          moduleNameError = 'Please enter a module name';
        }
        if (moduleCredit == null) {
          moduleCreditError = 'Please enter a valid module credit (1-10)';
        }
        if (moduleGrade == null) {
          moduleGradeError = 'Please enter a valid module grade (0-100)';
        }
      });
      return;
    }

    if (moduleCredit < 1 ||
        moduleCredit > 10 ||
        moduleGrade < 0 ||
        moduleGrade > 100) {
      // Show error for invalid inputs
      setState(() {
        if (moduleCredit < 1 || moduleCredit > 10) {
          moduleCreditError = 'Credit must be between 1 and 10';
        }
        if (moduleGrade < 0 || moduleGrade > 100) {
          moduleGradeError = 'Grade must be between 0 and 100';
        }
      });
      return;
    }

    if (totalCredits + moduleCredit > 18) {
      // Show error if total credits exceed the limit
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Credit Limit Exceeded'),
          content: const Text('You cannot exceed a total of 18 credits.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (modules.length >= 10) {
      // Show error if the module limit is reached
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Module Limit Reached'),
          content: const Text('You cannot add more than 10 modules.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
    moduleNameError = null;
    moduleCreditError = null;
    moduleGradeError = null;

    // add another module
    _askForAnotherModule();
  }

  void _askForAnotherModule() {
    final TextEditingController responseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Another Module?'),
        content: TextField(
          controller: responseController,
          decoration: const InputDecoration(
            labelText: 'enter y for Yes, n for No',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String response = responseController.text.trim().toLowerCase();
              Navigator.pop(context);
              _handleUserResponse(response);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _handleUserResponse(String response) {
    if (response == 'y') {
      // User wants to add another module
    } else if (response == 'n') {
      // Do nothing, the user chose not to add more modules
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
      moduleNameError = null;
      moduleCreditError = null;
      moduleGradeError = null;
    });
  }

  String? moduleNameError;
  String? moduleCreditError;
  String? moduleGradeError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to GPA Calculator!'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
              padding: const EdgeInsets.all(8.0),
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
                  errorText: moduleNameError,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
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
                  errorText: moduleCreditError,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
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
                  errorText: moduleGradeError,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addModule,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Add Module'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return ListTile(
                    title: Text('${module['name']}'),
                    subtitle: Text(
                        'Credits: ${module['credit']}, Grade: ${module['grade']}'),
                    trailing: Text('Points: ${module['point']}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'GPA: ${calculateGPA().toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
