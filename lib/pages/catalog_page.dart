import 'package:ecommerce_app/pages/add_product_page.dart';
import 'package:ecommerce_app/pages/bloc/ecommerce_bloc.dart';
import 'package:ecommerce_app/widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EcommerceBloc>()..add(LoadCatalogProductsEvent()),
      child: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalog Page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPorductPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EcommerceBloc, EcommerceState>(
        builder: (context, state) {
          if (state.catalogScreenState == CatalogScreenState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.catalogProducts.isEmpty) {
            return const Center(
              child: Text("Aun no hay productos agregados."),
            );
          }

          return ListView.builder(
            itemCount: state.catalogProducts.length,
            itemBuilder: (context, index) {
              final catalogProd = state.catalogProducts[index];
              return ListTile(
                title: Text(catalogProd.name),
                subtitle: Text("\$${catalogProd.price}"),
                trailing: Image.network(catalogProd.imageUrl),
                leading: IconButton(
                  onPressed: () {
                    // TODO: metodo para eliminar
                  },
                  icon: Icon(
                    Icons.delete,
                    color: AppColor.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
