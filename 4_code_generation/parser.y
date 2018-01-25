%{
#include <stdio.h>
#include "Symbol_table.h"
#define YYSTYPE Symbol_info*
#include "bits/stdc++.h"
#include "iostream"

#include "stdlib.h"
#include "string.h"

using namespace std;

FILE *logout;
FILE *tokenout;
FILE *parseLog;
FILE *asmout;

Symbol_table parser_table;
stringstream ss;
extern FILE *yyin;
extern int line_count;

int tempCount = 0, labelCount = 0;

extern int yylex(void);
extern int yyparse(void);

/*extern int error; //TODO: Error reporting*/

extern "C"
{
    //Kill me
}
extern char yytext[];
extern int column;

extern YYSTYPE yylval;

char *newLabel()
{
	char *lb= new char[4];
	strcpy(lb,"L");
	char b[3];
	sprintf(b,"%d", labelCount);
	labelCount++;
	strcat(lb,b);
	return lb;
}

char *newTemp()
{
	char *t= new char[4];
	strcpy(t,"t");
	char b[3];
	sprintf(b,"%d", tempCount);
	tempCount++;
	strcat(t,b);
	return t;
}

string getLabel()	//put type = "b" for byte
{
    stringstream ss;
    ss << "label" << labelCount++;
    return ss.str();
}

string getTemp(string type = "w")	//put type = "b" for byte
{
    stringstream ss;
    return ss.str();
}


//ofstream ir_code_stream; 

void yyerror(char *s)
{
    fprintf(stderr,"At Line %d, ERROR-> %s\n",line_count,s);
    fprintf(parseLog,"At Line %d, ERROR-> %s\n",line_count,s);
    return;
}

void adele(){
    cout << "Hello from the other side"<< endl;
}

%}
%error-verbose

%token SEMICOLON INT FLOAT CHAR COMMA LCURL RCURL 
%token ID LSQBRAC RSQBRAC FOR LPAREN RPAREN IF 
%token ELSE WHILE PRINTLN RETURN ASSIGNOP LOGICOP 
%token RELOP ADDOP MULOP NOT INCOP DECOP 
%token CONST_INT CONST_FLOAT CONST_CHAR
%token VOID

%nonassoc ELSE

%%
start : program
      {
            fprintf(asmout, ($1->code).c_str());
      }
    ;

program : program unit 
        {
            $$ = $1;
            $$->code += $2->code;
            fprintf(parseLog, "GRAMMER RULE: program -> program unit\n"); 
        }
        |   unit
        {
            $$ = $1;
            fprintf(parseLog, "GRAMMER RULE: program -> unit\n"); 
        }
    ;

unit : var_declaration
     {
            $$  = $1;
            fprintf(parseLog, "GRAMMER RULE: unit -> var_declaration\n"); 
     }
     | func_declaration
     {
            $$ = $1;
            fprintf(parseLog, "GRAMMER RULE: unit -> func_declaration\n"); 
     }
     | func_definition
     {
            $$ = $1;
            fprintf(parseLog, "GRAMMER RULE: unit -> func_definition\n"); 
     }
     ;

func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
                 {
                     fprintf(parseLog, "GRAMMER RULE: func_declaration -> type_specifier ID LPAREN parameter_list RPAREN SEMICOLON  \n"); 
                 }
                 ;

func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
                 {
                    $$=new Symbol_info();
                    // Need to work on this
                    /*$$->symbol += $1->symbol;*/
                    /*$$->symbol_type += $1-> symbol_type;*/
                    $$->code+="PROC "+$2->symbol+"\n";

                    if($2->symbol!="main")
                    {
                        $$->code+="PUSH AX\n";
                        $$->code+="PUSH BX\n";
                        $$->code+="PUSH CX\n";
                        $$->code+="PUSH DX\n";
                    }

                    $$->code += $6->code ;

                    if($2->symbol!="main") {
                        $$->code+="POP DX\n";
                        $$->code+="POP CX\n";
                        $$->code+="POP BX\n";
                        $$->code+="POP AX\n";
                    }

                    //Source of problem
                    fprintf(parseLog, "GRAMMER RULE: func_definition -> type_specifier ID LPAREN parameter_list RPAREN compound_statement  \n"); 
                 }
                ;

