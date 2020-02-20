%{
#include <iostream>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <vector>
#include <sstream>
#include "SymbolTable.h"
//#include "SymbolInfo.h"

//#define YYSTYPE SymbolInfo*

using namespace std;

extern int yylex();
void yyerror(const char *s);
extern FILE *yyin;
extern int line_count;
extern int error;


int labeline_count=0;
int tempCount=0;
int pTempCount = 0;
int maxTemp = 0;


string variable_type;
SymbolTable table(50);
SymbolTable funcParam(5);
int para_no = 0;
vector<string> args; 
extern int line_count;
int semantic_err=0;
vector<SymbolInfo> params;
string return_label;
bool funcDef = false;
string code_seg;

vector<string> variable;
vector<string> arrays;
vector<int> array_size;
vector<string> temp_var;
vector<string> ptemp_var;

ofstream logout;
ofstream errorout;
ofstream asmout;

char *newLabel()
{
	char *lb= new char[4];
	strcpy(lb,"L");
	char b[3];
	sprintf(b,"%d", labeline_count);
	labeline_count++;
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
	if(maxTemp < tempCount) maxTemp = tempCount;
	strcat(t,b);
	return t;
}

char *newPTemp()
{
	char *pt= new char[4];
	strcpy(pt,"p");
	char b[3];
	sprintf(b,"%d", pTempCount);
	pTempCount++;
	strcat(pt,b);
	return pt;
}

char *newBTemp()
{
	char *st= new char[4];
	strcpy(st,"s");
	char b[3];
	sprintf(b,"%d", tempCount);
	tempCount++;
	strcat(st,b);
	return st;
}

//SymbolTable *table= new SymbolTable(7);

%}

%error-verbose

%union{SymbolInfo* symVal;}

%start start

%token COMMENT IF ELSE FOR WHILE DO BREAK CONTINUE INT FLOAT CHAR DOUBLE VOID RETURN SWITCH CASE DEFAULT INCOP DECOP ASSIGNOP LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD SEMICOLON COMMA STRING NOT PRINTLN
%token <symVal>ID CONST_INT CONST_FLOAT CONST_CHAR ADDOP MULOP LOGICOP RELOP

%nonassoc THEN
%nonassoc ELSE

%type <symVal>type_specifier expression logic_expression rel_expression simple_expression term unary_expression factor variable program unit var_declaration func_declaration func_definition parameter_list compound_statement declaration_list statements statement expression_statement argument_list arguments

%%

start : program
	{
		//write your code in this block in all the similar blocks below
		ofstream asmfout;
		asmfout.open("code.asm");
		if(!error && !semantic_err){
			//ofstream asmfout;
			//asmfout.open("code.asm");
			$1->code+=code_seg+"\n\nPRINT_DECIMAL PROC NEAR\n\n\tpush ax\n\tpush bx\n\tpush cx\n\tpush dx\n\tor ax,ax\n \tjge enddif\n\tpush ax\n\tmov dl,'-'\n\tmov ah,2\n\tint 21h\n\tpop ax\n\tneg ax\nenddif:\n\txor cx,cx\n\tmov bx,10d\nrepeat:\n\txor dx,dx\n\tdiv bx\n\t push dx\n\tinc cx\n\tor ax,ax\n\tjne repeat\n\tmov ah,2\nprint_loop:\n\tpop dx\n\tor dl,30h\n\tint 21h\n\tloop print_loop\n\tpop dx\n\tpop cx\n\tpop bx\n\tpop ax\n\tret\n\nPRINT_DECIMAL ENDP\n";
		
			asmfout << ".model small\n\n.stack 100h\n\n.data\n" ;
			for(int i = 0; i<variable.size() ; i++)
			{
				asmfout << variable[i] << " dw ?\n";			
			}

			for(int i = 0 ; i< arrays.size() ; i++)
			{
				asmfout << arrays[i] << " dw " << array_size[i] << " dup(?)\n";
			}

			for(int i = 0 ; i< temp_var.size() ; i++)
			{
				asmfout << temp_var[i] << " dw ?\n";
			}
			
			for(int i = 0 ; i< ptemp_var.size() ; i++)
			{
				asmfout << ptemp_var[i] << " dw ?\n";
			}

			asmfout << "\n.code \n"; 
			asmfout << $1->code;
			logout << "Line " << line_count << " : start : program\n"<< endl;
		}
		else{
			asmfout<<" "<<endl;	
		}
	}
	;

program : program unit
	{
		logout << "Line " << line_count << " : program : program unit\n"<< endl;
		$$ = $1;
		$$->code = $$->code +  $2->code;
	} 
	| 
	unit
	{
		logout << "Line " << line_count << " : program : unit\n"<< endl;
		$$ = $1;
	}
	;
	
