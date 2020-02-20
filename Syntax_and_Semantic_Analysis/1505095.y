%{
#include<iostream>
#include<bits/stdc++.h>
#include<cstdlib>
#include<cstring>
#include<string>
#include<cmath>
#include<vector>
#include <fstream>
#include "symboltable.h"
//#define YYSTYPE SymbolInfo*

using namespace std;

int yyparse(void);
int yylex(void);
extern "C" FILE *yyin;
char var[26];
string str[26],fact[26];
char dect[500];char vardect[700];char funct[700];char functd[700];char unitcode[700];char parat[70];char simple[70];
char relation[70];char state[7000];char statet[7000];char comstatet[700];char express[700];char expresstate[700];char termt[700];
char unexp[700];char factt[70];char logic[70];char argu[700];char argut[700];char prevsimple[70];
int i=0,j=0,flag=0,parano=0,arguno=0,varid=1,vararr=1;
string s,arr,returntype,retype,idname,voidtype,dectype;


FILE *logout;
FILE *errorout;

extern int line_count;
int error=0;

hash_Map* root=new hash_Map();
symbolTable* table=new symbolTable();
struct hash_Map* curr;
struct hash_Map* curr1;
struct symbol_info* temp;
struct symbol_info* temp1;
int key;

struct SymbolInfo{
public:
	string symbol;
	string type;
	SymbolInfo(){
		symbol="";type="";
	}
	SymbolInfo(string symbol,string type){
		this->symbol=symbol;this->type=type;
	}
}symbolinfo;

struct hash_Map* openfile()
{
        ifstream filein;
        string line;
        filein.open ("input.txt");

    if ( filein.is_open ( ))
    {
        while ( getline( filein, line ))
        {
            vector < string > tab;
            stringstream strstrm ( line );
            while ( getline (strstrm,line, '\n'))
            {
                tab.push_back(line);
            }
            int i=0;
            while(1)
            {
                if ( i== tab.size())
                {
                    break;
                }
                cout<<"........."<<endl;
                i++;
            }
        //    for(int i=0; i<tab.size(); i++)
            {
                if(tab[0].compare("{")==0) // {cout<<i<<endl;}
                {
                    curr=table->enterScope(curr,logout);

                }

            }

        }
    }
return curr;
}
string id;
ofstream fileout;
//string line;
//ifstream myfile ("input.txt");
			   //   if(myfile.is_open()){
			     // while(getline (myfile,line))
			    //  {fileout<<$1 <<" "<<$2<<" "<<";"<<"\n";}
                              //}
			   

void yyerrok(char *s)
{
	//write your code
	fprintf(errorout,"Error at line %d : %s\n\n may add a semicolon(;)",line_count,s);
	return;
}

void yyerror(char *s)
{
	//write your code
	fprintf(errorout,"Error at line %d : %s\n",line_count,s);
	return;
}


%}

%union { double dval; int ival; char *sval;char cval;struct SymbolInfo{
public:
	string symbol;
	string type;
	SymbolInfo(){
		symbol="";type="";
	}
	SymbolInfo(string symbol,string type){
		this->symbol=symbol;this->type=type;
	}
}*symbolinfo;}

%start start

%token <sval> IF ELSE FOR WHILE DO BREAK SWITCH CASE DEFAULT CONTINUE CHAR RETURN VOID PRINTLN ADDOP MULOP ASSIGNOP RELOP LOGICOP NOT SEMICOLON COMMA LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD INCOP DECOP ID INT CONST_INT CONST_FLOAT
%token <ival> CONST_CHAR
%token <dval> FLOAT DOUBLE

//%left 
//%right

%nonassoc LOWER_THAN_ELSE CONST_FLOAT
%nonassoc ELSE RTHIRD

%type <sval> unit program var_declaration type_specifier declaration_list func_declaration func_definition variable parameter_list factor 
compound_statement statements statement expression_statement expression logic_expression unary_expression simple_expression term arguments
rel_expression argument_list
%%

start : program
	{
		//write your code in this block in all the similar blocks below
		table->printAll(curr,logout);
		fprintf(logout,"Total line count: %d \n\n",line_count-1);
                fprintf(logout,"Total error count: %d \n\n",error);
                fprintf(errorout,"Total error count: %d \n\n",error);
		//openfile();
	}
	;

