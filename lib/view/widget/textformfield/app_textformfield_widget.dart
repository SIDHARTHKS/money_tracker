// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import '../../../helper/color_helper.dart';
import '../common_widget.dart';
import '../text/app_text.dart';

class TextFormWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? nextFocusNode;
  final VoidCallback? onFieldSubmitted;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool optional;
  final FocusNode? focusNode;
  final bool enabled;
  final Function(String)? onTextChanged;
  final Function(String)? onChanged;
  final IconData? prefixIcon;
  final String? prefixText;
  Color? prefixIconColor;
  final IconData? suffixIcon;
  final String? suffixText;
  final VoidCallback? suffixIconPressed;
  final bool readOnly;
  final TextAlign textAlign;
  Color? textColor;
  final bool obscureText;
  final VoidCallback? onSampleClicked;
  final double? height;
  final bool digitsOnly;
  final VoidCallback? onClickcallback;
  final VoidCallback? ontap;
  final Color? borderColor;
  final bool showcursor;
  final Widget? prefixIconWidget;
  final List<TextInputFormatter>? inputFormatters; // NEW

  TextFormWidget({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.optional = false,
    this.enabled = true,
    this.focusNode,
    this.onTextChanged,
    this.onChanged,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.suffixIconPressed,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.onSampleClicked,
    this.height,
    this.digitsOnly = false,
    this.obscureText = false,
    this.onClickcallback,
    this.ontap,
    this.borderColor,
    this.prefixIconWidget,
    this.inputFormatters, // NEW
    this.showcursor = true,
  }) {
    textColor = AppColorHelper().textColor;
    prefixIconColor = AppColorHelper().iconColor;
  }

  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  late bool _obscureText;
  List<bool> passwordConditions = [false, false, false, false];

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  void checkPasswordConditions(String password) {
    setState(() {
      passwordConditions[0] = password.length >= 8;
      passwordConditions[1] = RegExp(r'[A-Z]').hasMatch(password);
      passwordConditions[2] = RegExp(r'[0-9]').hasMatch(password);
      passwordConditions[3] =
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              children: [],
            ),
          ),
          _textFormField(
            decoration: _normalFieldDecoration(),
            context: context,
            newMaxlength: widget.maxLength,
          ),
        ],
      );

  InputDecoration _normalFieldDecoration() => InputDecoration(
        labelText: widget.label,
        labelStyle: textStyle(14, AppColorHelper().textColor, FontWeight.w500),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: _border(
            color:
                widget.borderColor ?? AppColorHelper().pwdFormFieldBorderColor),
        counterText: '',
        enabledBorder: _border(
            color:
                widget.borderColor ?? AppColorHelper().pwdFormFieldBorderColor),
        errorBorder: _border(color: AppColorHelper().errorBorderColor),
        focusedBorder: _border(color: AppColorHelper().focusedBorderColor),
        errorStyle: textStyle(14, AppColorHelper().errorColor, FontWeight.w300),
        contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
        suffixIcon: _getSuffixIcon(),
        prefixIcon: _getPrefixIcon(),
      );

  Widget _textFormField({
    required InputDecoration decoration,
    required BuildContext context,
    int? newMaxlength,
  }) {
    List<TextInputFormatter>? effectiveInputFormatters = widget.inputFormatters;

    if (widget.digitsOnly && effectiveInputFormatters == null) {
      effectiveInputFormatters = [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(widget.maxLength ?? 200),
      ];
    }

    Widget child = TextFormField(
      showCursor: widget.showcursor,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      focusNode: widget.focusNode,
      controller: widget.controller,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: newMaxlength,
      decoration: decoration,
      validator: widget.validator,
      textAlign: widget.textAlign,
      style: TextStyle(color: widget.textColor),
      maxLengthEnforcement: MaxLengthEnforcement.none,
      textInputAction: widget.nextFocusNode != null
          ? TextInputAction.next
          : TextInputAction.done,
      inputFormatters: effectiveInputFormatters,
      onChanged: (value) {
        debouncer.call(() {
          if (widget.onTextChanged != null) widget.onTextChanged!(value);
          if (widget.onChanged != null) widget.onChanged!(value);
          checkPasswordConditions(value);
        });
      },
      onFieldSubmitted: (_) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
        widget.onFieldSubmitted ?? ();
      },
    );

    return widget.height != null
        ? SizedBox(height: widget.height, child: child)
        : child;
  }

  Widget? _getSuffixIcon() {
    if (widget.suffixText != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 20),
        child: GestureDetector(
          onTap: widget.ontap,
          child: appText(
            widget.suffixText!,
            color: AppColorHelper().textColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    return widget.suffixIcon != null
        ? IconButton(
            icon: Icon(widget.suffixIcon, color: AppColorHelper().iconColor),
            onPressed: widget.suffixIconPressed,
          )
        : null;
  }

  Widget? _getPrefixIcon() {
    if (widget.prefixIconWidget != null) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: 10,
          width: 10,
          child: widget.prefixIconWidget,
        ),
      );
    }

    if (widget.prefixText != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 20),
        child: GestureDetector(
          onTap: widget.ontap,
          child: appText(
            widget.prefixText!,
            color: AppColorHelper().textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return widget.prefixIcon != null
        ? Icon(widget.prefixIcon, color: widget.prefixIconColor)
        : null;
  }

  OutlineInputBorder _border({required Color color}) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1.2),
        borderRadius: BorderRadius.circular(8), // optional: rounded corners
      );
}