unit : var_declaration
	{
		logout << "Line " << line_count << " : unit : var_declaration\n"<< endl;
		$$ = $1;
	}
     	| 
     	func_declaration
     	{
			logout << "Line " << line_count << " : unit : func_declaration\n"<< endl;
			$$ = $1;
     	}
     	| 
     	func_definition
     	{
			logout << "Line " << line_count << " : unit : func_definition\n"<< endl;
			$$ = $1;
     	}
     	;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
			{
			        if(para_no==0){
				logout << "Line " << line_count << " : func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n" ;
				}
				else{
				logout << "Line " << line_count << " : func_definition : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n" ;
				}
				logout << $2->getName() << endl << endl;
				SymbolInfo *temp = table.lookUp($2->getName(), "FUNC");
				if(temp != NULL){
					errorout << "Error at line " << line_count << " Function "<< $2->getName() <<" already declared" << endl << endl;
					semantic_err++;
				}else {
					SymbolInfo* temp2 = table.InsertandGet($2->getName(), "ID");
					temp2->setIDType("FUNC");
					temp2->setFuncRet($1->getVarType());
					for(int i = 0; i<args.size(); i++){
						temp2->ParamList.push_back(args[i]);					
					}
					args.clear();
					funcParam.exitScope();
				} 
			}
		 	|type_specifier ID LPAREN parameter_list RPAREN error
			{
				errorout << "Error at line " << line_count << " ; missing" << endl << endl;
				semantic_err++;
			}
		 	;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN 
				{
				cout<<para_no<<endl;
				SymbolInfo *temp = table.lookUp($2->getName(), "FUNC");
				if(args.size() != para_no){
					errorout << "Error at line " << line_count << " Parameter mismatch for Function "<< $2->getName() << endl << endl;
					args.clear(); 
					para_no = 0;
					semantic_err++;
				}												
				if(temp != NULL){
					if(temp->isFuncDefined()== true){
						errorout << "Error at line " << line_count << "Function "<< $2->getName() <<" already defined" << endl << endl;
						semantic_err++;
						args.clear();
						para_no = 0;
					}
					else if(temp->getFuncRet() != $1->getVarType()){
						errorout << "Error at line " << line_count << "Function "<< $2->getName() <<" :return type doesn't match declaration" << endl << endl;
						semantic_err++;
						args.clear();
						para_no = 0; 
					} 
					else if(temp->getFuncRet() != $2->getFuncRet()){
						errorout << "Error at line " << line_count << "Function "<< $2->getName() <<" :return type doesn't match declaration" << endl << endl;
						semantic_err++;
						args.clear();
						para_no = 0 ; 
					} 
					else if(temp->ParamList.size() != args.size()){
						errorout << "Error at line " << line_count << "Function "<< $2->getName() <<" :Parameter list doesn not match declaration" << endl << endl;
						args.clear();
						para_no = 0;
						semantic_err++;					
					}
					else{
						for(int i = 0; i<temp->ParamList.size(); i++){
							if(temp->ParamList[i] != args[i]){
								errorout << "Error at line " << line_count << "Function "<< $2->getName()<< " :argument mismatch" << endl << endl;
								args.clear();
								para_no = 0;
								semantic_err++;	
							}
						}				
					}
				}
				else{
					SymbolInfo* temp = new SymbolInfo();
					temp = table.InsertandGet($2->getName(), "ID");
					temp->setIDType("FUNC");
					temp->setFuncRet($1->getVarType());
					for(int i = 0; i<args.size(); i++){
						temp->ParamList.push_back(args[i]);					
					}
					temp->setFuncDefined();cout<<$2->getIDType()<<"////////"<<endl;
					table.enterScope(); 
						for(int i = 0; i<params.size(); i++) table.Insert(params[i]);
						
						params.clear();	
				}
				
				}
			compound_statement
			{	
				if(para_no==0){
				logout << "Line " << line_count << " : func_definition : type_specifier ID LPAREN RPAREN compound_statement\n" ;
				}
				else{
				logout << "Line " << line_count << " : func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n" ;
				}
				logout << $2->getName() << endl << endl;
				SymbolInfo * func = new SymbolInfo();				
				$$ = func;
				//$$->code = $$->code +  $2->getName() + " PROC NEAR\n\n";
				//$$->code = $$->code +  $7->code;
				if($2->getName()!="main"){
					code_seg=code_seg+$2->getName()+" PROC NEAR\n\n";
					code_seg=code_seg+$7->code;
					//$$->code=$$->code+"\t"+string(return_label)+":\n";
					code_seg=code_seg+"\t\n";
				
				if(args.size()!=0){
					//$$->code=$$->code+"\tpop bp\n";
					code_seg=code_seg+"\tpop bp\n";
				}
				if($2->getName()!="main"){
					//$$->code=$$->code+"\tret ";
					code_seg=code_seg+"\tret ";
				}
		
				int p=args.size();//*2;
				if(p){
					string Result;       

					ostringstream convert;  
	
					convert << p;    

					Result = convert.str(); 
					//$$->code=$$->code+Result+"\n";
					code_seg=code_seg+Result+"\n";
				}
				code_seg+="\n";
				code_seg=code_seg+"\n"+$2->getName()+" ENDP\n\n";
				}
				$$->code+="\n";
				if($2->getName()=="main"){
					$$->code = $$->code +  $2->getName() + " PROC NEAR\n\n";
				        $$->code = $$->code +  $7->code;
					if(args.size()!=0){
						//$$->code=$$->code+"\tpop bp\n";
						code_seg=code_seg+"\tpop bp\n";
				        }
					$$->code+="\tmov ah,4ch\n\tint 21h\n";
				
				        $$->code = $$->code +  "\n" + $2->getName() + " ENDP\n\n";
				}
				$$->code+="\n";
				args.clear();
				para_no = 0;
				return_label = "";
				args.clear();
				//funcParam.exitScope();
			}
 		 	;
 		 
