#include <mega32.h>
#include <io.h>
#include <display.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>
#include <alpha.h>
#include <Stdlib.h>

#define up      1
#define down    0


char *Rx_Display,*Display1,*Display2,*Display3,*Display4,contin=0,mul=0;
unsigned char receive=0,finish=0,cnt=0,flag=0,dis[4],show[256],show1[256],done=0,j,sh_cnt=0,sh1_cnt=0,sh2_cnt=0,rr[4];
    

void Search_dis(char *dis,char i)
{

if(dis[i]=='A')
Rx_Display=A;
else
if(dis[i]=='B')
Rx_Display=B;
else
if(dis[i]=='C')
Rx_Display=C;
else
if(dis[i]=='D')
Rx_Display=D;
else
if(dis[i]=='E')
Rx_Display=E;
else
if(dis[i]=='F')
Rx_Display=F;
else
if(dis[i]=='G')
Rx_Display=G;
else
if(dis[i]=='H')
Rx_Display=H;
else
if(dis[i]=='I')
Rx_Display=_I;
else
if(dis[i]=='J')
Rx_Display=_J;
else
if(dis[i]=='K')
Rx_Display=K;
else
if(dis[i]=='L')
Rx_Display=L;
else
if(dis[i]=='M')
Rx_Display=M;
else
if(dis[i]=='N')
Rx_Display=N;
else 
if(dis[i]=='O')
Rx_Display=O;
else
if(dis[i]=='P')
Rx_Display=P;
else
if(dis[i]=='Q')
Rx_Display=Q;
else
if(dis[i]=='R')
Rx_Display=R;
else
if(dis[i]=='S')
Rx_Display=S;
else
if(dis[i]=='T')
Rx_Display=T;
else
if(dis[i]=='U')
Rx_Display=U;
else
if(dis[i]=='V')
Rx_Display=V;
else
if(dis[i]=='W')
Rx_Display=W;
else
if(dis[i]=='X')
Rx_Display=X;
else
if(dis[i]=='Y')
Rx_Display=Y;
else
if(dis[i]=='Z')
Rx_Display=Z;
else
if(dis[i]=='0')
Rx_Display=_0;
else
if(dis[i]=='1')
Rx_Display=_1;
else
if(dis[i]=='2')
Rx_Display=_2;
else
if(dis[i]=='3')
Rx_Display=_3;
else
if(dis[i]=='4')
Rx_Display=_4;
else
if(dis[i]=='5')
Rx_Display=_5;
else
if(dis[i]=='6')
Rx_Display=_6;
else
if(dis[i]=='7')
Rx_Display=_7;
else
if(dis[i]=='8')
Rx_Display=_8;
else
if(dis[i]=='9')
Rx_Display=_9;
else
if(dis[i]=='#')
Rx_Display=_Square;
else
if(dis[i]==',')
Rx_Display=_comma;
else
if(dis[i]=='.')
Rx_Display=_dot;
else
if(dis[i]=='^')
Rx_Display=_power;
else
if(dis[i]=='%')
Rx_Display=_per;
else
if(dis[i]=='*')
Rx_Display=star;
else
if(dis[i]=='@')
Rx_Display=_Ad;
else
if(dis[i]=='$')
Rx_Display=_dollor;
else
if(dis[i]=='&')
Rx_Display=and; 
else
if(dis[i]==0x00)
Rx_Display=_empty; 
}

char ID(void)
{
return (PINB & 0x0f);
}

interrupt [USART_RXC] void usart_rx_isr(void)
{


     receive=UDR; 
         if(flag==1)
     { 

                         
            if(receive=='{')
            { 
            
                finish=0;
                cnt=0;
                memset(dis,0,4); 
            
                    if(done==1)
                    {   
                    
                        memset(show,0,4);
                        memset(show1,0,4);
                        sh_cnt=0;
                        sh1_cnt=0;
                        done=0; 
            
                }
            } 
            
            else    
            
                if(receive==0xff) 
                { 
                
                    finish=1;
                    memset(dis,0,4);
                    sh2_cnt=sh1_cnt;
                                                
                    for(j=sh_cnt;j<=sh1_cnt;j++)
                    {  
                                    
                    show[sh_cnt]=show1[j];
                    sh_cnt++; 
                    sh2_cnt++; 
                                    
                        if(sh2_cnt>sh1_cnt)
                           sh2_cnt=0;
                                   
                        if(sh_cnt>=255)
                          sh_cnt=0;
                
                }
                } 
            
            else
            
                if(receive=='}')
                {
                
                    if(finish!=1)
                    {
                                      
                        for(j=0;j<=cnt;j++) 
                        { 
                                     
                            if((dis[j]!=0x00)&&(dis[j]!=0x07))
                            {
                            show1[sh1_cnt]=dis[j];
                            sh1_cnt++; 
                            } 
                
                    else
                     j++;
            
                            if(sh1_cnt>=255)
                              sh1_cnt=0;  
                         
                    }
                    
           
            } 
            
            else  
             
                if(finish==1)
            
                done=1;
            
                 
            flag=0; 
            
            }            

            else  
            { 
            
                if(receive!=0x0A)         
                { 
                
                dis[cnt]=receive; 
                cnt++;
            
            }
     }
    }
    
     if(receive==ID())
     
     flag=1;
     
 
}

