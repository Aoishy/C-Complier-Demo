%{
#include<bits/stdc++.h>
#include<cstdlib>
#include<cstring>
#include<cmath>
//#include "2005109.cpp"
#include "parsetree.cpp"


using namespace std;

extern int line_number;
extern int error_count;
int yyparse(void);
int yylex(void);
extern FILE *yyin;
FILE *logout;
FILE *parseout,*fp,*errorout;
int syntaxErrorCount = 0;

SymbolTable Table(11);


void yyerror(char *s)
{
	//write your code
}

string type_casting(string s1,string s2)
{
	if(s1=="CONST_FLOAT"||s1=="float"||s2=="CONST_FLOAT"||s2=="float")
	return "float";
	else return "int";


}
string error_factor(string s1,string s2,string s3,string s4,string s5,string s6,int line_number)
{  
	 
	 if(s1=="CONST_FLOAT"||s1=="float"||s2=="CONST_FLOAT"||s2=="float")

	{return "float";}

	else
	 {return "int";}

	if(s3=="void_err"||s4=="void_err")
	{
		error_count++;
		fprintf(errorout,"Line# %d: Void cannot be used in expression\n",line_number);
		return "error";
	}
	if(s5=="/"&&s6=="0")
	{
		error_count++;
		fprintf(errorout,"Line# %d: A number can not divided by zero\n",line_number);
		return "error";
	}
	else if(s5=="%"&&s6=="0")
	{
		error_count++;
		fprintf(errorout,"Line# %d: Warning: division by zero i=0f=1Const=0\n",line_number);
		return "error";
	}
	else if((s5=="%"&&s3!="CONST_INT")||s5=="%"&&s4!="CONST_INT")
	{
		error_count++;
		fprintf(errorout,"Line# %d: Operands of modulus must be integers\n",line_number);
		return "error";
	}

}
string func_error(SymbolInfo* name,int line_number)
{   string s;
	if(name==NULL)
	{   s="error";
		error_count++;
		fprintf(errorout,"Line# %d: Undeclared function \n",line_number);
		
	}
	else if(name->get_param_type()!="Function")
	{   s="error";
		error_count++;
		fprintf(errorout,"Line# %d: not a function\n",line_number);
		
	}
    else{
		s="null";
	}
	return s;
}

 string argument_checking ( SymbolInfo* func,vector<string> argument_list)
 {
	 string check=func->get_return_type();
	 for(int i=0;i<func->get_parameter_list().size();i++)
			{  
			string arguments2=func->get_parameter_list()[i];
				stringstream s(arguments2);
				string arguments3;
				vector<string>arguments4;
				while(getline(s,arguments3,' '))
				{
					arguments4.push_back(arguments3);
				}
				stringstream ss(argument_list[i]);
				vector<string>arguments5;
				while(getline(ss,arguments3,'.'))
				{
					arguments5.push_back(arguments3);
				}
				if(arguments4[0]=="INT"&&arguments5.size()>1)
				{
					check="error";
					error_count++;
					
				}
				else if(arguments4[0]!="INT"&&arguments5.size()==1)
				{
					check="error";
					error_count++;
					
				}	
			}
			return check;

 }

void list_size(int a,int b,int line_number)
{
	    
			if(a>b)
			{
				error_count++;
				fprintf(errorout,"Line# %d: Too few arguments to function \n",line_number);

			}
			else if(a<b)
			{   error_count++;
				fprintf(errorout,"Line# %d: Too few arguments to function \n",line_number);
			}
}


string assign_fault(string name1,string name2,string name3,string name4,int line_number)
{
	  string type=name1;
	if(name1=="error"||name2=="error")
	{
		type="error";
	}
	else if(name3=="void_err")
	{
		type="error";
		fprintf(errorout,"Line# %d: Void cannot be used in expression\n",line_number);
		error_count++;
	}
	if(name3=="float"&&(name4=="int"||name4=="CONST_INT"))
	{
		type="error";
		fprintf(errorout,"Line# %d: Floating point variable take integer value\n",line_number);
		error_count++;
	}
	return type;

}

void check_decalration(SymbolInfo* sym,SymbolInfo* sym1,string name,string name2,int line_number)
{
	if(sym==NULL)
	{
		error_count++;
		fprintf(errorout,"Line# %d: Undeclared function \n",line_number);
	}
	if(sym1==NULL)
	{
	error_count++;
		fprintf(errorout,"Line# %d: Undeclared function\n",line_number);	
	}

}







%}

%union
{
	SymbolInfo* lex_token ;
}

%token <lex_token>IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN CASE SWITCH CONTINUE DEFAULT ADDOP MULOP RELOP LOGICOP INCOP PRINTLN DECOP ASSIGNOP NOT BITOP LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON LSQUARE RSQUARE CONST_INT CONST_FLOAT CONST_CHAR ID  NUMBER STRING 
%type <lex_token>start program unit func_declaration func_definition parameter_list compound_statement var_declaration type_specifier declaration_list statements statement expression_statement variable expression logic_expression rel_expression simple_expression term unary_expression factor argument_list arguments


