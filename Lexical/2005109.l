%option noyywrap 
%x STATE_OF_STRING
%x STATE_OF_SINGLE_COMMENT
%x STATE_OF_MULTI_COMMENT
%{
#include<bits/stdc++.h>
#include<stdio.h>
#include<stdlib.h>
using namespace std;
 #include"2005109.cpp"

int line_number=1;
int error_count=0;
int warning_count=0;
int number_of_tabs=0;
int number_of_spaces=0;
int indent_level=0;
int expected_tabs=0;



FILE *logout;
FILE *tokenout;
 SymbolTable Table(10);
string ss,lex,logString;
int line=0;


char special_char(char c)
{
	if(c=='\'')
	{
		return '\'';
	}
	else if(c=='\"')
	{
		return '\"';
	}
	else if(c=='\\')
	{
		return '\\';
		
	}
	
	else if(c=='n')
	{
		return '\n';
	}
	else if(c=='t')
	{
		return  '\t';
	}
	else if(c=='\\')
	{
		return '\\';
	}
	else if(c=='a')
	{
		return '\a';
	}
	else if(c=='f')
	{
		return '\f';
	}
	else if(c=='r')
	{
		return '\r';
	}
	else if(c=='b')
	{
		return '\b';
	}
	else if(c=='v')
	{
		return '\v';
	}
	else if(c=='0')
	{
		return '\0';
	}
	else 
	{  
        return c;
	}


}


void indentation_verify()
{
	if(indent_level==0)
	{
		if(number_of_spaces==0)
		{
			if(number_of_tabs!=expected_tabs)
		{
			
				warning_count++;
				fprintf(logout, "Line# %d: warning, %d of tabs needed but got %d tabs.\n", line_number,expected_tabs,number_of_tabs);

			
		}
			
		}
		 else if(number_of_spaces>0)
		{
			warning_count++;
			 fprintf(logout, "Line# %d: Warning, tab requrired but got space.\n", line_number);
		}
		indent_level=1;
	}
}

string escapeString(string str) {
	string out = "";
	for (int i=1; i<str.length()-1; i++) {
		if(str[i] == '\\'&&str[i+1] == '\n')
			continue;
		else if (str[i] == '\\')
			out += special_char(str[++i]);
		else if (str[i] == '\r' || str[i] == '\n')
			continue;
		else
			out += str[i];
	}
	return out;
}

void printString(string token, string lexeme) {
	

	fprintf(tokenout,"<IF, %s>\n",escapeString(lexeme).c_str());
	fprintf(logout,"Line# %d: Token <IF> Lexeme %s found\n",line_number,escapeString(lexeme).c_str());
}


%}

