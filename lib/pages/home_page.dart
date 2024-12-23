import 'package:ecommerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:ecommerce_app/widgets/app_colors.dart';
import 'package:ecommerce_app/widgets/categories_widget.dart';
import 'package:ecommerce_app/widgets/products_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EcommerceBloc>()..add(LoadProductsEvent()),
      child: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.greyBackground,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 16,
          ),
          child: CircleAvatar(
            backgroundColor: AppColor.green,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Image(
                image: Svg('assets/icons/badge-percent.svg'),
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: SizedBox(
          width: size.width,
          child: Column(
            children: [
              Text(
                "Delivery address",
                style: TextStyle(
                  color: AppColor.greyLight,
                  fontSize: 12,
                ),
              ),
              Text(
                "92 High Street, London",
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: AppColor.greyBackground,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Image(
                image: Svg('assets/icons/bell.svg'),
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 8),
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: const Column(
          children: [
            CategoriesWidget(),
            Expanded(child: ProductWidget()),
          ],
        ),
      ),
    );
  }
}
