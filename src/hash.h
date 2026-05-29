#ifndef HASH_H
#define HASH_H

#include <cstdlib>
#include <cstdint>
#include <string>
#include <unordered_set>
#include <iostream>

/**
 * @brief Size of the hash table
 */
constexpr size_t HASH_TABLE_SIZE = 31;

/**
 * @brief A type to represent a hash
 */
typedef std::uint64_t hash_type;

/**
 * @brief A global hash table storing all defined strings
 */
extern std::unordered_set<std::string> global_hash_table;

/**
 * @brief Function to get the hash of a string
 *
 * @param s A reference to a string whose hash we want to calculate
 *
 * @return An element of type @ref hash_type
 */
hash_type get_string_hash(const std::string& s);

/**
 * @brief Function to get the index of a string in the hash table
 *
 * @param s A reference to a string whose index we want to get
 * @param h A pointer to @ref hash_type to store the hash of the string
 *
 * @return The index of the string in the hash table
 */
int get_string_index(const std::string& s, hash_type* h);

/**
 * @brief Function to add a string to the hash table
 *
 * @param s A reference to a string to add
 */
void add_string_to_hash_table(const std::string& s);

/**
 * @brief Function to check if a string is in the hash table
 *
 * @param s A reference to a string to check
 *
 * @return true if the string is in the hash table, false otherwise
 */
bool is_string_in_hash_table(const std::string& s);

/**
 * @brief Function to find a string in the hash table
 *
 * @param s A reference to a string to find
 *
 * @return A pointer to the string if found, nullptr otherwise
 */
const std::string* find_string_in_hash_table(const std::string& s);

/**
 * @brief Function to remove a string from the hash table
 *
 * @param s A reference to a string to remove
 */
void remove_string_from_hash_table(const std::string& s);

#endif
