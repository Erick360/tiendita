import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tiendita/models/image_picker_model.dart';
import 'package:tiendita/models/products_model.dart';
import '../../constants/constants.dart';
import '../../providers/products_provider.dart';
import '../../widgets/image_picker.dart';

class EditProducts extends ConsumerStatefulWidget{
    final ProductsModel? product;
    const EditProducts(this.product,{super.key});
    static String id = "edit_products";

    @override
  ConsumerState<EditProducts> createState() => _StateEditProducts();
}

class _StateEditProducts extends ConsumerState<EditProducts>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceShopController = TextEditingController();
  final TextEditingController _productPriceSalesController = TextEditingController();
  final TextEditingController _productStockController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();

  bool _isLoading = false;
  bool _isActive = true;
  DateTime? _selectedExpirationDate;
  int? _selectedCategoryId;
  String? _imageProduct;
  ProductsModel? _currentProduct;
  String? _selectedUnit;
  String? _selectedPresentation;

  final List<String> _units = ['Kilo', 'Gramo', 'Litro', 'Mililitro','Metro','Centimetro'];
  final List<String> _presentation = ['Caja', 'Saco', 'Pieza','Tira','Bolsa'];


  @override
  void initState(){
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async{
    try{
      //final product = await ref.read(productsRepositoryProvider).getProduct();
      if(widget.product != null) {
        _currentProduct = widget.product;
        _productNameController.text = widget.product!.productName;
        _selectedPresentation = widget.product!.presentation;
        _selectedUnit = widget.product!.units;
        _productPriceShopController.text = widget.product!.priceShop.toString();
        _productPriceSalesController.text =
            widget.product!.priceSale.toString();
        _productStockController.text = widget.product!.stock.toString();
        _isActive = widget.product!.status == 1;
        _imageProduct = widget.product!.productImage;
        _selectedExpirationDate = widget.product!.productExpiresAt;
        _selectedCategoryId = widget.product!.idCategory;

        if (_selectedExpirationDate != null) {
          _expirationDateController.text = DateFormat('dd/MM/yyyy').format(_selectedExpirationDate!);
        }
      }

    }catch(e){
      if(mounted){
        showErrorSnackBar(context, 'Error al cargar los datos');
        print(e);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpirationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child){
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
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
        _expirationDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void dispose(){
    _productNameController.dispose();
    _productPriceShopController.dispose();
    _productPriceSalesController.dispose();
    _productStockController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct()  async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isLoading = true;
    });

    try{
      final updateProduct = ProductsModel(
          idProduct: _currentProduct!.idProduct,
          productName: _productNameController.text.trim(),
          presentation: _selectedPresentation,
          units: _selectedUnit,
          priceShop: double.tryParse(_productPriceShopController.text.trim()),
          priceSale: double.tryParse(_productPriceSalesController.text.trim()),
          stock: int.parse(_productStockController.text.trim()),
          status: _isActive ? 1 : 0,
          productImage: _imageProduct,
          productExpiresAt: _selectedExpirationDate,
          idCategory: _selectedCategoryId
      );

      await ref.read(productsNotifierProvider.notifier).saveProduct(updateProduct);
      if(mounted){
        showSuccessSnackBar(context, 'Producto actualizado exitosamente');
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
    final categoryList = ref.watch(categoriesListProvider);
    if(_currentProduct == null){
        return Scaffold(
          appBar: AppBar(title: Text("Editar Producto")),
          body: Center(child: CircularProgressIndicator()),
        );
    }
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
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Presentación (ej. Caja, Pieza, Saco)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  initialValue: _selectedPresentation,
                  items: _presentation.map((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedPresentation = newValue;
                    });
                  },
                  validator: (value){
                    if(value == null){
                      return "Por favor seleccione una opcion";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Unidad de medida (ej. Kilo ,litro ,Gramo)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  initialValue: _selectedUnit,
                  items: _units.map((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedUnit = newValue;
                    });
                  },
                  validator: (value){
                    if(value == null){
                      return "Por favor seleccione una opcion";
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
                    labelText: "Fecha de caducidad (Opcional)",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                    suffixIcon: _selectedExpirationDate != null
                        ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _selectedExpirationDate = null;
                          _expirationDateController.clear();
                        });
                      },
                    )
                        : null,
                  ),
                  onTap: () {
                    _selectDate(context);
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
                  model: ImagePickerModel(
                  initialImage: _imageProduct,
                  onImageSelected: (path){
                    setState(() {
                      _imageProduct = path;
                    });
                  },
                  label: "Imagen del producto",
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _updateProduct,
                    icon: _isLoading ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ) : const Icon(Icons.save),
                    label: Text(_isLoading ? 'Guardando...' : 'Guardar Cambios'),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

}
