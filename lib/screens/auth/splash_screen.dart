import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiendita/providers/company_provider.dart';
import 'package:tiendita/repositories/company_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/screens/home_page.dart';
import 'package:tiendita/screens/company_setup_screen.dart';

class SplashScreen extends ConsumerStatefulWidget{
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>{
  @override
  void initState(){
    super.initState();
    _checkSetup();
  }

  Future<void> _checkSetup() async{
    await Future.delayed(const Duration(seconds: 2));

    if(!mounted)return;

    final repository = ref.read(companyRepositoryProvider);
    final companyExists = await repository.companyExists();

    if(companyExists){
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_)=>
      HomeScreen()
      ));
    }else{
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const CompanySetupScreen())
      );
    }
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage("images/tiendita_icon.png")),
              const CircularProgressIndicator()
            ],
          )
        ),
    );
  }
}