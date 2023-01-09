// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget({
    super.key,required this.hintText,
    required this.textEditingController,
    required this.validator,
    this.read_only =false
    });
  String hintText;
  TextEditingController textEditingController;
  final String? Function(String? val) validator;
  bool read_only ;
  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.read_only,
      controller: widget.textEditingController,
      validator: widget.validator,
      decoration: InputDecoration(
              hintText: widget.hintText),
    );
  }
}