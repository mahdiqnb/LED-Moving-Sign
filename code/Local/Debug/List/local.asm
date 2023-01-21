
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Rx_Display=R4
	.DEF _Rx_Display_msb=R5
	.DEF _Display1=R6
	.DEF _Display1_msb=R7
	.DEF _Display2=R8
	.DEF _Display2_msb=R9
	.DEF _Display3=R10
	.DEF _Display3_msb=R11
	.DEF _Display4=R12
	.DEF _Display4_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_Activator:
	.DB  0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8
	.DB  0x9,0xA,0xB,0xC,0xD,0xE,0xF,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x38,0x6C,0x6D,0x39,0x6E,0x66,0x3B
_0x4:
	.DB  0x10,0x3C,0x50,0x30,0x18,0x14,0x78,0x10
_0x5:
	.DB  0x38,0x44,0x9A,0xAA,0xAA,0x9C,0x40,0x38
_0x6:
	.DB  0x0,0x0,0x8,0x2A,0x1C,0x2A,0x8
_0x7:
	.DB  0x0,0x64,0xA8,0xA8,0x56,0x16,0x26
_0x8:
	.DB  0x8,0x14,0x22,0x41
_0x9:
	.DB  0x0,0x0,0x0,0x0,0x0,0x18,0x18
_0xA:
	.DB  0x0,0x0,0x0,0x8,0x8,0x8,0x10
_0xB:
	.DB  0xA,0xA,0x3F,0x14,0x14,0x7E,0x28,0x28
_0xC:
	.DB  0x20,0x50,0x50,0x50,0x70,0x88,0x88
_0xD:
	.DB  0x78,0x44,0x44,0x78,0x44,0x44,0x78
_0xE:
	.DB  0x38,0x44,0x40,0x40,0x40,0x44,0x38
_0xF:
	.DB  0x78,0x44,0x44,0x44,0x44,0x44,0x78
_0x10:
	.DB  0x7C,0x40,0x40,0x78,0x40,0x40,0x7C
_0x11:
	.DB  0x7C,0x40,0x40,0x78,0x40,0x40,0x40
_0x12:
	.DB  0x38,0x44,0x40,0x4C,0x44,0x44,0x38
_0x13:
	.DB  0x44,0x44,0x44,0x7C,0x44,0x44,0x44
_0x14:
	.DB  0x0,0x38,0x10,0x10,0x10,0x10,0x38
_0x15:
	.DB  0x0,0x10,0x10,0x10,0x10,0x10,0x90,0x60
_0x16:
	.DB  0x44,0x48,0x50,0x68,0x48,0x44,0x44
_0x17:
	.DB  0x40,0x40,0x40,0x40,0x40,0x40,0x7C
_0x18:
	.DB  0x82,0xC6,0xC6,0xAA,0xAA,0xAA,0x92
_0x19:
	.DB  0x44,0x64,0x64,0x54,0x4C,0x4C,0x44
_0x1A:
	.DB  0x38,0x44,0x44,0x44,0x44,0x44,0x38
_0x1B:
	.DB  0x70,0x48,0x48,0x70,0x40,0x40,0x40
_0x1C:
	.DB  0x38,0x44,0x44,0x44,0x54,0x4C,0x38,0x4
_0x1D:
	.DB  0x78,0x44,0x44,0x78,0x48,0x48,0x44
_0x1E:
	.DB  0x30,0x48,0x40,0x30,0x8,0x48,0x30
_0x1F:
	.DB  0xF8,0x20,0x20,0x20,0x20,0x20,0x20
_0x20:
	.DB  0x44,0x44,0x44,0x44,0x44,0x44,0x38
_0x21:
	.DB  0x82,0x82,0x44,0x44,0x28,0x28,0x10
_0x22:
	.DB  0x0,0x92,0xAA,0xAA,0xAA,0xAA,0x44
_0x23:
	.DB  0x0,0x28,0x28,0x10,0x10,0x28,0x28
_0x24:
	.DB  0x0,0x22,0x14,0x14,0x8,0x8,0x8
_0x25:
	.DB  0x0,0x3E,0x4,0x8,0x10,0x20,0x3E
_0x26:
	.DB  0x1C,0x22,0x22,0x22,0x22,0x22,0x22,0x1C
_0x27:
	.DB  0x0,0x8,0x18,0x8,0x8,0x8,0x8
_0x28:
	.DB  0x0,0x38,0x28,0x8,0x18,0x30,0x38
_0x29:
	.DB  0x0,0x3C,0x4,0xC,0x4,0x24,0x18
_0x2A:
	.DB  0x0,0x4,0xC,0xC,0x14,0x1E,0x4
_0x2B:
	.DB  0x0,0x1C,0x20,0x38,0x4,0x24,0x18
_0x2C:
	.DB  0x0,0x1C,0x20,0x38,0x24,0x24,0x18
_0x2D:
	.DB  0x0,0x38,0x4,0x8,0x10,0x10,0x10
_0x2E:
	.DB  0x0,0x3C,0x24,0x18,0x24,0x24,0x18
_0x2F:
	.DB  0x0,0x18,0x24,0x24,0x1C,0x4,0x38
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _and
	.DW  _0x3*2

	.DW  0x08
	.DW  __dollor
	.DW  _0x4*2

	.DW  0x08
	.DW  __Ad
	.DW  _0x5*2

	.DW  0x07
	.DW  _star
	.DW  _0x6*2

	.DW  0x07
	.DW  __per
	.DW  _0x7*2

	.DW  0x04
	.DW  __power
	.DW  _0x8*2

	.DW  0x07
	.DW  __dot
	.DW  _0x9*2

	.DW  0x07
	.DW  __comma
	.DW  _0xA*2

	.DW  0x08
	.DW  __Square
	.DW  _0xB*2

	.DW  0x07
	.DW  _A
	.DW  _0xC*2

	.DW  0x07
	.DW  _B
	.DW  _0xD*2

	.DW  0x07
	.DW  _C
	.DW  _0xE*2

	.DW  0x07
	.DW  _D
	.DW  _0xF*2

	.DW  0x07
	.DW  _E
	.DW  _0x10*2

	.DW  0x07
	.DW  _F
	.DW  _0x11*2

	.DW  0x07
	.DW  _G
	.DW  _0x12*2

	.DW  0x07
	.DW  _H
	.DW  _0x13*2

	.DW  0x07
	.DW  __I
	.DW  _0x14*2

	.DW  0x08
	.DW  __J
	.DW  _0x15*2

	.DW  0x07
	.DW  _K
	.DW  _0x16*2

	.DW  0x07
	.DW  _L
	.DW  _0x17*2

	.DW  0x07
	.DW  _M
	.DW  _0x18*2

	.DW  0x07
	.DW  _N
	.DW  _0x19*2

	.DW  0x07
	.DW  _O
	.DW  _0x1A*2

	.DW  0x07
	.DW  _P
	.DW  _0x1B*2

	.DW  0x08
	.DW  _Q
	.DW  _0x1C*2

	.DW  0x07
	.DW  _R
	.DW  _0x1D*2

	.DW  0x07
	.DW  _S
	.DW  _0x1E*2

	.DW  0x07
	.DW  _T
	.DW  _0x1F*2

	.DW  0x07
	.DW  _U
	.DW  _0x20*2

	.DW  0x07
	.DW  _V
	.DW  _0x21*2

	.DW  0x07
	.DW  _W
	.DW  _0x22*2

	.DW  0x07
	.DW  _X
	.DW  _0x23*2

	.DW  0x07
	.DW  _Y
	.DW  _0x24*2

	.DW  0x07
	.DW  _Z
	.DW  _0x25*2

	.DW  0x08
	.DW  __0
	.DW  _0x26*2

	.DW  0x07
	.DW  __1
	.DW  _0x27*2

	.DW  0x07
	.DW  __2
	.DW  _0x28*2

	.DW  0x07
	.DW  __3
	.DW  _0x29*2

	.DW  0x07
	.DW  __4
	.DW  _0x2A*2

	.DW  0x07
	.DW  __5
	.DW  _0x2B*2

	.DW  0x07
	.DW  __6
	.DW  _0x2C*2

	.DW  0x07
	.DW  __7
	.DW  _0x2D*2

	.DW  0x07
	.DW  __8
	.DW  _0x2E*2

	.DW  0x07
	.DW  __9
	.DW  _0x2F*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <io.h>
