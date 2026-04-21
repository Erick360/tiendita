import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/expenses_model.dart';
import 'package:tiendita/providers/expenses_provider.dart';

import '../../constants/constants.dart';

class DeleteExpense extends ConsumerStatefulWidget{
  const DeleteExpense(this._currentExpense,{super.key});
  final ExpensesModel _currentExpense;
  static String id = "delete_expense";

  @override
  ConsumerState<DeleteExpense> createState() => _DeleteExpenseState();

}

class _DeleteExpenseState extends ConsumerState<DeleteExpense>{
  bool _isLoading = false;

  Future<void> _deleteExpense() async{
    setState(() {
      _isLoading = true;
    });
    try{
      if(widget._currentExpense.idExpenses !=null){
        await ref.read(expenseNotifierProvider.notifier).deleteExpense(widget._currentExpense.idExpenses!);

        if(mounted){
          showSuccessSnackBar(context, 'Dato eliminado exitosamente');
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
        title: const Text("Eliminar Gasto"),
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
              "Estás a punto de eliminar :\n'${widget._currentExpense.expenseName}'\n\nEsta acción no se puede deshacer.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _deleteExpense,
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