%left 
%right

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE 


%%

start : program { 
	    fprintf(logout,"start : program\n");	
	     string name=$1->getName();
		 string type="start";
         int start_line=$1->get_start_line();
		
	    $$=new SymbolInfo(name,type,start_line,line_number,"start : program");
		$$->set_node($1);
		  PrintParseTree(parseout,$$," ");
	

}
	;

program : program unit {

	 fprintf(logout,"program : program unit\n");
	
	 string name=$1->getName()+" "+$2->getName();
	 string type="program";
	 int startline=$1->get_start_line()<$2->get_start_line() ? $1->get_start_line() : $2->get_start_line();
	 $$ =new SymbolInfo(name,type,startline,line_number,"program : program unit");
	  $$->set_node($1);
	  $$->set_node($2);


}
	| unit
	{    
		 fprintf(logout,"program : unit\n");
		 string name = $1->getName();
		 string type="program";
		
		 int start_line=$1->get_start_line();
		 $$=new SymbolInfo(name,type,start_line,line_number,"program : unit");
		  $$->set_node($1);
	}
	;
	
unit : var_declaration
{
	     fprintf(logout,"unit : var_declaration\n");
		 string name = $1->getName();
		 string type="unit";
		
		 int start_line=$1->get_start_line();
		 $$=new SymbolInfo(name,type,start_line,line_number,"unit : var_declaration");
		  $$->set_node($1);
}
     | func_declaration
	 {
        fprintf(logout,"unit : func_declaration\n");
		 string name = $1->getName();
		 string type="unit";
		
		 int start_line=$1->get_start_line();
		 $$=new SymbolInfo(name,type,start_line,line_number,"unit : func_declaration");
		  $$->set_node($1);

	 }
     | func_definition
	 {
         fprintf(logout,"unit : func_definition\n");
		 string name = $1->getName();
		 string type="unit";
		
		 int start_line=$1->get_start_line();
		 $$=new SymbolInfo(name,type,start_line,line_number,"unit : func_definition");
		  $$->set_node($1);
	 }
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
{   
	string name2=$2->getName();
	string name1=$1->getName();
	string type="ID";
		string name= name1+" "+name2+"("+$4->getName()+")"+";";
		int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int min4=$5->get_start_line()<min3?$5->get_start_line():min3;
			 int line=$6->get_start_line()<min4?$6->get_start_line():min4;
			
			int lastline=line_number;
            string grammer="func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON";
			$$=new SymbolInfo(name,"func_declaration",line,lastline,grammer);
			$$->set_node($1);
			$$->set_node($2);
			$$->set_node($3);
			$$->set_node($4);
			$$->set_node($5);
			$$->set_node($6);
			fprintf(logout,"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n");



	}

		| type_specifier ID LPAREN RPAREN SEMICOLON
		{  string name1=$1->getName();
           string name2=$2->getName();
		   string type="ID";
	       bool c=Table.InsertSymbol(name2,type);
	       SymbolInfo *check;
	    if(c==NULL)
	    {
		            error_count++;
		           fprintf(errorout,"Line# %d :Multiple declaration of variable\n",line_number);

	   } 
	   else{
		SymbolInfo *check=new SymbolInfo(name2,"Function",name1);
	    check->set_param_type("Function");
		check->set_return_type(name1);

	   }
	        string name=name1+" "+name2+"()"+";";
	        int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int line=$5->get_start_line()<min3?$5->get_start_line():min3;		
			
			int lastline=line_number;
            string grammer="func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON";
			$$=new SymbolInfo(name,"func_declaration",line,lastline,grammer);
			$$->set_node($1);
			$$->set_node($2);
			$$->set_node($3);
			$$->set_node($4);
			$$->set_node($5);
			fprintf(logout,"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n");


		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN
{ 
	
			}

 compound_statement{
	        
			   fprintf(logout,"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n"); 
			 string name1=$1->getName();
			 string name2=$2->getName();
			 
			 string name= name1+" "+name2+"("+$4->getName()+")"+$7->getName();
			 string type="func_definition";
			 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int line=$5->get_start_line()<min3?$5->get_start_line():min3;
			int line1=$7->get_start_line()<line?$7->get_start_line():line;
			
			int lastline=line_number;
			string grammer="func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement";
			 $$=new SymbolInfo(name,type,line1,lastline,grammer);
			 $$->set_node($1);
			$$->set_node($2);
			$$->set_node($3);
			$$->set_node($4);
			$$->set_node($5);
			$$->set_node($7);

 }
		| type_specifier ID LPAREN RPAREN
		{
			SymbolInfo *sym=Table.LookUpSymbol($2->getName());
		
				
		}
 compound_statement{
              
			   fprintf(logout,"func_definition : type_specifier ID LPAREN RPAREN compound_statement\n"); 
			 string name1=$1->getName();
			 string name2=$2->getName();
			 string name3=$6->getName();
			 string name= name1+" "+name2+"("+")"+name3;
			 string type="func_definition";
			 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int line=$6->get_start_line()<min3?$6->get_start_line():min3;
			
			
			int lastline=line_number;
			string grammer="func_definition : type_specifier ID LPAREN RPAREN compound_statement";
			 $$=new SymbolInfo(name,type,line,lastline,grammer);
			 $$->set_node($1);
			$$->set_node($2);
			$$->set_node($3);
			$$->set_node($4);
			$$->set_node($6);

			}
		
 		;				


parameter_list  : parameter_list COMMA type_specifier ID
{
	   
		string name1=$1->getName();
		string name2=$3->getName();
		string name3=$4->getName();
		string name=name1+","+name2+" "+name3;
		string type="parameter_list";
		int lin1=$1->get_start_line()<$2->get_start_line() ? $1->get_start_line():$2->get_start_line();
        int lin2=$3->get_start_line()<lin1 ? $3->get_start_line() :lin1;
		int start_line=$4->get_start_line()<lin2 ?$4->get_start_line():lin2;
		int lastline=line_number;
		string grammer="parameter_list : parameter_list COMMA type_specifier ID";
		$$=new SymbolInfo(name,type,start_line,lastline,grammer);
		 $$->set_node($1);
		$$->set_node($2);
		$$->set_node($3);
		$$->set_node($4);	
		fprintf(logout,"parameter_list  : parameter_list COMMA type_specifier ID\n");



}
		| parameter_list COMMA type_specifier
		{  fprintf(logout,"parameter_list  : parameter_list COMMA type_specifier\n");
			string name1=$1->getName();
			string name2=$3->getName();
			string name=name1+","+name2;
			string type="parameter_list";
			
			int lin1=$1->get_start_line()<$2->get_start_line() ? $1->get_start_line():$2->get_start_line();
            int lin2=$3->get_start_line()<lin1 ? $3->get_start_line() :lin1;
            int lastline=line_number;
			string grammer="parameter_list : parameter_list COMMA type_specifier";
			$$=new SymbolInfo(name,type,lin2,lastline,grammer);
			$$->set_node($1);
		    $$->set_node($2);
		    $$->set_node($3);
		   

		}
 		| type_specifier ID
		{   fprintf(logout,"parameter_list  : type_specifier ID\n"); 
			string name1=$1->getName();
			string name2=$2->getName();
			string name=name1+" "+name2;
			string type="parameter_list";
			
			int lin1=$1->get_start_line()<$2->get_start_line() ? $1->get_start_line():$2->get_start_line();
			 int lastline=line_number;
			string grammer="parameter_list : type_specifier ID";
			$$=new SymbolInfo(name,type,lin1,lastline,grammer);
			$$->set_node($1);
		    $$->set_node($2);
		    

		}
		| type_specifier
		{   fprintf(logout,"parameter_list  : type_specifier\n"); 
			string name=$1->getName();
			string type="parameter_list";
			
			int lin1=$1->get_start_line();
			 int lastline=line_number;
			 string grammer="parameter_list : type_specifier";
			 $$=new SymbolInfo(name,type,lin1,lastline,grammer);
			 $$->set_node($1);


		}
		|type_specifier error
		{
               yyclearin;
              	yyerrok;
               	$$=new SymbolInfo($1->getName(),"error");
	          
			   fprintf(errorout,"Error at line no %d syntax error\n",line_number);
		}
 		;

 		
compound_statement : LCURL statements RCURL
            { 
				
			fprintf(logout,"compound_statement : LCURL statements RCURL\n");
			string name="{"+$2->getName()+"}";
			string type=$2->getType();
			int lin1=$1->get_start_line()<$2->get_start_line() ? $1->get_start_line():$2->get_start_line();
            int line=$3->get_start_line()<lin1 ? $3->get_start_line() :lin1;
			string grammer="compound_statement : LCURL statements RCURL";
            int lastline=line_number;
			
			$$=new SymbolInfo(name,type,line,lastline,grammer);
			$$->set_node($1);
			$$->set_node($2);
			$$->set_node($3);
			Table.PrintAllScopeTable(logout);
			

				
			}
 		    | LCURL RCURL
			{  
				fprintf(logout,"compound_statement : LCURL RCURL\n");
			    string name="{}";
			    string type="compound_statement";
		     	int line=$1->get_start_line()<$2->get_start_line() ? $1->get_start_line():$2->get_start_line();
			    string grammer="compound_statement : LCURL RCURL";
                int lastline=line_number;
			    
			    $$=new SymbolInfo(name,type,line,lastline,grammer);
				$$->set_node($1);
			    $$->set_node($2);
				 Table.PrintAllScopeTable(logout);
			}
 		    ;
 		    
 var_declaration : type_specifier declaration_list SEMICOLON
        {
           string name= $1->getName();
		   string name2=$2->getName();

		   fprintf(logout,"var_declaration : type_specifier declaration_list SEMICOLON\n"); 
			 string name3= name+" "+name2+";";
			 string type="var_declaration";
			 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int line=$3->get_start_line()<min1?$3->get_start_line():min1;
			
			int lastline=line_number;
			string grammer="var_declaration : type_specifier declaration_list SEMICOLON";
		    $$=new SymbolInfo(name3,type,line,lastline,grammer);
			$$->set_node($1);
			$$->set_node($2);
			$$->set_node($3);
		   if(name=="VOID")
		   {
			error_count++;
			fprintf(errorout,"Line# %d :Variable or field %s declared void\n",line_number);
		   }
		   else 
		   {
		vector<string> declaration_list;
		stringstream s($2->getName());
		//printf("list ====%s ",$2->getName());
		string declaration;
		while(getline(s,declaration,','))
		{
			declaration_list.push_back(declaration);
		}
		for(string declaration:declaration_list)
		{
			regex declaration1("[_A-Za-z][_A-Za-z0-9]*\[[0-9]+\]");
			if(regex_match(declaration,declaration1))
			{
			
				string arr="";
				int array_size;
				for(int i=0;i<declaration.length();i++)
				{
					if(declaration[i]=='[')
					{	
						string declaration2="";
						int j=i+1;
						while(declaration[j]!=']')
						{
							declaration2+=declaration[j];
							j++;
						}
						array_size=stoi(declaration2);
						break;
					}
					arr+=declaration[i];
				}
				
				
			
			 }
		}
	        }
            

	   }  

 		 ;
 		 
type_specifier	: INT
        {   string name="INT";
		    string type="int";
			int line=$1->get_start_line();
			int lastline=line_number;
			string grammer="type_specifier : INT";
			$$=new SymbolInfo(name,type,line,lastline,grammer);
			fprintf(logout,"type_specifier	: INT\n");
			$$->set_node($1);
		
		}
 		| FLOAT
		{
		$$=new SymbolInfo("FLOAT","float",$1->get_start_line(),line_number,"type_specifier : FLOAT");
			fprintf(logout,"type_specifier	: FLOAT\n");
			$$->set_node($1);	
		}
 		| VOID
		{
		$$=new SymbolInfo("VOID","void",$1->get_start_line(),line_number,"type_specifier : VOID");
			fprintf(logout,"type_specifier	: VOID\n");
			$$->set_node($1);		
		}
 		;
 		
declaration_list : declaration_list COMMA ID {
	  string name1=$1->getName();
	  string name2=$3->getName();
	  string name= name1+name2;
		
	  int c=min($1->get_start_line(),$2->get_start_line());
	  int start_line=min(c,$3->get_start_line());
	  int lastline=line_number;
	  fprintf(logout,"declaration_list : declaration_list COMMA ID \n"); 
      $$=new SymbolInfo(name,$3->getType(),start_line,lastline,"declaration_list : declaration_list COMMA ID");
	  $$->set_node($1);
		$$->set_node($2);
		$$->set_node($3);
	  

}

 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
		  { 
			 fprintf(logout,"declaration_list : declaration_list COMMA ID  LTHIRD CONST_INT RTHIRD\n"); 
			 string name1=$1->getName();
			 string name2=$3->getName();
			 string name3=$5->getName();
			 string name= name1+","+name2+"["+name3+"]";
			 string type="declaration_list";
			 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int min4=$5->get_start_line()<min3?$5->get_start_line():min3;
			 int line=$6->get_start_line()<min4?$6->get_start_line():min4;
			
			int lastline=line_number;
			string grammer="declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE";
			 $$=new SymbolInfo(name,type,line,lastline,grammer);
			 $$->set_node($1);
			$$->set_node($2);
			$$->set_node($3);
			$$->set_node($4);
			$$->set_node($5);
			$$->set_node($6);

		  }
 		  | ID
		  {
			string name=$1->getName();
			
			string type=$1->getType();
			$$= new SymbolInfo(name,type,$1->get_start_line(),line_number,"declaration_list : ID");
			fprintf(logout,"declaration_list : ID\n");
			$$->set_node($1);

		  }
 		  | ID LTHIRD CONST_INT RTHIRD
		  {
             
		string name1=$1->getName();
		string name2="[";
		string name3=$3->getName();
		string name4="]";
		string name=name1+name2+name3+name4;
		string type="ID";
		int lin1=$1->get_start_line()<$2->get_start_line() ? $1->get_start_line():$2->get_start_line();
        int lin2=$3->get_start_line()<lin1 ? $3->get_start_line() :lin1;
		int start_line=$4->get_start_line()<lin2 ?$4->get_start_line():lin2;
		int lastline=line_number;
		string grammer="declaration_list : ID LSQUARE CONST_INT RSQUARE";
		$$=new SymbolInfo(name,type,start_line,lastline,grammer);
		 $$->set_node($1);
		      $$->set_node($2);
	          $$->set_node($3);
		      $$->set_node($4);	
		fprintf(logout,"declaration_list : ID LSQUARE CONST_INT RSQUARE\n");
 
		  }
		  |
 		  ;
 		  
statements : statement
{fprintf(logout,"statements : statement \n");
	string name=$1->getName();
	string type="statements";
	int startline=$1->get_start_line();
	int lastline=line_number;
	string grammer="statements : statement";
	
	$$=new SymbolInfo(name,type,startline,lastline,grammer);
	$$->set_node($1);


}
	   | statements statement
	   {
		fprintf(logout,"statements : statements statement \n");
	string name=$1->getName()+" "+$2->getName();
	string type="statements";
	int startline=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
	int lastline=line_number;
	string grammer="statements : statements statement";
	
	$$=new SymbolInfo(name,type,startline,lastline,grammer);
	$$->set_node($1);
	$$->set_node($2);

	   }
	   ;
	   
statement : var_declaration

{
fprintf(logout,"statement : var_declaration \n");
	string name=$1->getName();
	string type="statement";
	int startline=$1->get_start_line();
	int lastline=line_number;
	string grammer="statement : var_declaration";
	
	$$=new SymbolInfo(name,type,startline,lastline,grammer);
	$$->set_node($1);
}
	  | expression_statement
	  {fprintf(logout,"statement :  expression_statement \n");
		string name=$1->getName();
	    string type="statement";
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="statement : expression_statement";
	   
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);
	  }
	  |{
	
}
| 
	  | compound_statement
	  {
        fprintf(logout,"statement : compound_statement \n");
		string name=$1->getName();
	    string type="statement";
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="statement : compound_statement";
	    $$->set_node($1);
	    $$=new SymbolInfo(name,type,startline,lastline,grammer); 
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  { fprintf(logout,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n");
		string name1=$1->getName();
		string name2=$3->getName();
		string name3=$4->getName();
		string name4=$5->getName();
		string type="statement";
		string name=name1+"("+name2+" "+name3+" "+name4;
		int lastline=line_number;
		string grammer="statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement";
		 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int min4=$5->get_start_line()<min3?$5->get_start_line():min3;
			 int min5=$6->get_start_line()<min4?$6->get_start_line():min4;
             int line=$7->get_start_line()<min5?$7->get_start_line():min5;
        
		
      $$=new SymbolInfo(name,type,line,lastline,grammer); 
	  $$->set_node($1);
		$$->set_node($2);
		$$->set_node($3);
		$$->set_node($4);
		$$->set_node($5);
		$$->set_node($6);
		$$->set_node($7);

	  }


	  | IF LPAREN expression RPAREN statement
	  {
		fprintf(logout,"statement : IF LPAREN expression RPAREN statement\n");
		string name1=$1->getName();
		string name2=$3->getName();
		string name4=$5->getName();
		string type="statement";
		string name=name1+"("+name2+")"+name4;
		int lastline=line_number;
		string grammer="statement : IF LPAREN expression RPAREN statement";
		 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int line=$5->get_start_line()<min3?$5->get_start_line():min3;
		 $$=new SymbolInfo(name,type,line,lastline,grammer);	
        $$->set_node($1);
		$$->set_node($2);
		$$->set_node($3);
		$$->set_node($4);
		$$->set_node($5);
   
	  }


	  | IF LPAREN expression RPAREN statement ELSE statement
	  {
		 fprintf(logout,"statement : IF LPAREN expression RPAREN statement ELSE statement\n");
		string name1=$1->getName();
		string name2=$3->getName();
		string name3=$5->getName();
		string name4=$6->getName();
		string name5=$7->getName();
		string type="statement";
		string name=name1+"("+name2+")"+name3+" "+name4+" "+name5;
		int lastline=line_number;
		string grammer="statement : IF LPAREN expression RPAREN statement ELSE statement";
		 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int min4=$5->get_start_line()<min3?$5->get_start_line():min3;
			 int min5=$6->get_start_line()<min4?$6->get_start_line():min4;
             int line=$7->get_start_line()<min5?$7->get_start_line():min5;
		
      $$=new SymbolInfo(name,type,line,lastline,grammer); 
	  $$->set_node($1);
		$$->set_node($2);
		$$->set_node($3);
		$$->set_node($4);
		$$->set_node($5);
		$$->set_node($6);
		$$->set_node($7);
	  }
	  | WHILE LPAREN expression RPAREN statement
	  {
		fprintf(logout,"statement : WHILE LPAREN expression RPAREN statement\n");
		string name1=$1->getName();
		string name2=$3->getName();
		string name4=$5->getName();
		string type="statement";
		string name=name1+"("+name2+")"+name4;
		int lastline=line_number;
		string grammer="statement : WHILE LPAREN expression RPAREN statement";
		 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int line=$5->get_start_line()<min3?$5->get_start_line():min3;
			
        
      $$=new SymbolInfo(name,type,line,lastline,grammer);
	  $$->set_node($1);
		$$->set_node($2);
		$$->set_node($3);
		$$->set_node($4);
		$$->set_node($5);
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  {  

		
		fprintf(logout,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n");
		string name1=$1->getName();
		string name2=$3->getName();
	    SymbolInfo *sym =Table.LookUpSymbol(name1);
		SymbolInfo *sym1 =Table.LookUpSymbol(name2);
		 check_decalration(sym ,sym1,name1,name2,line_number);
		string type="statement";
		string name=name1+"("+name2+")"+";";
		int lastline=line_number;
		string grammer="statement : PRINTLN LPAREN ID RPAREN SEMICOLON";
		 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
			 int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
			 int min3=$4->get_start_line()<min2?$4->get_start_line():min2;
			 int line=$5->get_start_line()<min3?$5->get_start_line():min3;
        $$->set_node($1);
		$$->set_node($2);
		$$->set_node($3);
		$$->set_node($4);
		$$->set_node($5);
      $$=new SymbolInfo(name,type,line,lastline,grammer);
	  }
	  | RETURN expression SEMICOLON
	  {
         string name1=$1->getName();
	     string name2=$2->getName();
	     string name= name1+" "+name2+";";
		
	    int c=min($1->get_start_line(),$2->get_start_line());
	    int start_line=min(c,$3->get_start_line());
	     int lastline=line_number;
	  fprintf(logout,"statement : RETURN expression SEMICOLON \n"); 
      $$=new SymbolInfo(name,"statement",start_line,lastline,"statement : RETURN expression SEMICOLON");
	    $$->set_node($1);
		$$->set_node($2);
		$$->set_node($3);
	  }
	  ;
	  
expression_statement 	: SEMICOLON	
{
	     fprintf(logout,"expression_statement : SEMICOLON	\n");
		string name=$1->getName();
	    string type="expression_statement";
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="expression_statement : SEMICOLON";
	    
	    $$=new SymbolInfo(name,type,startline,lastline,grammer); 
		 $$->set_node($1);
}		
			| expression SEMICOLON 
			{
				  fprintf(logout,"expression_statement : expression SEMICOLON\n");
		string name=$1->getName()+";";
	    string type="expression_statement";
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="expression_statement : expression SEMICOLON";
	    
	    $$=new SymbolInfo(name,type,startline,lastline,grammer); 
		$$->set_node($1);
		$$->set_node($2);
			}
			
	

			;
	  
variable : ID 	
{
	string name=$1->getName();
	string type=$1->getType();
	SymbolInfo* sym=Table.LookUpSymbol(name);
	if(sym==NULL)
	{   
		type="error";
		error_count++;
		fprintf(errorout,"Line# %d :Undeclared variable\n",line_number);
	}
	else if(sym->get_length()!=$1->get_length())
	{
		error_count++;
		type="error";
		fprintf(errorout,"Line# %d :Type mismatch for variable \n",line_number);
		
	}
	  fprintf(logout,"variable : ID\n");
	   int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="variable : ID";
	    
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		$$->set_node($1);
}



	
	 | ID LTHIRD expression RTHIRD  
	 {
		string name=$1->getName();
       	string type=$1->getType();
	    SymbolInfo* sym=Table.LookUpSymbol(name);
	
		if(sym!=NULL)
		{    string indextype=$3->getType();		
			if(indextype!="CONST_INT");
			{
				error_count++;
				fprintf(errorout,"Line# %d : Array subscript is not an integer\n",line_number);
                type="error";
			}
			 int size=sym->get_length();
			 if(size==0)
			{   error_count++;
			    type="error";
                fprintf(errorout,"Line# :  is not an array\n",line_number);  
			}

		}
		else
		{
			error_count++;
			type="error";
			fprintf(errorout,"Line# %d : Undeclared variable \n",line_number);
		}
		
		string nam=name+"["+$3->getName()+"]";
		 
		  int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
		  int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
		  int line=$4->get_start_line()<min2?$4->get_start_line():min2;
         int lastline=line_number;
	     string grammer="variable : ID LSQUARE expression RSQUARE";
		  $$=new SymbolInfo(name,type,line,lastline,grammer);
		  $$->set_node($1);
		 $$->set_node($2);
		 $$->set_node($3);
		 $$->set_node($4);
		 fprintf(logout,"variable : ID LSQUARE expression RSQUARE\n");


	 }
	 ;
	 
 expression : logic_expression	
 {
	fprintf(logout,"expression : logic_expression\n");
		string name=$1->getName();
	    string type=$1->getType();
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="expression : logic_expression";
	   
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);
 }
	   | variable ASSIGNOP logic_expression 
	   {
          
		  string check=assign_fault($1->getType(),$3->getType(),$1->get_param_type(),$3->get_param_type(),line_number);
		  string name1=$1->getName();
		  string name2=$3->getName();
		  string name=name1+"="+name2;
		  
		 int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
		  int line=$3->get_start_line()<min1?$3->get_start_line():min1;
		  int lastline=line_number;
	      string grammer="expression : variable ASSIGNOP logic_expression";
		  $$=new SymbolInfo(name,check,line,lastline,grammer);
		 fprintf(logout,"expression : variable ASSIGNOP logic_expression\n");
		 $$->set_node($1);
		   $$->set_node($2);
		   $$->set_node($3);



	   }	
	   ;
			
logic_expression : rel_expression 	
{
	fprintf(logout,"logic_expression : rel_expression\n");
		string name=$1->getName();
	    string type=$1->getType();
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="logic_expression : rel_expression";
	    
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		$$->set_node($1);
}
		 | rel_expression LOGICOP rel_expression 	
		 {fprintf(logout,"logic_expression : rel_expression LOGICOP rel_expression\n");
			 string name1=$1->getName();
	         string name2=$2->getName();
	         string name3=$3->getName();
	         string name= name1+name2+name3;
	    	
	         int c=min($1->get_start_line(),$2->get_start_line());
	         int start_line=min(c,$3->get_start_line());
	         int lastline=line_number;
            $$=new SymbolInfo(name,"int",start_line,lastline,"logic_expression : rel_expression LOGICOP rel_expression");
		 $$->set_node($1);
		    $$->set_node($2);
		    $$->set_node($3);}
		 ;
			
rel_expression	: simple_expression 
{
	fprintf(logout,"rel_expression : simple_expression\n");
		string name=$1->getName();
	    string type=$1->getType();
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="rel_expression	: simple_expression";
	   
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);
}
		| simple_expression RELOP simple_expression	
		{
			fprintf(logout,"simple_expression RELOP simple_expression\n");
			 string name1=$1->getName();
	         string name2=$2->getName();
	         string name3=$3->getName();
	         string name= name1+name2+name3;
	    	
	         int c=min($1->get_start_line(),$2->get_start_line());
	         int start_line=min(c,$3->get_start_line());
	         int lastline=line_number;
             $$=new SymbolInfo(name,"int",start_line,lastline,"simple_expression RELOP simple_expression");
		$$->set_node($1);
		    $$->set_node($2);
		    $$->set_node($3);
		}
		;
				
simple_expression : term 
{ 
	fprintf(logout,"simple_expression : term\n");
		string name=$1->getName();
	    string type=$1->getType();
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="simple_expression : term";
	   
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);

}
		  | simple_expression ADDOP term 

		  { string assign_var;
		  string name=$1->getName();
  	    string param_type1=$1->get_param_type();
			string param_type2=$3->get_param_type();	 
        assign_var= type_casting(param_type1,param_type2);
		fprintf(logout,"simple_expression : simple_expression ADDOP term\n");
            
	         int c=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
	         int line=c<$3->get_start_line()?c:$3->get_start_line();
	         int lastline=line_number;
             $$=new SymbolInfo(name,assign_var,line,lastline,"simple_expression : simple_expression ADDOP term");
		  $$->set_node($1);
		    $$->set_node($2);
		    $$->set_node($3);




		  }
		  |
		  ;
					
term :	unary_expression
{
	 fprintf(logout,"term :	unary_expression\n");
		string name=$1->getName();
	    string type=$1->getType();
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="term : unary_expression";
	   
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);
}
     |  term MULOP unary_expression
	 {
         
		string  type=error_factor($1->get_param_type(),$3->get_param_type(),$1->getType(),$3->getType(),$2->getName(),$3->getName(),line_number);
        fprintf(logout,"term :	term MULOP unary_expression\n"); 
		  
	         int c=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
	         int line=c<$3->get_start_line()?c:$3->get_start_line();
	         int lastline=line_number;
             $$=new SymbolInfo($1->getName()+$2->getName()+$3->getName(),type,line,lastline,"term : term MULOP unary_expression");
		 $$->set_node($1);
		    $$->set_node($2);
		    $$->set_node($3);


	 }
     ;

