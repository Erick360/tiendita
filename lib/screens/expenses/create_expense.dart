import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/models/expenses_model.dart';
import '../../constants/constants.dart';
import '../../providers/expenses_provider.dart';

class CreateExpense extends ConsumerStatefulWidget{
  const CreateExpense({super.key});
  static String id = "create_expense";

  @override
  ConsumerState<CreateExpense> createState() => _CreateExpenseState();
}

class _CreateExpenseState extends ConsumerState<CreateExpense>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameExpenseController = TextEditingController();
  TextEditingController _expenseDescriptionController = TextEditingController();
  TextEditingController _expenseAmountController = TextEditingController();
  TextEditingController _expenseDateController = TextEditingController();
  bool _isLoading = false;
  DateTime? _selectedDate;

  void dispose(){
    _nameExpenseController.dispose();
    _expenseDescriptionController.dispose();
    _expenseAmountController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async{
    if (_formKey.currentState?.validate() != true) return;
    setState(() {
      _isLoading = true;
    });

    try{
      final expense = ExpensesModel(
          expenseName: _nameExpenseController.text.trim(),
          amount: double.parse(_expenseAmountController.text.trim()),
          expenseDate: _selectedDate ?? DateTime.now(),
          description: _expenseDescriptionController.text.trim().isEmpty ? '...' : _expenseDescriptionController.text.trim(),
      );

      await ref.read(expenseNotifierProvider.notifier).saveExpense(expense);
      if(mounted){
        showSuccessSnackBar(context, 'Gasto guardado exitosamente');
        Navigator.pop(context);
      }
    }catch(e){
      if(mounted){
        showErrorSnackBar(context, 'Error al guardar los datos');
        print("Error al guardar los datos $e");
      }
    }finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child){
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: kActiveColor,
              ),
            ),
            child: child!
        );
      },
    );

    if(picked != null && picked != _selectedDate){
      setState(() {
        _selectedDate = picked;

        _expenseDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }


  @override
  Widget build(BuildContext context){
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
              'Ingresar Gastos',
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
                  onTap: (){
                    _selectDate(context);
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveExpense,
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