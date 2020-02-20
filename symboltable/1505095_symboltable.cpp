#include<bits/stdc++.h>
#include<iostream>
#include <cstdlib>
#include <ctime>
#include <vector>
#include <algorithm>
#include <cmath>

using namespace std;

#define CHAIN_LENGTH 7

struct symbol_info
{
public:
    int value;
    int key;
    string str;
    string namestr;
    struct symbol_info* next;
}*block_new[CHAIN_LENGTH];

struct hash_Map
{
    struct symbol_info* list[CHAIN_LENGTH];
public:
    hash_Map()
    {
        for(int i=0; i<CHAIN_LENGTH; i++)
        {
            list[i]= new symbol_info();
            list[i]->key=-1;
            list[i]->value=-1;
            list[i]->next=0;
        }
    }
    int id;
    struct hash_Map* next;
    struct hash_Map* parent;
    int count=0;
    int collision=0;
    ~hash_Map();
    void insert_item(string str,int key,int value,string namestr);
    struct symbol_info* search_item(string str,int select);
    void delete_item(string str,int select);
    int hash_function(string str);
    void print();
};

struct symbolTable
{
    bool insertCurrent(struct hash_Map* current,string str,int key,int value,string namestr);
    bool removeCurrent(struct hash_Map* current,string str,int select);
    struct hash_Map* enterScope(struct hash_Map* current);
    struct hash_Map* exitScope(struct hash_Map* root);
    struct symbol_info* lookUp(struct hash_Map* current,string str,int select);
    void printCurrent(struct hash_Map* current);
    void printAll(struct hash_Map* current);
};

struct hash_Map* symbolTable::enterScope(struct  hash_Map* current)
{
    struct hash_Map* temp=new hash_Map();
    temp->id=current->id+1;
    current->next=temp;
    temp->parent=current;
    temp->next=0;
    cout<<"New Scope table with id "<<temp->id<<" is created"<<endl;
    return temp;
}

struct hash_Map* symbolTable::exitScope(struct hash_Map* root)
{
    struct hash_Map* temp;
    struct hash_Map* root1;
    root1=root;
    temp=0;
    while(root1->next!=0)
    {
        temp=root1;
        root1=root1->next;
    }
    if(temp==0)
    {
        root=0;
        cout<<"Main ScopeTable is removed"<<endl;
    }
    else
    {
        cout<<"ScopeTable with id "<<root1->id<<" removed"<<endl;
        temp->next=0;
    }
    return temp;
}

bool symbolTable::insertCurrent(struct hash_Map* curr,string str,int key,int value,string namestr)
{
    curr->insert_item(str,key,value,namestr);
}

bool symbolTable::removeCurrent(struct hash_Map* curr,string str,int select)
{
    curr->delete_item(str,select);
}

struct symbol_info* symbolTable::lookUp(struct hash_Map* curr,string str,int select)
{
    while(curr!=0)
    {
        struct symbol_info* temp=curr->search_item(str,select);
        if(temp!=0)
            return temp;
        else
           {
             curr=curr->parent;
           }
           cout<<str<<" not found"<<endl;
    }
    return 0;
}

void symbolTable::printCurrent(struct hash_Map* curr)
{
    cout<<endl<<"ScopeTable# "<<curr->id<<endl<<endl;
    curr->print();
}

void symbolTable::printAll(struct hash_Map* curr)
{
    while(curr!=0)
    {
        cout<<endl<<"ScopeTable# "<<curr->id<<endl<<endl;
        curr->print();
        curr=curr->parent;
    }
}

int  hash_Map::hash_function(string str)
{
    int idx=0;
    for(int i=0; i<str.length(); i++)
    {
        idx=idx+str.at(i);
    }

    return (idx%CHAIN_LENGTH);
}