;#include <display.h>
;#include <delay.h>
;#include <stdio.h>
;#include <string.h>
;#include <alpha.h>

	.DSEG
;#include <Stdlib.h>
;
;#define up      1
;#define down    0
;
;
;char *Rx_Display,*Display1,*Display2,*Display3,*Display4,contin=0,mul=0;
;unsigned char receive=0,finish=0,cnt=0,flag=0,dis[4],show[256],show1[256],done=0,j,sh_cnt=0,sh1_cnt=0,sh2_cnt=0,rr[4];
;
;
;void Search_dis(char *dis,char i)
; 0000 0013 {

	.CSEG
_Search_dis:
; .FSTART _Search_dis
; 0000 0014 
; 0000 0015 if(dis[i]=='A')
	ST   -Y,R26
;	*dis -> Y+1
;	i -> Y+0
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x41)
	BRNE _0x30
; 0000 0016 Rx_Display=A;
	LDI  R30,LOW(_A)
	LDI  R31,HIGH(_A)
	RJMP _0x123
; 0000 0017 else
_0x30:
; 0000 0018 if(dis[i]=='B')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x42)
	BRNE _0x32
; 0000 0019 Rx_Display=B;
	LDI  R30,LOW(_B)
	LDI  R31,HIGH(_B)
	RJMP _0x123
; 0000 001A else
_0x32:
; 0000 001B if(dis[i]=='C')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x43)
	BRNE _0x34
; 0000 001C Rx_Display=C;
	LDI  R30,LOW(_C)
	LDI  R31,HIGH(_C)
	RJMP _0x123
; 0000 001D else
_0x34:
; 0000 001E if(dis[i]=='D')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x44)
	BRNE _0x36
; 0000 001F Rx_Display=D;
	LDI  R30,LOW(_D)
	LDI  R31,HIGH(_D)
	RJMP _0x123
; 0000 0020 else
_0x36:
; 0000 0021 if(dis[i]=='E')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x45)
	BRNE _0x38
; 0000 0022 Rx_Display=E;
	LDI  R30,LOW(_E)
	LDI  R31,HIGH(_E)
	RJMP _0x123
; 0000 0023 else
_0x38:
; 0000 0024 if(dis[i]=='F')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x46)
	BRNE _0x3A
; 0000 0025 Rx_Display=F;
	LDI  R30,LOW(_F)
	LDI  R31,HIGH(_F)
	RJMP _0x123
; 0000 0026 else
_0x3A:
; 0000 0027 if(dis[i]=='G')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x47)
	BRNE _0x3C
; 0000 0028 Rx_Display=G;
	LDI  R30,LOW(_G)
	LDI  R31,HIGH(_G)
	RJMP _0x123
; 0000 0029 else
_0x3C:
; 0000 002A if(dis[i]=='H')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x48)
	BRNE _0x3E
; 0000 002B Rx_Display=H;
	LDI  R30,LOW(_H)
	LDI  R31,HIGH(_H)
	RJMP _0x123
; 0000 002C else
_0x3E:
; 0000 002D if(dis[i]=='I')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x49)
	BRNE _0x40
; 0000 002E Rx_Display=_I;
	LDI  R30,LOW(__I)
	LDI  R31,HIGH(__I)
	RJMP _0x123
; 0000 002F else
_0x40:
; 0000 0030 if(dis[i]=='J')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x4A)
	BRNE _0x42
; 0000 0031 Rx_Display=_J;
	LDI  R30,LOW(__J)
	LDI  R31,HIGH(__J)
	RJMP _0x123
; 0000 0032 else
_0x42:
; 0000 0033 if(dis[i]=='K')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x4B)
	BRNE _0x44
; 0000 0034 Rx_Display=K;
	LDI  R30,LOW(_K)
	LDI  R31,HIGH(_K)
	RJMP _0x123
; 0000 0035 else
_0x44:
; 0000 0036 if(dis[i]=='L')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x4C)
	BRNE _0x46
; 0000 0037 Rx_Display=L;
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	RJMP _0x123
; 0000 0038 else
_0x46:
; 0000 0039 if(dis[i]=='M')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x4D)
	BRNE _0x48
; 0000 003A Rx_Display=M;
	LDI  R30,LOW(_M)
	LDI  R31,HIGH(_M)
	RJMP _0x123
; 0000 003B else
_0x48:
; 0000 003C if(dis[i]=='N')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x4E)
	BRNE _0x4A
; 0000 003D Rx_Display=N;
	LDI  R30,LOW(_N)
	LDI  R31,HIGH(_N)
	RJMP _0x123
; 0000 003E else
_0x4A:
; 0000 003F if(dis[i]=='O')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x4F)
	BRNE _0x4C
; 0000 0040 Rx_Display=O;
	LDI  R30,LOW(_O)
	LDI  R31,HIGH(_O)
	RJMP _0x123
; 0000 0041 else
_0x4C:
; 0000 0042 if(dis[i]=='P')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x50)
	BRNE _0x4E
; 0000 0043 Rx_Display=P;
	LDI  R30,LOW(_P)
	LDI  R31,HIGH(_P)
	RJMP _0x123
; 0000 0044 else
_0x4E:
; 0000 0045 if(dis[i]=='Q')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x51)
	BRNE _0x50
; 0000 0046 Rx_Display=Q;
	LDI  R30,LOW(_Q)
	LDI  R31,HIGH(_Q)
	RJMP _0x123
; 0000 0047 else
_0x50:
; 0000 0048 if(dis[i]=='R')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x52)
	BRNE _0x52
; 0000 0049 Rx_Display=R;
	LDI  R30,LOW(_R)
	LDI  R31,HIGH(_R)
	RJMP _0x123
; 0000 004A else
_0x52:
; 0000 004B if(dis[i]=='S')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x53)
	BRNE _0x54
; 0000 004C Rx_Display=S;
	LDI  R30,LOW(_S)
	LDI  R31,HIGH(_S)
	RJMP _0x123
; 0000 004D else
_0x54:
; 0000 004E if(dis[i]=='T')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x54)
	BRNE _0x56
; 0000 004F Rx_Display=T;
	LDI  R30,LOW(_T)
	LDI  R31,HIGH(_T)
	RJMP _0x123
; 0000 0050 else
_0x56:
; 0000 0051 if(dis[i]=='U')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x55)
	BRNE _0x58
; 0000 0052 Rx_Display=U;
	LDI  R30,LOW(_U)
	LDI  R31,HIGH(_U)
	RJMP _0x123
; 0000 0053 else
_0x58:
; 0000 0054 if(dis[i]=='V')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x56)
	BRNE _0x5A
; 0000 0055 Rx_Display=V;
	LDI  R30,LOW(_V)
	LDI  R31,HIGH(_V)
	RJMP _0x123
; 0000 0056 else
_0x5A:
; 0000 0057 if(dis[i]=='W')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x57)
	BRNE _0x5C
; 0000 0058 Rx_Display=W;
	LDI  R30,LOW(_W)
	LDI  R31,HIGH(_W)
	RJMP _0x123
; 0000 0059 else
_0x5C:
; 0000 005A if(dis[i]=='X')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x58)
	BRNE _0x5E
; 0000 005B Rx_Display=X;
	LDI  R30,LOW(_X)
	LDI  R31,HIGH(_X)
	RJMP _0x123
; 0000 005C else
_0x5E:
; 0000 005D if(dis[i]=='Y')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x59)
	BRNE _0x60
; 0000 005E Rx_Display=Y;
	LDI  R30,LOW(_Y)
	LDI  R31,HIGH(_Y)
	RJMP _0x123
; 0000 005F else
_0x60:
; 0000 0060 if(dis[i]=='Z')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x5A)
	BRNE _0x62
; 0000 0061 Rx_Display=Z;
	LDI  R30,LOW(_Z)
	LDI  R31,HIGH(_Z)
	RJMP _0x123
