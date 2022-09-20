import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form/flutter_form.dart';

import 'package:flutter_form/next_shell/translation_service.dart';

import 'carousel_form.dart';

/// Input for a carousel of items used in a [ShellForm].
///
/// [items] will be the [Widget]s to be displayed in the carousel.
///
/// Standard controller is [ShellFormInputCarouselController].
class ShellFormInputCarousel extends ShellFormInputWidget {
  const ShellFormInputCarousel({
    Key? key,
    required ShellFormInputController controller,
    Widget? label,
    required this.items,
  }) : super(key: key, controller: controller, label: label);

  final List<Widget> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String Function(String, {List<String>? params}) _ =
        getTranslator(context, ref);

    super.registerController(context);

    return CarouselFormField(
      onSaved: (value) => controller.onSaved(value),
      validator: (value) => controller.onValidate(value, _),
      initialValue: controller.value ?? 0,
      items: items,
    );
  }
}

/// Controller for the carousel used by a [ShellFormInputWidget] used in a [ShellForm].
///
/// Mainly used by [ShellFormInputCarousel].
class ShellFormInputCarouselController
    implements ShellFormInputController<int> {
  ShellFormInputCarouselController({
    required this.id,
    this.mandatory = true,
    this.value,
    this.checkPageTitle,
    this.checkPageDescription,
  });

  @override
  String? id;

  @override
  int? value;

  @override
  bool mandatory;

  @override
  String Function(int value)? checkPageTitle;

  @override
  String Function(int value)? checkPageDescription;

  @override
  void onSaved(int value) {
    this.value = value;
  }

  @override
  String? onValidate(
      int value, String Function(String, {List<String>? params}) translator) {
    if (mandatory) {}

    return null;
  }
}
