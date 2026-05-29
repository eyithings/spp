#include <iostream>
#include <fstream>
#include <string>
#include "options.hpp"
#include "sppdebug.h"

static void judge_cmdline(const std::string& arg)
{
    if (arg == "-h" || arg == "--help") {
        show_usage();
        std::exit(EXIT_SUCCESS);
    }

    if (arg[0] == '-')
    {
        /* Quit to respect command line order. Files should come last */
        if (first_file_seen)
            show_usage();

        parse_cmdline_defines(arg);
        return;
    }
    parse_cmdline_files(arg);
}

int main(int argc, char **argv)
{
    for (int i = 1; i < argc; ++i)
    {
        judge_cmdline(argv[i]);
    }
    return 0;
}
