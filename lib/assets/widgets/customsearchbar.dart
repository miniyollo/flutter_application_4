import 'package:flutter/material.dart';

import '../theme.dart';
// Make sure to import your AppTheme

class ReusableSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const ReusableSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _ReusableSearchBarState createState() => _ReusableSearchBarState();
}

class _ReusableSearchBarState extends State<ReusableSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shadowColor: AppTheme.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onSearch,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search, color: AppTheme.darkText),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: InputBorder.none,
          filled: true,
          fillColor: AppTheme.nearlyWhite,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: AppTheme.primaryColor),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
