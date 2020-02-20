%{
#include<iostream>
#include<bits/stdc++.h>
#include<stdlib.h>
#include<string.h>
//#define YYSTYPE SymbolInfo*
//#include "symboltable.h"
#include "SymbolInfo.h"
#include "y.tab.h"



using namespace std;

extern YYSTYPE yylval;
void yyerrok(char *);
void yyerror(char *);
//extern symbolTable* table;

int line_count=1;
//int error=0;

%}



digit [0-9]
letter [A-Za-z]
delim [ \t\r\f\v]
newline \n
newlines \r
ws [delim]+
id (_|{letter})(_|{letter}|{digit})*
integer {digit}+
number {digit}*(\.{digit}+)?(E[+-]?{digit}+)?
ADDOP [+-] 
MULOP [*/%]
LITERAL [\n\t\f\r\v\b\a\\\'']

%%

{delim}+	{}
{newline} {line_count++;}

"if" {return IF;}
"else" {return ELSE;}
"for" {return FOR;}
"while" {return WHILE;}
"do"	{return DO;}
"break"	{return BREAK;}
"int" {return INT;}
"float" {return FLOAT;}
"double" {return DOUBLE;}
"char" {return CHAR;}
"return" {return RETURN;}
"void" {return VOID;}
"switch"	{return SWITCH;}

"case"	        {return CASE;}

"default"	{return DEFAULT;}

"continue"	{return CONTINUE;}
"println"	{return PRINTLN;}

{ADDOP} { 
			SymbolInfo *s= new  SymbolInfo(yytext, (char *)"ADDOP");
			//yylval.s[1].symbol=strdup(yytext);
			yylval.sval = strdup(yytext);
			return ADDOP;
		}



{MULOP}	{
			SymbolInfo *s= new  SymbolInfo(yytext, (char *)"MULOP");
			//yylval = (YYSTYPE)s;
			yylval.sval = strdup(yytext);
			return MULOP;
		}


"=" 	{return ASSIGNOP;}

">" {
		SymbolInfo *s= new  SymbolInfo(yytext, (char *)"RELOP");
		yylval.sval = strdup(yytext); if(yylval.sval==">") 
		return RELOP;
	}
"<" {
		SymbolInfo *s= new  SymbolInfo(yytext, (char *)"RELOP");
		yylval.sval = strdup(yytext);
		return RELOP;
	}
">=" {
		SymbolInfo *s= new  SymbolInfo(yytext, (char *)"RELOP");
		yylval.sval = strdup(yytext);
		return RELOP;
	}
"<=" {
		SymbolInfo *s= new  SymbolInfo(yytext, (char *)"RELOP");
		yylval.sval = strdup(yytext);
		return RELOP;
	}
"==" {
		SymbolInfo *s= new  SymbolInfo(yytext, (char *)"RELOP");
		yylval.sval = strdup(yytext);
		return RELOP;
	}
"!=" {
		SymbolInfo *s= new  SymbolInfo(yytext, (char *)"RELOP");
		yylval.sval = strdup(yytext);
		return RELOP;
	}

"&&"	{
			SymbolInfo *s= new  SymbolInfo(yytext, (char *)"LOGICOP");
			yylval.sval = strdup(yytext);
			return LOGICOP;
		}
"||"	{
			SymbolInfo *s= new  SymbolInfo(yytext, (char *)"LOGICOP");
			yylval.sval = strdup(yytext);
			return LOGICOP;
		}
"!"		{	return NOT; }


";" 	{ return SEMICOLON;}
"," 	{return COMMA;}
"(" 	{return LPAREN;}
")" 	{return RPAREN;}
"{" 	{return LCURL;}
"}" 	{return RCURL;}
"[" 	{return LTHIRD;}
"]" 	{return RTHIRD;}
"++" 	{return INCOP;}
"--" 	{return DECOP;}



{integer}	{
				SymbolInfo *s= new  SymbolInfo(strdup(yytext), (char *)"CONST_INT");
				yylval.sval = strdup(yytext);
				//printf("\n\n%s\n",s->symbol.c_str());
                               // printf("%s\n",yylval.symbolinfo.symbol.c_str()); 
				return CONST_INT;
			}
{number} 	{	
				SymbolInfo *s= new  SymbolInfo(strdup(yytext), (char *)"CONST_FLOAT");
				yylval.sval = strdup(yytext);
				return CONST_FLOAT; 
			}
{id} 		{	 
				
				SymbolInfo *s;
			//= table->lookUp(yytext);
				//if(s==NULL)
			//	{					
					s= new SymbolInfo(yytext, (char *)"ID");
			//	}
				//yylval.symbolinfo[0] = yytext[0];
				yylval.sval = strdup(yytext);
				//printf("%s\n",yylval.sval);							
				return ID;
			}
([']{1,1}[a-zA-Z]{1,1}[']{1,1})         {
                                            yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }

\'(\\t)\'                                {
                                                      yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }

\'(\\n)\'                                {
                                                      yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }

\'(\\r)\'                                {
                                                      yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }

\'(\\f)\'                                {
                                                     yylval.ival=atoi(yytext);
                                            return CONST_CHAR;
                                                   }

\'(\\a)\'                                {
                                                      yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }

\'(\\b)\'                                {
                                                      yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }

\'(\\v)\'                                {
                                                      yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }

\'(\\0)\'                                {
                                                      yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }
 
\'(\\'')\'		 {
                                                      yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }

\'(\\\\)\'		{
                                                      yylval.ival=atoi(yytext);
                                            return CONST_CHAR; 
                                                   }

\/\/((.*\\\n?.*)*|.*)       | 

"/*"([^*]|\*+[^*/])*\*+"/"          { 
				              for(int i=0;i<yyleng;i++)
				                  {
				                      if(yytext[i]=='\n')
				                         {
				                                line_count++;
				                         }
				                  }
				         }

. 	{
		char msg[25];
		sprintf(msg,"%s <%s>","invalid character",yytext);
		yyerror(msg);
	}
%%

int yywrap(void)
{
	return 1;
}
