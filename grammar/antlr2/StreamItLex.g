/* This file is simplified from the grammar file in sketch-frontend
 * repo, removing all dependencies and all keeping the grammar structure.
 * ref: https://github.com/asolarlez/sketch-frontend/blob/master/src/main/other/sketch/compiler/parser/StreamItLex.g
 */
/*
 * Copyright 2003 by the Massachusetts Institute of Technology.
 *
 * Permission to use, copy, modify, and distribute this
 * software and its documentation for any purpose and without
 * fee is hereby granted, provided that the above copyright
 * notice appear in all copies and that both that copyright
 * notice and this permission notice appear in supporting
 * documentation, and that the name of M.I.T. not be used in
 * advertising or publicity pertaining to distribution of the
 * software without specific, written prior permission.
 * M.I.T. makes no representations about the suitability of
 * this software for any purpose.  It is provided "as is"
 * without express or implied warranty.
 */

/*
 * StreamItLex.g: Lexical tokens for StreamIt
 * $Id: StreamItLex.g,v 1.18 2008/02/23 02:02:50 cgjones Exp $
 */


tokens {
	"atomic";
	"fork";
	"insert";
	"into";
	"loop"; "repeat"; "minrepeat";
	"new";
	"null";
	"reorder";
	
	"assume";
	"hassert";

	// Basic types:
	"boolean"; "float"; "bit"; "int"; "void"; "double"; "fun";"char";

	// Complicated types:
	"struct"; 
	"ref";
	"adt";

	// Control flow:
	"if"; "else"; "while"; "for"; "switch"; "case"; "repeat_case"; "default"; "break"; "do";
	"continue"; "return";

    // Intrinsic values:
	"true"; "false";

    // data-parallel control flow
    "parfor";
    "until";
    "by";

    // general sketching
    "implements";
    "assert";
    "assert_max";
    "h_assert";
    "generator";
    "harness";
    "model";
	"fixes";
    

   
    "global";
    "serial";

    // spmd
    "spmdfork";

    // solving methods
    "stencil";

    // Compiler directives:
    "include";
    "pragma";
    "package";
    
    //ADT
    "extends";
    
    "let";
    "precond";
}

ARROW :	"->" ;
LARROW :	"<-" ;

WS	:	(' '
	|	'\t'
	|	'\n'
	|	'\r')
	;


LINERESET : "#" (' ' | '\t')* NUMBER (' ' | '\t')* STRING_LITERAL 	(' ' | '\t')* '\n';

SL_COMMENT : "//" (~'\n')* '\n'	;

ML_COMMENT : "/*"(?'*'|'\n'|~('*'|'\n'))*"*/";

LPAREN : '(';
RPAREN : ')';
LCURLY:	'{' ;
RCURLY:	'}'	;
LSQUARE: '[' ;
RSQUARE: ']' ;
PLUS: '+' ;
PLUS_EQUALS: "+=" ;
INCREMENT: "++" ;
MINUS: '-' ;
MINUS_EQUALS: "-=" ;
DECREMENT: "--" ;
STAR: '*';
STAR_EQUALS: "*=" ;
DIV: '/';
DIV_EQUALS: "/=" ;
MOD: '%';
LOGIC_AND: "&&";
LOGIC_OR: "||";
BITWISE_AND: "&";
BITWISE_OR: "|";
BITWISE_XOR: "^";
ASSIGN: '=';
DEF_ASSIGN: ":=";
TRIPLE_EQUAL: "===";
EQUAL: "==";
NOT_EQUAL: "!=";
LESS_THAN: '<';
LESS_EQUAL: "<=";
MORE_THAN: '>';
MORE_EQUAL: ">=";
QUESTION: '?';
COLON: ':';
SEMI: ';';
COMMA: ',';
DOT: '.';
BANG: '!' | '~';
LSHIFT: "<<";
RSHIFT: ">>";
NDVAL: "{*}";
NDVAL2: "??";
NDVAL2SP: "??s";
SELECT: "{|}";
NDANGELIC: "**";
AT: "@";
BACKSLASH: "\\";
LESS_COLON: "<:";
DOLLAR: '$'; 

DOTASSIGN : ".=";
DOTPLUS: ".+";
DOTMINUS: ".-";
DOTTIMES: ".*";
DOTDIV: "./";
DOTMOD: ".%";
DOTLT: ".<";
DOTGT: ".>";
DOTLTE: ".<=";
DOTGTE: ".>=";


REGEN   { int open = 0; }
    :   "{|"
        ~('|' | '}')
        (
            ("{|") => "{|"          { open++; }
            | { open > 0 }? "|}"    { open--; }
            | { LA(2)!='}' }? '|'
            | '\n'
            | '{'
            | ~('{'|'|'|'\n')
        )*
        "|}";

CHAR_LITERAL
	:	'\'' (ESC|~'\'') '\''
	;

STRING_LITERAL
	:	'"' (ESC|~'"')* '"'
	;

protected
ESC	:	'\\'
		(	'n'
		|	'r'
		|	't'
		|	'b'
		|	'f'
		|	'"'
		|	'\''
		|	'\\'
		|	'0'..'3'
			(
				options {
					warnWhenFollowAmbig = false;
				}
			:	DIGIT
				(
					options {
						warnWhenFollowAmbig = false;
					}
				:	DIGIT
				)?
			)?
		|	'4'..'7'
			(
				options {
					warnWhenFollowAmbig = false;
				}
			:	DIGIT
			)?
		)
	;

protected
DIGIT
	:	'0'..'9'
	;

HQUAN
	:	 "0x" ( (DIGIT) | 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'a' | 'b' | 'c' | 'd' | 'e' | 'f')+
	;

NUMBER
	:	 (DIGIT)+ (DOT (DIGIT)+ )? (('e' | 'E') ('+'|'-')? (DIGIT)+ )? ('i')?
	;

ID
options {
	testLiterals = true;
	paraphrase = "an identifier";
}
	:	((('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*)
		| "op.+" | "op.-" | "op.*" |  "op./" |  "op.%"  | "op.=" | "op.<"
	)
	;


