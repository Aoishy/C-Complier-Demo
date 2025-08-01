#include<bits/stdc++.h>
using namespace std;









class SymbolInfo
{
    string Name;
    string Type;
    SymbolInfo *nextObj;
    string param_type;
  //  bool Array=false;
   
    int start_line;
    int end_line;
    int len=0;
    string variable_list;
    vector<string>parameter_list;
    vector<SymbolInfo *>node_list;
    string grammer_rule;
    string return_type;
    int function_defined;
    int endpoint;

  
    
public:

    SymbolInfo(string Name,string Type)
    {
       this->Name=Name;
       this->Type=Type;
       this->nextObj=nullptr;
       setflages();


    }

    void setflages()
    {
        this->len=0;
        this->start_line=1;
        this->end_line=1;
        this->return_type="";
        this->param_type="";
        this->function_defined=0;
        this->grammer_rule="";
        this->endpoint=0;

    }

    SymbolInfo(string Name,string Type,  int start_line, int end_line,string grammer_rule, int endpoint)
    {
        this->Name=Name;
        this->Type=Type;
        this->start_line=start_line;
        this->end_line=end_line;
        this->grammer_rule=grammer_rule;
        this->endpoint=endpoint;
    }
    SymbolInfo(string Name,string Type,  int start_line, int end_line,string grammer_rule)
    {
        this->Name=Name;
        this->Type=Type;
        this->start_line=start_line;
        this->end_line=end_line;
        this->grammer_rule=grammer_rule;
    }





 SymbolInfo(string Name,string Type, string param_type,string return_type,int function_defined)
    {
        this->Name=Name;
        this->Type=Type;
        this->param_type=param_type;
        this->return_type=return_type;
        this->function_defined=function_defined;
    }

SymbolInfo(string Name,string Type, string param_type)
    {
        this->Name=Name;
        this->Type=Type;
        this->param_type=param_type;
        
    }
     SymbolInfo(string Name,string Type, string param_type,string return_type)
    {
        this->Name=Name;
        this->Type=Type;
        this->param_type=param_type;
        this->return_type=return_type;
      
    }

//  SymbolInfo(string Name, string param_type,string return_type)
//     {
//         this->Name=Name;
       
//         this->param_type=param_type;
//          this->return_type=return_type;
        
//     }   
    // ~SymbolInfo()
    // {
    // //    this->nextObj=nullptr;
    // }
    void setName(string Name)
    {
        this->Name=Name;
    }
    void setType(string Type)
    {
        this->Type=Type;
    }
   