parameter_list  : parameter_list COMMA type_specifier ID
                {
                    fprintf(parseLog, "GRAMMER RULE: parameter_list  -> parameter_list COMMA type_specifier ID  \n"); 
                }
                | parameter_list COMMA type_specifier	 
                {
                  fprintf(parseLog, "GRAMMER RULE: parameter_list -> parameter_list COMMA type_specifier	   \n"); 
                }
                | type_specifier ID
                {
                    fprintf(parseLog, "GRAMMER RULE: parameter_list -> type_specifier ID  \n"); 
                }
                | unit
                {
                    fprintf(parseLog, "GRAMMER RULE: parameter_list -> unit  \n"); 
                }
                | type_specifier
                {
                  fprintf(parseLog, "GRAMMER RULE: parameter_list -> type_specifier  \n"); 
                }
                |
                ;

compound_statement : LCURL statements RCURL
                 {
                    $$ = $2;
                    /*$$ = $2;*/
                    fprintf(parseLog, "GRAMMER RULE: compound_statement -> LCURL statements RCURL  \n"); 
                 }
                   | LCURL RCURL
                 {
                     fprintf(parseLog, "GRAMMER RULE: compound_statement -> LCURL RCURL  \n"); 
                     $$ = new Symbol_info("compound_statement", "dummy");
                     //TODO Make new Symbol_info
                 }
            ;

var_declaration : type_specifier declaration_list SEMICOLON
                {
                    $$ = $2;
                    /*$$-> symbol_type = $1-> symbol_type;*/
                    fprintf(parseLog, "GRAMMER RULE: var_declaration -> type_specifier declaration_list SEMICOLON\n"); 
                }
                ;

type_specifier	: INT
                {
                    $$ = new Symbol_info("int", "KEYWORD");
                    fprintf(parseLog, "GRAMMER RULE: type_specifier -> INT\n"); 
                }
                | FLOAT
                {
                    $$ = new Symbol_info("float", "KEYWORD");
                    fprintf(parseLog, "GRAMMER RULE: type_specifier -> FLOAT\n"); 
                }
                | VOID
                {
                    $$ = new Symbol_info("void", "KEYWORD");
                    fprintf(parseLog, "GRAMMER RULE: type_specifier -> VOID\n"); 
                }
                ;


declaration_list : declaration_list COMMA ID
                 {
                    // These are the source of all problems
                     //TODO something in line 289
                     fprintf(parseLog, "GRAMMER RULE: declaration_list -> declaration_list COMMA ID \n"); 
                 }
                 | declaration_list COMMA ID LSQBRAC CONST_INT RSQBRAC
                 {
                     fprintf(parseLog, "GRAMMER RULE: declaration_list -> declaration_list COMMA ID LSQBRAC CONST_INT RSQBRAC \n"); 
                 }
                 | ID
                 {
                    $$ = new Symbol_info($1);
                    fprintf(parseLog, "GRAMMER RULE: declaration_list -> ID \n"); 
                 }
                 | ID LSQBRAC CONST_INT RSQBRAC
                 {
                     fprintf(parseLog, "GRAMMER RULE: declaration_list -> ID LSQBRAC CONST_INT RSQBRAC \n"); 
                 }
                 ;

statements : statement
                 {
                     $$ = $1;
                     fprintf(parseLog, "GRAMMER RULE: statements -> statement  \n"); 

                 }
                 | statements statement
                 {
                     fprintf(parseLog, "GRAMMER RULE: statements -> statements statement  \n"); 
                     $$ = $1;
                     $$->code += $2->code;
                     delete $2;
                 }
                 ;

