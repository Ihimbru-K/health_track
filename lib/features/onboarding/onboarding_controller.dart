import '../../services/api_service.dart';

class OnboardingController {
  final ApiService _apiService = ApiService();

  Future<String> getMotivationalMessage() async {
    try {
      return await _apiService.fetchMotivationalMessage();
    } catch (e) {
      return "You're doing great! Keep it up!";
     // return "Stay positive and keep going!";
    }
  }
}
