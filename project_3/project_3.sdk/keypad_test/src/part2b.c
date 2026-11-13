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
#include "xparameters.h"
#include "xil_io.h"
#include "PmodKYPD.h"
#include "sleep.h"

extern char inbyte(void);

#define DEFAULT_KEYTABLE "0FED789C456B123A"

PmodKYPD myDevice;

// Read player 1's choice from PuTTY
int getPCMove()
{
    char c;
    int move;

    while (1)
    {
        xil_printf("\r\nPlayer 1: Enter 1, 2, or 3: ");

        c = inbyte();

        // Ignore leftover Enter characters
        while (c == '\r' || c == '\n')
            c = inbyte();

        move = 0;

        if (c >= '1' && c <= '3')
            move = c - '0';

        // Consume the rest of the line
        while (c != '\r' && c != '\n')
        {
            c = inbyte();

            // Reject extra characters
            if (c != '\r' && c != '\n')
                move = 0;
        }

        if (move >= 1 && move <= 3)
            return move;

        xil_printf("\r\nInvalid input! Try again.\r\n");
    }
}

// Read player 2's choice from keypad
int getKeypadMove()
{
    u16 keystate;
    u8 key;
    u32 status;
    int move;

    xil_printf("\r\nPlayer 2: Press 1, 2, or 3 on keypad.\r\n");

    // Wait until no key is pressed
    do
    {
        keystate = KYPD_getKeyStates(&myDevice);
        status = KYPD_getKeyPressed(
            &myDevice, keystate, &key);
        usleep(10000);
    }
    while (status != KYPD_NO_KEY);

    while (1)
    {
        keystate = KYPD_getKeyStates(&myDevice);

        status = KYPD_getKeyPressed(
            &myDevice, keystate, &key);

        if (status == KYPD_SINGLE_KEY)
        {
            if (key == '1' || key == '2' || key == '3')
            {
                move = key - '0';

                // Wait for key release
                do
                {
                    usleep(10000);
                    keystate = KYPD_getKeyStates(&myDevice);
                    status = KYPD_getKeyPressed(
                        &myDevice, keystate, &key);
                }
                while (status != KYPD_NO_KEY);

                return move;
            }
        }

        usleep(10000);
    }
}

// Convert move number into name
const char* moveName(int move)
{
    if (move == 1)
        return "Rock";
    else if (move == 2)
        return "Paper";
    else
        return "Scissors";
}

// Compare moves and determine winner
void determineWinner(int pc, int fpga)
{
    xil_printf("\r\nPlayer 1 chose: %s\r\n",
               moveName(pc));

    xil_printf("FPGA chose: %s\r\n",
               moveName(fpga));

    if (pc == fpga)
    {
        xil_printf("It's a tie!\r\n");
    }
    else if ((pc == 1 && fpga == 3) ||
             (pc == 2 && fpga == 1) ||
             (pc == 3 && fpga == 2))
    {
        xil_printf("Player 1 wins!\r\n");
    }
    else
    {
        xil_printf("FPGA wins!\r\n");
    }
}

int main()
{
    int pcMove;
    int fpgaMove;

    init_platform();

    // Initialize keypad
    KYPD_begin(&myDevice,
        XPAR_PMODKYPD_0_AXI_LITE_GPIO_BASEADDR);

    KYPD_loadKeyTable(
        &myDevice, (u8*)DEFAULT_KEYTABLE);

    Xil_Out32(myDevice.GPIO_addr, 0xF);

    xil_printf("\r\n========================\r\n");
    xil_printf(" ROCK PAPER SCISSORS\r\n");
    xil_printf("========================\r\n");

    xil_printf("\r\n1 = Rock\r\n");
    xil_printf("2 = Paper\r\n");
    xil_printf("3 = Scissors\r\n");

    while (1)
    {
        pcMove = getPCMove();

        fpgaMove = getKeypadMove();

        determineWinner(pcMove, fpgaMove);

        xil_printf("\r\nStarting next round...\r\n");
    }

    cleanup_platform();
    return 0;
}


