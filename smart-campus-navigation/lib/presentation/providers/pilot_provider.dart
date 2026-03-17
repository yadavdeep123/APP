import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/pilot_service.dart';

final pilotServiceProvider = Provider<PilotService>((ref) {
  return PilotService();
});