program : program unit {fprintf(logout,"At line no: %d program: program unit\n\n",line_count);
				//fprintf(logout,"%s \n",vardect);
			/*int i=0;strcat(unitcode,vardect);strcat(unitcode,"\n");strcat(unitcode,funct);strcat(unitcode,"\n");
strcat(unitcode,functd);strcat(unitcode,"\n");*/
		   {fprintf(logout,"%s\n\n",unitcode);  i++;} 
			memset(&dect[0], 0, sizeof(dect)); 
			memset(&vardect[0], 0, sizeof(vardect)); 
			//memset(&funct[0], 0, sizeof(funct)); 
			//memset(&functd[0], 0, sizeof(functd)); 
			//memset(&simple[0], 0, sizeof(simple)); cout<<simple<<"clearing memory"<<endl;
			memset(&statet[0], 0, sizeof(statet)); 
			memset(&state[0], 0, sizeof(state)); 
			//memset(&relation[0], 0, sizeof(relation)); cout<<relation<<"clearing memory"<<endl;
			//memset(&express[0], 0, sizeof(express)); cout<<express<<"clearing memory"<<endl;
			//memset(&expresstate[0], 0, sizeof(expresstate)); 
			//memset(&comstatet[0], 0, sizeof(comstatet));
			//memset(&var[0], 0, sizeof(var)); cout<<simple<<"clearing memory"<<endl;
			//memset(&termt[0], 0, sizeof(termt)); cout<<termt<<"clearing memory"<<endl;
			//memset(&factt[0], 0, sizeof(factt)); cout<<factt<<"clearing memory"<<endl;
			//memset(&unexp[0], 0, sizeof(unexp)); cout<<unexp<<"clearing memory"<<endl;
			}
	| unit       {fprintf(logout,"At line no: %d program: unit\n\n",line_count); $$=$1;
			fprintf(logout,"%s \n\n",unitcode);
			memset(&dect[0], 0, sizeof(dect)); 
                        memset(&vardect[0], 0, sizeof(vardect));}
	;
	
unit : var_declaration   {fprintf(logout,"At line no: %d unit: var_declaration\n\n",line_count);
			   strcat(unitcode,vardect);
			//   memset(&vardect[0], 0, sizeof(vardect)); cout<<vardect<<"clearing memory"<<endl;
                           fprintf(logout,"%s \n\n",vardect);
			 }
     | func_declaration  {fprintf(logout,"At line no: %d unit: func_declaration\n\n",line_count);
				strcat(unitcode,funct);
				fprintf(logout,"%s \n\n",funct);}
     | func_definition   {fprintf(logout,"At line no: %d unit: func_definition\n\n",line_count); //$$=$1;
				strcat(unitcode,functd);
				fprintf(logout,"%s \n\n",functd);}
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {fprintf(logout,"At line no: %d func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n",line_count);
			//fprintf(logout,"%s %s(%s); \n\n",$1,$2,$4);
			 int key=root->hash_function($2);cout<<"wertyuiopsdfghjklzxcvbnm,	"<<parano<<endl;
                         table->insertCurrent(root,$2,key,root->count,"ID",$1,"function",parano,logout);
			memset(&funct[0], 0, sizeof(funct)); 
			 int i=0; strcat(funct,$1);strcat(funct," ");strcat(funct,$2);strcat(funct,"(");strcat(funct,parat);
strcat(funct,")");strcat(funct,";");
		   {fprintf(logout,"%s\n\n",funct);  i++;} parano=0;}
		| type_specifier ID LPAREN RPAREN SEMICOLON   {fprintf(logout,"At line no: %d func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n\n",line_count);
			//fprintf(logout,"%s %s(); \n\n",$1,$2);
                        int key=root->hash_function($2);
                        table->insertCurrent(root,$2,key,root->count,"ID",$1,"function",0,logout);
				memset(&funct[0], 0, sizeof(funct));
			  int i=0; strcat(funct,$1);strcat(funct," ");strcat(funct,$2);strcat(funct,"()");
strcat(funct,";");
		   {fprintf(logout,"%s\n\n",funct);  i++;} }
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN { //curr=table->enterScope(curr,logout);//curr1=curr;
				if((temp=table->lookUp(root,$2))) {cout<<"func_declare....................."<<$2<<endl;}
				 int key=root->hash_function($2); 
cout<<"wertyuiopsdfghjklzxcvbnm,	"<<parano<<endl;
                                 table->insertCurrent(root,$2,key,root->count,"ID",$1,"function",parano,logout);} compound_statement   {fprintf(logout,"At line no: %d func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n",line_count);
			memset(&functd[0], 0, sizeof(functd)); 
			 int i=0; strcat(functd,$1);strcat(functd," ");strcat(functd,$2);strcat(functd,"( ");strcat(functd,parat);
strcat(functd," )");strcat(functd,comstatet);
		   {fprintf(logout,"%s\n\n",functd);  i++;} parano=0;

				/*fprintf(logout,"%s %s (%s) %s \n\n",$1,$2,$4,$7);*/cout<<curr->id<<"???????"<<endl;// cout<<$1<<$2<<"("<<$4<<")"<<endl;
				if((temp=table->lookUp(curr1,$2)) && (temp1=table->lookUp(curr,$4))) {cout<<temp->str<<temp->type<<temp->nametype<<temp1->str<<temp1->type<<temp1->nametype<<"'''''"<<endl;returntype=temp1->nametype;retype=temp1->type;}}

		| type_specifier ID LPAREN RPAREN { curr=table->enterScope(curr,logout);
				if((temp=table->lookUp(root,$2)) && (temp=table->lookUp(root,$2))->type!=$1) {fprintf(errorout,"Error at line %d : type mismatch with function declaration\n\n",line_count);error++;}

				int key=root->hash_function($2); 
                                table->insertCurrent(root,$2,key,root->count,"ID",$1,"function",0,logout);
if((temp=table->lookUp(root,"main"))){cout<<temp->str<<"............................."<<endl;}} compound_statement   {fprintf(logout,"At line no: %d func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n",line_count);
				memset(&functd[0], 0, sizeof(functd)); 
				int i=0; strcat(functd,$1);strcat(functd," ");strcat(functd,$2);strcat(functd,"()");
strcat(functd,comstatet);
		   {fprintf(logout,"%s\n\n",functd);  i++;}if((temp=table->lookUp(root,"main"))){cout<<temp->str<<"............................."<<endl;}

				/*fprintf(logout,"%s %s () \n\n",$1,$2);*/}
 		;				


