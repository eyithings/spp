#include "hash.h"

std::unordered_set<std::string> global_hash_table;

/* Hash function shamelessly copied from
 * https://cseweb.ucsd.edu/~kube/cls/100/Lectures/lec16/lec16-16.html#pgfId-977548
 */
hash_type get_string_hash(const std::string& s)
{
    hash_type hashval = 0;
    for (auto c : s)
    {
        hashval = (hashval << 4) + static_cast<hash_type>(c);
        hash_type g = hashval & 0xF0000000;
        if (g != 0)
            hashval ^= g >> 24;
        hashval &= ~g;
    }
    return hashval;
}

int get_string_index(const std::string& s, hash_type* h)
{
    hash_type tmp = get_string_hash(s);
    if (h)
        *h = tmp;
    return static_cast<int>(tmp % HASH_TABLE_SIZE);
}

const std::string* find_string_in_hash_table(const std::string& s)
{
    auto it = global_hash_table.find(s);
    if (it != global_hash_table.end())
        return &(*it);
    return nullptr;
}

void add_string_to_hash_table(const std::string& s)
{
    global_hash_table.insert(s);
}

void remove_string_from_hash_table(const std::string& s)
{
    global_hash_table.erase(s);
}

bool is_string_in_hash_table(const std::string& s)
{
    return global_hash_table.find(s) != global_hash_table.end();
}
