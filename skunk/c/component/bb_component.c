
#include "bb_component.h"

#include <stddef.h>

void bb_component_init(bb_component_t* component)
{
	static uint32_t id_count = 1;  // 0 reserved

	component->next = NULL;
	component->prev = NULL;

	component->parent = NULL;
	component->child = NULL;

	component->id = id_count++;
	component->state = 0;
	component->data = NULL;

	component->init = NULL;
	component->update = NULL;
	component->handle_message = NULL;
}

