#include<bits/stdc++.h>
using namespace std;

class SymbolInfo
{
    string Name;
    string Type;
    SymbolInfo *nextObj;
public:

    SymbolInfo(string Name,string Type)
    {
       this->Name=Name;
       this->Type=Type;
       this->nextObj=nullptr;


    }
    ~SymbolInfo()
    {
    //    this->nextObj=nullptr;
    }
    void setName(string Name)
    {
        this->Name=Name;
    }
    void setType(string Type)
    {
        this->Type=Type;
    }
    string getName()
    {
        return this->Name;
    }
    string getType()
    {
        return this->Type;
    }
    void setNext(SymbolInfo *nextobj)
    {
        this->nextObj=nextobj;
    }
    SymbolInfo *getNext()
    {
        return this->nextObj;
    }
};