WHITESPACE [\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n
INT {DIGIT}+
FRAC (\.{DIGIT}+)
EXPONENT ([Ee][-+]?{DIGIT}+)
MULTI_CHARACTER \'.[^\'\r\n]+\'
special[nt\'afrbv0\"\\]
TAB [\t]
SPACE [ ]



%%
{WHITESPACE}  {}
{NEWLINE} {line_number++; 
 number_of_spaces=0;
 number_of_tabs=0;
 indent_level=0; }
{TAB} {number_of_tabs++;};
{SPACE} {number_of_spaces++;};







"if"	{   
	        indentation_verify();
			fprintf(tokenout,"<IF, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <IF> Lexeme %s found\n",line_number,yytext);
		}
		
"else"	{
	        indentation_verify();
			fprintf(tokenout,"<ELSE, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <ELSE> Lexeme %s found\n",line_number,yytext);
		}
"for"	{
	        indentation_verify();
            fprintf(tokenout,"<FOR, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <FOR> Lexeme %s found\n",line_number,yytext);
		}
"while" {   
	        indentation_verify();
            fprintf(tokenout,"<WHILE, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <WHILE> Lexeme %s found\n",line_number,yytext);
		}
"do"	{
	         indentation_verify();
            fprintf(tokenout,"<DO, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <DO> Lexeme %s found\n",line_number,yytext); 
        }

"break"	{
	        indentation_verify();
	        fprintf(tokenout,"<BREAK, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <BREAK> Lexeme %s found\n",line_number,yytext);
        }
"int"	{   indentation_verify();
            fprintf(tokenout,"<INT, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <INT> Lexeme %s found\n",line_number,yytext);
        }	
"char"  {   indentation_verify();
            fprintf(tokenout,"<CHAR, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <CHAR> Lexeme %s found\n",line_number,yytext);
        } 
"float"	{
	         indentation_verify();
            fprintf(tokenout,"<FLOAT, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <FLOAT> Lexeme %s found\n",line_number,yytext);
        }	
"double" {   indentation_verify();
            fprintf(tokenout,"<DOUBLE, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <DOUBLE> Lexeme %s found\n",line_number,yytext);
         }
"void"  {   indentation_verify();
            fprintf(tokenout,"<VOID, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <VOID> Lexeme %s found\n",line_number,yytext); 
        }
"return" {  indentation_verify();
            fprintf(tokenout,"<RETURN, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <RETURN> Lexeme %s found\n",line_number,yytext); 
         }		

"switch" {   indentation_verify();
             fprintf(tokenout,"<SWITCH, %s>\n",yytext);
		     fprintf(logout,"Line# %d: Token <SWITCH> Lexeme %s found\n",line_number,yytext); 	     
         }
"case"	{   indentation_verify();
            fprintf(tokenout,"<CASE, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <CASE> Lexeme %s found\n",line_number,yytext); 
        }

"default" {  indentation_verify();
            fprintf(tokenout,"<DEFAULT, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <DEFAULT> Lexeme %s found\n",line_number,yytext); 
          }

"continue" { indentation_verify();
            fprintf(tokenout,"<CONTINUE, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <CONTINUE> Lexeme %s found\n",line_number,yytext); 
           }		
		

"+"		|

"-"		{    indentation_verify();
			fprintf(tokenout,"<ADDOP, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <ADDOP> Lexeme %s found\n",line_number,yytext);
			
		}

"*"     |
"/"     |
"%"     {  indentation_verify();
           fprintf(tokenout,"<MULOP, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <MULOP> Lexeme %s found\n",line_number,yytext); 	
        }

"++"	|

"--"	{  indentation_verify();
           fprintf(tokenout,"<INCOP, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <INCOP> Lexeme %s found\n",line_number,yytext); 
        }

"<"		|
"<="    |
">"     |
">="    |
"=="    |
"!="    {  indentation_verify();
           fprintf(tokenout,"<RELOP, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <RELOP> Lexeme %s found\n",line_number,yytext); 
        }

"="     {  indentation_verify();
           fprintf(tokenout,"<ASSIGNOP, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <ASSIGNOP> Lexeme %s found\n",line_number,yytext); 
        }

"&&"    |
"||"    {  indentation_verify();
           fprintf(tokenout,"<LOGICOP, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <LOGICOP> Lexeme %s found\n",line_number,yytext); 
        }
"&"    |
"|"	   |
"^"	   |
"<<"   |
">>"   {   indentation_verify();
           fprintf(tokenout,"<BITOP, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <BITOP> Lexeme %s found\n",line_number,yytext); 
       }

"!"   {    indentation_verify();
           fprintf(tokenout,"<NOT, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <NOT> Lexeme %s found\n",line_number,yytext); 
      }


"("   {    indentation_verify();
           fprintf(tokenout,"<LPAREN, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <LPAREN> Lexeme %s found\n",line_number,yytext); 
      }


")"   {    indentation_verify();
           fprintf(tokenout,"<RPAREN, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <RPAREN> Lexeme %s found\n",line_number,yytext); 
      }


"{"   {    indentation_verify();
           fprintf(tokenout,"<LCURL, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <LCURL> Lexeme %s found\n",line_number,yytext);
		   Table.EnterScope(); 
		   expected_tabs++;
			
      }


"}"   {   
           fprintf(tokenout,"<RCURL, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <RCURL> Lexeme %s found\n",line_number,yytext); 
		    Table.ExitScope();
			expected_tabs--;
			 indentation_verify();
			
      }

"["   {    indentation_verify();
           fprintf(tokenout,"<LSQUARE, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <LSQUARE> Lexeme %s found\n",line_number,yytext); 
      }

"]"   {    indentation_verify();
           fprintf(tokenout,"<RSQUARE, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <RSQUARE> Lexeme %s found\n",line_number,yytext); 
      }


","   {    indentation_verify();
           fprintf(tokenout,"<COMMA, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <COMMA> Lexeme %s found\n",line_number,yytext); 
      }	  	  	  

";"   {    indentation_verify();
           fprintf(tokenout,"<SEMICOLON, %s>\n",yytext);
		   fprintf(logout,"Line# %d: Token <SEMICOLON> Lexeme %s found\n",line_number,yytext); 
      }


		
{DIGIT}+ 	{   indentation_verify();
				fprintf(tokenout,"<CONST_INT, %s>\n",yytext);
				fprintf(logout,"Line# %d: Token <CONST_INT> Lexeme %s found\n",line_number,yytext);
				
				//insert in symbol table and print symbol table content(only non empty buckets)
			}

{INT}\.?{INT}?{EXPONENT}  |
{FRAC}{EXPONENT}          |
{INT}?{FRAC}              |
({INT}\.)                      {
	            indentation_verify();
	            fprintf(tokenout,"<CONST_FLOAT, %s>\n",yytext);
				fprintf(logout,"Line# %d: Token <CONST_FLOAT> Lexeme %s found\n",line_number,yytext);
				

}

\'[^\\]\'  |
\'\\{special}\' {
	indentation_verify();	
	 char ch ;
	 size_t yytext_length = strlen(yytext);
	
   if (yytext_length == 4) {
     ch = special_char(yytext[2]);
	 printf("%c",ch);
  
  } 
else {
    ch = yytext[1];
	printf("%c",ch);
  }
    
 

    fprintf(tokenout, "<CONST_CHAR, %c>\n", ch);
    fprintf(logout, "Line# %d: Token <CONST_CHAR> Lexeme %c found\n", line_number, ch);
 

}

({LETTER}|_)({LETTER}|_|{DIGIT})*  {
             indentation_verify();
            fprintf(tokenout,"<ID, %s>\n",yytext);
		    fprintf(logout,"Line# %d: Token <ID> Lexeme %s found\n",line_number,yytext);
			bool s= Table.InsertSymbol(yytext,"ID") ; 
			if(s)
             {Table. PrintAllScopeTable(logout);}
			else
			{
			 fprintf(logout,"\t%s already exists in the current ScopeTable\n",yytext);	
			}
			

}


\/\/ {
	 indentation_verify();
	BEGIN STATE_OF_SINGLE_COMMENT;
	lex=yytext;
	line=0;

}
<STATE_OF_SINGLE_COMMENT>\\\r\n {
	number_of_spaces=0;
	number_of_tabs=0;
	indent_level=0;
	lex+=yytext;
	line++;
	line_number++;
}
<STATE_OF_SINGLE_COMMENT>\r\n {
	number_of_spaces=0;
	number_of_tabs=0;
	indent_level=0;
	 fprintf(logout,"Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n",line_number-line,lex.c_str());
	 line_number++;
	 BEGIN INITIAL;
}
<STATE_OF_SINGLE_COMMENT>. {
	lex+=yytext;
}


\/\* {
	
	
	indentation_verify();
	lex.clear();
	line=0;
	lex+=yytext;
	line_number+=line;
	BEGIN STATE_OF_MULTI_COMMENT;
}
<STATE_OF_MULTI_COMMENT>\*\/ {
	lex+=yytext;
	fprintf(logout,"Line# %d: Token <MULTI LINE COMMENT> Lexeme %s found\n",line_number-line,lex.c_str());
    line=0;
	BEGIN INITIAL;

}

<STATE_OF_MULTI_COMMENT>{NEWLINE} {
	
	line++;
	lex+=yytext;
	line_number++;

}
<STATE_OF_MULTI_COMMENT>. {
	lex+=yytext;	
}

<STATE_OF_MULTI_COMMENT><<EOF>> {
     error_count++;
	fprintf(logout,"Error at line# %d: UNFINISHED_COMMENT %s\n",line_number,lex.c_str());
    line=0;
	BEGIN INITIAL;

}



 ([-+]?{DIGIT}*\.{DIGIT}*\.[-+0-9\.Ee]*)    {
    indentation_verify();
     error_count++;
	fprintf(logout,"Error at line# %d: TOO_MANY_DECIMAL_POINTS %s\n",line_number,yytext);
}
{DIGIT}({LETTER}|_|{DIGIT})*({LETTER}|_)({LETTER}|_|{DIGIT})*   {
	 indentation_verify();
     error_count++;
	fprintf(logout,"Error at line# %d: INVALID_ID_SUFFIX_NUM_PREFIX %s\n",line_number,yytext);
}
{DIGIT}*(\.{DIGIT}*)*[Ee][+-]?{DIGIT}*(\.{DIGIT}*)+ {
	    indentation_verify();
	    error_count++;
	    fprintf(logout,"Error at line# %d: ILLFORMED_NUMBER %s\n",line_number,yytext);
}



{MULTI_CHARACTER} {
	      indentation_verify();
         error_count++;
         fprintf(logout,"Error at line# %d: MULTICHAR_CONST_CHAR %s\n",line_number,yytext);
}

\'\'   {
        indentation_verify();

	    error_count++;
	    fprintf(logout,"Error at line# %d: EMPTY_CONST_CHAR %s\n",line_number,yytext);
}