unary_expression : ADDOP unary_expression 
{
	fprintf(logout,"unary_expression : ADDOP unary_expression\n");
			    string name1=$1->getName();
				string name2=$2->getName();
				string name=name1+" "+name2;
			    string type="unary_expression";
		     	int line=$1->get_start_line()<$2->get_start_line() ? $1->get_start_line():$2->get_start_line();
			    string grammer="unary_expression : ADDOP unary_expression";
                int lastline=line_number;
			    
			    $$=new SymbolInfo(name,type,line,lastline,grammer);
				 $$->set_node($1);
			    $$->set_node($2);
} 
		 | NOT unary_expression 
		 {
			fprintf(logout,"unary_expression : NOT unary_expression\n");
			   
				string name2=$2->getName();
				string name="!"+name2;
			    string type="unary_expression";
		     	int line=$1->get_start_line()<$2->get_start_line() ? $1->get_start_line():$2->get_start_line();
			    string grammer="unary_expression : NOT unary_expression";
                int lastline=line_number;
			   
			    $$=new SymbolInfo(name,type,line,lastline,grammer);
				$$->set_node($1);
			    $$->set_node($2);
		 }
		 | factor 
		 {
			 fprintf(logout,"unary_expression : factor\n");
		string name=$1->getName();
	    string type=$1->getType();
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="unary_expression : factor";
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);
		 }
		 ;
	
