import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

class FormContainerWidget extends StatefulWidget {
  //properties
  final TextEditingController controller;
  final Key? fieldKey;
  final bool isPasswordField;
  final String hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;

  const FormContainerWidget({
    //paramaters
    Key? key,
    required this.controller,
    this.isPasswordField = false,
    this.fieldKey,
    required this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FormContainerWidgetState createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    print('Building FormContainerWidget'); // For debugging purposes
    print('Controller: ${widget.controller}');

    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          // Set a minimum and maximum height if needed
          minHeight: 40.0, // Example minimum height
          maxHeight: 50.0, // Example maximum height
        ),
        child: TextFormField(
          style: const TextStyle(color: Colors.blue),
          controller: widget.controller,
          keyboardType: widget.inputType,
          key: widget.fieldKey,
          obscureText: widget.isPasswordField == true ? _obscureText : false,
          onSaved: widget.onSaved,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: (text) {
            // For debugging purposes
            print('Input text: $text');
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(), // Add a border for testing purposes
            //border: InputBorder.none,
            filled: true,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.black45),
            // Only include the GestureDetector when isPasswordField is true
            suffixIcon: widget.isPasswordField
                ? GestureDetector(
                    onTap: () {
                      // Toggle the obscureText state
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      // Choose the icon based on the _obscureText state
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: _obscureText ? Colors.grey : Colors.blue,
                    ),
                  )
                : null, // No GestureDetector and no Icon when not a password field
          ),
        ),
      ),
    );
  }
}
