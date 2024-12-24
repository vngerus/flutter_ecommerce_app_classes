import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:ecommerce_app/widgets/app_colors.dart';
import 'package:ecommerce_app/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EcommerceBloc()..add(LoadCartItemsEvent()),
      child: const CartBody(),
    );
  }
}

class CartBody extends StatelessWidget {
  const CartBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Cart",
          style: TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            color: AppColor.black,
            focusColor: AppColor.greyBackground,
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: AppPrimaryButton(
          onTap: () {},
          text: 'Checkout',
        ),
      ),
      body: BlocBuilder<EcommerceBloc, EcommerceState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.cart.length,
            itemBuilder: (context, index) {
              if (state.cart.isEmpty) {
                return const SizedBox.shrink();
              }
              final product = state.cart[index];

              return _buildCardItem(context, product);
            },
          );
        },
      ),
    );
  }

  _buildCardItem(BuildContext context, ProductModel product) {
    return Container(
      height: 138,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context
                  .read<EcommerceBloc>()
                  .add(RemoveCartItemEvent(product: product));
            },
            icon: Icon(
              Icons.delete,
              color: AppColor.red,
            ),
          ),
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.greyBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(product.imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price * product.quantity}",
                        style: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<EcommerceBloc>().add(
                                    UpdateCartQuantityEvent(
                                      product: product,
                                      newQty: -1,
                                    ),
                                  );
                            },
                            icon: Icon(
                              Icons.remove,
                              color: AppColor.black,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: Center(
                              child: Text(product.quantity.toString()),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<EcommerceBloc>().add(
                                    UpdateCartQuantityEvent(
                                      product: product,
                                      newQty: 1,
                                    ),
                                  );
                            },
                            icon: Icon(
                              Icons.add,
                              color: AppColor.black,
                              size: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
