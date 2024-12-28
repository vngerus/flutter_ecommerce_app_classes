import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:ecommerce_app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductPage extends StatefulWidget {
  final bool isEditing;
  final ProductModel? product;

  const AddProductPage({super.key, this.isEditing = false, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.product != null) {
      _descriptionController.text = widget.product!.name;
      _imageUrlController.text = widget.product!.imageUrl;
      _priceController.text = widget.product!.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? "Editar producto" : "Nuevo producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "La descripción es obligatoria";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: "URL de la imagen",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "La URL de la imagen es obligatoria";
                  }
                  if (!Uri.parse(value.trim()).isAbsolute) {
                    return "Debe ser una URL válida";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Precio",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "El precio es obligatorio";
                  }
                  final price = double.tryParse(value.trim());
                  if (price == null || price <= 0) {
                    return "Debe ser un número mayor a 0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.green,
                    foregroundColor: AppColor.black,
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isSubmitting = true;
                            });

                            try {
                              if (widget.isEditing) {
                                context.read<EcommerceBloc>().add(
                                      EditProductEvent(
                                        updatedProduct:
                                            widget.product!.copyWith(
                                          name: _descriptionController.text
                                              .trim(),
                                          imageUrl:
                                              _imageUrlController.text.trim(),
                                          price: double.tryParse(
                                                _priceController.text.trim(),
                                              ) ??
                                              0,
                                        ),
                                      ),
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Producto editado con éxito."),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                context.read<EcommerceBloc>().add(
                                      CreateNewProductEvent(
                                        description:
                                            _descriptionController.text.trim(),
                                        imageUrl:
                                            _imageUrlController.text.trim(),
                                        price: int.tryParse(
                                                _priceController.text.trim()) ??
                                            0,
                                        category: "General",
                                      ),
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Producto agregado con éxito."),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                              Navigator.pop(context);
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error: ${error.toString()}",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } finally {
                              setState(() {
                                _isSubmitting = false;
                              });
                              _resetForm();
                            }
                          }
                        },
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(widget.isEditing
                          ? "Guardar cambios"
                          : "Agregar producto"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetForm() {
    _descriptionController.clear();
    _imageUrlController.clear();
    _priceController.clear();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
