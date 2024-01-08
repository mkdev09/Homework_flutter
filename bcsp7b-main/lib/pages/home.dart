import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_bcsp7b/blocs/authentication_bloc.dart';
import 'package:flutter_bcsp7b/blocs/authentication_bloc_provider.dart';
import 'package:flutter_bcsp7b/blocs/home_bloc.dart';
import 'package:flutter_bcsp7b/blocs/home_bloc_provider.dart';
import 'package:flutter_bcsp7b/blocs/journal_edit_bloc.dart';
import 'package:flutter_bcsp7b/blocs/journal_edit_bloc_provider.dart';
import 'package:flutter_bcsp7b/classes/format_dates.dart';
import 'package:flutter_bcsp7b/classes/mood_icons.dart';
import 'package:flutter_bcsp7b/models/journal.dart';
import 'package:flutter_bcsp7b/pages/edit_entry.dart';
import 'package:flutter_bcsp7b/services/db_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AuthenticationBloc _authenticationBloc;
  late HomeBloc _homeBloc;
  late String _uid;
  MoodIcons _moodIcons = MoodIcons(
    title: 'Very Satisfied',
    color: Colors.amber,
    rotation: 0.4,
    icon: Icons.sentiment_very_satisfied,
  );
  FormatDates _formatDates = FormatDates();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  // Add or Edit Journal Entry and call the Show Entry Dialog
  void _addOrEditJournal({required bool add, required Journal journal}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => JournalEditBlocProvider(
          key: Key('your_key_value'), // Provide a key value here
          journalEditBloc: JournalEditBloc(add, journal, DbFirestoreService()),
          add: not(null),
          journal: not(null),
          child: EditEntry(),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  // Confirm Deleting a Journal Entry
  Future<bool> _confirmDeleteJournal() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Journal"),
          content: Text("Are you sure you would like to Delete?"),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Journal',
          style: TextStyle(color: Colors.lightGreen.shade800),
        ),
        elevation: 0.0,
        bottom: PreferredSize(
            child: Container(), preferredSize: Size.fromHeight(32.0)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.lightGreen.shade800,
            ),
            onPressed: () {
              _authenticationBloc.logoutUser.add(true);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _homeBloc.listJournal,
        builder: ((BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return _buildListViewSeparated(snapshot);
          } else {
            return Center(
              child: Container(
                child: Text('Add Journals.'),
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Container(
          height: 44.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen.shade50, Colors.lightGreen],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Journal Entry',
        backgroundColor: Colors.lightGreen.shade300,
        child: Icon(Icons.add),
        onPressed: () async {
          _addOrEditJournal(add: true, journal: Journal(uid: _uid, documentID: '', date: '', mood: '', note: ''));
        },
      ),
    );
  }

  // Build the ListView with Separator
  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _titleDate =
            _formatDates.dateFormatShortMonthDayYear(snapshot.data[index].date);
        String _subtitle =
            snapshot.data[index].mood + "\n" + snapshot.data[index].note;
        return Dismissible(
          key: Key(snapshot.data[index].documentID),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            leading: Column(
              children: <Widget>[
                Text(
                  _formatDates.dateFormatDayNumber(snapshot.data[index].date),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                      color: Colors.lightGreen),
                ),
                Text(_formatDates
                    .dateFormatShortDayName(snapshot.data[index].date)),
              ],
            ),
            trailing: Transform(
              transform: Matrix4.identity()
                ..rotateZ(
                    _moodIcons.getMoodRotation(snapshot.data[index].mood)),
              alignment: Alignment.center,
              child: Icon(
                _moodIcons.getMoodIcon(snapshot.data[index].mood),
                color: _moodIcons.getMoodColor(snapshot.data[index].mood),
                size: 42.0,
              ),
            ),
            title: Text(
              _titleDate,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_subtitle),
            onTap: () {
              _addOrEditJournal(
                add: false,
                journal: Journal(
                    documentID: snapshot.data[index].documentID,
                    date: snapshot.data[index].date,
                    mood: snapshot.data[index].mood,
                    note: snapshot.data[index].note,
                    uid: snapshot.data[index].uid),
              );
            },
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteJournal();
            if (confirmDelete) {
              _homeBloc.deleteJournal.add(snapshot.data[index]);
            }
            return null;
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bcsp7b/database/database.dart';
// import 'package:flutter_bcsp7b/pages/edit_entry.dart';
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
//         title: Text('Journal', style: TextStyle(color: Colors.lightGreen.shade800)),
//         elevation: 0.0,
//         bottom: PreferredSize(child: Container(), preferredSize: Size.fromHeight(32.0)),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.lightGreen, Colors.lightGreen.shade50],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.exit_to_app,
//               color: Colors.lightGreen.shade800,
//             ),
//             onPressed: () {
//               // TODO: Add signOut method
//             },
//           ),
//         ],
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
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _addOrEditJournal(add: true, index: 0, journal: Journal());
//         },
//         tooltip: 'Add Journal Entry',
//         backgroundColor: Colors.lightGreen.shade300,
//         child: Icon(Icons.add),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         elevation: 0.0,
//         child: Container(
//           height: 44.0,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.lightGreen.shade50, Colors.lightGreen],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
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
