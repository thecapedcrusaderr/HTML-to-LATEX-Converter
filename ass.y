%{

#include<bits/stdc++.h> 
#include <string.h>
#include"ast.h"
using namespace std;

void yyerror(char *);
int yylex(void);

FILE *out;
extern FILE *yyin;

string font_size = "7";
string border_size = "";
string h_image = "";
string w_image = "";
string src_image = "";
string href ="";
string hname ="";
int h = 0;
int w = 0;
int s = 0;
int hr = 0;
int hn = 0;
int nrow = 0;
int tcells = 0;
string str="";
//void walk(node *);

%}

/* To add for center */

%union
{
 char* s;
 struct node* ptr; 
}

%start START

%type <ptr> a
%token <s>   START_HTML       END_HTML            TEXT              START_TITLE    END_TITLE      START_HEAD    END_HEAD
%token <s>   START_BODY       END_BODY            START_COMMENT     END_COMMENT
%token <s>   START_HYPERLINK  END_HYPERLINK       START_FONT        END_FONT       BREAK          
%token <s>   START_PARA       END_PARA            START_DIVISION    END_DIVISION   START_T        END_T
%token <s>   START_H1         END_H1              START_H2          END_H2         START_H3       END_H3        START_H4     END_H4 
%token <s>   START_ULIST      END_ULIST           START_DDATA       END_DDATA      START_CENTER   END_CENTER 
%token <s>   START_LITEM      END_LITEM           START_OLIST       END_OLIST
%token <s>   START_DLIST      END_DLIST           START_DTERM       END_DTERM      START_SUP      END_SUP       START_SUB    END_SUB
%token <s>   START_UNDER      END_UNDER           START_BOLD        END_BOLD       START_ITALIC   END_ITALIC    START_TTYPE  END_TTYPE
%token <s>   START_ENUM       END_ENUM            START_STRONG      END_STRONG     START_SMALL    END_SMALL
%token <s>   START_T_CAP      END_T_CAP           START_T_HEAD      END_T_HEAD     START_T_DATA   END_T_DATA    START_T_ROW  END_T_ROW    
%token <s>   IMAGE            START_FIG           END_FIG            
%token <s>   START_FIG_CAP    END_FIG_CAP         ANCHOR_EQUAL      ANCHD_ARGH_TEXT  ANCHD_ARGN_TEXT            ANCHS_ARGH_TEXT   ANCHS_ARGN_TEXT
%token <s>   HREF             SIZE                SRC               WIDTH          HEIGHT         NAME          ATR_TITLE    ARG_TEXT    ARG_C 
%token <s>   IMG_WIDTH        ARG_IMG             ARG_INT           ARG_BORDER     ARG_BORDSIZE   IMG_SRC       IMG_HEIGHT   ARG_SIZE
%token <s>   FONT_CLOSE       TABLE_CLOSE         IMG_CLOSE         ANCHOR_CLOSE   FONT_EQUAL     FONT_DARG_INT              FONT_SARG_INT
%token <s>   BORDER_EQUAL     DOBARG_BORDSIZE     SINARG_BORDSIZE   IMG_EQUAL      DARG_IMGH  DARG_IMGS DARG_IMGW       SARG_IMGH 
%token <s>   SARG_IMGW        SARG_IMGS           IMG_FSLH

%type <ptr> b START  c content header style list u1 d1 d2  para div table tab1 tab2 ti  fig figd img anchor break t2 a1 f1 img1 pos

%%

START : START_HTML a END_HTML { 
                                //fprintf(out,"%s \n %s \n %s",$1,$2,$3);
                                node* start = new_n();
                                start->k=0;
                                start->t = n_start;
                                start->child.push_back(new_nwd($1));
                                start->child.push_back(new_nwd("\\usepackage{graphicx}"));
                                start->child.push_back(new_nwd("\\usepackage{hyperref}"));
                                start->child.push_back($2);
                                //start->child.push_back(new_nwd($3));
                                $$=start;
                                 
                                str+=traverse($$);
				
                              }