parameter_list  : parameter_list COMMA type_specifier ID  {fprintf(logout,"At line no: %d parameter_list : parameter_list COMMA type_specifier ID\n\n",line_count); 
		//fprintf(logout,"%s %s,%s %s\n\n",$3,$$,$3,$4);//{ curr= table->exitScope(root,logout);}
		
		int i=0; strcat(parat,",");strcat(parat,$3);strcat(parat," ");strcat(parat,$4);{fprintf(logout,"%s\n\n",parat);  i++;}
		int key=curr->hash_function($4); parano++; 
                table->insertCurrent(curr,$4,key,curr->count,"ID",$3,"variable",0,logout);}
		| parameter_list COMMA type_specifier  {fprintf(logout,"At line no: %d parameter_list : parameter_list COMMA type_specifier\n\n",line_count);
		int i=0; strcat(parat,",");strcat(parat,$3);strcat(parat," ");{fprintf(logout,"%s\n\n",parat);  i++;} parano++;
							}
 		| type_specifier ID {fprintf(logout,"At line no: %d parameter_list : type_specifier ID\n\n",line_count); $$=$2;
					//fprintf(logout,"%s %s\n\n",$1,$2);//{ curr= table->exitScope(root,logout);}
				curr=table->enterScope(curr,logout);
				int i=0; strcat(parat,$1);strcat(parat," ");strcat(parat,$2); {fprintf(logout,"%s\n\n",parat);  
i++;}					
				int key=curr->hash_function($2); parano=1;
                                table->insertCurrent(curr,$2,key,curr->count,"ID",$1,"variable",0,logout);}
		| type_specifier    {fprintf(logout,"At line no: %d parameter_list : type_specifier\n\n",line_count);parano=1;
					int i=0;strcat(parat,$1);strcat(parat," ");{fprintf(logout,"%s\n\n",parat);  i++;}}
 		;

 		
compound_statement : LCURL {/*curr=table->enterScope(curr,logout);*/cout<<curr->id<<"curr id"<<endl;} statements RCURL  {fprintf(logout,"At line no: %d compound_statement : LCURL statements RCURL\n\n",line_count);memset(&comstatet[0], 0, sizeof(comstatet));
			int i=0; strcat(comstatet,"{\n");strcat(comstatet,statet);strcat(comstatet,"\n}");
{fprintf(logout,"%s\n\n",comstatet);  i++;}//memset(&statet[0], 0, sizeof(statet)); cout<<statet<<"clearing memory"<<endl;
					      //fprintf(logout,"{%s}\n\n",statet);
					      table->printAll(curr,logout);
					      curr= table->exitScope(root,logout);}
 		    | LCURL {/*curr=table->enterScope(curr,logout);*/cout<<curr->id<<"curr id"<<endl;} RCURL    {fprintf(logout,"At line no: %d compound_statement : LCURL RCURL\n\n",line_count);memset(&comstatet[0], 0, sizeof(comstatet));
				      int i=0; strcat(comstatet,"{\n");strcat(comstatet,"\n}");
{fprintf(logout,"%s\n\n",comstatet);  i++;}
				      table->printAll(curr,logout);
				      curr= table->exitScope(root,logout);}
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {fprintf(logout,"At line no: %d var_declaration: type_specifier declaration_list SEMICOLON\n\n",line_count); 
		  int i=0; /*strcat(dect[i],$1);*/strcat(vardect,$1);strcat(vardect," ");strcat(vardect,dect);strcat(vardect,";");
strcat(vardect,"\n");
		   {fprintf(logout,"%s\n\n",vardect);  i++;} 
		   //strcat(unitcode,vardect);
		    memset(&dect[0], 0, sizeof(dect)); 
		  //fprintf(logout,"%s ", $1);str[0]=$1;//cout<<$1<<endl;
		  
		  //fprintf(logout,"%s;\n\n", dect);
		  }
 		 ;
 		 
