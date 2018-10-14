%{
#include <assert.h>
%}

%option yylineno noyywrap

%%
#.*\n	{ printf("/** %s */\n",&yytext[2]); }
.+=.+\n	{ printf(yytext); }
.	{}

%%

int main(int argc, char *argv[] ) {
	assert(argc==2);
    yyin = fopen(argv[1], "r"); yylex();
	return 0;
}