void WELL_COME(void)
{
    char t=0,delay;
    if(ID()==1)       //for local one 
    {  
        Display1=E;      //show E
    Display2=_empty;
    Display3=_empty;
    Display4=_empty;    
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4);  
    
        Display1=M;      //show CE
    Display2=E;
    Display3=_empty;
    Display4=_empty;    
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
      
    Display1=O;         //SHOW OME
    Display2=M;
    Display3=E;
    Display4=_empty;    
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
    Display1=C;       //SJOW COME
    Display2=O;
    Display3=M;
    Display4=E;    
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4);  
   
    Display1=_empty;         //SHOW COM 
    Display2=C;
    Display3=O;
    Display4=M; 
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4);  
     Display1=L;           //SHOW l CO 
    Display2=_empty;
    Display3=C;
    Display4=O; 
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4);      
    Display1=E;             //SHOW EL C
    Display2=L;
    Display3=_empty;
    Display4=C;
        
    for(delay=0;delay<255;delay++) 
    display(Display1,Display2,Display3,Display4); 
         
    Display1=W;                 //SHOW WEL   (SPACE) 
    Display2=E;
    Display3=L;
    Display4=_empty;    
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
    Display1=_empty;
    Display2=W;                  //SHOW WEL
    Display3=E;
    Display4=L;    
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
    Display1=_empty;               //SHOW WE
    Display2=_empty;                  
    Display3=W;
    Display4=E;    
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
                Display1=_empty;
    Display2=_empty;                 //SHOW W
    Display3=_empty;
    Display4=W;    
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
        Display1=_empty;
        Display2=_empty;
        Display3=_empty;
        Display4=_empty;    
        for(t=0;t<=4;t++) 
             for(delay=0;delay<255;delay++)
     display(Display1,Display2,Display3,Display4); 
     }   
         if(ID()==2)
    {  
    
        Display1=_empty;
        Display2=_empty;
        Display3=_empty;
        Display4=_empty;    
        for(t=0;t<4;t++) 
    for(delay=0;delay<255;delay++)
     display(Display1,Display2,Display3,Display4); 
        Display1=E;
    Display2=_empty;
    Display3=_empty;
    Display4=_empty;    
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4);  
    
        Display1=M;
    Display2=E;
    Display3=_empty;
    Display4=_empty;    
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
      
    Display1=O;
    Display2=M;
    Display3=E;
    Display4=_empty;    
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
    Display1=C;
    Display2=O;
    Display3=M;
    Display4=E;    
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4);  
   
    Display1=L;
    Display2=C;
    Display3=O;
    Display4=M; 
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4);  
     Display1=L;
    Display2=L;
    Display3=C;
    Display4=O; 
                   
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4);      
    Display1=E;
    Display2=L;
    Display3=L;
    Display4=C;
        
    for(delay=0;delay<255;delay++) 
    display(Display1,Display2,Display3,Display4); 
         
    Display1=W;
    Display2=E;
    Display3=L;
    Display4=L;    
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
    Display1=_empty;
    Display2=W;
    Display3=E;
    Display4=L;    
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
    Display1=_empty;
    Display2=_empty;
    Display3=W;
    Display4=E;    
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
                Display1=_empty;
    Display2=_empty;
    Display3=_empty;
    Display4=W;    
    for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
    Display1=_empty;
        Display2=_empty;
        Display3=_empty;
        Display4=_empty;  
         for(delay=0;delay<255;delay++)
    display(Display1,Display2,Display3,Display4); 
     }


}



