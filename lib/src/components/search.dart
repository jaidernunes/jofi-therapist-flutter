import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/themes/app_theme.dart';

class Search extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final Function(String) onChanged;

  const Search({
    super.key,
    required this.placeholder,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
        bottom: 30,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF4F4F4F),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, bottom: 3),
                      child: TextFormField(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: placeholder,
                        ),
                        controller: controller,
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                   const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(Icons.search, color: AppTheme.standardOrange,
                    size: 40,),
                    // child: Image.asset('assets/images/search.png'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
