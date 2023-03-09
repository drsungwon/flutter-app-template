// Used Widgets
//
// https://api.flutter.dev/flutter/material/Scaffold-class.html
// https://flutter.dev/docs/catalog/samples/basic-app-bar
// https://api.flutter.dev/flutter/widgets/Text-class.html
// https://api.flutter.dev/flutter/material/SliverAppBar-class.html
// https://androidmonks.com/sliverappbar-flutter/
// https://api.flutter.dev/flutter/painting/TextStyle-class.html
// https://api.flutter.dev/flutter/material/ListTile-class.html
// https://api.flutter.dev/flutter/material/Drawer-class.html
// https://here4you.tistory.com/176 for AlertDialog
// https://api.flutter.dev/flutter/widgets/PageController-class.html
// https://api.flutter.dev/flutter/material/OutlineButton-class.html
// https://fluttermaster.com/working-with-flutter-raisedbutton/
// https://here4you.tistory.com/154 for SnackBar [[ it is in error condition ]]
// https://api.flutter.dev/flutter/material/Icons-class.html
// https://here4you.tistory.com/154 for "key: scaffoldKey" registration in Scaffold

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _count = 0;
  Choice _selectedChoice = choices[0]; // The app's "state".
  int _selectedIndex = 0;

  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Cloud',
      style: optionStyle,
    ),
    Text(
      'Index 2: Star',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      debugPrint("_onItemTapped : $index");

      if ((_pageController.hasClients) && (index == 0)) {
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Demo'),
          content: const Text("Select button you want"),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      }, // builder
    ); // showDialog
    if (scaffoldMessengerKey.currentState == null) return;
    scaffoldMessengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text("Result: $result"),
          backgroundColor: Colors.blueAccent,
          action: SnackBarAction(
            label: "Done",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
  } // showAlertDialog

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldMessengerKey,
        // PageViews
        body: PageView(
          controller: _pageController,
          children: [
            // PageView #0 : Initial Title
            Container(
              color: Colors.white,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  foregroundColor: Colors.blueAccent,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                child: const Text(
                  'PageView #0\n\nMain Title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      textBaseline: TextBaseline.alphabetic),
                ),
                onPressed: () {
                  if (_pageController.hasClients) {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 10),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            // PageView #1 : Main
            Container(
              color: Colors.white,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    title: const Text("PageView #1 - Main"),
                    backgroundColor: Colors.blueAccent,
                    pinned: true,
                    actions: <Widget>[
                      // action button
                      IconButton(
                        icon: Icon(choices[0].icon),
                        onPressed: () {
                          showAlertDialog(context);
                          _select(choices[0]);
                        },
                      ),
                      // action button
                      IconButton(
                        icon: Icon(choices[1].icon),
                        onPressed: () {
                          _select(choices[1]);
                        },
                      ),
                      // overflow menu
                      PopupMenuButton<Choice>(
                        onSelected: _select,
                        itemBuilder: (BuildContext context) {
                          return choices.skip(2).map((Choice choice) {
                            return PopupMenuItem<Choice>(
                              value: choice,
                              child: Text(choice.title),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                  SliverAppBar(
                    backgroundColor: Colors.blueAccent,
                    floating: true,
                    expandedHeight: 70.0,
                    flexibleSpace: ListView(
                      children: const <Widget>[
                        Text(
                          '  Sub-title 0',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          '  Sub-title 1',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text.rich(
                          TextSpan(
                            text: '  ', // default text style
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Sub-title ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic)),
                              TextSpan(
                                  text: 'with Span-mode',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => Card(
                            child: ListTile(
                                leading: const FlutterLogo(),
                                title: Text(
                                    '[Item #$index] Button pressed $_count times.'),
                                trailing: const Icon(Icons.more_vert),
                                subtitle: Text(_selectedChoice.title),
                                onTap: () => setState(() {
                                      if (_pageController.hasClients) {
                                        _pageController.animateToPage(
                                          (index + 2),
                                          duration:
                                              const Duration(milliseconds: 10),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                      _count++;
                                    }))),
                        childCount: 10),
                  ),
                ],
              ),
            ),
            // PageView #2 : Sub
            Scaffold(
              appBar: AppBar(
                title: const Text('PageView #2 - Sub-Menu 1'),
                backgroundColor: Colors.blueAccent,
              ),
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.wb_cloudy),
                    label: 'Cloud',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.star),
                    label: 'Star',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                onTap: _onItemTapped,
              ),
            ),
            // PageView #3 : Sub
            Container(
              color: Colors.blueAccent,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 10),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: const Text(
                    'PageView #3 - Sub-Menu 2',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Rotate Left', icon: Icons.rotate_left),
  Choice(title: 'Rotate Right', icon: Icons.rotate_right),
  Choice(title: 'Dissatisfied', icon: Icons.sentiment_dissatisfied),
  Choice(title: 'Neutral', icon: Icons.sentiment_neutral),
  Choice(title: 'Satisfied', icon: Icons.sentiment_satisfied),
  Choice(title: 'Very Satisfied', icon: Icons.sentiment_very_satisfied),
];
