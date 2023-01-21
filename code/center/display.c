extern char input,IT,cnt0,set,dis,x,y,cnt2,cnt4,cnt5,cnt6,cnt8,cnt9,cnt10,cnt12,cnt13,cnt14,crt,backcnt,str[256],i;
extern  volatile char alpha;
char Local_1[4],Local_2[4];
char L=0,Cnt,k=0,L1=1,L2=0;
#include <glcd.h>
#include <font5x7.h>
#include <stdio.h>
#include <string.h>
#include <display.h>
#include <delay.h>
void dis_alpha(void)
{
switch(input)
    {         
    case 2 : 
    IT=0; 
    set=1;
    if(cnt0==0)
    {
        glcd_outtextxy(x,y,"!");   
        dis='!';
    }
    if(cnt0==1)
    {
        glcd_outtextxy(x,y,"@"); 
        dis='@';
    } 
    if(cnt0==2)
    {
        glcd_outtextxy(x,y,"$");
        dis='$';
    }
    cnt0++;
    if(cnt0>2)
        cnt0=0;   
    
    break;    
    
    case 1 :   
      
    if(set==0)
    {
    x+=6;
    IT=0;         
    set=1; 
    glcd_outtextxy(x,y," ");
    dis=' ';    
    
    if(x>128)
    {
         x=0;
        y+=5;
        if(y>64)
         y=0;
    }      
     
    } 
    else
    {
    IT=0;         
    glcd_outtextxy(x,y," ");
    dis=' ';  
    }
    break; 
    
    case 0 : 
     
    IT=0; 
    set=1;    
    if(cnt2==0)
    {
        glcd_outtextxy(x,y,",");
        dis=',';    
    }
    if(cnt2==1)
    {
        glcd_outtextxy(x,y,"."); 
        dis='.';
    } 
    if(cnt2==2)
    {
        glcd_outtextxy(x,y,"^");   
        dis='^';
    }
    if(cnt2==3)
    {
        glcd_outtextxy(x,y,"%");
        dis='%';
    }
    cnt2++;
    if(cnt2>3)
        cnt2=0; 
    
    break;
     
  

    case 4 :
      
    IT=0; 
    set=1;    
    if(cnt4==0)
    {
        glcd_outtextxy(x,y,"&");
        dis='&';
    }
    if(cnt4==1)
    {
        glcd_outtextxy(x,y,"0");              
        dis='0';
    }
    cnt4++;
    if(cnt4>1)
        cnt4=0; 
    
    break;   
    
    case 5 :   
    
    IT=0;   
    set=1;   
    
    if(cnt5==0)
    {
        glcd_outtextxy(x,y,"A");
        dis='A';
    }
    if(cnt5==1)
    {
        glcd_outtextxy(x,y,"B");
        dis='B';

    }
    if(cnt5==2)
    {
        glcd_outtextxy(x,y,"C");
        dis='C';
    }
    cnt5++;
    if(cnt5>2)
     cnt5=0; 
                    
    break;  
    
    case 6 :
    
    IT=0;
    set=1;
    if(cnt6==0)
    {
        glcd_outtextxy(x,y,"D");
        dis='D';
    }
    if(cnt6==1)
    {
        glcd_outtextxy(x,y,"E");
        dis='E';
    }
    if(cnt6==2)
    {
        glcd_outtextxy(x,y,"F");
        dis='F';
    }
    cnt6++;
    if(cnt6>2)
        cnt6=0;  
    
    break;  
    
    case 8 :  
    
    IT=0; 
    set=1;
    if(cnt8==0)
    {
        glcd_outtextxy(x,y,"G");
        dis='G';
    }
    if(cnt8==1)
    {
        glcd_outtextxy(x,y,"H");
        dis='H';
    }
    if(cnt8==2)
    {
        glcd_outtextxy(x,y,"I");
        dis='I';
    }
    cnt8++;
    if(cnt8>2)
        cnt8=0;  
    
    break;  
    
    case 9 :  
    
    IT=0; 
    set=1;
    if(cnt9==0)
    {
        glcd_outtextxy(x,y,"J");
        dis='J';
    }
    if(cnt9==1)
    {
        glcd_outtextxy(x,y,"K");
        dis='K';
    }
    if(cnt9==2)
    {
        glcd_outtextxy(x,y,"L");
        dis='L';
    }
    cnt9++;
    if(cnt9>2)
        cnt9=0;  
    
    break;   
    
    case 10 : 
    
    IT=0; 
    set=1;     
    if(cnt10==0)
    {
        glcd_outtextxy(x,y,"M");
        dis='M';
    }
    if(cnt10==1)
    {
        glcd_outtextxy(x,y,"N");   
         dis='N';
    }
    if(cnt10==2)
    {
        glcd_outtextxy(x,y,"O");
        dis='O';
    }
    cnt10++;
    if(cnt10>2)
     cnt10=0;
            
    break;   
    
    case 12 : 
    
    IT=0; 
    set=1;
    if(cnt12==0)
    {
        glcd_outtextxy(x,y,"P");
        dis='P';
    }
    if(cnt12==1)
    {
        glcd_outtextxy(x,y,"Q");
        dis='Q';
    }
    if(cnt12==2)
    {
        glcd_outtextxy(x,y,"R");
        dis='R';
    }
    if(cnt12==3)
    {
        glcd_outtextxy(x,y,"S");
        dis='S';
    }
    cnt12++;
    if(cnt12>3)
        cnt12=0;  
    
    break; 
    
    case 13 :  
    
    IT=0; 
    set=1;    
    if(cnt13==0)
    {
        glcd_outtextxy(x,y,"T");
        dis='T';
    }
    if(cnt13==1)
    {
        glcd_outtextxy(x,y,"U");
        dis='U';
    }
    if(cnt13==2)
    {
        glcd_outtextxy(x,y,"V");
        dis='V';      
    }

    cnt13++;
    if(cnt13>2)
        cnt13=0;
            
    break;  

    case 14:
    IT=0; 
    set=1;
    if(cnt14==0)
    {
        glcd_outtextxy(x,y,"W");
        dis='W';      
    }
    if(cnt14==1)
    {
        glcd_outtextxy(x,y,"X");
        dis='X';      
    }
    if(cnt14==2)
    {
        glcd_outtextxy(x,y,"Y");
        dis='Y';   
    }
    if(cnt14==3)
    {
        glcd_outtextxy(x,y,"Z");
        dis='Z';      
    }
    cnt14++;
    if(cnt14>3)
    cnt14=0; 

     break;
                   
               

                
    case 7 : 
    
    glcd_clear();  
    IT=0;  
    glcd_outtextxy(0,0,str);  
     Cnt=0;
    for(L=0;L<strlen(str);L++)
   {
   k=strlen(str)-L;
   if(L1==1)
    Local_1[Cnt]=str[L];
    if(L2==1)
    Local_2[Cnt]=str[L]; 

  
      if((Cnt>=3) | (k<2))
    {
   Cnt=0;  
    if((L1==1 ))
    {     
    putchar(0x01);
   
        putchar('{');
  
    puts(Local_1); 
      
      putchar('}');
          
  
    memset(Local_1,0,4);

    }
    if((L2==1 ))
    {
    putchar(0x02); 
        
    putchar('{');   
        
    puts(Local_2); 
        
    putchar('}');  
        

    memset(Local_2,0,4);  

    }
    L2=1-L2;
    L1=1-L1;
    }
    else

    Cnt++;  
   
   }   
          if(strlen(str)<=3)
    {     
    L2=0;
    L1=1;
    }
    else
    {
    L2=1-L2;
    L1=1-L1;
    }
    k=0;
    putchar(0x02); 
        
    putchar('{');   
        
    putchar(0xff); 
        
    putchar('}');  
        
     
    putchar(0x01); 
        
    putchar('{');   
        
    putchar(0xff); 
        
    putchar('}');  
       
   
    break;
                
    case 11 : 
         
    i++;
    strncat(str, &dis, 1);
    IT=0;   
       
    if(crt==1)
    {
        crt=0;
        x=x+backcnt;  
        backcnt=0;   
        }
        else  
            if(set==1)
            { 
                x+=6;  
                i++;          
                cnt0=0;cnt2=0;cnt4=0;cnt5=0;cnt6=0;cnt8=0;cnt9=0;cnt10=0;cnt12=0;cnt13=0;cnt14=0;  
                               
            if(x>128)
            {
                x=0;
                y+=6;
                if(y>64)
                y=0;
        }
        set=0;  
    }       
    
    break;
                
    case 15 :
    
    IT=0;  
    glcd_clear(); 
    x=0;
    y=0;  
    i=0;
    memset(str,0,100);                                                          
    cnt0=0;cnt2=0;cnt4=0;cnt5=0;cnt6=0;cnt8=0;cnt9=0;cnt10=0;cnt12=0;cnt13=0;cnt14=0;   
    break; 

    case 3 : 
    IT=0;       
    alpha=1-alpha;    
    input=16;         
    break; 
    }
}

