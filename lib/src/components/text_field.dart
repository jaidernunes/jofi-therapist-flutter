import 'package:flutter/material.dart';

class TextFieldComponent extends StatefulWidget {
  final String placeholder;
  final String value;
  final bool multiline;
  final String type;
  final bool disabled;
  final ValueChanged<String> handleChange;
  final ValueChanged<String> handleBlur;
  final Function(bool) showDateModal;

  const TextFieldComponent({
    Key? key,
    required this.placeholder,
    required this.value,
    required this.multiline,
    required this.type,
    required this.disabled,
    required this.handleChange,
    required this.handleBlur,
    required this.showDateModal,
  }) : super(key: key);

  @override
  _TextFieldComponentState createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.multiline ? 75 : 42,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.disabled
              ? Colors.red
              : const Color(
                  0xFF4F4F4F,
                ),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: widget.placeholder,
        ),
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        controller: TextEditingController(
          text: widget.value,
        ),
        maxLines: widget.multiline ? null : 1,
        onTap: () {
          if (widget.type == 'date') {
            widget.showDateModal(true);
          }
        },
        showCursor: widget.type != 'date',
        readOnly: widget.type == 'date',
        onChanged: widget.handleChange,
        focusNode: _focusNode,
      ),
    );
  }
}
