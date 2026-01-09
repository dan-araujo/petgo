import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationCodeInput extends StatefulWidget {
  final Function(String) onChanged;
  final int codeLength;
  final Color borderColor;
  final Color textColor;

  const VerificationCodeInput({
    super.key,
    required this.onChanged,
    this.codeLength = 6,
    this.borderColor = const Color(0xFF208B8D),
    this.textColor = const Color(0x8A000000),
  });

  @override
  State<StatefulWidget> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  late List<FocusNode> _focusNode;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNode = List.generate(widget.codeLength, (i) => FocusNode());
    _controllers = List.generate(
      widget.codeLength,
      (i) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNode) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleInput(String value, int index) {
    if (value.isEmpty) {
      if (index > 0) {
        _focusNode[index - 1].requestFocus();
      }
    } else {
      if (index < widget.codeLength - 1) {
        _focusNode[index + 1].requestFocus();
      } else {
        _focusNode[index].unfocus();
      }
    }

    final fullCode = _controllers.map((c) => c.text).join();
    widget.onChanged(fullCode);
  }

  String getCode() {
    return _controllers.map((c) => c.text).join();
  }

  void clear() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNode[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.codeLength,
        (index) => SizedBox(
          width: 50,
          height: 60,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNode[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.borderColor, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.borderColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
            onChanged: (value) => _handleInput(value, index),
          ),
        ),
      ),
    );
  }
}