void hash_Map::insert_item(string str,int key,int value,string namestr)
{
    int key_real=key;
    struct symbol_info* p;
    struct symbol_info* prev;
    int y=0;
    if(list[key]->value==-1)
    {
        list[key]->next=0;
        list[key]->value=value;
        list[key]->str=str;
        list[key]->namestr=namestr;
        list[key]->key=key;
        cout<<endl<<"Inserted in ScopeTable# "<<id<<" at position "<<key<<", 0"<<endl;
        return;
    }
    collision++;
    p=list[key];
    while((p!=0))
    {
        prev=p;
        if(p->str==str)
        {
            cout<<endl;
            cout<<p->str<<" already exists in current ScopeTable"<<endl;
            return;
        }
        p=p->next;
        y++;
    }
    struct symbol_info* temp;
    temp=new symbol_info();
    temp->next=0;
    temp->str=str;
    temp->value=value;
    temp->namestr=namestr;
    temp->key=key;
    prev->next=temp;
    cout<<endl<<"Inserted in Scopetable# "<<id<<" at position  "<<key<<", "<<y<<endl;
    free(p);
    free(prev);
}

struct symbol_info*  hash_Map::search_item(string str,int select)
{
    int key;
    key=hash_function(str);
    int dummy=key;
    struct symbol_info* p;
    p=list[key];
    int y=0;
    while(p!=0)
    {
        if(p->str==str)

        {
            cout<<"Found in ScopeTable# "<<id<<" at position "<<key<<", "<<y<<endl;
            return p;
        }
        p=p->next;
        y++;
    }
    return 0;
}

void hash_Map::delete_item(string str,int select)
{
    struct symbol_info* temp=search_item(str,select);
    if(temp==0)
        cout<<str<<" Not Found"<<endl;
    else
    {
        int key;
        key=hash_function(str);

        int dummy=key;

        struct symbol_info* temp;
        struct symbol_info* prev;
        temp=list[dummy];
        int y=0;
        while (temp != 0)
        {
            if (temp->str == str) break ;
            prev = temp;
            temp = temp->next ;
            y++;
        }
        if (temp == 0)
            return ;
        if (temp == list[dummy])
        {
            list[dummy] = list[dummy]->next ;
            free(temp) ;
        }
        else
        {
            prev->next = temp->next ;
            free(temp);
        }
        cout<<"Deleted entry at "<<key<<", "<<y<<" from current ScopeTable"<<endl;
        return  ;
    }
}

void hash_Map::print()
{
    struct symbol_info* p;

    for(int i=0; i<CHAIN_LENGTH; i++)
    {
        p=list[i];
        cout<<i<<"-> ";
        while(p!=0&&p->str.length()!=0)
        {
            cout<<"<"<<p->str<<":"<<p->namestr<<"> ";
            p=p->next;
        }
        cout<<endl;
    }
}

hash_Map::~hash_Map()
{
    delete[] list;
}

int main()
{
    hash_Map* root=new hash_Map();
    symbolTable* table=new symbolTable();
    root->parent=0;
    root->next=0;
    root->id=1;
    struct hash_Map* curr;
    curr=root;

    ifstream filein;
    string line;
    filein.open ("input.txt");

    if ( filein.is_open ( ))
    {
        while ( getline( filein, line ))
        {
            vector < string > tab;
            stringstream strstrm ( line );
            cout<<endl;
            while ( getline (strstrm,line, ' '))
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
                cout<<tab[i]<<" ";
                i++;
            }

            if(tab[0].compare("I")==0)
            {
                int key=curr->hash_function(tab[1]);
                table->insertCurrent(curr,tab[1],key,curr->count,tab[2]);
            }
            cout<<endl;
            if(tab[0].compare("L")==0)
            {
                struct symbol_info* temp= table->lookUp(curr,tab[1],1);
            }
            if(tab[0].compare("D")==0)
            {
                table->removeCurrent(curr,tab[1],1);
            }
            if(tab[0].compare("P")==0&&tab[1].compare("A")==0&&tab.size()>1)
            {
                table->printAll(curr);
            }
            if(tab[0].compare("P")==0&&tab[1].compare("C")==0&&tab.size()>1)
            {
                table->printCurrent(curr);
            }
            if(tab[0].compare("S")==0)
            {
                curr=table->enterScope(curr);
            }
            if(tab[0].compare("E")==0)
            {
                curr= table->exitScope(root);
            }
        }
    }
    else
    {
         cout<<"file can not be openned"<<endl;
    }
    freopen("output.txt","w",stdout);
    return 0;
}

 // Omit the comma character
       /*     int pos = strlen(name) - 1;
            if( name[ pos ] == ',' )
            {
                name[ pos ] = '\0';
            }*/
