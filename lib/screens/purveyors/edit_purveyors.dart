import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/models/purveyors_model.dart';
import 'package:tiendita/providers/purveyor_provider.dart';

class EditPurveyors extends ConsumerStatefulWidget{
  const EditPurveyors(PurveyorsModel? purveyors, {super.key});
  static String id = "edit_purveyors";

  @override
  ConsumerState<EditPurveyors> createState() => _StateEditPurveyors();
}

class _StateEditPurveyors extends ConsumerState<EditPurveyors>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _purveyorNameController = TextEditingController();
  TextEditingController _purveyorAddressController = TextEditingController();
  TextEditingController _purveyorPhoneController = TextEditingController();
  TextEditingController _purveyorEmailController = TextEditingController();
  TextEditingController _purveyorRfcController = TextEditingController();

  bool _isLoading = false;
  PurveyorsModel? _currentPurveyor;

  @override
  void initState(){
    super.initState();
    _loadPurveyor();
  }

  Future<void> _loadPurveyor() async{
    try{
      final purveyor = await ref.read(purveyorRepositoryProvider).getPurveyor();

      if(purveyor != null && mounted){
        setState(() {
          _currentPurveyor = purveyor;
          _purveyorNameController.text = purveyor.PurveyorName;
          _purveyorAddressController.text = purveyor.PurveyorAddress;
          _purveyorEmailController.text = purveyor.PurveyorEmail;
          _purveyorPhoneController.text = purveyor.PurveyorPhoneNumber;
          _purveyorRfcController.text = purveyor.PurveyorRFC;
        });
      }
    }catch(e){
      if(mounted){
        showErrorSnackBar(context, 'Error al cargar los datos');
      }
    }
  }

  @override
  void dispose(){
    _purveyorNameController.dispose();
    _purveyorAddressController.dispose();
    _purveyorEmailController.dispose();
    _purveyorPhoneController.dispose();
    _purveyorRfcController.dispose();
    super.dispose();
  }

  Future<void> _updatePurveyor()async{
    try{
    final updatePurveyor = PurveyorsModel(
        idPurveyor: _currentPurveyor!.idPurveyor,
        PurveyorRFC: _purveyorRfcController.text.trim(),
        PurveyorName: _purveyorNameController.text.trim(),
        PurveyorPhoneNumber: _purveyorPhoneController.text.trim(),
        PurveyorEmail: _purveyorEmailController.text.trim(),
        PurveyorAddress: _purveyorAddressController.text.trim()
    );

    await ref.read(purveyorNotifierProvider.notifier).savePurveyor(updatePurveyor);

    if(mounted){
      showSuccessSnackBar(context, 'Proveedor actualizado exitosamente');
      Navigator.pop(context);
    }
  }catch(e){
    if(mounted){
       showErrorSnackBar(context, 'Error al actualizar los datos');
       print(e);
      }
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    if(_currentPurveyor == null){
      return Scaffold(
        appBar: AppBar(title: const Text("Editar proveedores")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kActiveColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Editar Proveedores',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                )
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 40),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _updatePurveyor,
                    icon: _isLoading ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                          color: Colors.white,
                      ),
                    ) : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Guardando...' : 'Guardar Cambios'),
                ),
              )
            ],
          )
      ),
    );
  }

}