cmake_minimum_required(VERSION 2.8.1)
project(plasma-examples)

include_directories(include)

add_executable(dump_sections src/dump_sections.c)
target_link_libraries(dump_sections kernel)
postprocess_binary(dump_sections)

add_executable(sample.zedboard src/sample.zedboard.c)
target_compile_definitions(kernel INTERFACE PLATFORM=zedboard)
target_link_libraries(sample.zedboard kernel)
postprocess_binary(sample.zedboard)

add_executable(sample.de1_soc src/sample.de1_soc.c)
target_compile_definitions(kernel INTERFACE PLATFORM=de1_soc)
target_link_libraries(sample.de1_soc kernel)
postprocess_binary(sample.de1_soc)