// Copyright (c) 2013, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#ifndef _memory_extender_h_
#define _memory_extender_h_

#include <stdint.h>

interface memory_extender {
  void st8(uintptr_t address, unsigned data);
  void st16(uintptr_t address, unsigned data);
  void stw(uintptr_t address, unsigned data);
  uint8_t ld8u(uintptr_t address);
  int16_t ld16s(uintptr_t address);
  unsigned ldw(uintptr_t address);
};

// TODO distributed task to do registration?

void memory_extender_install(client interface memory_extender * movable);

inline unsafe void * unsafe memory_extender_translate(uintptr_t address) {
  if ((intptr_t)address < 0) {
    __builtin_trap();
  }
  return (void * unsafe)(address | 0x80000000);
}

#endif /* _memory_extender_h_ */
