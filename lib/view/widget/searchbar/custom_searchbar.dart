import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/core/environment/env.dart';
import '../../../helper/enum.dart';
import '../text/app_text.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? action;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmit,
    this.validator,
    this.action,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButton);
  }

  void _updateClearButton() {
    setState(() {
      showClear = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButton);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = AppEnvironment.deviceType == UserDeviceType.tablet;
    return SizedBox(
      child: TextFormField(
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onFieldSubmitted: widget.onSubmit,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          fillColor: AppColorHelper().backgroundColor,
          hintText: widget.hintText.tr,
          hintStyle: textStyle(
            isTablet ? 18 : 14,
            AppColorHelper().primaryTextColor.withOpacity(0.5),
            FontWeight.w400,
          ),
          prefixIcon: null,
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //   child: Image.asset(
          //     Assets.icons.search.path,
          //     width: 20,
          //     height: 20,
          //     color: AppColorHelper().primaryTextColor.withValues(alpha: 0.4),
          //   ),
          // ),
          suffixIcon: showClear
              ? GestureDetector(
                  onTap: () {
                    widget.controller.clear();
                    widget.onChanged?.call('');
                    widget.action?.call('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColorHelper().primaryTextColor.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppColorHelper().borderColor.withOpacity(0.9),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppColorHelper().borderColor.withOpacity(0.9),
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppColorHelper().borderColor.withOpacity(0.3),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
