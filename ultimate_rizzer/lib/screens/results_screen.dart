import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'player_setup_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
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
        final winners = gameProvider.getWinners();
        final isTie = gameProvider.isTie();
        
        // Sort scores in descending order
        final sortedScores = gameProvider.scores.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                    // Winner announcement with animation
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.5),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: FadeTransition(
                        opacity: _animation,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                isTie ? 'It\'s a Tie!' : 'The Ultimate Rizzer is...',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              if (isTie)
                                Column(
                                  children: winners
                                      .map((winner) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Text(
                                              winner,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ))
                                      .toList(),
                                )
                              else
                                Text(
                                  winners.first,
                                  style:
                                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                  textAlign: TextAlign.center,
                                ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('👑', style: TextStyle(fontSize: 32)),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.emoji_events,
                                    size: 40,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 8),
                                  Text('👑', style: TextStyle(fontSize: 32)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Leaderboard title
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.5, end: 1.0)
                          .animate(CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.3, 0.6, curve: Curves.elasticOut),
                      )),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.leaderboard, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Final Leaderboard',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Leaderboard
                    Expanded(
                      child: ListView.builder(
                        itemCount: sortedScores.length,
                        itemBuilder: (context, index) {
                          final entry = sortedScores[index];
                          final player = entry.key;
                          final score = entry.value;
                          final isWinner = winners.contains(player);
                          
                          // Staggered animation for list items
                          return FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _controller,
                                curve: Interval(
                                  0.4 + (index * 0.1).clamp(0.0, 0.5),
                                  0.7 + (index * 0.1).clamp(0.0, 0.5),
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.5, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: Interval(
                                    0.4 + (index * 0.1).clamp(0.0, 0.5),
                                    0.7 + (index * 0.1).clamp(0.0, 0.5),
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: isWinner
                                      ? Colors.amber.withOpacity(0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: isWinner
                                      ? Border.all(color: Colors.amber, width: 2)
                                      : null,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // Position indicator
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: _getPositionColor(index),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      
                                      // Player name
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              player,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (isWinner)
                                              Text(
                                                'Ultimate Rizzer',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Score with badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '$score',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Trophy for winners
                                      if (isWinner) ...[
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.emoji_events,
                                          color: Colors.amber,
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
                    
                    const SizedBox(height: 24),
                    
                    // Play again button
                    ElevatedButton(
                      onPressed: () {
                        gameProvider.resetGame();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlayerSetupScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Play Again',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
  
  Color _getPositionColor(int position) {
    switch (position) {
      case 0:
        return Colors.amber.shade700; // Gold
      case 1:
        return Colors.blueGrey.shade400; // Silver
      case 2:
        return Colors.brown.shade400; // Bronze
      default:
        return Colors.grey.shade500; // Other positions
    }
  }
}
