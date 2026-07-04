import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:tiendita/providers/security_provider.dart';
import 'package:tiendita/providers/company_provider.dart';
import 'package:tiendita/constants/constants.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});
  static String id = "change_pin_screen";

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  final TextEditingController _pinController = TextEditingController();
  int _step = 0;
  String _newPin = "";
  String _statusMessage = "Ingresa tu PIN actual";

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onCompleted(String enteredPin) async {
    final currentPin = ref.read(securityProvider).appPin;

    if (_step == 0) {
      if (enteredPin == currentPin) {
        setState(() {
          _step = 1;
          _statusMessage = "Crea tu nuevo PIN";
          _pinController.clear();
        });
      } else {
        showErrorSnackBar(context, "PIN incorrecto. Intenta de nuevo.");
        _pinController.clear();
      }
    }

    else if (_step == 1) {
      setState(() {
        _newPin = enteredPin;
        _step = 2;
        _statusMessage = "Confirma tu nuevo PIN";
        _pinController.clear();
      });
    }
    else if (_step == 2) {
      if (enteredPin == _newPin) {
        await ref.read(securityProvider.notifier).setAppPin(_newPin);
        if (mounted) {
          showSuccessSnackBar(context, "PIN actualizado exitosamente");
          Navigator.pop(context);
        }
      } else {
        showErrorSnackBar(context, "Los PINs no coinciden. Intenta de nuevo.");
        setState(() {
          _step = 1;
          _newPin = "";
          _statusMessage = "Crea tu nuevo PIN";
          _pinController.clear();
        });
      }
    }
  }

  void _showRecoveryDialog() {
    final TextEditingController phoneCompanyController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recuperar PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Para cambiar tu PIN sin saber el actual, ingresa su numero de telefono registrado en la configuración de tu negocio.'),
            const SizedBox(height: 15),
            TextField(
              controller: phoneCompanyController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  labelText: 'Numero de telefono del negocio',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone)
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF25410)),
            onPressed: () async {
              final companyData = await ref.read(companyRepositoryProvider).getCompany();


              if (companyData != null &&
                  companyData.phoneNumberCompany.trim().toLowerCase() ==phoneCompanyController.text.trim().toLowerCase()) {

                Navigator.pop(ctx);
                setState(() {
                  _step = 1;
                  _statusMessage = "Identidad verificada. Crea tu nuevo PIN.";
                  _pinController.clear();
                });

              } else {
                Navigator.pop(ctx);
                showErrorSnackBar(context, "El numero de telefono no coincide con los registros del sistema.");
              }
            },
            child: const Text('Verificar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF25410),
        title: const Text('Cambiar PIN', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                'Seguridad',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),

              Pinput(
                obscureText: true,
                autofocus: true,
                controller: _pinController,
                length: 4,
                onCompleted: _onCompleted,
              ),

              const SizedBox(height: 30),

              if (_step == 0)
                TextButton(
                  onPressed: _showRecoveryDialog,
                  child: const Text('¿Olvidaste tu PIN?', style: TextStyle(color: Color(0xFFF25410), fontSize: 16)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}