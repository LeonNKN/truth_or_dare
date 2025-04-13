import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'round_setup_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  int playerCount = 2;
  final List<TextEditingController> _controllers = [];
  final List<String> _avatars = [
    '😎',
    '🔥',
    '🎮',
    '🌟',
    '🚀',
    '💫',
    '🎯',
    '🎪'
  ];

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  void _updateControllers() {
    while (_controllers.length < playerCount) {
      _controllers.add(TextEditingController());
    }
    while (_controllers.length > playerCount) {
      _controllers.last.dispose();
      _controllers.removeLast();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _areAllFieldsFilled() {
    return _controllers
        .every((controller) => controller.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Who's Playing?"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: playerCount > 2
                          ? () {
                              setState(() {
                                playerCount--;
                                _updateControllers();
                              });
                            }
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$playerCount Players',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: playerCount < 8
                          ? () {
                              setState(() {
                                playerCount++;
                                _updateControllers();
                              });
                            }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: playerCount,
                    itemBuilder: (context, index) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: Text(_avatars[index % _avatars.length]),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _controllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Player ${index + 1}',
                                    hintText: 'Enter player name',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .hintColor
                                          .withOpacity(0.7),
                                    ),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _areAllFieldsFilled()
                      ? () {
                          final gameProvider =
                              Provider.of<GameProvider>(context, listen: false);
                          gameProvider.setPlayers(
                            _controllers.map((c) => c.text.trim()).toList(),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoundSetupScreen(),
                            ),
                          );
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter all player names before proceeding'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
