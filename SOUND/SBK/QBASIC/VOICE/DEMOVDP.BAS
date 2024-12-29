'
' This program output the voice file DEMO.VOC
'

' $INCLUDE: 'SBC.BI'
' $INCLUDE: 'SBCSYS.BI'
' $INCLUDE: 'SBCVOICE.BI'

DECLARE   SUB  OUTVOCFILE(filename$)
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

PRINT "SBK QuickBasic Voice Output (disk version) Example"

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
	       CALL OUTVOCFILE("DEMO.VOC")

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
SUB  OUTVOCFILE(filename$)

     DIM  handle AS INTEGER, userkey AS INTEGER

     ' Open the file using DOS function
     handle = DOSOPEN%(filename$)

     IF (handle <> 0) THEN

	  ' Turn on speaker
	  SVDSPKER(INT(1))

	  ' Start the output
	  IF (SVDOUTPUT%(handle) = 0) THEN

	       WHILE CTVOICE% <> 0

		    c$ = INKEY$

		    IF c$ <> "" THEN

			 userkey = INT(ASC(LEFT$(c$, 1)))

			 SELECT CASE userkey
			      CASE ASC("S"), ASC("s"), 27
				   CALL SVDSTOP
			      CASE ASC("P"), ASC("p")
				   CALL SVDPAUSE
			      CASE ASC("C"), ASC("c")
				   CALL SVDCONT
			      CASE ASC("B"), ASC("b")
				   SVDBREAK(INT(1))
			 END SELECT

		    END IF

	       WEND

	  ELSE
	       CALL SHOWERROR
	  ENDIF
     ELSE
	  PRINT "Open " +filename$ + "error."
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