 void set_variable_list(string var)
 {
    variable_list=var;
 }
 string getvariablelist()
 {
    return variable_list;
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
    void set_parameter_list(vector<string>parameter_list)
    {
        this->parameter_list=parameter_list;
    }
    vector<string>get_parameter_list()
    {
        return parameter_list;
    }
    void set_param_type(string param_type)
    {
        this->param_type=param_type;
    }
    string get_param_type()
    {
        return this->param_type;
    }
    void set_length(int len)
    {
        this->len=len;
    }
    int get_length()
    {
        return this->len;
    }
    void set_funtion_defined(int function_defined)
    {
        this->function_defined=function_defined;
    }
    int get_function_defined()
    {
        return this->function_defined;
    }
    void set_return_type( string return_type)
    {
        this->return_type=return_type;
    }
    string get_return_type()
    {
        return this->return_type;
    }
    void set_start_line(int start_line)
    {
        this->start_line=start_line;
    }
    int get_start_line()
    {
        return this->start_line;
    }
    void set_end_line(int end_line)
    {
        this->end_line=end_line;
    }
    int get_end_line()
    {
        return this->end_line;
    }
    void set_node(SymbolInfo* node)
    {
        node_list.push_back(node);
    }
    vector<SymbolInfo*>get_node_list()
    {
             return node_list;
    }
    void set_endpoint(int endpoint)
    {
        this->endpoint=endpoint;
    }
    int get_endpoint()
    {
        return this->endpoint;
    }
    void set_grammer_rule(string grammer_rule)
    {
        this->grammer_rule=grammer_rule;
    }
    string get_grammer_rule()
    {
        return this->grammer_rule;
    }



};




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
          //  if(CurrentScopeTable[i]!=nullptr)delete CurrentScopeTable[i];
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
    {    int a=stoi(parentScope->getId())+parentScope->getScopeNumber();
          this->id=to_string(a);
        // this->id=parentScope->getId()+"."+to_string(parentScope->getScopeNumber());
        
    
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



      bool Insert(string Name,string Type)
    {


        int index=getbucketNo(Name);
         SymbolInfo*  newsymbol=new SymbolInfo(Name,Type);

        if(CurrentScopeTable[index]==nullptr)
        {
            CurrentScopeTable[index]=newsymbol;

            cout<<"\t"<<"Inserted  at position <"<<index+1<<", 1> of ScopeTable# "<<getId()<<endl;
            return true;
        }

        SymbolInfo* current = CurrentScopeTable[index];
        SymbolInfo *prev=nullptr;
        int position=1;
        while(current!=nullptr)
        {
            if(Name==current->getName())
            {
                cout<<"\t"<<"'"<<Name<<"' already exists in the current ScopeTable# "<<id<<endl;
                return false;
            }
            prev=current;
            current=current->getNext();
            position++;
        }
        prev->setNext(newsymbol);
        cout<<"\t"<<"Inserted  at position <"<<index+1<<", "<<position<<"> of ScopeTable# "<<id<<endl;
        return true;
    }




     SymbolInfo* LookUp(string Name)
    {
        int index=getbucketNo(Name);

        SymbolInfo* current=CurrentScopeTable[index];

        for(int i=0; current!=nullptr; current=current->getNext(),i++)
        {
            if(current->getName()==Name)
            {
                cout<<"\t"<<"'"<<Name<<"' found at position <"<<index+1<<", "<<i+1<<"> of ScopeTable# "<<this->getId()<<endl;
                return current;
            }
        }
        return nullptr;





    }

    bool Insert2(SymbolInfo* tem) 
    { 
        string Name=tem->getName(); 
        string Type=tem->getType(); 
 
 
        int index=getbucketNo(Name); 
         //SymbolInfo*  newsymbol=new SymbolInfo(Name,Type);   // no new 
        SymbolInfo*  newsymbol=tem; 
 
        if(CurrentScopeTable[index]==nullptr) 
        { 
            CurrentScopeTable[index]=newsymbol; 
 
            cout<<"\t"<<"Inserted  at position <"<<index+1<<", 1> of ScopeTable# "<<getId()<<endl; 
            return true; 
        } 
 
        SymbolInfo* current = CurrentScopeTable[index]; 
        SymbolInfo *prev=nullptr; 
        int position=1; 
        while(current!=nullptr) 
        { 
            if(Name==current->getName()) 
            { 
                cout<<"\t"<<"'"<<Name<<"' already exists in the current ScopeTable# "<<id<<endl; 
                return false; 
            } 
            prev=current; 
            current=current->getNext(); 
            position++; 
        } 
        prev->setNext(newsymbol); 
        cout<<"\t"<<"Inserted  at position <"<<index+1<<", "<<position<<"> of ScopeTable# "<<id<<endl; 
        return true; 
    } 
 


     bool Delete(string Name)
    {
        int position=1;
        int index=getbucketNo(Name);
        if(CurrentScopeTable[index]==nullptr)
        {
            cout<<"\t"<<"Not found in the current ScopeTable# "<<id<<endl;
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
            cout<<"\t"<<"Deleted '"<<Name<<"' from position <"<<index+1<<", "<<position<<"> of ScopeTable# "<<id<<endl;

            return true;

        }

         SymbolInfo* next=CurrentScopeTable[index]->getNext();

        while(current->getNext()!=nullptr)
        {
            position++;
            if(Name==current->getNext()->getName())
            {
              current->setNext(next->getNext());
            cout<<"\t"<<"Deleted '"<<Name<<"' from position <"<<index+1<<", "<<position<<"> of ScopeTable# "<<id<<endl;
                 return true;
            }
            current=next;
            next=next->getNext();
        }

         cout<<"\t"<<"Not found in the current ScopeTable# "<<id<<endl;
            return false;


    }

    void Print(FILE*  logout)
    {
       // cout<<"\t"<<"ScopeTable# "<<getId()<<endl;
        fprintf(logout,"\tScopeTable# %s\n",getId().c_str());
        for(int i=0;i<total_buckets;i++)
        {
            SymbolInfo* temp=CurrentScopeTable[i];
          // cout<<"\t"<<i+1;
           if(temp==nullptr)
            {
                continue;
            }
           fprintf(logout,"\t%d",i+1);

            while(temp!=nullptr)
            {
              //  cout<<" --> ("<<temp->getName()<<","<<temp->getType()<<")";
                 fprintf(logout," --> (%s,%s)",temp->getName().c_str(),temp->getType().c_str());
                temp=temp->getNext();
            }
          // cout<<endl;
           fprintf(logout,"\n");
        }


    }



    };





class SymbolTable
{ ScopeTable* currentTable;
int bucket_size;
public:
    SymbolTable(int n)
    {    bucket_size=n;
         currentTable=nullptr;
         EnterScope();

    }
    ~SymbolTable()
    {
       

    }







    void  EnterScope()
    {
       ScopeTable *newscope=new ScopeTable(bucket_size);



    
           if(currentTable!=nullptr)
           {
               newscope->setParentScope(currentTable);
               currentTable=newscope;
               currentTable->getParentscope()->setScopeNumber();
               currentTable->setId();

              cout<<"\t"<<"ScopeTable# "<<currentTable->getId()<<endl;

           }
           else
           {
              currentTable=newscope;
              currentTable->setParentScope(nullptr);
              currentTable->setId(1);

               cout<<"\t"<<"ScopeTable# "<<currentTable->getId()<<" created"<<endl;
            
           }






    }
     void ExitScope()

