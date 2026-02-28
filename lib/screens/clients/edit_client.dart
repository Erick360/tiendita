import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/clients_model.dart';
import '../../constants/constants.dart';
import '../../providers/clients_provider.dart';

class EditClient extends ConsumerStatefulWidget{
  EditClient(ClientsModel? client,{super.key});
  static String id = "edit_client";

  @override
  ConsumerState<EditClient> createState() => _EditControllerState();
}

class _EditControllerState extends ConsumerState<EditClient>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _clientLastNaController= TextEditingController();
  TextEditingController _clientAddressController = TextEditingController();
  TextEditingController _clientPhoneController = TextEditingController();
  TextEditingController _clientEmailController = TextEditingController();

  bool _isLoading = false;
  ClientsModel? _currentClient;

  @override
  void initState(){
    _loadClients();
    super.initState();
  }

  Future<void> _loadClients() async{
    try{
      final client = await ref.read(clientsRepositoryProvider).getClient();

      if(client != null && mounted){
        setState(() {
          _currentClient = client;
          _clientNameController.text = client.clientName;
          _clientLastNaController.text = client.clientLastName;
          _clientAddressController.text = client.clientAddress;
          _clientPhoneController.text = client.clientPhoneNumber;
          _clientEmailController.text = client.clientEmail;
        });
      }
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al cargar datos: $e")));
      }
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose(){
    _clientNameController.dispose();
    _clientLastNaController.dispose();
    _clientAddressController.dispose();
    _clientPhoneController.dispose();
    _clientEmailController.dispose();
    super.dispose();
  }

  Future<void> _updateClient() async{
   try{
       final updateClient = ClientsModel(
           idClient: _currentClient!.idClient,
           clientName: _clientNameController.text.trim(),
           clientLastName: _clientLastNaController.text.trim(),
           clientPhoneNumber: _clientPhoneController.text.trim(),
           clientEmail: _clientEmailController.text.trim(),
           clientAddress: _clientAddressController.text.trim()
       );
       await ref.read(clientNotifierProvider.notifier).saveClient(updateClient);

       if(mounted){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cambios Guardados"),backgroundColor: Colors.green));
       }
   }catch(e){
     if(mounted){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al guardar")));
     }
   }finally{
     setState(() {
       _isLoading = false;
     });
   }
  }

  @override
  Widget build(BuildContext context) {
    if(_currentClient == null){
      return Scaffold(
        appBar: AppBar(title: const Text("Editar Clientes")),
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
                controller: _clientNameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: "Nombre del cliente",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
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
                  labelText: 'Apellidos del cliente *',
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
              const SizedBox(height: 10),
              TextFormField(
                controller: _clientEmailController,
                decoration: const InputDecoration(
                    labelText: 'Correo Electronico *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    helperText: 'Solo si el cliente cuenta con uno.'
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _updateClient,
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