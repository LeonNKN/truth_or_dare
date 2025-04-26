import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../providers/game_provider.dart';
import '../services/bgm_service.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();

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
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playCardSound() async {
    await _audioPlayer.play(AssetSource('sounds/card_flip.mp3'));
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
                  BgmService().stop(); // Stop background music
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
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.5,
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
                                        _playCardSound();
                                      }
                                    : null,
                                    
                                child: isFrontVisible
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          image: DecorationImage(
                                            image: AssetImage('assets/design/card_design.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(24.0),
                                        child: const SizedBox.shrink(), // Empty container for front side
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2.0,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(24.0),
                                        child: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()..rotateY(3.14159),
                                          child: Column(
                                            children: [
                                              if (gameProvider.currentCard != null) ...[
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: _getCategoryColor(context, gameProvider.currentCard!.category).withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: _getCategoryColor(context, gameProvider.currentCard!.category),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    gameProvider.currentCard!.category.toUpperCase(),
                                                    style: TextStyle(
                                                      color: _getCategoryColor(context, gameProvider.currentCard!.category),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      fontFamily: 'Poppins',
                                                      letterSpacing: 1.2,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      gameProvider.currentCard!.text,
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Quicksand',
                                                        height: 1.3,
                                                        letterSpacing: 0.5,
                                                        color: Theme.of(context).textTheme.headlineSmall?.color,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                Center(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      gameProvider.nextTurn();
                                                      if (gameProvider.isVotingPhase) {
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const VotingScreen(),
                                                          ),
                                                        );
                                                      }
                                                      _controller.reverse();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                      minimumSize: const Size(150, 48),
                                                      textStyle: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    ),
                                                    child: const Text('Next Player'),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
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
                          _playCardSound();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1.0,
                          ),
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
  
  // Helper method to get color based on category
  Color _getCategoryColor(BuildContext context, String category) {
    switch (category.toLowerCase()) {
      case 'intimate':
        return Colors.pinkAccent;
      case 'flirty':
        return Colors.redAccent;
      case 'funny':
        return Colors.orangeAccent;
      case 'bold':
        return Colors.purpleAccent;
      case 'creative':
        return Colors.blueAccent;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }
}
