// ignore_for_file: non_constant_identifier_names, camel_case_types, constant_identifier_names

import 'dart:ffi';
import 'package:ffi/ffi.dart';

/// Bindings for `md4c.h`.
class DartMd4cBindings {
  /// Holds the symbol lookup function.
  final Pointer<T> Function<T extends NativeType>(
    String symbolName,
  ) _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  DartMd4cBindings(DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  DartMd4cBindings.fromLookup(
    Pointer<T> Function<T extends NativeType>(String symbolName) lookup,
  ) : _lookup = lookup;

  /// Helper function to create an MD_PARSER since Structs can't be
  /// constructed inside Dart.
  MD_PARSER create_parser(
    int flags,
    Pointer<NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
        enter_block,
    Pointer<NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
        leave_block,
    Pointer<NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
        enter_span,
    Pointer<NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
        leave_span,
    Pointer<
            NativeFunction<
                Int32 Function(Int32, Pointer<Utf8>, MD_SIZE, Pointer<Void>)>>
        text,
    Pointer<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Void>)>>
        debug_log,
  ) {
    return _create_parser(
      flags,
      enter_block,
      leave_block,
      enter_span,
      leave_span,
      text,
      debug_log,
    );
  }

  late final _create_parserPtr = _lookup<
      NativeFunction<
          MD_PARSER Function(
    Uint32,
    Pointer<
        NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>,
    Pointer<
        NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>,
    Pointer<
        NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>,
    Pointer<
        NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>,
    Pointer<
        NativeFunction<
            Int32 Function(Int32, Pointer<Utf8>, MD_SIZE, Pointer<Void>)>>,
    Pointer<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Void>)>>,
  )>>('create_parser');

  late final _create_parser = _create_parserPtr.asFunction<
      MD_PARSER Function(
    int,
    Pointer<
        NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>,
    Pointer<
        NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>,
    Pointer<
        NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>,
    Pointer<
        NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>,
    Pointer<
        NativeFunction<
            Int32 Function(Int32, Pointer<Utf8>, MD_SIZE, Pointer<Void>)>>,
    Pointer<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Void>)>>,
  )>();

  /// Parse the Markdown document stored in the string 'text' of size 'size'.
  ///
  /// The parser provides callbacks to be called during the parsing so the
  /// caller can render the document on the screen or convert the Markdown to
  /// another format.
  ///
  /// Zero is returned on success. If a runtime error occurs (e.g. a memory
  /// fails), -1 is returned. If the processing is aborted due any callback
  /// returning non-zero, the return value of the callback is returned.
  int md_parse(
    Pointer<Utf8> text,
    int size,
    Pointer<MD_PARSER> parser,
    Pointer<Void> userdata,
  ) {
    return _md_parse(
      text,
      size,
      parser,
      userdata,
    );
  }

  late final _md_parsePtr = _lookup<
      NativeFunction<
          Int32 Function(Pointer<Utf8>, MD_SIZE, Pointer<MD_PARSER>,
              Pointer<Void>)>>('md_parse');

  late final _md_parse = _md_parsePtr.asFunction<
      int Function(Pointer<Utf8>, int, Pointer<MD_PARSER>, Pointer<Void>)>();
}

// Typedefs
typedef MD_CHAR = Int8;
typedef MD_SIZE = Uint32;
typedef MD_OFFSET = Uint32;

// From here on, code and comments are mostly copied directly from md4c.h.
//
// Note regarding ffigen: Most of the bindings are exactly how ffigen would
// generate them. However, some comments are not properly formatted for Dart
// and therefore require some syntactical rewriting.

/// Block represents a part of document hierarchy structure like a paragraph
/// or list item.
abstract class MD_BLOCKTYPE {
  /// \<body>...\</body>
  static const MD_BLOCK_DOC = 0;

  /// \<blockquote>...\</blockquote>
  static const MD_BLOCK_QUOTE = 1;

  /// \<ul>...\</ul>
  ///
  /// Detail: Structure [MD_BLOCK_UL_DETAIL].
  static const MD_BLOCK_UL = 2;

