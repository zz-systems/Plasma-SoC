cmake_minimum_required(VERSION 2.8.1)
project(plasma-examples)

include_directories(include)

# LED blinking example
add_executable(blink src/blink.c)
target_link_libraries(blink kernel)
postprocess_binary(blink)

add_executable(blink_with_drivers src/blink_with_drivers.c)
target_link_libraries(blink_with_drivers kernel)
postprocess_binary(blink_with_drivers)

add_executable(oled_hello_world src/oled_hello_world.c)
target_link_libraries(oled_hello_world kernel)
postprocess_binary(oled_hello_world)


add_executable(uart_hello_world src/uart_hello_world.c)
target_link_libraries(uart_hello_world kernel)
postprocess_binary(uart_hello_world)