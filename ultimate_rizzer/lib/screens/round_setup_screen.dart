import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';
import '../services/bgm_service.dart';

class RoundSetupScreen extends StatefulWidget {
  const RoundSetupScreen({super.key});

  @override
  State<RoundSetupScreen> createState() => _RoundSetupScreenState();
}

class _RoundSetupScreenState extends State<RoundSetupScreen> with SingleTickerProviderStateMixin {
  int rounds = 3;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Removed: Header with animated title (FadeTransition, SlideTransition, and Container)
                const SizedBox(height: 40),
                
                // Round selection card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Moved here: "Set Your Rizz Level" text
                        Text(
                          "Set Your Rizz Level",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Removed: const SizedBox(height: 16),
                        // Show only the relevant character image based on rounds
                        if (rounds <= 3)
                          Image.asset(
                            'assets/selection_page/casual_round_character.png',
                            width: 300,
                            height: 300,
                          )
                        else if (rounds <= 7)
                          Image.asset(
                            'assets/selection_page/balanced_round_character.png',
                            width: 300,
                            height: 300,
                          )
                        else
                          Image.asset(
                            'assets/selection_page/ultimate_round_character.png',
                            width: 300,
                            height: 300,
                          ),
                        
                        const SizedBox(height: 24),

                        // Round number display
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '$rounds Rounds',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // Removed: const SizedBox(height: 40),
                        
                        // Custom slider with better visual feedback
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Casual',
                                    style: TextStyle(
                                      fontSize: 16, // Smaller text size
                                      fontWeight: rounds <= 3 ? FontWeight.bold : FontWeight.normal,
                                      color: rounds <= 3
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Balance',
                                    style: TextStyle(
                                      fontSize: 16, // Smaller text size
                                      fontWeight: (rounds > 3 && rounds <= 7) ? FontWeight.bold : FontWeight.normal,
                                      color: (rounds > 3 && rounds <= 7)
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Ultimate',
                                    style: TextStyle(
                                      fontSize: 16, // Smaller text size
                                      fontWeight: rounds > 7 ? FontWeight.bold : FontWeight.normal,
                                      color: rounds > 7
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Theme.of(context).colorScheme.primary,
                                inactiveTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                thumbColor: Theme.of(context).colorScheme.secondary,
                                overlayColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                                trackHeight: 8,
                              ),
                              child: Slider(
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
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Rizz level indicator
                        Text(
                          getRizzLevelText(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          getRizzLevelDescription(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Start game button
                ElevatedButton(
                  onPressed: () async {
                    await BgmService().play(); // Start background music
                    final gameProvider = Provider.of<GameProvider>(context, listen: false);
                    gameProvider.initializeGame(gameProvider.players, rounds);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameScreen(),
                      ),
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
                    // Removed duplicate padding parameter
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    getStartButtonText(),
                    style: const TextStyle(
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
  }
  
  String getRizzLevelText() {
    if (rounds <= 3) return "Casual Rizz";
    if (rounds <= 7) return "Serious Rizz";
    return "Ultimate Rizz Master";
  }
  
  String getRizzLevelDescription() {
    if (rounds <= 3) {
      return "A quick game to test your rizz skills";
    } else if (rounds <= 7) {
      return "Perfect balance of fun and challenge";
    } else {
      return "For those with legendary rizz abilities";
    }
  }
  
  String getStartButtonText() {
    if (rounds <= 3) return "Let's Warm Up";
    if (rounds <= 7) return "Show Your Rizz";
    return "Unleash Ultimate Rizz";
  }
}
