import 'package:tiendita/model/company_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/company_provider.dart';
import 'package:tiendita/screens/settings/settings_screen.dart';
import 'package:tiendita/widgets/image_picker.dart';

class CompanyEditScreen extends ConsumerStatefulWidget{
  const CompanyEditScreen({super.key});
  static String id = "company_edit_screen";

  @override
  ConsumerState<CompanyEditScreen> createState() => _CompanyEditScreenState();
}

class _CompanyEditScreenState extends ConsumerState<CompanyEditScreen>{
  final _formKey = GlobalKey<FormState>();

  //controllers for fields
  final TextEditingController _nameCompanyController = TextEditingController();
  final TextEditingController _addressCompanyController = TextEditingController();
  final TextEditingController _phoneCompanyController = TextEditingController();
  final TextEditingController _emailCompanyController = TextEditingController();
  final TextEditingController _rfcCompanyController = TextEditingController();

  bool _isLoading = false;
  String? _logoCompany;
  CompanyModel? _currentCompany;

  @override
  void initState(){
    super.initState();
    _loadCompany();
  }

  Future<void> _loadCompany() async{
    try{
      final company = await ref.read(companyRepositoryProvider).getCompany();

      if(company != null && mounted){
        setState(() {
          _currentCompany = company;
          _nameCompanyController.text = company.nameCompany;
          _addressCompanyController.text = company.addressCompany;
          _emailCompanyController.text = company.emailCompany;
          _rfcCompanyController.text = company.rfcCompany!;
          _phoneCompanyController.text = company.phoneNumberCompany;
        });
      }
    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error Cargando datos: $e")),
        );
      }
    }
  }

  @override
  void dispose(){
    _nameCompanyController.dispose();
    _addressCompanyController.dispose();
    _phoneCompanyController.dispose();
    _emailCompanyController.dispose();
    _rfcCompanyController.dispose();
    super.dispose();
  }

  Future<void> _updateCompany() async{
    if(_currentCompany == null)return;
    if(!_formKey.currentState!.validate())return;

    setState(()=> _isLoading = true);

    try{
      final updateCompany = CompanyModel(
          idCompany: _currentCompany!.idCompany,
          nameCompany: _nameCompanyController.text.trim(),
          addressCompany: _addressCompanyController.text.trim(),
          phoneNumberCompany: _phoneCompanyController.text.trim(),
          emailCompany: _emailCompanyController.text.trim(),
          rfcCompany: _rfcCompanyController.text.trim().toUpperCase(),
          logoCompany: _logoCompany
      );

      await ref.read(companyNotifierProvider.notifier).saveCompany(updateCompany);

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
             content: Text('Cambios guardados'),
          backgroundColor: Colors.green,
         ),
        );
        Navigator.pop(context);
      }

    }catch(e){
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar'),
            )
          );
        }
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context){
    if(_currentCompany == null){
      return Scaffold(
        appBar: AppBar(title: const Text('Editar negocio')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                  'Editar negocio',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  )
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () => Navigator.pushNamed(context, SettingsScreen.id),
                icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 20
                )
            )
          ],
        ),
      body: Form(
              key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    ImagePicker(
                        initialImage: _logoCompany,
                        onImageSelected: (path){
                          setState(() {
                            _logoCompany = path;
                          });
                        },
                      label: "Logo de la empresa",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameCompanyController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del negocio',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business)
                      ),
                      validator: (value){
                        if(value==null || value.trim().isEmpty){
                          return 'Este campo necesita rellenarse';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      controller: _addressCompanyController,
                      decoration: InputDecoration(
                          labelText: 'Direccion del negocio',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city_rounded)
                      ),
                      validator: (value){
                        if(value==null || value.trim().isEmpty){
                          return 'Este campo necesita rellenarse';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      controller: _emailCompanyController,
                      decoration: InputDecoration(
                          labelText: 'Correo electronico del negocio',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined)
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value==null || value.trim().isEmpty){
                          return 'Este campo necesita rellenarse';
                        }
                        if(!value.contains("@")){
                          return 'Correo electronico invalido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      controller: _phoneCompanyController,
                      decoration: InputDecoration(
                          labelText: 'Numero de telefono del negocio',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone)
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 12,
                      validator: (value){
                        if(value==null || value.trim().isEmpty){
                          return 'Este campo necesita rellenarse';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      controller: _rfcCompanyController,
                      decoration: InputDecoration(
                          labelText: 'RFC del negocio',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business)
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 13,
                      validator: (value){
                        if(value==null || value.trim().isEmpty){
                          return 'Este campo necesita rellenarse';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                          onPressed: _isLoading ? null :  _updateCompany,
                          icon: _isLoading ? const SizedBox(
                            width: 20,
                              height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white
                            ),
                          ) : const Icon(Icons.save),
                        label: Text(_isLoading ? 'Guardando...' : 'Guardar cambios'),
                      ),
                    )
                  ],
                )
            ),
      );
  }
}