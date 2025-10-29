import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_color.dart';

class VerifyCodeField extends StatefulWidget {
  final int length;
  final void Function(String code)? onCompleted;

  const VerifyCodeField({super.key, this.length = 4, this.onCompleted});

  @override
  State<VerifyCodeField> createState() => _VerifyCodeFieldState();
}

class _VerifyCodeFieldState extends State<VerifyCodeField> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  late List<bool> filledStatus; // ✅ لتتبع الفيلد اللي فيه رقم

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.length, (index) => TextEditingController());
    focusNodes = List.generate(widget.length, (index) => FocusNode());
    filledStatus = List.generate(widget.length, (index) => false);
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    setState(() {
      filledStatus[index] = value.isNotEmpty; // ✅ تحديث حالة الخانة
    });

    // لو كتب رقم → يروح للِّي بعدها
    if (value.isNotEmpty && index < widget.length - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }

    // لو مسح الرقم → يرجع للّي قبله
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }

    // التحقق لو الكود اكتمل
    final code = controllers.map((e) => e.text).join();
    if (code.length == widget.length && !code.contains('')) {
      widget.onCompleted?.call(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
            (index) => SizedBox(
          width: 60,
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLines: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColor.grey2Color,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.grey2Color),
              ),
              // ✅ لو الفيلد عليه فوكس أو مكتوب فيه رقم → يكون بلون الفوكس
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.greenColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: (focusNodes[index].hasFocus || filledStatus[index])
                      ? AppColor.greenColor
                      : AppColor.grey2Color,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) => _onChanged(value, index),
          ),
        ),
      ),
    );
  }
}