  /// \<ol>...\</ol>
  ///
  /// Detail: Structure [MD_BLOCK_OL_DETAIL].
  static const MD_BLOCK_OL = 3;

  /// \<li>...\</li>
  ///
  /// Detail: Structure [MD_BLOCK_LI_DETAIL].
  static const MD_BLOCK_LI = 4;

  /// \<hr>
  static const MD_BLOCK_HR = 5;

  /// \<h1>...\</h1> (for levels up to 6)
  ///
  /// Detail: Structure [MD_BLOCK_H_DETAIL].
  static const MD_BLOCK_H = 6;

  /// \<pre>\<code>...\</code>\</pre>
  ///
  /// Note the text lines within code blocks are terminated with '\n' instead
  /// of explicit [MD_TEXT_BR].
  static const MD_BLOCK_CODE = 7;

  /// Raw HTML block.
  ///
  /// This itself does not correspond to any particular HTML tag. The content of
  /// _is_ raw HTML source intended to be put in verbatim form to the HTML
  /// output.
  static const MD_BLOCK_HTML = 8;

  /// \<p>...\</p>
  static const MD_BLOCK_P = 9;

  /// \<table>...\</table> and its contents.
  ///
  /// Detail: Structure [MD_BLOCK_TABLE_DETAIL] (for [MD_BLOCK_TABLE]),
  /// structure [MD_BLOCK_TD_DETAIL] (for [MD_BLOCK_TH] and [MD_BLOCK_TD])
  ///
  /// Note all of these are used only if extension [MD_FLAG_TABLES] is
  /// enabled.
  static const MD_BLOCK_TABLE = 10;
  static const MD_BLOCK_THEAD = 11;
  static const MD_BLOCK_TBODY = 12;
  static const MD_BLOCK_TR = 13;
  static const MD_BLOCK_TH = 14;
  static const MD_BLOCK_TD = 15;
}

/// Span represents an in-line piece of a document which should be rendered with
/// the same font, color and other attributes. A sequence of spans forms a block
/// like paragraph or list item.
abstract class MD_SPANTYPE {
  /// \<em>...\</em>
  static const MD_SPAN_EM = 0;

  /// \<strong>...\</strong>
  static const MD_SPAN_STRONG = 1;

  /// \<a href="xxx">...\</a>
  ///
  /// Detail: Structure [MD_SPAN_A_DETAIL].
  static const MD_SPAN_A = 2;

  /// \<img src="xxx">...\</a>
  ///
  /// Detail: Structure [MD_SPAN_IMG_DETAIL].
  ///
  /// Note: Image text can contain nested spans and even nested images.
  ///
  /// If rendered into ALT attribute of HTML <IMG> tag, it's responsibility
  /// of the parser to deal with it.
  static const MD_SPAN_IMG = 3;

  /// \<code>...\</code>
  static const MD_SPAN_CODE = 4;

  /// \<del>...\</del>
  ///
  /// Note: Recognized only when [MD_FLAG_STRIKETHROUGH] is enabled.
  static const MD_SPAN_DEL = 5;

  /// For recognizing inline ($) and display ($$) equations.
  ///
  /// Note: Recognized only when [MD_FLAG_LATEXMATHSPANS] is enabled.
  static const MD_SPAN_LATEXMATH = 6;
  static const MD_SPAN_LATEXMATH_DISPLAY = 7;

  /// Wiki links
  ///
  /// Note: Recognized only when [MD_FLAG_WIKILINKS] is enabled.
  static const MD_SPAN_WIKILINK = 8;

  /// \<u>...\</u>
  ///
  /// Note: Recognized only when [MD_FLAG_UNDERLINE] is enabled.
  static const MD_SPAN_U = 9;
}

/// Text is the actual textual contents of span.
abstract class MD_TEXTTYPE {
  /// Normal text.
  static const MD_TEXT_NORMAL = 0;

  /// NULL character.
  ///
  /// CommonMark requires replacing NULL character with the replacement char
  /// U+FFFD, so this allows caller to do that easily.
  static const MD_TEXT_NULLCHAR = 1;

  /// Line breaks.
  ///
  /// Note these are not sent from blocks with verbatim output ([MD_BLOCK_CODE]
  /// or [MD_BLOCK_HTML]). In such cases, '\n' is part of the text itself.
  static const MD_TEXT_BR = 2;

