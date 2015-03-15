
#ifndef __bb_component_h__
#define __bb_component_h__
#pragma once

#include <stdint.h>

#include "bb_list.h"
#include "bb_component_types.h"

typedef void (*init_func_t)(void);
typedef void (*update_func_t)(float elapsed);
typedef void (*handle_message_t)(uint32_t msg_id, void* sender, void* param);

typedef struct bb_component_t {

	BB_LIST_MEMBERS(bb_component_t)

	// TODO: add rbtree.c macros

	struct bb_component_t* parent;
	struct bb_component_t* child;

	enum bb_component_type_t type;
	uint32_t id;
	uint32_t state;
	void* data;

	init_func_t init;
	update_func_t update;
	handle_message_t handle_message;

} bb_component_t;

BB_LIST_FUNCS(bb_component_t)

void bb_component_init(bb_component_t* component);

#endif // __bb_component_h__