void main(void)
{
  char delay=0,t,well_come_massage=1; 

    char le;
    unsigned int data_ln=0;
    DDRC=0xFF;
    DDRA=0xFF; 
    DDRB=0XF0;
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: Off
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;
// Global enable interrupts
#asm("sei")
    while (1)
    {  
  
 
      if(done==1)
      {
      well_come_massage=0;
      Display1=_empty;
        Display2=_empty;
        Display3=_empty;
        Display4=_empty;      
      for(t=0;t<255;t++)
      {
       if(show[t]==0x00)
       break;
      }
  
      data_ln =t;
      rr[1]=data_ln;
      if(data_ln>4)  
     {  
     data_ln=data_ln/4;
       for(le=0;le<data_ln;le++)
       {
        Search_dis(show,(le*4));
        Display1=Rx_Display;
        Rx_Display=0;
        Search_dis(show,(le*4)+1);
        Display2=Rx_Display;
        Rx_Display=0;
        Search_dis(show,(le*4)+2);
        Display3=Rx_Display;
        Rx_Display=0;
        Search_dis(show,(le*4)+3);
        Display4=Rx_Display;
        Rx_Display=0;
         for(t=0;t<5;t++)     
        for(delay=0;delay<255;delay++)
        display(Display1,Display2,Display3,Display4);      
        Display1=_empty;
        Display2=_empty;
        Display3=_empty;
        Display4=_empty;  
 
      }  
      mul=data_ln*4;
      rr[0]=mul;   

      data_ln=rr[1]-rr[0]; 
      
      contin=1;
      }
        if(contin==1)
        {

            if(data_ln==3)
            {   
                Search_dis(show,mul);
                Display1=Rx_Display;
                Rx_Display=0;
                Search_dis(show,mul+1);
                Display2=Rx_Display;
                Rx_Display=0;
                Search_dis(show,mul+2);
                Display3=Rx_Display;
                Rx_Display=0;

            }
            if(data_ln==2)
            {       
                Search_dis(show,mul);
                Display1=Rx_Display;
                Rx_Display=0;
                Search_dis(show,mul+1);
                Display2=Rx_Display;
                Rx_Display=0;
                Display3=_empty;
                Display4=_empty;

            }
            if(data_ln==1)
            {          
            
                Search_dis(show,mul);
                Display1=Rx_Display;
                Rx_Display=0;
                Display2=_empty;
                Display3=_empty;
                Display4=_empty;

            } 
              for(t=0;t<5;t++) 
          for(delay=0;delay<255;delay++)
     display(Display1,Display2,Display3,Display4) ; 

      

      }
      else if(contin==0)
      {
             if(data_ln==4)
            {   
            Display1=_empty;
                Display2=_empty;
                Display3=_empty;
                Display4=_empty;
                Search_dis(show,0);
                Display1=Rx_Display;
                Rx_Display=0;
                Search_dis(show,1);
                Display2=Rx_Display;
                Rx_Display=0;
                Search_dis(show,2);
                Display3=Rx_Display;
                 Rx_Display=0;  
                 Search_dis(show,3);
                Display4=Rx_Display;
                 Rx_Display=0;

            }

            if(data_ln==3)
            {   
            Display1=_empty;
                Display2=_empty;
                Display3=_empty;
                Display4=_empty;
                Search_dis(show,0);
                Display1=Rx_Display;
                Rx_Display=0;
                Search_dis(show,1);
                Display2=Rx_Display;
                Rx_Display=0;
                Search_dis(show,2);
                Display3=Rx_Display;
                 Rx_Display=0;

            }
            if(data_ln==2)
            {       


                Search_dis(show,0);
                Display1=Rx_Display;
                Rx_Display=0;
                Search_dis(show,1);
                Display2=Rx_Display;
                Rx_Display=0;
                Display3=_empty;
                Display4=_empty;

            }
            if(data_ln==1)
            {        

                Search_dis(show,0);
                Display1=Rx_Display;
                Rx_Display=0;
                Display2=_empty;
                Display3=_empty;
                Display4=_empty;

            }
              for(t=0;t<5;t++) 
          for(delay=0;delay<255;delay++)
     display(Display1,Display2,Display3,Display4) ; 
      
}
      }
      else 
      if(well_come_massage==1)
      {    
      WELL_COME(); 

                }   
     
          
      }
      
     } 
      

    
    
