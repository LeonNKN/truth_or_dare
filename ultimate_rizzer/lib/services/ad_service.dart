import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  // Initialize the Mobile Ads SDK
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
  }

  // Load an interstitial ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-5835056353129158/3795664370', // Your real ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoaded = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  // Show the interstitial ad
  Future<void> showInterstitialAd() async {
    if (_isAdLoaded && _interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialAd!.dispose();
      _loadInterstitialAd(); // Load the next ad
    } else {
      _loadInterstitialAd(); // Try to load a new ad if none is available
    }
  }
}
