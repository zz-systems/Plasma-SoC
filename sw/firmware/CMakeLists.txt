cmake_minimum_required(VERSION 2.8.1)
project(plasma-firmware)

include_directories(include)

set_source_files_properties(
        src/boot.asm
        src/crt.asm
        src/vectortable.asm
        PROPERTIES COMPILE_FLAGS "-x assembler-with-cpp")

add_library(linker_cfg INTERFACE)

target_link_libraries(
        linker_cfg
        INTERFACE
        "-Wl,-Ttext,0x0,-eentry,-Map,test.map,-s,-N")

target_include_directories(linker_cfg INTERFACE include)
#target_include_directories(linker_cfg2 INTERFACE include)

add_library(firmware STATIC src/boot.asm src/no_os.c)
target_link_libraries(firmware PUBLIC linker_cfg)

add_library(firmware_new STATIC src/vectortable.asm src/no_os.c src/crt.asm)
target_include_directories(firmware_new INTERFACE include)
target_link_libraries(firmware_new PUBLIC linker_cfg2)


