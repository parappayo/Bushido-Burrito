
#include "bb_list.h"

#include <stdlib.h>
#include <stdio.h>

typedef struct node {

	BB_LIST_MEMBERS(node)

	int i;
} node;

BB_LIST_FUNCS(node)

int main(int argc, char** argv)
{
	node test_list;
	test_list.i = -1;
	node_init_list(&test_list);

	for (int i = 0; i < 25; i++) {
		node* new_node = malloc(sizeof(node));
		new_node->i = i;
		node_init_list(new_node);
		node_add_tail(&test_list, new_node);
	}

	for (node* i = &test_list; i != NULL; i = i->next) {
		printf("%d, ", i->i);
	}
	printf("\n");

	return 0;
}

