#ifndef OPTIONS_HPP
#define OPTIONS_HPP

#include <string>

extern bool first_file_seen;

[[noreturn]] void show_usage();
void parse_cmdline_defines(const std::string& text);
void parse_cmdline_files(const std::string& text);

#endif
