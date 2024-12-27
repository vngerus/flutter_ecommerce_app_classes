part of 'ecommerce_bloc.dart';

enum HomeScreenState {
  none,
  loading,
  success,
  failure,
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
    required this.catalogProducts,
    required this.homeScreenState,
    required this.catalogScreenState,
  });

  factory EcommerceState.initial() {
    return const EcommerceState(
      products: [],
      cart: [],
      catalogProducts: [],
      homeScreenState: HomeScreenState.none,
      catalogScreenState: CatalogScreenState.none,
    );
  }

  EcommerceState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? cart,
    List<ProductModel>? catalogProducts,
    HomeScreenState? homeScreenState,
    CatalogScreenState? catalogScreenState,
  }) {
    return EcommerceState(
      products: products ?? this.products,
      cart: cart ?? this.cart,
      catalogProducts: catalogProducts ?? this.catalogProducts,
      homeScreenState: homeScreenState ?? this.homeScreenState,
      catalogScreenState: catalogScreenState ?? this.catalogScreenState,
    );
  }

  @override
  List<Object> get props => [
        products,
        cart,
        catalogProducts,
        homeScreenState,
        catalogScreenState,
      ];
}