a : START_HEAD b END_HEAD c   { 
                               
                                node* start = new_n();
                                start->k=0;
                                start->t = n_head;
                                //start->child.push_back(new_nwd($1));
                                start->child.push_back($2);
                                //start->child.push_back(new_nwd($3));
                                start->child.push_back($4);
                                $$=start;             
                              }
  | {}

b : START_TITLE content END_TITLE { 
                                    node* start = new_n();
                                    start->t = n_title;
                                    start->k=0;
                                    start->child.push_back(new_nwd($1));
                                    start->child.push_back($2);
                                    start->child.push_back(new_nwd($3));
                                    $$=start;                                                                                     
                                  }
  | {}

c : START_BODY content END_BODY {
				  node* start = new_n();
                                  start->t = n_body;
                                  start->k=0;
                                  start->child.push_back(new_nwd($1));
                                  start->child.push_back(new_nwd("\\maketitle"));
                                  start->child.push_back($2);
                                  start->child.push_back(new_nwd($3));
                                  $$=start;
                                }
 content :  header content { 
                              node* start = new_n();
                              start->t = n_headings; 
                              start->k=0;
                              start->child.push_back($1);
                              start->child.push_back($2);
                              $$=start;	
                           }
        |  para content { 
                              node* start = new_n();
                              start->t = n_para; 
                              start->k=0;
                              start->child.push_back($1);
                              start->child.push_back($2);
                              $$=start;	 
                        } 
        | div content {
                        node* start = new_n();
                        start->t = n_div; 
                        start->k=0;
                        start->child.push_back($1);
                        start->child.push_back($2);
                        $$=start;	  
                      } 
        | table content {
                         node* start = new_n();
                         start->t = n_table; 
                         start->k=0;
                         start->child.push_back($1);
                         start->child.push_back($2);
                         $$=start;  
                        } 
        | list content  {
                         node* start = new_n();
                        start->t = n_list; 
                        start->k=0;
                        start->child.push_back($1);
                        start->child.push_back($2);
                        $$=start;                 
                        } 
        | fig content  {
                         node* start = new_n();
                        start->t = n_fig; 
                        start->k=0;
                        start->child.push_back($1);
                        start->child.push_back($2);
                        $$=start; 
                       }

        | anchor content {
                          node* start = new_n();
                          start->t = n_hyper; 
                          start->k=0;
                          start->child.push_back($1);
                          start->child.push_back($2);
                          $$=start;
                         }
        
        | break content {
                          node* start = new_n();
                          start->t = n_break; 
                          start->k=0;
                          start->child.push_back($1);
                          start->child.push_back($2);
                          $$=start;
                        }

        | pos content { 
                        node* start = new_n();
                        start->t = n_pos; 
                        start->k=0;
                        start->child.push_back($1);
                        start->child.push_back($2);
                        $$=start;               
                      } 

                         
        | style content { 
                         node* start = new_n();
                         start->t = n_style; 
                         start->k=0;
                         start->child.push_back($1);
                         start->child.push_back($2);
                         $$=start;	
                        } 
    
        | { 
           node* start = new_n();
           start->k=1;
           start->k=n_empty;
           start->value = "";
           $$ = start;
          }

 pos : START_CENTER content END_CENTER {
                                        node* start = new_n();
                                        start->t = n_pos; 
                                        start->k=0;
                                        start->child.push_back(new_nwd($1));
                                        start->child.push_back($2);
                                        start->child.push_back(new_nwd($3));
                                        $$=start;
                                      } 


break : BREAK {
                 node* start = new_n();
                 start->t = n_break; 
                 start->k=1;
                 start->value = $1;
                 $$ = start;            
              }

