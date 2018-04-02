#pragma once

#include "sys/types.h"

// strlen: get length of string
// taken from https://en.wikibooks.org/wiki/C_Programming/string.h/strlen
size_t strlen(const char * str);

// reverse:  reverse string s in place
// taken from: https://en.wikibooks.org/wiki/C_Programming/stdlib.h/itoa
void reverse(char s[]);

// itoa:  convert n to characters in s
// taken from: https://en.wikibooks.org/wiki/C_Programming/stdlib.h/itoa
void itoa(int n, char s[]);

// strcmp:  compare s1 to s2
// taken from: https://en.wikibooks.org/wiki/C_Programming/string.h/strcmp
int strcmp (const char * s1, const char * s2);

// strcopy: copy src to dest
// taken from: https://en.wikibooks.org/wiki/C_Programming/string.h/strcpy#Usage_and_implementation
char *strcpy(char *dest, const char *src);