statement : var_declaration
                 {
                    $$=$1;
                    fprintf(parseLog, "GRAMMER RULE: statement -> var_declaration  \n"); 
                 }
                 | expression_statement
                 {
                     $$ = $1;
                     fprintf(parseLog, "GRAMMER RULE: statement -> expression_statement  \n"); 
                 }
                 | compound_statement
                 {
                     $$ = new Symbol_info($1);
                     fprintf(parseLog, "GRAMMER RULE: statement -> compound_statement  \n"); 
                 }
                 | FOR LPAREN expression_statement expression_statement expression RPAREN statement
                 {
					/*
                        for (i=0;i>5;i++) print(x)
						$3's code at first, which is already done by assigning $$=$3
						create two labels and append one of them in $$->code
						compare $4's symbol with 0
						if equal jump to 2nd label
						append $7's code
						append $5's code
						append the second label in the code
					*/
                     $$ = $3;

                     fprintf(parseLog, "GRAMMER RULE: statement -> FOR LPAREN expression_statement expression_statement expression RPAREN statement  \n"); 
                     // TODO Some code in Line 96 of the template
                 }
                 | IF LPAREN expression RPAREN statement
                 {
                    fprintf(parseLog, "GRAMMER RULE: statement -> IF LPAREN expression RPAREN statement  \n"); 
					$$=$3;
					
					char *label=newLabel();
					$$->code+="mov ax, "+$3->getSymbol()+"\n";
					$$->code+="cmp ax, 0\n";
					$$->code+="je "+string(label)+"\n";
					$$->code+=$5->code;
					$$->code+=string(label)+":\n";
                 }
                 | IF LPAREN expression RPAREN statement ELSE statement
                 {
                    fprintf(parseLog, "GRAMMER RULE: statement -> IF LPAREN expression RPAREN statement ELSE statement  \n"); 
                 }
                 | WHILE LPAREN expression RPAREN statement
                 {
                    fprintf(parseLog, "GRAMMER RULE: statement -> WHILE LPAREN expression RPAREN statement  \n"); 
                 }
                 | PRINTLN LPAREN ID RPAREN SEMICOLON
                 {
                    fprintf(parseLog, "GRAMMER RULE: statement -> PRINTLN LPAREN ID RPAREN SEMICOLON  \n"); 
                 }
                 | RETURN expression SEMICOLON
                 {
                    $$ = $1;
                    fprintf(parseLog, "GRAMMER RULE: statement -> RETURN expression SEMICOLON  \n"); 
                 }
                 ;

expression_statement 	: SEMICOLON			
                        {
                            $$ = new Symbol_info(";", "SEMICOLON");
                            fprintf(parseLog, "GRAMMER RULE: expression_statement -> SEMICOLON  \n"); 
                        }
                        | expression SEMICOLON 
                        {
                            $$ = $1;
                            fprintf(parseLog, "GRAMMER RULE: expression_statement -> expression SEMICOLON   \n"); 
                        }
                        ;

variable : ID 		
                 {
                    $$= new Symbol_info($1);
                    fprintf(parseLog, "GRAMMER RULE: variable -> ID 		  \n"); 
                 }
         | ID LSQBRAC expression RSQBRAC 
                 {
                    $$= new Symbol_info($1);
                    $$->setType("array");

                    $$->code=$3->code+"mov bx, " +$3->getSymbol() +"\nadd bx, bx\n";
                    
                    delete $3;
                    $$->print_info();
                    fprintf(parseLog, "GRAMMER RULE: variable -> ID LSQBRAC expression RSQBRAC   \n"); 
                 }
     ;

expression : logic_expression	
           {
               $$ = $1;
               fprintf(parseLog, "GRAMMER RULE: expression -> logic_expression	  \n"); 
           }
           | variable ASSIGNOP logic_expression 	
           {
                // Source of BUG #2
				$$=$1;
				$$->code+=$3->code;
				$$->code+="mov ax, "+$3->getSymbol()+"\n";
				if($$->getType()=="notarray"){ 
					$$->code+= "mov "+$1->getSymbol()+", ax\n";
				}
				
				else{
					$$->code+= "mov  "+$1->getSymbol()+"[bx], ax\n";
				}
				delete $3;
                fprintf(parseLog, "GRAMMER RULE: expression -> variable ASSIGNOP logic_expression 	  \n"); 
           }
       ;