type_specifier	: INT  {
			fprintf(logout,"At line no: %d type_specifier: INT\n\n",line_count);
			$$="int"; str[0].clear();str[0]="int";
                        fprintf(logout,"int \n\n");
			}
 		| FLOAT {fprintf(logout,"At line no: %d type_specifier: FLOAT\n\n",line_count);$$="float";str[0].clear();str[0]="float";
                         fprintf(logout,"float\n\n");}
 		| VOID {fprintf(logout,"At line no: %d type_specifier: VOID\n\n",line_count); $$="void";str[0].clear();str[0]="void";
			fprintf(logout,"void\n\n"); voidtype="VOID";}
 		;
 		
declaration_list : declaration_list COMMA ID  {fprintf(logout,"At line no: %d declaration_list: declaration_list COMMA ID\n\n",line_count);
					    //   fprintf(logout,"%s %s",str[0],idname);	
						//fprintf(logout,"%s",s.c_str());					
 int i=0; /*strcat(dect[i],$1);*/strcat(dect,",");strcat(dect,$3); //cout<<dect[i]<<i<<endl;
/*strcat(vardect[i],dect);*/{fprintf(logout,"%s\n\n",dect);  i++;}  stringstream ss;  //ss<<$1<<","<<$3; string s=ss.str(); //cout<<"......."<<endl;cout<<s<<endl;
			int key=curr->hash_function($3);
                        table->insertCurrent(curr,$3,key,curr->count,"ID",str[0],"variable",0,logout);
			
			}
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD   {fprintf(logout,"At line no: %d declaration_list: declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n",line_count);  
		    strcat(dect,",");strcat(dect,$3); //cout<<dect[i]<<i<<endl;
/*strcat(vardect[i],dect)*/;{fprintf(logout,"%s\n\n",dect);  i++;}
stringstream ss;  ss<<$3<<"["<<$5<<"]"; string s=ss.str(); cout<<"......."<<endl; 
cout<<s<<endl;
									//fprintf(logout,"%s \n\n",$5);
									//fprintf(logout,"%s,%s[%s] \n\n",$$,$3,$5);
									int key=curr->hash_function(s);
                        table->insertCurrent(curr,s,key,curr->count,"ID",str[0],"variable",atoi($5),logout);}
 		  | ID    {fprintf(logout,"At line no: %d declaration_list: ID\n\n",line_count); id=$1; strcat(dect,$1);
				//fprintf(logout,"%s\n\n",strdup(yytext));		
			    fprintf(logout,"%s\n\n", $$); if(temp= table->lookUp(curr,$1)) {fprintf(errorout,"Error at line %d : Multiple declaration of %s\n\n",line_count,$1);error++;}  idname=$1;
			     int key=curr->hash_function($1);
                        table->insertCurrent(curr,$1,key,curr->count,"ID",str[0],"variable",0,logout);
            		if((temp= table->lookUp(curr,$1))==NULL) {fprintf(errorout,"Error at line %d : Undeclared variable %s\n\n",line_count,$1);error++;}
			/*printf("%s\n",id.c_str());*/ cout<<$$<<endl;}
		
 		  | ID LTHIRD CONST_INT RTHIRD  {fprintf(logout,"At line no: %d declaration_list: ID LTHIRD CONST_INT RTHIRD\n\n",line_count);
						stringstream ss;  ss<<$1<<"["<<$3<<"]"; s=ss.str();
						fprintf(logout,"%s \n\n",$3);
						fprintf(logout,"%s[%s] \n\n",$$,$3);
						fprintf(logout,"%s \n\n",$$); idname=$1;strcat(dect,s.c_str());
						arr=$$;
						int key=curr->hash_function($1);
                        table->insertCurrent(curr,$1,key,curr->count,"ID",str[0],"array",atoi($3),logout);}
 		   ;
 		  
statements : statement  {fprintf(logout,"At line no: %d statements : statement\n\n",line_count);
			//memset(&state[0], 0, sizeof(state)); cout<<state<<"clearing memory"<<endl;
			int i=0; strcat(statet,state);//strcat(statet," ");
{fprintf(logout,"%s\n\n",statet);  i++;}
			/*fprintf(logout,"%s\n\n",state);*/}
	   | statements statement   {fprintf(logout,"At line no: %d statements : statements statement\n\n",line_count);
				memset(&statet[0], 0, sizeof(statet)); 
			int i=0; /*strcat(statet,state);strcat(statet,"\n");*/strcat(statet,statet);strcat(statet,state);
{fprintf(logout,"%s\n\n",statet);  i++;}
			/*fprintf(logout,"%s \n\n",statet);*/}
	   ;
	   
