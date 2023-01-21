#include <mega32.h>
#include <io.h>
#include <glcd.h>
#include <font5x7.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>
#include <display.h>
flash int keycode[4][4]={{0,1,2,3},{4,5,6,7},{8,9,10,11},{12,13,14,15}};
char input=16,IT=0,cnt0=0,set=0,dis,x=0,y=0,cnt2,cnt4,cnt5,cnt6,cnt8,cnt9,cnt10,cnt12,cnt13,cnt14,crt,backcnt,str[256],i;
volatile char alpha=1;
interrupt [EXT_INT0] void ext_int0_isr(void)
{

char temp=0,col=10,row=10;

temp=(PINC &0X0F);
if(temp ==14)
row=0;
if(temp ==13)
row=1;
if(temp ==11)
row=2;
if(temp ==7)
row=3;


delay_ms(20);

PORTC=0XEF;
delay_us(50);
if((PINC&0X0F)!=0X0F)
col=0;

else
{
PORTC=0XDF;
delay_us(50);
if((PINC &0X0F)!=0X0F)
col=1;
else
{
PORTC=0xBF;
delay_us(50);
if((PINC&0X0F)!=0X0F)
col=2;
else
{
PORTC=0x7F;
delay_us(50);
if((PINC&0X0F)!=0X0F)
col=3;
}
}
}

input=keycode[row][col];

PORTC=0X0F;
IT=1;

while(PIND.2==0);

}
void main(void)
{

GLCDINIT_t glcd_init_data;
DDRC=0XF0;
PORTC=0X0F;
DDRD.0=0;
DDRD.1=1;
DDRD.2=0;
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;


// Graphic Display Controller initialization
// The KS0108 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// DB0 - PORTA Bit 0
// DB1 - PORTA Bit 1
// DB2 - PORTA Bit 2
// DB3 - PORTA Bit 3
// DB4 - PORTA Bit 4
// DB5 - PORTA Bit 5
// DB6 - PORTA Bit 6
// DB7 - PORTA Bit 7
// E - PORTB Bit 0
// RD /WR - PORTB Bit 1
// RS - PORTB Bit 2
// /RST - PORTB Bit 3
// CS1 - PORTB Bit 4
// CS2 - PORTB Bit 5

// Specify the current font for displaying text
glcd_init_data.font=font5x7;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;

glcd_init(&glcd_init_data);
 // External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Low level
// INT1: Off
// INT2: Off
GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);

// Global enable interrupts
#asm("sei")
while (1)
      {       
if(IT==1)
   {  

    if(alpha==1) 
    dis_alpha(); 
    
   
    if(alpha==0)  
    dis_num();  

   }
  } 
}