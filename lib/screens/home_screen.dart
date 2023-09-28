import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const sixtySeconds = 60;
  final String title = "PomoTimer";
  final int roundUnits = 4;

  int _minutesDefined = 25;
  int totalSeconds = 0;
  int totalPomodoros = 0;
  int subPomodoros = 0;

  bool isRunning = false;
  bool isEnable = true;
  late Timer timer;

  @override
  void initState() {
    totalSeconds = _minutesDefined * sixtySeconds;
    super.initState();
  }

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        subPomodoros++;
        if (subPomodoros == roundUnits) {
          totalPomodoros = totalPomodoros + 1;
          subPomodoros = 0;
          _reEnable();
        }
        isRunning = false;
        totalSeconds = _minutesDefined * sixtySeconds;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    if (!isEnable) return;

    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed() {
    setState(() {
      totalSeconds = _minutesDefined * sixtySeconds;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCountdownSquare(1),
                      for (int i = 15; i <= 35; i += 5)
                        _buildCountdownSquare(i),
                    ],
                  ),
                ),
                isEnable
                    ? IconButton(
                        iconSize: 120,
                        color: Theme.of(context).cardColor,
                        onPressed: isRunning ? onPausePressed : onStartPressed,
                        icon: Icon(isRunning
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline),
                      )
                    : IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow_outlined)),
                IconButton(
                  iconSize: 30,
                  color: Theme.of(context).cardColor,
                  onPressed: onResetPressed,
                  icon: const Icon(Icons.restore),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.68),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(9),
                        bottomRight: Radius.circular(9),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ROUND',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '$subPomodoros/$roundUnits',
                              style: TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'GOAL',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '$totalPomodoros/12',
                              style: TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCountdownSquare(int number) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: number == _minutesDefined
            ? const Color.fromARGB(255, 238, 176, 41)
            : Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: TextButton(
          onPressed: () {
            setState(() {
              _minutesDefined = number;
              totalSeconds = _minutesDefined * sixtySeconds;
            });
          },
          child: Text(
            number.toString(),
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  void _reEnable() {
    isEnable = false;
    Timer.periodic(const Duration(seconds: 1 * sixtySeconds), (timer) {
      setState(() {
        _minutesDefined--;
      });

      if (_minutesDefined <= 0) {
        timer.cancel();
        isEnable = true;
        setState(() {});
      }
    });
  }
}