statement : var_declaration {fprintf(logout,"At line no: %d statement : var_declaration\n\n",line_count);
				memset(&state[0], 0, sizeof(state)); 
				int i=0; /*strcat(state,str[0].c_str());*/strcat(state,vardect);
{/*fprintf(logout,"%s\n\n",state);*/  i++;}	//memset(&vardect[0], 0, sizeof(vardect)); cout<<vardect<<"clearing memory"<<endl;	
				fprintf(logout,"%s\n\n",state);
				}
	  | expression_statement {fprintf(logout,"At line no: %d statement : expression_statement\n\n",line_count);
				int i=0;strcat(state,expresstate);strcat(state,"\n");
{fprintf(logout,"%s\n\n",state);  i++;}//memset(&expresstate[0], 0, sizeof(expresstate)); cout<<expresstate<<"clearing memory"<<endl;
				/*fprintf(logout,"%s \n\n",state)*/;}
	  | compound_statement   {fprintf(logout,"At line no: %d statement : compound_statement\n\n",line_count);
				int i=0;strcat(state,comstatet);strcat(state,"\n");
{fprintf(logout,"%s\n\n",state);  i++;}

				  /*fprintf(logout,"%s\n\n",$1);*/}
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement  {fprintf(logout,"At line no: %d statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n",line_count);}
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {fprintf(logout,"At line no: %d statement : IF LPAREN expression RPAREN statement\n\n",line_count);}
	  | IF LPAREN expression RPAREN statement ELSE statement  {fprintf(logout,"At line no: %d statement : IF LPAREN expression RPAREN statement ELSE statement\n\n",line_count);}
	  | WHILE LPAREN expression RPAREN statement  {fprintf(logout,"At line no: %d statement : WHILE LPAREN expression RPAREN statement\n\n",line_count);
			int i=0; strcat(state,"while");strcat(state,"( ");strcat(state,express);strcat(state,")");
{fprintf(logout,"%s\n\n",state);  i++;}}
	  | PRINTLN LPAREN ID RPAREN SEMICOLON  {fprintf(logout,"At line no: %d statement : PRINTLN LPAREN ID RPAREN SEMIOLON\n\n",line_count);
			int i=0; strcat(state,"println");strcat(state," ( ");strcat(state,$3);strcat(state," ) ");strcat(state,";");
{fprintf(logout,"%s\n\n",state);  i++;}}
	  | RETURN expression SEMICOLON  {fprintf(logout,"At line no: %d statement : RETURN expression SEMICOLON\n\n",line_count);
					
					int i=0; strcat(state,"return");strcat(state," ");strcat(state,express);strcat(state,";");
{fprintf(logout,"%s\n\n",state);  i++;}//memset(&express[0], 0, sizeof(express)); cout<<express<<"clearing memory"<<endl;
					/*fprintf(logout,"return %s ;\n\n",simple);*/}
	  ;
	  
expression_statement 	: SEMICOLON	{fprintf(logout,"At line no: %d expression_statement : SEMICOLON\n\n",line_count);
				memset(&expresstate[0], 0, sizeof(expresstate)); 
					 fprintf(logout,";\n\n");}		
			| expression SEMICOLON  {fprintf(logout,"At line no: %d expression_statement : expression SEMICOLON\n\n",line_count);        
			memset(&expresstate[0], 0, sizeof(expresstate)); 
			int i=0; strcat(expresstate,express);strcat(expresstate,";");
{fprintf(logout,"%s\n\n",expresstate);  i++;}
			/*fprintf(logout,"%s \n\n",$1);*/}
			;
	  
