import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'round_setup_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> with SingleTickerProviderStateMixin {
  int playerCount = 2;
  final List<TextEditingController> _controllers = [];
  final List<String> _avatars = [
    '😎', '🔥', '🎮', '🌟', '🚀', '💫', '🎯', '🎪'
  ];
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _updateControllers();
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
    _animationController.dispose();
    super.dispose();
  }

  bool _areAllFieldsFilled() {
    return _controllers
        .every((controller) => controller.text.trim().isNotEmpty);
  }
  
  bool _hasDuplicateNames() {
    final names = _controllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    
    if (names.length < 2) return false;
    
    final uniqueNames = names.toSet().toList();
    return names.length != uniqueNames.length;
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
              children: [
                // Header with animated title
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.2),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0), // Reduced vertical padding
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/selection_page/rizzer_banner.png',
                            width: MediaQuery.of(context).size.width - 32,
                            height: 160,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 1), // Spacing set to 1
                          Text(
                            "Who's Ready to Rizz?",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Player count selector with modern design
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Minus icon
                      InkWell(
                        onTap: playerCount > 2
                            ? () {
                                setState(() {
                                  playerCount--;
                                  _updateControllers();
                                });
                              }
                            : null,
                        child: Icon(
                          Icons.remove,
                          color: playerCount > 2
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 32), // Increased spacing
                      // Player count number
                      Text(
                        '$playerCount',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 20,
                            ),
                      ),
                      const SizedBox(width: 32), // Increased spacing
                      // Plus icon
                      InkWell(
                        onTap: playerCount < 8
                            ? () {
                                setState(() {
                                  playerCount++;
                                  _updateControllers();
                                });
                              }
                            : null,
                        child: Icon(
                          Icons.add,
                          color: playerCount < 8
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Player name input fields
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: playerCount,
                      itemBuilder: (context, index) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 70, // Increased from 50
                                  height: 70, // Increased from 50
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/selection_page/character${index + 1}.png',
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: _controllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Player ${index + 1}',
                                      hintText: 'Enter name with rizz',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Quicksand',
                                        color: Theme.of(context).hintColor.withOpacity(0.7),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.withOpacity(0.05),
                                    ),
                                    onChanged: (_) {
                                      if (_errorMessage != null) {
                                        setState(() {
                                          _errorMessage = null;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Error message display
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Next button with modern design
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_areAllFieldsFilled()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter all player names before proceeding'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      
                      if (_hasDuplicateNames()) {
                        setState(() {
                          _errorMessage = "Player names must be unique!";
                        });
                        return;
                      }
                      
                      final gameProvider = Provider.of<GameProvider>(context, listen: false);
                      gameProvider.setPlayers(
                        _controllers.map((c) => c.text.trim()).toList(),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoundSetupScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Let\'s Get Rizzy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.8,
                      ),
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
}
