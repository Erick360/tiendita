import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/model/company_model.dart';
import 'package:tiendita/providers/company_provider.dart';


class CompanyForm extends ConsumerStatefulWidget{
  const CompanyForm({super.key});

  @override
  ConsumerState<CompanyForm> createState() => _CompanyFormState();
}

class _CompanyFormState extends ConsumerState<CompanyForm>{
  final _formKey = GlobalKey<FormState>();

  //controllers for fields
  final TextEditingController _nameCompanyController = TextEditingController();
  final TextEditingController _addressCompanyController = TextEditingController();
  final TextEditingController _phoneCompanyController = TextEditingController();
  final TextEditingController _emailCompanyController = TextEditingController();
  final TextEditingController _rfcCompanyController = TextEditingController();

  String? _companyLogo;
  bool _isLoading = false;
  String? _error;

  @override
  void initState(){
    super.initState();
    _loadExistingCompany();
  }

  Future<void> _loadExistingCompany() async{
    final company = await ref.read(companyRepositoryProvider).getCompany();
    if(company != null && mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameCompanyController,
              decoration: const InputDecoration(labelText: "Nombre del negocio"),
              validator: (value)=> value!.isEmpty ? "Requerido" : null,
            ),
            TextFormField(
              controller: _addressCompanyController,
              decoration: const InputDecoration(labelText: "Direccion del negocio"),
              validator: (value)=> value!.isEmpty ? "Requerido" : null,
            ),
            TextFormField(
              controller: _phoneCompanyController,
              decoration: const InputDecoration(labelText: "Numero de celular del negocio"),
              validator: (value)=> value!.isEmpty ? "Requerido" : null,
            ),
            TextFormField(
              controller: _emailCompanyController,
              decoration: const InputDecoration(labelText: "Correo electronico del negocio"),
              validator: (value)=> value!.isEmpty ? "Requerido" : null,
            ),
            TextFormField(
              controller: _rfcCompanyController,
              decoration: const InputDecoration(labelText: "RFC del negocio"),
              validator: (value)=> value!.isEmpty ? "Requerido" : null,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    final company = CompanyModel(
                  nameCompany: _nameCompanyController.text,
                  addressCompany: _addressCompanyController.text,
                  phoneNumberCompany: _phoneCompanyController.text,
                    emailCompany: _emailCompanyController.text
                    );
                  }
                },
                child: const Text('Guardar')
            )
          ],
      ),
    );
  }
}