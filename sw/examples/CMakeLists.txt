cmake_minimum_required(VERSION 2.8.1)
project(plasma-examples)

include_directories(include)

# LED blinking example
add_executable(blink src/blink.c)
target_link_libraries(blink firmware)
postprocess_binary(blink)

add_executable(oled_hello_world src/oled_hello_world.c)
target_link_libraries(oled_hello_world firmware)
postprocess_binary(oled_hello_world)


add_executable(uart_hello_world src/uart_hello_world.c)
target_link_libraries(uart_hello_world firmware)
postprocess_binary(uart_hello_world)