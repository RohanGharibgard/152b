/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */



#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xgpio.h"
#include "xparameters.h"

extern char inbyte(void);

int main()
{
    int a, b, product;
    char c;

    init_platform();

    XGpio led_gpio;

    XGpio_Initialize(&led_gpio, XPAR_AXI_GPIO_0_DEVICE_ID);
    XGpio_SetDataDirection(&led_gpio, 1, 0xF);
    XGpio_SetDataDirection(&led_gpio, 2, 0x0000);

    // Turn off all LEDs initially
    XGpio_DiscreteWrite(&led_gpio, 2, 0x0000);

    xil_printf("Multiplication Program\r\n");

    while (1)
    {
        a = 0;
        b = 0;

        xil_printf("\r\nEnter two numbers (8/6): ");

        // Read first number
        c = inbyte();

        while (c >= '0' && c <= '9')
        {
            a = a * 10 + (c - '0');
            c = inbyte();
        }

        // Read second number
        if (c == '/')
        {
            c = inbyte();

            while (c >= '0' && c <= '9')
            {
                b = b * 10 + (c - '0');
                c = inbyte();
            }

            product = a * b;

            xil_printf("\r\nProduct: %d\r\n", product);

            if (product > 100)
            {
                XGpio_DiscreteWrite(&led_gpio, 2, 0x0001);
            }
            else
            {
                XGpio_DiscreteWrite(&led_gpio, 2, 0x0000);
            }
        }
        else
        {
            xil_printf("\r\nInvalid input\r\n");
        }
    }

    cleanup_platform();
    return 0;
}