factor	: variable 
{
	 fprintf(logout,"factor	: variable\n");
		string name=$1->getName();
	    string type="factor";
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="factor : variable";
	   
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);
		 
}
	 | ID LPAREN argument_list RPAREN 
	{    string name=$1->getName();
	  
		 SymbolInfo* func=Table.LookUpSymbol(name);
	 string check=func_error(func,line_number);
	 if(check!="error"){
	 if(func->get_param_type()=="Function")
		{
			vector<string> argument_list;
	      	stringstream s($3->getName());
		      string arg;
	       	while(getline(s,arg,','))
		{
			argument_list.push_back(arg);
		}
		if(func->get_parameter_list().size()!=argument_list.size())
		{   

			list_size(func->get_parameter_list().size(),argument_list.size(),line_number);
			
		}
		else
		{
			
			 check=  argument_checking (func,argument_list);

			
		}
		if(func->get_return_type()=="VOID")
		{
			check="void_err";
		}
		}}
		fprintf(logout,"factor : ID LPAREN argument_list RPAREN\n");
		
		string name2=$3->getName();
		string name3=name+"("+name2+")";
		int lastline=line_number;
		string grammer="factor : ID LPAREN argument_list RPAREN";
		int min1=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
		int min2=$3->get_start_line()<min1?$3->get_start_line():min1;
		int line=$4->get_start_line()<min2?$4->get_start_line():min2;
			
		
      $$=new SymbolInfo(name3,check,line,lastline,grammer);
	   $$->set_node($1);
		$$->set_node($2);
		$$->set_node($3);
		$$->set_node($4);
	
		}
		
		
	| LPAREN expression RPAREN
	{
		
			fprintf(logout,"factor : LPAREN expression RPAREN\n");
			
	         string name2=$2->getName();
	         string name= "("+name2+")";
	    	
	         int c=min($1->get_start_line(),$2->get_start_line());
	         int start_line=min(c,$3->get_start_line());
	         int lastline=line_number;
             $$=new SymbolInfo(name,$2->getType(),start_line,lastline,"factor : LPAREN expression RPAREN");
			 $$->set_node($1);
		    $$->set_node($2);
		    $$->set_node($3);
	}
	| CONST_INT 
	{
	fprintf(logout,"factor : CONST_INT\n");
		string name=$1->getName();
	    string type="int";
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="factor : CONST_INT";
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);	
		 $$->set_node($1);
	}
	| CONST_FLOAT
	{
		fprintf(logout,"factor : CONST_FLOAT\n");
		string name=$1->getName();
	    string type="float";
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="factor : CONST_FLOAT";
	   
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);
	}
	| variable INCOP 
	{
		fprintf(logout,"factor : variable INCOP\n");
		string name=$1->getName()+"++";
	    string type=$1->getType();
	    int startline=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
	    int lastline=line_number;
	    string grammer="factor : variable INCOP";
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		$$->set_node($1);
		$$->set_node($2);
	}
	| variable DECOP
	{
		fprintf(logout,"factor : variable DECOP\n");
		string name=$1->getName()+"--";
	    string type=$1->getType();
	    int startline=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
	    int lastline=line_number;
	    string grammer="factor : variable DECOP";
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);
		$$->set_node($2);
	}
	;
	
