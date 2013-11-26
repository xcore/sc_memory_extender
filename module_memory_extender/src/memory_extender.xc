// Copyright (c) 2013, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "memory_extender.h"
#include <stdint.h>

// Force external definition of inline functions.
extern inline unsafe void * unsafe memory_extender_translate(uintptr_t address);

extern void memory_extender_handler_install(void);

static client interface memory_extender * movable mem;

#define UNSAFE_MEM ((client interface memory_extender * unsafe)mem)

// Dummy function to force an array bound check.
static void ptr_check(client interface memory_extender p[]) {}

void memory_extender_install(client interface memory_extender * movable p)
{
  ptr_check(p);
  mem = move(p);
  memory_extender_handler_install();
}

void memory_extender_st8(uintptr_t address, unsigned data)
{
  unsafe { UNSAFE_MEM->st8(address, data); }
}

void memory_extender_st16(uintptr_t address, unsigned data)
{
  unsafe { UNSAFE_MEM->st16(address, data); }
}

void memory_extender_stw(uintptr_t address, unsigned data)
{
  unsafe { UNSAFE_MEM->stw(address, data); }
}

uint8_t memory_extender_ld8u(uintptr_t address)
{
  unsafe { return UNSAFE_MEM->ld8u(address); }
}

int16_t memory_extender_ld16s(uintptr_t address)
{
  unsafe { return UNSAFE_MEM->ld16s(address); }
}

unsigned memory_extender_ldw(uintptr_t address)
{
  unsafe { return UNSAFE_MEM->ldw(address); }
}
