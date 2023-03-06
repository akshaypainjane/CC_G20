#include "ast.hh"

#include <string>
#include <vector>


NodeBinOp::NodeBinOp(NodeBinOp::Op ope, Node *leftptr, Node *rightptr) {
    type = BIN_OP;
    op = ope;
    left = leftptr;
    right = rightptr;
}

std::string NodeBinOp::to_string() {
    std::string out = "(";
    switch(op) {
        case PLUS: out += '+'; break;
        case MINUS: out += '-'; break;
        case MULT: out += '*'; break;
        case DIV: out += '/'; break;
    }

    out += ' ' + left->to_string() + ' ' + right->to_string() + ')';

    return out;
}

NodeInt::NodeInt(int val) {
    type = INT_LIT;
    value = val;
}

std::string NodeInt::to_string() {
    return std::to_string(value);
}

NodeStmts::NodeStmts() {
    type = STMTS;
    list = std::vector<Node*>();
}

void NodeStmts::push_back(Node *node) {
    list.push_back(node);
}

std::string NodeStmts::to_string() {
    std::string out = "(begin";
    for(auto i : list) {
        out += " " + i->to_string();
    }

    out += ')';

    return out;
}

NodeAssn::NodeAssn(std::string id, Node *expr) {
    type = ASSN;
    identifier = id;
    expression = expr;
}

std::string NodeAssn::to_string() {
    return "(let " + identifier + " " + expression->to_string() + ")";
}

NodeDebug::NodeDebug(Node *expr) {
    type = DBG;
    expression = expr;
}

std::string NodeDebug::to_string() {
    return "(dbg " + expression->to_string() + ")";
}

NodeIdent::NodeIdent(std::string ident) {
    identifier = ident;
}
std::string NodeIdent::to_string() {
    return identifier;
}


/////////////////////////

NodeVarAssn::NodeVarAssn(std::string id, Node *expr) {
    type = ASSN;
    identifier = id;
    expression = expr;
}

std::string NodeVarAssn::to_string() {
    return "(assign " + identifier + " " + expression->to_string() + ")";
}

NodeTernary::NodeTernary(Node *expr0, Node *expr1, Node *expr2) {
    type = STMTS;
    expression0 = expr0;
    expression1 = expr1;
    expression2 = expr2;
}

std::string NodeTernary::to_string() {
    return "(?: " + expression0->to_string() + " " + expression1->to_string() +" " + expression2->to_string() + ")";
}