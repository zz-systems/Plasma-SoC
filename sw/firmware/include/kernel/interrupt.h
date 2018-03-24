#pragma once

#define IR_UART_READ    (1 << 0)
#define IR_UART_WRITE   (1 << 1)
#define IR_CNT_OVERFLOW (1 << 2)

typedef void (*ir_handler)(void);
//typedef void (*ir_handler)(unsigned);
void kregister_ir_handler(ir_handler handler, unsigned ir_flag);