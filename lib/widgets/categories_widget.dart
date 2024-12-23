import 'package:ecommerce_app/widgets/app_colors.dart';
import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          categoryHeader(),
          Expanded(child: categoryListItems()),
        ],
      ),
    );
  }

  Widget categoryHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Categories",
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Text(
            "See all",
            style: TextStyle(
              color: AppColor.greyLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryListItems() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: AppColor.greyBackground,
                radius: 21,
              ),
              Text(
                "Phones",
                style: TextStyle(
                  color: AppColor.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
