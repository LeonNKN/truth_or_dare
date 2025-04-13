import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'voting_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Round ${gameProvider.currentRound}/${gameProvider.totalRounds}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  gameProvider.resetGame();
                  Navigator.pop(context);
                },
              ),
            ],
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "It's ${gameProvider.currentPlayer}'s turn!",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final rotationValue = _flipAnimation.value * 3.14159;
                          final isFrontVisible = _flipAnimation.value < 0.5;

                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(rotationValue),
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                onTap: gameProvider.currentCard == null
                                    ? () {
                                        gameProvider.drawCard();
                                        _controller.forward(from: 0.0);
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isFrontVisible) ...[
                                        // Front of card (before flip)
                                        const Icon(
                                          Icons.auto_awesome,
                                          size: 64,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          'Tap to Draw a Rizz Card',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Tap here or the button below',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                      ] else ...[
                                        // Back of card (after flip)
                                        Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..rotateY(
                                                3.14159), // Flip back text to be readable
                                          child: Column(
                                            children: [
                                              if (gameProvider.currentCard !=
                                                  null) ...[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    gameProvider
                                                        .currentCard!.category,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                Text(
                                                  gameProvider
                                                      .currentCard!.text,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall,
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 24),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    gameProvider.nextTurn();
                                                    if (gameProvider
                                                        .isVotingPhase) {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const VotingScreen(),
                                                        ),
                                                      );
                                                    }
                                                    _controller.reverse();
                                                  },
                                                  child:
                                                      const Text('Next Player'),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (gameProvider.currentCard == null)
                      ElevatedButton(
                        onPressed: () {
                          gameProvider.drawCard();
                          _controller.forward(from: 0.0);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Draw Card'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
