#include<bits/stdc++.h> 
using namespace std;
#include "ast.h"
string out="";
void walk(node * r)
{
 if(r->k==0)
 {
  for(int i=0;i<r->child.size();i++)
  {
  walk(r->child[i]);
  //cout<<endl;
  }
 }
  else
  {
   //cout<<r->value;
	out+=r->value;
 }
}

string traverse(node *r)
{
	walk(r);
	return out;
}

node* new_n() {
               node* a  = new node;
               return a;
              }

node* new_nwd(string data) {
                            node* a = new node;
                            a->k=1;
                            a-> value = data;
                            return a;                     
                           }
