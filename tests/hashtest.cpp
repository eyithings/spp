#include <hash.h>
#include <gtest/gtest.h>

namespace
{

    TEST(HashTest, ConsistentHash)
    {
        std::string testString = "test";
        std::string testString2 = "test";
        hash_type firstHash = get_string_hash(testString);
        hash_type secondHash = get_string_hash(testString2);
        ASSERT_EQ(firstHash, secondHash);
    }

    TEST(HashTest, DifferentStringsDifferentHash)
    {
        std::string string1 = "test1";
        std::string string2 = "test2";
        ASSERT_NE(get_string_hash(string1), get_string_hash(string2));

        string1 = "test";
        string2 = "TEST";
        ASSERT_NE(get_string_hash(string1), get_string_hash(string2));

        string1 = "test";
        string2 = "tEst ";
        ASSERT_NE(get_string_hash(string1), get_string_hash(string2));
    }

    TEST(HashTest, IndexInRange)
    {
        std::string testString = "test";
        hash_type hash;
        int index = get_string_index(testString, &hash);
        ASSERT_GE(index, 0);
        ASSERT_LT(index, 256);

        testString = "Why, hello there! Let's test this hash function!";
        index = get_string_index(testString, &hash);
        ASSERT_GE(index, 0);
        ASSERT_LT(index, 256);

        testString = "This is a very long string that should produce a hash"
                     "index within the range of the hash table. Is it really"
                     "long enough? What if it was 256 * 256 in length? Let's"
                     "find out!";
        index = get_string_index(testString, &hash);
        ASSERT_GE(index, 0);
        ASSERT_LT(index, 256);
    }

    TEST(HashTest, FindExistingString)
    {
        std::string testString = "Let's talk about Donlald Trump!";
        add_string_to_hash_table(testString);
        const std::string* result = find_string_in_hash_table(testString);
        ASSERT_NE(result, nullptr);
        if (result)
            ASSERT_EQ(*result, testString);
        remove_string_from_hash_table(testString);
    }

    TEST(HashTest, FindNonExistingString)
    {
        std::string testString = "nonExisting";
        const std::string* result = find_string_in_hash_table(testString);
        ASSERT_EQ(result, nullptr);
    }

}