  /// \<br> (hard break)
  static const MD_TEXT_SOFTBR = 3;

  /// '\n' in source text where it is not semantically meaningful (soft break)

  /// Entity.
  /// (a) Named entity, e.g. &nbsp;
  ///     (Note MD4C does not have a list of known entities.
  ///     Anything matching the regexp `&[A-Za-z][A-Za-z0-9]{1,47};` is
  ///     treated as a named entity.)
  /// (b) Numerical entity, e.g. &#1234;
  /// (c) Hexadecimal entity, e.g. &#x12AB;
  ///
  /// As MD4C is mostly encoding agnostic, application gets the verbatim entity
  /// text into the `MD_PARSER::text_callback()`.
  static const MD_TEXT_ENTITY = 4;

  /// Text in a code block (inside [MD_BLOCK_CODE]) or inlined code (`code`).
  ///
  /// If it is inside [MD_BLOCK_CODE], it includes spaces for indentation and `\n`
  /// for new lines. [MD_TEXT_BR] and [MD_TEXT_SOFTBR] are not sent for this kind of
  /// text.
  static const MD_TEXT_CODE = 5;

  /// Text is a raw HTML.
  /// If it is contents of a raw HTML block (i.e. not an inline raw HTML), then
  /// [MD_TEXT_BR] and [MD_TEXT_SOFTBR] are not used. The text contains verbatim
  /// '\n' for the new lines.
  static const MD_TEXT_HTML = 6;

  /// Text is inside an equation. This is processed the same way as inlined code
  /// spans (`code`). */
  static const MD_TEXT_LATEXMATH = 7;
}

/// Alignment enumeration.
abstract class MD_ALIGN {
  /// When unspecified.
  static const MD_ALIGN_DEFAULT = 0;
  static const MD_ALIGN_LEFT = 1;
  static const MD_ALIGN_CENTER = 2;
  static const MD_ALIGN_RIGHT = 3;
}

/// String attribute.
///
/// This wraps strings which are outside of a normal text flow and which are
/// propagated within various detailed structures, but which still may contain
/// string portions of different types like e.g. entities.
///
/// So, for example, lets consider this image:
/// `![image alt text](http://example.org/image.png 'foo &quot; bar')`
/// The image alt text is propagated as a normal text via the `MD_PARSER::text()`
/// callback. However, the image title `foo &quot; bar` is propagated as
/// [MD_ATTRIBUTE] in `MD_SPAN_IMG_DETAIL::title`.
///
/// Then the attribute `MD_SPAN_IMG_DETAIL::title` shall provide the following:
/// - `[0]`: "foo "   (substr_types[0] == MD_TEXT_NORMAL; substr_offsets[0] == 0)
/// - `[1]`: "&quot;" (substr_types[1] == MD_TEXT_ENTITY; substr_offsets[1] == 4)
/// - `[2]`: " bar"   (substr_types[2] == MD_TEXT_NORMAL; substr_offsets[2] == 10)
/// - `[3]`: (n/a)    (n/a                              ; substr_offsets[3] == 14)
///
/// Note that these invariants are always guaranteed:
/// - substr_offsets[0] == 0
/// - substr_offsets[LAST+1] == size
/// - Currently, only MD_TEXT_NORMAL, MD_TEXT_ENTITY, MD_TEXT_NULLCHAR
///     substrings can appear. This could change only of the specification
///     changes.
class MD_ATTRIBUTE extends Struct {
  external Pointer<MD_CHAR> text;

  @MD_SIZE()
  external int size;
  external Pointer<Int32> substr_types;
  external Pointer<MD_OFFSET> substr_offsets;
}

/// Detailed info for [MD_BLOCK_UL].
class MD_BLOCK_UL_DETAIL extends Struct {
  /// Non-zero if tight list, zero if loose.
  @Int32()
  external int is_tight;

  /// Item bullet character in MarkDown source of the list, e.g. '-', '+', '*'.
  @MD_CHAR()
  external int mark;
}

