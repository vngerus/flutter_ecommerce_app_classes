import 'dart:async';

import 'package:flutter/material.dart';

class AddPorductPage extends StatefulWidget {
  const AddPorductPage({super.key});

  @override
  State<AddPorductPage> createState() => _AddPorductPageState();
}

class _AddPorductPageState extends State<AddPorductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo producto"),
      ),
    );
  }
}
