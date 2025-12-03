import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/model/company_model.dart';
import 'package:tiendita/screens/home_page.dart';
import '../providers/company_provider.dart';
import 'package:tiendita/widgets/image_picker.dart';

class CompanySetupScreen extends ConsumerStatefulWidget{
  const CompanySetupScreen({super.key});
  static String id = "company_setup_screen";

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

  String? _logoCompany;
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
          emailCompany: _emailCompanyController.text.trim(),
          rfcCompany: _rfcCompanyController.text.trim(),
          logoCompany: _logoCompany
      );

      await ref.read(companyNotifierProvider.notifier).saveCompany(company);
      if(mounted){
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }

    }catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar los datos: $e"),backgroundColor: Colors.red,)
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
      //backgroundColor: Color(0xFFF5F5DC),
      body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                //const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: SizedBox(
                   height: 160,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Image.asset(
                        "images/tiendita_banner.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
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
                //Name field
                const Text(
                    'Comienza a configurar tu negocio para poder iniciar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Monserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameCompanyController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre del negocio *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business)
                  ),
                  maxLength: 40,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value==null || value.trim().isEmpty){
                        return 'Este campo necesita rellenarse';
                      }
                      return null;
                    },
                ),
                const SizedBox(height: 10),
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
                  controller: _rfcCompanyController,
                  decoration: const InputDecoration(
                    labelText: 'RFC (opcional)',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                    helperText: 'Solo si tu negocio cuenta con este'
                ),
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 15,
                ),
                ImagePicker(
                  initialImage: _logoCompany,
                  onImageSelected: (path) {
                    setState(()=> _logoCompany = path);
                  },
                  label: 'Logo del negocio',
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