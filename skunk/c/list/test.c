
#include "bb_list.h"

#include <stdlib.h>
#include <stdio.h>

typedef struct node {

	BB_LIST_MEMBERS(node)

	int data;
} node;

BB_LIST_FUNCS(node)

void print_list(node* list)
{
	for (node* i = list; i != NULL; i = i->next) {
		printf("%d, ", i->data);
	}
	printf("\n");
}

int main(int argc, char** argv)
{
	node test_list;
	test_list.data = -1;
	node_list_init(&test_list);

	for (int i = 0; i < 25; i++) {
		node* new_node = malloc(sizeof(node));
		new_node->data = i;
		node_list_init(new_node);
		node_list_add_tail(&test_list, new_node);
	}

	printf("after populating:\n");
	print_list(&test_list);

	printf("walking backwards:\n");
	for (node* i = node_list_tail(&test_list); i->prev != NULL; i = i->prev) {
		printf("%d, ", i->data);
	}
	printf("\n");

	// simple insertion test
	{
		node* test_node = &test_list;
		for (int i = 0; i < 5; i++) {
			test_node = test_node->next;
		}
		node* new_node = malloc(sizeof(node));
		new_node->data = 99;
		node_list_insert_after(test_node, new_node);
	}

	printf("after insert test:\n");
	print_list(&test_list);

	// simple deletion test
	{
		node* test_node = &test_list;
		for (int i = 0; i < 6; i++) {
			test_node = test_node->next;
		}
		node_list_remove(test_node);
		free(test_node);
	}

	printf("after remove test:\n");
	print_list(&test_list);

	{
		node* i = node_list_tail(&test_list);
		printf("list tail: %d\n", i->data);
		printf("list tail prev: %x\n", (unsigned int) i->prev);
	}

	for (node* i = node_list_tail(&test_list); i->prev != NULL; ) {
		node* prev = i->prev;
		node_list_remove(i);
		free(i);
		i = prev;
	}

	printf("after cleanup:\n");
	print_list(&test_list);

	return 0;
}