; 0000 0062 else
_0x62:
; 0000 0063 if(dis[i]=='0')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x30)
	BRNE _0x64
; 0000 0064 Rx_Display=_0;
	LDI  R30,LOW(__0)
	LDI  R31,HIGH(__0)
	RJMP _0x123
; 0000 0065 else
_0x64:
; 0000 0066 if(dis[i]=='1')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x31)
	BRNE _0x66
; 0000 0067 Rx_Display=_1;
	LDI  R30,LOW(__1)
	LDI  R31,HIGH(__1)
	RJMP _0x123
; 0000 0068 else
_0x66:
; 0000 0069 if(dis[i]=='2')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x32)
	BRNE _0x68
; 0000 006A Rx_Display=_2;
	LDI  R30,LOW(__2)
	LDI  R31,HIGH(__2)
	RJMP _0x123
; 0000 006B else
_0x68:
; 0000 006C if(dis[i]=='3')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x33)
	BRNE _0x6A
; 0000 006D Rx_Display=_3;
	LDI  R30,LOW(__3)
	LDI  R31,HIGH(__3)
	RJMP _0x123
; 0000 006E else
_0x6A:
; 0000 006F if(dis[i]=='4')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x34)
	BRNE _0x6C
; 0000 0070 Rx_Display=_4;
	LDI  R30,LOW(__4)
	LDI  R31,HIGH(__4)
	RJMP _0x123
; 0000 0071 else
_0x6C:
; 0000 0072 if(dis[i]=='5')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x35)
	BRNE _0x6E
; 0000 0073 Rx_Display=_5;
	LDI  R30,LOW(__5)
	LDI  R31,HIGH(__5)
	RJMP _0x123
; 0000 0074 else
_0x6E:
; 0000 0075 if(dis[i]=='6')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x36)
	BRNE _0x70
; 0000 0076 Rx_Display=_6;
	LDI  R30,LOW(__6)
	LDI  R31,HIGH(__6)
	RJMP _0x123
; 0000 0077 else
_0x70:
; 0000 0078 if(dis[i]=='7')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x37)
	BRNE _0x72
; 0000 0079 Rx_Display=_7;
	LDI  R30,LOW(__7)
	LDI  R31,HIGH(__7)
	RJMP _0x123
; 0000 007A else
_0x72:
; 0000 007B if(dis[i]=='8')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x38)
	BRNE _0x74
; 0000 007C Rx_Display=_8;
	LDI  R30,LOW(__8)
	LDI  R31,HIGH(__8)
	RJMP _0x123
; 0000 007D else
_0x74:
; 0000 007E if(dis[i]=='9')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x39)
	BRNE _0x76
; 0000 007F Rx_Display=_9;
	LDI  R30,LOW(__9)
	LDI  R31,HIGH(__9)
	RJMP _0x123
; 0000 0080 else
_0x76:
; 0000 0081 if(dis[i]=='#')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x23)
	BRNE _0x78
; 0000 0082 Rx_Display=_Square;
	LDI  R30,LOW(__Square)
	LDI  R31,HIGH(__Square)
	RJMP _0x123
; 0000 0083 else
_0x78:
; 0000 0084 if(dis[i]==',')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x2C)
	BRNE _0x7A
; 0000 0085 Rx_Display=_comma;
	LDI  R30,LOW(__comma)
	LDI  R31,HIGH(__comma)
	RJMP _0x123
; 0000 0086 else
_0x7A:
; 0000 0087 if(dis[i]=='.')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x2E)
	BRNE _0x7C
; 0000 0088 Rx_Display=_dot;
	LDI  R30,LOW(__dot)
	LDI  R31,HIGH(__dot)
	RJMP _0x123
; 0000 0089 else
_0x7C:
; 0000 008A if(dis[i]=='^')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x5E)
	BRNE _0x7E
; 0000 008B Rx_Display=_power;
	LDI  R30,LOW(__power)
	LDI  R31,HIGH(__power)
	RJMP _0x123
; 0000 008C else
_0x7E:
; 0000 008D if(dis[i]=='%')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x25)
	BRNE _0x80
; 0000 008E Rx_Display=_per;
	LDI  R30,LOW(__per)
	LDI  R31,HIGH(__per)
	RJMP _0x123
; 0000 008F else
_0x80:
; 0000 0090 if(dis[i]=='*')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x2A)
	BRNE _0x82
; 0000 0091 Rx_Display=star;
	LDI  R30,LOW(_star)
	LDI  R31,HIGH(_star)
	RJMP _0x123
; 0000 0092 else
_0x82:
; 0000 0093 if(dis[i]=='@')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x40)
	BRNE _0x84
; 0000 0094 Rx_Display=_Ad;
	LDI  R30,LOW(__Ad)
	LDI  R31,HIGH(__Ad)
	RJMP _0x123
; 0000 0095 else
_0x84:
; 0000 0096 if(dis[i]=='$')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x24)
	BRNE _0x86
; 0000 0097 Rx_Display=_dollor;
	LDI  R30,LOW(__dollor)
	LDI  R31,HIGH(__dollor)
	RJMP _0x123
; 0000 0098 else
_0x86:
; 0000 0099 if(dis[i]=='&')
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x26)
	BRNE _0x88
; 0000 009A Rx_Display=and;
	LDI  R30,LOW(_and)
	LDI  R31,HIGH(_and)
	RJMP _0x123
; 0000 009B else
_0x88:
; 0000 009C if(dis[i]==0x00)
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BRNE _0x8A
; 0000 009D Rx_Display=_empty;
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
_0x123:
	MOVW R4,R30
; 0000 009E }
_0x8A:
	ADIW R28,3
	RET
; .FEND
;
;char ID(void)
; 0000 00A1 {
_ID:
; .FSTART _ID
; 0000 00A2 return (PINB & 0x0f);
	IN   R30,0x16
	ANDI R30,LOW(0xF)
	RET
; 0000 00A3 }
; .FEND
;
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 00A6 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A7 
; 0000 00A8 
; 0000 00A9      receive=UDR;
	IN   R30,0xC
	STS  _receive,R30