parameter_list  : parameter_list COMMA type_specifier ID
				{
					logout << "Line " << line_count << " : parameter_list  : parameter_list COMMA type_specifier ID\n" ;
					logout << $4->getName() << endl << endl;
					args.push_back(variable_type);//changed from $3->getVarType()
					para_no++;
					$4->setIDType("VAR");
					$4->setVarType(variable_type);//changed from $3->getVarType()
					SymbolInfo* temp = new SymbolInfo($4->getName(), $4->getType());
					temp->setIDType("VAR");
					
					params.push_back(*temp);
					variable.push_back($4->getName()+to_string(table.scopeNum+1));
				
				}
		| parameter_list COMMA type_specifier
		{
			logout << "Line " << line_count << " : parameter_list  : parameter_list COMMA type_specifier\n"<< endl;
			args.push_back($3->getVarType());
		}	 
 		| type_specifier ID
		{
			logout << "Line " << line_count << " : parameter_list  : type_specifier ID\n" ;
			logout << $2->getName() << endl << endl;
			args.push_back(variable_type);//$1->getVarType()
			para_no++;
			$2->setIDType("VAR");
			$2->setVarType(variable_type);//$1->getVarType()
			params.push_back(*$2);
			variable.push_back($2->getName()+to_string(table.scopeNum+1));
				

		}
 		| type_specifier
		{
			logout << "Line " << line_count << " : parameter_list  : type_specifier\n" ;
			args.push_back(variable_type);
		}
 		|{}
 		;

compound_statement	: LCURL
					{
						//table.enterScope(); 
						//for(int i = 0; i<params.size(); i++) table.Insert(params[i]);
						
						//params.clear();					
					}statements RCURL
					{	
						table.exitScope();
						$$=$3;
						logout << "Line " << line_count << " : compound_statement : LCURL statements RCURL\n"<< endl;
					}
					| LCURL RCURL
					{
						$$=new SymbolInfo("compound_statement","dummy");
						logout << "Line " << line_count << " : compound_statement : LCURL RCURL\n"<< endl;
					}
					;

var_declaration : type_specifier declaration_list SEMICOLON
				{
					logout << "Line " << line_count << " : var_declaration : type_specifier declaration_list SEMICOLON\n"<< endl;
				}
				|type_specifier declaration_list error
				{
						errorout << "Error at line " << line_count << " ; missing" << endl << endl;
						semantic_err++;
				} 		 		
				;
 		 
type_specifier	: INT
				{
					logout << "Line " << line_count << " : type_specifier	: INT\n"<< endl; 
					SymbolInfo* s= new SymbolInfo("INT");
					variable_type = "INT" ;
					$$ = s;
				}
 				| FLOAT
				{	
					logout << "Line " << line_count << " : type_specifier	: FLOAT\n"<< endl;
					SymbolInfo* s= new SymbolInfo("FLOAT");
					variable_type = "FLOAT" ;
					$$ = s;
				}
 				| VOID
				{
					logout << "Line " << line_count << " : type_specifier	: VOID\n"<< endl;
					SymbolInfo* s= new SymbolInfo("VOID");
					variable_type = "VOID" ;
					$$ = s;
				}
 				;
 		
