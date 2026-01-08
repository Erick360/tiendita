import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiendita/providers/company_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/screens/home_page.dart';
import 'package:tiendita/screens/company_setup_screen.dart';

class SplashScreen extends ConsumerStatefulWidget{
  const SplashScreen({super.key});
  static String id = "splash_screen";
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
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }else{
      Navigator.pushReplacementNamed(context, CompanySetupScreen.id);
    }
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFF36618),
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    child: Image.asset(
                      "images/tiendita_icon.png",
                      //alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 4
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );

      /*
      Scaffold(
        body: Stack(
            children: [
              SizedBox.expand(
                child: Image(
                  image: AssetImage("images/tiendita_icon.png"),
                  fit: BoxFit.fill,
                  //height: double.infinity,
                  //width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 4,
                    ),
                ),
              )
            ],
        ),
    );

       */
  }
}