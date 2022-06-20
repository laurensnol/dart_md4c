import 'package:flutter/material.dart';

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:dart_md4c/dart_md4c.dart' as md4c;

class MdParser {
  static String _result = "";

  static String parse(String md) {
    _result = "";

    md4c.mdParse(md, _parserPointer);

    malloc.free(_parserPointer);

    return _result;
  }

  static final ffi.Pointer<md4c.MD_PARSER> _parserPointer =
      malloc<md4c.MD_PARSER>()..ref = _parser;

  static final md4c.MD_PARSER _parser = md4c.createParser(
    ffi.Pointer.fromFunction(_enterBlock, 0),
    ffi.Pointer.fromFunction(_leaveBlock, 0),
    ffi.Pointer.fromFunction(_enterSpan, 0),
    ffi.Pointer.fromFunction(_leaveSpan, 0),
    ffi.Pointer.fromFunction(_text, 0),
    ffi.nullptr,
  );

  // MD4C Callbacks

  static int _enterBlock(
    int blocktype,
    ffi.Pointer<ffi.Void> detail,
    ffi.Pointer<ffi.Void> userdata,
  ) {
    if (blocktype == md4c.MD_BLOCKTYPE.MD_BLOCK_H) {
      final blockDetails = detail.cast<md4c.MD_BLOCK_H_DETAIL>().ref;
      _result += "Entered Block: Type H${blockDetails.level}\n";
    } else {
      _result += "Entered Block: Type $blocktype\n";
    }

    return 0;
  }

  static int _leaveBlock(
    int blocktype,
    ffi.Pointer<ffi.Void> detail,
    ffi.Pointer<ffi.Void> userdata,
  ) {
    _result += "Left Block: Type $blocktype\n";

    return 0;
  }

  static int _enterSpan(
    int spantype,
    ffi.Pointer<ffi.Void> detail,
    ffi.Pointer<ffi.Void> userdata,
  ) {
    _result += "Entered Span: Type $spantype\n";

    return 0;
  }

  static int _leaveSpan(
    int spantype,
    ffi.Pointer<ffi.Void> detail,
    ffi.Pointer<ffi.Void> userdata,
  ) {
    _result += "Left Span: Type $spantype\n";

    return 0;
  }

  static int _text(
    int texttype,
    ffi.Pointer<Utf8> text,
    int size,
    ffi.Pointer<ffi.Void> userdata,
  ) {
    String dartText = text.toDartString(length: size);
    _result += "Text: Type $texttype, '$dartText'\n";

    return 0;
  }
}

class Md4cExample extends StatefulWidget {
  const Md4cExample({Key? key}) : super(key: key);

  @override
  State<Md4cExample> createState() => _Md4cExampleState();
}

class _Md4cExampleState extends State<Md4cExample> {
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
                  _result = MdParser.parse(value);
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
