
#ifndef __bb_list_h__
#define __bb_list_h__
#pragma once

#include <stddef.h>

#define BB_LIST_MEMBERS(type_t) \
	struct type_t* next;\
	struct type_t* prev;\

#define BB_LIST_FUNCS(type_t) \
	void type_t##_init_list(struct type_t* node);\
	void type_t##_insert_before(struct type_t* list, struct type_t* node);\
	void type_t##_insert_after(struct type_t* list, struct type_t* node);\
	void type_t##_add_head(struct type_t* list, struct type_t* node);\
	void type_t##_add_tail(struct type_t* list, struct type_t* node);\
\
void type_t##_init_list(struct type_t* node)\
{\
	node->next = NULL;\
	node->prev = NULL;\
}\
\
void type_t##_insert_before(struct type_t* list, struct type_t* node)\
{\
	node->prev = list->prev;\
	node->next = list;\
	if (list->prev) {\
		list->prev->next = node;\
	};\
	list->prev = node;\
}\
\
void type_t##_insert_after(struct type_t* list, struct type_t* node)\
{\
	node->prev = list;\
	node->next = list->next;\
	if (list->next) {\
		list->next->prev = node;\
	}\
	list->next = node;\
}\
\
void type_t##_add_head(struct type_t* list, struct type_t* node)\
{\
	struct type_t* old_head = list;\
	while (old_head->prev) { old_head = old_head->prev; }\
	old_head->prev = node;\
}\
\
void type_t##_add_tail(struct type_t* list, struct type_t* node)\
{\
	struct type_t* old_tail = list;\
	while (old_tail->next) { old_tail = old_tail->next; }\
	old_tail->next = node;\
}\

#endif // __bb_list_h__