variable : ID 		{fprintf(logout,"At line no: %d variable : ID\n\n",line_count);//var[0]=$1; //$$=$1;
			memset(&var[0], 0, sizeof(var)); 
			strcat(var,$1);varid=1;vararr=0;
                         fprintf(logout,"%s\n\n",var);
			}
        // | ID LTHIRD CONST_FLOAT RTHIRD  {yyerror("Non Integer Array Index\n");error++;}
	 | ID LTHIRD expression RTHIRD {fprintf(logout,"At line no: %d variable : ID LTHIRD expression RTHIRD\n\n",line_count);
					stringstream ss;  ss<<$1<<"["<<$3<<"]"; //var[0]=ss.str();cout<<var[0].c_str()<<endl;
					memset(&var[0], 0, sizeof(var)); 
					strcat(var,$1);strcat(var,"[");strcat(var,$3);strcat(var,"]");					
					fprintf(logout,"%s \n\n",var);vararr=1;varid=0;
					if((temp=table->lookUp(curr,$1))) {if(temp->nametype=="array" && fact[0]=="CONST_FLOAT" &&flag==0)
 {fprintf(errorout,"Error at line %d : Non Integer Array Index\n\n",line_count);error++;}}}
	 ;
	 
 expression : logic_expression	{fprintf(logout,"At line no: %d expression : logic_expression\n\n",line_count);
				memset(&express[0], 0, sizeof(express)); 
				int i=0; strcat(express,logic);//strcat(express," ");
{fprintf(logout,"%s\n\n",express);  i++;}//memset(&simple[0], 0, sizeof(simple)); cout<<simple<<"clearing memory"<<endl;
				/*fprintf(logout,"%s \n\n",exp);*/}
	   | variable ASSIGNOP logic_expression  {fprintf(logout,"At line no: %d expression : variable ASSIGNOP logic_expression\n\n",line_count);	memset(&express[0], 0, sizeof(express)); 
			int i=0; strcat(express,$1);strcat(express,"=");strcat(express,logic);
{fprintf(logout,"%s\n\n",express);  i++;}//memset(&simple[0], 0, sizeof(simple)); cout<<simple<<"clearing memory"<<endl;
					//memset(&var[0], 0, sizeof(var)); cout<<simple<<"clearing memory"<<endl;

				//fprintf(logout,"%s=%s \n\n",$1,$3); $2="=";
		if((temp= table->lookUp(curr,$1))==NULL) {fprintf(errorout,"Error at line %d : Undeclared variable %s\n\n",line_count,$1);error++;} string eq= "=";
		if((temp= table->lookUp(curr,$1))) {string strtype=temp->type;/*cout<<strtype<<endl;cout<<$3<<" "<<fact[0]<<endl;*/string strname=temp->str;cout<<strname<<".....f"<<" "<<temp->nametype<<endl;string name=s;
		if(temp->nametype== "array" && varid==1 &&vararr==0)  {cout<<"qwertyuiop"<<"..................."<<var<<"..."<<temp->str<<temp->num<<endl;fprintf(errorout,"Error at line %d : Type mismatch\n\n",line_count);error++;}
		if(strtype=="int" && fact[0]=="CONST_FLOAT" && flag==0) {fprintf(errorout,"Error at line %d : Type mismatch\n\n",line_count);error++;}
		if(strtype=="float" && fact[0]=="CONST_INT" && flag==0) {fprintf(errorout,"Warning at line %d : INTEGER is converted to FLOAT\n\n",line_count);}
		/*if(voidtype=="void") {fprintf(errorout,"Error at line %d : VOID can not be part of expression\n\n",line_count);error++;
}*/}}	
	   ;
			
logic_expression : rel_expression  {fprintf(logout,"At line no: %d logic_expression : rel_expression\n\n",line_count);
			            memset(&logic[0], 0, sizeof(logic)); 
				     strcat(logic,relation);
					fprintf(logout,"%s \n\n",logic);}	
		 | rel_expression LOGICOP rel_expression {fprintf(logout,"At line no: %d logic_expression : rel_expression LOGICOP rel_expression\n\n",line_count);
					//memset(&logic[0], 0, sizeof(logic)); cout<<logic<<"clearing memory"<<endl;
				        /*strcat(logic,relation);*/strcat(logic,$2);strcat(logic,relation);
					fprintf(logout,"%s \n\n",logic);
					 if(fact[0]!="CONST_INT") {fprintf(errorout,"Error at line %d : LOGICOP operation should be integer\n\n",line_count);error++;}}	
		 ;
			
rel_expression	: simple_expression {fprintf(logout,"At line no: %d rel_expression : simple_expression\n\n",line_count);
				     memset(&relation[0], 0, sizeof(relation)); 
				     strcat(relation,simple); 
			             fprintf(logout,"%s \n\n",relation); }
		| simple_expression RELOP simple_expression {fprintf(logout,"At line no: %d rel_expression : simple_expression RELOP simple_expression\n\n",line_count);  
				      memset(&relation[0], 0, sizeof(relation)); 
					 int i=0; strcat(relation,simple);strcat(relation,$2);strcat(relation,simple);cout<<relation<<"////////////"<<endl;
                         {fprintf(logout,"%s\n\n",relation);  i++;}
			  if(fact[0]!="CONST_INT") {fprintf(errorout,"Error at line %d : RELOP operation should be integer\n\n",line_count);error++;}
					/*fprintf(logout,"%s%s%s \n\n",$1,$2,$3);*/}	
		;
				
simple_expression : term  {fprintf(logout,"At line no: %d simple_expression : term\n\n",line_count);
			memset(&simple[0], 0, sizeof(simple)); 
				strcat(simple,termt);
				fprintf(logout,"%s \n\n",simple); }
		  | simple_expression ADDOP term   {fprintf(logout,"At line no: %d simple_expression : simple_expression ADDOP term\n\n",line_count);//memset(&simple[0], 0, sizeof(simple)); cout<<express<<"clearing memory"<<endl;
			 int i=0; /*strcat(simple,simple);*/strcat(simple,$2);strcat(simple,termt);
                         {fprintf(logout,"%s\n\n",simple);  i++;}
			//fprintf(logout,"%s%s%s\n\n",$1,$2,$3); 
/* strcat(simstr[i],$1); strcat(simstr[i],$2); strcat(simstr[i],$3); i++; /*cout<<simstr[0]<<endl<<endl;*/}
		  ;
					
