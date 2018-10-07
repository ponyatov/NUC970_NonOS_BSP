%{
#include "ByteCompiler.hpp"
%}

%defines %union { uint8_t cmd0; char* bcfile; }

%token <cmd0> CMD0
%token SAVE dotVM
%token <bcfile> BCFILE

%%
REPL : | REPL CMD0	{ Bcompile($2); }
| REPL SAVE BCFILE	{ save($3); }
| REPL dotVM		{ VM(); }
%%