declaration_list : declaration_list COMMA ID
					{
						logout << "Line " << line_count << " : declaration_list : declaration_list COMMA ID\n" ;
						logout << $3->getName() << endl << endl;
						if(variable_type == "VOID"){
							errorout << "Error at line " << line_count << " :variable type can't be void" << endl << endl;
							semantic_err++;
						}
						else{
							SymbolInfo* temp = table.lookUp($3->getName(), "VAR");
							if(temp != NULL){
							errorout << "Error at line " << line_count << ": Variable "<< $3->getName() <<" already declared" << endl << endl;	
								semantic_err++;	
							}
							else{
								//SymbolInfo* temp2 = table.InsertandGet($3->getName(), $3->getType());
								//temp2->setVarType(variable_type);
								//temp2->setIDType("VAR");
								SymbolInfo* temp2 = new SymbolInfo($3->getName(), $3->getType());
								temp2->setVarType(variable_type);
								temp2->setIDType("VAR");
								table.Insert(*temp2);
								variable.push_back($3->getName()+to_string(table.scopeNum));
								//data.push_back(*temp2);
								//table.printAll(logout);
							}
						}
					}
 					| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
					{
						logout << "Line " << line_count << " : declaration_list : 	declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n" ;
						logout << $3->getName() << endl;
						logout << $5->getName() << endl << endl;
						if(variable_type == "VOID"){
							errorout << "Error at line " << line_count << " : array type can't be void" << endl << endl;
							semantic_err++;
						}
						else{
							SymbolInfo* temp = table.lookUp($3->getName(), "ARR");
							if(temp!= NULL){
							errorout << "Error at line " << line_count << " : Array "<< $3->getName()<< " already declared" << endl << endl;
								semantic_err++;			
							}
							else{
								SymbolInfo* temp2 = new SymbolInfo($3->getName(), $3->getType());
								temp2->setVarType(variable_type);
								temp2->setIDType("ARR");
								int arr_size = atoi(($5->getName()).c_str());
								temp2->setarr_size(arr_size);
								if(variable_type == "INT"){								
									for(int i = temp2->ints.size(); i<arr_size; i++){
										temp2->ints.push_back(0);
									}							
								}
								else if(variable_type == "FLOAT"){								
									for(int i = temp2->floats.size(); i<arr_size; i++){
										temp2->floats.push_back(0);
									}							
								}
								else if(variable_type == "CHAR"){								
									for(int i = temp2->chars.size(); i<arr_size; i++){
										temp2->chars.push_back('\0');
									}							
								}
								table.Insert(*temp2);
								arrays.push_back($3->getName()+to_string(table.scopeNum));
					                        array_size.push_back(arr_size);	
								//data.push_back(*temp2);		
								//cout << temp2->getName() << endl;			
								//table.printAll(logout);
							}
						}

					}
 					| ID
					{
						logout << "Line " << line_count << " : declaration_list : ID\n" ;
						logout << $1->getName() << endl << endl;
						if(variable_type == "VOID"){
							errorout << "Error at line " << line_count << " :variable type can't be void" << endl << endl;
							semantic_err++;
						}
						else{
							SymbolInfo* temp = table.lookUp($1->getName(), "ARR");
							if(temp!= NULL){
							errorout << "Error at line " << line_count << ": Variable "<< $1->getName() <<" already declared" << endl << endl;	
								semantic_err++;		
							}
							else{
								SymbolInfo* temp2 = new SymbolInfo($1->getName(), $1->getType());
								temp2->setVarType(variable_type);
								temp2->setIDType("VAR");
								table.Insert(*temp2);
								variable.push_back($1->getName()+to_string(table.scopeNum));
								//data.push_back(*temp2);
								//cout << temp2->getName() << endl;
//table.printAll(logout);										
							}
						}
					}
					| ID LTHIRD CONST_INT RTHIRD
					{
						logout << "Line " << line_count << " : declaration_list : ID LTHIRD CONST_INT RTHIRD\n" ;
						logout << $1->getName() << endl;
						logout << $3->getName() << endl << endl;
						if(variable_type == "VOID"){
							errorout << "Error at line " << line_count << " :array type can't be void" << endl << endl;
							semantic_err++;
						}
						else{
							SymbolInfo* temp = table.lookUp($1->getName(), "ARR");
							if(temp!= NULL){
								errorout << "Error at line " << line_count << ": Array "<< $1->getName() <<" already declared" << endl << endl;	
								semantic_err++;
							}
							else{
								SymbolInfo* temp2 = new SymbolInfo($1->getName(), $1->getType());
								temp2->setVarType(variable_type);
								temp2->setIDType("ARR");
								int arr_size = atoi(($3->getName()).c_str());
								temp2->setarr_size(arr_size);
								table.Insert(*temp2);
								arrays.push_back($1->getName()+to_string(table.scopeNum));
					                        array_size.push_back(arr_size);
								//data.push_back(*temp2);
								//cout << temp2->getName() << endl;
								//table.printAll(logout);			
							}
						}
					}						
					;


statements : statement {
				$$=$1;
				logout << "Line " << line_count << " : statements : statement\n"<< endl;
			}
	       | statements statement {
				$$=$1;
				$$->code = $$->code +  $2->code;
				delete $2;
				logout << "Line " << line_count << " : statements : statements statement\n"<< endl;
			}
	       ;


