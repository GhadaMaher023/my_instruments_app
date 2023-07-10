import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterMidi flutterMidi = FlutterMidi();
  String path = 'assets/Yamaha-Grand-Lite-SF-v1.1.sf2';
  Uri ? link;

  @override
  void initState() {
    load(path);
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    //flutterMidi.prepare(sf2: _byte);
    flutterMidi.prepare(sf2: _byte, name: path.replaceAll('assets/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[700],
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: path,
                  onChanged: (String? value) {
                    setState(() {
                      if (value != null) {
                        path = value;
                        load(value);
                      }
                    });
                  },
                  dropdownColor: Colors.blue[700],
                  items: const [
                    DropdownMenuItem(
                      value: 'assets/Yamaha-Grand-Lite-SF-v1.1.sf2',
                      child: Text('Piano',style: TextStyle(color: Colors.white),),
                    ),
                    DropdownMenuItem(
                      value: 'assets/Best of Guitars-4U-v1.0.sf2',
                      child: Text('Guitar',style: TextStyle(color: Colors.white),),
                    ),
                    DropdownMenuItem(
                      value: 'assets/Expressive Flute SSO-v1.2.sf2',
                      child: Text('Flute',style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed:(){
                    link = Uri.parse('tel:+970595190932');
                    launchUrl(link!);
                  },
                  icon: const Icon(Icons.call),
                ),
                IconButton(
                  onPressed:(){
                    link = Uri.parse('sms:0595190932');
                    launchUrl(link!);
                  },
                  icon: const Icon(Icons.sms),
                ),
                IconButton(
                  onPressed:(){
                    link = Uri.parse('mailto:ghadamaher023@gmail.com');
                    launchUrl(link!);
                  },
                  icon: const Icon(Icons.email),
                ),
                IconButton(
                  onPressed:(){
                    link = Uri.parse('https://www.facebook.com');
                    launchUrl(link!, mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.info_outline),
                ),
              ],
              title: const Text('PIANO'),
              leadingWidth: 90,

            ),
            body: Scaffold(
                body: Center(
                  child: InteractivePiano(
                    highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
                    naturalColor: Colors.white,
                    accidentalColor: Colors.black,
                    keyWidth: 60,
                    noteRange: NoteRange.forClefs([
                      Clef.Treble,
                    ]),
                    onNotePositionTapped: (position) {
                      print(position.pitch);
                      flutterMidi.playMidiNote(midi: position.pitch);
                      // Use an audio library like flutter_midi to play the sound
                    },
                  ),
                )
            )
        )
    );
  }
}