; 0000 00AA          if(flag==1)
	LDS  R26,_flag
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x8B
; 0000 00AB      {
; 0000 00AC 
; 0000 00AD 
; 0000 00AE             if(receive=='{')
	LDS  R26,_receive
	CPI  R26,LOW(0x7B)
	BRNE _0x8C
; 0000 00AF             {
; 0000 00B0 
; 0000 00B1                 finish=0;
	LDI  R30,LOW(0)
	STS  _finish,R30
; 0000 00B2                 cnt=0;
	STS  _cnt,R30
; 0000 00B3                 memset(dis,0,4);
	CALL SUBOPT_0x1
; 0000 00B4 
; 0000 00B5                     if(done==1)
	LDS  R26,_done
	CPI  R26,LOW(0x1)
	BRNE _0x8D
; 0000 00B6                     {
; 0000 00B7 
; 0000 00B8                         memset(show,0,4);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 00B9                         memset(show1,0,4);
	LDI  R30,LOW(_show1)
	LDI  R31,HIGH(_show1)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3
; 0000 00BA                         sh_cnt=0;
	LDI  R30,LOW(0)
	STS  _sh_cnt,R30
; 0000 00BB                         sh1_cnt=0;
	STS  _sh1_cnt,R30
; 0000 00BC                         done=0;
	STS  _done,R30
; 0000 00BD 
; 0000 00BE                 }
; 0000 00BF             }
_0x8D:
; 0000 00C0 
; 0000 00C1             else
	RJMP _0x8E
_0x8C:
; 0000 00C2 
; 0000 00C3                 if(receive==0xff)
	LDS  R26,_receive
	CPI  R26,LOW(0xFF)
	BRNE _0x8F
; 0000 00C4                 {
; 0000 00C5 
; 0000 00C6                     finish=1;
	LDI  R30,LOW(1)
	STS  _finish,R30
; 0000 00C7                     memset(dis,0,4);
	CALL SUBOPT_0x1
; 0000 00C8                     sh2_cnt=sh1_cnt;
	LDS  R30,_sh1_cnt
	STS  _sh2_cnt,R30
; 0000 00C9 
; 0000 00CA                     for(j=sh_cnt;j<=sh1_cnt;j++)
	LDS  R30,_sh_cnt
	STS  _j,R30
_0x91:
	LDS  R30,_sh1_cnt
	LDS  R26,_j
	CP   R30,R26
	BRLO _0x92
; 0000 00CB                     {
; 0000 00CC 
; 0000 00CD                     show[sh_cnt]=show1[j];
	LDS  R26,_sh_cnt
	LDI  R27,0
	SUBI R26,LOW(-_show)
	SBCI R27,HIGH(-_show)
	LDS  R30,_j
	LDI  R31,0
	SUBI R30,LOW(-_show1)
	SBCI R31,HIGH(-_show1)
	LD   R30,Z
	ST   X,R30
; 0000 00CE                     sh_cnt++;
	LDS  R30,_sh_cnt
	SUBI R30,-LOW(1)
	STS  _sh_cnt,R30
; 0000 00CF                     sh2_cnt++;
	LDS  R30,_sh2_cnt
	SUBI R30,-LOW(1)
	STS  _sh2_cnt,R30
; 0000 00D0 
; 0000 00D1                         if(sh2_cnt>sh1_cnt)
	LDS  R30,_sh1_cnt
	LDS  R26,_sh2_cnt
	CP   R30,R26
	BRSH _0x93
; 0000 00D2                            sh2_cnt=0;
	LDI  R30,LOW(0)
	STS  _sh2_cnt,R30
; 0000 00D3 
; 0000 00D4                         if(sh_cnt>=255)
_0x93:
	LDS  R26,_sh_cnt
	CPI  R26,LOW(0xFF)
	BRLO _0x94
; 0000 00D5                           sh_cnt=0;
	LDI  R30,LOW(0)
	STS  _sh_cnt,R30
; 0000 00D6 
; 0000 00D7                 }
_0x94:
	CALL SUBOPT_0x4
	RJMP _0x91
_0x92:
; 0000 00D8                 }
; 0000 00D9 
; 0000 00DA             else
	RJMP _0x95
_0x8F:
; 0000 00DB 
; 0000 00DC                 if(receive=='}')
	LDS  R26,_receive
	CPI  R26,LOW(0x7D)
	BREQ PC+2
	RJMP _0x96
; 0000 00DD                 {
; 0000 00DE 
; 0000 00DF                     if(finish!=1)
	LDS  R26,_finish
	CPI  R26,LOW(0x1)
	BREQ _0x97
; 0000 00E0                     {
; 0000 00E1 
; 0000 00E2                         for(j=0;j<=cnt;j++)
	LDI  R30,LOW(0)
	STS  _j,R30
_0x99:
	LDS  R30,_cnt
	LDS  R26,_j
	CP   R30,R26
	BRLO _0x9A
; 0000 00E3                         {
; 0000 00E4 
; 0000 00E5                             if((dis[j]!=0x00)&&(dis[j]!=0x07))
	LDS  R30,_j
	LDI  R31,0
	SUBI R30,LOW(-_dis)
	SBCI R31,HIGH(-_dis)
	LD   R26,Z
	CPI  R26,LOW(0x0)
	BREQ _0x9C
	CPI  R26,LOW(0x7)
	BRNE _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 00E6                             {
; 0000 00E7                             show1[sh1_cnt]=dis[j];
	LDS  R26,_sh1_cnt
	LDI  R27,0
	SUBI R26,LOW(-_show1)
	SBCI R27,HIGH(-_show1)
	LDS  R30,_j
	LDI  R31,0
	SUBI R30,LOW(-_dis)
	SBCI R31,HIGH(-_dis)
	LD   R30,Z
	ST   X,R30
; 0000 00E8                             sh1_cnt++;
	LDS  R30,_sh1_cnt
	SUBI R30,-LOW(1)
	STS  _sh1_cnt,R30
; 0000 00E9                             }
; 0000 00EA 
; 0000 00EB                     else
	RJMP _0x9E
_0x9B:
; 0000 00EC                      j++;
	CALL SUBOPT_0x4
; 0000 00ED 
; 0000 00EE                             if(sh1_cnt>=255)
_0x9E:
	LDS  R26,_sh1_cnt
	CPI  R26,LOW(0xFF)
	BRLO _0x9F
; 0000 00EF                               sh1_cnt=0;
	LDI  R30,LOW(0)
	STS  _sh1_cnt,R30
; 0000 00F0 
; 0000 00F1                     }
_0x9F:
	CALL SUBOPT_0x4
	RJMP _0x99
_0x9A:
; 0000 00F2 
; 0000 00F3 
; 0000 00F4             }
; 0000 00F5 
; 0000 00F6             else
	RJMP _0xA0
_0x97:
; 0000 00F7 
; 0000 00F8                 if(finish==1)
	LDS  R26,_finish
	CPI  R26,LOW(0x1)
	BRNE _0xA1
; 0000 00F9 
; 0000 00FA                 done=1;
	LDI  R30,LOW(1)
	STS  _done,R30
; 0000 00FB 
; 0000 00FC 
; 0000 00FD             flag=0;
_0xA1:
_0xA0:
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0000 00FE 
; 0000 00FF             }
; 0000 0100 
; 0000 0101             else
	RJMP _0xA2
_0x96:
; 0000 0102             {
; 0000 0103 
; 0000 0104                 if(receive!=0x0A)
	LDS  R26,_receive
	CPI  R26,LOW(0xA)
	BREQ _0xA3
; 0000 0105                 {
; 0000 0106 
; 0000 0107                 dis[cnt]=receive;
	LDS  R30,_cnt
	LDI  R31,0
	SUBI R30,LOW(-_dis)
	SBCI R31,HIGH(-_dis)
	STD  Z+0,R26
; 0000 0108                 cnt++;
	LDS  R30,_cnt
	SUBI R30,-LOW(1)
	STS  _cnt,R30
; 0000 0109 
; 0000 010A             }
; 0000 010B      }
_0xA3:
_0xA2:
_0x95:
_0x8E:
; 0000 010C     }
; 0000 010D 
; 0000 010E      if(receive==ID())
_0x8B:
	RCALL _ID
	LDS  R26,_receive
	CP   R30,R26
	BRNE _0xA4
; 0000 010F 
; 0000 0110      flag=1;
	LDI  R30,LOW(1)
	STS  _flag,R30
