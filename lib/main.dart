import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:journex/utils/theme/theme.dart';
import 'package:journex/viewmodels/journel_viewModel.dart';
import 'package:journex/views/HomeScreen/homeScreen.dart';
import 'package:provider/provider.dart';

import 'model/journel_entries.dart';

void main()  async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(JournalEntryAdapter());

    final journalViewModel = JournalViewModel();
    await journalViewModel.init();

    runApp(
      ChangeNotifierProvider(
        create: (_) => journalViewModel,
        child: const MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
