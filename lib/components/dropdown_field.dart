import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final List<String> options;
  final String hintText;
  final TextEditingController controller;

  const DropdownField({
    Key? key,
    required this.options,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedValue = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                height: 300, // Set the maximum height of the dropdown menu
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Select an option',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: widget.options
                              .map((option) => ListTile(
                                    title: Text(option),
                                    onTap: () {
                                      Navigator.pop(context, option);
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        if (selectedValue != null) {
          setState(() {
            selectedOption = selectedValue;
            widget.controller.text = selectedValue;
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14.0, // Match with TextInputField
              horizontal: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
