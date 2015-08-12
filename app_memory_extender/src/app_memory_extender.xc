// Copyright (c) 2013, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "memory_extender.h"
#include <stdlib.h>
#define DEBUG_PRINT_ENABLE 1
#include "debug_print.h"

[[distributable]] static void logger(server interface memory_extender mem)
{
  while (1) {
    select {
    case mem.st8(uintptr_t address, unsigned data):
      debug_printf("Store 0x%x to *(uint8_t*)0x%x\n", data, address);
      unsafe { *((uint8_t *unsafe)address) = data; }
      break;
    case mem.st16(uintptr_t address, unsigned data):
      debug_printf("Store 0x%x to *(uint16_t*)0x%x\n", data, address);
      unsafe { *((int16_t *unsafe)address) = data; }
      break;
    case mem.stw(uintptr_t address, unsigned data):
      debug_printf("Store 0x%x to *(unsigned*)0x%x\n", data, address);
      unsafe { *((unsigned *unsafe)address) = data; }
      break;
    case mem.ld8u(uintptr_t address) -> uint8_t data:
      unsafe { data = *((uint8_t *unsafe)address); }
      debug_printf("Load 0x%x from *(uint8_t*)0x%x\n", data, address);
      break;
    case mem.ld16s(uintptr_t address) -> int16_t data:
      unsafe { data = *((int16_t *unsafe)address); }
      debug_printf("Load 0x%x from *(uint16_t*)0x%x\n", data, address);
      break;
    case mem.ldw(uintptr_t address) -> unsigned data:
      unsafe { data = *((unsigned *unsafe)address); }
      debug_printf("Load 0x%x from *(unsigned*)0x%x\n", data, address);
      break;
    }
  }
}

int index = 0;

static void test(client interface memory_extender mem)
{
  client interface memory_extender * movable p = &mem;
  memory_extender_install(move(p));
  int x = 1;
  unsafe {
    int * unsafe p1 = memory_extender_translate((uintptr_t)&x);
    *p1 += 1;
    p1[index] += 1;
    short * unsafe p2 = memory_extender_translate((uintptr_t)&x);
    *p2 += 1;
    p2[index] += 1;
    char * unsafe p3 = memory_extender_translate((uintptr_t)&x);
    *p3 += 1;
    p3[index] += 1;
  }
  debug_printf("x = %d\n", x);
  // Check that exception handler passes exceptions that are not load / store
  // exceptions to the original exception handler.
   __builtin_trap();
}

int main()
{
  interface memory_extender mem;
  par {
    logger(mem);
    test(mem);
  }
  return 0;
}
