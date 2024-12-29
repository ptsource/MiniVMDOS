'
' This program records a voice file TEMP.VOC
'

' $INCLUDE: 'SBC.BI'
' $INCLUDE: 'SBCSYS.BI'
' $INCLUDE: 'SBCVOICE.BI'

DECLARE   SUB  RECVOCFILE(filename$)
DECLARE   SUB  SHOWERROR()

REM $DYNAMIC
CLEAR

' Following statements free memory for the Disk Double Buffer
' Two 32K buffers are released by BASIC
DUMMY = SETMEM(-16400)
DUMMY = SETMEM(-16400)
DUMMY = SETMEM(-16400)
DUMMY = SETMEM(-16400)

CLS

PRINT "SBK QuickBasic Voice Recording (disk version) Example"

' Set I/O address
CTIOADDX (&H220)

' Detect Sound Blaster Card
IF ((SBCHKCRD% AND 4) = 4) THEN

     ' Detect interrupt
     IF (SBSCNINT% > 0) THEN

	  ' Initial the driver, with 64K buffer as double buffer
	  IF ( SVDINIT%((16)) = 0 ) THEN

	       ' Off DAC speaker
	       CALL SVDSPKER(INT(0))

	       ' Output the voice file
	       CALL RECVOCFILE("TEMP.VOC")

	       ' Terminate the driver
	       CALL SVDEXIT

	  ELSE
	       CALL SHOWERROR
	  ENDIF

     ELSE
	  PRINT "Interrupt error."
     END IF

ELSE
	PRINT "Sound Blaster Card not found"
END IF

' Return the memory to BASIC
DUMMY = SETMEM(16400)
DUMMY = SETMEM(16400)
DUMMY = SETMEM(16400)
DUMMY = SETMEM(16400)

END


' ------------------------------------------------------------------------ '


REM %STATIC
SUB  RECVOCFILE(filename$)

' This function create a file and record voice into it

     DIM  handle AS INTEGER, userkey AS INTEGER

     handle = DOSCREATE%(filename$)

     IF (handle <> 0) THEN

	  SVDSPKER(INT(0))

	  IF (SVDINPUT%(handle,(8000)) = 0) THEN

	       WHILE CTVOICE% <> 0

		    c$ = INKEY$

		    IF (c$ <> "") THEN

			 userkey = ASC(c$)

			 IF userkey = 27 THEN
			      CALL SVDSTOP
			 ENDIF

		    ENDIF

	       WEND

	  ENDIF

     ENDIF

END SUB


' ------------------------------------------------------------------------ '


SUB  SHOWERROR

' This function show the error code from the driver

     DIM  errcode AS INTEGER

     errcode = SVDDRVERR%

     PRINT "Driver error ="; errcode

     IF (errcode <> 6) AND (errcode <> 2) THEN
	  PRINT "Dos error ="; SVDEXTERR%
     ENDIF

END SUB