term :	unary_expression {fprintf(logout,"At line no: %d term :	unary_expression\n\n",line_count);
			int i=0; memset(&termt[0], 0, sizeof(termt)); 
			strcat(termt,unexp);
                         {fprintf(logout,"%s\n\n",termt);  i++;}
				//memset(&unexp[0], 0, sizeof(unexp)); cout<<factt<<"clearing memory"<<endl;
			/*fprintf(logout,"%s \n\n",$$);*/}
     |  term MULOP unary_expression   {fprintf(logout,"At line no: %d term : term MULOP unary_expression\n\n",line_count);string ss="%";
					//memset(&termt[0], 0, sizeof(termt)); cout<<simple<<"clearing memory"<<endl;
					int i=0; /*strcat(termt,termt);*/strcat(termt,$2);strcat(termt,unexp);
                         {fprintf(logout,"%s\n\n",termt);  i++;}
//strcat(prevsimple,termt);cout<<"prevsimple............	"<<prevsimple<<endl;//strcat(prevsimple,$2);
//memset(&prevsimple[0], 0, sizeof(prevsimple)); cout<<prevsimple<<"clearing memory"<<endl;
if(termt==simple) {cout<<termt<<"................"<<endl;}
				//memset(&unexp[0], 0, sizeof(unexp)); cout<<unexp<<"clearing memory"<<endl;
					     //  fprintf(logout,"%s%s%s \n\n",$1,$2,$3);cout<<$2<<"..."<<$1<<" "<<$3<<endl;
					if($2==ss && fact[0]=="CONST_FLOAT") {cout<<"asdfghjkl"<<endl;flag=1;fprintf(errorout,"Error at line %d : Integer operand on modulus operator\n\n",line_count);error++;}
				//	else if(MULOP=='/')   fprintf(logout,"%s/%s \n\n",$1,$3);
				/*	else  fprintf(logout,"%s%s \n\n",$1,$3);*/}
     ;

unary_expression : ADDOP unary_expression  {fprintf(logout,"At line no: %d unary_expression : ADDOP unary_expression\n\n",line_count);
						int i=0; strcat(unexp,$1);strcat(unexp,unexp);
                         {fprintf(logout,"%s\n\n",unexp);  i++;}
				//memset(&factt[0], 0, sizeof(factt)); cout<<factt<<"clearing memory"<<endl;				
				//		fprintf(logout,"%s%s \n\n",$1,$2);
						}
		 | NOT unary_expression   {fprintf(logout,"At line no: %d unary_expression : NOT unary_expression\n\n",line_count);
					int i=0; strcat(unexp,"!");strcat(unexp,unexp);
                         {fprintf(logout,"%s\n\n",unexp);  i++;}
				
						/*fprintf(logout,"!%s \n\n",$2);*/}
		 | factor   {fprintf(logout,"At line no: %d unary_expression : factor\n\n",line_count);
				memset(&unexp[0], 0, sizeof(unexp)); 
				int i=0; strcat(unexp,factt);
                         {fprintf(logout,"%s\n\n",unexp);  i++;}
				
				/*fprintf(logout,"%s \n\n",$1);*/}
		 ;
	
