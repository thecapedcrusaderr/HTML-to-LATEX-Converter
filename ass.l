%{
#include<bits/stdc++.h> 
#include <string.h>
#include "ass.tab.h"
using namespace std;

int a = 0;
int c = 0;
int b = 0;
int d = 0;
int e = 0;

%}

INTEGER [0-9]+
SPECIAL [\.\,/\`\=\!\(\)\?\:\;@\[\]\\\n]+
VSPECIAL [\#\$\%\^\&\-\{\}\\]
OPERATORS [+*]+
TEXT ([0-9A-Za-z]|[ ]|{SPECIAL}|{OPERATORS})+
DOBQUOTESARG \"{TEXT}+\"
SINQUOTESARG \'{TEXT}+\'
GREEK &[A-Za-z]+;

%x ANCHOR_ARG
%x FONT_ARG
%x COMMENT_ARG
%x IMAGE_ARG
%x TABLE_ARG

%%

<*>[\t  \n]+ ;	

"<!DOCTYPE"[^>]*">" ;

{GREEK}	{
		string x(yytext);
		if(x == "&Alpha;")
		{ strcpy(yylval.s,"A");}
		else if(x== "&Beta;")
		{ strcpy(yylval.s,"B"); }
		else if(x == "&Gamma;")
		{ strcpy(yylval.s,"\\Gamma"); }
		else if(x == "&Delta;")
		{ strcpy(yylval.s,"\\Delta");}
		else if(x == "&Epsilon;")
		{ strcpy(yylval.s,"E");}
		else if(x == "&Zeta;")
		{ strcpy(yylval.s,"Z"); }
		else if(x == "&Eta;")
		{ strcpy(yylval.s,"H");}
		else if(x == "&Theta;")
		{ strcpy(yylval.s,"\\Theta");}
		else if(x == "&Pi;")
		{ strcpy(yylval.s,"\\Pi");}
		else if(x == "&Phi;")
		{ strcpy(yylval.s,"\\Phi");}
		else if(x == "&Xi;")
		{ strcpy(yylval.s,"\\Xi");}
		else if(x == "&alpha;")
		{strcpy(yylval.s,"\\alpha");}
		else if(x == "&beta;")
		{strcpy(yylval.s,"\\beta");}
		else if(x == "&gamma;")
		{strcpy(yylval.s,"\\gamma");}
		else if(x == "&delta;")
		{strcpy(yylval.s,"\\delta");}
		else if(x == "&epsilon;")
		{strcpy(yylval.s,"\\epsilon");}
		else if(x == "&zeta;")
		{strcpy(yylval.s,"\\zeta");}
		else if(x == "&theta;")
		{strcpy(yylval.s,"\\theta");}
		else if(x == "&pi;")
		{strcpy(yylval.s,"\\pi");}
		else if(x == "&phi;")
		{strcpy(yylval.s,"\\phi");}
		return TEXT;
	}
	
{VSPECIAL} {
             string x(yytext);
             if(x == "#")
	     {strcpy(yylval.s,"\\#");}
	     else if(x == "$")
             {strcpy(yylval.s,"\\$");}
             else if(x == "%")
             {strcpy(yylval.s,"\\%");}
             else if(x == "&")
             {strcpy(yylval.s,"\\&");}
             else if(x == "-")
             {strcpy(yylval.s,"\\-");}
             else if(x == "{")
             {strcpy(yylval.s,"\\{");}
             else if(x == "}")
             {strcpy(yylval.s,"\\}");}
             else if(x == "~")
             {strcpy(yylval.s,"\\~{}");}
             else if(x == "^")
             {strcpy(yylval.s,"\\^{}");}
             else if(x == "^")
             {strcpy(yylval.s,"\\^{}");}
             else if(x == "_")
             {strcpy(yylval.s,"{\\_}");}
             else if(x == "\\")
             {strcpy(yylval.s,"$\\backslash\\$");}
             return TEXT;
           }	

{TEXT}   {
	    char *final = new char[strlen(yytext) + 1];
            strcpy(final, yytext);
            yylval.s = final;
            return TEXT;
	 }

"<html>"|"<HTML>"  { 
                   cout<<"hello";
                   char *final = new char[100];
                   strcpy(final,"\\documentclass{article}");
                   yylval.s = final;
	           return START_HTML;
                  }

"</html>"|"</HTML>" {  /* char *final = new char[strlen(yytext) + 1];
                        strcpy(final,"</html>");
                        yylval.s = final; */
                        return END_HTML;
                      }

"<head>"|"<HEAD>" { /* char *final = new char[100];
                     strcpy(final,"<head>");
                     yylval.s = final; */ 
                     return START_HEAD;
	           }
 
"</head>"|"</HEAD>" {   /* char *final = new char[strlen(yytext) + 1];
                         strcpy(final,"</head>");
                         yylval.s = final; */
                         return END_HEAD;
                     }
        
"<body>"|"<BODY>" {  char *final = new char[strlen(yytext) + 1];
                     strcpy(final,"\\begin{document}");
                     yylval.s = final;
	             return START_BODY;
                  }

"</body>"|"</BODY>" { char *final = new char[strlen(yytext) + 1];
                       strcpy(final,"\\end{document}");
                       yylval.s = final;
	               return END_BODY;
                     }

"<title>"|"<TITLE>" {char *final = new char[strlen(yytext) + 1];
                     strcpy(final,"\\title{");
                     yylval.s = final;
	             return START_TITLE;
                    }
"</title>"|"</TITLE>" {char *final = new char[strlen(yytext) + 1];
                       strcpy(final,"}");
                       yylval.s = final; 
	               return END_TITLE;
                      }

"<a"|"<A" {
           BEGIN(ANCHOR_ARG);
            char *final = new char[strlen(yytext) + 1];
           strcpy(final,"\\");
           yylval.s = final; 
           return START_HYPERLINK;
          }

<ANCHOR_ARG>"href"|"HREF" {
                            d=1;
                            char *final = new char[strlen(yytext) + 1];
                            strcpy(final,"href{");
                            yylval.s = final;
                            return HREF;                                               
                           }

<ANCHOR_ARG>"name"|"NAME" { e =1 ;
                            char *final = new char[100];
                            strcpy(final,"label{");
                            yylval.s = final;
                            return NAME; 
                           }

<ANCHOR_ARG>"title"|"TITLE" {
                             /*char *final = new char[strlen(yytext) + 1];
           	             strcpy(final,"title");
            	             yylval.s = final; */
                             return ATR_TITLE; 
                            }
<ANCHOR_ARG>"="    {
                       /* char *final = new char[strlen(yytext) + 1];
                       strcpy(final,"=");
                       yylval.s = final; */
                       return ANCHOR_EQUAL; 
                   }

<ANCHOR_ARG>{DOBQUOTESARG} {                                                    
                             char *final = new char[strlen(yytext) + 1];
                             int n = strlen(yytext);
                             for(int i=1; i<n-1; i++)
                             {
                              final[i-1] = yytext[i];
                             }  
                            yylval.s = final;
                            if(d==1)
                            {
                              d=2;
                              return ANCHD_ARGH_TEXT;
                            }
                            if(e==1)
                            {
                               e = 2;
                               return ANCHD_ARGN_TEXT;
                            }                                   
                           } 
<ANCHOR_ARG>{SINQUOTESARG} {                                                    
                             char *final = new char[strlen(yytext) + 1];
                             int n = strlen(yytext);
                             for(int i=1; i<n-1; i++)
                             {
                              final[i-1] = yytext[i];
                              // printf("%c",yytext[i]);
                             }  
                            yylval.s = final; 
                            if(d==1)
                            {
                              d=2;
                              return ANCHS_ARGH_TEXT;
                            }
                            if(e==1)
                            {
                               e = 2;
                               return ANCHS_ARGN_TEXT;
                            }                       
                           }

<ANCHOR_ARG>">" {
                 BEGIN(INITIAL);
                 char *final = new char[100]; 
                 strcpy(final,"}{");
                 yylval.s = final;
                 return ANCHOR_CLOSE;
                }


"</a>"|"</A>" { 
               char *final = new char[strlen(yytext) + 1]; 
               strcpy(final,"}");
               yylval.s = final; 
               return END_HYPERLINK;
              }

"<font"|"<FONT" {
                 BEGIN(FONT_ARG);
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"<font");
                 yylval.s = final; 
                 return START_FONT;
                }

<FONT_ARG>"size"|"SIZE" {
                         char *final = new char[strlen(yytext) + 1]; 
                         strcpy(final,"size");
                         yylval.s = final;
                         return ARG_SIZE;              
                        }
<FONT_ARG>"="    {
                     char *final = new char[strlen(yytext) + 1]; 
                     strcpy(final,"=");
                     yylval.s = final;
                     return FONT_EQUAL; 
                 }
 
<FONT_ARG>{DOBQUOTESARG} {
                           char *final = new char[strlen(yytext) + 1];
                           int n = strlen(yytext);
                             for(int i=1; i<n-1; i++)
                             {
                              final[i-1] = yytext[i];
                              // printf("%c",yytext[i]);
                             }  
                            yylval.s = final; 
                          return FONT_DARG_INT; 
                         }
<FONT_ARG>{SINQUOTESARG} {
                           char *final = new char[strlen(yytext) + 1];
                             int n = strlen(yytext);
                             for(int i=1; i<n-1; i++)
                             {
                              final[i-1] = yytext[i];
                              // printf("%c",yytext[i]);
                             }  
                            yylval.s = final; 
                          return FONT_SARG_INT; 
                         }
<FONT_ARG>">" {
                 BEGIN(INITIAL);
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,">");
                 yylval.s = final;
                 return FONT_CLOSE;
              }

"</font>"|"</FONT>" {
                     char *final = new char[100]; 
                     strcpy(final,"}");
                     yylval.s = final;
                     return END_FONT;
                    }
"<br>"|"<BR>" { 
                char *final = new char[strlen(yytext) + 1]; 
                strcpy(final,"\\\\");
                yylval.s = final;
                return BREAK; 
               }
"<p>"|"<P>" {
             char *final = new char[strlen(yytext) + 1]; 
             strcpy(final,"\\par ");
             yylval.s = final;
             return START_PARA;
            }
"</p>"|"</P>" {
               /* char *final = new char[strlen(yytext) + 1]; 
               strcpy(final,"</p>");
               yylval.s = final; */
               return END_PARA;         
              }

"<h1>"|"<H1>" {
                char *final = new char[100]; 
                strcpy(final,"\\section*{");
                yylval.s = final;
                return START_H1;
               }

"</h1>"|"</H1>" {
                 char *final = new char[100]; 
                 strcpy(final,"} ");
                 yylval.s = final;
                 return END_H1;
                }  
"<h2>"|"<H2>" {
               char *final = new char[100]; 
               strcpy(final,"\\subsection*{");
               yylval.s = final;
               return START_H2;
              }

"</h2>"|"</H2>" {
                 char *final = new char[100]; 
                 strcpy(final,"} ");
                 yylval.s = final;
                 return END_H2;
                }
"<h3>"|"<H3>" {
               char *final = new char[100]; 
               strcpy(final,"\\subsubsection*{");
               yylval.s = final;
               return START_H3;
              }
"</h3>"|"</H3>" {
                 char *final = new char[100]; 
                 strcpy(final,"} ");
                 yylval.s = final;
                 return END_H3;
                }
"<h4>"|"<H4>" {
               char *final = new char[100]; 
               strcpy(final,"\\textbf{");
               yylval.s = final;
               return START_H4;
              }
"</h4>"|"</H4>" {
                 char *final = new char[100]; 
                 strcpy(final,"} ");
                 yylval.s = final; 
                 return END_H4;
                }
"<ul>"|"<UL>" {  
               char *final = new char[100]; 
               strcpy(final,"\\begin{itemize}");
               yylval.s = final;
	       return START_ULIST;
              }

"</ul>"|"</UL>" { 
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"\\end{itemize}");
                 yylval.s = final;
	         return END_ULIST;
                } 

"<li>"|"<LI>" {
               char *final = new char[100]; 
               strcpy(final,"\\item");
               yylval.s = final; 
               return START_LITEM;
              }

"</li>"|"</LI>" {
                 /* char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"</li>");
                 yylval.s = final; */
                 return END_LITEM;
                }

"<ol>"|"<OL>" { char *final = new char[100]; 
                strcpy(final,"\\begin{enumerate}");
                yylval.s = final;
                return START_OLIST;
              }

"</ol>"|"</OL>" {
                  char *final = new char[100]; 
                  strcpy(final,"\\end{enumerate}");
                  yylval.s = final;
                  return END_OLIST;
                }

"<dl>"|"<DL>" { char *final = new char[100]; 
                strcpy(final,"\\begin{description} ");
                yylval.s = final;
                return START_DLIST;
              }

"</dl>"|"</DL>" { char *final = new char[100]; 
                  strcpy(final,"\\end{description} ");
                  yylval.s = final;
                  return END_DLIST;
                }

"<dt>"|"<DT>" { char *final = new char[100]; 
                strcpy(final,"\\item[");
                yylval.s = final;
                return START_DTERM;
              }

"</dt>"|"</DT>" { char *final = new char[100]; 
                  strcpy(final,"]");
                  yylval.s = final;
                  return END_DTERM;
                }

"<dd>"|"<DD>" { /* char *final = new char[strlen(yytext) + 1]; 
                strcpy(final,"<dd>");
                yylval.s = final; */
                return START_DDATA;
              }

"</dd>"|"</DD>" { /*
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"</dd>");
                 yylval.s = final; */
                 return END_DDATA;
                }


"<div>"|"<DIV>" { 
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"\\par ");
                 yylval.s = final;  
                 return START_DIVISION;
                }
"</div>"|"</DIV>" { 
                   char *final = new char[strlen(yytext) + 1]; 
                   strcpy(final,"</div>");
                   yylval.s = final; 
                   return END_DIVISION;
                  }
"<u>"|"<U>" {
               char *final = new char[100]; 
               strcpy(final,"\\underline{");
               yylval.s = final; 
               return START_UNDER;
            }
"</u>"|"</U>" {
               char *final = new char[100]; 
               strcpy(final,"}");
               yylval.s = final;  
               return END_UNDER;
              }
"<b>"|"<B>" {
             char *final = new char[100]; 
             strcpy(final,"\\textbf{");
             yylval.s = final; 
             return START_BOLD;
            }
"</b>"|"</B>" {
               char *final = new char[100]; 
               strcpy(final,"}");
               yylval.s = final;     
               return END_BOLD;
              }
"<i>"|"<I>" {
             char *final = new char[100]; 
             strcpy(final,"\\textit{");
             yylval.s = final;
             return START_ITALIC;
            }
"</i>"|"</I>" {
	       char *final = new char[100]; 
               strcpy(final,"}");
               yylval.s = final;
               return END_ITALIC;
              }
"<em>"|"<EM>" {
               char *final = new char[strlen(yytext) + 1]; 
               strcpy(final,"\\emph{");
               yylval.s = final;  
               return START_ENUM;
              }
"</em>"|"</EM>" {
                 char *final = new char[100]; 
                 strcpy(final,"}");
                 yylval.s = final;
                 return END_ENUM;
                }
"<tt>"|"<TT>" {
               char *final = new char[strlen(yytext) + 1]; 
               strcpy(final,"\\texttt{");
               yylval.s = final; 
               return START_TTYPE;
              }
"</tt>"|"</TT>" {
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"}");
                 yylval.s = final;
                 return END_TTYPE;
                }
"<strong>"|"<STRONG>" {
                       char *final = new char[100]; 
                       strcpy(final,"\\textbf{");
                       yylval.s = final; 
                       return START_STRONG;
                      }
"</strong>"|"</STRONG>" {
                         char *final = new char[strlen(yytext) + 1]; 
                         strcpy(final,"}");
                         yylval.s = final;
                         return END_STRONG;
                        }
"<center>"|"<CENTER>" { 
                       char *final = new char[strlen(yytext) + 1]; 
                       strcpy(final,"\\begin{center}");
                       yylval.s = final; 
                       return START_CENTER;
                      }
"</center>"|"</CENTER>" {
                         char *final = new char[strlen(yytext) + 1]; 
                         strcpy(final,"\\end{center}");
                         yylval.s = final; 
                         return END_CENTER;
                        }
"<small>"|"<SMALL>" { 
                     char *final = new char[100]; 
                     strcpy(final,"{\\tiny ");
                     yylval.s = final; 
                     return START_SMALL;
                    }

"</small>"|"</SMALL>" {
                       char *final = new char[100]; 
                       strcpy(final,"}");
                       yylval.s = final; 
                       return END_SMALL;
                      }
"<sub>"|"<SUB>" {
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"$_{");
                 yylval.s = final; 
                 return START_SUB;
                }
"</sub>"|"</SUB>" {
                   char *final = new char[strlen(yytext) + 1]; 
                   strcpy(final,"}$");
                   yylval.s = final;
                   return END_SUB;
                  }
"<sup>"|"<SUP>" {
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"$^{");
                 yylval.s = final; 
                 return START_SUP;
                }
"</sup>"|"</SUP>" {
                   char *final = new char[strlen(yytext) + 1]; 
                   strcpy(final,"}$");
                   yylval.s = final;
                   return END_SUP;
                  }
"<figure>"|"<FIGURE>" {
                       char *final = new char[100]; 
                       strcpy(final,"\\begin{figure}[h]");
                       yylval.s = final;           
                       return START_FIG;
                      }
"</figure>"|"</FIGURE>" {
                         char *final = new char[strlen(yytext) + 1]; 
                         strcpy(final,"\\end{figure}");
                         yylval.s = final;            
                         return END_FIG;
                        }
"<figure_caption>"|"<FIGURE_CAPTION>" {
                                       char *final = new char[strlen(yytext) + 1]; 
                                       strcpy(final,"<figure_caption>");
                                       yylval.s = final;    
                                       return START_FIG_CAP;	
                                      }
"</figure_caption>"|"</FIGURE_CAPTION>" {
                                         char *final = new char[strlen(yytext) + 1]; 
                                         strcpy(final,"</figure_caption>");
                                         yylval.s = final;
                                         return END_FIG_CAP;
                                        }
"<table"|"<TABLE" { 
                    BEGIN(TABLE_ARG);
                    char *final = new char[strlen(yytext) + 1]; 
                    strcpy(final,"<table");
                    yylval.s = final;
                    return START_T;
                  }
<TABLE_ARG>"border"|"BORDER"  {
                                 char *final = new char[strlen(yytext) + 1]; 
                                 strcpy(final,"border");
                                 yylval.s = final;
                                return ARG_BORDER; 
                              }  

<TABLE_ARG>"="       {
                       char *final = new char[strlen(yytext) + 1]; 
                       strcpy(final,"=");
                       yylval.s = final;
                       return BORDER_EQUAL; 
                      } 

<TABLE_ARG>{DOBQUOTESARG} {
                            char *final = new char[strlen(yytext) + 1];
                            int n = strlen(yytext);
                             for(int i=1; i<n-1; i++)
                             {
                              final[i-1] = yytext[i];
                              // printf("%c",yytext[i]);
                             }  
                            yylval.s = final; 
                            return DOBARG_BORDSIZE; 
                          }
<TABLE_ARG>{SINQUOTESARG} {
                            char *final = new char[strlen(yytext) + 1];
                            int n = strlen(yytext);
                             for(int i=1; i<n-1; i++)
                             {
                              final[i-1] = yytext[i];
                              // printf("%c",yytext[i]);
                             }  
                            yylval.s = final; 
                            return SINARG_BORDSIZE; 
                          }

<TABLE_ARG>">" {
                 BEGIN(INITIAL);
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,">");
                 yylval.s = final;
                 return TABLE_CLOSE;
               }


"</table>"|"</TABLE>" {
                       char *final = new char[100]; 
                       strcpy(final,"\\end{tabular}");
                       yylval.s = final;  
                       return END_T;
                      }
"<caption>"|"<CAPTION>" {
                          char *final = new char[strlen(yytext) + 1]; 
                          strcpy(final,"<caption>");
                          yylval.s = final;
                          return START_T_CAP;
                        }
"</caption>"|"</CAPTION>" {
                            char *final = new char[strlen(yytext) + 1]; 
                            strcpy(final,"</caption>");
                            yylval.s = final;
                            return END_T_CAP;
                          }
"<th>"|"<TH>" {
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"<th>");
                 yylval.s = final;
                 return START_T_HEAD;
              }
"</th>"|"</TH>" { 
                   char *final = new char[strlen(yytext) + 1]; 
                  strcpy(final,"</th>");
                  yylval.s = final;
                  return END_T_HEAD;
                }
"<td>"|"<TD>" {
                char *final = new char[strlen(yytext) + 1]; 
                strcpy(final,"<td>");
                yylval.s = final;
                return START_T_DATA;
                
              }
"</td>"|"</TD>" { char *final = new char[strlen(yytext) + 1]; 
                  strcpy(final,"</td>");
                  yylval.s = final;
                  return END_T_DATA;
                }
"<tr>"|"<TR>" {
                char *final = new char[strlen(yytext) + 1]; 
                strcpy(final,"<tr>");
                yylval.s = final;
                return START_T_ROW;
              }
"</tr>"|"</TR>" {
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"</tr>");
                 yylval.s = final;
                 return END_T_ROW;
                }

"<img"|"<IMG" {  BEGIN(IMAGE_ARG);
                 char *final = new char[strlen(yytext) + 1]; 
                 strcpy(final,"<img");
                 yylval.s = final;
                 return IMAGE;
              }

<IMAGE_ARG>"src"|"SRC" { a =1 ;
                         char *final = new char[strlen(yytext) + 1]; 
         	         strcpy(final,"src");
                         yylval.s = final;
                         return IMG_SRC; 
                        }
<IMAGE_ARG>"height"|"HEIGHT" {  b = 1;
                                char *final = new char[strlen(yytext) + 1]; 
         	                strcpy(final,"height");
                                yylval.s = final;
                                return IMG_HEIGHT; 
                               }

<IMAGE_ARG>"width"|"WIDTH" { c = 1;
                            char *final = new char[strlen(yytext) + 1]; 
         	            strcpy(final,"width");
                            yylval.s = final;
                            return IMG_WIDTH; 
                           }
<IMAGE_ARG>"=" {
                      char *final = new char[strlen(yytext) + 1]; 
         	      strcpy(final,"=");
                      yylval.s = final;
                      return IMG_EQUAL; 
                     }

<IMAGE_ARG>{DOBQUOTESARG} {  
                            char *final = new char[100];
                            int n = strlen(yytext);
                             for(int i=1; i<n-1; i++)
                             {
                              final[i-1] = yytext[i];
                              // printf("%c",yytext[i]);
                             }  
                            yylval.s = final;
                           if(a==1) 
                           {
                            a=2;
                            return DARG_IMGS;
                           }
                           if(b==1)
                           {
                             b=2;
                             return DARG_IMGH;
                           }
                           if(c==1)
                           {
                             c =2;
                             return DARG_IMGW;
                           }                           
                         }
<IMAGE_ARG>{SINQUOTESARG} {
                            char *final = new char[strlen(yytext) + 1];
                            int n = strlen(yytext);
                             for(int i=1; i<n-1; i++)
                             {
                              final[i-1] = yytext[i];
                              // printf("%c",yytext[i]);
                             }  
                            yylval.s = final; 
                           if(a==1) 
                           {
                            a=2;
                            return SARG_IMGS;
                           }
                           if(b==1)
                           {
                             b=2;
                             return SARG_IMGH;
                           }
                           if(c==1)
                           {
                             c=2;
                             return SARG_IMGW;
                           } 
                         }
<IMAGE_ARG>"/" {
                  char *final = new char[10];
                  strcpy(final,"/");
                  yylval.s = final;
                  return IMG_FSLH;            
                }
 

<IMAGE_ARG>">" {
                 BEGIN(INITIAL);
                 char *final = new char[strlen(yytext) + 1]; 
         	 strcpy(final,">");
                 yylval.s = final;
                 return IMG_CLOSE;
               }


"<!--"  {  
           BEGIN(COMMENT_ARG);   
           printf("HELLO");                 
        }



<COMMENT_ARG>"-->"  {  
                     BEGIN(INITIAL);
                    }

<*>.  ;
 
%%

int yywrap()
{
return 1;
}

