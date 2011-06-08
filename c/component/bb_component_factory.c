
#include "bb_component.h"

#include <stddef.h>
#include <stdlib.h>

bb_component_t* bb_component_create(enum bb_component_type_t type)
{
	bb_component_t* retval = malloc(sizeof(bb_component_t));
	if (!retval) { return NULL; }

	bb_component_init(retval);

	switch (type)
	{
		case BB_COMPONENT_TYPE_NONE:
			break;

		// TODO: add user-defined types here

		default:
			// TODO: error condition here
			break;
	}

	return retval;
}

