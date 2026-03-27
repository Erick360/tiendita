import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiendita/constants/constants.dart';
import 'package:tiendita/models/products_model.dart';
import 'package:tiendita/providers/products_provider.dart';
import '../../widgets/image_picker.dart';

class CreateProducts extends ConsumerStatefulWidget{
  const CreateProducts({super.key});
  static String id = "create_products";

  @override
  ConsumerState<CreateProducts> createState() => _StateCreateProducts();
}

class _StateCreateProducts extends ConsumerState<CreateProducts>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _productPresentationController = TextEditingController();
  TextEditingController _productPriceShopController = TextEditingController();
  TextEditingController _productPriceSalesController = TextEditingController();
  TextEditingController _productStockController = TextEditingController();
  TextEditingController _productUnitsController = TextEditingController();
  TextEditingController _productLocalCoinController = TextEditingController();
  TextEditingController _expirationDateController = TextEditingController();

  bool _isLoading = false;
  bool _isActive = true;
  DateTime? _selectedExpirationDate;
  int? _selectedCategoryId;
  String? _imageProduct;

  void dispose(){
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _productPresentationController.dispose();
    _productPriceShopController.dispose();
    _productPriceSalesController.dispose();
    _productStockController.dispose();
    _productUnitsController.dispose();
    _productLocalCoinController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct()  async{
  if (_formKey.currentState?.validate() != true) return;
  setState(() {
    _isLoading = true;
  });

    try{
      final product = ProductsModel(
          productName: _productNameController.text.trim(),
          presentation: _productPresentationController.text.trim(),
          units:  _productUnitsController.text.trim(),
          //coin: _productLocalCoinController.text.trim().isEmpty? null : _productLocalCoinController.text.trim(),
          priceShop: double.tryParse(_productPriceShopController.text.trim()),
          priceSale: double.tryParse(_productPriceSalesController.text.trim()),
          stock: int.tryParse(_productStockController.text.trim()),
          status: _isActive ? 1 : 0,
          productImage: _imageProduct,
          productExpiresAt: _selectedExpirationDate,
          idCategory: _selectedCategoryId

      );

      await ref.read(productsNotifierProvider.notifier).saveProduct(product);
      if(mounted){
        showSuccessSnackBar(context, 'Producto guardado exitosamente');
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

    if(picked != null && picked != _selectedExpirationDate){
      setState(() {
        _selectedExpirationDate = picked;

        _expirationDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }


  @override
  Widget build(BuildContext context){
    final categoryList = ref.watch(categoriesListProvider);
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
              'Ingresar Productos',
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
                children: <Widget>[
                  TextFormField(
                    controller: _productNameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: "Nombre del producto",
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
                  const SizedBox(height: 15),
                  categoryList.when(
                      data: (categories){
                        if(categories.isEmpty){
                          return const Center(child: Text("No hay categorias registradas", style: TextStyle(color: Colors.red)));
                        }
                        return DropdownButtonFormField<int>(
                            initialValue: _selectedCategoryId,
                            decoration: const InputDecoration(
                              labelText: "Categoria",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.category)
                            ),
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                value: category?.idCategory,
                                  child: Text("${category!.CategoryName}"),
                              );
                            }).toList(),
                            onChanged: (int? value){
                              setState(() {
                                _selectedCategoryId = value;
                              });
                            },
                          validator: (value){
                              if(value == null){
                                return "Por favor seleccione una categoria";
                              }
                              return null;
                          },
                        );
                      },
                      error: (e, stack) => Text("Error al cargar datos: $e"),
                      loading: () => const Center(child: CircularProgressIndicator())
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _productPresentationController,
                    decoration: InputDecoration(
                      labelText: 'Presentación (ej. Caja, Pieza, Saco)',
                      border: OutlineInputBorder()
                    ),
                      maxLength: 20,
                      validator: (value) {
                        if (value == null || value
                            .trim()
                            .isEmpty) {
                          return 'Este campo necesita llenarse';
                        }
                        return null;
                      },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _productUnitsController,
                    decoration: InputDecoration(
                        labelText: 'Unidad de medida (ej. Kilo ,litro ,Gramo)',
                        border: OutlineInputBorder()
                    ),
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return 'Este campo necesita llenarse';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _productPriceShopController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Precio de compra *',
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
                    controller: _productPriceSalesController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        labelText: 'Precio de venta *',
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
                    controller: _expirationDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Fecha de caducidad",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today)
                    ),
                    onTap: (){
                      _selectDate(context);
                    },
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Seleccione una fecha de caducidad';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  SwitchListTile(
                    title: const Text("Estado del producto", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        _isActive ? 'Activo (Visible para venta)' : 'Inactivo (Producto no disponible)',
                        style: TextStyle(color: _isActive ? Colors.green : Colors.red),
                      ),
                      activeThumbColor: kActiveColor,
                      value: _isActive,
                      onChanged: (bool value){
                          setState(() {
                            _isActive = value;
                          });
                      },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _productStockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stock Inicial *',
                      prefixIcon: Icon(Icons.inventory),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Requerido';

                      if (int.tryParse(value) == null) return 'Ingrese un número entero';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  ImagePicker(
                    initialImage: _imageProduct,
                    onImageSelected: (path){
                      setState(() {
                        _imageProduct = path;
                      });
                    },
                    label: "Imagen del producto",
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProduct,
                        child: _isLoading ? const CircularProgressIndicator() : const Text("Guardar")
                    ),
                  )
                ],
              ),
          )
      ),
    );
  }
}