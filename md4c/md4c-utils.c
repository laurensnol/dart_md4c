#include <stdio.h>

#include "md4c-utils.h"

MD_PARSER create_parser(
  unsigned flags,
  int (*enter_block)(MD_BLOCKTYPE, void*, void*),
  int (*leave_block)(MD_BLOCKTYPE, void*, void*),
  int (*enter_span)(MD_SPANTYPE, void*, void*),
  int (*leave_span)(MD_SPANTYPE, void*, void*),
  int (*text)(MD_TEXTTYPE, const MD_CHAR*, MD_SIZE, void*),
  void (*debug_log)(const char*, void*)
) {
  MD_PARSER parser = {
    0,
    flags,
    enter_block,
    leave_block,
    enter_span,
    leave_span,
    text,
    debug_log,
    NULL
  };

  return parser;
}