statement 	: 	var_declaration
			{
				logout << "Line " << line_count << " : statement : var_declaration\n"<< endl;
			}
	  		|	expression_statement {
					logout << "Line " << line_count << " : statement : expression_statement\n"<< endl;
					$$=$1;
				}
			| 	compound_statement {
					logout << "Line " << line_count << " : statement : compound_statement\n"<< endl;
					$$=$1;
				}
			|	FOR LPAREN expression_statement expression_statement expression RPAREN statement 				{			
				logout << "Line " << line_count << " : statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n"<< endl;
					/*
						$3's code at first, which is already done by assigning $$=$3
						create two labels and append one of them in $$->code
						compare $4's symbol with 0
						if equal jump to 2nd label
						append $7's code
						append $5's code
						append the second label in the code
					*/

					$$ = $3;
					char *label1 = newLabel();
					char *label2 = newLabel();
					$$->code = $$->code +  string(label1) + ":\n";
					$$->code+=$4->code;
					$$->code+="\tmov ax , "+$4->getName()+"\n";
					$$->code+="\tcmp ax , 0\n";
					$$->code+="\tje "+string(label2)+"\n";
					$$->code+=$7->code;
					$$->code+=$5->code;
					$$->code+="\tjmp "+string(label1)+"\n";
					$$->code+=string(label2)+":\n";
		
				}
			|	IF LPAREN expression RPAREN statement %prec THEN {
					logout << "Line " << line_count << " : statement : IF LPAREN expression RPAREN statement\n"<< endl;
					$$=$3;
					
					char *label=newLabel();
					$$->code+="\tmov ax,   "+$3->getName()+"\n";
					$$->code+="\tcmp ax, 0\n";
					$$->code+="\tje "+string(label)+"\n";
					$$->code+=$5->code;
					$$->code+=string(label)+":\n";
					
					//$$->setName("if");//not necessary
				}
			|	IF LPAREN expression RPAREN statement ELSE statement {
					logout << "Line " << line_count << " : statement : IF LPAREN expression RPAREN statement ELSE statement\n"<< endl;
					$$=$3;
					//similar to if part
					char *elselabel=newLabel();
					char *exitlabel=newLabel();
					$$->code+="\tmov ax,  "+$3->getName()+"\n";
					$$->code+="\tcmp ax,0\n";
					$$->code+="\tje "+string(elselabel)+"\n";
					$$->code+=$5->code;
					$$->code+="\tjmp "+string(exitlabel)+"\n";
					$$->code+=string(elselabel)+":\n";
					$$->code+=$7->code;
					$$->code+=string(exitlabel)+":\n";
				}
			|	WHILE LPAREN expression RPAREN statement {
					logout << "Line " << line_count << " : statement : WHILE LPAREN expression RPAREN statement\n"<< endl;
					$$ = new SymbolInfo();
					char * label = newLabel();
					char * exit = newLabel();
					$$->code = string(label) + ":\n"; 
					$$->code+=$3->code;
					$$->code+="\tmov ax , "+$3->getName()+"\n";
					$$->code+="\tcmp ax , 0\n";
					$$->code+="\tje "+string(exit)+"\n";
					$$->code+=$5->code;
					$$->code+="\tjmp "+string(label)+"\n";
					$$->code+=string(exit)+":\n";
			
				}
			|	PRINTLN LPAREN ID RPAREN SEMICOLON {
					// ID is an integer variable.
					$$=new SymbolInfo("println","nonterminal");
					logout << "Line " << line_count << " : statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n"<< endl;
				       // variable.push_back($3->getName()+ to_string(table.scopeNum));
					$$->code = $$->code +  "\tmov ax,   " + $3->getName() +to_string(table.scopeNum)+"\n\tcall PRINT_DECIMAL\n";
					//$$->code = $$->code +  "\tcall PRINT_DECIMAL\n";
				}
			| PRINTLN LPAREN ID RPAREN error
			{
				errorout << "Error at line " << line_count << " ; missing" << endl << endl;
				semantic_err++;
			}
			| 	RETURN expression SEMICOLON {
					$$=$2;
					$$->code+="\tmov dx,"+$2->getName()+"\n";
					//$$->code+="\tjmp   "+string(return_label)+"\n";
					if($2->getIDType()=="FUNC"){  cout<<$2->getName()+"......."<<endl;
						$$->code+="\tcall "+$2->getName()+"\n";
					}
		
					logout << "Line " << line_count << " : statement : RETURN expression SEMICOLON\n"<< endl;
				}
			| RETURN expression error
			{
				errorout << "Error at line " << line_count << " ; missing" << endl << endl;
				semantic_err++;
			}
			;
		
expression_statement	: SEMICOLON	{
							logout << "Line " << line_count << " : expression_statement : SEMICOLON\n"<< endl;
							$$=new SymbolInfo(";","SEMICOLON");
							$$->code="";
							tempCount = 0;
						}			
					| expression SEMICOLON {
							logout << "Line " << line_count << " : expression_statement : expression SEMICOLON\n"<< endl;
							$$=$1;
							tempCount = 0;
						}		
					| expression error
						{
							errorout << "Error at line " << line_count << " ; missing" << endl << endl;
							semantic_err++;
						} 		 		
						;
						
