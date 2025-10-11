cmake_minimum_required(VERSION 3.14)
project(sppTests)

include(FetchContent)

# v1.16.x
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/6910c9d9165801d8827d628cb72eb7ea9dd538c5.zip
  DOWNLOAD_EXTRACT_TIMESTAMP true
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()

include_directories(../src)
file(GLOB TEST_SOURCES "*.cpp")
file(GLOB_RECURSE SOURCES "../src/*.cpp" "../src/*.c")
list(FILTER SOURCES EXCLUDE REGEX ".*main.cpp")
add_executable(${PROJECT_NAME} ${TEST_SOURCES} ${SOURCES})
target_link_libraries(${PROJECT_NAME} ${GTEST_LIBRARIES} gtest_main pthread)
add_test(NAME ${PROJECT_NAME} COMMAND ${PROJECT_NAME})

# gmock unused
target_compile_definitions(sppTests PUBLIC BUILD_GMOCK=OFF)

add_custom_target(tests COMMAND ${CMAKE_CTEST_COMMAND} -V)
