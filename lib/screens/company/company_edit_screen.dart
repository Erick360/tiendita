import 'package:tiendita/model/company_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/company_provider.dart';

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
  bool _isInitialized = false;

  @override
  void dispose(){
    _nameCompanyController.dispose();
    _addressCompanyController.dispose();
    _phoneCompanyController.dispose();
    _emailCompanyController.dispose();
    _rfcCompanyController.dispose();
    super.dispose();
  }

  void _initializedFields(CompanyModel? company){
    if(company != null && !_isInitialized){
      _isInitialized = true;
      _nameCompanyController.text = company.nameCompany;
      _addressCompanyController.text = company.phoneNumberCompany;
      _emailCompanyController.text = company.emailCompany;
      _rfcCompanyController.text = company.rfcCompany!;
      _phoneCompanyController.text = company.phoneNumberCompany;
    }
  }

  Future<void> _updateCompany(CompanyModel exists) async{
    if(!_formKey.currentState!.validate())return;

    setState(()=> _isLoading = true);

    try{
      final updateCompany = CompanyModel(
          idCompany: exists.idCompany,
          nameCompany: _nameCompanyController.text.trim(),
          addressCompany: _addressCompanyController.text.trim(),
          phoneNumberCompany: _phoneCompanyController.text.trim(),
          emailCompany: _emailCompanyController.text.trim(),
          rfcCompany: _rfcCompanyController.text.trim().toUpperCase(),
          logoCompany: exists.logoCompany
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
        if(mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context){
    final companyState = ref.watch(companyNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar negocio'),
        ),
      body: companyState.when(
          data: (company){
            if(company==null){
              return const Center(child: Text('No hay datos disponibles'));
            }

            _initializedFields(company);


            return Form(
              key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
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
                      validator: (value){
                        if(value==null || value.trim().isEmpty){
                          return 'Este campo necesita rellenarse';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      controller: _phoneCompanyController,
                      decoration: InputDecoration(
                          labelText: 'Numerod de telefono del negocio',
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
                      maxLength: 15,
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
                          onPressed: _isLoading ? null : () => _updateCompany(company),
                          icon: _isLoading ? const SizedBox(
                            width: 20,
                              height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ) : const Icon(Icons.save),
                        label: Text(_isLoading ? 'Guardado...' : 'Guardar cambios'),
                      ),
                    )
                  ],
                )
            );
          },

          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error al guardar datos: $e'),
                ElevatedButton(
                    onPressed: () => ref.refresh(companyNotifierProvider),
                    child: const Text('Reintentar')
                )
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator())
      ),
    );
  }
}