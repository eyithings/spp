cmake_minimum_required(VERSION 3.14)

project(spp VERSION 1.0)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_EXTENSIONS OFF)

file(GLOB_RECURSE SOURCES "src/*.cpp" "src/*.c")
add_executable(spp ${SOURCES})

if(DEFINED ENV{DEBUG})
  target_compile_definitions(spp PUBLIC -DDEBUG)
  target_compile_options(spp PRIVATE -g -O0)
else()
  target_compile_options(spp PRIVATE -O3 -Werror)
endif()
target_compile_options(spp PRIVATE -Wall -Wextra -pedantic)

add_subdirectory(tests)

include(GNUInstallDirs)
install(
  TARGETS spp
  DESTINATION ${CMAKE_INSTALL_BINDIR}
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
              GROUP_READ GROUP_EXECUTE
              WORLD_READ WORLD_EXECUTE
)