; 0000 0111 
; 0000 0112 
; 0000 0113 }
_0xA4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void WELL_COME(void)
; 0000 0116 {
_WELL_COME:
; .FSTART _WELL_COME
; 0000 0117     char t=0,delay;
; 0000 0118     if(ID()==1)       //for local one
	ST   -Y,R17
	ST   -Y,R16
;	t -> R17
;	delay -> R16
	LDI  R17,0
	RCALL _ID
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0xA5
; 0000 0119     {
; 0000 011A         Display1=E;      //show E
	CALL SUBOPT_0x5
; 0000 011B     Display2=_empty;
; 0000 011C     Display3=_empty;
; 0000 011D     Display4=_empty;
; 0000 011E 
; 0000 011F     for(delay=0;delay<255;delay++)
_0xA7:
	CPI  R16,255
	BRSH _0xA8
; 0000 0120     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xA7
_0xA8:
; 0000 0122 Display1=M;
	CALL SUBOPT_0x7
; 0000 0123     Display2=E;
; 0000 0124     Display3=_empty;
; 0000 0125     Display4=_empty;
; 0000 0126 
; 0000 0127     for(delay=0;delay<255;delay++)
_0xAA:
	CPI  R16,255
	BRSH _0xAB
; 0000 0128     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xAA
_0xAB:
; 0000 012A Display1=O;
	CALL SUBOPT_0x8
; 0000 012B     Display2=M;
; 0000 012C     Display3=E;
; 0000 012D     Display4=_empty;
; 0000 012E 
; 0000 012F     for(delay=0;delay<255;delay++)
_0xAD:
	CPI  R16,255
	BRSH _0xAE
; 0000 0130     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xAD
_0xAE:
; 0000 0131 Display1=C;
	CALL SUBOPT_0x9
; 0000 0132     Display2=O;
; 0000 0133     Display3=M;
; 0000 0134     Display4=E;
; 0000 0135 
; 0000 0136     for(delay=0;delay<255;delay++)
_0xB0:
	CPI  R16,255
	BRSH _0xB1
; 0000 0137     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xB0
_0xB1:
; 0000 0139 Display1=_empty;
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	CALL SUBOPT_0xA
; 0000 013A     Display2=C;
; 0000 013B     Display3=O;
; 0000 013C     Display4=M;
; 0000 013D 
; 0000 013E     for(delay=0;delay<255;delay++)
_0xB3:
	CPI  R16,255
	BRSH _0xB4
; 0000 013F     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xB3
_0xB4:
; 0000 0140 Display1=L;
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	CALL SUBOPT_0xB
; 0000 0141     Display2=_empty;
; 0000 0142     Display3=C;
	CALL SUBOPT_0xC
; 0000 0143     Display4=O;
; 0000 0144 
; 0000 0145     for(delay=0;delay<255;delay++)
_0xB6:
	CPI  R16,255
	BRSH _0xB7
; 0000 0146     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xB6
_0xB7:
; 0000 0147 Display1=E;
	CALL SUBOPT_0xD
; 0000 0148     Display2=L;
; 0000 0149     Display3=_empty;
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R10,R30
; 0000 014A     Display4=C;
	LDI  R30,LOW(_C)
	LDI  R31,HIGH(_C)
	MOVW R12,R30
; 0000 014B 
; 0000 014C     for(delay=0;delay<255;delay++)
	LDI  R16,LOW(0)
_0xB9:
	CPI  R16,255
	BRSH _0xBA
; 0000 014D     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xB9
_0xBA:
; 0000 014F Display1=W;
	CALL SUBOPT_0xE
; 0000 0150     Display2=E;
; 0000 0151     Display3=L;
; 0000 0152     Display4=_empty;
	CALL SUBOPT_0xF
; 0000 0153     for(delay=0;delay<255;delay++)
_0xBC:
	CPI  R16,255
	BRSH _0xBD
; 0000 0154     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xBC
_0xBD:
; 0000 0155 Display1=_empty;
	CALL SUBOPT_0x10
; 0000 0156     Display2=W;                  //SHOW WEL
; 0000 0157     Display3=E;
; 0000 0158     Display4=L;
; 0000 0159     for(delay=0;delay<255;delay++)
_0xBF:
	CPI  R16,255
	BRSH _0xC0
; 0000 015A     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xBF
_0xC0:
; 0000 015B Display1=_empty;
	CALL SUBOPT_0x11
; 0000 015C     Display2=_empty;
; 0000 015D     Display3=W;
	CALL SUBOPT_0x12
; 0000 015E     Display4=E;
; 0000 015F     for(delay=0;delay<255;delay++)
_0xC2:
	CPI  R16,255
	BRSH _0xC3
; 0000 0160     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xC2
_0xC3:
; 0000 0161 Display1=_empty;
	CALL SUBOPT_0x11
; 0000 0162     Display2=_empty;                 //SHOW W
; 0000 0163     Display3=_empty;
	CALL SUBOPT_0x13
; 0000 0164     Display4=W;
; 0000 0165     for(delay=0;delay<255;delay++)
_0xC5:
	CPI  R16,255
	BRSH _0xC6
; 0000 0166     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xC5
_0xC6:
; 0000 0167 Display1=_empty;
	CALL SUBOPT_0x11
; 0000 0168         Display2=_empty;
; 0000 0169         Display3=_empty;
	CALL SUBOPT_0x14
; 0000 016A         Display4=_empty;
; 0000 016B         for(t=0;t<=4;t++)
_0xC8:
	CPI  R17,5
	BRSH _0xC9
; 0000 016C              for(delay=0;delay<255;delay++)
	LDI  R16,LOW(0)
_0xCB:
	CPI  R16,255
	BRSH _0xCC
; 0000 016D      display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xCB
_0xCC:
; 0000 016E }
	SUBI R17,-1
	RJMP _0xC8
_0xC9:
; 0000 016F          if(ID()==2)
_0xA5:
	RCALL _ID
	CPI  R30,LOW(0x2)
	BREQ PC+2
	RJMP _0xCD
; 0000 0170     {
; 0000 0171 
; 0000 0172         Display1=_empty;
	CALL SUBOPT_0x11
; 0000 0173         Display2=_empty;
; 0000 0174         Display3=_empty;
	CALL SUBOPT_0x14
; 0000 0175         Display4=_empty;
; 0000 0176         for(t=0;t<4;t++)
_0xCF:
	CPI  R17,4
	BRSH _0xD0
; 0000 0177     for(delay=0;delay<255;delay++)
	LDI  R16,LOW(0)
_0xD2:
	CPI  R16,255
	BRSH _0xD3
; 0000 0178      display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xD2
_0xD3:
; 0000 0179 Display1=E;
	SUBI R17,-1
	RJMP _0xCF
_0xD0:
	CALL SUBOPT_0x5
; 0000 017A     Display2=_empty;
; 0000 017B     Display3=_empty;
; 0000 017C     Display4=_empty;
; 0000 017D 
; 0000 017E     for(delay=0;delay<255;delay++)
_0xD5:
	CPI  R16,255
	BRSH _0xD6
; 0000 017F     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xD5
_0xD6:
; 0000 0181 Display1=M;
	CALL SUBOPT_0x7
; 0000 0182     Display2=E;
; 0000 0183     Display3=_empty;
; 0000 0184     Display4=_empty;
; 0000 0185 
; 0000 0186     for(delay=0;delay<255;delay++)
_0xD8:
	CPI  R16,255
	BRSH _0xD9
; 0000 0187     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xD8
_0xD9:
; 0000 0189 Display1=O;
	CALL SUBOPT_0x8
; 0000 018A     Display2=M;
; 0000 018B     Display3=E;
; 0000 018C     Display4=_empty;
; 0000 018D 
; 0000 018E     for(delay=0;delay<255;delay++)
_0xDB:
	CPI  R16,255
	BRSH _0xDC
; 0000 018F     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xDB
_0xDC:
; 0000 0190 Display1=C;
	CALL SUBOPT_0x9
; 0000 0191     Display2=O;
; 0000 0192     Display3=M;
; 0000 0193     Display4=E;
; 0000 0194 
; 0000 0195     for(delay=0;delay<255;delay++)
_0xDE:
	CPI  R16,255
	BRSH _0xDF
; 0000 0196     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xDE
_0xDF:
; 0000 0198 Display1=L;
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	CALL SUBOPT_0xA
; 0000 0199     Display2=C;
; 0000 019A     Display3=O;
; 0000 019B     Display4=M;
; 0000 019C 
; 0000 019D     for(delay=0;delay<255;delay++)
_0xE1:
	CPI  R16,255
	BRSH _0xE2
; 0000 019E     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xE1
_0xE2:
; 0000 019F Display1=L;
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	MOVW R6,R30
; 0000 01A0     Display2=L;
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	MOVW R8,R30
; 0000 01A1     Display3=C;
	CALL SUBOPT_0xC
; 0000 01A2     Display4=O;
; 0000 01A3 
; 0000 01A4     for(delay=0;delay<255;delay++)
_0xE4:
	CPI  R16,255
	BRSH _0xE5
; 0000 01A5     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xE4
_0xE5:
; 0000 01A6 Display1=E;
	CALL SUBOPT_0xD
; 0000 01A7     Display2=L;
; 0000 01A8     Display3=L;
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	MOVW R10,R30
; 0000 01A9     Display4=C;
	LDI  R30,LOW(_C)
	LDI  R31,HIGH(_C)
	MOVW R12,R30
; 0000 01AA 
; 0000 01AB     for(delay=0;delay<255;delay++)
	LDI  R16,LOW(0)
_0xE7:
	CPI  R16,255
	BRSH _0xE8
; 0000 01AC     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xE7
_0xE8:
; 0000 01AE Display1=W;
	CALL SUBOPT_0xE
; 0000 01AF     Display2=E;
; 0000 01B0     Display3=L;
; 0000 01B1     Display4=L;
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	MOVW R12,R30
; 0000 01B2     for(delay=0;delay<255;delay++)
	LDI  R16,LOW(0)
_0xEA:
	CPI  R16,255
	BRSH _0xEB
; 0000 01B3     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xEA
_0xEB:
; 0000 01B4 Display1=_empty;
	CALL SUBOPT_0x10
; 0000 01B5     Display2=W;
; 0000 01B6     Display3=E;
; 0000 01B7     Display4=L;
; 0000 01B8     for(delay=0;delay<255;delay++)
_0xED:
	CPI  R16,255
	BRSH _0xEE
; 0000 01B9     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xED
_0xEE:
; 0000 01BA Display1=_empty;
	CALL SUBOPT_0x11
; 0000 01BB     Display2=_empty;
; 0000 01BC     Display3=W;
	CALL SUBOPT_0x12
; 0000 01BD     Display4=E;
; 0000 01BE     for(delay=0;delay<255;delay++)
_0xF0:
	CPI  R16,255
	BRSH _0xF1
; 0000 01BF     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xF0
_0xF1:
; 0000 01C0 Display1=_empty;
	CALL SUBOPT_0x11
; 0000 01C1     Display2=_empty;
; 0000 01C2     Display3=_empty;
	CALL SUBOPT_0x13
; 0000 01C3     Display4=W;
; 0000 01C4     for(delay=0;delay<255;delay++)
_0xF3:
	CPI  R16,255
	BRSH _0xF4
; 0000 01C5     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xF3
_0xF4:
; 0000 01C6 Display1=_empty;
	CALL SUBOPT_0x11
; 0000 01C7         Display2=_empty;
; 0000 01C8         Display3=_empty;
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R10,R30
; 0000 01C9         Display4=_empty;
	CALL SUBOPT_0xF
; 0000 01CA          for(delay=0;delay<255;delay++)
_0xF6:
	CPI  R16,255
	BRSH _0xF7
; 0000 01CB     display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R16,-1
	RJMP _0xF6
_0xF7:
; 0000 01CC }
; 0000 01CD 
; 0000 01CE 
; 0000 01CF }
_0xCD:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;
;
;void main(void)
; 0000 01D4 {
_main:
; .FSTART _main
; 0000 01D5   char delay=0,t,well_come_massage=1;
; 0000 01D6 
; 0000 01D7     char le;
; 0000 01D8     unsigned int data_ln=0;
; 0000 01D9     DDRC=0xFF;
;	delay -> R17
;	t -> R16
;	well_come_massage -> R19
;	le -> R18
;	data_ln -> R20,R21
	LDI  R17,0
	LDI  R19,1
	__GETWRN 20,21,0
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 01DA     DDRA=0xFF;
	OUT  0x1A,R30
; 0000 01DB     DDRB=0XF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 01DC // USART initialization
; 0000 01DD // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01DE // USART Receiver: On
; 0000 01DF // USART Transmitter: Off
; 0000 01E0 // USART Mode: Asynchronous
; 0000 01E1 // USART Baud Rate: 9600
; 0000 01E2 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01E3 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(144)
	OUT  0xA,R30
; 0000 01E4 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01E5 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01E6 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01E7 // Global enable interrupts
; 0000 01E8 #asm("sei")
	sei
; 0000 01E9     while (1)
_0xF8:
; 0000 01EA     {
; 0000 01EB 
; 0000 01EC 
; 0000 01ED       if(done==1)
	LDS  R26,_done
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0xFB
; 0000 01EE       {
; 0000 01EF       well_come_massage=0;
	LDI  R19,LOW(0)
; 0000 01F0       Display1=_empty;
	CALL SUBOPT_0x11
; 0000 01F1         Display2=_empty;
; 0000 01F2         Display3=_empty;
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R10,R30
; 0000 01F3         Display4=_empty;
	CALL SUBOPT_0xF
; 0000 01F4       for(t=0;t<255;t++)
_0xFD:
	CPI  R16,255
	BRSH _0xFE
; 0000 01F5       {
; 0000 01F6        if(show[t]==0x00)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_show)
	SBCI R31,HIGH(-_show)
	LD   R30,Z
	CPI  R30,0
	BREQ _0xFE
; 0000 01F7        break;
; 0000 01F8       }
	SUBI R16,-1
	RJMP _0xFD
_0xFE:
; 0000 01F9 
; 0000 01FA       data_ln =t;
	MOV  R20,R16
	CLR  R21
; 0000 01FB       rr[1]=data_ln;
	__PUTBMRN _rr,1,20
; 0000 01FC       if(data_ln>4)
	__CPWRN 20,21,5
	BRSH PC+2
	RJMP _0x100
; 0000 01FD      {
; 0000 01FE      data_ln=data_ln/4;
	MOVW R30,R20
	CALL __LSRW2
	MOVW R20,R30
; 0000 01FF        for(le=0;le<data_ln;le++)
	LDI  R18,LOW(0)
_0x102:
	MOVW R30,R20
	MOV  R26,R18
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x103
; 0000 0200        {
; 0000 0201         Search_dis(show,(le*4));
	CALL SUBOPT_0x2
	MOV  R30,R18
	LSL  R30
	LSL  R30
	MOV  R26,R30
	CALL SUBOPT_0x15
; 0000 0202         Display1=Rx_Display;
; 0000 0203         Rx_Display=0;
; 0000 0204         Search_dis(show,(le*4)+1);
	MOV  R30,R18
	LSL  R30
	LSL  R30
	SUBI R30,-LOW(1)
	MOV  R26,R30
	CALL SUBOPT_0x16
; 0000 0205         Display2=Rx_Display;
; 0000 0206         Rx_Display=0;
; 0000 0207         Search_dis(show,(le*4)+2);
	MOV  R30,R18
	LSL  R30
	LSL  R30
	SUBI R30,-LOW(2)
	MOV  R26,R30
	CALL SUBOPT_0x17
; 0000 0208         Display3=Rx_Display;
; 0000 0209         Rx_Display=0;
; 0000 020A         Search_dis(show,(le*4)+3);
	CALL SUBOPT_0x2
	MOV  R30,R18
	LSL  R30
	LSL  R30
	SUBI R30,-LOW(3)
	MOV  R26,R30
	RCALL _Search_dis
; 0000 020B         Display4=Rx_Display;
	MOVW R12,R4
; 0000 020C         Rx_Display=0;
	CLR  R4
	CLR  R5
; 0000 020D          for(t=0;t<5;t++)
	LDI  R16,LOW(0)
_0x105:
	CPI  R16,5
	BRSH _0x106
; 0000 020E         for(delay=0;delay<255;delay++)
	LDI  R17,LOW(0)
_0x108:
	CPI  R17,255
	BRSH _0x109
; 0000 020F         display(Display1,Display2,Display3,Display4);
	CALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x108
_0x109:
; 0000 0210 Display1=_empty;
	SUBI R16,-1
	RJMP _0x105
_0x106:
	CALL SUBOPT_0x11
; 0000 0211         Display2=_empty;
; 0000 0212         Display3=_empty;
	CALL SUBOPT_0x18
; 0000 0213         Display4=_empty;
; 0000 0214 
; 0000 0215       }
	SUBI R18,-1
	RJMP _0x102
_0x103:
; 0000 0216       mul=data_ln*4;
	MOV  R30,R20
	LSL  R30
	LSL  R30
	STS  _mul,R30
; 0000 0217       rr[0]=mul;
	STS  _rr,R30
; 0000 0218 
; 0000 0219       data_ln=rr[1]-rr[0];
	__GETB2MN _rr,1
	CLR  R27
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
; 0000 021A 
; 0000 021B       contin=1;
	LDI  R30,LOW(1)
	STS  _contin,R30
; 0000 021C       }
; 0000 021D         if(contin==1)
_0x100:
	LDS  R26,_contin
	CPI  R26,LOW(0x1)
	BRNE _0x10A
; 0000 021E         {
; 0000 021F 
; 0000 0220             if(data_ln==3)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x10B
; 0000 0221             {
; 0000 0222                 Search_dis(show,mul);
	CALL SUBOPT_0x2
	LDS  R26,_mul
	CALL SUBOPT_0x15
; 0000 0223                 Display1=Rx_Display;
; 0000 0224                 Rx_Display=0;
; 0000 0225                 Search_dis(show,mul+1);
	LDS  R26,_mul
	SUBI R26,-LOW(1)
	CALL SUBOPT_0x16
; 0000 0226                 Display2=Rx_Display;
; 0000 0227                 Rx_Display=0;
; 0000 0228                 Search_dis(show,mul+2);
	LDS  R26,_mul
	SUBI R26,-LOW(2)
	CALL SUBOPT_0x17
; 0000 0229                 Display3=Rx_Display;
; 0000 022A                 Rx_Display=0;
; 0000 022B 
; 0000 022C             }
; 0000 022D             if(data_ln==2)
_0x10B:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x10C
; 0000 022E             {
; 0000 022F                 Search_dis(show,mul);
	CALL SUBOPT_0x2
	LDS  R26,_mul
	CALL SUBOPT_0x15
; 0000 0230                 Display1=Rx_Display;
; 0000 0231                 Rx_Display=0;
; 0000 0232                 Search_dis(show,mul+1);
	LDS  R26,_mul
	SUBI R26,-LOW(1)
	CALL SUBOPT_0x19
; 0000 0233                 Display2=Rx_Display;
; 0000 0234                 Rx_Display=0;
; 0000 0235                 Display3=_empty;
; 0000 0236                 Display4=_empty;
; 0000 0237 
; 0000 0238             }
; 0000 0239             if(data_ln==1)
_0x10C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x10D
; 0000 023A             {
; 0000 023B 
; 0000 023C                 Search_dis(show,mul);
	CALL SUBOPT_0x2
	LDS  R26,_mul
	CALL SUBOPT_0x1A
; 0000 023D                 Display1=Rx_Display;
; 0000 023E                 Rx_Display=0;
; 0000 023F                 Display2=_empty;
; 0000 0240                 Display3=_empty;
; 0000 0241                 Display4=_empty;
; 0000 0242 
; 0000 0243             }
; 0000 0244               for(t=0;t<5;t++)
_0x10D:
	LDI  R16,LOW(0)
_0x10F:
	CPI  R16,5
	BRSH _0x110
; 0000 0245           for(delay=0;delay<255;delay++)
	LDI  R17,LOW(0)
_0x112:
	CPI  R17,255
	BRSH _0x113
; 0000 0246      display(Display1,Display2,Display3,Display4) ;
	CALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x112
_0x113:
; 0000 024A }
	SUBI R16,-1
	RJMP _0x10F
_0x110:
; 0000 024B       else if(contin==0)
	RJMP _0x114
_0x10A:
	LDS  R30,_contin
	CPI  R30,0
	BREQ PC+2
	RJMP _0x115
; 0000 024C       {
; 0000 024D              if(data_ln==4)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x116
; 0000 024E             {
; 0000 024F             Display1=_empty;
	CALL SUBOPT_0x11
; 0000 0250                 Display2=_empty;
; 0000 0251                 Display3=_empty;
	CALL SUBOPT_0x18
; 0000 0252                 Display4=_empty;
; 0000 0253                 Search_dis(show,0);
	CALL SUBOPT_0x2
	LDI  R26,LOW(0)
	CALL SUBOPT_0x15
; 0000 0254                 Display1=Rx_Display;
; 0000 0255                 Rx_Display=0;
; 0000 0256                 Search_dis(show,1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x16
; 0000 0257                 Display2=Rx_Display;
; 0000 0258                 Rx_Display=0;
; 0000 0259                 Search_dis(show,2);
	LDI  R26,LOW(2)
	CALL SUBOPT_0x17
; 0000 025A                 Display3=Rx_Display;
; 0000 025B                  Rx_Display=0;
; 0000 025C                  Search_dis(show,3);
	CALL SUBOPT_0x2
	LDI  R26,LOW(3)
	RCALL _Search_dis
; 0000 025D                 Display4=Rx_Display;
	MOVW R12,R4
; 0000 025E                  Rx_Display=0;
	CLR  R4
	CLR  R5
; 0000 025F 
; 0000 0260             }
; 0000 0261 
; 0000 0262             if(data_ln==3)
_0x116:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x117
; 0000 0263             {
; 0000 0264             Display1=_empty;
	CALL SUBOPT_0x11
; 0000 0265                 Display2=_empty;
; 0000 0266                 Display3=_empty;
	CALL SUBOPT_0x18
; 0000 0267                 Display4=_empty;
; 0000 0268                 Search_dis(show,0);
	CALL SUBOPT_0x2
	LDI  R26,LOW(0)
	CALL SUBOPT_0x15
; 0000 0269                 Display1=Rx_Display;
; 0000 026A                 Rx_Display=0;
; 0000 026B                 Search_dis(show,1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x16
; 0000 026C                 Display2=Rx_Display;
; 0000 026D                 Rx_Display=0;
; 0000 026E                 Search_dis(show,2);
	LDI  R26,LOW(2)
	CALL SUBOPT_0x17
; 0000 026F                 Display3=Rx_Display;
; 0000 0270                  Rx_Display=0;
; 0000 0271 
; 0000 0272             }
; 0000 0273             if(data_ln==2)
_0x117:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x118
; 0000 0274             {
; 0000 0275 
; 0000 0276 
; 0000 0277                 Search_dis(show,0);
	CALL SUBOPT_0x2
	LDI  R26,LOW(0)
	CALL SUBOPT_0x15
; 0000 0278                 Display1=Rx_Display;
; 0000 0279                 Rx_Display=0;
; 0000 027A                 Search_dis(show,1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x19
; 0000 027B                 Display2=Rx_Display;
; 0000 027C                 Rx_Display=0;
; 0000 027D                 Display3=_empty;
; 0000 027E                 Display4=_empty;
; 0000 027F 
; 0000 0280             }
; 0000 0281             if(data_ln==1)
_0x118:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x119
; 0000 0282             {
; 0000 0283 
; 0000 0284                 Search_dis(show,0);
	CALL SUBOPT_0x2
	LDI  R26,LOW(0)
	CALL SUBOPT_0x1A
; 0000 0285                 Display1=Rx_Display;
; 0000 0286                 Rx_Display=0;
; 0000 0287                 Display2=_empty;
; 0000 0288                 Display3=_empty;
; 0000 0289                 Display4=_empty;
; 0000 028A 
; 0000 028B             }
; 0000 028C               for(t=0;t<5;t++)
_0x119:
	LDI  R16,LOW(0)
_0x11B:
	CPI  R16,5
	BRSH _0x11C
; 0000 028D           for(delay=0;delay<255;delay++)
	LDI  R17,LOW(0)
_0x11E:
	CPI  R17,255
	BRSH _0x11F
; 0000 028E      display(Display1,Display2,Display3,Display4) ;
	CALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x11E
_0x11F:
; 0000 0290 }
	SUBI R16,-1
	RJMP _0x11B
_0x11C:
; 0000 0291       }
_0x115:
_0x114:
; 0000 0292       else
	RJMP _0x120
_0xFB:
; 0000 0293       if(well_come_massage==1)
	CPI  R19,1
	BRNE _0x121
; 0000 0294       {
; 0000 0295       WELL_COME();
	RCALL _WELL_COME
; 0000 0296 
; 0000 0297                 }
; 0000 0298 
; 0000 0299 
; 0000 029A       }
_0x121:
_0x120:
	RJMP _0xF8
; 0000 029B 
; 0000 029C      }
_0x122:
	RJMP _0x122
; .FEND
;
;
;
;
;#include <display.h>
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#define up      1
;#define down    0
;
;
;flash char Activator[16]={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
;
;void display(char *MAT1,char *MAT2,char *MAT3,char *MAT4)
; 0001 000B {

	.CSEG
_display:
; .FSTART _display
; 0001 000C    char i=0;
; 0001 000D 
; 0001 000E 
; 0001 000F 
; 0001 0010           for(i=0;i<=7;i++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*MAT1 -> Y+7
;	*MAT2 -> Y+5
;	*MAT3 -> Y+3
;	*MAT4 -> Y+1
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,8
	BRSH _0x20005
; 0001 0011             {
; 0001 0012                 PORTC=MAT1[i];
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0x1B
; 0001 0013                 PORTA=((Activator[i])|(0x0));
	SUBI R30,LOW(-_Activator*2)
	SBCI R31,HIGH(-_Activator*2)
	CALL SUBOPT_0x1C
; 0001 0014                 PORTC=0;PORTA=255;
; 0001 0015 
; 0001 0016 
; 0001 0017 
; 0001 0018                 PORTC=MAT2[i];
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CALL SUBOPT_0x1B
; 0001 0019                 PORTA=((Activator[i+ 8])|(0));
	__ADDW1FN _Activator,8
	CALL SUBOPT_0x1C
; 0001 001A                 PORTC=0;PORTA=255;
; 0001 001B 
; 0001 001C 
; 0001 001D 
; 0001 001E 
; 0001 001F 
; 0001 0020                 PORTC=MAT3[i];
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL SUBOPT_0x1B
; 0001 0021                 PORTA=((Activator[i+(0)])|(0x10));
	__ADDW1FN _Activator,0
	CALL SUBOPT_0x1D
; 0001 0022                 PORTC=0;PORTA=255;
; 0001 0023 
; 0001 0024 
; 0001 0025 
; 0001 0026 
; 0001 0027 
; 0001 0028                 PORTC=MAT4[i];
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0x1B
; 0001 0029                 PORTA=((Activator[i+(8)])|( 0x10));
	__ADDW1FN _Activator,8
	CALL SUBOPT_0x1D
; 0001 002A                 PORTC=0;PORTA=255;
; 0001 002B 
; 0001 002C 
; 0001 002D 
; 0001 002E             }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 002F 
; 0001 0030 
; 0001 0031 }
	LDD  R17,Y+0
	ADIW R28,9
	RET
; .FEND
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__empty:
	.BYTE 0x8
_and:
	.BYTE 0x8
__dollor:
	.BYTE 0x8
__Ad:
	.BYTE 0x8
_star:
	.BYTE 0x8
__per:
	.BYTE 0x8
__power:
	.BYTE 0x8
__dot:
	.BYTE 0x8
__comma:
	.BYTE 0x8
__Square:
	.BYTE 0x8
_A:
	.BYTE 0x8
_B:
	.BYTE 0x8
_C:
	.BYTE 0x8
_D:
	.BYTE 0x8
_E:
	.BYTE 0x8
_F:
	.BYTE 0x8
_G:
	.BYTE 0x8
_H:
	.BYTE 0x8
__I:
	.BYTE 0x8
__J:
	.BYTE 0x8
_K:
	.BYTE 0x8
_L:
	.BYTE 0x8
_M:
	.BYTE 0x8
_N:
	.BYTE 0x8
_O:
	.BYTE 0x8
_P:
	.BYTE 0x8
_Q:
	.BYTE 0x8
_R:
	.BYTE 0x8
_S:
	.BYTE 0x8
_T:
	.BYTE 0x8
_U:
	.BYTE 0x8
_V:
	.BYTE 0x8
_W:
	.BYTE 0x8
_X:
	.BYTE 0x8
_Y:
	.BYTE 0x8
_Z:
	.BYTE 0x8
__0:
	.BYTE 0x8
__1:
	.BYTE 0x8
__2:
	.BYTE 0x8
__3:
	.BYTE 0x8
__4:
	.BYTE 0x8
__5:
	.BYTE 0x8
__6:
	.BYTE 0x8
__7:
	.BYTE 0x8
__8:
	.BYTE 0x8
__9:
	.BYTE 0x8
_contin:
	.BYTE 0x1
_mul:
	.BYTE 0x1
_receive:
	.BYTE 0x1
_finish:
	.BYTE 0x1
_cnt:
	.BYTE 0x1
_flag:
	.BYTE 0x1
_dis:
	.BYTE 0x4
_show:
	.BYTE 0x100
_show1:
	.BYTE 0x100
_done:
	.BYTE 0x1
_j:
	.BYTE 0x1
_sh_cnt:
	.BYTE 0x1
_sh1_cnt:
	.BYTE 0x1
_sh2_cnt:
	.BYTE 0x1
_rr:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES, CODE SIZE REDUCTION:217 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(_dis)
	LDI  R31,HIGH(_dis)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(_show)
	LDI  R31,HIGH(_show)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(_E)
	LDI  R31,HIGH(_E)
	MOVW R6,R30
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R8,R30
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R10,R30
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:186 WORDS
SUBOPT_0x6:
	ST   -Y,R7
	ST   -Y,R6
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	MOVW R26,R12
	JMP  _display

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_M)
	LDI  R31,HIGH(_M)
	MOVW R6,R30
	LDI  R30,LOW(_E)
	LDI  R31,HIGH(_E)
	MOVW R8,R30
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R10,R30
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_O)
	LDI  R31,HIGH(_O)
	MOVW R6,R30
	LDI  R30,LOW(_M)
	LDI  R31,HIGH(_M)
	MOVW R8,R30
	LDI  R30,LOW(_E)
	LDI  R31,HIGH(_E)
	MOVW R10,R30
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(_C)
	LDI  R31,HIGH(_C)
	MOVW R6,R30
	LDI  R30,LOW(_O)
	LDI  R31,HIGH(_O)
	MOVW R8,R30
	LDI  R30,LOW(_M)
	LDI  R31,HIGH(_M)
	MOVW R10,R30
	LDI  R30,LOW(_E)
	LDI  R31,HIGH(_E)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	MOVW R6,R30
	LDI  R30,LOW(_C)
	LDI  R31,HIGH(_C)
	MOVW R8,R30
	LDI  R30,LOW(_O)
	LDI  R31,HIGH(_O)
	MOVW R10,R30
	LDI  R30,LOW(_M)
	LDI  R31,HIGH(_M)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xB:
	MOVW R6,R30
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(_C)
	LDI  R31,HIGH(_C)
	MOVW R10,R30
	LDI  R30,LOW(_O)
	LDI  R31,HIGH(_O)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(_E)
	LDI  R31,HIGH(_E)
	MOVW R6,R30
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(_W)
	LDI  R31,HIGH(_W)
	MOVW R6,R30
	LDI  R30,LOW(_E)
	LDI  R31,HIGH(_E)
	MOVW R8,R30
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R6,R30
	LDI  R30,LOW(_W)
	LDI  R31,HIGH(_W)
	MOVW R8,R30
	LDI  R30,LOW(_E)
	LDI  R31,HIGH(_E)
	MOVW R10,R30
	LDI  R30,LOW(_L)
	LDI  R31,HIGH(_L)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(_W)
	LDI  R31,HIGH(_W)
	MOVW R10,R30
	LDI  R30,LOW(_E)
	LDI  R31,HIGH(_E)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R10,R30
	LDI  R30,LOW(_W)
	LDI  R31,HIGH(_W)
	MOVW R12,R30
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R10,R30
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R12,R30
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x15:
	CALL _Search_dis
	MOVW R6,R4
	CLR  R4
	CLR  R5
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16:
	CALL _Search_dis
	MOVW R8,R4
	CLR  R4
	CLR  R5
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	CALL _Search_dis
	MOVW R10,R4
	CLR  R4
	CLR  R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R10,R30
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	CALL _Search_dis
	MOVW R8,R4
	CLR  R4
	CLR  R5
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	CALL _Search_dis
	MOVW R6,R4
	CLR  R4
	CLR  R5
	LDI  R30,LOW(__empty)
	LDI  R31,HIGH(__empty)
	MOVW R8,R30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1B:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	OUT  0x15,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LPM  R30,Z
	OUT  0x1B,R30
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LPM  R30,Z
	ORI  R30,0x10
	OUT  0x1B,R30
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	RET


	.CSEG
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

;END OF CODE MARKER
__END_OF_CODE:
