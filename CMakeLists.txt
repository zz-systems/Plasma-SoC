cmake_minimum_required(VERSION 2.8.1)

project(plasmax)
enable_language(C ASM)

set(CMAKE_C_FLAGS   ${CMAKE_C_FLAGS}    "-Wall -s -fno-pic -mips1 -mgp32 -mfp32 -mno-abicalls -nostdlib")
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}  "-Wall -s -fno-pic -mips1 -mgp32 -mfp32 -mno-abicalls -nostdlib")
set(CMAKE_ASM_FLAGS ${CMAKE_ASM_FLAGS}  "-Wall -s -fno-pic -mips1 -mgp32 -mfp32 -mno-abicalls -nostdlib")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

add_subdirectory(dependencies/PlasmaConvert)
add_subdirectory(sw)
