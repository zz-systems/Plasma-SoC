cmake_minimum_required(VERSION 2.8.1)
project(plasma-examples)

include_directories(include)

# LED blinking example
add_executable(blink src/blink.c)
target_link_libraries(blink firmware)
postprocess_binary(blink)

add_executable(blink_new src/blink.c)
target_link_libraries(blink_new firmware_new)
postprocess_binary(blink_new)

add_executable(oled_hello_world src/oled_hello_world.c)
target_link_libraries(oled_hello_world firmware)
postprocess_binary(oled_hello_world)


add_executable(uart_hello_world src/uart_hello_world.c)
target_link_libraries(uart_hello_world firmware)
postprocess_binary(uart_hello_world)


add_executable(test_old src/test.c)
target_link_libraries(test_old firmware)
postprocess_binary(test_old)


add_executable(test_new src/testnew.c)
target_link_libraries(test_new firmware_new)
postprocess_binary_new(test_new)