import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/clients_model.dart';

import '../../constants/constants.dart';
import '../../providers/clients_provider.dart';
import 'clients_screen.dart';

class CreateClient extends ConsumerStatefulWidget{
  const CreateClient({super.key});
  static String id = "create_client";

  ConsumerState<CreateClient> createState() => _CreateClientState();
}

class _CreateClientState extends ConsumerState<CreateClient>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _clientLastNaController= TextEditingController();
  TextEditingController _clientAddressController = TextEditingController();
  TextEditingController _clientPhoneController = TextEditingController();
  TextEditingController _clientEmailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose(){
    _clientNameController.dispose();
    _clientLastNaController.dispose();
    _clientAddressController.dispose();
    _clientPhoneController.dispose();
    _clientEmailController.dispose();
    super.dispose();
  }

  Future<void> _saveClient()  async{
    if (_formKey.currentState?.validate() != true) return;
    setState(() {
      _isLoading = true;
    });
    try{
      final client = ClientsModel(
          clientName: _clientNameController.text.trim(),
          clientLastName: _clientLastNaController.text.trim(),
          clientPhoneNumber: _clientPhoneController.text.trim(),
          clientEmail: _clientEmailController.text.trim().isEmpty ? 'proovedor@email.com' : _clientEmailController.text.trim(),
          clientAddress: _clientAddressController.text.trim()
      );

      await ref.read(clientNotifierProvider.notifier).saveClient(client);
      if(mounted){
        showSuccessSnackBar(context, 'Cliente guardado exitosamente');
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
  Widget build(BuildContext context) {
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
                'Ingresar Clientes',
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
                  controller: _clientNameController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: "Nombre del cliente",
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
                  controller: _clientLastNaController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: "Apellidos del cliente",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.contact_mail_outlined),
                  ),
                  maxLength: 30,
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
                  controller: _clientAddressController,
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
                  controller: _clientEmailController,
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
                  controller: _clientPhoneController,
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
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveClient,
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