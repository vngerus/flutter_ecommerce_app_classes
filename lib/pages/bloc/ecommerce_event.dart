part of 'ecommerce_bloc.dart';

sealed class EcommerceEvent extends Equatable {
  const EcommerceEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends EcommerceEvent {}

class LoadCatalogProductsEvent extends EcommerceEvent {}

class LoadCartItemsEvent extends EcommerceEvent {}

class AddToCartEvent extends EcommerceEvent {
  final ProductModel product;

  const AddToCartEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class UpdateCartQuantityEvent extends EcommerceEvent {
  final ProductModel product;
  final int newQty;

  const UpdateCartQuantityEvent({
    required this.product,
    required this.newQty,
  });

  @override
  List<Object> get props => [product, newQty];
}

class RemoveCartItemEvent extends EcommerceEvent {
  final ProductModel product;

  const RemoveCartItemEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class CreateNewProductEvent extends EcommerceEvent {
  final String description;
  final String category;
  final String imageUrl;
  final int price;

  const CreateNewProductEvent({
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.price,
  });

  @override
  List<Object> get props => [description, category, imageUrl, price];
}
