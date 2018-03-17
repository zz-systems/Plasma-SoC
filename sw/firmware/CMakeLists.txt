cmake_minimum_required(VERSION 2.8.1)
project(plasma-firmware)

include_directories(include)

set_source_files_properties(
        src/boot.asm
        src/crt.asm
        src/vectortable.asm
        PROPERTIES COMPILE_FLAGS "-x assembler-with-cpp")


add_library(firmware STATIC src/vectortable.asm src/no_os.c src/crt.asm)
target_include_directories(firmware INTERFACE include)
target_link_libraries(firmware PUBLIC linker_cfg)


