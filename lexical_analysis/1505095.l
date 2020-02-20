%option noyywrap

%{
#include<cstdio>
#include<cstdlib>
#include<string>
#include<vector>
#include"symboltable.h"

using namespace std;

int line_count=1;
int error=0;

FILE *logout;
FILE *tokenout;
ofstream fw;

class SymbolInfo{
public:
	string symbol;
	string type;
	SymbolInfo(){
		symbol="";type="";
	}
	SymbolInfo(string symbol,string type){
		this->symbol=symbol;this->type=type;
	}
};
class ScopeTable{
	vector<SymbolInfo *> syminfo;
	public:
	void insert(SymbolInfo *s){
		syminfo.push_back(s);
	}
	void print(){
		for(int i=0;i<syminfo.size();i++){
			fprintf(logout,"\n%s %s\n",syminfo[i]->symbol.c_str(),syminfo[i]->type.c_str());
		}
	}
};

ScopeTable st;
symbolTable* table=new symbolTable();
struct hash_Map* curr;
int key;
     void logprint(int line_count,char* yytext){
           fprintf(logout,"Line no %d: Lexeme %s found",line_count,yytext);
           }
%}


WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
IDENTIFIER [_a-zA-Z][_0-9a-zA-Z]*
EXPONENTIAL [E]-?[0-9]+
NEWLINE \n
NEWLINES \r
LITERAL [\n\t\f\r\v\b\a\\\'']

%%

{NEWLINE} {line_count++;}

{WHITESPACE}    {}

"if"	{
			fprintf(tokenout,"<IF>");
			fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n\n",line_count,yytext);
		}
		
"else"	{
			fprintf(tokenout,"<ELSE>");
			fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n\n",line_count,yytext);
		}

"for"	{
			fprintf(tokenout,"<FOR>");
			fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n\n",line_count,yytext);
		}

"while"	{
			fprintf(tokenout,"<WHILE>");
			fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n\n",line_count,yytext);
		}

"do"	{
			fprintf(tokenout,"<DO>");
			fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n\n",line_count,yytext);
		}

"break"	{
			fprintf(tokenout,"<BREAK>");
			fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n\n",line_count,yytext);
		}

"int"	{
			fprintf(tokenout,"<INT>");
			fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n\n",line_count,yytext);
		}

"float"	{
			fprintf(tokenout,"<FLOAT>");
			fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n\n",line_count,yytext);
		}

"char"	{
			fprintf(tokenout,"<CHAR>");
			fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n\n",line_count,yytext);
		}

"double"	{
			fprintf(tokenout,"<DOUBLE>");
			fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n\n",line_count,yytext);
		}

"void"	       {
			fprintf(tokenout,"<VOID>");
			fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n\n",line_count,yytext);
		}

"return"	{
			fprintf(tokenout,"<RETURN>");
			fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n\n",line_count,yytext);
		}

"switch"	{
			fprintf(tokenout,"<SWITCH>");
			fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n\n",line_count,yytext);
		}

"case"	        {
			fprintf(tokenout,"<CASE>");
			fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n\n",line_count,yytext);
		}

"default"	{
			fprintf(tokenout,"<DEFAULT>");
			fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n\n",line_count,yytext);
		}

"continue"	{
			fprintf(tokenout,"<CONTINUE>");
			fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n\n",line_count,yytext);
		}
"+"		|

"-"		{
                        key=curr->hash_function(yytext);
			fprintf(tokenout,"<ADDOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n\n",line_count,yytext);
                        //table->insertCurrent(curr,yytext,key,curr->count,"ADDOP",logout);
                        //table->printAll(curr,logout);
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}
		
"*"		|

"/"             |