variable	: ID {
				logout << "Line " << line_count << " : variable : ID\n" ;
				logout << $1->getName() << endl << endl;
				SymbolInfo* temp = table.lookUp($1->getName(),"VAR");
				
				if(temp == NULL){
					//logout << "Variable " << $1->getName() << " doesn't exist" << endl;
					cout<<temp<<"......"<<endl;
					errorout << "Error at line " << line_count << " : " << $1->getName() << " doesn't exist" <<  endl << endl;					
					semantic_err++;
				}
				else{
					$$= new SymbolInfo($1);
					$$->code="";
					$$->setName($$->getName()+to_string(table.scopeNum));
					//variable.push_back($$->getName()+to_string(table.scopeNum));
					
					$$->setType("notarray");
				}
		}		
		| ID LTHIRD expression RTHIRD {
				logout << "Line " << line_count << " : variable : ID LTHIRD expression RTHIRD\n" ;
				logout << $1->getName() << endl << endl;
				SymbolInfo* temp = table.lookUp($1->getName(),"ARR");
				if(temp == NULL){
				errorout << "Error at line " << line_count << " : " <<$1->getName() << " doesn't exist" <<  endl << endl;					
					semantic_err++;				
				}
				else{
					
					$$= new SymbolInfo($1);
					$$->setType("array");
					$$->setName($$->getName()+to_string(table.scopeNum));
					//arrays.push_back($$->getName()+to_string(table.scopeNum));
					
					//array_size.push_back($1->getarr_size());
					$$->code=$3->code ;
					$$->code = $$->code +  "\tmov bx, " +$3->getName() +"\n";
					$$->code = $$->code +  "\tadd bx, bx\n";
					
					delete $3;
			}
		}	
		;
			
expression : logic_expression {
			$$= $1;
			logout << "Line " << line_count << " : expression : logic_expression\n"<< endl;
		}	
		| variable ASSIGNOP logic_expression {
				logout << "Line " << line_count << " : expression : variable ASSIGNOP logic_expression\n"<< endl;
				$$=$1;
				$$->code=$3->code+$1->code;
				SymbolInfo* temp=new SymbolInfo();
			        temp = table.lookUp($3->getName(), "FUNC");
				if(temp==NULL){
					cout<<"asdfghjkxcvbnm"<<endl;
				}else{
					$$->code+="\tcall "+$3->getName()+"\n";
				}
				$$->code+="\tmov ax,   "+$3->getName()+"\n";
				//variable.push_back($1->getName());
				cout<<$1->getName()<<$3->getName()<<endl;
				if($$->getType()=="notarray"){ 
					$$->code+= "\tmov "+$1->getName()+", ax\n";
				}
				
				else{
					$$->code+= "\tmov  "+$1->getName()+"[bx], ax\n"; cout<<$1->getName()<<endl;
				}

				delete $3;
				//delete $1;
			}	
		;
			
logic_expression : rel_expression {
					logout << "Line " << line_count << " : logic_expression : rel_expression\n"<< endl;
					$$= $1;	
					//variable.push_back($1->getName());	
				}	
		| rel_expression LOGICOP rel_expression {
					logout << "Line " << line_count << " : logic_expression : rel_expression LOGICOP rel_expression\n"<< endl;
					$$=$1;
					$$->code=$$->code + $3->code;
					char * label1 = newLabel();
					char * label2 = newLabel();
					char * temp = newPTemp();
					if($2->getName()=="&&"){
						/* 
						Check whether both operands value is 1. If both are one set value of a temporary variable to 1
						otherwise 0
						*/
						$$->code = $$->code +  "\tmov ax , " + $1->getName() +"\n";
						$$->code = $$->code +  "\tcmp ax , 0\n";
				 		$$->code = $$->code +  "\tje " + string(label1) +"\n";
						$$->code = $$->code +  "\tmov ax , " + $3->getName() +"\n";
						$$->code = $$->code +  "\tcmp ax , 0\n";
						$$->code = $$->code +  "\tje " + string(label1) +"\n";
						$$->code = $$->code +  "\tmov " + string(temp) + " , 1\n";
						$$->code = $$->code +  "\tjmp " + string(label2) + "\n";
						$$->code = $$->code +  string(label1) + ":\n" ;
						$$->code = $$->code +  "\tmov " + string(temp) + ", 0\n";
						$$->code = $$->code +  string(label2) + ":\n";
						$$->setName(temp);
						ptemp_var.push_back(string(temp));
						
					}
					else if($2->getName()=="||"){
						$$->code = $$->code +  "\tmov ax , " + $1->getName() +"\n";
						$$->code = $$->code +  "\tcmp ax , 0\n";
				 		$$->code = $$->code +  "\tjne " + string(label1) +"\n";
						$$->code = $$->code +  "\tmov ax , " + $3->getName() +"\n";
						$$->code = $$->code +  "\tcmp ax , 0\n";
						$$->code = $$->code +  "\tjne " + string(label1) +"\n";
						$$->code = $$->code +  "\tmov " + string(temp) + " , 0\n";
						$$->code = $$->code +  "\tjmp " + string(label2) + "\n";
						$$->code = $$->code +  string(label1) + ":\n" ;
						$$->code = $$->code +  "\tmov " + string(temp) + ", 1\n";
						$$->code = $$->code +  string(label2) + ":\n";
						$$->setName(temp);
						ptemp_var.push_back(string(temp));
						
					}
					delete ($3);
				}	
			;
			
