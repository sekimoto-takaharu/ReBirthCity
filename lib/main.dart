import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebirth_city/core/theme.dart';
import 'package:rebirth_city/features/city_management/presentation/city_management_page.dart';
import 'package:rebirth_city/features/life_planning/presentation/life_planning_page.dart';
import 'package:rebirth_city/features/simulation/presentation/simulation_page.dart';

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

class ReBirthCityHomePage extends StatefulWidget {
  const ReBirthCityHomePage({super.key});

  @override
  State<ReBirthCityHomePage> createState() => _ReBirthCityHomePageState();
}

class _ReBirthCityHomePageState extends State<ReBirthCityHomePage> {
  int _currentIndex = 0;

  static const _titles = [
    '街の運営',
    '未来予測',
    '終活アクション',
  ];

  static const _pages = [
    CityManagementPage(),
    SimulationPage(),
    LifePlanningPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('RE:BIRTH CITY'),
            Text(
              _titles[_currentIndex],
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            backgroundColor: AppTheme.surfaceWhite,
            builder: (context) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'クイックアクション',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _QuickActionTile(
                        icon: Icons.account_balance_rounded,
                        title: '街の状況を見る',
                        subtitle: '人口・予算・高齢化率をすぐ確認',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _currentIndex = 0);
                        },
                      ),
                      _QuickActionTile(
                        icon: Icons.timeline_rounded,
                        title: '未来をシミュレーション',
                        subtitle: '30年後・100年後をスライダーで比較',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _currentIndex = 1);
                        },
                      ),
                      _QuickActionTile(
                        icon: Icons.auto_awesome_rounded,
                        title: '終活アクションを選ぶ',
                        subtitle: '街に効果を与える行動を実行',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _currentIndex = 2);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.bolt_rounded),
        label: const Text('アクション'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            height: 72,
            backgroundColor: Colors.white,
            indicatorColor: AppTheme.primaryBlueSoft,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.location_city_rounded),
                selectedIcon: Icon(Icons.location_city),
                label: '街',
              ),
              NavigationDestination(
                icon: Icon(Icons.insights_outlined),
                selectedIcon: Icon(Icons.insights),
                label: '未来',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border_rounded),
                selectedIcon: Icon(Icons.favorite),
                label: '終活',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryBlueSoft,
          foregroundColor: AppTheme.primaryBlueDeep,
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
