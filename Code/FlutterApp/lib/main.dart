import 'package:flutter/material.dart';
import 'pc_entry_page.dart';
import 'pc_list_page.dart';

void main() {
  runApp(const PCMapp());
}

class PCMapp extends StatelessWidget {
  const PCMapp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0066FF);
    const Color backgroundColor = Color(0xFF000044);

    return MaterialApp(
      title: 'PCM APP',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
          labelLarge: TextStyle(fontSize: 20.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 20),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(
              fontSize: 18.0,
              color: Colors.white70,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            )
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.cyan[200],
            textStyle: const TextStyle(fontSize: 16),
          )
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(primaryColor),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
        )
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PCM Application')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PcEntryPage()),
                );
              },
              child: const Text('Enter New PC'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PcListPage()),
                );
              },
              child: const Text('View PC List'),
            ),
          ],
        ),
      ),
    );
  }
}
