import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/constants.dart';
import '../../models/expenses_model.dart';
import '../../providers/expenses_provider.dart';

class EditExpense extends ConsumerStatefulWidget{
  const EditExpense(ExpensesModel? expense,{super.key});
  static String id = "edit_expense";

  ConsumerState<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends ConsumerState<EditExpense>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameExpenseController = TextEditingController();
  TextEditingController _expenseDescriptionController = TextEditingController();
  TextEditingController _expenseAmountController = TextEditingController();
  TextEditingController _expenseDateController = TextEditingController();
  bool _isLoading = false;
  DateTime? _selectedDate;
  ExpensesModel? _currentExpense;

  @override
  void initState(){
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async{
    try{
      final expense = await ref.read(expenseRepositoryProvider).getExpense();
      if(expense != null){
        _currentExpense = expense;
        _nameExpenseController.text = expense.expenseName;
        _expenseDescriptionController.text = expense.description;
        _selectedDate = expense.expenseDate;
        _expenseAmountController.text = expense.amount.toString();
      }
    }catch(e){
      if(mounted){
        showErrorSnackBar(context, 'Error al cargar los datos');
        print(e);
      }
    }
  }

  @override
  void dispose(){
    _nameExpenseController.dispose();
    _expenseDescriptionController.dispose();
    _expenseAmountController.dispose();
    _expenseDateController.dispose();
    super.dispose();
  }

  Future<void> _updateExpense() async {
    try {
      final updateExpense = ExpensesModel(
        idExpenses: _currentExpense?.idExpenses,
        expenseName: _nameExpenseController.text.trim(),
        description: _expenseDescriptionController.text.trim(),
        amount: double.tryParse(_expenseAmountController.text.trim())!,
        expenseDate: _selectedDate!,
      );

      await ref.read(expenseNotifierProvider.notifier).saveExpense(updateExpense);
      if(mounted){
        showSuccessSnackBar(context, 'Datos actualizados exitosamente');
        Navigator.pop(context);
      }
    }catch(e){
      if(mounted){
        showErrorSnackBar(context, 'Error al actualizar los datos');
        print(e);
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
    /*
    if(_currentExpense == null){
      return Scaffold(
        appBar: AppBar(title: Text("Editar Gasto")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    */
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
              'Editar datos de gastos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              TextFormField(
                  controller: _nameExpenseController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: "Nombre del gasto",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_basket),
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
                  }
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _expenseDescriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: "Descripcion del gasto",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_basket),
                ),
                maxLength: 30,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _expenseAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText: 'valor del gasto',
                    border: OutlineInputBorder(),
                    prefixText: "\$"
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Requerido';

                  if (double.tryParse(value) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _expenseDateController,
                readOnly: true,
                decoration: InputDecoration(
                    labelText: "Fecha del gasto",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today)
                ),
                onTap: () =>  _selectedDate!
                ,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateExpense,
                    child: _isLoading ? const CircularProgressIndicator() : const Text("Guardar")
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}