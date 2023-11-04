#include <libintl.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
int main(void)
{
  // printf("%s", getenv("LC_ALL"));
  
  setlocale(LC_ALL, "" );
  textdomain("hello");

  // Place to look for MO file
  bindtextdomain("hello", "./locale/");  
  
  printf(gettext("Hello, world!\n"));
  printf(gettext("How are you\n"));
  printf(gettext("I am fine\n")); 
  
  exit(0);
 }
