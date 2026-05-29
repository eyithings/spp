#ifndef SPP_H
#define SPP_H

#include "hash.h"
#include <string>
#include <vector>

constexpr char spp_extension[] = ".spp";

void preprocess_file(const std::string& filename);

enum class line_type
{
    IFDEF,
    ELIF,
    ELSE,
    ENDIF,
    NORMAL,
    FILEEND
};

struct pstate
{
    size_t current_line_number;
};

struct reader_output
{
    std::string line;
    line_type ltype;
    bool valid;
};

struct if_stack
{
    size_t line_number;
    bool fastforward;
    bool writeblock;
};

#endif
