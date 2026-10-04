import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// خانات OTP منفصلة (6 خانات) — الإدخال دائماً من اليسار إلى اليمين.
class OtpBoxes extends StatefulWidget {
  const OtpBoxes({
    Key? key,
    required this.length,
    required this.onChanged,
    this.onCompleted,
    this.enabled = true,
    this.hideDigits = false,
    this.focusNode,
  }) : super(key: key);

  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool enabled;
  final bool hideDigits;
  final FocusNode? focusNode;

  @override
  State<OtpBoxes> createState() => OtpBoxesState();
}

class OtpBoxesState extends State<OtpBoxes> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late List<String> _digits;

  @override
  void initState() {
    super.initState();
    _digits = List.filled(widget.length, '');
    _controller = TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  String get code => _digits.join();

  void clear() {
    _digits = List.filled(widget.length, '');
    _controller.clear();
    widget.onChanged('');
    setState(() {});
    _focusNode.requestFocus();
  }

  void _onText(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'\D'), '');
    final clipped = cleaned.length > widget.length
        ? cleaned.substring(0, widget.length)
        : cleaned;
    _digits = List.filled(widget.length, '');
    for (var i = 0; i < clipped.length; i++) {
      _digits[i] = clipped[i];
    }
    if (_controller.text != clipped) {
      _controller.value = TextEditingValue(
        text: clipped,
        selection: TextSelection.collapsed(offset: clipped.length),
      );
    }
    widget.onChanged(clipped);
    if (clipped.length == widget.length) {
      widget.onCompleted?.call(clipped);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final filledCount = _digits.where((d) => d.isNotEmpty).length;

    // إجبار LTR مهما كانت لغة التطبيق (عربي RTL).
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: widget.enabled ? () => _focusNode.requestFocus() : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0,
              child: SizedBox(
                height: 1,
                width: 1,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  onChanged: _onText,
                ),
              ),
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.length, (i) {
                final active = widget.enabled && filledCount == i;
                final filled = _digits[i].isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: widget.length >= 6 ? 46 : 58,
                  height: widget.length >= 6 ? 56 : 64,
                  margin: EdgeInsets.symmetric(
                      horizontal: widget.length >= 6 ? 4 : 8),
                  decoration: BoxDecoration(
                    color: filled
                        ? primary.withOpacity(0.06)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: active
                          ? primary
                          : filled
                              ? primary.withOpacity(0.45)
                              : Colors.grey.shade300,
                      width: active ? 2.2 : 1.4,
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: primary.withOpacity(0.22),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: widget.hideDigits && filled ? 0 : 1,
                    child: Text(
                      filled ? _digits[i] : '',
                      textDirection: TextDirection.ltr,
                      style: GoogleFonts.cairo(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
