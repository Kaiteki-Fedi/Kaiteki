import "package:flutter/material.dart";

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final bool autofocus;

  const SearchBar({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.hintText,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      controller: controller,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(1 / 15),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        isDense: true,
        hintText: hintText ?? "Search",
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.value.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: controller.clear,
                tooltip: "Clear search",
                splashRadius: 20.0,
              )
            : null,
      ),
    );
  }
}