rel_expression	: simple_expression {
				logout << "Line " << line_count << " : rel_expression : simple_expression\n"<< endl;
				$$= $1;
			}	
		| simple_expression RELOP simple_expression {
				logout << "Line " << line_count << " : rel_expression : simple_expression RELOP simple_expression\n"<< endl;
				$$=$1;
				$$->code+=$3->code;
				$$->code+="\tmov ax,   " + $1->getName()+"\n";
				$$->code+="\tcmp ax, " + $3->getName()+"\n";
				char *temp=newPTemp();
				char *label1=newLabel();
				char *label2=newLabel();
				if($2->getName()=="<"){
					$$->code+="\tjl " + string(label1)+"\n";
				}
				else if($2->getName()=="<="){
					$$->code+="\tjle " + string(label1)+"\n";
				}
				else if($2->getName()==">"){
					$$->code+="\tjg " + string(label1)+"\n";
				}
				else if($2->getName()==">="){
					$$->code+="\tjge " + string(label1)+"\n";
				}
				else if($2->getName()=="=="){
					$$->code+="\tje " + string(label1)+"\n";
				}
				else if($2->getName()=="!="){
					$$->code+="\tjne " + string(label1)+"\n";
				}
				
				$$->code+="\tmov "+string(temp) +", 0\n";
				$$->code+="\tjmp "+string(label2) +"\n";
				$$->code+=string(label1)+":\n";
				$$->code+= "\tmov "+string(temp)+", 1\n";
				$$->code+=string(label2)+":\n";
				$$->setName(temp);
				ptemp_var.push_back(string(temp));
				delete $3;
			}	
		;
				
simple_expression : term {
				logout << "Line " << line_count << " : simple_expression : term\n"<< endl;
				$$= $1;
			}
		| simple_expression ADDOP term {
				logout << "Line " << line_count << " : simple_expression : simple_expression ADDOP term\n"<< endl;
				$$=$1;
				$$->code=$$->code+$3->code;
				
				// move one of the operands to a register, perform addition or subtraction with the other operand and move the result in a temporary variable  
				
				if($2->getName()=="+"){
					char* temp = newTemp();
					$$->code = $$->code +  "\tmov ax,   " + $1->getName() + "\n";
					$$->code = $$->code +  "\tadd ax, " + $3->getName() + "\n";
					$$->code = $$->code +  "\tmov " + string(temp) +" , ax\n";
					$$->setName(string(temp));
					temp_var.push_back(string(temp));
				}
				else if($2->getName() == "-"){
					char* temp = newTemp();
					$$->code = $$->code +  "\tmov ax,   " + $1->getName() + "\n";
					$$->code = $$->code +  "\tsub ax, " + $3->getName() + "\n";
					$$->code = $$->code +  "\tmov " + string(temp) +" , ax\n";
					$$->setName(string(temp));
					temp_var.push_back(string(temp));
				}
				delete $3;
				cout << endl;
			}
				;
				
term :	unary_expression 
		{
			logout << "Line " << line_count << " : term : unary_expression\n"<< endl;						
			$$= $1;
		}
	 	|term MULOP unary_expression 
		{
			logout << "Line " << line_count << " : term : term MULOP unary_expression\n"<< endl;
			$$=$1;
			$$->code = $$->code +  $3->code;
			$$->code = $$->code +  "\tmov ax,   "+ $1->getName()+"\n";
			$$->code = $$->code +  "\tmov bx, "+ $3->getName() +"\n";
			char *temp=newBTemp();
			if($2->getName()=="*"){
				$$->code = $$->code +  "\tmul bx\n";
				$$->code = $$->code +  "\tmov "+ string(temp) + ", ax\n";
				$$->setName(temp);
			        temp_var.push_back(string(temp));
			}
			else if($2->getName()=="/"){
				// clear dx, perform 'div bx' and mov ax to temp
				$$->code = $$->code +  "\txor dx , dx\n";
				$$->code = $$->code +  "\tdiv bx\n";
				$$->code = $$->code +  "\tmov " + string(temp) + " , ax\n";
				$$->setName(temp);
			        temp_var.push_back(string(temp));
			}
			else{
			// clear dx, perform 'div bx' and mov dx to temp
				$$->code = $$->code +  "\txor dx , dx\n";
				$$->code = $$->code +  "\tdiv bx\n";
				$$->code = $$->code +  "\tmov " + string(temp) + " , dx\n";
				$$->setName(temp);
			        temp_var.push_back(string(temp));
				
			}
			//$$->setName(temp);
			//temp_var.push_back(string(temp)+"...5");
			cout << endl << $$->code << endl;
			delete $3;
		}
	 	;

