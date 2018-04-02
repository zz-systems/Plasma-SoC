#include "sys/string.h"

// strlen: get length of string
// taken from https://en.wikibooks.org/wiki/C_Programming/string.h/strlen
size_t strlen(const char * str)
{
    const char *s;
    for (s = str; *s; ++s);
    
    return(s - str);
}

// reverse:  reverse string s in place
// taken from: https://en.wikibooks.org/wiki/C_Programming/stdlib.h/itoa
void reverse(char s[])
{
    int i, j;
    char c;

    for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}
// itoa:  convert n to characters in s
// taken from: https://en.wikibooks.org/wiki/C_Programming/stdlib.h/itoa
void itoa(int n, char s[])
{
    int i, sign;

    if ((sign = n) < 0)  /* record sign */
        n = -n;          /* make n positive */
    i = 0;
    do {       /* generate digits in reverse order */
        s[i++] = n % 10 + '0';   /* get next digit */
    } while ((n /= 10) > 0);     /* delete it */
    if (sign < 0)
        s[i++] = '-';
    s[i] = '\0';
    reverse(s);
}

// strcmp:  compare s1 to s2
// taken from: https://en.wikibooks.org/wiki/C_Programming/string.h/strcmp
int strcmp (const char * s1, const char * s2)
{
    for(; *s1 == *s2; ++s1, ++s2)
        if(*s1 == 0)
            return 0;
    return *(unsigned char *)s1 < *(unsigned char *)s2 ? -1 : 1;
}

// strcopy: copy src to dest
// taken from: https://en.wikibooks.org/wiki/C_Programming/string.h/strcpy#Usage_and_implementation
char *strcpy(char *dest, const char *src)
{
   char *save = dest;
   while(*dest++ = *src++);
   return save;
}