#include<bits/stdc++.h> 
using namespace std;


enum node_type { n_headings, n_table, n_dlist, n_list, n_style, n_pos, n_hyper, n_para, n_div, n_br, n_fig, n_font_arg, n_title, n_body, n_head, n_html, n_start, n_text,     n_empty, n_break, n_table_arg };
	

typedef struct node{
	node_type t;
	string value;
        int k;
	vector<node*> child;
}node;


extern string str;
extern string traverse(node *);
extern void walk(node *);
extern node* new_n();
extern node* new_nwd(string);