anchor : START_HYPERLINK a1 content END_HYPERLINK {
                                                   node* start = new_n();
                                                   start->t = n_hyper; 
                                                   start->k=0;
                                                   //start->child.push_back(new_nwd($1));
                                                   //start->child.push_back($2)
                                                   if(hn==2)
                                                   {
                                                     start->child.push_back(new_nwd("\\label{"));
                                                     start->child.push_back(new_nwd(hname));
                                                     start->child.push_back(new_nwd("} "));
                                                   }
                                                   if(hr==2)
                                                   { start->child.push_back(new_nwd("\\href{"));
                                                     start->child.push_back(new_nwd(href));
                                                     start->child.push_back(new_nwd("}{"));
                                                   }
                                                   start->child.push_back($3);
                                                   if(hr==2)
                                                   {
                                                   start->child.push_back(new_nwd($4));
                                                   }
                                                   $$=start;
                                                 }
a1 : HREF a1      {
                         node* start = new_n();
                         start->t = n_hyper; 
                         start->k=0;
                         start->child.push_back(new_nwd($1));
                         start->child.push_back($2);
                         $$=start;
                     
                  }

   | NAME a1      {
                     node* start = new_n();
                     start->t = n_hyper; 
                     start->k=0;
                     start->child.push_back(new_nwd($1));
                     start->child.push_back($2);
                     $$=start; 
                  }

   | ATR_TITLE a1 {
                     node* start = new_n();
                     start->t = n_hyper; 
                     start->k=0;
                    // start->child.push_back(new_nwd($1));
                     start->child.push_back($2);
                     $$=start;
                   }

   | ANCHOR_EQUAL a1 {
                       node* start = new_n();
                       start->t = n_hyper; 
                       start->k=0;
                       //start->child.push_back(new_nwd($1));
                       start->child.push_back($2);
                       $$=start; 
                     }

   | ANCHD_ARGH_TEXT a1 {
                        href=string($1); 
                        hr = 2;
                        node* start = new_n();
                        start->t = n_hyper; 
                        start->k=0;
                        start->child.push_back(new_nwd($1));
                        start->child.push_back($2);
                        $$=start;
                       }
   | ANCHD_ARGN_TEXT a1 {                      
                        hname=string($1);
                         hn = 2;
                        node* start = new_n();
                        start->t = n_hyper; 
                        start->k=0;
                        start->child.push_back(new_nwd($1));
                        start->child.push_back($2);
                        $$=start;
                       }

   | ANCHS_ARGH_TEXT a1 {                      
                        href = string($1);
                        hr = 2;
                        node* start = new_n();
                        start->t = n_hyper; 
                        start->k=0;
                        start->child.push_back(new_nwd($1));
                        start->child.push_back($2);
                        $$=start; 
                       }

   |  ANCHS_ARGN_TEXT a1 { 
                           hn = 2;
                           hname= string($1);
                           node* start = new_n();
                           start->t = n_hyper; 
                           start->k=0;
                           start->child.push_back(new_nwd($1));
                           start->child.push_back($2);
                           $$=start; 
                          }
 
   | ANCHOR_CLOSE {
                    node* start = new_n();
                    start->t = n_hyper; 
                    start->k=1;
                    start->value = $1;
                    $$ = start; 
                  }


fig : START_FIG figd END_FIG { 
                               
                               node* start = new_n();
                               start->t = n_fig; 
                               start->k=0;
                               start->child.push_back(new_nwd($1));
                               start->child.push_back($2);
                               start->child.push_back(new_nwd($3));
                               $$=start;
                             }

    | img {

            node* start = new_n();
            start->t = n_fig; 
            start->k=0;
            start->child.push_back(new_nwd("\\includegraphics"));
            $$=start;
            if(h==2 && w==2)
            {
               start->child.push_back(new_nwd("[height= "+h_image+"px,"));
               start->child.push_back(new_nwd(" width= "+w_image+"px]"));
               start->child.push_back(new_nwd("{"+src_image+"}"));          
            }
            else if((h==2) && (w!=2))
            {
               start->child.push_back(new_nwd("[height= "+h_image+"px]"));
               start->child.push_back(new_nwd("{"+src_image+"}")); 
            } 
            else if((h!=2) && (w==2))
            {
              start->child.push_back(new_nwd("[width= "+w_image+"px]"));
              start->child.push_back(new_nwd("{"+src_image+"}"));
            }
            else {start->child.push_back(new_nwd("{"+src_image+"}")); } 
            $$=start;          
          }

