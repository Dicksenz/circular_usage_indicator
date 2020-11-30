import 'package:circular_usage_indicator/circular_usage_indicator.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  double value = 0.0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF023A5C),
      ),
      body: Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              CircularUsageIndicator(
                elevation: 15.0,
                backgroundColor: Color(0xFFD4DFE5),
                borderColor: Colors.transparent,
                progressValue: value, // progress value from 0.0 to 1.0
                progressLabelStyle: TextStyle(
                  // change style for percentage text.
                  fontSize: 60.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                progressColor: Color(0xFF023A5C),
                size: 300,
                borderWidth: 1.0,
                // comment children if you the percentage to show up as a label
                children: [
                  // if there are children widgets then the percentage label will not show up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '2125',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                        ),
                      ),
                      Text(
                        'MB',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Data Remaining',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),

              // For testing purpose i have created two buttons to increment and decrement the value for simulation.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        value = value - 0.1;
                      });
                    },
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        value = value + 0.1;
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
