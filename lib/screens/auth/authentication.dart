import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/screens/home_page.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});
  static String id = "auth";

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authStatus = "No autenticado";
  bool _isAuthenticating = false;

  Future<void> _authenticateUser() async {
    bool authenticated = false;
    setState(() {
      _isAuthenticating = true;
      _authStatus = "Autenticando...";
    });

    try {
      //(v3.0.0)
      authenticated = await auth.authenticate(
        localizedReason: 'Escanea tu huella (o usa tu rostro) para autenticarte.',
        persistAcrossBackgrounding: true,
        biometricOnly: false,
      );

    } catch (e) {
      print("Error Autenticación: $e");
      setState(() {
        _authStatus = "Error de Autenticación";
      });
      return;
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }

    setState(() {
      _authStatus = authenticated ? "Autenticación Exitosa!" : "Error de Autenticación!";
    });

    if (authenticated) {
       Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 15, bottom: 15,left: 10, right: 10),
              decoration: const BoxDecoration(
                  color: kActiveColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)
                  ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset(
                "images/tiendita_banner.png",
                height: 130,
              ),
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.fingerprint,
                          size: 80,
                          color: _isAuthenticating ? const Color(0xFFF36618) : Colors.grey[400]
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _authStatus,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _authStatus.contains("Error") ? Colors.red : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isAuthenticating ? null : _authenticateUser,
                          icon: _isAuthenticating
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.fingerprint_outlined, size: 30),
                          label: Text(_isAuthenticating ? 'Esperando...' : 'Acceder'),
                          style:
                          ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
            ),
          ],
      ),
    );
  }
}