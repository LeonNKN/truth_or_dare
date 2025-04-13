import 'package:flutter/foundation.dart';
import '../data/rizz_cards.dart';
import '../services/ad_service.dart';

class GameProvider with ChangeNotifier {
  List<String> _players = [];
  int _currentRound = 0;
  int _totalRounds = 0;
  int _currentPlayerIndex = 0;
  Map<String, int> _scores = {};
  bool _isVotingPhase = false;
  List<String> _votedPlayers = [];
  RizzCard? _currentCard;
  List<RizzCard> _usedCards = [];

  List<String> get players => _players;
  int get currentRound => _currentRound;
  int get totalRounds => _totalRounds;
  int get currentPlayerIndex => _currentPlayerIndex;
  String get currentPlayer => _players[_currentPlayerIndex];
  Map<String, int> get scores => _scores;
  bool get isVotingPhase => _isVotingPhase;
  RizzCard? get currentCard => _currentCard;
  List<String> get votedPlayers => _votedPlayers;

  void initializeGame(List<String> players, int totalRounds) {
    _players = players;
    _totalRounds = totalRounds;
    _currentRound = 1;
    _currentPlayerIndex = 0;
    _scores = {for (var player in players) player: 0};
    _isVotingPhase = false;
    _votedPlayers = [];
    _usedCards = [];
    _currentCard = null;
    notifyListeners();
  }

  RizzCard drawCard() {
    List<RizzCard> availableCards =
        rizzCards.where((card) => !_usedCards.contains(card)).toList();

    if (availableCards.isEmpty) {
      _usedCards.clear();
      availableCards = List.from(rizzCards);
    }

    _currentCard = availableCards[
        DateTime.now().millisecondsSinceEpoch % availableCards.length];
    _usedCards.add(_currentCard!);
    notifyListeners();
    return _currentCard!;
  }

  void nextTurn() {
    if (_currentPlayerIndex < _players.length - 1) {
      _currentPlayerIndex++;
    } else {
      _currentPlayerIndex = 0;
      if (_currentRound < _totalRounds) {
        _currentRound++;
      } else {
        _isVotingPhase = true;
        _currentPlayerIndex = 0;
      }
    }
    _currentCard = null;
    notifyListeners();
  }

  void voteForPlayer(String playerName) {
    if (!_votedPlayers.contains(currentPlayer)) {
      _scores[playerName] = (_scores[playerName] ?? 0) + 1;
      _votedPlayers.add(currentPlayer);

      // Move to next player for voting
      if (_currentPlayerIndex < _players.length - 1) {
        _currentPlayerIndex++;
      } else {
        // All players have voted, go to results
        _currentPlayerIndex = 0;
        // Show ad after the game ends
        AdService().showInterstitialAd();
      }
      notifyListeners();
    }
  }

  List<String> getWinners() {
    int maxScore = 0;
    List<String> winners = [];

    // Find the maximum score
    _scores.forEach((player, score) {
      if (score > maxScore) {
        maxScore = score;
      }
    });

    // Find all players with the maximum score
    _scores.forEach((player, score) {
      if (score == maxScore) {
        winners.add(player);
      }
    });

    return winners;
  }

  bool isTie() {
    return getWinners().length > 1;
  }

  void resetGame() {
    _players = [];
    _currentRound = 1;
    _totalRounds = 0;
    _currentPlayerIndex = 0;
    _scores = {};
    _isVotingPhase = false;
    _votedPlayers = [];
    _usedCards = [];
    _currentCard = null;
    notifyListeners();
  }

  void setPlayers(List<String> playerNames) {
    _players = playerNames;
    notifyListeners();
  }

  void setTotalRounds(int rounds) {
    _totalRounds = rounds;
    notifyListeners();
  }
}
