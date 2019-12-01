bison -d ass.y
flex ass.l
g++ lex.yy.c ass.tab.c ass.cpp
./a.out $1 $2
