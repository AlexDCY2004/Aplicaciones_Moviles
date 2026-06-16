import 'package:flutter/material.dart';
import '../models/policy_model.dart';
import '../services/api_service.dart';

class PolicyViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Policy> _policies = [];
  bool _isLoading = false;

  List<Policy> get policies => _policies;
  bool get isLoading => _isLoading;

  Future<void> fetchPolicies() async {
    _isLoading = true;
    notifyListeners();
    try {
      _policies = await _apiService.getPolicies();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPolicy(Policy policy) async {
    await _apiService.createPolicy(policy);
    await fetchPolicies();
  }

  Future<void> updatePolicy(String id, Policy policy) async {
    await _apiService.updatePolicy(id, policy);
    await fetchPolicies();
  }

  Future<void> deletePolicy(String id) async {
    await _apiService.deletePolicy(id);
    await fetchPolicies();
  }
}