figd : img START_FIG_CAP content END_FIG_CAP {
                                                node* start = new_n();
                                                start->t = n_fig; 
                                                start->k=0;
                                                
                                                start->child.push_back(new_nwd("\\includegraphics"));
                                         
                                                if(h==2 && w==2)
            					{
               					start->child.push_back(new_nwd("[height= "+h_image+"px,"));
               					start->child.push_back(new_nwd(" width= "+w_image+"px]"));
               					start->child.push_back(new_nwd("{"+src_image+"}"));          
            					}
            					else if((h==2) && (w!=2))
            					{
               					start->child.push_back(new_nwd("[height= "+h_image+"px]"));
               					start->child.push_back(new_nwd("{"+src_image+"}")); 
            					} 
            					else if((h!=2) && (w==2))
            					{
              					start->child.push_back(new_nwd("[width= "+w_image+"px]"));
              					start->child.push_back(new_nwd("{"+src_image+"}"));
            					}
            					else {start->child.push_back(new_nwd("{"+src_image+"}")); }                                                 


                                                start->child.push_back(new_nwd($2));
                                                start->child.push_back($3);
                                                start->child.push_back(new_nwd($4));
                                                $$=start;                                             
                                             } 

img : IMAGE img1 { cout<<" image first";
                   node* start = new_n();
                   start->t = n_fig; 
                   start->k=0;
                   start->child.push_back(new_nwd($1));
                   start->child.push_back($2);
                   $$=start;  
                 }  

img1 : IMG_SRC img1 {                     

                     
                     node* start = new_n();
                     start->t = n_fig; 
                     start->k=0;
                     start->child.push_back(new_nwd($1));
                     start->child.push_back($2);
                     $$=start;  	 
                   }

     | IMG_HEIGHT img1  {
                         
                      
                          node* start = new_n();
                         start->t = n_fig; 
                         start->k=0;
                         start->child.push_back(new_nwd($1));
                         start->child.push_back($2);
                         $$=start; 
                         
                        }

     | IMG_WIDTH img1  {
                         
                         node* start = new_n();
                        start->t = n_fig; 
                        start->k=0;
                        start->child.push_back(new_nwd($1));
                        start->child.push_back($2);
                        $$=start;  
                      }

     | IMG_EQUAL img1  {
                        //cout<<"equals";
                        node* start = new_n();
                        start->t = n_fig; 
                        start->k=0;
                        start->child.push_back(new_nwd($1));
                        start->child.push_back($2);
                        $$=start; 
                      }

     | DARG_IMGH img1 {                  
                        h_image = string($1);
                        h = 2;
                        cout<<"height";
                      }
     | DARG_IMGS img1 {                  
                        src_image = string($1);
                        s = 2;
                        cout<<"src";
                      }
     | DARG_IMGW img1 {
                         w_image = string($1);
                         w = 2;
                         cout<<"width";
                      }
     | SARG_IMGH img1 {                  
                        h_image = string($1);
                        h = 2;
                      }
     | SARG_IMGS img1 {                  
                        src_image = string($1);
                        s = 2;
                      }
     | SARG_IMGW img1 {
                         w_image = string($1);
                         w = 2;
                      }
     

     | IMG_FSLH img1 {
		       node* start = new_n();
                       start->t = n_fig; 
                       start->k=0;
                       start->child.push_back(new_nwd($1));
                       start->child.push_back($2);
                       $$=start; 				
                     }

     | IMG_CLOSE   {
                    node* start = new_n();
                    start->t = n_fig; 
                    start->k=1;
                    start->value = $1;
                    $$ = start; 
                   }


