import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/city_management/presentation/city_management_page.dart';
import 'package:rebirth_city/features/life_planning/presentation/life_planning_page.dart';

void main() {
  runApp(const ProviderScope(child: ReBirthCityApp()));
}

class ReBirthCityApp extends StatelessWidget {
  const ReBirthCityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RE:BIRTH CITY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ReBirthCityHomePage(),
    );
  }
}

class ReBirthCityHomePage extends StatelessWidget {
  const ReBirthCityHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RE:BIRTH CITY'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '街の運営'),
              Tab(text: '終活アクション'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CityManagementPage(),
            Padding(
              padding: EdgeInsets.all(20),
              child: LifePlanningPage(),
            ),
          ],
        ),
      ),
    );
  }
}
