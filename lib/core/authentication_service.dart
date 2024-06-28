import 'dart:convert';
import 'dart:developer';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:keycloak_authentication/core/config.dart';
import 'package:keycloak_authentication/core/sso_user_model.dart';

class AuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _clientId = Config.clientId;
  final String _redirectUrl = Config.redirectUrl;
  final String _issuer = Config.issuer;
  final List<String> _scopes = Config.scopes;

  Future<void> login() async {
    try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          discoveryUrl: '$_issuer/.well-known/openid-configuration',
          scopes: _scopes,
        ),
      );

      if (result != null) {
        await _secureStorage.write(key: 'access_token', value: result.accessToken);
        await _secureStorage.write(key: 'id_token', value: result.idToken);
        await _secureStorage.write(key: 'refresh_token', value: result.refreshToken);
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }



  Future<void> logout() async {
    await endSession();
    await _secureStorage.deleteAll();
  }

  Future<void> endSession() async {
    final String? idToken = await _secureStorage.read(key: 'id_token');

    if (idToken != null) {
      try {
        await _appAuth.endSession(EndSessionRequest(
          idTokenHint: idToken,
          postLogoutRedirectUrl: _redirectUrl,
          discoveryUrl: '$_issuer/.well-known/openid-configuration',
        ));
        await _secureStorage.deleteAll();
        print('Logout successful');
      } catch (e) {
        print('Error during logout: $e');
      }
    } else {
      print('No ID token found for logout');
    }
  }
  

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<String?> getIdToken() async {
    return await _secureStorage.read(key: 'id_token');
  }

  Future<SsoUserModel> getUserInfo() async {
    final String? accessToken = await getAccessToken();
    final String? idToken = await getIdToken();
    if (idToken != null) {
      log('Access token = $accessToken');
    }
    if (accessToken != null) {
      final response = await http.get(
        Uri.parse('$_issuer/protocol/openid-connect/userinfo'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      log('Access token = $accessToken');
      if (response.statusCode == 200) {
        final Map<String, dynamic> userInfoJson = jsonDecode(response.body);
        return SsoUserModel.fromJson(userInfoJson);
      } else {
        throw Exception('Failed to load user info');
      }
    } else {
      throw Exception('Access token not available');
    }
  }
}