"%"		{
			fprintf(tokenout,"<MULOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n\n",line_count,yytext);
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"++"		|

"--"		{
			fprintf(tokenout,"<INCOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n\n",line_count,yytext);
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"<"		|

"<="            |

">"             |

">="            |

"=="            |

"!="		{
			fprintf(tokenout,"<RELOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"="		{
			fprintf(tokenout,"<ASSINGOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ASSINGOP> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"&&"		|

"||"		{
			fprintf(tokenout,"<LOGICOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"&"		|

"|"             |

"^"             |

"<<"            |

">>"		{
			fprintf(tokenout,"<BITOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <BITOP> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"!"		{
			fprintf(tokenout,"<NOT,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <NOT> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"("		{
			fprintf(tokenout,"<LPAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

")"		{
			fprintf(tokenout,"<RPAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"{"		{
			fprintf(tokenout,"<LCURL,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"}"		{
			fprintf(tokenout,"<RCURL,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RCURL> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"["		{
			fprintf(tokenout,"<LTHIRD,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

"]"		{
			fprintf(tokenout,"<RTHIRD,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

","		{
			fprintf(tokenout,"<COMMA,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

";"		{
			fprintf(tokenout,"<SEMICOLON,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n\n",line_count,yytext);
                        //insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}

{IDENTIFIER}    {
                        fprintf(tokenout,"<ID,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n\n",line_count,yytext);
                        key=curr->hash_function(yytext);
                        table->insertCurrent(curr,yytext,key,curr->count,"ID",logout);
                        table->printAll(curr,logout);

                }

{DIGIT}+ 	{
				fprintf(tokenout,"<CONST_INT,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n\n",line_count,yytext);
                                key=curr->hash_function(yytext);
                                table->insertCurrent(curr,yytext,key,curr->count,"CONST_INT",logout);
                                table->printAll(curr,logout);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//SymbolInfo *si=new SymbolInfo(string(yytext),"CONST_INT");
				//st.insert(si);
		}

([0-9]*[.])?[0-9]+(E(-)?[0-9]+)? {
				fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n\n",line_count,yytext);
                                key=curr->hash_function(yytext);
                                table->insertCurrent(curr,yytext,key,curr->count,"CONST_FLOAT",logout);
                                table->printAll(curr,logout);
				//insert in symbol table and print symbol table content(only non empty buckets)
				SymbolInfo *si=new SymbolInfo(string(yytext),"CONST_FLOAT");
				st.insert(si);
                              //  st.print();
		}

\"([^"\\\n]|\\(.|\n))*\"      |

\"([^"\\\n]|\\(.|\r?\n))*\"  {
                              // string str;
                             //  string st;
                              // string str=yytext;
                              // const char* c = str.c_str();
                              // char* ch=strdup(c);
                              // fprintf(tokenout,"<STRING,%s>",ch);
                               fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n\n",line_count,yytext);
                               for(int i=0;i<yyleng;i++)
                               {
                                 if(yytext[i]=='\\' && yytext[i+1]=='t')
                                    {
                                         yytext[i]='	';
                                         yytext[i+1]=yytext[i+2];
                                         i++;
                                     }
                                }
                               for(int i=0;i<yyleng;i++)
                               {
                                 if(yytext[i]=='\\' && yytext[i+1]=='n')
                                    {
                                         yytext[i]='\n';
                                         yytext[i+1]=yytext[i+2];
                                         i++;
                                     }
                                }
                               for(int i=0;i<yyleng;i++)
                               {
                                 if(yytext[i]=='\\' && yytext[i+1]=='a')
                                    {
                                         yytext[i]='\a';
                                         yytext[i+1]=yytext[i+2];
                                         i++;
                                     }
                                }
				for(int i=0;i<yyleng;i++)
                               {
                                 if(yytext[i]=='\\' && yytext[i+1]=='b')
                                    {
                                         yytext[i]='\b';
                                         yytext[i+1]=yytext[i+2];
                                         i++;
                                     }
                                }
				for(int i=0;i<yyleng;i++)
                               {
                                 if(yytext[i]=='\\' && yytext[i+1]=='f')
                                    {
                                         yytext[i]='\f';
                                         yytext[i+1]=yytext[i+2];
                                         i++;
                                     }
                                }
				for(int i=0;i<yyleng;i++)
                               {
                                 if(yytext[i]=='\\' && yytext[i+1]=='r')
                                    {
                                         yytext[i]='\r';
                                         yytext[i+1]=yytext[i+2];
                                         i++;
                                     }
                                }
				for(int i=0;i<yyleng;i++)
                               {
                                 if(yytext[i]=='\\' && yytext[i+1]=='v')
                                    {
                                         yytext[i]='\v';
                                         yytext[i+1]=yytext[i+2];
                                         i++;
                                     }
                                }
                                 for(int i=0;i<yyleng;i++)
                               {
                                 if(yytext[i]=='\\' && yytext[i+1]=='\n')
                                    {
                                         yytext[i]=yytext[i+2];
                                         i++;
                                     }
                                }
                                 yytext[yyleng-2]=0;
                                 fprintf(tokenout,"<STRING,%s\">",yytext);
                               for(int i=0;i<yyleng;i++)
                                  {
                                      if(yytext[i]=='\n')
                                         {
                                                line_count++;
                                         }
                                  } 
                              }

([']{1,1}[a-zA-Z]{1,1}[']{1,1})         {
                                                     fprintf(tokenout,"<CONST_CHAR,%c>",yytext[1]);
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\'(\\t)\'                                {
                                                     fprintf(tokenout,"<CONST_CHAR,\t>");
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\'(\\n)\'                                {
                                                     fprintf(tokenout,"<CONST_CHAR,\n>");
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\'(\\r)\'                                {
                                                     fprintf(tokenout,"<CONST_CHAR,\r>");
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\'(\\f)\'                                {
                                                     fprintf(tokenout,"<CONST_CHAR,\f>");
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\'(\\a)\'                                {
                                                     fprintf(tokenout,"<CONST_CHAR,\a>");
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\'(\\b)\'                                {
                                                     fprintf(tokenout,"<CONST_CHAR,\b>");
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\'(\\v)\'                                {
                                                     fprintf(tokenout,"<CONST_CHAR,\v>");
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\'(\\0)\'                                {
                                                     fprintf(tokenout,"<CONST_CHAR,0>");
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }
 
\'(\\'')\'		 {
                                                     fprintf(tokenout,"<CONST_CHAR,%c%c>",yytext[2],yytext[3]);
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\'(\\\\)\'		{
                                                     fprintf(tokenout,"<CONST_CHAR,\\>");
			                             fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
                                                     key=curr->hash_function(yytext);
                                                     table->insertCurrent(curr,yytext,key,curr->count,"CONST_CHAR",logout);
                                                     table->printAll(curr,logout); 
                                                   }

\/\/((.*\\\n?.*)*|.*)       | 

"/*"([^*]|\*+[^*/])*\*+"/"          {  //   \/\/(([^*]|\*+[^*/])*(\\\n)?.*(\\n)?)*  
					      fprintf(logout,"Line no %d: COMMENT Lexeme %s found\n\n",line_count,yytext); 
				              for(int i=0;i<yyleng;i++)
				                  {
				                      if(yytext[i]=='\n')
				                         {
				                                line_count++;
				                         }
				                  }
				         }

[0-9]+{IDENTIFIER} {
                         fprintf(logout,"Line no %d: %s Invalid Suffix on numeric constant or invalid prefix on identifier\n\n",line_count,yytext);
                       error++; 
                   }

\'([^"\\\n]|\\(.|\n))+\'   {
					fprintf(logout,"Line no %d: Multicharacter constant %s error\n\n",line_count,yytext);
                                        error++; 
				   }

[']{1,1}[a-zA-z\n]{1,1}|['][\\][']    {
                                      fprintf(logout,"Line no %d: %s Unfinished character\n\n",line_count,yytext);
                                      error++; 
                                     }

([0-9]*[.]+)+[0-9]+(E(-)?[0-9]+)? {
                                   fprintf(logout,"Line no %d: %s Too many decimal point error\n\n",line_count,yytext);
                                   error++;
                                  }

([0-9E]*[.])?[0-9]+((-)?[0-9]+)? {
                                   fprintf(logout,"Line no %d: %s Ill formed number error\n\n",line_count,yytext);
                                   error++;
                                  }

\"([^"\\\n]|\\(.|\n))*      |

\"(([^*]|\*+[^*/])*\\\\n(.*)) |

\"([^"\\\n]|\\(.|\n))\\\\\n?                    {
			      //string     \"(\\\n.|[^"\\])*$          \"[^\n\"]+\\\n
                              fprintf(logout,"Line no %d: %s Unfinished string error\n\n",line_count,yytext);
                              error++;
                              for(int i=0;i<yyleng;i++)
                                  {
                                      if(yytext[i]=='\n')
                                         {
                                                line_count++;
                                         }
                                  }
                              }

\/\/((.*\\\n?.*)*|.*)|"/*"([^*]|\*+[^*/])*\**    {
                                                    fprintf(logout,"Line no %d: Unfinished comment error %s\n\n",line_count,yytext);
                                                    error++;
						    for(int i=0;i<yyleng;i++)
                                                    {
                                                        if(yytext[i]=='\n')
                                                          {
                                                             line_count++;
                                                           }
                                                     }
                                                 }
\'\'      {
                  fprintf(logout,"Line no %d: Empty character constant error %s \n\n",line_count,yytext);
                  error++;
               }
\'     {
                  fprintf(logout,"Line no %d: Empty character constant error %s \n\n",line_count,yytext);
                  error++;
               }

(\\)+       {
                  fprintf(logout,"Line no %d: Unrecognized characters %s\n\n",line_count,yytext);
                  error++;
               }

(#)+       {
                  fprintf(logout,"Line no %d: Unrecognized characters %s\n\n",line_count,yytext);
                  error++;
               }

(&|@|:)+       {
                  fprintf(logout,"Line no %d: Unrecognized characters %s\n\n",line_count,yytext);
                  error++;
               }

<<EOF>> {
         fprintf(logout,"Total Line Number: %d\n\n",line_count-1);
         fprintf(logout,"Total Number Of Error: %d\n\n",error); 
         return 0;
        }

%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
        hash_Map* root=new hash_Map();
      //  symbolTable* table=new symbolTable();
        root->parent=0;
        root->next=0;
        root->id=1;
       // struct hash_Map* curr;
        curr=root;
      void logprint(int line_count,char* yytext);
	
	logout= fopen("1505095_log.txt","w");
	tokenout= fopen("1505095_token.txt","w");
        fw.open("1505095log.txt");

	yyin= fin;
	yylex();
	st.print();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
