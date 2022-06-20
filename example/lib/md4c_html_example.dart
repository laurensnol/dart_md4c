import 'package:flutter/material.dart';

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:dart_md4c/dart_md4c.dart' as md4c;

class MdHtmlParser {
  static String parse(String md) {
    _result = "";
    md4c.mdHtml(md, ffi.Pointer.fromFunction(_callback));

    return _result;
  }

  static String _result = "";

  static void _callback(
    ffi.Pointer<Utf8> html,
    int size,
    ffi.Pointer<ffi.Void> flags,
  ) {
    _result += html.toDartString(length: size);
  }
}

class Md4cHtmlExample extends StatefulWidget {
  const Md4cHtmlExample({Key? key}) : super(key: key);

  @override
  State<Md4cHtmlExample> createState() => _Md4cHtmlExampleState();
}

class _Md4cHtmlExampleState extends State<Md4cHtmlExample> {
  String _result = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              onChanged: ((value) {
                setState(() {
                  _result = MdHtmlParser.parse(value);
                });
              }),
              expands: true,
              minLines: null,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Markdown",
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SelectableText(
              _result,
              style: const TextStyle(fontFamily: "Menlo", fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
