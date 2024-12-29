'
' This program output the voice file DEMO.VOC
'

' $INCLUDE: 'SBC.BI'
' $INCLUDE: 'SBCSYS.BI'
' $INCLUDE: 'SBCVOICE.BI'

DECLARE FUNCTION LDVFILE% (filename$, segment%, offset%)
DECLARE SUB OUTVOC (buffer%())

REM $DYNAMIC
CLEAR

CLS

PRINT "SBK QuickBasic Voice Output (memory version) Example"

' Free 4K memory for the CT-VOICE.DRV
DUMMY = SETMEM(-4096)

' Allocate 180K buffer for voice data file
DIM buffer%(1 TO 180, 1 TO 512)

' Set I/O address
CTIOADDX (&H220)

' Check for Sound Blaster Card
IF ((SBCHKCRD% AND 4) = 4) THEN

	' Scan for interrupt
	IF (SBSCNINT% > 0) THEN

	  ' Load CT-VOICE.DRV
	  DRVADDX% = LOADDRV%

	  ' If driver loaded successfully
	  IF (DRVADDX% <> 0) THEN

		  ' Set driver address
		  CTVADDX (DRVADDX%)

		  ' Initialize driver
		  IF (SVMINIT% = 0) THEN

		    CALL SVMSPKER(INT(0))

		    ' Load voice file
		    IF (LDVFILE("DEMO.VOC", VARSEG(buffer%(1, 1)), VARPTR(buffer%(1, 1))) <> 0) THEN
			  CALL OUTVOC(buffer%())
		    END IF

		    ' Terminate driver before exit
		    CALL SVMEXIT

		  END IF

	  END IF


	END IF

ELSE
	PRINT "Sound Blaster Card not found"
END IF

' Return memory to BASIC
DUMMY = SETMEM(4096)

END


' ------------------------------------------------------------------------ '


' ------------------------------------------------------------------------ '

REM $STATIC
FUNCTION LDVFILE% (filename$, segment%, offset%)

' This function loads voice file into buffer%

	DIM handle%, filelen&

	handle% = DOSOPEN(filename$)
	LDVFILE% = 0

	IF (handle% <> 0) THEN
	  filelen& = FILESIZE&(handle%)

	  IF (DOSREAD%(handle%, offset%, segment%, filelen&) <> 0) THEN
		  LDVFILE% = 1
	  ELSE
		  PRINT "Read file error."
	  END IF

	  DOSCLOSE (handle%)
	ELSE
	  PRINT "Open " + filename$ + "error."
	END IF

END FUNCTION

SUB OUTVOC (buffer%())

' This function output the voice file loaded and check for the keyboard
' input to pause, stop and break the voice output

	DIM userkey AS INTEGER, voice AS INTEGER

	' Turn on DAC speaker
	CALL SVMSPKER(INT(1))

	voice% = buffer%(11, 1)

	IF (SVMOUTPUT%(buffer%(voice% / 2 + 1, 1)) = 0) THEN

	  WHILE CTVOICE% <> 0

		  c$ = INKEY$

		  IF c$ <> "" THEN

		    userkey = INT(ASC(LEFT$(c$, 1)))

		    SELECT CASE userkey
			 CASE ASC("S"), ASC("s"), 27
				 CALL SVMSTOP
			 CASE ASC("P"), ASC("p")
				 CALL SVMPAUSE
			 CASE ASC("C"), ASC("c")
				 CALL SVMCONT
			 CASE ASC("B"), ASC("b")
				 SVMBREAK (INT(1))
		    END SELECT

		  END IF

	  WEND

	END IF

	' Turn off DAC speaker
	CALL SVMSPKER(INT(0))

END SUB
