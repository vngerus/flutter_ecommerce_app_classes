import 'package:dio/dio.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'ecommerce_event.dart';
part 'ecommerce_state.dart';

const homeUrl =
    "https://ecommerceflutter-119f3-default-rtdb.firebaseio.com/Ecommerce";
const cartUrl =
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
  }

  /* Cargar productos desde Firebase */
  Future<void> _onLoadProductsEvent(
      LoadProductsEvent event, Emitter<EcommerceState> emit) async {
    emit(state.copyWith(homeScreenState: HomeScreenState.loading));
    try {
      final response = await dio.get('$homeUrl.json');
      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        emit(state
            .copyWith(homeScreenState: HomeScreenState.success, products: []));
        return;
      }

      final products = data.entries.map((entry) {
        final value = entry.value as Map<String, dynamic>;

        return ProductModel(
          id: entry.key,
          name: value["description"],
          price: double.tryParse(value["price"].toString()) ?? 0.0,
          imageUrl: value["image_url"],
        );
      }).toList();

      emit(state.copyWith(
          homeScreenState: HomeScreenState.success, products: products));
    } catch (e) {
      emit(state.copyWith(homeScreenState: HomeScreenState.failure));
    }
  }

  /* Cargar productos del carrito desde Firebase */
  Future<void> _onLoadCartItemsEvent(
      LoadCartItemsEvent event, Emitter<EcommerceState> emit) async {
    try {
      final response = await dio.get('$cartUrl.json');
      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        emit(state.copyWith(cart: []));
        return;
      }

      final cartItems = data.entries.map((entry) {
        final value = entry.value as Map<String, dynamic>;
        return ProductModel(
          id: value["id"],
          name: value["description"],
          price: double.tryParse(value["price"].toString()) ?? 0.0,
          imageUrl: value["image_url"],
          quantity: value["quantity"] ?? 1,
        );
      }).toList();

      emit(state.copyWith(cart: cartItems));
    } catch (e) {
      emit(state.copyWith(cart: []));
    }
  }

  /* Agregar producto al carrito */
  Future<void> _onAddToCartEvent(
      AddToCartEvent event, Emitter<EcommerceState> emit) async {
    final product = event.product;
    final existingIndex = state.cart.indexWhere((p) => p.id == product.id);

    try {
      if (existingIndex >= 0) {
        final existingProduct = state.cart[existingIndex];
        final newQuantity = existingProduct.quantity + 1;

        await dio.patch("$cartUrl/${product.id}.json",
            data: {"quantity": newQuantity});

        final updatedCart = List<ProductModel>.from(state.cart);
        updatedCart[existingIndex] =
            existingProduct.copyWith(quantity: newQuantity);

        emit(state.copyWith(cart: updatedCart));
      } else {
        await dio.put(
          "$cartUrl/${product.id}.json",
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
    } on DioException catch (_) {}
  }

  /* Actualizar cantidad de productos */
  Future<void> _onUpdateCartQuantityEvent(
      UpdateCartQuantityEvent event, Emitter<EcommerceState> emit) async {
    final product = event.product;
    final newQuantity = product.quantity + event.newQty;

    try {
      if (newQuantity > 0) {
        await dio.patch("$cartUrl/${product.id}.json",
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
    } on DioException catch (_) {}
  }

  /* Eliminar producto del carrito */
  Future<void> _onRemoveCartItemEvent(
      RemoveCartItemEvent event, Emitter<EcommerceState> emit) async {
    try {
      final product = event.product;

      final updatedCart = state.cart.where((p) => p.id != product.id).toList();

      emit(state.copyWith(cart: updatedCart));
    } catch (_) {}
  }
}
