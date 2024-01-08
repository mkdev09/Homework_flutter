// import 'package:flutter/material.dart';
// import 'package:flutter_bcsp7b/pages/edit_entry.dart';
// import 'package:flutter_bcsp7b/database/database.dart';
// import 'package:intl/intl.dart';

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   late Database _database;

//   @override
//   void initState() {
//     super.initState();
//     _loadJournals();
//   }

//   Future<void> _loadJournals() async {
//     final journalsJson = await DatabaseFileRoutines().readJournals();
//     setState(() {
//       _database = databaseFromJson(journalsJson);
//       _database.journal.sort((comp1, comp2) => comp2.date!.compareTo(comp1.date!));
//     });
//   }

//   void _addOrEditJournal(
//       {required bool add, required int index, required Journal journal}) async {
//     JournalEdit _journalEdit = JournalEdit(action: '', journal: journal);
//     _journalEdit = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditEntry(
//           add: add,
//           index: index,
//           journalEdit: _journalEdit,
//         ),
//         fullscreenDialog: true,
//       ),
//     );
//     switch (_journalEdit.action) {
//       case 'Save':
//         if (add) {
//           setState(() {
//             Journal newJournal = _journalEdit.journal!.copyWith(id: UniqueKey().toString());
//             _database.journal.add(newJournal);
//           });
//         } else {
//           setState(() {
//             Journal updatedJournal = _journalEdit.journal!.copyWith();
//             _database.journal[index] = updatedJournal;
//           });
//         }
//         DatabaseFileRoutines().writeJournals(databaseToJson(_database));
//         break;
//       case 'Cancel':
//         break;
//       default:
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your App Title'),
//       ),
//       body: FutureBuilder(
//         future: _loadJournals(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             return _buildListViewSeparated(snapshot);
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _addOrEditJournal(add: true, index: 0, journal: Journal());
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
//     return ListView.separated(
//       itemCount: snapshot.data.length,
//       itemBuilder: (BuildContext context, int index) {
//         String _titleDate = DateFormat.yMMMd()
//             .format(DateTime.parse(snapshot.data[index].date));
//         String _subtitle =
//             snapshot.data[index].mood + "\n" + snapshot.data[index].note;
//         return Dismissible(
//           key: Key(snapshot.data[index].id),
//           background: Container(
//             color: Colors.red,
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.only(left: 16.0),
//             child: Icon(
//               Icons.delete,
//               color: Colors.white,
//             ),
//           ),
//           secondaryBackground: Container(
//             color: Colors.red,
//             alignment: Alignment.centerRight,
//             padding: EdgeInsets.only(right: 16.0),
//             child: Icon(
//               Icons.delete,
//               color: Colors.white,
//             ),
//           ),
//           child: ListTile(
//             leading: Column(
//               children: <Widget>[
//                 Text(
//                   DateFormat.d()
//                       .format(DateTime.parse(snapshot.data[index].date)),
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 32.0,
//                       color: Colors.blue),
//                 ),
//                 Text(DateFormat.E()
//                     .format(DateTime.parse(snapshot.data[index].date))),
//               ],
//             ),
//             title: Text(
//               _titleDate,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(_subtitle),
//             onTap: () {
//               _addOrEditJournal(
//                 add: false,
//                 index: index,
//                 journal: snapshot.data[index],
//               );
//             },
//           ),
//           onDismissed: (direction) {
//             setState(() {
//               _database.journal.removeAt(index);
//             });
//             DatabaseFileRoutines().writeJournals(databaseToJson(_database));
//           },
//         );
//       },
//       separatorBuilder: (BuildContext context, int index) {
//         return Divider(
//           color: Colors.grey,
//         );
//       },
//     );
//   }
// }





// // class Journal {
// //   // Placeholder class for Journal
// // }

// // class Home extends StatefulWidget {
// //   @override
// //   _HomeState createState() => _HomeState();
// // }

// // class _HomeState extends State<Home> {

  
// //   Future<List<Journal>> _loadJournals() async {
// //     // Replace this with your actual implementation to load journals
// //     await Future.delayed(Duration(seconds: 2)); // Simulating a delay
// //     return List<Journal>.empty(growable: true);
// //   }

// //   Widget _buildListViewSeparated(AsyncSnapshot<List<Journal>> snapshot) {
// //     // Replace this with your implementation to build the ListView
// //     // You can use snapshot.data to access the list of journals
// //     return ListView.separated(
// //       itemBuilder: (context, index) {
// //         // Build your list item here using snapshot.data[index]
// //         return ListTile(
// //           title: Text('Journal ${index + 1}'),
// //           // Other properties...
// //         );
// //       },
// //       separatorBuilder: (context, index) => Divider(),
// //       itemCount: snapshot.data!.length,
// //     );
// //   }

// //   void _addOrEditJournal({required bool add, required int index, required Journal journal}) {
// //     // Replace this with your implementation for adding/editing a journal entry
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Home'),
// //       ),
// //       body: FutureBuilder<List<Journal>>(
// //         initialData: [],
// //         future: _loadJournals(),
// //         builder: (BuildContext context, AsyncSnapshot<List<Journal>> snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else {
// //             return _buildListViewSeparated(snapshot);
// //           }
// //         },
// //       ),
// //       bottomNavigationBar: BottomAppBar(
// //         shape: CircularNotchedRectangle(),
// //         child: Padding(padding: const EdgeInsets.all(24.0)),
// //       ),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// //       floatingActionButton: FloatingActionButton(
// //         tooltip: 'Add Journal Entry',
// //         child: Icon(Icons.add),
// //         onPressed: () {
// //           _addOrEditJournal(add: true, index: -1, journal: Journal());
// //         },
// //       ),
// //     );
// //   }
// // }
