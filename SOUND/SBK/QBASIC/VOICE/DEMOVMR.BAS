'
' This program records a voice file TEMP.VOC
'

' $INCLUDE: 'SBC.BI'
' $INCLUDE: 'SBCSYS.BI'
' $INCLUDE: 'SBCVOICE.BI'

DECLARE FUNCTION LDVFILE% (filename$, segment%, offset%)
DECLARE SUB RECFILE(filename$,buffer%())
DECLARE FUNCTION RECORD%(buffer%(),bufsize&)
DECLARE SUB SAVEVOC(filename$,buffer%())


REM $DYNAMIC
CLEAR

' Free 4K memory for the CT-VOICE.DRV
DUMMY = SETMEM(-4096)

' Allocate 100K buffer for voice data
DIM buffer%(1 TO 100,1 TO 512)

CLS
PRINT "SBK Voice Recording (memory version) Example"

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

		    ' Record a voice file
		    CALL RECFILE("TEMP.VOC",buffer%())

		    ' Terminate driver before exit
		    CALL SVMEXIT

	       ENDIF

	  END IF

     END IF

ELSE
	PRINT "Sound Blaster Card not found"
END IF

' Return the memory to BASIC
DUMMY = SETMEM(4096)

END


' ------------------------------------------------------------------------ '

REM $STATIC
SUB RECFILE(filename$,buffer%())

' This function records a voice buffer and saves it into file

     DIM   bufsize AS LONG

     ' Set the buffer size to 100K
     bufsize = 100000&

     IF (RECORD%(buffer%(),bufsize) <> 0) THEN
	  CALL SAVEVOC(filename$,buffer%())
     ENDIF

END SUB


' ------------------------------------------------------------------------ '


FUNCTION RECORD%(buffer%(),bufsize&)

' This function records the voice, until buffer full.
' Keyboard input is checked for terminating the recording before the buffer
' is full.

     DIM userkey AS INTEGER, voice AS INTEGER

     SVMSPKER INT(0)

     RECORD% = 0

     IF (SVMINPUT%(buffer%(1,1),bufsize&,INT(8000)) = 0) THEN

	  RECORD% = 1

	  WHILE CTVOICE% <> 0

	       c$ = INKEY$

	       IF c$ <> "" THEN

		    IF c$=chr$(27) THEN
			 CALL SVMSTOP
		    ENDIF

	       END IF

	  WEND

     END IF

END FUNCTION


' ------------------------------------------------------------------------ '


SUB SAVEVOC(filename$,buffer%())

' This function save the buffer into a Creative Voice file format

     DIM header AS VOCHDR, handle AS INTEGER, bufsize AS LONG

     ' Setup the voice file format
     header.id = "Creative Voice File" + CHR$(26)
     header.offset = 26
     header.version = &H10A
     header.checkcode = &H1129

     ' Create a file
     handle = DOSCREATE%(filename$)

     IF (handle <> 0) THEN

	  ' Write the file header
	  IF (DOSWRITE%(handle,VARPTR(header.id),VARSEG(header.id),26) <> 0) THEN

	       ' Get the voice block length from buffer
	       DEF SEG = VARSEG(buffer%(1,1))
		    bufsize = PEEK(VARPTR(buffer%(1,1)) + 1)
	       DEF SEG

	       bufsize = bufsize + 256& * buffer%(2,1)

	       ' Add 5 bytes for the block header and terminating block
	       bufsize = bufsize + 5

	       ' Write the buffer
	       IF (DOSWRITE%(handle,VARPTR(buffer%(1,1)),VARSEG(buffer%(1,1)),bufsize) = 0) THEN
		    PRINT "Write file error."
	       ENDIF

	  ENDIF

	  CALL DOSCLOSE(handle)
     ELSE
	  PRINT "Creating file error.\n"
     ENDIF

END SUB