factor	: variable  {fprintf(logout,"At line no: %d factor : variable\n\n",line_count); 
			memset(&factt[0], 0, sizeof(factt)); 
			int i=0; strcat(factt,var);
                         {fprintf(logout,"%s\n\n",factt);  i++;}//memset(&var[0], 0, sizeof(var)); cout<<simple<<"clearing memory"<<endl;
			/*fprintf(logout,"%s\n\n",$1);*/}
	| ID LPAREN argument_list RPAREN  {fprintf(logout,"At line no: %d factor : ID LPAREN argument_list RPAREN\n\n",line_count);
					//fprintf(logout,"%s(%s) \n\n",$1,$3);
					memset(&factt[0], 0, sizeof(factt)); 
					if((temp=table->lookUp(root,$1))==NULL)  {fprintf(errorout,"Error at line %d : Undeclared function\n\n",line_count);error++;}
					strcat(factt,$1);strcat(factt,"(");strcat(factt,argu);strcat(factt,")");
					fprintf(logout,"%s \n\n",factt); cout<<(temp=table->lookUp(root,$1))->num<<"...."<<parano<<"................"<<endl;
					if((temp=table->lookUp(root,$1))->num!=parano) {fprintf(errorout,"Error at line %d : parameter mismatch\n\n",line_count);error++;}
					if((temp=table->lookUp(curr,$1))->nametype!="function") {fprintf(errorout,"Error at line %d : invalid function calling\n\n",line_count);error++;}
					if((temp=table->lookUp(root,$1)) && (temp1=table->lookUp(curr,$3))&&(temp=table->lookUp(root,$1))->type!="void") {cout<<temp->nametype<<temp1->nametype<<"...."<<endl; cout<<returntype<<retype<<"777777"<<endl;
					if(returntype==(temp1->nametype) && retype ==(temp1->type)) 
					{strcat(factt,$1);strcat(factt,"(");strcat(factt,argu);strcat(factt,")");
					fprintf(logout,"%s \n\n",factt);
					cout<<"///"<<endl;}
					else  {fprintf(errorout,"Error at line %d : Type mismatch\n\n",line_count);error++;
						memset(&factt[0], 0, sizeof(factt));
					       strcat(factt,$1);strcat(factt,"(");strcat(factt,"error");strcat(factt,")"); strcat(argu,"error");
					       fprintf(logout,"%s \n\n",factt);
					       }}}
	| LPAREN expression RPAREN  {fprintf(logout,"At line no: %d factor : LPAREN expression RPAREN\n\n",line_count);
					memset(&factt[0], 0, sizeof(factt)); 
					int i=0; strcat(factt,"(");strcat(factt,express);strcat(factt,")");
                         {fprintf(logout,"%s\n\n",factt);  i++;}
					//memset(&express[0], 0, sizeof(express)); cout<<express<<"clearing memory"<<endl;
					/*fprintf(logout,"(%s) \n\n",express);*/}
	| CONST_INT   {fprintf(logout,"At line no: %d factor : CONST_INT\n\n",line_count);
			memset(&factt[0], 0, sizeof(factt)); 
			 int i=0; strcat(factt,$1);
                         {fprintf(logout,"%s\n\n",factt);  i++;}
			/*fprintf(logout,"%s \n\n",$1);*/fact[0]="CONST_INT";}
	| CONST_FLOAT  {fprintf(logout,"At line no: %d factor : CONST_FLOAT\n\n",line_count);
				memset(&factt[0], 0, sizeof(factt)); 
				int i=0; strcat(factt,$1);
                         {fprintf(logout,"%s\n\n",factt);  i++;}
			/*fprintf(logout,"%s\n\n",$1);*/fact[0]="CONST_FLOAT";}
	| variable INCOP   {fprintf(logout,"At line no: %d factor : variable INCOP\n\n",line_count);
				memset(&factt[0], 0, sizeof(factt)); 
				int i=0; strcat(factt,var);strcat(factt,"++");
                         {fprintf(logout,"%s\n\n",factt);  i++; fact[0]="CONST_INT";}
			  if((temp=table->lookUp(curr,var))->type!="int") {fprintf(errorout,"Error at line %d : variable should be INTEGER\n\n",line_count);error++;}
			}
	| variable DECOP   {fprintf(logout,"At line no: %d factor : variable DECOP\n\n",line_count);
				memset(&factt[0], 0, sizeof(factt)); 
				int i=0; strcat(factt,var);strcat(factt,"--");
                         {fprintf(logout,"%s\n\n",factt);  i++; fact[0]="CONST_INT";}
			  if((temp=table->lookUp(curr,var))->type!="int") {fprintf(errorout,"Error at line %d : variable should be INTEGER\n\n",line_count);error++;}
}
	;
	
argument_list : arguments    {fprintf(logout,"At line no: %d argument_list : arguments\n\n",line_count);
				memset(&argu[0], 0, sizeof(argu)); if(arguno!=parano) {cout<<"............."<<arguno<<" "<<parano<<endl;parano=arguno;cout<<parano<<endl;}
				strcat(argu,argut);//memset(&argu[0], 0, sizeof(argu)); cout<<argut<<"clearing memory"<<endl;
				fprintf(logout,"%s \n\n",argu);}
			  |  {fprintf(logout,"At line no: %d argument_list : 	       \n\n",line_count);
				memset(&argu[0], 0, sizeof(argu));
				strcat(argu," ");arguno=0;
				fprintf(logout,"%s \n\n",argu);}
			  ;
	
arguments : arguments COMMA logic_expression  {fprintf(logout,"At line no: %d arguments : arguments COMMA logic_expression\n\n",line_count);
						//memset(&argut[0], 0, sizeof(argut)); cout<<argut<<"clearing memory"<<endl;
				                /*strcat(argut,argut);*/strcat(argut,",");strcat(argut,logic);arguno++;
cout<<"wertyuiopsdfghjklzxcvbnm,arguments	"<<arguno<<endl;
						fprintf(logout,"%s \n\n",argut);}
	      | logic_expression    {fprintf(logout,"At line no: %d arguments : logic_expression\n\n",line_count);
					memset(&argut[0], 0, sizeof(argut)); 
				        strcat(argut,logic); arguno=1;
					fprintf(logout,"%s \n\n",argut);}
	      ;

%%
int main(int argc,char *argv[])
{

	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
        //hash_Map* root=new hash_Map();
      //  symbolTable* table=new symbolTable();
        root->parent=0;
        root->next=0;
        root->id=1; 
        //struct hash_Map* curr;
        curr=root;
    //  void logprint(int line_count,char* yytext);
        
       // openfile();
	logout= fopen("1505095_log.txt","w");
	errorout= fopen("1505095_error.txt","w");
        fileout.open("log.txt");
	fileout.close();
	yyin= fin;
	yyparse();
	//st.print();
       // openfile();
	fclose(yyin);
	fclose(errorout);
	fclose(logout);
	return 0;
}

