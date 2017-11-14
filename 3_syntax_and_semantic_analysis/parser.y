%{
#include <stdio.h>
#include "main.cpp"
#define YYSTYPE SymbolInfo*
#include "bits/stdc++.h"
#include "iostream"

FILE *logout;
FILE *tokenout;
FILE *parseLog;

SymbolTable parser_table;
stringstream ss;
extern FILE *yyin;
extern int line_count;
int tempCount = 0, labelCount = 0;

extern int yylex(void);
extern int yyparse(void);
string assembly_codes = "";
string varDec = "";

extern "C"
{
	//Kill me
}
extern char yytext[];
extern int column;
ofstream assembly;

string getTemp(string type = "w")	//put type = "b" for byte
{
	stringstream ss;
	varDec+= ss.str()+" d"+type[0]+" 0\n";
	return ss.str();
}

string getLabel()	//put type = "b" for byte
{
	stringstream ss;
	ss << "label" << labelCount++;
	return ss.str();
}


//ofstream ir_code_stream; 

void yyerror(char *s)
{
	fprintf(stderr,"At Line %d, ERROR-> %s\n",line_count,s);
	return;
}

void adele(){
	cout << "Hello from the other side"<< endl;
}

%}

%token SEMICOLON INT FLOAT CHAR COMMA TYPEDEF LCURL RCURL
%token ID LTHIRD CONST RTHIRD FOR LBRAKET RBRAKET IF STATIC
%token ELSE WHILE PRINTLN RETURN ASSIGNOP LOGICOP REGISTER
%token RELOP ADDOP MULOP NOT INCOP DECOP CONST_CHAR
%token CONST_INT CONST_FLOAT MAIN TYPE_NAME VOLATILE AUTO
%token VOID SHORT LONG DOUBLE SIGNED UNSIGNED EXTERN
%token ENUM IDENTIFIER STRUCT UNION HEADER NUMBER STRING
%token OR_OP AND_OP EQ_OP NE_OP LEFT_OP GE_OP LE_OP RIGHT_OP

%%

%%

int main(int argc,char *argv[]){
	adele();
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");
	parseLog = fopen("parseLog", "w");
	//assembly= fopen("assembly.asm", "W");
	assembly.open("assembly.asm");
	fclose(tokenout);
	fclose(logout);
	yyparse();
	fclose(parseLog);
	printf ("\nTotal line Count: %d\n", line_count);
	parser_table.dump();
	
	return 0;
}