table : START_T t2 tab1 END_T {
                                 node* start = new_n();
                                 start->t = n_hyper; 
                                 start->k=0;
                                 
                                 int c = tcells/nrow;
                                 if(border_size=="1")
                                 {
                                 start->child.push_back(new_nwd("\\begin{tabular}{ |"));
                                 for(int i=0; i<c ; i++)
                                 start->child.push_back(new_nwd("c|"));
                    
                                 start->child.push_back(new_nwd(" }"));
                                 start->child.push_back(new_nwd("\\hline"));
                                 
                                 }
                                 else 
                                 {
                                  
                                 start->child.push_back(new_nwd("\\begin{tabular}{ "));

                                 for(int i=0; i<c ; i++)
                                 start->child.push_back(new_nwd("c "));
                    
                                 start->child.push_back(new_nwd("}"));
                                 }

                                 
                                 
                                 //start->child.push_back(new_nwd($1));
                                 //start->child.push_back($2);
                                 start->child.push_back($3);
                                 start->child.push_back(new_nwd($4));
                                 start->child.push_back(new_nwd("\\\\"));
                                 $$=start;
                                
                              }

tab1 : START_T_CAP content END_T_CAP tab2 {
                                             node* start = new_n();
                                             start->t = n_table; 
                                             start->k=0;
                                             //start->child.push_back(new_nwd($1));
                                             start->child.push_back($2);
                                             //start->child.push_back(new_nwd($3));
                                             start->child.push_back($4);
                                             $$=start;                                                  
                                          } 
     |  tab2 { 
               node* start = new_n();
               start->t = n_table; 
               start->k=0;
               start->child.push_back($1);
               $$=start;
             }

t2 : ARG_BORDER t2 {
                      /* node* start = new_n();
                      start->t = n_table_arg; 
                      start->k=0;
                      start->child.push_back(new_nwd($1));
                      start->child.push_back($2);
                      $$=start; */
                   }

   | BORDER_EQUAL t2 {
                      /* node* start = new_n();
                      start->t = n_table_arg; 
                      start->k=0;
                      start->child.push_back(new_nwd($1));
                      start->child.push_back($2);
                      $$=start; */
                     }

   | DOBARG_BORDSIZE t2  {
                          /* node* start = new_n();
                          start->t = n_table_arg; 
                          start->k=0;
                          start->child.push_back(new_nwd($1));
                          start->child.push_back($2);
                          $$=start; */
                          border_size=string($1); 
                         }

   | SINARG_BORDSIZE t2  {
                          /* node* start = new_n();
                          start->t = n_table_arg; 
                          start->k=0;
                          start->child.push_back(new_nwd($1));
                          start->child.push_back($2);
                          $$=start; */
                          border_size=string($1); 
                         }


   | TABLE_CLOSE  { 
                    /* node* start = new_n();
                     start->t = n_table_arg; 
                     start->k=1;
                     start->value = $1;
                     $$=start; */		     
                  }



tab2 : START_T_ROW ti END_T_ROW tab2 {
                                       nrow++;
                                       node* start = new_n();
                                       start->t = n_table; 
                                       start->k=0;
                                       //start->child.push_back(new_nwd($1));
                                       start->child.push_back($2);
                                       //start->child.push_back(new_nwd($3));
                                       
                                       start->child.push_back(new_nwd("\\\\"));
                                       if(border_size=="1")
                                       { 
                                        start->child.push_back(new_nwd("\\hline"));
                                        // start->child.push_back(new_nwd("\\\\"));
                                       }
                                       start->child.push_back($4);
                                       $$=start;
                                         
                                     }
     | { 
           node* start = new_n();
           start->k=1;
           start->k=n_empty;
           start->value = "";
           $$ = start;
       }

