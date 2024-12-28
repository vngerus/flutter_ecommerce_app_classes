import 'package:dio/dio.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'ecommerce_event.dart';
part 'ecommerce_state.dart';

const baseUrl =
    "https://ecommerceflutter-119f3-default-rtdb.firebaseio.com/Ecommerce";

class EcommerceBloc extends Bloc<EcommerceEvent, EcommerceState> {
  final Dio dio;
  final Uuid uuid;

  EcommerceBloc({Dio? dioInstance, Uuid? uuidInstance})
      : dio = dioInstance ?? Dio(),
        uuid = uuidInstance ?? Uuid(),
        super(EcommerceState.initial()) {
    on<LoadProductsEvent>(_onLoadProductsEvent);
    on<LoadCartItemsEvent>(_onLoadCartItemsEvent);
    on<AddToCartEvent>(_onAddToCartEvent);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantityEvent);
    on<RemoveCartItemEvent>(_onRemoveCartItemEvent);
    on<LoadCatalogProductsEvent>(_onLoadCatalogProductsEvent);
    on<CreateNewProductEvent>(_onCreateNewProductEvent);
    on<EditProductEvent>(_onEditProductEvent);
  }

  Future<void> _onLoadProductsEvent(
      LoadProductsEvent event, Emitter<EcommerceState> emit) async {
    emit(state.copyWith(homeScreenState: HomeScreenState.loading));
    try {
      final response = await dio.get('$baseUrl.json');
      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        emit(state
            .copyWith(homeScreenState: HomeScreenState.success, products: []));
        return;
      }

      final products = data.entries
          .map((entry) {
            final value = entry.value as Map<String, dynamic>;
            return ProductModel(
              id: entry.key,
              name: value["description"] ?? "",
              price: double.tryParse(value["price"]?.toString() ?? "0") ?? 0.0,
              imageUrl: value["image_url"] ?? "",
            );
          })
          .where((product) => product.name.isNotEmpty && product.price > 0)
          .toList();

      emit(state.copyWith(
          homeScreenState: HomeScreenState.success, products: products));
    } catch (_) {
      emit(state.copyWith(homeScreenState: HomeScreenState.failure));
    }
  }

  Future<void> _onLoadCartItemsEvent(
      LoadCartItemsEvent event, Emitter<EcommerceState> emit) async {
    try {
      final response = await dio.get('$baseUrl/cart.json');
      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        emit(state.copyWith(cart: []));
        return;
      }

      final cartItems = data.entries
          .map((entry) {
            final value = entry.value as Map<String, dynamic>;
            return ProductModel(
              id: value["id"] ?? "",
              name: value["description"] ?? "",
              price: double.tryParse(value["price"]?.toString() ?? "0") ?? 0.0,
              imageUrl: value["image_url"] ?? "",
              quantity: value["quantity"] ?? 1,
            );
          })
          .where((product) => product.name.isNotEmpty && product.price > 0)
          .toList();

      emit(state.copyWith(cart: cartItems));
    } catch (_) {
      emit(state.copyWith(cart: []));
    }
  }

  Future<void> _onAddToCartEvent(
      AddToCartEvent event, Emitter<EcommerceState> emit) async {
    final product = event.product;
    if (product.name.isEmpty ||
        product.price <= 0 ||
        product.imageUrl.isEmpty) {
      return;
    }

    final existingIndex = state.cart.indexWhere((p) => p.id == product.id);

    try {
      if (existingIndex >= 0) {
        final existingProduct = state.cart[existingIndex];
        final newQuantity = existingProduct.quantity + 1;

        await dio.patch("$baseUrl/cart/${product.id}.json",
            data: {"quantity": newQuantity});

        final updatedCart = List<ProductModel>.from(state.cart);
        updatedCart[existingIndex] =
            existingProduct.copyWith(quantity: newQuantity);

        emit(state.copyWith(cart: updatedCart));
      } else {
        await dio.put(
          "$baseUrl/cart/${product.id}.json",
          data: {
            "id": product.id,
            "description": product.name,
            "image_url": product.imageUrl,
            "price": product.price,
            "quantity": 1,
          },
        );

        emit(state.copyWith(cart: [...state.cart, product]));
      }
    } catch (_) {}
  }

  Future<void> _onUpdateCartQuantityEvent(
      UpdateCartQuantityEvent event, Emitter<EcommerceState> emit) async {
    final product = event.product;
    final newQuantity = product.quantity + event.newQty;

    try {
      if (newQuantity > 0) {
        await dio.patch("$baseUrl/cart/${product.id}.json",
            data: {"quantity": newQuantity});

        final updatedCart = state.cart.map((p) {
          if (p.id == product.id) {
            return p.copyWith(quantity: newQuantity);
          }
          return p;
        }).toList();

        emit(state.copyWith(cart: updatedCart));
      } else {
        final updatedCart =
            state.cart.where((p) => p.id != product.id).toList();
        emit(state.copyWith(cart: updatedCart));
      }
    } catch (_) {}
  }

  Future<void> _onRemoveCartItemEvent(
      RemoveCartItemEvent event, Emitter<EcommerceState> emit) async {
    try {
      final product = event.product;

      final updatedCart = state.cart.where((p) => p.id != product.id).toList();

      emit(state.copyWith(cart: updatedCart));
    } catch (_) {}
  }

  Future<void> _onLoadCatalogProductsEvent(
      LoadCatalogProductsEvent event, Emitter<EcommerceState> emit) async {
    emit(state.copyWith(catalogScreenState: CatalogScreenState.loading));
    try {
      final response = await dio.get('$baseUrl.json');
      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        emit(state.copyWith(
            catalogScreenState: CatalogScreenState.success,
            catalogProducts: []));
        return;
      }

      final catalogProducts = data.entries
          .map((prod) {
            final value = prod.value as Map<String, dynamic>;
            return ProductModel(
              id: prod.key,
              name: value["description"] ?? "",
              price: double.tryParse(value["price"]?.toString() ?? "0") ?? 0.0,
              imageUrl: value["image_url"] ?? "",
            );
          })
          .where((product) => product.name.isNotEmpty && product.price > 0)
          .toList();

      emit(state.copyWith(
        catalogScreenState: CatalogScreenState.success,
        catalogProducts: catalogProducts,
      ));
    } catch (_) {
      emit(state.copyWith(catalogScreenState: CatalogScreenState.failure));
    }
  }

  Future<void> _onCreateNewProductEvent(
      CreateNewProductEvent event, Emitter<EcommerceState> emit) async {
    try {
      if (event.description.isEmpty ||
          event.imageUrl.isEmpty ||
          event.price <= 0) {
        return;
      }

      final String prodUID = uuid.v1();

      final data = {
        "id": prodUID,
        "description": event.description,
        "image_url": event.imageUrl,
        "price": event.price,
      };

      await dio.put("$baseUrl/$prodUID.json", data: data);

      final newProduct = ProductModel(
        id: prodUID,
        name: event.description,
        price: double.parse(event.price.toString()),
        imageUrl: event.imageUrl,
      );

      emit(state.copyWith(
        catalogProducts: [...state.catalogProducts, newProduct],
      ));
    } catch (_) {
      emit(state.copyWith(catalogScreenState: CatalogScreenState.failure));
    }
  }

  Future<void> _onEditProductEvent(
      EditProductEvent event, Emitter<EcommerceState> emit) async {
    try {
      final updatedProduct = event.updatedProduct;

      await dio.patch(
        "$baseUrl/${updatedProduct.id}.json",
        data: {
          "description": updatedProduct.name,
          "image_url": updatedProduct.imageUrl,
          "price": updatedProduct.price,
        },
      );

      final updatedCatalog = state.catalogProducts.map((product) {
        if (product.id == updatedProduct.id) {
          return updatedProduct;
        }
        return product;
      }).toList();

      emit(state.copyWith(catalogProducts: updatedCatalog));
    } catch (_) {
      emit(state.copyWith(catalogScreenState: CatalogScreenState.failure));
    }
  }
}
