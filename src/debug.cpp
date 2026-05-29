#include "sppdebug.h"
#include "hash.h"

#ifdef DEBUG
void dump_hash_table()
{
    for (const auto& elem : global_hash_table)
    {
        std::cout << elem << std::endl;
    }
}

std::string print_line_type(line_type t)
{
    switch (t)
    {
        case line_type::IFDEF:
            return "IFDEF";
        case line_type::ELIF:
            return "ELIF";
        case line_type::ELSE:
            return "ELSE";
        case line_type::ENDIF:
            return "ENDIF";
        case line_type::NORMAL:
            return "NORMAL";
        default:
            return "UNKNOWN";
    }
}

#else
void dump_hash_table() {}
std::string print_line_type(line_type t) { (void)t; return ""; }
#endif