logic_expression : rel_expression 	
                 {
                    $$ = $1;
                    fprintf(parseLog, "GRAMMER RULE: logic_expression -> rel_expression 	  \n"); 
                 }
                 | rel_expression LOGICOP rel_expression 	
                 {
					$$=$1;
					$$->code+=$3->code;
					
					if($2->getSymbol()=="&&"){
						/* 
						Check whether both operands value is 1. If both are one set value of a temporary variable to 1
						otherwise 0
						*/
					}
					else if($2->getSymbol()=="||"){
						
					}
					delete $3;
                    fprintf(parseLog, "GRAMMER RULE: logic_expression -> rel_expression LOGICOP rel_expression 	  \n"); 
                 }
         ;

rel_expression	: simple_expression 
                 {
                     $$=$1;
                     fprintf(parseLog, "GRAMMER RULE: rel_expression -> simple_expression   \n"); 
                 }
               | simple_expression RELOP simple_expression	
                 {
                    $$=$1;
                    $$->code+=$3->code;
                    $$->code+="mov ax, " + $1->getSymbol()+"\n";
                    $$->code+="cmp ax, " + $3->getSymbol()+"\n";
                    char *temp=newTemp();
                    char *label1=newLabel();
                    char *label2=newLabel();
                    if($2->getSymbol()=="<"){
                        $$->code+="jl " + string(label1)+"\n";
                    }
                    else if($2->getSymbol()=="<="){
                    //TODO
                    }
                    else if($2->getSymbol()==">"){
                    }
                    else if($2->getSymbol()==">="){
                    }
                    else if($2->getSymbol()=="=="){
                    }
                    else{
                    }
                    
                    $$->code+="mov "+string(temp) +", 0\n";
                    $$->code+="jmp "+string(label2) +"\n";
                    $$->code+=string(label1)+":\nmov "+string(temp)+", 1\n";
                    $$->code+=string(label2)+":\n";
                    $$->setSymbol(temp);
                    delete $3;

                    fprintf(parseLog, "GRAMMER RULE: rel_expression -> simple_expression RELOP simple_expression	  \n"); 
                 }
        ;

simple_expression : term 
                 {
                     $$ = $1;
                     fprintf(parseLog, "GRAMMER RULE: simple_expression -> term   \n"); 
                 }
                  | simple_expression ADDOP term 
                 {
                    $$=$1;
                    $$->code+=$3->code;
                    
                    // move one of the operands to a register, perform addition or subtraction with the other operand and move the result in a temporary variable  
                    
                    if($2->getSymbol()=="+"){
                    
                    }
                    else{
                    
                    }
                    delete $3;
                    cout << endl;

                    fprintf(parseLog, "GRAMMER RULE: simple_expression -> simple_expression ADDOP term   \n"); 
                 }
          ;

term :	unary_expression
                 {
                    $$ = $1;
                    fprintf(parseLog, "GRAMMER RULE:  term ->	unary_expression  \n"); 
                 }
     |  term MULOP unary_expression
                 {
                    $$=$1;
                    $$->code += $3->code;
                    $$->code += "mov ax, "+ $1->getSymbol()+"\n";
                    $$->code += "mov bx, "+ $3->getSymbol() +"\n";
                    char *temp=newTemp();
                    if($2->getSymbol()=="*"){
                        $$->code += "mul bx\n";
                        $$->code += "mov "+ string(temp) + ", ax\n";
                    }
                    else if($2->getSymbol()=="/"){
                        // TODO
                        // clear dx, perform 'div bx' and mov ax to temp
                    }
                    else{
                        // clear dx, perform 'div bx' and mov dx to temp
                    }
                    $$->setSymbol(temp);
                    cout << endl << $$->code << endl;
                    delete $3;
                    
                    fprintf(parseLog, "GRAMMER RULE: term -> term MULOP unary_expression  \n"); 
                 }
     ;

