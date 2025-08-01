#include<bits/stdc++.h>
using namespace std;
#include "2005109_SymbolInfo.cpp"

class ScopeTable

{
    ScopeTable *parentScope;
    SymbolInfo **CurrentScopeTable;
    int total_buckets,scopenumber;
    string id;

public:
    ScopeTable(int bucket_size)
    {
        this->total_buckets=bucket_size;

        CurrentScopeTable=new SymbolInfo*[total_buckets];


        for(int i=0; i<total_buckets; i++)
        {
            CurrentScopeTable[i]=nullptr;

        }
        parentScope=nullptr;
        scopenumber=0;


    }
    ~ScopeTable()
    {
        for(int i=0; i<total_buckets; i++)

        {
           SymbolInfo* newscope=CurrentScopeTable[i];

           while(newscope!=nullptr)
            {


                SymbolInfo* temp=newscope;
                newscope=newscope->getNext();
                delete temp;

            }

        }
        if(total_buckets!=0)delete []CurrentScopeTable;

    }






  void setId(int id) {

    this->id=to_string(id);
  }


    string getId()
    {
       if(this->parentScope==nullptr)
        return to_string(1);

       return  this->id;
    }
    void setId()
    {
         this->id=parentScope->getId()+"."+to_string(parentScope->getScopeNumber());
    }
    void setParentScope( ScopeTable*  parent)
    {
        this->parentScope=parent;
    }
    ScopeTable *getParentscope()
    {
        return this->parentScope;
    }

    void setScopeNumber()
    {
        this->scopenumber++;
    }
    int  getScopeNumber()
    {
        return this->scopenumber;
    }
    int getbucketNo(string Name)
    {
        unsigned long long hashVAL=0;
        unsigned long long valc;
        for(char c: Name)
        {   valc=c;
            hashVAL=valc+(hashVAL<<6)+(hashVAL<<16)-hashVAL;
        }
        hashVAL= (hashVAL%total_buckets);
        return hashVAL;
    }



      bool Insert(string Name,string Type,ofstream &out)
    {


        int index=getbucketNo(Name);
         SymbolInfo*  newsymbol=new SymbolInfo(Name,Type);

        if(CurrentScopeTable[index]==nullptr)
        {
            CurrentScopeTable[index]=newsymbol;

            out<<"\t"<<"Inserted  at position <"<<index+1<<", 1> of ScopeTable# "<<getId()<<endl;
            return true;
        }

        SymbolInfo* current = CurrentScopeTable[index];
        SymbolInfo *prev=nullptr;
        int position=1;
        while(current!=nullptr)
        {
            if(Name==current->getName())
            {
                out<<"\t"<<"'"<<Name<<"' already exists in the current ScopeTable# "<<id<<endl;
                return false;
            }
            prev=current;
            current=current->getNext();
            position++;
        }
        prev->setNext(newsymbol);
        out<<"\t"<<"Inserted  at position <"<<index+1<<", "<<position<<"> of ScopeTable# "<<id<<endl;
        return true;
    }




     SymbolInfo* LookUp(string Name,ofstream &out)
    {
        int index=getbucketNo(Name);

        SymbolInfo* current=CurrentScopeTable[index];

        for(int i=0; current!=nullptr; current=current->getNext(),i++)
        {
            if(current->getName()==Name)
            {
                out<<"\t"<<"'"<<Name<<"' found at position <"<<index+1<<", "<<i+1<<"> of ScopeTable# "<<this->getId()<<endl;
                return current;
            }
        }
        return nullptr;





    }


     bool Delete(string Name,ofstream &out)
    {
        int position=1;
        int index=getbucketNo(Name);
        if(CurrentScopeTable[index]==nullptr)
        {
            out<<"\t"<<"Not found in the current ScopeTable# "<<id<<endl;
            return false;
        }

        SymbolInfo* current=CurrentScopeTable[index];
        if(Name==CurrentScopeTable[index]->getName())
        {

            if(CurrentScopeTable[index]->getNext()!=nullptr)
            {

                CurrentScopeTable[index]=CurrentScopeTable[index]->getNext();
            }
            else
            {
                CurrentScopeTable[index]=nullptr;
            }
            out<<"\t"<<"Deleted '"<<Name<<"' from position <"<<index+1<<", "<<position<<"> of ScopeTable# "<<id<<endl;

            return true;

        }

         SymbolInfo* next=CurrentScopeTable[index]->getNext();

        while(current->getNext()!=nullptr)
        {
            position++;
            if(Name==current->getNext()->getName())
            {
              current->setNext(next->getNext());
            out<<"\t"<<"Deleted '"<<Name<<"' from position <"<<index+1<<", "<<position<<"> of ScopeTable# "<<id<<endl;
                 return true;
            }
            current=next;
            next=next->getNext();
        }

         out<<"\t"<<"Not found in the current ScopeTable# "<<id<<endl;
            return false;


    }

    void Print(ofstream &out)
    {
        out<<"\t"<<"ScopeTable# "<<getId()<<endl;
        for(int i=0;i<total_buckets;i++)
        {
            SymbolInfo* temp=CurrentScopeTable[i];
            out<<"\t"<<i+1;
            while(temp!=nullptr)
            {
                out<<" --> ("<<temp->getName()<<","<<temp->getType()<<")";
                temp=temp->getNext();
            }
           out<<endl;
        }


    }

    };


