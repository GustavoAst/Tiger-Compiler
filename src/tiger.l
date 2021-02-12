#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <tiger.tab.h>

using namespace std;

#define MAX_STRING 65535
#define YY_NO_UNPUT
#define NEXT {charPos+=yyleng;}

void showError();

int charPos = 1;
std::stringstream strbuf;
char *strptr = NULL;

int commentDepth = 0;

extern YYLTYPE yylloc;

extern "C" int yywrap(void){
 charPos=1;
 return 1;
}



"array"    {NEXT; return ARRAY;}
"if"	   {NEXT; return IF;}
"then"     {NEXT; return THEN;}
"else"     {NEXT; return ELSE;}
"while"    {NEXT; return WHILE;}
"for"  	   {NEXT; return FOR;}
"to"	   {NEXT; return TO;}
"do"	   {NEXT; return DO;}
"let"	   {NEXT; return LET;}
"in"       {NEXT; return IN;}
"end"      {NEXT; return END;}
"of"	   {NEXT; return OF;}
"break"    {NEXT; return BREAK;}
"nil"      {NEXT; return NIL;}
"function" {NEXT; return FUNCTION;}
"var"      {NEXT; return VAR;}
"type"     {NEXT; return TYPE;}
"import"   {NEXT; return IMPORT;}
"primitive"{NEXT; return PRIMITIVE;}

[a-zA-Z][a-zA-Z0-9_]*    {NEXT; tigerlval.sval=new string(yytext); return ID;}
[0-9]+	   {NEXT; tigerlval.ival=atoi(yytext); return INT;}

","	   {NEXT; return COMMA;}
":"	   {NEXT; return COLON;}
";"	   {NEXT; return SEMICOLON;}
"("	   {NEXT; return LPAREN;}
")"        {NEXT; return RPAREN;}
"["        {NEXT; return LBRACK;}
"]"        {NEXT; return RBRACK;}
"{"        {NEXT; return LBRACE;}
"}"        {NEXT; return RBRACE;}
"."        {NEXT; return DOT;}
"+"        {NEXT; return PLUS;}
"-"        {NEXT; return MINUS;}
"*"        {NEXT; return TIMES;}
"/"        {NEXT; return DIVIDE;}
"="        {NEXT; return EQUAL;}
"<>"       {NEXT; return NOTEQUAL;}
"<"        {NEXT; return LESSTHAN;}
"<="       {NEXT; return LESSEQUAL;}
">"        {NEXT; return GREATERTHAN;}
">="       {NEXT; return GREATEREQUAL;}
"&"	   {NEXT; return AND;}
"|"	   {NEXT; return OR;}
":="       {NEXT; return ASSIGN;}

%%
%}
%x COMMENT STR
%%
[ \t]	   {NEXT; continue;}
(\n|\r\n)  {NEXT; /*EM_newline();*/ continue;}
"/*"       {NEXT; BEGIN(COMMENT); commentDepth++;}
<COMMENT>{
"/*"      {NEXT; commentDepth++;}
"*/"      {NEXT; if (--commentDepth == 0) BEGIN(INITIAL);}
[^\n]     {NEXT; }
(\n|\r\n) {NEXT; /*EM_newline();*/}
}

\"               {NEXT; BEGIN(STR); }
<STR>{
\"               {NEXT; tigerlval.sval=new std::string(strbuf.str()); strbuf.clear(); strbuf.str(std::string()); BEGIN(INITIAL); return STRING;}
\\n              {NEXT; strbuf << "\n";}
\\t		 {NEXT; strbuf << "\t";}
\\^[GHIJLM]	 {NEXT; strbuf<<yytext;}
\\[0-9]{3}	 {NEXT; strbuf<<yytext;}
\\\"    	 {NEXT; strbuf<<yytext;}
\\[ \n\t\r\f]+\\ {NEXT;}
\\(.|\n)	 {NEXT; showError();}
(\n|\r\n)	 {NEXT; showError();}
[^\"\\\n(\r\n)]+ {NEXT; strbuf<<yytext;}
}
. {NEXT; showError();}
        
void showError(){
    printf("Lexic Error, illegal token");
}
        