ti : START_T_HEAD content END_T_HEAD ti {
                                          tcells++;
                                          node* start = new_n();
                                          start->t = n_table; 
                                          start->k=0;
                                          //start->child.push_back(new_nwd($1));
                                          start->child.push_back($2);
                                          //start->child.push_back(new_nwd($3));
                                          if($4->t != n_empty)
                                          start->child.push_back(new_nwd(" & "));
                                          start->child.push_back($4);
                                          start->child.push_back(new_nwd("\\\\"));
                                          $$=start;                                         
                                        }
   | START_T_DATA content END_T_DATA ti { tcells++;
  			            	  node* start = new_n();
                                          start->t = n_table; 
                                          start->k=0;
                                          //start->child.push_back(new_nwd($1));
                                          start->child.push_back($2);
                                          //start->child.push_back(new_nwd($3));
                                          if($4->t != n_empty)
                                          start->child.push_back(new_nwd(" & "));
                                          start->child.push_back($4);
                                          $$=start;   
                                        }
   | { 
           node* start = new_n();
           start->k=1;
           start->t=n_empty;
           start->value = "";
           $$ = start; 
     }



div : START_DIVISION content END_DIVISION {
                                             node* start = new_n();
                                             start->t = n_div; 
                                             start->k=0;
                                             start->child.push_back(new_nwd($1));
                                             start->child.push_back($2);
                                             start->child.push_back(new_nwd(" "));
                                             $$=start;                                          
                                          }


para : START_PARA content END_PARA { 
                                    node* start = new_n();
                                    start->t = n_para; 
                                    start->k=0;
                                    start->child.push_back(new_nwd($1));
                                    start->child.push_back($2);
                                    start->child.push_back(new_nwd(" "));
                                    //start->child.push_back(new_nwd($3));
                                    $$=start;
                                   }  


 header : START_H1 content END_H1 {
 				     node* start = new_n();
                                     start->t = n_headings; 
                                     start->k=0;
                                     start->child.push_back(new_nwd($1));
                                     start->child.push_back($2);
                                     start->child.push_back(new_nwd($3));
                                     $$=start;
                                  }
      | START_H2 content END_H2  {
				     node* start = new_n();
                                     start->t = n_headings; 
                                     start->k=0;
                                     start->child.push_back(new_nwd($1));
                                     start->child.push_back($2);
                                     start->child.push_back(new_nwd($3));
                                     $$=start; 
                                 }
       | START_H3 content END_H3 {
 				     node* start = new_n();
                                     start->t = n_headings; 
                                     start->k=0;
                                     start->child.push_back(new_nwd($1));
                                     start->child.push_back($2);
                                     start->child.push_back(new_nwd($3));
                                     $$=start;
                                }
       | START_H4 content END_H4 {
				     node* start = new_n();
                                     start->t = n_headings; 
                                     start->k=0;
                                     start->child.push_back(new_nwd($1));
                                     start->child.push_back($2);
                                     start->child.push_back(new_nwd($3));
                                     $$=start;
                                 } 

 


 list : START_ULIST u1 END_ULIST  {
                                     node* start = new_n();
                                     start->t = n_list; 
                                     start->k=0;
                                     start->child.push_back(new_nwd($1));
                                     start->child.push_back($2);
                                     start->child.push_back(new_nwd($3));
                                     $$=start;
                                  }

     | START_OLIST u1 END_OLIST  {
                                     node* start = new_n();
                                     start->t = n_list; 
                                     start->k=0;
                                     start->child.push_back(new_nwd($1));
                                     start->child.push_back($2);
                                     start->child.push_back(new_nwd($3));
                                     $$=start; 
                                 }

     | START_DLIST d1 END_DLIST  {
                                     node* start = new_n();
                                     start->t = n_dlist; 
                                     start->k=0;
                                     start->child.push_back(new_nwd($1));
                                     start->child.push_back($2);
                                     start->child.push_back(new_nwd($3));
                                     $$=start;
                                  }

u1 : START_LITEM content END_LITEM u1  {
                                          node* start = new_n();
                                          start->t = n_list; 
                                          start->k=0;
                                          start->child.push_back(new_nwd($1));
                                          start->child.push_back($2);
                                          //start->child.push_back(new_nwd($3));
                                          start->child.push_back($4);
                                          $$=start;              
                                       }
   | list u1  {
                 node* start = new_n();
                 start->t = n_list; 
                 start->k=0;
                 start->child.push_back($1);
                 start->child.push_back($2);
                 $$ = start;                        
              }
   
   | {     
         node* start = new_n();
         start->k=1;
         start->t=n_empty;
         start->value = "";
         $$ = start;
     }

