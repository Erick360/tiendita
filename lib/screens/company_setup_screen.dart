import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/model/company_model.dart';
import 'package:tiendita/screens/home_page.dart';

import '../providers/company_provider.dart';

class CompanySetupScreen extends ConsumerStatefulWidget{
  const CompanySetupScreen({super.key});

  @override
  ConsumerState<CompanySetupScreen> createState() => _CompanySetupState();
}

class _CompanySetupState extends ConsumerState<CompanySetupScreen>{
  final _formKey = GlobalKey<FormState>();

  //controllers for fields
  final TextEditingController _nameCompanyController = TextEditingController();
  final TextEditingController _addressCompanyController = TextEditingController();
  final TextEditingController _phoneCompanyController = TextEditingController();
  final TextEditingController _emailCompanyController = TextEditingController();
  final TextEditingController _rfcCompanyController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose(){
    _nameCompanyController.dispose();
    _addressCompanyController.dispose();
    _phoneCompanyController.dispose();
    _emailCompanyController.dispose();
    _rfcCompanyController.dispose();
    super.dispose();
  }

  Future<void> _saveCompany() async {
    setState(() {
      _isLoading = true;
    });

    try{
      final company = CompanyModel(
          nameCompany: _nameCompanyController.text.trim(),
          addressCompany: _addressCompanyController.text.trim(),
          phoneNumberCompany: _phoneCompanyController.text.trim(),
          emailCompany: _emailCompanyController.text.trim()
      );

      await ref.read(companyNotifierProvider.notifier).saveCompany(company);
      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }

    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()),backgroundColor: Colors.red,)
        );
      }
    } finally{
      if(mounted) {
        setState(() =>
        _isLoading = false);
      }
    }

  }
  
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                const SizedBox(height: 40),
                Image(image: AssetImage("images/tiendita_icon.png")),
                const SizedBox(height: 16),
                const Text(
                    'Bienvenido',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                    'Comienza a configurar tu negocio para poder iniciar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Monserrat',
                    fontSize: 16,
                    color: Colors.grey
                  ),
                ),
                const SizedBox(height: 40),
                //Phone Number field
                TextFormField(
                  controller: _phoneCompanyController,
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
                // email Field
                TextFormField(
                  controller: _emailCompanyController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electronico *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value==null || value.trim().isEmpty){
                      return 'Este campo necesita rellenarse';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressCompanyController,
                  decoration: const InputDecoration(
                    labelText: 'Direccion *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city_rounded)
                  ),
                  maxLines: 2,
                  validator: (value){
                    if(value == null || value.trim().isEmpty ){
                      return 'Este campo necesita llenarse';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameCompanyController,
                  decoration: const InputDecoration(
                    labelText: 'RFC (opcional)',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                    helperText: 'Solo si tu negocio cuenta con este'
                ),
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 15,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveCompany,
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) :
                    const Text('Continuar', style: TextStyle(fontSize: 16)),

                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}