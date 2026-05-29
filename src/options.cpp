#include "options.hpp"
#include "spp.h"
#include <cstdlib>
#include <unistd.h>

/**
 * @brief Handle an invalid command-line definition and exit
 */
[[noreturn]] static void invalid_cmdline(const std::string& text)
{
    std::cerr << "Invalid definition: " << text << std::endl << std::endl;
    show_usage();
}

bool first_file_seen = false;

void show_usage()
{
    std::cerr << "Usage: spp [-D<define>] [files]" << std::endl;
    std::exit(EXIT_FAILURE);
}

/**
 * @brief Add a string to the hash table
 *
 * @details The string is the definition provided on the command line. If -DNAME is provided,
 *          then NAME is added to the hash table.
 *
 * @param text the string to add
 */
static void add_defines_to_hashtable(const std::string& text)
{
    add_string_to_hash_table(text);
}

void parse_cmdline_defines(const std::string& text)
{
    if (text.length() <= 2)
        invalid_cmdline(text);

    if (text[1] == 'D')
    {
        if (text.find('=') != std::string::npos)
        {
            std::cerr << "Ignoring `" << text << "' with `='" << std::endl;
            return;
        }
        add_defines_to_hashtable(text.substr(2));
    }
    else
    {
        invalid_cmdline(text);
    }
}

void parse_cmdline_files(const std::string& text)
{
    first_file_seen = true;

    if (access(text.c_str(), R_OK) == -1)
    {
        switch (errno)
        {
            case EACCES:
                std::cerr << "Read permissions needed for file " << text << std::endl;
                break;
            case ENOENT:
                std::cerr << "File " << text << " does not exist" << std::endl;
                break;
            default:
                std::cerr << "File " << text << " cannot be read" << std::endl;
        }
        std::exit(EXIT_FAILURE);
    }
    preprocess_file(text);
}
