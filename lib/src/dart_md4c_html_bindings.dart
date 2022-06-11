// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'dart_md4c_bindings.dart' show MD_SIZE;

/// Bindings for `md4c-html.h`.
class DartMd4cHtmlBindings {
  /// Holds the symbol lookup function.
  final Pointer<T> Function<T extends NativeType>(
    String symbolName,
  ) _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  DartMd4cHtmlBindings(DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  DartMd4cHtmlBindings.fromLookup(
    Pointer<T> Function<T extends NativeType>(String symbolName) lookup,
  ) : _lookup = lookup;

  /// Render Markdown into HTML.
  ///
  /// Note only contents of `<body>` tag is generated. Caller must generate
  /// HTML header/footer manually before/after calling `md_html()`.
  ///
  /// Params input and input_size specify the Markdown input.
  /// Callback process_output() gets called with chunks of HTML output.
  /// (Typical implementation may just output the bytes to a file or append to
  /// some buffer).
  /// Param userdata is just propagated back to `process_output()` callback.
  /// Param parser_flags are flags from md4c.h propagated to `md_parse()`.
  /// Param render_flags is bitmask of MD_HTML_FLAG_xxxx.
  ///
  /// Returns -1 on error (if `md_parse()` fails.)
  /// Returns 0 on success.
  int md_html(
    Pointer<Utf8> input,
    int input_size,
    Pointer<
            NativeFunction<
                Void Function(
      Pointer<Utf8>,
      MD_SIZE,
      Pointer<Void>,
    )>>
        process_output,
    Pointer<Void> userdata,
    int parser_flags,
    int renderer_flags,
  ) {
    return _md_html(
      input,
      input_size,
      process_output,
      userdata,
      parser_flags,
      renderer_flags,
    );
  }

  late final _md_htmlPtr = _lookup<
      NativeFunction<
          Int32 Function(
    Pointer<Utf8>,
    MD_SIZE,
    Pointer<
        NativeFunction<
            Void Function(
      Pointer<Utf8>,
      MD_SIZE,
      Pointer<Void>,
    )>>,
    Pointer<Void>,
    Uint32,
    Uint32,
  )>>('md_html');

  late final _md_html = _md_htmlPtr.asFunction<
      int Function(
    Pointer<Utf8>,
    int,
    Pointer<
        NativeFunction<
            Void Function(
      Pointer<Utf8>,
      MD_SIZE,
      Pointer<Void>,
    )>>,
    Pointer<Void>,
    int,
    int,
  )>();
}

/// If set, debug output from md_parse() is sent to stderr.
const MD_HTML_FLAG_DEBUG = 0x0001;
const MD_HTML_FLAG_VERBATIM_ENTITIES = 0x0002;
const MD_HTML_FLAG_SKIP_UTF8_BOM = 0x0004;
const MD_HTML_FLAG_XHTML = 0x0008;
