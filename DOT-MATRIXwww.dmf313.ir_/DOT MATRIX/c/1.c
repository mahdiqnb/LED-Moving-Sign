#include <mega16.h>
#include <delay.h>

flash unsigned char image1[8]=
{
    0x00,    //    0001        . . . . . . . . 
    0x00,    //    0002        . . . . . . . . 
    0x00,    //    0003        . . . . . . . . 
    0xFF,    //    0004        # # # # # # # # 
    0xFF,    //    0005        # # # # # # # # 
    0x00,    //    0006        . . . . . . . . 
	0x00,	 //	   0007		   . . . . . . . . 
	0x00 	 //	   0008		   . . . . . . . .  
};
flash unsigned char image2[8]=
{
	0x00,	//	0001		. . . . . . . . 
	0xFF,	//	0002		# # # # # # # # 
	0xFF,	//	0003		# # # # # # # # 
	0x0C,	//	0004		. . . . # # . . 
	0x0C,	//	0005		. . . . # # . . 
	0x0F,	//	0006		. . . . # # # # 
	0x0F,	//	0007		. . . . # # # # 
	0x00 	//	0008		. . . . . . . . 
};
flash unsigned char image3[8]=
{
	0x00,	//	0001		. . . . . . . . 
	0xFE,	//	0002		# # # # # # # . 
	0xFE,	//	0003		# # # # # # # . 
	0x08,	//	0004		. . . . # . . . 
	0x0E,	//	0005		. . . . # # # . 
	0x08,	//	0006		. . . . # . . . 
	0x0E,	//	0007		. . . . # # # . 
	0x0E 	//	0008		. . . . # # # . 
};
flash unsigned char image4[8]=
{
	0x1E,	//	0001		. . . # # # # . 
	0x1E,	//	0002		. . . # # # # . 
	0x18,	//	0003		. . . # # . . . 
	0xD8,	//	0004		# # . # # . . . 
	0xD8,	//	0005		# # . # # . . . 
	0x18,	//	0006		. . . # # . . . 
	0x1E,	//	0007		. . . # # # # . 
	0x1E 	//	0008		. . . # # # # . 
};
flash unsigned char image5[8]=
{
	0x00,	//	0001		. . . . . . . . 
	0x30,	//	0002		. . # # . . . . 
	0x60,	//	0003		. # # . . . . . 
	0x40,	//	0004		. # . . . . . . 
	0x40,	//	0005		. # . . . . . . 
	0x60,	//	0006		. # # . . . . . 
	0x3F,	//	0007		. . # # # # # # 
	0x00 	//	0008		. . . . . . . . 
};
flash unsigned char image6[8]=
{
	0x70,	//	0001		. # # # . . . . 
	0x40,	//	0002		. # . . . . . . 
	0x40,	//	0003		. # . . . . . . 
	0x40,	//	0004		. # . . . . . . 
	0x40,	//	0005		. # . . . . . . 
	0x5C,	//	0006		. # . # # # . . 
	0x5D,	//	0007		. # . # # # . # 
	0x7C 	//	0008		. # # # # # . . 
};

flash char faal_saz[8]={0B11111110,0B11111101,0B11111011,0B11110111,0B11101111,0B11011111,0B10111111,0B01111111,};


void main(void)
{
    unsigned int i=0,timer=0;
    
    DDRA=0xFF;
    DDRB=0xFF;
    
    while (1)
    {
        for(timer=0;timer<=40;timer++)
            for(i=0;i<=7;i++)
            {            
                PORTA=image1[i];
                PORTB=faal_saz[i];
                delay_ms(5);
                PORTA=0;PORTB=255;
            }
            
        for(timer=0;timer<=40;timer++)
            for(i=0;i<=7;i++)
            {            
                PORTA=image2[i];
                PORTB=faal_saz[i];
                delay_ms(5);
                PORTA=0;PORTB=255;
            }
            
        for(timer=0;timer<=40;timer++)
            for(i=0;i<=7;i++)
            {            
                PORTA=image3[i];
                PORTB=faal_saz[i];
                delay_ms(5);
                PORTA=0;PORTB=255;
            }
            
        for(timer=0;timer<=40;timer++)
            for(i=0;i<=7;i++)
            {            
                PORTA=image4[i];
                PORTB=faal_saz[i];
                delay_ms(5);
                PORTA=0;PORTB=255;
            }
        
        for(timer=0;timer<=40;timer++)
            for(i=0;i<=7;i++)
            {            
                PORTA=image5[i];
                PORTB=faal_saz[i];
                delay_ms(5);
                PORTA=0;PORTB=255;
            }
            
        for(timer=0;timer<=40;timer++)
            for(i=0;i<=7;i++)
            {            
                PORTA=image6[i];
                PORTB=faal_saz[i];
                delay_ms(5);
                PORTA=0;PORTB=255;
            }  
    }
}