import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final int limit;
  final String prefixText;

  const InputWidget({
    Key? key,
    required this.limit,
    required this.prefixText,
  }) : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late TextEditingController _controller;
  final textFieldBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(
      color: Colors.black,
      width: 0.5,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "1");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // prefix text
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.prefixText,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),

          //  input field

          Expanded(
            child: SizedBox(
              height: 32,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  enabledBorder: textFieldBorder,
                  focusedBorder: textFieldBorder,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 5,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),

          // increment button
          const SizedBox(width: 10),
          InkWell(
            onTap: increment,
            child: Image.asset(
              "assets/images/increment_icon.jpg",
              width: 26,
              height: 26,
            ),
          ),

          // decrement button
          const SizedBox(width: 10),

          InkWell(
            onTap: decrement,
            child: Image.asset(
              "assets/images/decrement_icon.jpg",
              width: 26,
              height: 26,
            ),
          ),
        ],
      ),
    );
  }

  void increment() {
    if (isValidNumber()) {
      setState(() {
        // we can't increment the value above the limit
        if (widget.limit > int.parse(_controller.text)) {
          _controller.text = (int.parse(_controller.text) + 1).toString();
        }
      });
    } else {
      _controller.text = "1";
    }
  }

  void decrement() {
    if (isValidNumber()) {
      setState(() {
        // negative value are not allowed
        if (int.parse(_controller.text) > 0) {
          _controller.text = (int.parse(_controller.text) - 1).toString();
        }
      });
    } else {
      _controller.text = "1";
    }
  }

  bool isValidNumber() {
    String number = _controller.text;
    try {
      return (number == null) ? false : int.parse(number.trim()) > -1;
    } catch (exception) {
      return false;
    }
  }
}
