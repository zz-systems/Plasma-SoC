cmake_minimum_required(VERSION 2.8.1)
project(plasma-firmware)

include_directories(include)

set_source_files_properties(
        src/boot.asm
        src/crt.asm
        src/vectortable.asm
        PROPERTIES COMPILE_FLAGS "-x assembler-with-cpp")

add_library(stdlib STATIC       src/stdlib/file.c
                                src/stdlib/string.c
                                src/stdlib/memory.c)

target_link_libraries(stdlib PUBLIC linker_cfg kernel)

add_library(drivers STATIC      src/drivers/uart.c
                                src/drivers/irc.c
                                src/drivers/counter.c
                                src/drivers/timer.c
                                src/drivers/display.c)

target_link_libraries(drivers PUBLIC linker_cfg kernel)

add_library(kernel STATIC       src/vectortable.asm 
                                src/crt.asm 
                                src/kernel/io.c
                                src/kernel/device.c
                                src/kernel/kernel.c
                                src/kernel/interrupt.c
                                src/kernel/memory.c
                                src/kernel/init.c)

target_include_directories(kernel INTERFACE include)
target_link_libraries(kernel PUBLIC linker_cfg drivers stdlib)