unary_expression 	:	ADDOP unary_expression  
					{
						logout << "Line " << line_count << " : unary_expression : ADDOP unary_expression\n"<< endl;
						
						if($1->getName() == "+"){
							$$=$2;
						}
						else if($1->getName() == "-")
						{
							$$ = $2;
							$$->code = $$->code +  "\tmov ax,   " + $2->getName() + "\n";
							$$->code = $$->code +  "\tneg ax\n";
							$$->code = $$->code +  "\tmov " + $2->getName() + " , ax\n";
						}
							// Perform NEG operation if the symbol of ADDOP is '-'
					}
					|	NOT unary_expression 
					{
						logout << "Line " << line_count << " : unary_expression : NOT unary_expression\n"<< endl;
						$$=$2;
						char *temp=newTemp();
						$$->code="\tmov ax,   " + $2->getName() + "\n";
						$$->code+="\tnot ax\n";
						$$->code+="\tmov "+string(temp)+", ax";
						temp_var.push_back(string(temp));
					}
					|	factor 
					{
						logout << "Line " << line_count << " : unary_expression : factor\n"<< endl;
						$$=$1;
					}
					;
	
factor	: variable {
			SymbolInfo * newVar = new SymbolInfo(*$1);
			
			logout << "Line " << line_count << " : factor : variable\n"<< endl;
			if($$->getType()=="notarray"){
				
			}
			
			else{
				char *temp= newPTemp();
				$$->code+="\tmov ax,   " + $1->getName() + "[bx]\n";
				$$->code+= "\tmov " + string(temp) + ", ax\n";
				$$->setName(temp);
				temp_var.push_back(string(temp));
			}
			}
	| ID LPAREN argument_list RPAREN
	{
		logout << "Line " << line_count << " : factor : ID LPAREN argument_list RPAREN\n" ;
		logout << $1->getName() << endl << endl;
		SymbolInfo *temp=new SymbolInfo();
			temp = table.lookUp($1->getName(), "FUNC");
			if(temp == NULL){
				errorout << "Error at line " << line_count <<" : Function " <<$1->getName() <<" doesn't exist"<<endl << endl;
			}
	}
	| LPAREN expression RPAREN 
	{
		logout << "Line " << line_count << " : factor : LPAREN expression RPAREN\n"<< endl;
		$$= $2;
	}
	| CONST_INT 
	{
		logout << "Line " << line_count << " : factor : CONST_INT\n" ;
		logout << $1->getName() << endl << endl;
		$$= $1;
	}
	| CONST_FLOAT 
	{
		logout << "Line " << line_count << " : factor : CONST_FLOAT\n" ;
		logout << $1->getName() << endl << endl;
		$$= $1;
	}
	| variable INCOP 
	{
		logout << "Line " << line_count << " : factor : variable INCOP\n"<< endl;
		$$=$1;
		$$->code = $$->code +  "\tmov ax , " + $$->getName()+ "\n";
		$$->code = $$->code +  "\tadd ax , 1\n";
		$$->code = $$->code +  "\tmov " + $$->getName() + " , ax\n";
		// perform incop depending on whether the varaible is an array or not
		
	}
	| variable DECOP
	{
		logout << "Line " << line_count << " : factor : variable DECOP\n"<< endl;
		$$ = $1;
		
		$$->code = $$->code +  "\tmov ax , " + $$->getName()+ "\n";
		$$->code = $$->code +  "\tsub ax , 1\n";
		$$->code = $$->code +  "\tmov " + $$->getName() + " , ax\n";
	}
	;

argument_list	: arguments
				{
					logout << "Line " << line_count << " : argument_list : arguments\n"<< endl;
				}
				| 
				{}
				;

arguments	:arguments COMMA logic_expression 
			{
				logout << "Line " << line_count << " : arguments : arguments COMMA logic_expression\n"<< endl;
			}
			|logic_expression
			{
				logout << "Line " << line_count << " : arguments : logic_expression\n"<< endl;
			}
			;
		
%%


void yyerror(const char *s){
	cout << "Error at line no " << line_count << " : " << s << endl;
}

int main(int argc, char * argv[]){
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout.open("1505095_log.txt");
	errorout.open("1505095_errors.txt");

	yyin= fin;
	yyparse();

	logout<<"Total Lines : "<<line_count-1<<endl<<endl;
	logout<<"Total Errors : "<<semantic_err+error<<endl<<endl;	

	logout.close();
	errorout.close();
	return 0;
}
