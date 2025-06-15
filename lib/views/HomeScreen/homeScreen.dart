// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../viewmodels/expense_viewModel.dart';
// // import '../../viewmodels/journel_viewModel.dart';
// // import '../../widgets/journal_card_widget.dart';
// // import 'addEntry.dart';
// // import 'journal_detail_screen.dart';
// // import 'package:intl/intl.dart';
// //
// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});
// //
// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
// //   late TabController _tabController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 2, vsync: this);
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       Provider.of<JournalViewModel>(context, listen: false).init();
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'JOURNEX',
// //           style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
// //         ),
// //         actions: [
// //           Padding(
// //             padding: const EdgeInsets.all(20.0),
// //             child: Row(
// //               children: const [
// //                 Icon(Icons.filter_alt),
// //                 SizedBox(width: 16),
// //                 Icon(Icons.settings),
// //               ],
// //             ),
// //           ),
// //         ],
// //         bottom: TabBar(
// //           controller: _tabController,
// //           tabs: const [
// //             Tab(text: 'Journal'),
// //             Tab(text: 'Expense'),
// //           ],
// //         ),
// //       ),
// //
// //       floatingActionButton: AnimatedBuilder(
// //         animation: _tabController,
// //         builder: (context, child) {
// //           return _tabController.index == 0
// //               ? FloatingActionButton(
// //             onPressed: () async {
// //               await Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (_) => const AddEntryScreen(),
// //                 ),
// //               );
// //             },
// //             backgroundColor: Colors.green,
// //             child: const Icon(Icons.add, color: Colors.white, size: 28),
// //           )
// //               : const SizedBox.shrink();
// //         },
// //       ),
// //
// //       body: TabBarView(
// //         controller: _tabController,
// //         children: [
// //           // Journal Tab
// //           Consumer<JournalViewModel>(
// //             builder: (context, viewModel, _) {
// //               if (viewModel.isLoading) {
// //                 return const Center(child: CircularProgressIndicator());
// //               }
// //
// //               final entries = viewModel.entries;
// //
// //               if (entries.isEmpty) {
// //                 return Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(Icons.book_outlined, size: 80, color: Colors.grey.shade400),
// //                       const SizedBox(height: 16),
// //                       Text("No journal entries yet.",
// //                           style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
// //                       const SizedBox(height: 8),
// //                       Text("Tap the + button to create your first entry",
// //                           style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
// //                     ],
// //                   ),
// //                 );
// //               }
// //
// //               return RefreshIndicator(
// //                 onRefresh: () async => viewModel.loadEntries(),
// //                 child: ListView.builder(
// //                   padding: const EdgeInsets.only(top: 8, bottom: 80),
// //                   itemCount: entries.length,
// //                   itemBuilder: (context, index) {
// //                     final entry = entries[index];
// //                     return Padding(
// //                       padding: const EdgeInsets.all(8.0),
// //                       child: JournalCardWidget(
// //                         entry: entry,
// //                         onTap: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) => JournalDetailScreen(entry: entry),
// //                             ),
// //                           );
// //                         },
// //                         onEdit: () async {
// //                           await Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) => AddEntryScreen(entryToEdit: entry),
// //                             ),
// //                           );
// //                         },
// //                         onDelete: () async {
// //                           final success = await viewModel.deleteEntry(entry);
// //                           if (success && mounted) {
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               const SnackBar(
// //                                 content: Text('Entry deleted successfully'),
// //                                 backgroundColor: Colors.green,
// //                               ),
// //                             );
// //                           }
// //                         },
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               );
// //             },
// //           ),
// //
// //           // Expense Tab
// //           Consumer<ExpenseTrackerViewModel>(
// //             builder: (context, tracker, _) {
// //               final containers = tracker.allContainers;
// //               final transactions = tracker.allTransactions;
// //               final today = DateTime.now();
// //
// //               final todayExpenses = transactions.where((tx) =>
// //               tx.date.year == today.year &&
// //                   tx.date.month == today.month &&
// //                   tx.date.day == today.day &&
// //                   tx.type == 'expense'
// //               ).toList();
// //
// //               final todayTotal = todayExpenses.fold(0.0, (sum, tx) => sum + tx.amount);
// //
// //               return SingleChildScrollView(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //
// //                     const Text("My Wallets",
// //                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //                     const SizedBox(height: 8),
// //
// //                     SizedBox(
// //                       height: 120,
// //                       child: ListView.separated(
// //                         scrollDirection: Axis.horizontal,
// //                         itemCount: containers.length,
// //                         separatorBuilder: (_, __) => const SizedBox(width: 10),
// //                         itemBuilder: (context, index) {
// //                           final container = containers[index];
// //                           return Container(
// //                             width: 150,
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: BorderRadius.circular(12),
// //                               boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
// //                             ),
// //                             padding: const EdgeInsets.all(12),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(container.name,
// //                                     style: const TextStyle(
// //                                         fontWeight: FontWeight.bold, fontSize: 16)),
// //                                 const SizedBox(height: 10),
// //                                 Text(
// //                                   "Rs. ${container.balance.toStringAsFixed(2)}",
// //                                   style: TextStyle(
// //                                     color: container.balance < 0 ? Colors.red : Colors.green,
// //                                     fontSize: 18,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ),
// //
// //                     const SizedBox(height: 20),
// //
// //                     Card(
// //                       color: Colors.red.shade50,
// //                       child: ListTile(
// //                         title: const Text("Today's Expenses"),
// //                         subtitle: Text("Date: ${DateFormat.yMMMd().format(today)}"),
// //                         trailing: Column(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Text(
// //                               "Rs. ${todayTotal.toStringAsFixed(2)}",
// //                               style: TextStyle(
// //                                 color: Colors.red.shade700,
// //                                 fontSize: 20,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                             if (todayTotal > 100)
// //                               const Text("Over Budget",
// //                                   style: TextStyle(fontSize: 12, color: Colors.redAccent)),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //
// //                     const SizedBox(height: 12),
// //
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: ElevatedButton.icon(
// //                         style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
// //                         icon: const Icon(Icons.add),
// //                         label: const Text("Add New Expense"),
// //                         onPressed: () => _showAddContainerDialog(context),
// //                       ),
// //                     ),
// //
// //                     const SizedBox(height: 20),
// //
// //                     const Text("Today's Transactions",
// //                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //                     const SizedBox(height: 8),
// //
// //                     if (todayExpenses.isEmpty)
// //                       const Center(child: Text("No transactions yet."))
// //                     else
// //                       ...todayExpenses.reversed.map((tx) {
// //                         return Card(
// //                           margin: const EdgeInsets.symmetric(vertical: 6),
// //                           child: ListTile(
// //                             leading: CircleAvatar(
// //                               backgroundColor: Colors.grey.shade100,
// //                               child: Icon(Icons.category, color: Colors.grey.shade600),
// //                             ),
// //                             title: Text(tx.notes ?? tx.type),
// //                             subtitle: Text(
// //                                 "${tx.type.toUpperCase()} • ${TimeOfDay.fromDateTime(tx.date).format(context)}"),
// //                             trailing: Text(
// //                               "- Rs. ${tx.amount.toStringAsFixed(2)}",
// //                               style: const TextStyle(
// //                                 color: Colors.red,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ),
// //                         );
// //                       }),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _showAddContainerDialog(BuildContext context) {
// //     final nameController = TextEditingController();
// //     final balanceController = TextEditingController();
// //
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text("Add Balance Container"),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               controller: nameController,
// //               decoration: const InputDecoration(labelText: "Name"),
// //             ),
// //             TextField(
// //               controller: balanceController,
// //               decoration: const InputDecoration(labelText: "Initial Balance"),
// //               keyboardType: TextInputType.number,
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               final name = nameController.text;
// //               final balance = double.tryParse(balanceController.text) ?? 0;
// //               Provider.of<ExpenseTrackerViewModel>(context, listen: false)
// //                   .addContainer(name, balance);
// //               Navigator.pop(context);
// //             },
// //             child: const Text("Add"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/expense_viewModel.dart';
// import '../../viewmodels/journel_viewModel.dart';
// import '../../widgets/journal_card_widget.dart';
// import 'addEntry.dart';
// import 'journal_detail_screen.dart';
// import 'expense_tab.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<JournalViewModel>(context, listen: false).init();
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'JOURNEX',
//           style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Row(
//               children: const [
//                 Icon(Icons.filter_alt),
//                 SizedBox(width: 16),
//                 Icon(Icons.settings),
//               ],
//             ),
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Journal'),
//             Tab(text: 'Expense'),
//           ],
//         ),
//       ),
//
//       floatingActionButton: AnimatedBuilder(
//         animation: _tabController,
//         builder: (context, child) {
//           return _tabController.index == 0
//               ? FloatingActionButton(
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const AddEntryScreen(),
//                 ),
//               );
//             },
//             backgroundColor: Colors.green,
//             child: const Icon(Icons.add, color: Colors.white, size: 28),
//           )
//               : const SizedBox.shrink();
//         },
//       ),
//
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Journal Tab (keeping your existing code)
//           Consumer<JournalViewModel>(
//             builder: (context, viewModel, _) {
//               if (viewModel.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               final entries = viewModel.entries;
//
//               if (entries.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.book_outlined, size: 80, color: Colors.grey.shade400),
//                       const SizedBox(height: 16),
//                       Text("No journal entries yet.",
//                           style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
//                       const SizedBox(height: 8),
//                       Text("Tap the + button to create your first entry",
//                           style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
//                     ],
//                   ),
//                 );
//               }
//
//               return RefreshIndicator(
//                 onRefresh: () async => viewModel.loadEntries(),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.only(top: 8, bottom: 80),
//                   itemCount: entries.length,
//                   itemBuilder: (context, index) {
//                     final entry = entries[index];
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: JournalCardWidget(
//                         entry: entry,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => JournalDetailScreen(entry: entry),
//                             ),
//                           );
//                         },
//                         onEdit: () async {
//                           await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => AddEntryScreen(entryToEdit: entry),
//                             ),
//                           );
//                         },
//                         onDelete: () async {
//                           final success = await viewModel.deleteEntry(entry);
//                           if (success && mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Entry deleted successfully'),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//
//           // New Expense Tab
//           ExpenseTab(),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/filter_model.dart';
import '../../viewmodels/expense_viewModel.dart';
import '../../viewmodels/journel_viewModel.dart';
import '../../widgets/journal_card_widget.dart';
import 'addEntry.dart';
import 'filterScreen.dart';
import 'journal_detail_screen.dart';
import 'expense_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JournalViewModel>(context, listen: false).init();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openFilterScreen() async {
    final journalViewModel = Provider.of<JournalViewModel>(context, listen: false);
    final expenseViewModel = Provider.of<ExpenseTrackerViewModel>(context, listen: false);

    final currentFilter = _tabController.index == 0
        ? journalViewModel.currentFilter
        : expenseViewModel.currentFilter;

    final result = await Navigator.push<FilterModel>(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          currentFilter: currentFilter,
          activeTabIndex: _tabController.index,
        ),
      ),
    );

    if (result != null) {
      if (_tabController.index == 0) {
        journalViewModel.applyFilter(result);
      } else {
        expenseViewModel.applyFilter(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JOURNEX',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _openFilterScreen,
                  child: Stack(
                    children: [
                      Icon(Icons.filter_alt),
                      // Show indicator if filters are active
                      Consumer2<JournalViewModel, ExpenseTrackerViewModel>(
                        builder: (context, journalVM, expenseVM, _) {
                          final hasActiveFilters = _tabController.index == 0
                              ? journalVM.hasActiveFilters
                              : expenseVM.hasActiveFilters;

                          if (hasActiveFilters) {
                            return Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Journal'),
            Tab(text: 'Expense'),
          ],
        ),
      ),

      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          return _tabController.index == 0
              ? FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEntryScreen(),
                ),
              );
            },
            backgroundColor: Colors.green,
            shape: const CircleBorder(),
            child:  Icon(Icons.add, color: Colors.white, size: 28),
          )
              : const SizedBox.shrink();
        },
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          // Journal Tab
          Consumer<JournalViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final entries = viewModel.entries;

              return Column(
                children: [
                  // Filter status bar
                  if (viewModel.hasActiveFilters)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.blue.shade50,
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt, size: 16, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Showing ${viewModel.filteredEntriesCount} of ${viewModel.entriesCount} entries',
                            style: TextStyle(color: Colors.blue.shade700),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () => viewModel.clearFilters(),
                            child: Text('Clear'),
                          ),
                        ],
                      ),
                    ),

                  // Entries list
                  Expanded(
                    child: entries.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined, size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                              viewModel.hasActiveFilters
                                  ? "No entries match your filters."
                                  : "No journal entries yet.",
                              style: TextStyle(fontSize: 18, color: Colors.grey.shade600)
                          ),
                          const SizedBox(height: 8),
                          Text(
                              viewModel.hasActiveFilters
                                  ? "Try adjusting your filter criteria"
                                  : "Tap the + button to create your first entry",
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)
                          ),
                        ],
                      ),
                    )
                        : RefreshIndicator(
                      onRefresh: () async => viewModel.loadEntries(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 80),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: JournalCardWidget(
                              entry: entry,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JournalDetailScreen(entry: entry),
                                  ),
                                );
                              },
                              onEdit: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddEntryScreen(entryToEdit: entry),
                                  ),
                                );
                              },
                              onDelete: () async {
                                final success = await viewModel.deleteEntry(entry);
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Entry deleted successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Expense Tab with filter support
          ExpenseTab(),
        ],
      ),
    );
  }
}