/// Detailed info for [MD_BLOCK_OL].
class MD_BLOCK_OL_DETAIL extends Struct {
  /// Start index of the ordered list.
  @Uint32()
  external int start;

  /// Non-zero if tight list, zero if loose.
  @Int32()
  external int is_tight;

  /// Character delimiting the item marks in MarkDown source, e.g. '.' or ')'.
  @MD_CHAR()
  external int mark_delimiter;
}

/// Detailed info for [MD_BLOCK_LI].
class MD_BLOCK_LI_DETAIL extends Struct {
  /// Can be non-zero only with [MD_FLAG_TASKLISTS]
  @Int32()
  external int is_task;

  /// If is_task, then one of 'x', 'X' or ' '. Undefined otherwise.
  @MD_CHAR()
  external int task_mark;

  /// If is_task, then offset in the input of the char between '[' and ']'.
  @MD_OFFSET()
  external int task_mark_offset;
}

/// Detailed info for [MD_BLOCK_H].
class MD_BLOCK_H_DETAIL extends Struct {
  /// Header level (1 - 6)
  @Uint32()
  external int level;
}

/// Detailed info for [MD_BLOCK_CODE].
class MD_BLOCK_CODE_DETAIL extends Struct {
  external MD_ATTRIBUTE info;
  external MD_ATTRIBUTE lang;

  /// The character used for fenced code block; or zero for indented code block.
  @MD_CHAR()
  external int fence_char;
}

/// Detailed info for [MD_BLOCK_TABLE].
class MD_BLOCK_TABLE_DETAIL extends Struct {
  /// Count of columns in the table.
  @Uint32()
  external int col_count;

  /// Count of rows in the table header (currently always 1)
  @Uint32()
  external int head_row_count;

  /// Count of rows in the table body
  @Uint32()
  external int body_row_count;
}

/// Detailed info for [MD_BLOCK_TH] and [MD_BLOCK_TD].
class MD_BLOCK_TD_DETAIL extends Struct {
  @Int32()
  external int align;
}

/// Detailed info for [MD_SPAN_A].
class MD_SPAN_A_DETAIL extends Struct {
  external MD_ATTRIBUTE href;
  external MD_ATTRIBUTE title;
}

/// Detailed info for [MD_SPAN_IMG].
class MD_SPAN_IMG_DETAIL extends Struct {
  external MD_ATTRIBUTE src;
  external MD_ATTRIBUTE title;
}

/// Detailed info for [MD_SPAN_WIKILINK].
class MD_SPAN_WIKILINK extends Struct {
  external MD_ATTRIBUTE target;
}

// Flags specifying extensions/deviations from CommonMark specification.
//
// By default (when MD_PARSER::flags == 0), we follow CommonMark specification.
// The following flags may allow some extensions or deviations from it.

/// In MD_TEXT_NORMAL, collapse non-trivial whitespace into single ' '.
const MD_FLAG_COLLAPSEWHITESPACE = 0x0001;

/// Do not require space in ATX headers ( ###header ).
const MD_FLAG_PERMISSIVEATXHEADERS = 0x0002;

/// Recognize URLs as autolinks even without '<', '>'.
const MD_FLAG_PERMISSIVEURLAUTOLINKS = 0x0004;

/// Recognize e-mails as autolinks even without '<', '>' and 'mailto:'.
const MD_FLAG_PERMISSIVEEMAILAUTOLINKS = 0x0008;

/// Disable indented code blocks. (Only fenced code works.).
const MD_FLAG_NOINDENTEDCODEBLOCKS = 0x0010;

/// Disable raw HTML blocks.
const MD_FLAG_NOHTMLBLOCKS = 0x0020;

/// Disable raw HTML (inline).
const MD_FLAG_NOHTMLSPANS = 0x0040;

/// Enable tables extension.
const MD_FLAG_TABLES = 0x0100;

/// Enable strikethrough extension.
const MD_FLAG_STRIKETHROUGH = 0x0200;

/// Enable WWW autolinks (even without any scheme prefix, if they begin with
/// 'www.').
const MD_FLAG_PERMISSIVEWWWAUTOLINKS = 0x0400;

/// Enable task list extension.
const MD_FLAG_TASKLISTS = 0x0800;

