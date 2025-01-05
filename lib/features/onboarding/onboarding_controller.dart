import '../../services/api_service.dart';


/// fetches motivational message from the dummy api service and prepares it to be used in the onboarding ui
class OnboardingController {
  final ApiService _apiService = ApiService();

  Future<String> getMotivationalMessage() async {
    try {
      return await _apiService.fetchMotivationalMessage();
    } catch (e) {

     return "Stay positive and keep going..!";

    }
  }
}
