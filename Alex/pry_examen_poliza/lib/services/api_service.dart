import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/policy_model.dart';

class ApiService {
  
  final String baseUrl = "https://6a3148c27bc5e1c6126579e1.mockapi.io/poliza"; 

  Future<List<Policy>> getPolicies() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Policy.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar pólizas');
    }
  }

  Future<void> createPolicy(Policy policy) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(policy.toJson()),
    );
  }

  Future<void> updatePolicy(String id, Policy policy) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(policy.toJson()),
    );
  }

  Future<void> deletePolicy(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}