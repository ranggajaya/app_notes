import 'package:app_note/shared/top_container.dart';
import 'package:app_note/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:app_note/db/database.dart';
import 'package:app_note/model/note.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'edit_screen.dart';
import 'detail_screen.dart';
import 'package:app_note/widget/card_widget.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage()),
          );

          refreshNotes();
        },
      ),

      //backgroundColor: Colors.grey,
      body: SafeArea(
        child: ListView(
          children: [
            TopContainer(
              height: 200,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircularPercentIndicator(
                            radius: 110.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: 0.75,
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor:
                                const Color.fromRGBO(251, 99, 64, 1.0),
                            backgroundColor:
                                const Color.fromRGBO(68, 181, 255, 1.0),
                            center: const CircleAvatar(
                              backgroundColor: Color.fromRGBO(82, 95, 127, 1.0),
                              radius: 45.0,
                              backgroundImage: AssetImage(
                                'assets/image/avatar1.png',
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // ignore: avoid_unnecessary_containers
                              Container(
                                child: const Text(
                                  'Monkey D. Luffy',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 26.0,
                                    color: Color.fromRGBO(247, 250, 252, 1.0),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const Text(
                                'Aku akan menjadi seorang \nRaja Bajak Laut',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
            Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Center(
                  child: subheading('My Notes'),
                )),
            Container(
              child: isLoading
                  ? CircularProgressIndicator()
                  : notes.isEmpty
                      ? Text(
                          'Empty',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )
                      : buildNotes(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotes() => Container(
        padding: EdgeInsets.all(5),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          itemCount: notes.length,
          staggeredTileBuilder: (index) => StaggeredTile.fit(2),
          itemBuilder: (context, index) {
            final note = notes[index];

            return GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ));

                refreshNotes();
              },
              child: NoteCardWidget(note: note, index: index),
            );
          },
        ),
      );
  // =>
  // Scaffold(
  //   appBar: AppBar(
  //     title: Text(
  //       'Notes',
  //       style: TextStyle(fontSize: 24),
  //     ),
  //     actions: [Icon(Icons.search), SizedBox(width: 12)],
  //   ),
  //   body: Center(
  //     child: isLoading
  //         ? CircularProgressIndicator()
  //         : notes.isEmpty
  //             ? Center(
  //                 child: Text(
  //                   'Empty',
  //                   style: TextStyle(color: Colors.white, fontSize: 24),
  //                 ),
  //               )
  //             : buildNotes(),
  //   ),
  //   floatingActionButton: FloatingActionButton(
  //     backgroundColor: Colors.black,
  //     child: Icon(Icons.add),
  //     onPressed: () async {
  //       await Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => AddEditNotePage()),
  //       );

  //       refreshNotes();
  //     },
  //   ),
  // );

}