d1 : START_DTERM content END_DTERM d2 {
                                          node* start = new_n();
                                          start->t = n_dlist; 
                                          start->k=0;
                                          start->child.push_back(new_nwd($1));
                                          start->child.push_back($2);
                                          start->child.push_back(new_nwd($3));
                                          start->child.push_back($4);
                                          $$=start;         
                                      }

 
   | {
         node* start = new_n();
         start->k=1;
         start->k=n_empty;
         start->value = "";
         $$ = start;
     }

d2 : START_DDATA content END_DDATA d1 {
                                          node* start = new_n();
                                          start->t = n_dlist; 
                                          start->k=0;
                                          //start->child.push_back(new_nwd($1));
                                          start->child.push_back($2);
                                          //start->child.push_back(new_nwd($3));
                                          start->child.push_back($4);
                                          $$=start;                                        
                                      }   
           
f1 : ARG_SIZE f1 {
                     /*node* start = new_n();
                     start->t = n_font_arg; 
                     start->k=0;
                     start->child.push_back(new_nwd($1));
                     start->child.push_back($2);
                     $$=start; */ 
                  }

   | FONT_EQUAL f1 {
                     /* node* start = new_n();
                     start->t = n_font_arg; 
                     start->k=0; 
                     start->child.push_back(new_nwd($1));
                     start->child.push_back($2);
                     $$=start; */
                   }

   | FONT_DARG_INT f1 {
                         /* node* start = new_n();
                         start->t = n_font_arg; 
                         start->k=0;
                         start->child.push_back(new_nwd($1));
                         start->child.push_back($2);
                         $$=start; */
                         font_size=string($1); 
                      }

   | FONT_SARG_INT f1 {
                        /* node* start = new_n();
                         start->t = n_font_arg; 
                         start->k=0;
                         start->child.push_back(new_nwd($1));
                         start->child.push_back($2); */
                         font_size=string($1);
                      }

   | FONT_CLOSE {
                     /* node* start = new_n();
                     start->t = n_font_arg; 
                     start->k=1;
                     start->value = $1;
                     $$=start; */
                } 

