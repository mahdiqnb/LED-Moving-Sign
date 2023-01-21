
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
;Global 'const' stored in FLASH: Yes
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
	.DEF _input=R5
	.DEF _IT=R4
	.DEF _cnt0=R7
	.DEF _set=R6
	.DEF _dis=R9
	.DEF _x=R8
	.DEF _y=R11
	.DEF _cnt2=R10
	.DEF _cnt4=R13
	.DEF _cnt5=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
_keycode:
	.DB  0x0,0x0,0x1,0x0,0x2,0x0,0x3,0x0
	.DB  0x4,0x0,0x5,0x0,0x6,0x0,0x7,0x0
	.DB  0x8,0x0,0x9,0x0,0xA,0x0,0xB,0x0
	.DB  0xC,0x0,0xD,0x0,0xE,0x0,0xF,0x0
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x10,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x1
_0x20003:
	.DB  0x1
_0x20000:
	.DB  0x21,0x0,0x40,0x0,0x24,0x0,0x20,0x0
	.DB  0x2C,0x0,0x2E,0x0,0x5E,0x0,0x25,0x0
	.DB  0x26,0x0,0x30,0x0,0x41,0x0,0x42,0x0
	.DB  0x43,0x0,0x44,0x0,0x45,0x0,0x46,0x0
	.DB  0x47,0x0,0x48,0x0,0x49,0x0,0x4A,0x0
	.DB  0x4B,0x0,0x4C,0x0,0x4D,0x0,0x4E,0x0
	.DB  0x4F,0x0,0x50,0x0,0x51,0x0,0x52,0x0
	.DB  0x53,0x0,0x54,0x0,0x55,0x0,0x56,0x0
	.DB  0x57,0x0,0x58,0x0,0x59,0x0,0x5A,0x0
	.DB  0x2A,0x0,0x23,0x0,0x31,0x0,0x32,0x0
	.DB  0x33,0x0,0x34,0x0,0x35,0x0,0x36,0x0
	.DB  0x37,0x0,0x38,0x0,0x39,0x0
_0x2100060:
	.DB  0x1
