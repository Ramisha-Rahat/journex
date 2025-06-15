import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journex/utils/theme/theme.dart' as AppTheme;
import 'package:journex/viewmodels/journel_viewModel.dart';
import 'package:journex/viewmodels/expense_viewModel.dart';
import 'package:journex/views/HomeScreen/homeScreen.dart';
import 'package:provider/provider.dart';
import 'model/balance_container.dart';
import 'model/journal_entries.dart';
import 'model/transaction_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(BalanceContainerAdapter());
  Hive.registerAdapter(TransactionEntryAdapter());

  await Hive.openBox<JournalEntry>('journalBox_v2');
  await Hive.openBox<BalanceContainer>('balanceContainers');
  await Hive.openBox<TransactionEntry>('transactions');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JournalViewModel()..init()),
        ChangeNotifierProvider(create: (_) => ExpenseTrackerViewModel()),
      ],
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