/// Enable $ and $$ containing LaTeX equations.
const MD_FLAG_LATEXMATHSPANS = 0x1000;

/// Enable wiki links extension.
const MD_FLAG_WIKILINKS = 0x2000;

/// Enable underline extension (and disables '_' for normal emphasis).
const MD_FLAG_UNDERLINE = 0x4000;

const MD_FLAG_PERMISSIVEAUTOLINKS = (MD_FLAG_PERMISSIVEEMAILAUTOLINKS |
    MD_FLAG_PERMISSIVEURLAUTOLINKS |
    MD_FLAG_PERMISSIVEWWWAUTOLINKS);

const MD_FLAG_NOHTML = (MD_FLAG_NOHTMLBLOCKS | MD_FLAG_NOHTMLSPANS);

// Convenient sets of flags corresponding to well-known Markdown dialects.
//
// Note we may only support subset of features of the referred dialect.
// The constant just enables those extensions which bring us as close as
// possible given what features we implement.
//
// ABI compatibility note: Meaning of these can change in time as new
// extensions, bringing the dialect closer to the original, are implemented.
const MD_DIALECT_COMMONMARK = 0;
const MD_DIALECT_GITHUB = (MD_FLAG_PERMISSIVEAUTOLINKS |
    MD_FLAG_TABLES |
    MD_FLAG_STRIKETHROUGH |
    MD_FLAG_TASKLISTS);

/// Parser structure.
class MD_PARSER extends Struct {
  /// Reserved. Set to zero.
  @Uint32()
  external int abi_version;

  /// Dialect options. Bitmask of MD_FLAG_xxxx values.
  @Uint32()
  external int flags;

  // Caller-provided rendering callbacks.
  //
  // For some block/span types, more detailed information is provided in a
  // type-specific structure pointed by the argument 'detail'.
  //
  // The last argument of all callbacks, 'userdata', is just propagated from
  // md_parse() and is available for any use by the application.
  //
  // Note any strings provided to the callbacks as their arguments or as
  // members of any detail structure are generally not zero-terminated.
  // Application has to take the respective size information into account.
  //
  // Any rendering callback may abort further parsing of the document by
  // returning non-zero.

  /// Callback parameters:
  /// - [MD_BLOCKTYPE] as [Int32] type,
  /// - [Pointer]<[Void]> detail,
  /// - [Pointer]<[Void]> userdata
  external Pointer<
          NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
      enter_block;

  /// Callback parameters:
  /// - [MD_BLOCKTYPE] as [Int32] type,
  /// - [Pointer]<[Void]> detail,
  /// - [Pointer]<[Void]> userdata
  external Pointer<
          NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
      leave_block;

  /// Callback parameters:
  /// - [MD_SPANTYPE] as [Int32] type,
  /// - [Pointer]<[Void]> detail,
  /// - [Pointer]<[Void]> userdata
  external Pointer<
          NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
      enter_span;

  /// Callback parameters:
  /// - [MD_SPANTYPE] as [Int32] type,
  /// - [Pointer]<[Void]> detail,
  /// - [Pointer]<[Void]> userdata
  external Pointer<
          NativeFunction<Int32 Function(Int32, Pointer<Void>, Pointer<Void>)>>
      leave_span;

  /// Callback parameters:
  /// - [MD_TEXTTYPE] as [Int32] type,
  /// - [Pointer]<[MD_CHAR]> text,
  /// - [MD_SIZE] size,
  /// - [Pointer]<[Void]> userdata
  external Pointer<
          NativeFunction<
              Int32 Function(Int32, Pointer<MD_CHAR>, MD_SIZE, Pointer<Void>)>>
      text;

  /// Debug callback. Optional (may be NULL).
  ///
  /// If provided and something goes wrong, this function gets called.
  /// This is intended for debugging and problem diagnosis for developers; it is
  /// not intended to provide any errors suitable for displaying to an end user.
  external Pointer<NativeFunction<Void Function(Pointer<Int8>, Pointer<Void>)>>
      debug_log;

  /// Reserved. Set to NULL.
  external Pointer<NativeFunction<Void Function()>> syntax;
}