    {  if(currentTable==nullptr)
       {
           cout<<"NO scope"<<endl;
           return;
       }
      /* else if(currentTable->getId()==to_string(1))
       {
           out<<"\t"<<"ScopeTable# 1 cannot be deleted"<<endl;
           return;
       }


        ScopeTable *present=currentTable;
        currentTable=currentTable->getParentscope();
       out<<"\t"<<"ScopeTable# "<<present->getId()<<" deleted"<<endl;
       delete present;*/
       else
      {

        if(currentTable->getId()==to_string(1))
        {
            cout<<"\t"<<"ScopeTable# 1 cannot be deleted"<<endl;
            return;
        }
        else
        {

          ScopeTable *present=currentTable;
          currentTable=currentTable->getParentscope();
          cout<<"\t"<<"ScopeTable# "<<present->getId()<<" deleted"<<endl;
          delete present;
       }


      }
    }
      void ExitAllScope()

    {
       while (currentTable != nullptr) {
        ScopeTable* present = currentTable;
        currentTable = currentTable->getParentscope();

        cout <<"\t"<<"ScopeTable# " << present->getId() << " deleted" << endl;
        delete present;
    }

    }


     bool InsertSymbol(string name,string type)
    {

        if(currentTable->Insert(name,type))
            return true;

        else
            return false;
    }
bool InsertSymbol2(SymbolInfo* tem)    
    { 
 
        if(currentTable->Insert2(tem)) 
            return true; 
 
        else 
            return false; 
    } 
 


    SymbolInfo* LookUpSymbol(string Name)
    {
       /* ScopeTable *check= currentTable;

        SymbolInfo *temp;
        while(check!=nullptr)
        {
           temp=check->LookUp(Name,out);

            if(temp!=nullptr)
            {
                return temp;
            }
            check=check->getParentscope();
        }


        out<<"\t"<<"'"<<Name<<"' not found in any of the ScopeTables"<<endl;
        return nullptr;*/

        ScopeTable *check = currentTable;
    SymbolInfo *temp;

    for (; check != nullptr; check = check->getParentscope()) {
        temp = check->LookUp(Name);

        if (temp != nullptr) {
            return temp;
        }
    }

   // cout << "\t'" << Name << "' not found in any of the ScopeTables" << endl;
    return nullptr;



    }

      bool RemoveSymbol(string name)
    {

             if(currentTable->Delete(name))
                 return true;

        else
            return false;
    }

     void PrintScopeTable(FILE *out)
    {
        currentTable->Print(out);
    }
    void PrintAllScopeTable(FILE* out)
    {
        for(ScopeTable *current=currentTable;current!=nullptr;current=current->getParentscope())
        {
            current->Print(out);
        }
    }





};









/*int main()
{


    ifstream in("input.txt",ios::in);
    ofstream out("output.txt",ios::out);
    string bucket;
    getline(in,bucket);
    int tem_bucket=stoi(bucket);
    SymbolTable current(tem_bucket,out);
     int cmdNumber = 1;

    while(!in.eof())
    {   string command[20],str,s1;
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
             for (int i = 1; i < cnt; ++i) {
                out <<" "<< command[i];
                        }
                out << endl;
            if(cnt>2||cnt<2)
            {

                out<<"\t"<<"Wrong number of arugments for the command D"<<endl;
            }

           else{ current.RemoveSymbol(command[1],out);}
        }
     else   if(command[0]=="I")

        {


            out<<command[0];
             for (int i = 1; i < cnt; ++i) {
                out <<" "<< command[i];
                        }
                out << endl;
            if(cnt>3||cnt<3)
            {

                out<<"\t"<<"Wrong number of arugments for the command I"<<endl;
            }

          else { current.InsertSymbol(command[1],command[2],out);}
        }
       else if(command[0]=="L")
        {
             out<<command[0];
             for (int i = 1; i < cnt; ++i) {
                out <<" "<< command[i];
                        }
                out << endl;
            if(cnt>2||cnt<2)
            {

                out<<"\t"<<"Wrong number of arugments for the command L"<<endl;
            }

           else
           {current.LookUpSymbol(command[1],out);
        }
        }
        if(command[0]=="S")
        {
             out<<command[0];
             for (int i = 1; i < cnt; ++i) {
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

        else if(command[0]== "E"){
             out<<command[0];
             for (int i = 1; i < cnt; ++i) {
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
        {  out<<command[0];
             for (int i = 1; i < cnt; ++i) {
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
                else{
                    out<<"\t"<<"Invalid argument for the command P"<<endl;
                }
            }

        }


         else if(command[0]== "Q"){
              out<<command[0];
             for (int i = 1; i < cnt; ++i) {
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
}*/


