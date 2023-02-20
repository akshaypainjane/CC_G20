%option noyywrap
%{
#include "parser.hh"
#include <string>
#include <iostream>
#include <fstream>
#include <unordered_map>
#include <string>
    
extern int yyerror(std::string msg);
std::unordered_map<std::string, std::string> mp;
bool flag = false;
%}

%%    
    
"//".*"\n"     {}
"/*"[-a-zA-Z0-9+*/;()_= \n]*"*/"     {}   // put /s here 
    
"#undef "[_a-zA-Z][_a-zA-Z0-9]* { 

    std::string str = yytext;
    std::string iden = "";
    
    int i = 7;
    while(i < (int)str.size())
    {
        iden += str[i];
        i++;
    }
    
    mp.erase(iden);
}
    
"#def "([a-zA-Z_][a-zA-Z0-9_]*" ".*(\\\n)?)+ { 

    std::string str = yytext;
    std::string iden = "", text = "";
    
    int i=5;
    while(str[i]!=' ')
    {
        iden += str[i];
        i++;
    }
    i++;

    while(i < (int)str.size())
    {
        if (str[i] != '\\')
            text += str[i]; 
        i++;
    }
    
    mp[iden] = text;
}
    
  
"#ifdef "[_a-zA-Z][_a-zA-Z0-9]*"\n" {
    
    std::string str = yytext;
    std::string iden = "";
    
    int i=7;
    while(str[i] != '\n')
    {
        iden += str[i];
        i++;
    }
    
    if(mp.find(iden) == mp.end() || mp[iden] == "")
    {
        char c = yyinput();
        char c1 = yyinput();

        while(!(c == '#' && c1 == 'e'))
        {
            unput(c1);
            unput(c);

            yyinput();

            c = yyinput();
            c1 = yyinput();
        }

        unput(c1);
        unput(c);
    }
    
    else
    {
        flag = true;
    }
}
    
    
"#elif "[_a-zA-Z][_a-zA-Z0-9]*"\n" {
    
    if(!flag)
    {
        std::string str = yytext;
        std::string iden = "";
    
        int i = 6;
        while(str[i] != '\n')
        {
            iden += str[i];
            i++;
        }
    
        if(mp.find(iden) == mp.end() || mp[iden] == "")
        {
            char c = yyinput();
            char c1 = yyinput();

            while(!(c == '#' && c1 == 'e'))
            {
                unput(c1);
                unput(c);

                yyinput();

                c = yyinput();
                c1 = yyinput();
            }

            unput(c1);
            unput(c);
        }
    
        else
        {
            flag = true;
        }
    }
    
    else
    {
        char c = yyinput();
        char c1 = yyinput();

        while(!(c == '#' && c1 == 'e'))
        {
            unput(c1);
            unput(c);

            yyinput();

            c = yyinput();
            c1 = yyinput();
        }

        unput(c1);
        unput(c);
    }
    
    
}
    
    
"#else\n" {
    
    if(flag)
    {
        char c = yyinput();
        char c1 = yyinput();

        while(!(c == '#' && c1 == 'e'))
        {
            unput(c1);
            unput(c);

            yyinput();

            c = yyinput();
            c1 = yyinput();
        }

        unput(c1);
        unput(c);
    }
}
    
    
"#endif" {
    
    flag = false;
}
    
"+"       { return TPLUS; }
"-"       { return TDASH; }
"*"       { return TSTAR; }
"/"       { return TSLASH; }
";"       { return TSCOL; }
"("       { return TLPAREN; }
")"       { return TRPAREN; }
"="       { return TEQUAL; }
"dbg"     { return TDBG; }
"let"     { return TLET; }
[0-9]+    { yylval.lexeme = std::string(yytext); return TINT_LIT; }
    
    
    
[_a-zA-Z][_a-zA-Z0-9]* {
    
    std::string str = yytext; 
    while(mp.find(str) != mp.end())
        str = mp[str];
    
    if(str != yytext) {
        int sz = str.size();
        for(int i=sz-1;i>=0;i--)
            unput(str[i]);
    } else{
        yylval.lexeme = std::string(yytext); return TIDENT;
    
    }
}

[ \t\n]   { /* skip */ }
.         { yyerror("unknown char"); }
%%
    
std::string token_to_string(int token, const char *lexeme) 
{
    std::string s;
    switch (token) {
        case TPLUS: s = "TPLUS"; break;
        case TDASH: s = "TDASH"; break;
        case TSTAR: s = "TSTAR"; break;
        case TSLASH: s = "TSLASH"; break;
        case TSCOL: s = "TSCOL"; break;
        case TLPAREN: s = "TLPAREN"; break;
        case TRPAREN: s = "TRPAREN"; break;
        case TEQUAL: s = "TEQUAL"; break;
        
        case TDBG: s = "TDBG"; break;
        case TLET: s = "TLET"; break;
    
        /* case TCOMMENT: s = "TCOMMENT"; break;
        case TMCOMMENT: s = "TMCOMMENT"; break; */
    
        case TINT_LIT: s = "TINT_LIT"; s.append("  ").append(lexeme); break;
        case TIDENT: s = "TIDENT"; s.append("  ").append(lexeme); break;
    }
    
    return s;
}
