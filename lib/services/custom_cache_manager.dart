import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const key = "customCacheKey";

  static final CustomCacheManager _instance = CustomCacheManager._();

  factory CustomCacheManager() {
    return _instance;
  }

  CustomCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 7), // Auto delete after 7 days
            maxNrOfCacheObjects: 20, // Keep up to 50 files
          ),
        );
}
