#include "2005109.cpp"
#include<bits/stdc++.h>
using namespace std;






void PrintParseTree(FILE *parseout,SymbolInfo* root, string gape) 
{
	if(root==NULL)
	{
		return;
	}
	int endpoint=root->get_endpoint();
	if(endpoint==1)
	{
		fprintf(parseout,"%s%s	<Line: %d>\n",gape.c_str(),root->get_grammer_rule().c_str(),root->get_start_line());
	
	}
	else
	{fprintf(parseout,"%s%s	<Line: %d-%d>\n",gape.c_str(),root->get_grammer_rule().c_str(),root->get_start_line(),root->get_end_line());
	
	}
	vector<SymbolInfo*> node_list=root->get_node_list();
	for(int i = 0; i < node_list.size(); i++)
	{
		PrintParseTree(parseout,node_list[i], gape + " ");
	}
	

}