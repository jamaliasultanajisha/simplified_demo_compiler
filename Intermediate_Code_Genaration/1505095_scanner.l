%{

#include"SymbolTable.h"
#include"y.tab.h"

int line_count = 1; 
int error = 0;

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

{ADDOP}   	{
			SymbolInfo * s = new SymbolInfo(yytext, "ADDOP");
			yylval.symVal = s;
			return ADDOP;
		}
	
{MULOP} 	{
			SymbolInfo* s = new SymbolInfo(yytext,"MULOP");
			yylval.symVal = s;			
			return MULOP;
		}
"++" 		{
			return INCOP;
		}

"--"  		{
			return DECOP;
		}


	
"<="|">="|"=="|"!=" {
			SymbolInfo* s = new SymbolInfo(yytext, "RELOP");
			yylval.symVal = s; 
			return RELOP;
		}

"<"|">"		{
			SymbolInfo* s = new SymbolInfo(yytext, "RELOP");
			yylval.symVal = s; 			
			return RELOP;
		}

"=" 		{
			return ASSIGNOP;
		}

"&&"|"||" { 
			SymbolInfo* s = new SymbolInfo(yytext, "LOGICOP");
			yylval.symVal = s; 			
			return LOGICOP;
		}

"(" 		{
			return LPAREN;
		}

")" 		{	 
			return RPAREN;
		}

"{" 		{
			return LCURL;
		}

"}" 		{
			return RCURL;
		}

"[" 		{
			return LTHIRD;
		}

"]" 		{
			return RTHIRD;
		}

";" 		{ 
			return SEMICOLON;
		}

"," 		{ 
			return COMMA;		
		}
"!"		{
			return NOT;
		}



{integer}       {
			SymbolInfo* s =new  SymbolInfo(yytext, "CONST_INT");
			yylval.symVal= s;
			return CONST_INT;
		}

{number}  	{
			SymbolInfo* s =new  SymbolInfo(yytext, "CONST_FLOAT");
			yylval.symVal = s;
			return CONST_FLOAT;
		}
{id}		{
			SymbolInfo* s =new  SymbolInfo(yytext, "ID");
			yylval.symVal= s;
			return ID;
		}


([']{1,1}[a-zA-Z]{1,1}[']{1,1})     {
					string name;
					name.push_back(yytext[1]);
					SymbolInfo* s =new SymbolInfo(name, "CONST_CHAR");
					yylval.symVal= s;
					return CONST_CHAR;
				     }

\'(\\t)\'                            {
                                             SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
			                     yylval.symVal= s;
                                            return CONST_CHAR; 
                                      }

\'(\\n)\'                             {
                                            SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
					    yylval.symVal= s;
                                            return CONST_CHAR; 
                                       }

\'(\\r)\'                              {
                                            SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
					    yylval.symVal= s;
                                            return CONST_CHAR; 
                                       }

\'(\\f)\'                              {
                                            SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
			                    yylval.symVal= s;
                                            return CONST_CHAR;
                                        }

\'(\\a)\'                               {
                                            SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
					    yylval.symVal= s;
                                            return CONST_CHAR; 
                                         }

\'(\\b)\'                                {
                                            SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
					    yylval.symVal= s;
                                            return CONST_CHAR; 
                                         }

\'(\\v)\'                                {
                                            SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
					    yylval.symVal= s;
                                            return CONST_CHAR; 
                                          }

\'(\\0)\'                                {
                                            SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
					    yylval.symVal= s;
                                            return CONST_CHAR; 
                                          }
 
\'(\\'')\'		 {
                                            SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
					    yylval.symVal= s;
                                            return CONST_CHAR; 
                         }

\'(\\\\)\'		{
                                            SymbolInfo* s =new  SymbolInfo(yytext, "CONST_CHAR");
			         	    yylval.symVal= s;
                                            return CONST_CHAR; 
                         }

\/\/((.*\\\n?.*)*|.*)       | 

"/*"([^*]|\*+[^*/])*\*+"/" 	{
					for(int i = 0; i<yyleng ; i++){if(yytext[i] == '\n') line_count++;}
					return COMMENT;
				}

.		{
			error++;
		}

%%

int yywrap(void)
{
	return 1;
}
