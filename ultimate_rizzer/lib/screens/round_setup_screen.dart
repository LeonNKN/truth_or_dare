import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class RoundSetupScreen extends StatefulWidget {
  const RoundSetupScreen({super.key});

  @override
  State<RoundSetupScreen> createState() => _RoundSetupScreenState();
}

class _RoundSetupScreenState extends State<RoundSetupScreen> {
  int rounds = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How Many Rounds?'),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🔥'),
                    const SizedBox(width: 8),
                    Text(
                      '$rounds Rounds',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Slider(
                  value: rounds.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: rounds.toString(),
                  onChanged: (value) {
                    setState(() {
                      rounds = value.round();
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'More rounds = more rizz!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    final gameProvider =
                        Provider.of<GameProvider>(context, listen: false);
                    gameProvider.initializeGame(gameProvider.players, rounds);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Start Game'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
