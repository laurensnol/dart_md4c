/* Helper functions and wrappers for md4c.
 * Will be built with md4c.h.
 */

#ifndef MD4C_UTILS_H
#define MD4C_UTILS_H

#include "md4c.h"

#ifdef __cplusplus
    extern "C" {
#endif

/* Helper function to create an MD_PARSER since ffi.Structs can't be constructed
 * inside Dart.
 */
MD_PARSER create_parser(
  unsigned flags,
  int (*enter_block)(MD_BLOCKTYPE, void*, void*),
  int (*leave_block)(MD_BLOCKTYPE, void*, void*),
  int (*enter_span)(MD_SPANTYPE, void*, void*),
  int (*leave_span)(MD_SPANTYPE, void*, void*),
  int (*text)(MD_TEXTTYPE, const MD_CHAR*, MD_SIZE, void*),
  void (*debug_log)(const char*, void*)
);

#ifdef __cplusplus
    }  /* extern "C" { */
#endif

#endif