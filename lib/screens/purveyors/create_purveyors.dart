import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/models/purveyors_model.dart';
import 'package:tiendita/providers/purveyor_provider.dart';
import 'package:tiendita/screens/purveyors/purveyors_screen.dart';

class CreatePurveyor extends ConsumerStatefulWidget{
  const CreatePurveyor({super.key});
  static String id = "create_purveyor";

  @override
  ConsumerState<CreatePurveyor> createState() => _StateCreatePurveyor();
}

class _StateCreatePurveyor extends ConsumerState<CreatePurveyor>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _purveyorNameController = TextEditingController();
  TextEditingController _purveyorAddressController = TextEditingController();
  TextEditingController _purveyorPhoneController = TextEditingController();
  late final TextEditingController _purveyorEmailController = TextEditingController();
  late final TextEditingController _purveyorRfcController= TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _purveyorNameController.dispose();
    _purveyorAddressController.dispose();
    _purveyorEmailController.dispose();
    _purveyorPhoneController.dispose();
    _purveyorRfcController.dispose();
    super.dispose();
  }

  Future<void> _savePurveyor() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() {
      _isLoading = true;
    });

    try{
      final purveyor = PurveyorsModel(
          PurveyorRFC: _purveyorRfcController.text.trim().isEmpty ? 'XAXX010101000' : _purveyorRfcController.text.trim(),
          PurveyorName: _purveyorNameController.text.trim(),
          PurveyorPhoneNumber: _purveyorPhoneController.text.trim(),
          PurveyorEmail: _purveyorEmailController.text.trim().isEmpty ? 'proovedor@email.com' : _purveyorEmailController.text.trim(),
          PurveyorAddress: _purveyorAddressController.text.trim(),
      );

      await ref.read(purveyorNotifierProvider.notifier).savePurveyor(purveyor);
      if(mounted){
        showSuccessSnackBar(context, 'Proveedor guardado exitosamente');
          Navigator.pop(context);
      }

    }catch(e){
      if(mounted){
        showErrorSnackBar(context, 'Error al guardar los datos');
            print(e);
      }
    }finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF25410),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresar Proveedor',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              TextFormField(
                controller: _purveyorNameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: "Nombre del proveedor",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Este campo necesita llenarse';
                  }
                  if(value.length <3){
                    return "El nombre es muy corto";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purveyorAddressController,
                decoration: const InputDecoration(
                  labelText: 'Direccion *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city_outlined)                                 ,
                ),
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "Este campo necesita llenarse";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purveyorEmailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electronico *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                  helperText: 'Solo si el proveedor cuenta con uno.'
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _purveyorPhoneController,
                decoration: const InputDecoration(
                    labelText: 'Telefono *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone)
                ),
                keyboardType: TextInputType.phone,
                maxLength: 12,
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return 'Este campo necesita rellenarse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purveyorRfcController,
                decoration: const InputDecoration(
                  labelText: 'RFC (opcional)',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                  helperText: 'Solo si el proveedor cuenta con este',
                ),
                textCapitalization: TextCapitalization.characters,
                maxLength: 13,
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePurveyor,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF25410)),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white,strokeWidth: 2)
                      : const Text('Continuar', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