unary_expression : ADDOP unary_expression  
                 {
                    $$=new Symbol_info($2);
                    //TODO Perform NEG operation if the symbol of ADDOP is '-'
                    fprintf(parseLog, "GRAMMER RULE: unary_expression -> ADDOP unary_expression    \n"); 
                 }
                 | NOT unary_expression 
                 {
                    $$=new Symbol_info($2);
                    char *temp=newTemp();
                    $$->code="mov ax, " + $2->getSymbol() + "\n";
                    $$->code+="not ax\n";
                    $$->code+="mov "+string(temp)+", ax";
                    fprintf(parseLog, "GRAMMER RULE: unary_expression -> NOT unary_expression   \n"); 
                 }
                 | factor 
                 {
                    $$ = $1;
                    fprintf(parseLog, "GRAMMER RULE: unary_expression -> factor   \n"); 
                 }
                 ;

factor	: variable 
        {
			$$= $1;
			if($$->getType()=="notarray"){
			    //TODO Do something
			}
			
			else{
				char *temp= newTemp();
				$$->code+="mov ax, " + $1->getSymbol() + "[bx]\n";
				$$->code+= "mov " + string(temp) + ", ax\n";
				$$->setSymbol(temp);
            }
            fprintf(parseLog, "GRAMMER RULE:  factor  -> variable   \n"); 
        }
        | ID LPAREN argument_list RPAREN
        {
            $$ = $3;

            char *temp= newTemp();
            $$->code+="mov ax, " + $1->getSymbol() + "[bx]\n";
            $$->code+= "mov " + string(temp) + ", ax\n";
            $$->setSymbol(temp);

            fprintf(parseLog, "GRAMMER RULE: factor-> ID LPAREN argument_list RPAREN  \n"); 
        }
        | LPAREN expression RPAREN
        {
           $$ = new Symbol_info($2); 
           fprintf(parseLog, "GRAMMER RULE: factor -> LPAREN expression RPAREN  \n"); 
        }
        | CONST_INT 
        {
            $$ = $1;
            fprintf(parseLog, "GRAMMER RULE: factor -> CONST_INT   \n"); 
        }
        | CONST_FLOAT
        {
            $$ = new Symbol_info($1);
            fprintf(parseLog, "GRAMMER RULE: factor -> CONST_FLOAT  \n"); 
        }
        | CONST_CHAR
        {
            $$ = new Symbol_info($1);
            fprintf(parseLog, "GRAMMER RULE: factor -> CONST_CHAR  \n"); 
        }
        | variable INCOP 
        {
            $$ = new Symbol_info($1);
            // TODO Perform increment
            char *temp = newTemp();
            $$->code+="ADD BX,2\n";
            $$->code+="MOV "+string(temp)+","+$1->symbol+"[BX]\n";
            fprintf(parseLog, "GRAMMER RULE: factor -> variable INCOP   \n"); 
        }
        | variable DECOP
        {
            // TODO 
            fprintf(parseLog, "GRAMMER RULE: factor -> variable DECOP  \n"); 
        }
    ;

argument_list : argument_list COMMA logic_expression
                 {
                     $$ = $1;
                     $$->code += $2->code;
                     fprintf(parseLog, "GRAMMER RULE: argument_list -> argument_list COMMA logic_expression  \n"); 
                 }
              | logic_expression
                 {
                     $$ = $1;
                     fprintf(parseLog, "GRAMMER RULE: argument_list -> logic_expression  \n"); 
                 }
          |
          ;


%%

int main(int argc,char *argv[]){
    adele();
    tokenout= fopen("token.txt","w");
    parseLog = fopen("log.txt", "w");
    asmout = fopen("code.asm", "w");
    fprintf(parseLog, "Program start: Line Count: 1\n");
    yyparse();
    fclose(tokenout);
    fclose(parseLog);
    fclose(asmout);
    printf ("\nTotal line Count: %d\n", line_count);
    /*parser_table.print(logout);*/
    

return 0;
}
