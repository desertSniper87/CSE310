%{
#include <stdio.h>
#include "Symbol_table.h"
#define YYSTYPE Symbol_info*
#include "bits/stdc++.h"
#include "iostream"

FILE *logout;
FILE *tokenout;
FILE *parseLog;

Symbol_table parser_table;
stringstream ss;
extern FILE *yyin;
extern int line_count;
int tempCount = 0, labelCount = 0;

extern int yylex(void);
extern int yyparse(void);

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
%token ID LSQBRAC CONST RSQBRAC FOR LPAREN RPAREN IF STATIC
%token ELSE WHILE PRINTLN RETURN ASSIGNOP LOGICOP REGISTER
%token RELOP ADDOP MULOP NOT INCOP DECOP CONST_CHAR
%token CONST_INT CONST_FLOAT MAIN TYPE_NAME VOLATILE AUTO KEYWORD
%token VOID SHORT LONG DOUBLE SIGNED UNSIGNED EXTERN
%token ENUM IDENTIFIER STRUCT UNION HEADER NUMBER STRING
%token OR_OP AND_OP EQ_OP NE_OP LEFT_OP GE_OP LE_OP RIGHT_OP

%%
start : program;

program : program unit 
        {
            fprintf(parseLog, "program -> program unit\n"); 
        }
        |   unit
        {
            fprintf(parseLog, "program -> unit\n"); 
        }
    ;

unit : var_declaration
     {
            fprintf(parseLog, "unit -> var_declaration\n"); 
     }
     | func_declaration
     {
            fprintf(parseLog, "unit -> func_declaration\n"); 
     }
     | func_definition
     {
            fprintf(parseLog, "unit -> func_definition\n"); 
     }
     ;

func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
                 {
                     fprintf(parseLog, "func_declaration -> type_specifier ID LPAREN parameter_list RPAREN SEMICOLON  \n"); 
                 }
                 ;

func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
                 {
                     fprintf(parseLog, "func_definition -> type_specifier ID LPAREN parameter_list RPAREN compound_statement  \n"); 
                 }
                ;

parameter_list  : parameter_list COMMA type_specifier ID
                 {
                     fprintf(parseLog, "parameter_list  -> parameter_list COMMA type_specifier ID  \n"); 
                 }
                | parameter_list COMMA type_specifier	 
                 {
                     fprintf(parseLog, "parameter_list -> parameter_list COMMA type_specifier	   \n"); 
                 }
                | type_specifier ID
                 {
                     fprintf(parseLog, "parameter_list -> type_specifier ID  \n"); 
                 }
                | unit
                 {
                     fprintf(parseLog, "parameter_list -> unit  \n"); 
                 }
                | type_specifier
                 {
                     fprintf(parseLog, "parameter_list -> type_specifier  \n"); 
                 }
                |
                ;

compound_statement : LCURL statements RCURL
                 {
                     fprintf(parseLog, "compound_statement -> LCURL statements RCURL  \n"); 
                 }
                   | LCURL RCURL
                 {
                     fprintf(parseLog, "compound_statement -> LCURL RCURL  \n"); 
                 }
            ;

var_declaration : type_specifier declaration_list SEMICOLON
                {
                    fprintf(parseLog, "var_declaration -> type_specifier declaration_list SEMICOLON\n"); 
                }
                ;

type_specifier	: INT
                {
                    fprintf(parseLog, "type_specifier -> INT\n"); 
                }
                | FLOAT
                | VOID
                ;

declaration_list : declaration_list COMMA ID
                 {
                     fprintf(parseLog, "declaration_list -> declaration_list COMMA ID \n"); 
                 }
                 | declaration_list COMMA ID LSQBRAC CONST_INT RSQBRAC
                 {
                     fprintf(parseLog, "declaration_list -> declaration_list COMMA ID LSQBRAC CONST_INT RSQBRAC \n"); 
                 }
                 | ID
                 {
                     fprintf(parseLog, "declaration_list -> ID \n"); 
                 }
                 | ID LSQBRAC CONST_INT RSQBRAC
                 {
                     fprintf(parseLog, "declaration_list -> ID LSQBRAC CONST_INT RSQBRAC \n"); 
                 }
                 ;

statements : statement
                 {
                     fprintf(parseLog, "statements -> statement  \n"); 
                 }
           | statements statement
                 {
                     fprintf(parseLog, "statements -> statements statement  \n"); 
                 }
       ;

statement : var_declaration
                 {
                     fprintf(parseLog, "statement -> var_declaration  \n"); 
                 }
          | expression_statement
                 {
                     fprintf(parseLog, "statement -> expression_statement  \n"); 
                 }
      | compound_statement
                 {
                     fprintf(parseLog, "statement -> compound_statement  \n"); 
                 }
      | FOR LPAREN expression_statement expression_statement expression RPAREN statement
                 {
                     fprintf(parseLog, "statement -> FOR LPAREN expression_statement expression_statement expression RPAREN statement  \n"); 
                 }
      | IF LPAREN expression RPAREN statement
                 {
                     fprintf(parseLog, "statement -> IF LPAREN expression RPAREN statement  \n"); 
                 }
      | IF LPAREN expression RPAREN statement ELSE statement
                 {
                     fprintf(parseLog, "statement -> IF LPAREN expression RPAREN statement ELSE statement  \n"); 
                 }
      | WHILE LPAREN expression RPAREN statement
                 {
                     fprintf(parseLog, "statement -> WHILE LPAREN expression RPAREN statement  \n"); 
                 }
      | PRINTLN LPAREN ID RPAREN SEMICOLON
                 {
                     fprintf(parseLog, "statement -> PRINTLN LPAREN ID RPAREN SEMICOLON  \n"); 
                 }
      | RETURN expression SEMICOLON
                 {
                     fprintf(parseLog, "statement -> RETURN expression SEMICOLON  \n"); 
                 }
      ;

expression_statement 	: SEMICOLON			
                 {
                     fprintf(parseLog, "expression_statement -> SEMICOLON  \n"); 
                 }
                      | expression SEMICOLON 
                 {
                     fprintf(parseLog, "expression_statement -> expression SEMICOLON   \n"); 
                 }
            ;

variable : ID 		
                 {
                     fprintf(parseLog, "variable -> ID 		  \n"); 
                 }
         | ID LSQBRAC expression RSQBRAC 
                 {
                     fprintf(parseLog, "variable -> ID LSQBRAC expression RSQBRAC   \n"); 
                 }
     ;

expression : logic_expression	
                 {
                     fprintf(parseLog, "expression -> logic_expression	  \n"); 
                 }
           | variable ASSIGNOP logic_expression 	
                 {
                     fprintf(parseLog, "expression -> variable ASSIGNOP logic_expression 	  \n"); 
                 }
       ;

logic_expression : rel_expression 	
                 {
                     fprintf(parseLog, "logic_expression -> rel_expression 	  \n"); 
                 }
                 | rel_expression LOGICOP rel_expression 	
                 {
                     fprintf(parseLog, "logic_expression -> rel_expression LOGICOP rel_expression 	  \n"); 
                 }
         ;

rel_expression	: simple_expression 
                 {
                     fprintf(parseLog, "rel_expression -> simple_expression   \n"); 
                 }
               | simple_expression RELOP simple_expression	
                 {
                     fprintf(parseLog, "rel_expression -> simple_expression RELOP simple_expression	  \n"); 
                 }
        ;

simple_expression : term 
                 {
                     fprintf(parseLog, "rel_expression -> simple_expression -> term   \n"); 
                 }
                  | simple_expression ADDOP term 
                 {
                     fprintf(parseLog, "rel_expression -> simple_expression ADDOP term   \n"); 
                 }
          ;

term :	unary_expression
                 {
                     fprintf(parseLog, "term -> term ->	unary_expression  \n"); 
                 }
     |  term MULOP unary_expression
                 {
                     fprintf(parseLog, "term -> term MULOP unary_expression  \n"); 
                 }
     ;

unary_expression : ADDOP unary_expression  
                 {
                     fprintf(parseLog, "unary_expression -> ADDOP unary_expression    \n"); 
                 }
                 | NOT unary_expression 
                 {
                     fprintf(parseLog, "unary_expression -> NOT unary_expression   \n"); 
                 }
         | factor 
                 {
                     fprintf(parseLog, "unary_expression -> factor   \n"); 
                 }
         ;

factor	: variable 
                 {
                     fprintf(parseLog, "unary_expression -> factor	-> variable   \n"); 
                 }
       | ID LPAREN argument_list RPAREN
                 {
                     fprintf(parseLog, "unary_expression -> ID LPAREN argument_list RPAREN  \n"); 
                 }
    | LPAREN expression RPAREN
                 {
                     fprintf(parseLog, "unary_expression -> LPAREN expression RPAREN  \n"); 
                 }
    | CONST_INT 
                 {
                     fprintf(parseLog, "unary_expression -> CONST_INT   \n"); 
                 }
    | CONST_FLOAT
                 {
                     fprintf(parseLog, "unary_expression -> CONST_FLOAT  \n"); 
                 }
    | CONST_CHAR
                 {
                     fprintf(parseLog, "unary_expression -> CONST_CHAR  \n"); 
                 }
    | variable INCOP 
                 {
                     fprintf(parseLog, "unary_expression -> variable INCOP   \n"); 
                 }
    | variable DECOP
                 {
                     fprintf(parseLog, "unary_expression -> variable DECOP  \n"); 
                 }
    ;

argument_list : argument_list COMMA logic_expression
                 {
                     fprintf(parseLog, "argument_list -> argument_list COMMA logic_expression  \n"); 
                 }
              | logic_expression
                 {
                     fprintf(parseLog, "argument_list -> logic_expression  \n"); 
                 }
          |
          ;


%%

int main(int argc,char *argv[]){
    adele();
    logout= fopen("log.txt","w");
    tokenout= fopen("token.txt","w");
    parseLog = fopen("parseLog.txt", "w");
    fclose(tokenout);
    yyparse();
    fclose(parseLog);
    printf ("\nTotal line Count: %d\n", line_count);
    parser_table.print(logout);
    fclose(logout);

return 0;
}