_0x2100000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _alpha
	.DW  _0x3*2

	.DW  0x01
	.DW  _L1
	.DW  _0x20003*2

	.DW  0x02
	.DW  _0x20009
	.DW  _0x20000*2

	.DW  0x02
	.DW  _0x20009+2
	.DW  _0x20000*2+2

	.DW  0x02
	.DW  _0x20009+4
	.DW  _0x20000*2+4

	.DW  0x02
	.DW  _0x20009+6
	.DW  _0x20000*2+6

	.DW  0x02
	.DW  _0x20009+8
	.DW  _0x20000*2+6

	.DW  0x02
	.DW  _0x20009+10
	.DW  _0x20000*2+8

	.DW  0x02
	.DW  _0x20009+12
	.DW  _0x20000*2+10

	.DW  0x02
	.DW  _0x20009+14
	.DW  _0x20000*2+12

	.DW  0x02
	.DW  _0x20009+16
	.DW  _0x20000*2+14

	.DW  0x02
	.DW  _0x20009+18
	.DW  _0x20000*2+16

	.DW  0x02
	.DW  _0x20009+20
	.DW  _0x20000*2+18

	.DW  0x02
	.DW  _0x20009+22
	.DW  _0x20000*2+20

	.DW  0x02
	.DW  _0x20009+24
	.DW  _0x20000*2+22

	.DW  0x02
	.DW  _0x20009+26
	.DW  _0x20000*2+24

	.DW  0x02
	.DW  _0x20009+28
	.DW  _0x20000*2+26

	.DW  0x02
	.DW  _0x20009+30
	.DW  _0x20000*2+28

	.DW  0x02
	.DW  _0x20009+32
	.DW  _0x20000*2+30

	.DW  0x02
	.DW  _0x20009+34
	.DW  _0x20000*2+32

	.DW  0x02
	.DW  _0x20009+36
	.DW  _0x20000*2+34

	.DW  0x02
	.DW  _0x20009+38
	.DW  _0x20000*2+36

	.DW  0x02
	.DW  _0x20009+40
	.DW  _0x20000*2+38

	.DW  0x02
	.DW  _0x20009+42
	.DW  _0x20000*2+40

	.DW  0x02
	.DW  _0x20009+44
	.DW  _0x20000*2+42

	.DW  0x02
	.DW  _0x20009+46
	.DW  _0x20000*2+44

	.DW  0x02
	.DW  _0x20009+48
	.DW  _0x20000*2+46

	.DW  0x02
	.DW  _0x20009+50
	.DW  _0x20000*2+48

	.DW  0x02
	.DW  _0x20009+52
	.DW  _0x20000*2+50

	.DW  0x02
	.DW  _0x20009+54
	.DW  _0x20000*2+52

	.DW  0x02
	.DW  _0x20009+56
	.DW  _0x20000*2+54

	.DW  0x02
	.DW  _0x20009+58
	.DW  _0x20000*2+56

	.DW  0x02
	.DW  _0x20009+60
	.DW  _0x20000*2+58

	.DW  0x02
	.DW  _0x20009+62
	.DW  _0x20000*2+60

	.DW  0x02
	.DW  _0x20009+64
	.DW  _0x20000*2+62

	.DW  0x02
	.DW  _0x20009+66
	.DW  _0x20000*2+64

	.DW  0x02
	.DW  _0x20009+68
	.DW  _0x20000*2+66

	.DW  0x02
	.DW  _0x20009+70
	.DW  _0x20000*2+68

	.DW  0x02
	.DW  _0x20009+72
	.DW  _0x20000*2+70

	.DW  0x02
	.DW  _0x2005E
	.DW  _0x20000*2+72

	.DW  0x02
	.DW  _0x2005E+2
	.DW  _0x20000*2+18

	.DW  0x02
	.DW  _0x2005E+4
	.DW  _0x20000*2+74

	.DW  0x02
	.DW  _0x2005E+6
	.DW  _0x20000*2+76

	.DW  0x02
	.DW  _0x2005E+8
	.DW  _0x20000*2+78

	.DW  0x02
	.DW  _0x2005E+10
	.DW  _0x20000*2+80

	.DW  0x02
	.DW  _0x2005E+12
	.DW  _0x20000*2+82

	.DW  0x02
	.DW  _0x2005E+14
	.DW  _0x20000*2+84

	.DW  0x02
	.DW  _0x2005E+16
	.DW  _0x20000*2+86

	.DW  0x02
	.DW  _0x2005E+18
	.DW  _0x20000*2+88

	.DW  0x02
	.DW  _0x2005E+20
	.DW  _0x20000*2+90

	.DW  0x02
	.DW  _0x2005E+22
	.DW  _0x20000*2+92

	.DW  0x01
	.DW  __seed_G108
	.DW  _0x2100060*2

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
;#include <glcd.h>
;#include <font5x7.h>
;#include <delay.h>
;#include <stdio.h>
;#include <string.h>
;#include <display.h>
;flash int keycode[4][4]={{0,1,2,3},{4,5,6,7},{8,9,10,11},{12,13,14,15}};
;char input=16,IT=0,cnt0=0,set=0,dis,x=0,y=0,cnt2,cnt4,cnt5,cnt6,cnt8,cnt9,cnt10,cnt12,cnt13,cnt14,crt,backcnt,str[256],i ...
;volatile char alpha=1;

	.DSEG
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 000D {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
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
; 0000 000E 
; 0000 000F char temp=0,col=10,row=10;
; 0000 0010 
; 0000 0011 temp=(PINC &0X0F);
	CALL __SAVELOCR4
;	temp -> R17
;	col -> R16
;	row -> R19
	LDI  R17,0
	LDI  R16,10
	LDI  R19,10
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0000 0012 if(temp ==14)
	CPI  R17,14
	BRNE _0x4
; 0000 0013 row=0;
	LDI  R19,LOW(0)
; 0000 0014 if(temp ==13)
_0x4:
	CPI  R17,13
	BRNE _0x5
; 0000 0015 row=1;
	LDI  R19,LOW(1)
; 0000 0016 if(temp ==11)
_0x5:
	CPI  R17,11
	BRNE _0x6
; 0000 0017 row=2;
	LDI  R19,LOW(2)
; 0000 0018 if(temp ==7)
_0x6:
	CPI  R17,7
	BRNE _0x7
; 0000 0019 row=3;
	LDI  R19,LOW(3)
; 0000 001A 
; 0000 001B 
; 0000 001C delay_ms(20);
_0x7:
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 001D 
; 0000 001E PORTC=0XEF;
	LDI  R30,LOW(239)
	CALL SUBOPT_0x0
; 0000 001F delay_us(50);
; 0000 0020 if((PINC&0X0F)!=0X0F)
	BREQ _0x8
; 0000 0021 col=0;
	LDI  R16,LOW(0)
; 0000 0022 
; 0000 0023 else
	RJMP _0x9
_0x8:
; 0000 0024 {
; 0000 0025 PORTC=0XDF;
	LDI  R30,LOW(223)
	CALL SUBOPT_0x0
; 0000 0026 delay_us(50);
; 0000 0027 if((PINC &0X0F)!=0X0F)
	BREQ _0xA
; 0000 0028 col=1;
	LDI  R16,LOW(1)
; 0000 0029 else
	RJMP _0xB
_0xA:
; 0000 002A {
; 0000 002B PORTC=0xBF;
	LDI  R30,LOW(191)
	CALL SUBOPT_0x0
; 0000 002C delay_us(50);
; 0000 002D if((PINC&0X0F)!=0X0F)
	BREQ _0xC
; 0000 002E col=2;
	LDI  R16,LOW(2)
; 0000 002F else
	RJMP _0xD
_0xC:
; 0000 0030 {
; 0000 0031 PORTC=0x7F;
	LDI  R30,LOW(127)
	CALL SUBOPT_0x0
; 0000 0032 delay_us(50);
; 0000 0033 if((PINC&0X0F)!=0X0F)
	BREQ _0xE
; 0000 0034 col=3;
	LDI  R16,LOW(3)
; 0000 0035 }
_0xE:
_0xD:
; 0000 0036 }
_0xB:
; 0000 0037 }
_0x9:
; 0000 0038 
; 0000 0039 input=keycode[row][col];
	MOV  R30,R19
	LDI  R31,0
	CALL __LSLW3
	SUBI R30,LOW(-_keycode*2)
	SBCI R31,HIGH(-_keycode*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LPM  R5,Z
; 0000 003A 
; 0000 003B PORTC=0X0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 003C IT=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 003D 
; 0000 003E while(PIND.2==0);
_0xF:
	SBIS 0x10,2
	RJMP _0xF
; 0000 003F 
; 0000 0040 }
	CALL __LOADLOCR4
	ADIW R28,4
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
;void main(void)
; 0000 0042 {
_main:
; .FSTART _main
; 0000 0043 
; 0000 0044 GLCDINIT_t glcd_init_data;
; 0000 0045 DDRC=0XF0;
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 0046 PORTC=0X0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 0047 DDRD.0=0;
	CBI  0x11,0
; 0000 0048 DDRD.1=1;
	SBI  0x11,1
; 0000 0049 DDRD.2=0;
	CBI  0x11,2
; 0000 004A // USART initialization
; 0000 004B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 004C // USART Receiver: On
; 0000 004D // USART Transmitter: On
; 0000 004E // USART Mode: Asynchronous
; 0000 004F // USART Baud Rate: 9600
; 0000 0050 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0051 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0052 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0053 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0054 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0055 
; 0000 0056 
; 0000 0057 // Graphic Display Controller initialization
; 0000 0058 // The KS0108 connections are specified in the
; 0000 0059 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 005A // DB0 - PORTA Bit 0
; 0000 005B // DB1 - PORTA Bit 1
; 0000 005C // DB2 - PORTA Bit 2
; 0000 005D // DB3 - PORTA Bit 3
; 0000 005E // DB4 - PORTA Bit 4
; 0000 005F // DB5 - PORTA Bit 5
; 0000 0060 // DB6 - PORTA Bit 6
; 0000 0061 // DB7 - PORTA Bit 7
; 0000 0062 // E - PORTB Bit 0
; 0000 0063 // RD /WR - PORTB Bit 1
; 0000 0064 // RS - PORTB Bit 2
; 0000 0065 // /RST - PORTB Bit 3
; 0000 0066 // CS1 - PORTB Bit 4
; 0000 0067 // CS2 - PORTB Bit 5
; 0000 0068 
; 0000 0069 // Specify the current font for displaying text
; 0000 006A glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 006B // No function is used for reading
; 0000 006C // image data from external memory
; 0000 006D glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 006E // No function is used for writing
; 0000 006F // image data to external memory
; 0000 0070 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0071 
; 0000 0072 glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 0073  // External Interrupt(s) initialization
; 0000 0074 // INT0: On
; 0000 0075 // INT0 Mode: Low level
; 0000 0076 // INT1: Off
; 0000 0077 // INT2: Off
; 0000 0078 GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0079 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 007A MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 007B GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 007C 
; 0000 007D // Global enable interrupts
; 0000 007E #asm("sei")
	sei
; 0000 007F while (1)
_0x18:
; 0000 0080       {
; 0000 0081 if(IT==1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x1B
; 0000 0082    {
; 0000 0083 
; 0000 0084     if(alpha==1)
	LDS  R26,_alpha
	CPI  R26,LOW(0x1)
	BRNE _0x1C
; 0000 0085     dis_alpha();
	RCALL _dis_alpha
; 0000 0086 
; 0000 0087 
; 0000 0088     if(alpha==0)
_0x1C:
	LDS  R30,_alpha
	CPI  R30,0
	BRNE _0x1D
; 0000 0089     dis_num();
	RCALL _dis_num
; 0000 008A 
; 0000 008B    }
_0x1D:
; 0000 008C   }
_0x1B:
	RJMP _0x18
; 0000 008D }
_0x1E:
	RJMP _0x1E
; .FEND
;extern char input,IT,cnt0,set,dis,x,y,cnt2,cnt4,cnt5,cnt6,cnt8,cnt9,cnt10,cnt12,cnt13,cnt14,crt,backcnt,str[256],i;
;extern  volatile char alpha;
;char Local_1[4],Local_2[4];
;char L=0,Cnt,k=0,L1=1,L2=0;

	.DSEG
;#include <glcd.h>
;#include <font5x7.h>
;#include <stdio.h>
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
;#include <string.h>
;#include <display.h>
;#include <delay.h>
;void dis_alpha(void)
; 0001 000C {

	.CSEG
_dis_alpha:
; .FSTART _dis_alpha
; 0001 000D switch(input)
	MOV  R30,R5
	LDI  R31,0
; 0001 000E     {
; 0001 000F     case 2 :
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20007
; 0001 0010     IT=0;
	CLR  R4
; 0001 0011     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 0012     if(cnt0==0)
	TST  R7
	BRNE _0x20008
; 0001 0013     {
; 0001 0014         glcd_outtextxy(x,y,"!");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,0
	CALL _glcd_outtextxy
; 0001 0015         dis='!';
	LDI  R30,LOW(33)
	MOV  R9,R30
; 0001 0016     }
; 0001 0017     if(cnt0==1)
_0x20008:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x2000A
; 0001 0018     {
; 0001 0019         glcd_outtextxy(x,y,"@");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,2
	CALL _glcd_outtextxy
; 0001 001A         dis='@';
	LDI  R30,LOW(64)
	MOV  R9,R30
; 0001 001B     }
; 0001 001C     if(cnt0==2)
_0x2000A:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x2000B
; 0001 001D     {
; 0001 001E         glcd_outtextxy(x,y,"$");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,4
	CALL _glcd_outtextxy
; 0001 001F         dis='$';
	LDI  R30,LOW(36)
	MOV  R9,R30
; 0001 0020     }
; 0001 0021     cnt0++;
_0x2000B:
	INC  R7
; 0001 0022     if(cnt0>2)
	LDI  R30,LOW(2)
	CP   R30,R7
	BRSH _0x2000C
; 0001 0023         cnt0=0;
	CLR  R7
; 0001 0024 
; 0001 0025     break;
_0x2000C:
	RJMP _0x20006
; 0001 0026 
; 0001 0027     case 1 :
_0x20007:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2000D
; 0001 0028 
; 0001 0029     if(set==0)
	TST  R6
	BRNE _0x2000E
; 0001 002A     {
; 0001 002B     x+=6;
	LDI  R30,LOW(6)
	ADD  R8,R30
; 0001 002C     IT=0;
	CALL SUBOPT_0x1
; 0001 002D     set=1;
; 0001 002E     glcd_outtextxy(x,y," ");
	__POINTW2MN _0x20009,6
	CALL _glcd_outtextxy
; 0001 002F     dis=' ';
	LDI  R30,LOW(32)
	MOV  R9,R30
; 0001 0030 
; 0001 0031     if(x>128)
	LDI  R30,LOW(128)
	CP   R30,R8
	BRSH _0x2000F
; 0001 0032     {
; 0001 0033          x=0;
	CLR  R8
; 0001 0034         y+=5;
	LDI  R30,LOW(5)
	ADD  R11,R30
; 0001 0035         if(y>64)
	LDI  R30,LOW(64)
	CP   R30,R11
	BRSH _0x20010
; 0001 0036          y=0;
	CLR  R11
; 0001 0037     }
_0x20010:
; 0001 0038 
; 0001 0039     }
_0x2000F:
; 0001 003A     else
	RJMP _0x20011
_0x2000E:
; 0001 003B     {
; 0001 003C     IT=0;
	CLR  R4
; 0001 003D     glcd_outtextxy(x,y," ");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,8
	CALL _glcd_outtextxy
; 0001 003E     dis=' ';
	LDI  R30,LOW(32)
	MOV  R9,R30
; 0001 003F     }
_0x20011:
; 0001 0040     break;
	RJMP _0x20006
; 0001 0041 
; 0001 0042     case 0 :
_0x2000D:
	SBIW R30,0
	BRNE _0x20012
; 0001 0043 
; 0001 0044     IT=0;
	CLR  R4
; 0001 0045     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 0046     if(cnt2==0)
	TST  R10
	BRNE _0x20013
; 0001 0047     {
; 0001 0048         glcd_outtextxy(x,y,",");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,10
	CALL _glcd_outtextxy
; 0001 0049         dis=',';
	LDI  R30,LOW(44)
	MOV  R9,R30
; 0001 004A     }
; 0001 004B     if(cnt2==1)
_0x20013:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x20014
; 0001 004C     {
; 0001 004D         glcd_outtextxy(x,y,".");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,12
	CALL _glcd_outtextxy
; 0001 004E         dis='.';
	LDI  R30,LOW(46)
	MOV  R9,R30
; 0001 004F     }
; 0001 0050     if(cnt2==2)
_0x20014:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x20015
; 0001 0051     {
; 0001 0052         glcd_outtextxy(x,y,"^");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,14
	CALL _glcd_outtextxy
; 0001 0053         dis='^';
	LDI  R30,LOW(94)
	MOV  R9,R30
; 0001 0054     }
; 0001 0055     if(cnt2==3)
_0x20015:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x20016
; 0001 0056     {
; 0001 0057         glcd_outtextxy(x,y,"%");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,16
	CALL _glcd_outtextxy
; 0001 0058         dis='%';
	LDI  R30,LOW(37)
	MOV  R9,R30
; 0001 0059     }
; 0001 005A     cnt2++;
_0x20016:
	INC  R10
; 0001 005B     if(cnt2>3)
	LDI  R30,LOW(3)
	CP   R30,R10
	BRSH _0x20017
; 0001 005C         cnt2=0;
	CLR  R10
; 0001 005D 
; 0001 005E     break;
_0x20017:
	RJMP _0x20006
; 0001 005F 
; 0001 0060 
; 0001 0061 
; 0001 0062     case 4 :
_0x20012:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20018
; 0001 0063 
; 0001 0064     IT=0;
	CLR  R4
; 0001 0065     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 0066     if(cnt4==0)
	TST  R13
	BRNE _0x20019
; 0001 0067     {
; 0001 0068         glcd_outtextxy(x,y,"&");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,18
	CALL _glcd_outtextxy
; 0001 0069         dis='&';
	LDI  R30,LOW(38)
	MOV  R9,R30
; 0001 006A     }
; 0001 006B     if(cnt4==1)
_0x20019:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x2001A
; 0001 006C     {
; 0001 006D         glcd_outtextxy(x,y,"0");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,20
	CALL _glcd_outtextxy
; 0001 006E         dis='0';
	LDI  R30,LOW(48)
	MOV  R9,R30
; 0001 006F     }
; 0001 0070     cnt4++;
_0x2001A:
	INC  R13
; 0001 0071     if(cnt4>1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRSH _0x2001B
; 0001 0072         cnt4=0;
	CLR  R13
; 0001 0073 
; 0001 0074     break;
_0x2001B:
	RJMP _0x20006
; 0001 0075 
; 0001 0076     case 5 :
_0x20018:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2001C
; 0001 0077 
; 0001 0078     IT=0;
	CLR  R4
; 0001 0079     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 007A 
; 0001 007B     if(cnt5==0)
	TST  R12
	BRNE _0x2001D
; 0001 007C     {
; 0001 007D         glcd_outtextxy(x,y,"A");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,22
	CALL _glcd_outtextxy
; 0001 007E         dis='A';
	LDI  R30,LOW(65)
	MOV  R9,R30
; 0001 007F     }
; 0001 0080     if(cnt5==1)
_0x2001D:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x2001E
; 0001 0081     {
; 0001 0082         glcd_outtextxy(x,y,"B");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,24
	CALL _glcd_outtextxy
; 0001 0083         dis='B';
	LDI  R30,LOW(66)
	MOV  R9,R30
; 0001 0084 
; 0001 0085     }
; 0001 0086     if(cnt5==2)
_0x2001E:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x2001F
; 0001 0087     {
; 0001 0088         glcd_outtextxy(x,y,"C");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,26
	CALL _glcd_outtextxy
; 0001 0089         dis='C';
	LDI  R30,LOW(67)
	MOV  R9,R30
; 0001 008A     }
; 0001 008B     cnt5++;
_0x2001F:
	INC  R12
; 0001 008C     if(cnt5>2)
	LDI  R30,LOW(2)
	CP   R30,R12
	BRSH _0x20020
; 0001 008D      cnt5=0;
	CLR  R12
; 0001 008E 
; 0001 008F     break;
_0x20020:
	RJMP _0x20006
; 0001 0090 
; 0001 0091     case 6 :
_0x2001C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20021
; 0001 0092 
; 0001 0093     IT=0;
	CLR  R4
; 0001 0094     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 0095     if(cnt6==0)
	LDS  R30,_cnt6
	CPI  R30,0
	BRNE _0x20022
; 0001 0096     {
; 0001 0097         glcd_outtextxy(x,y,"D");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,28
	CALL _glcd_outtextxy
; 0001 0098         dis='D';
	LDI  R30,LOW(68)
	MOV  R9,R30
; 0001 0099     }
; 0001 009A     if(cnt6==1)
_0x20022:
	LDS  R26,_cnt6
	CPI  R26,LOW(0x1)
	BRNE _0x20023
; 0001 009B     {
; 0001 009C         glcd_outtextxy(x,y,"E");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,30
	CALL _glcd_outtextxy
; 0001 009D         dis='E';
	LDI  R30,LOW(69)
	MOV  R9,R30
; 0001 009E     }
; 0001 009F     if(cnt6==2)
_0x20023:
	LDS  R26,_cnt6
	CPI  R26,LOW(0x2)
	BRNE _0x20024
; 0001 00A0     {
; 0001 00A1         glcd_outtextxy(x,y,"F");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,32
	CALL _glcd_outtextxy
; 0001 00A2         dis='F';
	LDI  R30,LOW(70)
	MOV  R9,R30
; 0001 00A3     }
; 0001 00A4     cnt6++;
_0x20024:
	LDS  R30,_cnt6
	SUBI R30,-LOW(1)
	STS  _cnt6,R30
; 0001 00A5     if(cnt6>2)
	LDS  R26,_cnt6
	CPI  R26,LOW(0x3)
	BRLO _0x20025
; 0001 00A6         cnt6=0;
	LDI  R30,LOW(0)
	STS  _cnt6,R30
; 0001 00A7 
; 0001 00A8     break;
_0x20025:
	RJMP _0x20006
; 0001 00A9 
; 0001 00AA     case 8 :
_0x20021:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x20026
; 0001 00AB 
; 0001 00AC     IT=0;
	CLR  R4
; 0001 00AD     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 00AE     if(cnt8==0)
	LDS  R30,_cnt8
	CPI  R30,0
	BRNE _0x20027
; 0001 00AF     {
; 0001 00B0         glcd_outtextxy(x,y,"G");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,34
	CALL _glcd_outtextxy
; 0001 00B1         dis='G';
	LDI  R30,LOW(71)
	MOV  R9,R30
; 0001 00B2     }
; 0001 00B3     if(cnt8==1)
_0x20027:
	LDS  R26,_cnt8
	CPI  R26,LOW(0x1)
	BRNE _0x20028
; 0001 00B4     {
; 0001 00B5         glcd_outtextxy(x,y,"H");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,36
	CALL _glcd_outtextxy
; 0001 00B6         dis='H';
	LDI  R30,LOW(72)
	MOV  R9,R30
; 0001 00B7     }
; 0001 00B8     if(cnt8==2)
_0x20028:
	LDS  R26,_cnt8
	CPI  R26,LOW(0x2)
	BRNE _0x20029
; 0001 00B9     {
; 0001 00BA         glcd_outtextxy(x,y,"I");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,38
	CALL _glcd_outtextxy
; 0001 00BB         dis='I';
	LDI  R30,LOW(73)
	MOV  R9,R30
; 0001 00BC     }
; 0001 00BD     cnt8++;
_0x20029:
	LDS  R30,_cnt8
	SUBI R30,-LOW(1)
	STS  _cnt8,R30
; 0001 00BE     if(cnt8>2)
	LDS  R26,_cnt8
	CPI  R26,LOW(0x3)
	BRLO _0x2002A
; 0001 00BF         cnt8=0;
	LDI  R30,LOW(0)
	STS  _cnt8,R30
; 0001 00C0 
; 0001 00C1     break;
_0x2002A:
	RJMP _0x20006
; 0001 00C2 
; 0001 00C3     case 9 :
_0x20026:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x2002B
; 0001 00C4 
; 0001 00C5     IT=0;
	CLR  R4
; 0001 00C6     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 00C7     if(cnt9==0)
	LDS  R30,_cnt9
	CPI  R30,0
	BRNE _0x2002C
; 0001 00C8     {
; 0001 00C9         glcd_outtextxy(x,y,"J");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,40
	CALL _glcd_outtextxy
; 0001 00CA         dis='J';
	LDI  R30,LOW(74)
	MOV  R9,R30
; 0001 00CB     }
; 0001 00CC     if(cnt9==1)
_0x2002C:
	LDS  R26,_cnt9
	CPI  R26,LOW(0x1)
	BRNE _0x2002D
; 0001 00CD     {
; 0001 00CE         glcd_outtextxy(x,y,"K");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,42
	CALL _glcd_outtextxy
; 0001 00CF         dis='K';
	LDI  R30,LOW(75)
	MOV  R9,R30
; 0001 00D0     }
; 0001 00D1     if(cnt9==2)
_0x2002D:
	LDS  R26,_cnt9
	CPI  R26,LOW(0x2)
	BRNE _0x2002E
; 0001 00D2     {
; 0001 00D3         glcd_outtextxy(x,y,"L");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,44
	CALL _glcd_outtextxy
; 0001 00D4         dis='L';
	LDI  R30,LOW(76)
	MOV  R9,R30
; 0001 00D5     }
; 0001 00D6     cnt9++;
_0x2002E:
	LDS  R30,_cnt9
	SUBI R30,-LOW(1)
	STS  _cnt9,R30
; 0001 00D7     if(cnt9>2)
	LDS  R26,_cnt9
	CPI  R26,LOW(0x3)
	BRLO _0x2002F
; 0001 00D8         cnt9=0;
	LDI  R30,LOW(0)
	STS  _cnt9,R30
; 0001 00D9 
; 0001 00DA     break;
_0x2002F:
	RJMP _0x20006
; 0001 00DB 
; 0001 00DC     case 10 :
_0x2002B:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x20030
; 0001 00DD 
; 0001 00DE     IT=0;
	CLR  R4
; 0001 00DF     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 00E0     if(cnt10==0)
	LDS  R30,_cnt10
	CPI  R30,0
	BRNE _0x20031
; 0001 00E1     {
; 0001 00E2         glcd_outtextxy(x,y,"M");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,46
	CALL _glcd_outtextxy
; 0001 00E3         dis='M';
	LDI  R30,LOW(77)
	MOV  R9,R30
; 0001 00E4     }
; 0001 00E5     if(cnt10==1)
_0x20031:
	LDS  R26,_cnt10
	CPI  R26,LOW(0x1)
	BRNE _0x20032
; 0001 00E6     {
; 0001 00E7         glcd_outtextxy(x,y,"N");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,48
	CALL _glcd_outtextxy
; 0001 00E8          dis='N';
	LDI  R30,LOW(78)
	MOV  R9,R30
; 0001 00E9     }
; 0001 00EA     if(cnt10==2)
_0x20032:
	LDS  R26,_cnt10
	CPI  R26,LOW(0x2)
	BRNE _0x20033
; 0001 00EB     {
; 0001 00EC         glcd_outtextxy(x,y,"O");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,50
	CALL _glcd_outtextxy
; 0001 00ED         dis='O';
	LDI  R30,LOW(79)
	MOV  R9,R30
; 0001 00EE     }
; 0001 00EF     cnt10++;
_0x20033:
	LDS  R30,_cnt10
	SUBI R30,-LOW(1)
	STS  _cnt10,R30
; 0001 00F0     if(cnt10>2)
	LDS  R26,_cnt10
	CPI  R26,LOW(0x3)
	BRLO _0x20034
; 0001 00F1      cnt10=0;
	LDI  R30,LOW(0)
	STS  _cnt10,R30
; 0001 00F2 
; 0001 00F3     break;
_0x20034:
	RJMP _0x20006
; 0001 00F4 
; 0001 00F5     case 12 :
_0x20030:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x20035
; 0001 00F6 
; 0001 00F7     IT=0;
	CLR  R4
; 0001 00F8     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 00F9     if(cnt12==0)
	LDS  R30,_cnt12
	CPI  R30,0
	BRNE _0x20036
; 0001 00FA     {
; 0001 00FB         glcd_outtextxy(x,y,"P");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,52
	CALL _glcd_outtextxy
; 0001 00FC         dis='P';
	LDI  R30,LOW(80)
	MOV  R9,R30
; 0001 00FD     }
; 0001 00FE     if(cnt12==1)
_0x20036:
	LDS  R26,_cnt12
	CPI  R26,LOW(0x1)
	BRNE _0x20037
; 0001 00FF     {
; 0001 0100         glcd_outtextxy(x,y,"Q");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,54
	CALL _glcd_outtextxy
; 0001 0101         dis='Q';
	LDI  R30,LOW(81)
	MOV  R9,R30
; 0001 0102     }
; 0001 0103     if(cnt12==2)
_0x20037:
	LDS  R26,_cnt12
	CPI  R26,LOW(0x2)
	BRNE _0x20038
; 0001 0104     {
; 0001 0105         glcd_outtextxy(x,y,"R");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,56
	CALL _glcd_outtextxy
; 0001 0106         dis='R';
	LDI  R30,LOW(82)
	MOV  R9,R30
; 0001 0107     }
; 0001 0108     if(cnt12==3)
_0x20038:
	LDS  R26,_cnt12
	CPI  R26,LOW(0x3)
	BRNE _0x20039
; 0001 0109     {
; 0001 010A         glcd_outtextxy(x,y,"S");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,58
	CALL _glcd_outtextxy
; 0001 010B         dis='S';
	LDI  R30,LOW(83)
	MOV  R9,R30
; 0001 010C     }
; 0001 010D     cnt12++;
_0x20039:
	LDS  R30,_cnt12
	SUBI R30,-LOW(1)
	STS  _cnt12,R30
; 0001 010E     if(cnt12>3)
	LDS  R26,_cnt12
	CPI  R26,LOW(0x4)
	BRLO _0x2003A
; 0001 010F         cnt12=0;
	LDI  R30,LOW(0)
	STS  _cnt12,R30
; 0001 0110 
; 0001 0111     break;
_0x2003A:
	RJMP _0x20006
; 0001 0112 
; 0001 0113     case 13 :
_0x20035:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x2003B
; 0001 0114 
; 0001 0115     IT=0;
	CLR  R4
; 0001 0116     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 0117     if(cnt13==0)
	LDS  R30,_cnt13
	CPI  R30,0
	BRNE _0x2003C
; 0001 0118     {
; 0001 0119         glcd_outtextxy(x,y,"T");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,60
	CALL _glcd_outtextxy
; 0001 011A         dis='T';
	LDI  R30,LOW(84)
	MOV  R9,R30
; 0001 011B     }
; 0001 011C     if(cnt13==1)
_0x2003C:
	LDS  R26,_cnt13
	CPI  R26,LOW(0x1)
	BRNE _0x2003D
; 0001 011D     {
; 0001 011E         glcd_outtextxy(x,y,"U");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,62
	CALL _glcd_outtextxy
; 0001 011F         dis='U';
	LDI  R30,LOW(85)
	MOV  R9,R30
; 0001 0120     }
; 0001 0121     if(cnt13==2)
_0x2003D:
	LDS  R26,_cnt13
	CPI  R26,LOW(0x2)
	BRNE _0x2003E
; 0001 0122     {
; 0001 0123         glcd_outtextxy(x,y,"V");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,64
	CALL _glcd_outtextxy
; 0001 0124         dis='V';
	LDI  R30,LOW(86)
	MOV  R9,R30
; 0001 0125     }
; 0001 0126 
; 0001 0127     cnt13++;
_0x2003E:
	LDS  R30,_cnt13
	SUBI R30,-LOW(1)
	STS  _cnt13,R30
; 0001 0128     if(cnt13>2)
	LDS  R26,_cnt13
	CPI  R26,LOW(0x3)
	BRLO _0x2003F
; 0001 0129         cnt13=0;
	LDI  R30,LOW(0)
	STS  _cnt13,R30
; 0001 012A 
; 0001 012B     break;
_0x2003F:
	RJMP _0x20006
; 0001 012C 
; 0001 012D     case 14:
_0x2003B:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x20040
; 0001 012E     IT=0;
	CLR  R4
; 0001 012F     set=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0001 0130     if(cnt14==0)
	LDS  R30,_cnt14
	CPI  R30,0
	BRNE _0x20041
; 0001 0131     {
; 0001 0132         glcd_outtextxy(x,y,"W");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,66
	CALL _glcd_outtextxy
; 0001 0133         dis='W';
	LDI  R30,LOW(87)
	MOV  R9,R30
; 0001 0134     }
; 0001 0135     if(cnt14==1)
_0x20041:
	LDS  R26,_cnt14
	CPI  R26,LOW(0x1)
	BRNE _0x20042
; 0001 0136     {
; 0001 0137         glcd_outtextxy(x,y,"X");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,68
	CALL _glcd_outtextxy
; 0001 0138         dis='X';
	LDI  R30,LOW(88)
	MOV  R9,R30
; 0001 0139     }
; 0001 013A     if(cnt14==2)
_0x20042:
	LDS  R26,_cnt14
	CPI  R26,LOW(0x2)
	BRNE _0x20043
; 0001 013B     {
; 0001 013C         glcd_outtextxy(x,y,"Y");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,70
	CALL _glcd_outtextxy
; 0001 013D         dis='Y';
	LDI  R30,LOW(89)
	MOV  R9,R30
; 0001 013E     }
; 0001 013F     if(cnt14==3)
_0x20043:
	LDS  R26,_cnt14
	CPI  R26,LOW(0x3)
	BRNE _0x20044
; 0001 0140     {
; 0001 0141         glcd_outtextxy(x,y,"Z");
	ST   -Y,R8
	ST   -Y,R11
	__POINTW2MN _0x20009,72
	CALL _glcd_outtextxy
; 0001 0142         dis='Z';
	LDI  R30,LOW(90)
	MOV  R9,R30
; 0001 0143     }
; 0001 0144     cnt14++;
_0x20044:
	LDS  R30,_cnt14
	SUBI R30,-LOW(1)
	STS  _cnt14,R30
; 0001 0145     if(cnt14>3)
	LDS  R26,_cnt14
	CPI  R26,LOW(0x4)
	BRLO _0x20045
; 0001 0146     cnt14=0;
	LDI  R30,LOW(0)
	STS  _cnt14,R30
; 0001 0147 
; 0001 0148      break;
_0x20045:
	RJMP _0x20006
; 0001 0149 
; 0001 014A 
; 0001 014B 
; 0001 014C 
; 0001 014D     case 7 :
_0x20040:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x20046
; 0001 014E 
; 0001 014F     glcd_clear();
	CALL SUBOPT_0x2
; 0001 0150     IT=0;
; 0001 0151     glcd_outtextxy(0,0,str);
; 0001 0152      Cnt=0;
; 0001 0153     for(L=0;L<strlen(str);L++)
_0x20048:
	CALL SUBOPT_0x3
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x20049
; 0001 0154    {
; 0001 0155    k=strlen(str)-L;
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
; 0001 0156    if(L1==1)
	BRNE _0x2004A
; 0001 0157     Local_1[Cnt]=str[L];
	CALL SUBOPT_0x5
; 0001 0158     if(L2==1)
_0x2004A:
	LDS  R26,_L2
	CPI  R26,LOW(0x1)
	BRNE _0x2004B
; 0001 0159     Local_2[Cnt]=str[L];
	CALL SUBOPT_0x6
; 0001 015A 
; 0001 015B 
; 0001 015C       if((Cnt>=3) | (k<2))
_0x2004B:
	CALL SUBOPT_0x7
	BREQ _0x2004C
; 0001 015D     {
; 0001 015E    Cnt=0;
	CALL SUBOPT_0x8
; 0001 015F     if((L1==1 ))
	BRNE _0x2004D
; 0001 0160     {
; 0001 0161     putchar(0x01);
	CALL SUBOPT_0x9
; 0001 0162 
; 0001 0163         putchar('{');
; 0001 0164 
; 0001 0165     puts(Local_1);
	CALL SUBOPT_0xA
; 0001 0166 
; 0001 0167       putchar('}');
; 0001 0168 
; 0001 0169 
; 0001 016A     memset(Local_1,0,4);
; 0001 016B 
; 0001 016C     }
; 0001 016D     if((L2==1 ))
_0x2004D:
	LDS  R26,_L2
	CPI  R26,LOW(0x1)
	BRNE _0x2004E
; 0001 016E     {
; 0001 016F     putchar(0x02);
	CALL SUBOPT_0xB
; 0001 0170 
; 0001 0171     putchar('{');
; 0001 0172 
; 0001 0173     puts(Local_2);
	CALL SUBOPT_0xC
; 0001 0174 
; 0001 0175     putchar('}');
; 0001 0176 
; 0001 0177 
; 0001 0178     memset(Local_2,0,4);
; 0001 0179 
; 0001 017A     }
; 0001 017B     L2=1-L2;
_0x2004E:
	CALL SUBOPT_0xD
; 0001 017C     L1=1-L1;
	STS  _L1,R30
; 0001 017D     }
; 0001 017E     else
	RJMP _0x2004F
_0x2004C:
; 0001 017F 
; 0001 0180     Cnt++;
	LDS  R30,_Cnt
	SUBI R30,-LOW(1)
	STS  _Cnt,R30
; 0001 0181 
; 0001 0182    }
_0x2004F:
	LDS  R30,_L
	SUBI R30,-LOW(1)
	STS  _L,R30
	RJMP _0x20048
_0x20049:
; 0001 0183           if(strlen(str)<=3)
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _strlen
	SBIW R30,4
	BRSH _0x20050
; 0001 0184     {
; 0001 0185     L2=0;
	LDI  R30,LOW(0)
	STS  _L2,R30
; 0001 0186     L1=1;
	LDI  R30,LOW(1)
	RJMP _0x2007C
; 0001 0187     }
; 0001 0188     else
_0x20050:
; 0001 0189     {
; 0001 018A     L2=1-L2;
	CALL SUBOPT_0xD
; 0001 018B     L1=1-L1;
_0x2007C:
	STS  _L1,R30
; 0001 018C     }
; 0001 018D     k=0;
	LDI  R30,LOW(0)
	STS  _k,R30
; 0001 018E     putchar(0x02);
	CALL SUBOPT_0xB
; 0001 018F 
; 0001 0190     putchar('{');
; 0001 0191 
; 0001 0192     putchar(0xff);
	CALL SUBOPT_0xE
; 0001 0193 
; 0001 0194     putchar('}');
; 0001 0195 
; 0001 0196 
; 0001 0197     putchar(0x01);
	CALL SUBOPT_0x9
; 0001 0198 
; 0001 0199     putchar('{');
; 0001 019A 
; 0001 019B     putchar(0xff);
	CALL SUBOPT_0xE
; 0001 019C 
; 0001 019D     putchar('}');
; 0001 019E 
; 0001 019F 
; 0001 01A0     break;
	RJMP _0x20006
; 0001 01A1 
; 0001 01A2     case 11 :
_0x20046:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x20052
; 0001 01A3 
; 0001 01A4     i++;
	CALL SUBOPT_0xF
; 0001 01A5     strncat(str, &dis, 1);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0001 01A6     IT=0;
; 0001 01A7 
; 0001 01A8     if(crt==1)
	LDS  R26,_crt
	CPI  R26,LOW(0x1)
	BRNE _0x20053
; 0001 01A9     {
; 0001 01AA         crt=0;
	LDI  R30,LOW(0)
	STS  _crt,R30
; 0001 01AB         x=x+backcnt;
	LDS  R30,_backcnt
	ADD  R8,R30
; 0001 01AC         backcnt=0;
	LDI  R30,LOW(0)
	STS  _backcnt,R30
; 0001 01AD         }
; 0001 01AE         else
	RJMP _0x20054
_0x20053:
; 0001 01AF             if(set==1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x20055
; 0001 01B0             {
; 0001 01B1                 x+=6;
	LDI  R30,LOW(6)
	ADD  R8,R30
; 0001 01B2                 i++;
	CALL SUBOPT_0xF
; 0001 01B3                 cnt0=0;cnt2=0;cnt4=0;cnt5=0;cnt6=0;cnt8=0;cnt9=0;cnt10=0;cnt12=0;cnt13=0;cnt14=0;
	CALL SUBOPT_0x12
; 0001 01B4 
; 0001 01B5             if(x>128)
	LDI  R30,LOW(128)
	CP   R30,R8
	BRSH _0x20056
; 0001 01B6             {
; 0001 01B7                 x=0;
	CLR  R8
; 0001 01B8                 y+=6;
	LDI  R30,LOW(6)
	ADD  R11,R30
; 0001 01B9                 if(y>64)
	LDI  R30,LOW(64)
	CP   R30,R11
	BRSH _0x20057
; 0001 01BA                 y=0;
	CLR  R11
; 0001 01BB         }
_0x20057:
; 0001 01BC         set=0;
_0x20056:
	CLR  R6
; 0001 01BD     }
; 0001 01BE 
; 0001 01BF     break;
_0x20055:
_0x20054:
	RJMP _0x20006
; 0001 01C0 
; 0001 01C1     case 15 :
_0x20052:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x20058
; 0001 01C2 
; 0001 01C3     IT=0;
	CALL SUBOPT_0x13
; 0001 01C4     glcd_clear();
; 0001 01C5     x=0;
; 0001 01C6     y=0;
; 0001 01C7     i=0;
; 0001 01C8     memset(str,0,100);
	CALL SUBOPT_0x14
; 0001 01C9     cnt0=0;cnt2=0;cnt4=0;cnt5=0;cnt6=0;cnt8=0;cnt9=0;cnt10=0;cnt12=0;cnt13=0;cnt14=0;
	CALL SUBOPT_0x12
; 0001 01CA     break;
	RJMP _0x20006
; 0001 01CB 
; 0001 01CC     case 3 :
_0x20058:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20006
; 0001 01CD     IT=0;
	CLR  R4
; 0001 01CE     alpha=1-alpha;
	CALL SUBOPT_0x15
; 0001 01CF     input=16;
; 0001 01D0     break;
; 0001 01D1     }
_0x20006:
; 0001 01D2 }
	RET
; .FEND

	.DSEG
_0x20009:
	.BYTE 0x4A
;
;void dis_num(void)
; 0001 01D5 {

	.CSEG
_dis_num:
; .FSTART _dis_num
; 0001 01D6     switch(input)
	MOV  R30,R5
	LDI  R31,0
; 0001 01D7     {
; 0001 01D8 
; 0001 01D9     case 2 :
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2005D
; 0001 01DA 
; 0001 01DB         IT=0;
	CALL SUBOPT_0x1
; 0001 01DC         set=1;
; 0001 01DD         glcd_outtextxy(x,y,"*");
	__POINTW2MN _0x2005E,0
	CALL _glcd_outtextxy
; 0001 01DE         dis='*';
	LDI  R30,LOW(42)
	MOV  R9,R30
; 0001 01DF 
; 0001 01E0     break;
	RJMP _0x2005C
; 0001 01E1 
; 0001 01E2     case 1 :
_0x2005D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2005F
; 0001 01E3 
; 0001 01E4         IT=0;
	CALL SUBOPT_0x1
; 0001 01E5         set=1;
; 0001 01E6         glcd_outtextxy(x,y,"0");
	__POINTW2MN _0x2005E,2
	CALL _glcd_outtextxy
; 0001 01E7         dis='0';
	LDI  R30,LOW(48)
	MOV  R9,R30
; 0001 01E8 
; 0001 01E9     break;
	RJMP _0x2005C
; 0001 01EA 
; 0001 01EB     case 0 :
_0x2005F:
	SBIW R30,0
	BRNE _0x20060
; 0001 01EC         IT=0;
	CALL SUBOPT_0x1
; 0001 01ED         set=1;
; 0001 01EE         glcd_outtextxy(x,y,"#");
	__POINTW2MN _0x2005E,4
	CALL _glcd_outtextxy
; 0001 01EF 
; 0001 01F0         dis='#';
	LDI  R30,LOW(35)
	MOV  R9,R30
; 0001 01F1 
; 0001 01F2     break;
	RJMP _0x2005C
; 0001 01F3 
; 0001 01F4     case 4 :
_0x20060:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20061
; 0001 01F5 
; 0001 01F6         IT=0;
	CALL SUBOPT_0x1
; 0001 01F7         set=1;
; 0001 01F8         glcd_outtextxy(x,y,"1");
	__POINTW2MN _0x2005E,6
	CALL _glcd_outtextxy
; 0001 01F9 
; 0001 01FA         dis='1';
	LDI  R30,LOW(49)
	MOV  R9,R30
; 0001 01FB 
; 0001 01FC     break;
	RJMP _0x2005C
; 0001 01FD 
; 0001 01FE     case 5 :
_0x20061:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x20062
; 0001 01FF         IT=0;
	CALL SUBOPT_0x1
; 0001 0200         set=1;
; 0001 0201         glcd_outtextxy(x,y,"2");
	__POINTW2MN _0x2005E,8
	CALL _glcd_outtextxy
; 0001 0202 
; 0001 0203         dis='2';
	LDI  R30,LOW(50)
	MOV  R9,R30
; 0001 0204 
; 0001 0205     break;
	RJMP _0x2005C
; 0001 0206 
; 0001 0207     case 6 :
_0x20062:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20063
; 0001 0208 
; 0001 0209         IT=0;
	CALL SUBOPT_0x1
; 0001 020A         set=1;
; 0001 020B         glcd_outtextxy(x,y,"3");
	__POINTW2MN _0x2005E,10
	CALL _glcd_outtextxy
; 0001 020C 
; 0001 020D         dis='3';
	LDI  R30,LOW(51)
	MOV  R9,R30
; 0001 020E 
; 0001 020F     break;
	RJMP _0x2005C
; 0001 0210 
; 0001 0211     case 8 :
_0x20063:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x20064
; 0001 0212 
; 0001 0213         IT=0;
	CALL SUBOPT_0x1
; 0001 0214         set=1;
; 0001 0215         glcd_outtextxy(x,y,"4");
	__POINTW2MN _0x2005E,12
	CALL _glcd_outtextxy
; 0001 0216         dis='4';
	LDI  R30,LOW(52)
	MOV  R9,R30
; 0001 0217 
; 0001 0218     break;
	RJMP _0x2005C
; 0001 0219 
; 0001 021A     case 9 :
_0x20064:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x20065
; 0001 021B 
; 0001 021C         IT=0;
	CALL SUBOPT_0x1
; 0001 021D         set=1;
; 0001 021E         glcd_outtextxy(x,y,"5");
	__POINTW2MN _0x2005E,14
	CALL _glcd_outtextxy
; 0001 021F         dis='5';
	LDI  R30,LOW(53)
	MOV  R9,R30
; 0001 0220 
; 0001 0221     break;
	RJMP _0x2005C
; 0001 0222 
; 0001 0223     case 10 :
_0x20065:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x20066
; 0001 0224 
; 0001 0225         IT=0;
	CALL SUBOPT_0x1
; 0001 0226         set=1;
; 0001 0227         glcd_outtextxy(x,y,"6");
	__POINTW2MN _0x2005E,16
	CALL _glcd_outtextxy
; 0001 0228         dis='6';
	LDI  R30,LOW(54)
	MOV  R9,R30
; 0001 0229 
; 0001 022A     break;
	RJMP _0x2005C
; 0001 022B 
; 0001 022C     case 12 :
_0x20066:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x20067
; 0001 022D 
; 0001 022E         IT=0;
	CALL SUBOPT_0x1
; 0001 022F         set=1;
; 0001 0230         glcd_outtextxy(x,y,"7");
	__POINTW2MN _0x2005E,18
	CALL _glcd_outtextxy
; 0001 0231         dis='7';
	LDI  R30,LOW(55)
	MOV  R9,R30
; 0001 0232 
; 0001 0233     break;
	RJMP _0x2005C
; 0001 0234 
; 0001 0235         case 13 :
_0x20067:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x20068
; 0001 0236 
; 0001 0237         IT=0;
	CALL SUBOPT_0x1
; 0001 0238         set=1;
; 0001 0239         glcd_outtextxy(x,y,"8");
	__POINTW2MN _0x2005E,20
	CALL _glcd_outtextxy
; 0001 023A         dis='8';
	LDI  R30,LOW(56)
	MOV  R9,R30
; 0001 023B 
; 0001 023C     break;
	RJMP _0x2005C
; 0001 023D 
; 0001 023E     case 14:
_0x20068:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x20069
; 0001 023F 
; 0001 0240         IT=0;
	CALL SUBOPT_0x1
; 0001 0241         set=1;
; 0001 0242         glcd_outtextxy(x,y,"9");
	__POINTW2MN _0x2005E,22
	CALL _glcd_outtextxy
; 0001 0243         dis='9';
	LDI  R30,LOW(57)
	MOV  R9,R30
; 0001 0244 
; 0001 0245     break;
	RJMP _0x2005C
; 0001 0246 
; 0001 0247     case 3 :
_0x20069:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2006A
; 0001 0248     alpha=1-alpha;
	CALL SUBOPT_0x15
; 0001 0249     input=16;
; 0001 024A     break;
	RJMP _0x2005C
; 0001 024B 
; 0001 024C     case 7 :
_0x2006A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2006B
; 0001 024D      glcd_clear();
	CALL SUBOPT_0x2
; 0001 024E     IT=0;
; 0001 024F     glcd_outtextxy(0,0,str);
; 0001 0250      Cnt=0;
; 0001 0251     for(L=0;L<strlen(str);L++)
_0x2006D:
	CALL SUBOPT_0x3
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x2006E
; 0001 0252    {
; 0001 0253    k=strlen(str)-L;
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
; 0001 0254    if(L1==1)
	BRNE _0x2006F
; 0001 0255     Local_1[Cnt]=str[L];
	CALL SUBOPT_0x5
; 0001 0256     if(L2==1)
_0x2006F:
	LDS  R26,_L2
	CPI  R26,LOW(0x1)
	BRNE _0x20070
; 0001 0257     Local_2[Cnt]=str[L];
	CALL SUBOPT_0x6
; 0001 0258 
; 0001 0259 
; 0001 025A       if((Cnt>=3) | (k<2))
_0x20070:
	CALL SUBOPT_0x7
	BREQ _0x20071
; 0001 025B     {
; 0001 025C    Cnt=0;
	CALL SUBOPT_0x8
; 0001 025D     if((L1==1 ))
	BRNE _0x20072
; 0001 025E     {
; 0001 025F     putchar(0x01);
	CALL SUBOPT_0x9
; 0001 0260 
; 0001 0261         putchar('{');
; 0001 0262 
; 0001 0263     puts(Local_1);
	CALL SUBOPT_0xA
; 0001 0264 
; 0001 0265       putchar('}');
; 0001 0266 
; 0001 0267 
; 0001 0268     memset(Local_1,0,4);
; 0001 0269 
; 0001 026A     }
; 0001 026B     if((L2==1 ))
_0x20072:
	LDS  R26,_L2
	CPI  R26,LOW(0x1)
	BRNE _0x20073
; 0001 026C     {
; 0001 026D     putchar(0x02);
	CALL SUBOPT_0xB
; 0001 026E 
; 0001 026F     putchar('{');
; 0001 0270 
; 0001 0271     puts(Local_2);
	CALL SUBOPT_0xC
; 0001 0272 
; 0001 0273     putchar('}');
; 0001 0274 
; 0001 0275 
; 0001 0276     memset(Local_2,0,4);
; 0001 0277 
; 0001 0278     }
; 0001 0279 
; 0001 027A     }
_0x20073:
; 0001 027B     else
	RJMP _0x20074
_0x20071:
; 0001 027C 
; 0001 027D     Cnt++;
	LDS  R30,_Cnt
	SUBI R30,-LOW(1)
	STS  _Cnt,R30
; 0001 027E 
; 0001 027F    }
_0x20074:
	LDS  R30,_L
	SUBI R30,-LOW(1)
	STS  _L,R30
	RJMP _0x2006D
_0x2006E:
; 0001 0280        if(strlen(str)<=3)
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _strlen
	SBIW R30,4
	BRSH _0x20075
; 0001 0281     {
; 0001 0282     L2=0;
	LDI  R30,LOW(0)
	STS  _L2,R30
; 0001 0283     L1=1;
	LDI  R30,LOW(1)
	RJMP _0x2007D
; 0001 0284     }
; 0001 0285     else
_0x20075:
; 0001 0286     {
; 0001 0287     L2=1-L2;
	CALL SUBOPT_0xD
; 0001 0288     L1=1-L1;
_0x2007D:
	STS  _L1,R30
; 0001 0289     }
; 0001 028A     k=0;
	LDI  R30,LOW(0)
	STS  _k,R30
; 0001 028B     putchar(0x02);
	CALL SUBOPT_0xB
; 0001 028C 
; 0001 028D     putchar('{');
; 0001 028E 
; 0001 028F     putchar(0xff);
	CALL SUBOPT_0xE
; 0001 0290 
; 0001 0291     putchar('}');
; 0001 0292 
; 0001 0293 
; 0001 0294     putchar(0x01);
	CALL SUBOPT_0x9
; 0001 0295 
; 0001 0296     putchar('{');
; 0001 0297 
; 0001 0298     putchar(0xff);
	CALL SUBOPT_0xE
; 0001 0299 
; 0001 029A     putchar('}');
; 0001 029B 
; 0001 029C     break;
	RJMP _0x2005C
; 0001 029D 
; 0001 029E     case 11 :
_0x2006B:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x20077
; 0001 029F 
; 0001 02A0 
; 0001 02A1     i++;
	CALL SUBOPT_0xF
; 0001 02A2     strncat(str, &dis, 1);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0001 02A3     IT=0;
; 0001 02A4 
; 0001 02A5 //    if(crt==1)
; 0001 02A6 //    {
; 0001 02A7 //        crt=0;
; 0001 02A8 //        x=x+backcnt;
; 0001 02A9 //        backcnt=0;
; 0001 02AA //        }
; 0001 02AB //        else
; 0001 02AC 
; 0001 02AD             if(set==1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x20078
; 0001 02AE             {
; 0001 02AF                 x+=6;
	LDI  R30,LOW(6)
	ADD  R8,R30
; 0001 02B0                 i++;
	CALL SUBOPT_0xF
; 0001 02B1 
; 0001 02B2             if(x>128)
	LDI  R30,LOW(128)
	CP   R30,R8
	BRSH _0x20079
; 0001 02B3             {
; 0001 02B4                 x=0;
	CLR  R8
; 0001 02B5                 y+=6;
	LDI  R30,LOW(6)
	ADD  R11,R30
; 0001 02B6                 if(y>64)
	LDI  R30,LOW(64)
	CP   R30,R11
	BRSH _0x2007A
; 0001 02B7                 y=0;
	CLR  R11
; 0001 02B8         }
_0x2007A:
; 0001 02B9         set=0;
_0x20079:
	CLR  R6
; 0001 02BA     }
; 0001 02BB     break;
_0x20078:
	RJMP _0x2005C
; 0001 02BC 
; 0001 02BD     case 15 :
_0x20077:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x2005C
; 0001 02BE 
; 0001 02BF         IT=0;
	CALL SUBOPT_0x13
; 0001 02C0         glcd_clear();
; 0001 02C1         x=0;
; 0001 02C2         y=0;
; 0001 02C3         i=0;
; 0001 02C4         memset(str,0,100);
	CALL SUBOPT_0x14
; 0001 02C5 
; 0001 02C6     break;
; 0001 02C7    }
_0x2005C:
; 0001 02C8 
; 0001 02C9 }
	RET
; .FEND

	.DSEG
_0x2005E:
	.BYTE 0x18
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
_ks0108_enable_G100:
; .FSTART _ks0108_enable_G100
	nop
	SBI  0x18,0
	nop
	RET
; .FEND
_ks0108_disable_G100:
; .FSTART _ks0108_disable_G100
	CBI  0x18,0
	CBI  0x18,4
	CBI  0x18,5
	RET
; .FEND
_ks0108_rdbus_G100:
; .FSTART _ks0108_rdbus_G100
	ST   -Y,R17
	RCALL _ks0108_enable_G100
	IN   R17,25
	CBI  0x18,0
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G100:
; .FSTART _ks0108_busy_G100
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	SBI  0x18,1
	CBI  0x18,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2000003
	SBI  0x18,4
	RJMP _0x2000004
_0x2000003:
	CBI  0x18,4
_0x2000004:
	SBRS R17,1
	RJMP _0x2000005
	SBI  0x18,5
	RJMP _0x2000006
_0x2000005:
	CBI  0x18,5
_0x2000006:
_0x2000007:
	RCALL _ks0108_rdbus_G100
	ANDI R30,LOW(0x80)
	BRNE _0x2000007
	LDD  R17,Y+0
	JMP  _0x2120003
; .FEND
_ks0108_wrcmd_G100:
; .FSTART _ks0108_wrcmd_G100
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0x16
	JMP  _0x2120003
; .FEND
_ks0108_setloc_G100:
; .FSTART _ks0108_setloc_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G100,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	RET
; .FEND
_ks0108_gotoxp_G100:
; .FSTART _ks0108_gotoxp_G100
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G100,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G100,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G100,2
	RCALL _ks0108_setloc_G100
	JMP  _0x2120003
; .FEND
_ks0108_nextx_G100:
; .FSTART _ks0108_nextx_G100
	LDS  R26,_ks0108_coord_G100
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G100,R26
	CPI  R26,LOW(0x80)
	BRLO _0x200000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G100,R30
_0x200000A:
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	BRNE _0x200000B
	LDS  R30,_ks0108_coord_G100
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G100,2
	RCALL _ks0108_gotoxp_G100
_0x200000B:
	RET
; .FEND
_ks0108_wrdata_G100:
; .FSTART _ks0108_wrdata_G100
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	SBI  0x18,2
	CALL SUBOPT_0x16
	JMP  _0x2120005
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	SBI  0x18,1
	SBI  0x18,2
	RCALL _ks0108_rdbus_G100
	RET
; .FEND
_ks0108_rdbyte_G100:
; .FSTART _ks0108_rdbyte_G100
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x17
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	RCALL _ks0108_rddata_G100
	JMP  _0x2120003
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x17,0
	SBI  0x17,1
	SBI  0x17,2
	SBI  0x17,3
	SBI  0x18,3
	SBI  0x17,4
	SBI  0x17,5
	RCALL _ks0108_disable_G100
	CBI  0x18,3
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,3
	LDI  R17,LOW(0)
_0x200000C:
	CPI  R17,2
	BRSH _0x200000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G100
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G100
	RJMP _0x200000C
_0x200000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x200000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000AC
_0x200000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	JMP  _0x2120002
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2000015
	LDI  R16,LOW(255)
_0x2000015:
_0x2000016:
	CPI  R19,8
	BRSH _0x2000018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G100
	LDI  R17,LOW(0)
_0x2000019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x200001B
	MOV  R26,R16
	CALL SUBOPT_0x18
	RJMP _0x2000019
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G100
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x2120001
; .FEND
_ks0108_wrmasked_G100:
; .FSTART _ks0108_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x200002B
	CPI  R30,LOW(0x8)
	BRNE _0x200002C
_0x200002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x200002D
_0x200002C:
	CPI  R30,LOW(0x3)
	BRNE _0x200002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000030
_0x200002F:
	CPI  R30,0
	BRNE _0x2000031
_0x2000030:
_0x200002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x2)
	BRNE _0x2000033
_0x2000032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2000029
_0x2000033:
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2000029
_0x2000034:
	CPI  R30,LOW(0x4)
	BRNE _0x2000029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2000029:
	MOV  R26,R17
	CALL SUBOPT_0x18
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2000037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2000037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2000037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2000036
_0x2000037:
	RJMP _0x2120008
_0x2000036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2000039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2000039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x200003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x200003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x200003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	RJMP _0x2120008
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000041
	RJMP _0x2120008
_0x2000041:
_0x2000042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000043
_0x2000044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x19
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2000046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2000048
	MOV  R17,R16
_0x2000049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200004B
	CALL SUBOPT_0x1A
	RJMP _0x2000049
_0x200004B:
	RJMP _0x2000046
_0x2000048:
_0x2000043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x200004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x19
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x200004D
	SUBI R19,-LOW(1)
_0x200004D:
	LDI  R18,LOW(0)
_0x200004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000050
	LDD  R17,Y+14
_0x2000051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000053
	CALL SUBOPT_0x1A
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x19
	RJMP _0x200004E
_0x2000050:
_0x200004C:
_0x200003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2000057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2000058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x200005D
	CPI  R30,LOW(0x3)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2000060
_0x200005F:
	RJMP _0x2000061
_0x2000060:
	CPI  R30,LOW(0x8)
	BRNE _0x2000062
_0x2000061:
	RJMP _0x2000063
_0x2000062:
	CPI  R30,LOW(0x6)
	BRNE _0x2000064
_0x2000063:
	RJMP _0x2000065
_0x2000064:
	CPI  R30,LOW(0x9)
	BRNE _0x2000066
_0x2000065:
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x2000067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x17
_0x200005B:
_0x2000069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x200006C
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	CALL SUBOPT_0x1B
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G100
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G100
	RJMP _0x200006D
_0x200006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000071
	LDI  R21,LOW(0)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0xA)
	BRNE _0x2000070
	LDI  R21,LOW(255)
	RJMP _0x2000072
_0x2000070:
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x1D
	MOV  R21,R30
	RJMP _0x200007B
_0x200007A:
	CPI  R30,LOW(0x3)
	BRNE _0x200007D
	COM  R21
	RJMP _0x200007E
_0x200007D:
	CPI  R30,0
	BRNE _0x2000080
_0x200007E:
_0x200007B:
	MOV  R26,R21
	CALL SUBOPT_0x18
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x1E
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
_0x2000077:
_0x200006D:
	RJMP _0x2000069
_0x200006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000081
_0x2000058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000082
_0x2000057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000084
_0x2000083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000088
_0x2000089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008B
	CALL SUBOPT_0x1F
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x20
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x1B
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000089
_0x200008B:
	RJMP _0x2000087
_0x2000088:
	CPI  R30,LOW(0x9)
	BRNE _0x200008C
	LDI  R21,LOW(0)
	RJMP _0x200008D
_0x200008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2000093
	LDI  R21,LOW(255)
_0x200008D:
	CALL SUBOPT_0x1D
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000092
	CALL SUBOPT_0x1E
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000090
_0x2000092:
	RJMP _0x2000087
_0x2000093:
_0x2000094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000096
	CALL SUBOPT_0x21
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000094
_0x2000096:
_0x2000087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2000097
	RJMP _0x2000056
_0x2000097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2000098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000AD
_0x2000098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200009D
_0x200009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A0
	CALL SUBOPT_0x1F
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x20
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x1B
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x200009C
_0x200009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20000A1
	LDI  R21,LOW(0)
	RJMP _0x20000A2
_0x20000A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20000A8
	LDI  R21,LOW(255)
_0x20000A2:
	CALL SUBOPT_0x1D
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20000A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A7
	CALL SUBOPT_0x1E
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A5
_0x20000A7:
	RJMP _0x200009C
_0x20000A8:
_0x20000A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000AB
	CALL SUBOPT_0x21
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A9
_0x20000AB:
_0x200009C:
_0x2000081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000054
_0x2000056:
_0x2120008:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x22
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120003
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	JMP  _0x2120003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x22
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120003
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	JMP  _0x2120003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x23
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120007
_0x202000B:
	CALL SUBOPT_0x24
	STD  Y+7,R0
	CALL SUBOPT_0x24
	STD  Y+6,R0
	CALL SUBOPT_0x24
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120007
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120007
_0x202000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120007
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120007:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x25
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x23
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	RJMP _0x2120006
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x25
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x25
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x26
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x2120006
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x2120006:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2020025:
	CALL SUBOPT_0x27
	BREQ _0x2020027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020025
_0x2020027:
	LDD  R17,Y+0
	JMP  _0x2120004
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	JMP  _0x2120003
; .FEND
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
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2120005:
	ADIW R28,1
	RET
; .FEND
_puts:
; .FSTART _puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060003:
	CALL SUBOPT_0x27
	BREQ _0x2060005
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2060003
_0x2060005:
	LDI  R26,LOW(10)
	RCALL _putchar
	LDD  R17,Y+0
	JMP  _0x2120002
; .FEND

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
_0x2120004:
	ADIW R28,5
	RET
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strncat:
; .FSTART _strncat
	ST   -Y,R26
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncat0:
    ld   r22,x+
    tst  r22
    brne strncat0
    sbiw r26,1
strncat1:
    st   x,r23
    tst  r23
    breq strncat2
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncat1
strncat2:
    movw r30,r24
    ret
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20A0007
	CPI  R30,LOW(0xA)
	BRNE _0x20A0008
_0x20A0007:
	LDS  R17,_glcd_state
	RJMP _0x20A0009
_0x20A0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20A000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20A0009
_0x20A000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20A0005
	__GETBRMN 17,_glcd_state,16
_0x20A0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20A000E
	CPI  R17,0
	BREQ _0x20A000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20A000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20A000E:
	CPI  R17,0
	BRNE _0x20A0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20A0011:
_0x20A0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20A0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120002
_0x20A0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20A0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120002
_0x20A0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20A0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x20A0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20A001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20A001B
_0x20A001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20A001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20A001B
_0x20A001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20A001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20A001B:
_0x2120001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_cnt6:
	.BYTE 0x1
_cnt8:
	.BYTE 0x1
_cnt9:
	.BYTE 0x1
_cnt10:
	.BYTE 0x1
_cnt12:
	.BYTE 0x1
_cnt13:
	.BYTE 0x1
_cnt14:
	.BYTE 0x1
_crt:
	.BYTE 0x1
_backcnt:
	.BYTE 0x1
_str:
	.BYTE 0x100
_i:
	.BYTE 0x1
_alpha:
	.BYTE 0x1
_Local_1:
	.BYTE 0x4
_Local_2:
	.BYTE 0x4
_L:
	.BYTE 0x1
_Cnt:
	.BYTE 0x1
_k:
	.BYTE 0x1
_L1:
	.BYTE 0x1
_L2:
	.BYTE 0x1
_ks0108_coord_G100:
	.BYTE 0x3
__seed_G108:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x0:
	OUT  0x15,R30
	__DELAY_USB 133
	IN   R30,0x13
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1:
	CLR  R4
	LDI  R30,LOW(1)
	MOV  R6,R30
	ST   -Y,R8
	ST   -Y,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	CALL _glcd_clear
	CLR  R4
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _glcd_outtextxy
	LDI  R30,LOW(0)
	STS  _Cnt,R30
	STS  _L,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _strlen
	LDS  R26,_L
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	SUB  R30,R26
	STS  _k,R30
	LDS  R26,_L1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDS  R26,_Cnt
	LDI  R27,0
	SUBI R26,LOW(-_Local_1)
	SBCI R27,HIGH(-_Local_1)
	LDS  R30,_L
	LDI  R31,0
	SUBI R30,LOW(-_str)
	SBCI R31,HIGH(-_str)
	LD   R30,Z
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDS  R26,_Cnt
	LDI  R27,0
	SUBI R26,LOW(-_Local_2)
	SBCI R27,HIGH(-_Local_2)
	LDS  R30,_L
	LDI  R31,0
	SUBI R30,LOW(-_str)
	SBCI R31,HIGH(-_str)
	LD   R30,Z
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDS  R26,_Cnt
	LDI  R30,LOW(3)
	CALL __GEB12U
	MOV  R0,R30
	LDS  R26,_k
	LDI  R30,LOW(2)
	CALL __LTB12U
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	STS  _Cnt,R30
	LDS  R26,_L1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(1)
	CALL _putchar
	LDI  R26,LOW(123)
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_Local_1)
	LDI  R27,HIGH(_Local_1)
	CALL _puts
	LDI  R26,LOW(125)
	CALL _putchar
	LDI  R30,LOW(_Local_1)
	LDI  R31,HIGH(_Local_1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(2)
	CALL _putchar
	LDI  R26,LOW(123)
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_Local_2)
	LDI  R27,HIGH(_Local_2)
	CALL _puts
	LDI  R26,LOW(125)
	CALL _putchar
	LDI  R30,LOW(_Local_2)
	LDI  R31,HIGH(_Local_2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	LDS  R26,_L2
	LDI  R30,LOW(1)
	SUB  R30,R26
	STS  _L2,R30
	LDS  R26,_L1
	LDI  R30,LOW(1)
	SUB  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(255)
	CALL _putchar
	LDI  R26,LOW(125)
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _strncat
	CLR  R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x12:
	CLR  R7
	CLR  R10
	CLR  R13
	CLR  R12
	LDI  R30,LOW(0)
	STS  _cnt6,R30
	STS  _cnt8,R30
	STS  _cnt9,R30
	STS  _cnt10,R30
	STS  _cnt12,R30
	STS  _cnt13,R30
	STS  _cnt14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	CLR  R4
	CALL _glcd_clear
	CLR  R8
	CLR  R11
	LDI  R30,LOW(0)
	STS  _i,R30
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDS  R26,_alpha
	LDI  R30,LOW(1)
	SUB  R30,R26
	STS  _alpha,R30
	LDI  R30,LOW(16)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	CBI  0x18,1
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LD   R30,Y
	OUT  0x1B,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__GEB12U:
	CP   R26,R30
	LDI  R30,1
	BRSH __GEB12U1
	CLR  R30
__GEB12U1:
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
