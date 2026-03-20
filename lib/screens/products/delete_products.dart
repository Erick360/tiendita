import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/providers/products_provider.dart';
import '../../constants/constants.dart';
import '../../models/products_model.dart';

class DeleteProduct extends ConsumerStatefulWidget{
  final ProductsModel _currentProduct;
  DeleteProduct(this._currentProduct,{super.key});

  @override
  ConsumerState<DeleteProduct> createState() => _StateDeleteProduct();
}

class _StateDeleteProduct extends ConsumerState<DeleteProduct>{
  bool _isLoading = false;

  Future<void> _deleteProduct() async{
    setState(() {
      _isLoading = true;
    });
    try{
      if(widget._currentProduct.idProduct!=null){
        await ref.read(productsNotifierProvider.notifier).deleteProduct(widget._currentProduct.idProduct!);

        if(mounted){
          showSuccessSnackBar(context, 'Producto eliminado exitosamente');
          Navigator.pop(context);
        }
      }
    }catch(e){
      if(mounted){
        showErrorSnackBar(context, 'Error al eliminar los datos');
        print("Error al eliminar datos: $e");
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
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eliminar Producto"),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 80,color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              "Estas Seguro?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Estás a punto de eliminar :\n'${widget._currentProduct.productName}'\n\nEsta acción no se puede deshacer.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _deleteProduct,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15)
              ),
              child: _isLoading ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
                  : const Text("ELIMINAR DEFINITIVAMENTE", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(fontSize: 16)),
            ),

          ],
        ),
      ),
    );
  }
}