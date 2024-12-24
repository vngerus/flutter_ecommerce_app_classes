import 'package:dio/dio.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'ecommerce_event.dart';
part 'ecommerce_state.dart';

const homeUrl = "https://demoluisfelipe.firebaseio.com/adl_ecommerce";
const cartUrl = "https://demoluisfelipe.firebaseio.com/adl_ecommerce_cart_lfvq";

class EcommerceBloc extends Bloc<EcommerceEvent, EcommerceState> {
  var uuid = Uuid();
  var dio = Dio();

  EcommerceBloc() : super(EcommerceState.initial()) {
    on<LoadProductsEvent>(_onLoadProductsEvent);
    on<LoadCartItemsEvent>(_onLoadCartItemsEvent);
    on<AddToCartEvent>(_onAddToCartEvent);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantityEvent);
    on<RemoveCartItemEvent>(_onRemoveCartItemEvent);
  }

  void _onLoadProductsEvent(
      LoadProductsEvent event, Emitter<EcommerceState> emit) async {
    emit(state.copyWith(homeScreenState: HomeScreenState.loading));

    final response = await dio.get('$homeUrl.json');

    final products =
        (response.data as Map<String, dynamic>).entries.map((prod) {
      return ProductModel(
        id: prod.key,
        name: prod.value["description"],
        price: double.parse(prod.value["price"].toString()),
        imageUrl: prod.value["image_url"],
      );
    }).toList();

    // final products2 = productsJson.map((json) {
    //   return ProductModel(
    //     id: json["id"].toString(),
    //     name: json["description"],
    //     price: double.parse(json["price"].toString()),
    //     imageUrl: json["image_url"],
    //   );
    // }).toList();

    emit(state.copyWith(
      homeScreenState: HomeScreenState.success,
      products: products,
    ));
  }

  void _onLoadCartItemsEvent(
      LoadCartItemsEvent event, Emitter<EcommerceState> emit) async {
    final response = await dio.get('$cartUrl.json');

    final cartItems =
        (response.data as Map<String, dynamic>).entries.map((prod) {
      return ProductModel(
        id: prod.key,
        name: prod.value["description"],
        price: double.parse(prod.value["price"].toString()),
        imageUrl: prod.value["image_url"],
      );
    }).toList();

    emit(state.copyWith(
      cart: cartItems,
    ));
  }

  void _onAddToCartEvent(
      AddToCartEvent event, Emitter<EcommerceState> emit) async {
    String uuidProd = uuid.v1();

    await dio.put("$cartUrl/$uuidProd.json", data: {
      "id": uuidProd,
      "description": event.product.name,
      "product": "",
      "image_url": event.product.imageUrl,
      "price": event.product.price
    });

    final exist = state.cart.firstWhere(
      (p) => p.id == event.product.id,
      orElse: () => event.product.copyWith(quantity: 0),
    );

    final updateCart = state.cart.map((p) {
      if (p.id == event.product.id) {
        return p.copyWith(quantity: p.quantity + 1);
      }
      return p;
    }).toList();

    if (exist.quantity == 0) {
      updateCart.add(event.product.copyWith(quantity: 1));
    }

    emit(state.copyWith(cart: updateCart));
  }

  void _onUpdateCartQuantityEvent(
      UpdateCartQuantityEvent event, Emitter<EcommerceState> emit) {
    final updatedCart = state.cart
        .map((p) {
          if (p.id == event.product.id) {
            final newQuantity = p.quantity + event.newQty;
            if (newQuantity <= 0) return null;
            return p.copyWith(quantity: newQuantity);
          }
          return p;
        })
        .whereType<ProductModel>()
        .toList();

    emit(state.copyWith(cart: updatedCart));
  }

  void _onRemoveCartItemEvent(
      RemoveCartItemEvent event, Emitter<EcommerceState> emit) {
    final updatedCart =
        state.cart.where((p) => p.id != event.product.id).toList();

    emit(state.copyWith(cart: updatedCart));
  }
}