argument_list : arguments
{
	
		fprintf(logout,"argument_list : arguments\n");
		string name=$1->getName();
	    string type="argument_list";
	    int startline=$1->get_start_line();
	    int lastline=line_number;
	    string grammer="argument_list : arguments";
	   
	    $$=new SymbolInfo(name,type,startline,lastline,grammer);
		 $$->set_node($1);
}


			  |


			  ;
	
arguments : arguments COMMA logic_expression
{
	fprintf(logout,"arguments : arguments COMMA logic_expression\n");
			string name1=$1->getName();
	         string name2=$3->getName();
	         string name= name1+","+name2;

	         int c=$1->get_start_line()<$2->get_start_line()?$1->get_start_line():$2->get_start_line();
	         int start_line=min(c,$3->get_start_line());
	         int lastline=line_number;
             $$=new SymbolInfo(name,"arguments",start_line,lastline,"arguments : arguments COMMA logic_expression");
			 $$->set_node($1);
		    $$->set_node($2);
		    $$->set_node($3);
}
	      | logic_expression
		  {
			fprintf(logout,"arguments : logic_expression\n");
	    	string name=$1->getName();
	        string type="arguments";
	        int startline=$1->get_start_line();
	        int lastline=line_number;
	        string grammer="arguments : logic_expression";
	         $$=new SymbolInfo(name,type,startline,lastline,grammer);
			  $$->set_node($1);
		  }
	      ;
 

%%
int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	//FILE *fin=fopen(argv[1],"r");

	//if(fin==NULL){
		if((fp=fopen(argv[1],"r"))==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("2005109_log.txt","w");
	//errorout=fopen("2005109_error.txt","w");
	//parseout=fopen("2005109_parse.txt","w");
	errorout = fopen("error.txt","w");
	parseout=fopen("parsetree.txt","w");
	
  
	//yyin= fin;
	yyin=fp;
	yyparse();
	//fclose(yyin);
	//fprintf(errorout,"sdjdekwnd");
	fprintf(parseout,"sdjdekwnd");
    fprintf(logout,"Total lines: %d\n",line_number);
	fprintf(logout,"Total errors: %d\n",error_count);
	
	
	fclose(logout);
	fclose(errorout);
	fclose(parseout);
	return 0;
}


