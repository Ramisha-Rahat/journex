import 'package:flutter/material.dart';
import 'package:journex/utils/responsiveHelper/responsiveHelper.dart';
import 'package:journex/widgets/journel_card_widget.dart';

import 'addEntry.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title:  Padding(
            padding:  EdgeInsets.symmetric(horizontal: ResponsiveHelper.getWidth(context, 0.05)),
            child: Text('JOURNEX'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
              children: [
                Icon(Icons.filter_alt),
                SizedBox(width:ResponsiveHelper.getWidth(context, 0.05)),
                Icon(Icons.settings),
              ],
                        ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Journal',),
              Tab(text: 'Expense'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEntryScreen()));
          },
          child: Icon(Icons.add, color: Colors.green,size:30),
        ),

        body:  TabBarView(
          children: [
            Center(child: Column(
             children: [
               JournelCardWidget(title: 'bkhc', date: 'shhcs', description: 'sbsghewi hixshicxh hxsnxiuhei bxsjhcewi wbshciuew',
                   tags: ['work','gratitude','family'], leadingIcon: Icons.add)
             ],
            )
            ),
            Center(child: Text('This is the Expense page')),
          ],
        ),
      ),
    );

  }


//
//   void createNote() {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           content: TextField(
//             decoration: InputDecoration(
//               hintText: 'Enter your note',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//
//                 borderSide: BorderSide(
//                   color: Colors.grey,
//                   // Customize border color when not focused
//                   width: 1.0,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 borderSide: BorderSide(
//                   color: Colors.black87,
//                   // Customize border color when focused
//                   width: 2.0,
//                 ),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//             cursorColor: Colors.green, // Customize cursor color
//             controller: textController,
//           ),
//           actions: [
//             MaterialButton(
//               onPressed: () {
//                 Provider.of<NoteDatabase>(context, listen: false)
//                     .addNote(textController.text);
//                 textController.clear();
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Container(
//                     width: 100,
//                     child: Text
//                       ('Save',
//                       style: TextStyle(color: Colors.black87, fontSize: 20,),)),
//               ),
//             ),
//           ],
//         ));
//   }
//
// //delete note
//   void deleteNote(int id){
//
//     //context.read<NoteDatabase>().deleteNote(id);
//     showDialog(context: context, builder: (context)=>AlertDialog(
//       content: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Card(
//           color: Colors.black,
//           child: Container(
//             height: 100,
//             child:Column(
//               children: [
//                 Text('Are you Sure You wan to delete Your Note?',style: TextStyle(color: Colors.white, fontSize: 16,),),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center, // Distribute buttons evenly
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         context.read<NoteDatabase>().deleteNote(id);
//                         Navigator.pop(context);
//                       },
//                       child: Text('Yes'),
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.white, // Set button text color
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.pop(context), // Dismiss the dialog
//                       child: Text('Cancel'),
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.white, // Set button text color
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10), // Add rounded corners
//           ),
//           elevation: 5, // Add a slight shadow for depth
//         ),
//       ),
//     )
//
//     );
//   }
//
//   //edit note
//
//   void updateNote(Note note){
//
//     textController.text= note.text;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Edit Your Note', style: TextStyle(fontSize: 20),),
//         content:  SizedBox(
//           height: 150,
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Enter your note',
//
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//
//                 borderSide: BorderSide(
//                   color: Colors.grey,
//                   // Customize border color when not focused
//                   width: 1.0,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 borderSide: BorderSide(
//                   color: Colors.black87,
//                   // Customize border color when focused
//                   width: 2.0,
//                 ),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//             cursorColor: Colors.green, // Customize cursor color
//             controller: textController,
//             maxLines: null, // Allow unlimited lines
//             keyboardType: TextInputType.multiline,
//           ),
//         ),
//         actions: [
//           MaterialButton(
//             onPressed: () {
//               context
//                   .read<NoteDatabase>()
//                   .updateNote(note.id, textController.text);
//               textController.clear();
//               Navigator.pop(context);
//             },
//             child: Text('Update', style: TextStyle(color: Colors.black87, fontSize: 20,),),
//           ),
//         ],
//       ),
//     );
//   }

}
