import 'package:flutter/material.dart';
import 'package:keycloak_authentication/core/authentication_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SSO with Keycloak'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _authService.login(),
              child: const Text('Login with SSO'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Example: Fetch user info after login
                try {
                  final userInfo = await _authService.getUserInfo();
                  debugPrint(userInfo);
                } catch (e) {
                  debugPrint('Error fetching user info: $e');
                }
              },
              child: const Text('Get User Info'),
            ),
            ElevatedButton(
              onPressed: () => _authService.logout(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
