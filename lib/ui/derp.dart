import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterProvider extends ChangeNotifier {
  int count = 0;
  int count1 = 0;
  int get getCount1 => count1;
  int get getCount => count;
  incrementCounter() {
    count++;
    notifyListeners();
  }

  incrementCounter1() {
    count1--;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => CounterProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: Counter()),
    );
  }
} ////////////

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    final counterProvider =
        Provider.of<CounterProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          children: <Widget>[
            Selector<CounterProvider, int>(
              builder: (context, data, child) {
                print("object");
                return Text('$data');
              },
              selector: (buildContext, countPro) => countPro.getCount,
            ),
            Selector<CounterProvider, int>(
              builder: (context, data, child) {
                print("object123");
                return Text('$data');
              },
              selector: (buildContext, counterProvider) =>
                  counterProvider.getCount1,
            )
          ],
        )),
        floatingActionButton: Row(
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                counterProvider.incrementCounter();
              },
            ),
            FloatingActionButton(
              onPressed: () {
                counterProvider.incrementCounter1();
              },
            ),
          ],
        ),
      ),
    );
  }
}/////////////
