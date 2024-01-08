import 'package:flutter/material.dart';
import 'package:flutter_bcsp7b/blocs/journal_edit_bloc.dart';
import 'package:flutter_bcsp7b/blocs/journal_edit_bloc_provider.dart';
import 'package:flutter_bcsp7b/classes/format_dates.dart';
import 'package:flutter_bcsp7b/classes/mood_icons.dart';

class EditEntry extends StatefulWidget {
  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  late JournalEditBloc _journalEditBloc;
  late FormatDates _formatDates;
  late MoodIcons _moodIcons;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDates();
    _moodIcons = MoodIcons(
      title: 'Very Satisfied',
      color: Colors.amber,
      rotation: 0.4,
      icon: Icons.sentiment_very_satisfied,
    );
    _noteController = TextEditingController();
    _noteController.text = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _journalEditBloc = JournalEditBlocProvider.of(context).journalEditBloc;
  }

  @override
  void dispose() {
    _noteController.dispose();
    _journalEditBloc.dispose();
    super.dispose();
  }

  // Date Picker
  Future<String> _selectDate(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);

    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (_pickedDate != null) {
      selectedDate = DateTime(
        _pickedDate.year,
        _pickedDate.month,
        _pickedDate.day,
        _initialDate.hour,
        _initialDate.minute,
        _initialDate.second,
        _initialDate.millisecond,
        _initialDate.microsecond,
      ).toString();
    }
    return selectedDate;
  }

  void _addOrUpdateJournal() {
    _journalEditBloc.saveJournalChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Entry',
          style: TextStyle(color: Colors.lightGreen.shade800),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: _journalEditBloc.dateEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return TextButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String _pickerDate = await _selectDate(snapshot.data);
                      _journalEditBloc.dateEditChanged.add(_pickerDate);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(0.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          size: 22.0,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          _formatDates
                              .dateFormatShortMonthDayYear(snapshot.data),
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  );
                },
              ),
              StreamBuilder(
                  stream: _journalEditBloc.moodEdit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<MoodIcons>(
                        value: _moodIcons.getMoodIconsList()[_moodIcons
                            .getMoodIconsList()
                            .indexWhere((icon) => icon.title == snapshot.data)],
                        onChanged: (selected) {
                          _journalEditBloc.moodEditChanged.add(selected!.title);
                        },
                        items: _moodIcons
                            .getMoodIconsList()
                            .map((MoodIcons selected) {
                          return DropdownMenuItem<MoodIcons>(
                            value: selected,
                            child: Row(
                              children: <Widget>[
                                Transform(
                                  transform: Matrix4.identity()
                                    ..rotateZ(_moodIcons
                                        .getMoodRotation(selected.title)),
                                  alignment: Alignment.center,
                                  child: Icon(
                                      _moodIcons.getMoodIcon(selected.title),
                                      color: _moodIcons
                                          .getMoodColor(selected.title)),
                                ),
                                SizedBox(width: 16.0),
                                Text(selected.title)
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
              StreamBuilder(
                stream: _journalEditBloc.noteEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  // Use the copyWith to make sure when you edit TextField the cursor does not bounce to the first character
                  _noteController.value =
                      _noteController.value.copyWith(text: snapshot.data);
                  return TextField(
                    controller: _noteController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      icon: Icon(Icons.subject),
                    ),
                    maxLines: null,
                    onChanged: (note) =>
                        _journalEditBloc.noteEditChanged.add(note),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      _addOrUpdateJournal();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreen.shade100,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bcsp7b/database/database.dart';
// import 'package:intl/intl.dart'; // Format Dates
// import 'dart:math'; // Random() numbers


// class EditEntry extends StatefulWidget {
//   final bool add;
//   final int index;
//   final JournalEdit journalEdit;

//   const EditEntry({
//     Key? key,
//     required this.add,
//     required this.index,
//     required this.journalEdit,
//   }) : super(key: key);

//   @override
//   _EditEntryState createState() => _EditEntryState();
// }

// class _EditEntryState extends State<EditEntry> {
//   late JournalEdit _journalEdit;
//   late String _title;
//   late DateTime _selectedDate;
//   TextEditingController _moodController = TextEditingController();
//   TextEditingController _noteController = TextEditingController();
//   FocusNode _moodFocus = FocusNode();
//   FocusNode _noteFocus = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _journalEdit =
//         JournalEdit(action: 'Cancel', journal: widget.journalEdit.journal);
//     _title = widget.add ? 'Add' : 'Edit';
//     _journalEdit.journal = widget.journalEdit.journal;

//     if (widget.add) {
//       _selectedDate = DateTime.now();
//       _moodController.text = '';
//       _noteController.text = '';
//     } else {
//       _selectedDate =
//           DateTime.tryParse(_journalEdit.journal!.date ?? '') ?? DateTime.now();
//       _moodController.text = _journalEdit.journal!.mood ?? '';
//       _noteController.text = _journalEdit.journal!.note ?? '';
//     }
//   }

//   @override
//   void dispose() {
//     _moodController.dispose();
//     _noteController.dispose();
//     _moodFocus.dispose();
//     _noteFocus.dispose();
//     super.dispose();
//   }

//   // Date Picker
//   Future<void> _selectDate() async {
//     DateTime initialDate = _selectedDate;

//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );

//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$_title Entry'),
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: <Widget>[
//               TextButton(
//                 onPressed: () async {
//                   FocusScope.of(context).requestFocus(FocusNode());
//                   await _selectDate();
//                 },
//                 child: Row(
//                   children: <Widget>[
//                     Icon(
//                       Icons.calendar_today,
//                       size: 22.0,
//                       color: Colors.black54,
//                     ),
//                     SizedBox(width: 16.0),
//                     Text(
//                       DateFormat.yMMMEd().format(_selectedDate),
//                       style: TextStyle(
//                         color: Colors.black54,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_drop_down,
//                       color: Colors.black54,
//                     ),
//                   ],
//                 ),
//               ),
//               TextField(
//                 controller: _moodController,
//                 autofocus: true,
//                 textInputAction: TextInputAction.next,
//                 focusNode: _moodFocus,
//                 textCapitalization: TextCapitalization.words,
//                 decoration: InputDecoration(
//                   labelText: 'Mood',
//                   icon: Icon(Icons.mood),
//                 ),
//                 onSubmitted: (submitted) {
//                   FocusScope.of(context).requestFocus(_noteFocus);
//                 },
//               ),
//               TextField(
//                 controller: _noteController,
//                 textInputAction: TextInputAction.newline,
//                 focusNode: _noteFocus,
//                 textCapitalization: TextCapitalization.sentences,
//                 decoration: InputDecoration(
//                   labelText: 'Note',
//                   icon: Icon(Icons.subject),
//                 ),
//                 maxLines: null,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       _journalEdit.action = 'Cancel';
//                       Navigator.pop(context, _journalEdit);
//                     },
//                     child: Text('Cancel'),
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.grey.shade100,
//                     ),
//                   ),
//                   SizedBox(width: 8.0),
//                   TextButton(
//                     onPressed: () {
//                       _journalEdit.action = 'Save';
//                       String id = widget.add
//                           ? Random().nextInt(9999999).toString()
//                           : _journalEdit.journal!.id!;
//                       _journalEdit.journal = Journal(
//                         id: id,
//                         date: _selectedDate.toIso8601String(),
//                         mood: _moodController.text,
//                         note: _noteController.text,
//                       );
//                       Navigator.pop(context, _journalEdit);
//                     },
//                     child: Text('Save'),
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.lightGreen.shade100,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
