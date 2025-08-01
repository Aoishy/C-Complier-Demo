#include<bits/stdc++.h>
#include "2005109_ScopeTable.cpp"
using namespace std;



class SymbolTable
{
    ScopeTable* currentTable;
    int bucket_size;
public:
    SymbolTable(int n,ofstream &out)
    {
        bucket_size=n;
        currentTable=nullptr;
        EnterScope(out);

    }
    ~SymbolTable()
    {
        /* while(currentTable!=nullptr)
         {
             ScopeTable *temp=currentTable->getParentscope();
             delete currentTable;
             currentTable=temp;*/

    }







    void  EnterScope(ofstream &out)
    {
        ScopeTable *newscope=new ScopeTable(bucket_size);

        if(currentTable!=nullptr)
        {
            newscope->setParentScope(currentTable);
            currentTable=newscope;
            currentTable->getParentscope()->setScopeNumber();
            currentTable->setId();

            out<<"\t"<<"ScopeTable# "<<currentTable->getId()<<" created"<<endl;

        }
        else
        {
            currentTable=newscope;
            currentTable->setParentScope(nullptr);
            currentTable->setId(1);

            out<<"\t"<<"ScopeTable# "<<currentTable->getId()<<" created"<<endl;
        }

    }
    void ExitScope(ofstream &out)

    {
        if(currentTable==nullptr)
        {
            out<<"NO scope"<<endl;
            return;
        }

        else
        {

            if(currentTable->getId()==to_string(1))
            {
                out<<"\t"<<"ScopeTable# 1 cannot be deleted"<<endl;
                return;
            }
            else
            {

                ScopeTable *present=currentTable;
                currentTable=currentTable->getParentscope();
                out<<"\t"<<"ScopeTable# "<<present->getId()<<" deleted"<<endl;
                delete present;
            }


        }
    }
    void ExitAllScope(ofstream &out)

    {
        while (currentTable != nullptr)
        {
            ScopeTable* present = currentTable;
            currentTable = currentTable->getParentscope();

            out <<"\t"<<"ScopeTable# " << present->getId() << " deleted" << endl;
            delete present;
        }

    }


    bool InsertSymbol(string name,string type,ofstream &out)
    {

        if(currentTable->Insert(name,type,out))
            return true;

        else
            return false;
    }



    SymbolInfo* LookUpSymbol(string Name,ofstream &out)
    {

        ScopeTable *check = currentTable;
        SymbolInfo *temp;

        for(;check!=nullptr;check=check->getParentscope())
        {
            temp=check->LookUp(Name,out);

            if(temp != nullptr)
            {
                return temp;
            }
        }

        out << "\t'" << Name << "' not found in any of the ScopeTables" << endl;
        return nullptr;



    }

    bool RemoveSymbol(string name,ofstream &out)
    {

        if(currentTable->Delete(name,out))
            return true;

        else
            return false;
    }

    void PrintScopeTable(ofstream &out)
    {
        currentTable->Print(out);
    }
    void PrintAllScopeTable(ofstream &out)
    {
        for(ScopeTable *current=currentTable; current!=nullptr; current=current->getParentscope())
        {
            current->Print(out);
        }
    }


};



int main()
{


    ifstream in("input.txt",ios::in);
    ofstream out("output.txt",ios::out);
    string bucket;
    getline(in,bucket);
    int tem_bucket=stoi(bucket);
    SymbolTable current(tem_bucket,out);
    int cmdNumber = 1;

    while(!in.eof())
    {
        string command[20],str,s1;
        getline(in,str);
        istringstream strstream(str);
        int cnt=0;
        while(strstream>>s1)
        {
            command[cnt++]=s1 ;
        }


        out << "Cmd " << cmdNumber++ << ": ";

        if(command[0]=="D")
        {
            out<<command[0];
            for (int i = 1; i < cnt; ++i)
            {
                out <<" "<< command[i];
            }
            out << endl;
            if(cnt>2||cnt<2)
            {

                out<<"\t"<<"Wrong number of arugments for the command D"<<endl;
            }

            else
            {
                current.RemoveSymbol(command[1],out);
            }
        }
        else   if(command[0]=="I")

        {


            out<<command[0];
            for (int i = 1; i < cnt; ++i)
            {
                out <<" "<< command[i];
            }
            out << endl;
            if(cnt>3||cnt<3)
            {

                out<<"\t"<<"Wrong number of arugments for the command I"<<endl;
            }

            else
            {
                current.InsertSymbol(command[1],command[2],out);
            }
        }
        else if(command[0]=="L")
        {
            out<<command[0];
            for (int i = 1; i < cnt; ++i)
            {
                out <<" "<< command[i];
            }
            out << endl;
            if(cnt>2||cnt<2)
            {

                out<<"\t"<<"Wrong number of arugments for the command L"<<endl;
            }

            else
            {
                current.LookUpSymbol(command[1],out);
            }
        }
     else   if(command[0]=="S")
        {
            out<<command[0];
            for (int i = 1; i < cnt; ++i)
            {
                out <<" "<< command[i];
            }
            out << endl;
            if(cnt==1)
            {
                current.EnterScope(out);

            }
            else
            {
                out<<"\t"<<"Wrong number of arugments for the command S"<<endl;

            }

        }

        else if(command[0]== "E")
        {
            out<<command[0];
            for (int i = 1; i < cnt; ++i)
            {
                out <<" "<< command[i];
            }
            out << endl;
            if(cnt==1)
            {
                current.ExitScope(out);

            }
            else
            {
                out<<"\t"<<"Wrong number of arugments for the command E"<<endl;

            }


        }



        else if(command[0]=="P")
        {
            out<<command[0];
            for (int i = 1; i < cnt; ++i)
            {
                out <<" "<< command[i];
            }
            out << endl;
            if(cnt>2||cnt<2)
            {
                out<<"\t"<<"Wrong number of arugments for the command P"<<endl;

            }
            else
            {
                if(command[1]=="A")
                {
                    current.PrintAllScopeTable(out);
                }
                else if(command[1]=="C")
                {
                    current.PrintScopeTable(out);
                }
                else
                {
                    out<<"\t"<<"Invalid argument for the command P"<<endl;
                }
            }

        }


        else if(command[0]== "Q")
        {
            out<<command[0];
            for (int i = 1; i < cnt; ++i)
            {
                out <<" "<< command[i];
            }
            out << endl;
            if(cnt>1||cnt<1)
            {
                out<<"\t"<<"Wrong number of arugments for the command Q"<<endl;
            }
            else
            {
                current.ExitAllScope(out);
                out<<endl;
            }

        }


    }
    in.close();
    out.close();
}