\'(.|\\.|\\\')?  {
	    indentation_verify();
	    error_count++;
	    fprintf(logout,"Error at line# %d: UNFINISHED_CONST_CHAR %s\n",line_number,yytext);

}




\" { indentation_verify();
	logString="\"";BEGIN STATE_OF_STRING;}
<STATE_OF_STRING>\\{special} {
	string tem=yytext;
	logString+=tem;
} 
<STATE_OF_STRING>\\\r\n {
	logString+="\\\n";
	line_number++;
}
<STATE_OF_STRING>\" { 
    logString+="\""; 
    int newline_number = 0;
    for (int i = 0; i<logString.size(); i++) {
        if (logString[i] == '\n') {
            newline_number++;
        }
    }

    if (newline_number > 0) {
        fprintf(tokenout, "<MULTI LINE STRING, %s>\n", escapeString(logString).c_str());
        fprintf(logout, "Line# %d: Token <MULTI LINE STRING> Lexeme %s found\n", line_number - newline_number, logString.c_str());
    } else {
        fprintf(tokenout, "<SINGLE LINE STRING, %s>\n", escapeString(logString).c_str());
        fprintf(logout, "Line# %d: Token <SINGLE LINE STRING> Lexeme %s found\n", line_number, logString.c_str());
    }
    BEGIN INITIAL; 
} 
<STATE_OF_STRING>\r\n {
	number_of_spaces=0;
	number_of_tabs=0;
	indent_level=0; 
	error_count++;
	
	fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",line_number,logString.c_str());
    line_number++;
    BEGIN INITIAL; 

} 
<STATE_OF_STRING><<EOF>> { 
    error_count++;
	fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",line_number,logString.c_str());
   	BEGIN INITIAL; 
} 
<STATE_OF_STRING>. {
	string tem=yytext;
	logString+=tem;
}




. 	{    indentation_verify();
         error_count++;
	    fprintf(logout,"Error at line# %d: UNRECOGNIZED_CHAR %s\n",line_number,yytext);
		
}





<<EOF>> {
	 
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
	
	logout= fopen("2005109_log.txt","w");
	tokenout= fopen("2005109_token.txt","w");

	yyin= fin;
	yylex();
	fclose(yyin);
	Table.PrintAllScopeTable(logout);
    fprintf(logout,"Total lines: %d\n",line_number);
	fprintf(logout,"Total errors: %d\n",error_count);
	fprintf(logout,"Total warnings: %d\n",warning_count);

	fclose(tokenout);
	fclose(logout);
	return 0;
}
