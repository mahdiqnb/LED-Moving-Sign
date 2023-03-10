#include <mega16.h>
#include <delay.h>

char image[8];
char data[48]=
{
    0x00,    //  0001        . . . . . . . . 
    0x00,    //  0002        . . . . . . . . 
    0x00,    //  0003        . . . . . . . . 
    0xFF,    //  0004        # # # # # # # # 
    0xFF,    //  0005        # # # # # # # # 
    0x00,    //  0006        . . . . . . . . 
	0x00,	 //	 0007		 . . . . . . . . 
	0x00, 	 //	 0008		 . . . . . . . . 
    
	0x00,	//	0009		. . . . . . . . 
	0xFF,	//	0010		# # # # # # # # 
	0xFF,	//	0011		# # # # # # # # 
	0x0C,	//	0012		. . . . # # . . 
	0x0C,	//	0013		. . . . # # . . 
	0x0F,	//	0014		. . . . # # # # 
	0x0F,	//	0015		. . . . # # # # 
	0x00, 	//	0016		. . . . . . . .
    
	0x00,	//	0017		. . . . . . . . 
	0xFE,	//	0018		# # # # # # # . 
	0xFE,	//	0019		# # # # # # # . 
	0x08,	//	0020		. . . . # . . . 
	0x0E,	//	0021		. . . . # # # . 
	0x08,	//	0022		. . . . # . . . 
	0x0E,	//	0023		. . . . # # # . 
	0x0E, 	//	0024		. . . . # # # . 
    
	0x1E,	//	0025		. . . # # # # . 
	0x1E,	//	0026		. . . # # # # . 
	0x18,	//	0027		. . . # # . . . 
	0xD8,	//	0028		# # . # # . . . 
	0xD8,	//	0029		# # . # # . . . 
	0x18,	//	0030		. . . # # . . . 
	0x1E,	//	0031		. . . # # # # . 
	0x1E, 	//	0032		. . . # # # # . 
    
	0x00,	//	0033		. . . . . . . . 
	0x30,	//	0034		. . # # . . . . 
	0x60,	//	0035		. # # . . . . . 
	0x40,	//	0036		. # . . . . . . 
	0x40,	//	0037		. # . . . . . . 
	0x60,	//	0038		. # # . . . . . 
	0x3F,	//	0039		. . # # # # # # 
	0x00, 	//	0040		. . . . . . . . 
    
	0x70,	//	0041		. # # # . . . . 
	0x40,	//	0042		. # . . . . . . 
	0x40,	//	0043		. # . . . . . . 
	0x40,	//	0044		. # . . . . . . 
	0x40,	//	0045		. # . . . . . . 
	0x5C,	//	0046		. # . # # # . . 
	0x5D,	//	0047		. # . # # # . # 
	0x7C 	//	0048		. # # # # # . .    
};

char faal_saz[8]={0B11111110,0B11111101,0B11111011,0B11110111,0B11101111,0B11011111,0B10111111,0B01111111,};


void main(void)
{
    unsigned int i=0,timer=0,number_char=0,j=0;
    
    DDRA=0xFF;
    DDRB=0xFF;
    
    while (1)
    {
        for(number_char=0;number_char<=5;number_char++)
        { 
            if(number_char==0)     for(j=0;j<=7;j++)  image[j]=data[j];
            else if(number_char==1)for(j=8;j<=15;j++) image[j]=data[j];
            else if(number_char==2)for(j=16;j<=23;j++)image[j]=data[j];
            else if(number_char==3)for(j=24;j<=31;j++)image[j]=data[j];
            else if(number_char==4)for(j=32;j<=39;j++)image[j]=data[j];
            else if(number_char==5)for(j=40;j<=47;j++)image[j]=data[j];
            
                    
            for(timer=0;timer<=4;timer++)
                for(i=0;i<=7;i++)
                {            
                    PORTA=image[i];
                    PORTB=faal_saz[i];
                    delay_ms(5);
                    PORTA=0;PORTB=255;
                }
        }
    }
}