void dis_num(void)
{
    switch(input)
    {     
            
    case 2 :
     
        IT=0; 
        set=1;
        glcd_outtextxy(x,y,"*");
        dis='*'; 
        
    break;    
    
    case 1 :    
    
        IT=0;       
        set=1;   
        glcd_outtextxy(x,y,"0");
        dis='0'; 
        
    break;  
    
    case 0 :  
        IT=0;     
        set=1;
        glcd_outtextxy(x,y,"#");

        dis='#';  
    
    break;

    case 4 :  
    
        IT=0;     
        set=1;
        glcd_outtextxy(x,y,"1");

        dis='1'; 
        
    break;   
    
    case 5 :
        IT=0;   
        set=1;
        glcd_outtextxy(x,y,"2");

        dis='2';
                        
    break;    
    
    case 6 :    
    
        IT=0;
        set=1;
        glcd_outtextxy(x,y,"3");

        dis='3';  
    
    break; 
    
    case 8 :
    
        IT=0;
        set=1;
        glcd_outtextxy(x,y,"4");
        dis='4';
    
    break; 
    
    case 9 : 
    
        IT=0;
        set=1;
        glcd_outtextxy(x,y,"5");
        dis='5';  
        
    break;   
    
    case 10 :   
    
        IT=0;      
        set=1;
        glcd_outtextxy(x,y,"6");
        dis='6';
            
    break;
    
    case 12 :  
    
        IT=0; 
        set=1;
        glcd_outtextxy(x,y,"7");
        dis='7';
        
    break; 
    
        case 13 : 
        
        IT=0;     
        set=1;
        glcd_outtextxy(x,y,"8");
        dis='8';
        
    break; 
    
    case 14:     
    
        IT=0;
        set=1;
        glcd_outtextxy(x,y,"9");
        dis='9';

    break;
                   
    case 3 : 
    alpha=1-alpha;  
    input=16;       
    break;
                
    case 7 :  
     glcd_clear();  
    IT=0;  
    glcd_outtextxy(0,0,str);  
     Cnt=0;
    for(L=0;L<strlen(str);L++)
   {
   k=strlen(str)-L;
   if(L1==1)
    Local_1[Cnt]=str[L];
    if(L2==1)
    Local_2[Cnt]=str[L]; 

  
      if((Cnt>=3) | (k<2))
    {
   Cnt=0;  
    if((L1==1 ))
    {     
    putchar(0x01);
   
        putchar('{');
  
    puts(Local_1); 
      
      putchar('}');
          
  
    memset(Local_1,0,4);

    }
    if((L2==1 ))
    {
    putchar(0x02); 
        
    putchar('{');   
        
    puts(Local_2); 
        
    putchar('}');  
        

    memset(Local_2,0,4);  

    }  

    }
    else

    Cnt++;  
   
   }
       if(strlen(str)<=3)
    {     
    L2=0;
    L1=1;
    }
    else
    {
    L2=1-L2;
    L1=1-L1;
    }
    k=0;
    putchar(0x02); 
        
    putchar('{');   
        
    putchar(0xff); 
        
    putchar('}');  
        
     
    putchar(0x01); 
        
    putchar('{');   
        
    putchar(0xff); 
        
    putchar('}');  
       
    break;
                
    case 11 :  
                                       
     
    i++;
    strncat(str, &dis, 1);
    IT=0;   
       
//    if(crt==1)
//    {
//        crt=0;
//        x=x+backcnt;  
//        backcnt=0;   
//        }
//        else  

            if(set==1)
            { 
                x+=6;  
                i++;          
                               
            if(x>128)
            {
                x=0;
                y+=6;
                if(y>64)
                y=0;
        }
        set=0;  
    }       
    break;
                
    case 15 :   
    
        IT=0;  
        glcd_clear();
        x=0;
        y=0;
        i=0;
        memset(str,0,100);  
        
    break;
   }

}