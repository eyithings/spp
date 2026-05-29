#include "spp.h"
#include "sppdebug.h"
#include "parser.h"
#include <fstream>
#include <string>
#include <cstdio>
#include <memory>
#include <regex>

constexpr int token_prefix_len = 5;
constexpr char token_ifdef[] = "@ifdef ";
constexpr char token_elif[] = "@elif ";
constexpr char token_else[] = "@else";
constexpr char token_endif[] = "@endif";

static reader_output getLine(std::ifstream& reader, pstate& stats);
static bool simplify(reader_output& ro);
bool judge_lines(std::ifstream& reader, std::ofstream& writer);

static std::vector<if_stack> if_stack_list;

static if_stack create_if_stack(pstate& stat)
{
    if_stack ifs;
    ifs.line_number = stat.current_line_number;
    ifs.fastforward = false;
    ifs.writeblock = false;
    return ifs;
}

static void push_if_stack(if_stack& ifs)
{
    if (!if_stack_list.empty())
        ifs.fastforward = if_stack_list.back().fastforward;
    if_stack_list.push_back(ifs);
    cerr_debug_print("[push]: line " << if_stack_list.back().line_number);
}

static void pop_if_stack()
{
    if (if_stack_list.empty())
    {
        cerr_debug_print("WARN: nothing to pop" << std::endl);
        return;
    }
    cerr_debug_print("[pop] line " << if_stack_list.back().line_number << std::endl);
    if_stack_list.pop_back();
}

static int token_len(line_type type)
{
    switch (type)
    {
        case line_type::IFDEF:
            return token_prefix_len + sizeof(token_ifdef) - 2;
        case line_type::ELIF:
            return token_prefix_len + sizeof(token_elif) - 2;
        case line_type::ELSE:
            return token_prefix_len + sizeof(token_else) - 2;
        case line_type::ENDIF:
            return token_prefix_len + sizeof(token_endif) - 2;
        default:
            return -1;
    }
}

static bool simplify(reader_output& ro)
{
    bool ret = false;

    ro.line.erase(0, token_len(ro.ltype));

    std::regex activex("^[a-zA-Z0-9]+[ ]+$", std::regex_constants::extended);
    std::smatch matchx;
    if (std::regex_search(ro.line, matchx, activex))
    {
        if (is_string_in_hash_table(ro.line))
            ret = true;
    }
    else if (parse(ro.line))
        ret = true;

    if (ret) {
        cerr_debug_print("Eval [True] " << ro.line << std::endl);
    } else {
        cerr_debug_print("Eval [False] " << ro.line << std::endl);
    }

    return ret;
}

static line_type check_line_type(std::string& line, pstate& state)
{
    if (line[0] == '#' && line[1] == '-' && line[2] == '-')
    {
        if (line.find(token_ifdef, 2) != std::string::npos)
            return line_type::IFDEF;
        else if (line.find(token_endif, 2) != std::string::npos)
            return line_type::ENDIF;
        else if (line.find(token_elif, 2) != std::string::npos)
            return line_type::ELIF;
        else if (line.find(token_else, 2) != std::string::npos)
            return line_type::ELSE;
        else
            std::cerr << "Error: Invalid directive on line " << state.current_line_number << std::endl;
    }
    return line_type::NORMAL;
}

static reader_output getLine(std::ifstream& reader, pstate& stats)
{
    reader_output output;
    if (std::getline(reader, output.line))
    {
        stats.current_line_number++;
        output.ltype = check_line_type(output.line, stats);
        output.valid = true;
    }
    else
    {
        output.valid = false;
    }
    return output;
}

bool judge_lines(std::ifstream& reader, std::ofstream& writer)
{
    pstate stats = { 0 };

    while (true)
    {
        reader_output ro = getLine(reader, stats);
        if (!ro.valid)
            break;

        cerr_debug_print("[line]:" << print_line_type(ro.ltype) << " "
            << ro.line << std::endl);

        if (ro.ltype == line_type::IFDEF)
        {
            if_stack tmp = create_if_stack(stats);
            push_if_stack(tmp);
            if (simplify(ro))
                if_stack_list.back().writeblock = true;
        }

        else if (ro.ltype == line_type::ELIF)
        {
            if (!if_stack_list.empty() && !if_stack_list.back().fastforward)
            {
                if (if_stack_list.back().writeblock == true)
                {
                    if_stack_list.back().writeblock = false;
                    if_stack_list.back().fastforward = true;
                }
                else
                {
                    if (simplify(ro))
                        if_stack_list.back().writeblock = true;
                }
            }
        }

        else if (ro.ltype == line_type::ELSE)
        {
            if (!if_stack_list.empty() && !if_stack_list.back().fastforward)
                if_stack_list.back().writeblock = !if_stack_list.back().writeblock;
        }

        else if (ro.ltype == line_type::ENDIF)
        {
            pop_if_stack();
        }

        else if (ro.ltype == line_type::NORMAL)
        {
            if (!if_stack_list.empty() && if_stack_list.back().fastforward)
            {
                cerr_debug_print("[>>]" << std::endl);
                continue;
            }
            if (!if_stack_list.empty() && !if_stack_list.back().writeblock)
                continue;

            cerr_debug_print("[write]: " << ro.line << std::endl);
            writer << ro.line << std::endl;
        }
    }

    return true;
}

void preprocess_file(const std::string& filename)
{
    std::ifstream ifile(filename);
    std::string output_filename = filename + spp_extension;
    std::ofstream ofile(output_filename);
    bool s = judge_lines(ifile, ofile);
    ifile.close();
    ofile.close();
    if (!s)
    {
        std::cerr << "Error: Unterminated block" << std::endl;
        std::remove(output_filename.c_str());
        std::exit(EXIT_FAILURE);
    }
}
