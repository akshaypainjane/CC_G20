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
%}

%%
    
    
"//".*"\n"     {}
"/*"[-a-zA-Z0-9+*/;()_= \n]*"*/"     {}   // put /s here 
    
"#undef "[_a-zA-Z][_a-zA-Z0-9]* { 
    std::string str = yytext;
    std::string iden="";
    
    int i=7;
    while(i < str.length())
    {
        iden += str[i];
        i++;
    }
    
    // mp.erase(iden);
    mp[iden] = "";
}
    
"#def "([a-zA-Z_][a-zA-Z0-9_]*" ".*(\\\n)?)+ { 
    std::string str = yytext;
    std::string iden="", text="";
    
    int i=5;
    while(str[i]!=' ')
    {
        iden += str[i];
        i++;
    }
    i++;
    while(i < str.length())
    {
        if (str[i] != '\\')
            text += str[i]; 
        i++;
    }
    
    mp[iden] = text;
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
    while(mp.find(str) != mp.end() && mp[str] != "")
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