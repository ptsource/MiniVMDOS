' $INCLUDE: 'SBC.BI'
' $INCLUDE: 'SBCSYS.BI'
' $INCLUDE: 'SBCMUSIC.BI'

DECLARE SUB  SETINSTBL (instrument%())

REM $DYNAMIC
CLEAR

CLS

PRINT "SBK QuickBasic FM Low Level Example"

DIM instrument%(1 TO 128,1 TO 8)

' Set I/O address
CTIOADDX (&H220)

' Check for Sound Blaster Card
IF (SBCHKCRD% > 4) THEN

     ' Initialize driver
     CALL SLINIT

     ' Setup the instrument table
     CALL SETINSTBL(instrument%())

     ' Set the instrument table for driver
     CALL SLINST(instrument%(1,1))

     CALL PLAYSCALE

     ' Reset driver before exit
     CALL SLRESET

ELSE
	PRINT "Sound Blaster Card not found"
END IF

END


' ------------------------------------------------------------------------ '


REM $STATIC
SUB  SETINSTBL(instrument%())

     DIM  i AS INTEGER, j AS INTEGER, offset AS INTEGER, value AS INTEGER

     DEF SEG = VARSEG(instrument%(1,1))

     offset = VARPTR(instrument%(1,1))

     ' Set the instrument table with first 10 instrument defined in DATA

     FOR i = 1 to 10

	  FOR j = 1 to 16

	       READ value

	       POKE offset,value
	       offset = offset + 1

	  NEXT

     NEXT

     DEF SEG

DATA   &H21,&H11,&H4C,&H00,&HF1,&HF2,&H63,&H72
DATA   &H00,&H00,&H04,&H00,&H00,&H00,&H00,&H00

DATA   &HA5,&HB1,&HD2,&H80,&H81,&HF1,&H03,&H05
DATA   &H00,&H00,&H02,&H00,&H00,&H00,&H00,&H00

DATA   &H72,&H62,&H1C,&H05,&H51,&H52,&H03,&H13
DATA   &H00,&H00,&H0E,&H00,&H00,&H00,&H00,&H00

DATA   &H11,&H01,&H8A,&H40,&HF1,&HF1,&H11,&HB3
DATA   &H00,&H00,&H06,&H00,&H00,&H00,&H00,&H00

DATA   &H21,&H11,&H11,&H00,&HA3,&HC4,&H43,&H22
DATA   &H02,&H00,&H0D,&H00,&H00,&H00,&H00,&H00

DATA   &H31,&HA1,&H1C,&H80,&H41,&H92,&H0B,&H3B
DATA   &H00,&H00,&H0E,&H00,&H00,&H00,&H00,&H00

DATA   &H71,&H62,&HC5,&H05,&H6E,&H8B,&H17,&H0E
DATA   &H00,&H00,&H02,&H00,&H00,&H00,&H00,&H00

DATA   &H41,&H91,&H83,&H00,&H65,&H32,&H05,&H74
DATA   &H00,&H00,&H0A,&H00,&H00,&H00,&H00,&H00

DATA   &H32,&H16,&H87,&H80,&HA1,&H7D,&H10,&H33
DATA   &H00,&H00,&H08,&H00,&H00,&H00,&H00,&H00

DATA   &H01,&H13,&H8D,&H00,&H51,&H52,&H53,&H7C
DATA   &H01,&H00,&H0C,&H00,&H00,&H00,&H00,&H00

END SUB


' ------------------------------------------------------------------------ '


SUB PLAYSCALE

     DIM  inst AS INTEGER, delay1 AS INTEGER, delay2 AS INTEGER, note AS INTEGER
     DIM  notenum%(8)

     ' Setup the MIDI note number
     FOR note = 1 TO 8
	  READ notenum%(note)
     NEXT

     ' Play each instrument
     FOR inst = 0 TO 9

	  ' Set channel 0 instrument
	  CALL SLPROGRM((0),inst)

	  ' Play a scale on channel 0
	  FOR note = 1 TO 8

	       CALL SLNOTEON((0),notenum%(note),&h40)

	       ' Delay
	       FOR delay1 = 1 TO 100
		    FOR delay2 = 1 TO 4000
		    NEXT
	       NEXT

	       CALL SLNOTEOFF((0),notenum%(note),&h40)
	  NEXT

     NEXT

DATA   60, 62, 64, 65, 67, 69, 71, 72
END SUB
