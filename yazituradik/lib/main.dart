import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const HeadsOrTailsApp());

class HeadsOrTailsApp extends StatelessWidget {
  const HeadsOrTailsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yazı Tura Dik',
      theme: ThemeData(useMaterial3: true),
      home: const CoinTossScreen(),
    );
  }
}

class CoinTossScreen extends StatefulWidget {
  const CoinTossScreen({Key? key}) : super(key: key);

  @override
  _CoinTossScreenState createState() => _CoinTossScreenState();
}

class _CoinTossScreenState extends State<CoinTossScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String coinResult = '';
  String headAsset = 'assets/images/coin_head.png';
  String tailAsset = 'assets/images/coin_tail.png';
  String edgeAsset = 'assets/images/coin_edge.png';
  bool _leftMenuOpen = false;
  int randomValue1 = 50;
  int randomValue2 = 50;
  int randomValue3 = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Random random = Random();
        int randomValue = random.nextInt(100);
        if (randomValue < randomValue1) {
          setState(() {
            coinResult = 'Yazı';
          });
        } else if (randomValue < randomValue1 + randomValue2) {
          setState(() {
            coinResult = 'Tura';
          });
        } else {
          setState(() {
            coinResult = 'Dik';
          });
        }
        _animationController.reverse();
      }
    });
  }

  void tossCoin() {
    if (_animationController.isAnimating) return;
    _animationController.forward();
  }

  void openMenu() {
    setState(() {
      if (_leftMenuOpen) {
        closeMenu();
      } else {
        _leftMenuOpen = true;
      }
    });
  }

  void closeMenu() {
    setState(() {
      _leftMenuOpen = false;
    });
  }

  void navigateToSettingsPage() async {
    final Map<String, int?>? newValues = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          randomValue1: randomValue1,
          randomValue2: randomValue2,
          randomValue3: randomValue3,
        ),
      ),
    );

    if (newValues != null) {
      int? newValue1 = newValues['randomValue1'] ?? randomValue1;
      int? newValue2 = newValues['randomValue2'] ?? randomValue2;
      int? newValue3 = newValues['randomValue3'] ?? randomValue3;

      int sum = newValue1 + newValue2 + newValue3;
      if (sum == 100) {
        setState(() {
          randomValue1 = newValue1;
          randomValue2 = newValue2;
          randomValue3 = newValue3;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hata'),
            content: const Text('Toplam olasılık değeri 100 olmalıdır.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String coinAsset;
    if (coinResult == 'Yazı') {
      coinAsset = headAsset;
    } else if (coinResult == 'Tura') {
      coinAsset = tailAsset;
    } else {
      coinAsset = edgeAsset;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yazı Tura Dik',
          textAlign: TextAlign.center,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: openMenu,
            );
          },
        ),
      ),
      body: GestureDetector(
        child: Row(
          children: [
            if (_leftMenuOpen)
              Container(
                color: Colors.grey[200],
                width: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.black87,
                      child: ListTile(
                        leading: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Ayarlar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: navigateToSettingsPage,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Yazı tura atmak için tıklayın',
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: tossCoin,
                      child: RotationTransition(
                        turns: _animation,
                        child: Image.asset(
                          coinAsset,
                          width: 200.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      coinResult,
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final int randomValue1;
  final int randomValue2;
  final int randomValue3;

  const SettingsPage({
    Key? key,
    required this.randomValue1,
    required this.randomValue2,
    required this.randomValue3,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController randomValue1Controller;
  late TextEditingController randomValue2Controller;
  late TextEditingController randomValue3Controller;

  @override
  void initState() {
    super.initState();
    randomValue1Controller =
        TextEditingController(text: widget.randomValue1.toString());
    randomValue2Controller =
        TextEditingController(text: widget.randomValue2.toString());
    randomValue3Controller =
        TextEditingController(text: widget.randomValue3.toString());
  }

  @override
  void dispose() {
    randomValue1Controller.dispose();
    randomValue2Controller.dispose();
    randomValue3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Yazı olasılığı:'),
            TextField(
              controller: randomValue1Controller,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            const Text('Tura olasılığı:'),
            TextField(
              controller: randomValue2Controller,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            const Text('Dik olasılığı:'),
            TextField(
              controller: randomValue3Controller,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                int? newValue1 = int.tryParse(randomValue1Controller.text);
                int? newValue2 = int.tryParse(randomValue2Controller.text);
                int? newValue3 = int.tryParse(randomValue3Controller.text);

                if (newValue1 == null) newValue1 = 0;
                if (newValue2 == null) newValue2 = 0;
                if (newValue3 == null) newValue3 = 0;

                int sum = newValue1 + newValue2 + newValue3;
                if (sum == 100) {
                  Navigator.pop(context, {
                    'randomValue1': newValue1,
                    'randomValue2': newValue2,
                    'randomValue3': newValue3,
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hata'),
                      content:
                          const Text('Toplam olasılık değeri 100 olmalıdır.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, {
                              'randomValue1': widget.randomValue1,
                              'randomValue2': widget.randomValue2,
                              'randomValue3': widget.randomValue3,
                            });
                          },
                          child: const Text('Tamam'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