style : START_UNDER content END_UNDER  { 
			                node* start = new_n();
                                        start->t = n_style; 
                                        start->k=0;
                                        start->child.push_back(new_nwd($1));
                                        start->child.push_back($2);
                                        start->child.push_back(new_nwd($3));
                                        $$=start;
                                       }
      | START_BOLD content END_BOLD { 
			                node* start = new_n();
                                        start->t = n_style; 
                                        start->k=0;
                                        start->child.push_back(new_nwd($1));
                                        start->child.push_back($2);
                                        start->child.push_back(new_nwd($3));
                                        $$=start;
                                    }
      | START_ITALIC content END_ITALIC    { 
			                      node* start = new_n();
                                              start->t = n_style; 
                                              start->k=0;
                                              start->child.push_back(new_nwd($1));
                                              start->child.push_back($2);
                                              start->child.push_back(new_nwd($3));
                                              $$=start;
                                           }
      | START_ENUM content END_ENUM  { 
			                node* start = new_n();
                                        start->t = n_style; 
                                        start->k=0;
                                        start->child.push_back(new_nwd($1));
                                        start->child.push_back($2);
                                        start->child.push_back(new_nwd($3));
                                        $$=start;
                                     }
      | START_TTYPE content END_TTYPE  { 
			                 node* start = new_n();
                                         start->t = n_style; 
                                         start->k=0;
                                         start->child.push_back(new_nwd($1));
                                         start->child.push_back($2);
                                         start->child.push_back(new_nwd($3));
                                         $$=start;
                                       }
      | START_STRONG content END_STRONG { 
			                  node* start = new_n();
                                          start->t = n_style; 
                                          start->k=0;
                                          start->child.push_back(new_nwd($1));
                                          start->child.push_back($2);
                                          start->child.push_back(new_nwd($3));
                                          $$=start;
                                        }
      | START_SMALL content END_SMALL  { 
			                  node* start = new_n();
                                          start->t = n_style; 
                                          start->k=0;
                                          start->child.push_back(new_nwd($1));
                                          start->child.push_back($2);
                                          start->child.push_back(new_nwd($3));
                                          $$=start;
                                       }
      | START_SUP content END_SUP  {
                                          node* start = new_n();
                                          start->t = n_style; 
                                          start->k=0;
                                          start->child.push_back(new_nwd($1));
                                          start->child.push_back($2);
                                          start->child.push_back(new_nwd($3));
                                          $$=start;
                                   }
      | START_SUB content END_SUB    {
                                          node* start = new_n();
                                          start->t = n_style; 
                                          start->k=0;
                                          start->child.push_back(new_nwd($1));
                                          start->child.push_back($2);
                                          start->child.push_back(new_nwd($3));
                                          $$=start;
                                     } 

      |START_FONT f1 content END_FONT {
                                          node* start = new_n();
                                          start->t = n_style; 
                                          start->k=0;
                                          //start->child.push_back(new_nwd($1));
                                          if(font_size == "1") {start->child.push_back(new_nwd("{\\tiny "));}
                                          else if (font_size == "2") {start->child.push_back(new_nwd("{\\small "));}
                                          else if (font_size == "3") {start->child.push_back(new_nwd("{\\normalsize "));}
                                          else if(font_size == "4") {start->child.push_back(new_nwd("{\\large "));}
                                          else if(font_size == "5") {start->child.push_back(new_nwd("{\\Large "));}
                                          else if(font_size == "6") {start->child.push_back(new_nwd("{\\LARGE "));}
                                          else {start->child.push_back(new_nwd("{\\huge "));}
                                           
                                    
                                         /* switch(font_size)
                                          {
                                            case '1' : { start->child.push_back(new_nwd("\\tiny{"));}
                                            break;
                                            case '2' : {start->child.push_back(new_nwd("\\footnotesize{"));}
                                            break;
                                            case '3' : {start->child.push_back(new_nwd("\\small{"));}
                                            break;
                                            case '4' : {start->child.push_back(new_nwd("\\normalsize{"));}
                                            break;
                                            case '5' : {start->child.push_back(new_nwd("\\large{"));}
                                            break;
                                            case '6' : {start->child.push_back(new_nwd("\\huge{"));}
                                            break;
                                            default : {start->child.push_back(new_nwd("\\Huge{"));}
                                            break;                                                                      
                                          } */
                                   
                                          start->child.push_back($3);
                                          start->child.push_back(new_nwd(" "));
                                          start->child.push_back(new_nwd($4));
                                          $$=start;   
                                      } 

      | TEXT   { 
                    node* start = new_n();
                    start->t = n_text; 
                    start->k=1;
                    start->value = $1;
                    $$ = start;                                 
                } 
      

/* t : t style {
                int x = strlen($1) + strlen($2) + 100 ;
                char *c = (char *)malloc(x);
                strcpy(c,$1);
                strcat(c,$2);
                //strcat(c,$3);
                $$ = c; 
              } 

   

   |  style {
             int x = strlen($1) + 100;
             char *c = (char *)malloc(x);
             strcpy(c,$1);
             $$ = c;  
           } */

   


%%

void yyerror(char *msg)
{
 printf("Error:");
 fprintf(stderr,"%s\n",msg); 
}

int main(int argc,char* argv[])
{
 yyin = fopen(argv[1],"r");
// out = fopen(argv[2],"w+");
ofstream outfile;
yyparse();
//cout<<str<<endl;
outfile.open(argv[2], ios::out | ios::trunc );
outfile<<str;
outfile.close();
return 1;
} 
