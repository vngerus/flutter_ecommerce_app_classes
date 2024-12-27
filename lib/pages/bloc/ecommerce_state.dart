part of 'ecommerce_bloc.dart';

enum HomeScreenState {
  none,
  loading,
  success,
  failure,
  error,
}

enum CatalogScreenState {
  none,
  loading,
  success,
  failure,
}

class EcommerceState extends Equatable {
  final List<ProductModel> products;
  final List<ProductModel> cart;
  final List<ProductModel> catalogProducts;
  final HomeScreenState homeScreenState;
  final CatalogScreenState catalogScreenState;

  const EcommerceState({
    required this.products,
    required this.cart,
    required this.homeScreenState,
    required this.catalogProducts,
    required this.catalogScreenState,
  });

  factory EcommerceState.initial() {
    return const EcommerceState(
      products: [],
      cart: [],
      homeScreenState: HomeScreenState.none,
      catalogProducts: [],
      catalogScreenState: CatalogScreenState.none,
    );
  }

  EcommerceState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? cart,
    HomeScreenState? homeScreenState,
    List<ProductModel>? catalogProducts,
    CatalogScreenState? catalogScreenState,
  }) {
    return EcommerceState(
      products: products ?? this.products,
      cart: cart ?? this.cart,
      homeScreenState: homeScreenState ?? this.homeScreenState,
      catalogProducts: catalogProducts ?? this.catalogProducts,
      catalogScreenState: catalogScreenState ?? this.catalogScreenState,
    );
  }

  @override
  List<Object> get props => [
        products,
        cart,
        homeScreenState,
        catalogProducts,
        catalogScreenState,
      ];
}
