// Taken from https://github.com/embeddedartistry/embedded-resources/
// Adapted by Sergej Zuyev


#pragma once

#include "sys/types.h"

typedef struct kll_node 
{
    struct kll_node *next;
    struct kll_node *prev;
} kll_node_t;

// Define offsetof and container_of
#define offsetof(type, member) ((size_t) &((type *)NULL)->member)

#define container_of(ptr, type, member)	({			\
	const __typeof__( ((type *)0)->member ) *__mptr = (ptr);	\
	(type *)( (char *)__mptr - offsetof(type,member) );})


#define kll_elem(ptr, type, member) container_of(ptr, type, member)

#define kll_first_elem(head, type, member) kll_elem((head)->next, type, member)

#define kll_foreach(pos, head) \
	for (pos = (head)->next; pos != (head); pos = pos->next)

#define kll_foreach_safe(pos, n, head) \
	for (pos = (head)->next, n = pos->next; pos != (head); \
		pos = n, n = pos->next)

#define kll_foreach_elem(pos, head, member) \
	for (pos = kll_elem((head)->next, __typeof__(*pos), member);	\
		&pos->member != (head);					\
		pos = kll_elem(pos->member.next, __typeof__(*pos), member))

#define kll_foreach_elem_safe(pos, n, head, member)			\
	for (pos = kll_elem((head)->next, __typeof__(*pos), member),	\
		n = kll_elem(pos->member.next, __typeof__(*pos), member);	\
		&pos->member != (head);					\
		pos = n, n = kll_elem(n->member.next, __typeof__(*n), member))

static inline void kll_insert(kll_node_t *node, kll_node_t *prev, kll_node_t *next)
{
    next->prev = node;
    node->next = next;
    node->prev = prev;
    prev->next = node;
}

static inline void kll_append(kll_node_t *node, kll_node_t *last)
{
    kll_insert(node, last, last->next);
}

static inline void kll_insert_last(kll_node_t *node, kll_node_t *last)
{
    kll_insert(node, last->prev, last);
}

static inline void kll_remove_between(kll_node_t *prev, kll_node_t *next)
{
    next->prev = prev;
    prev->next = next;
}

static inline void kll_remove(kll_node_t *node)
{
    kll_remove_between(node->prev, node->next);
    node->prev = NULL;
    node->next = NULL;
}