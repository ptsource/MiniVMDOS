'
' This program output the sample CMF file FFARES.CMF
'

' $INCLUDE: 'SBC.BI'
' $INCLUDE: 'SBCSYS.BI'
' $INCLUDE: 'SBCMUSIC.BI'

DECLARE FUNCTION LODCMF% (filename$, segment%, offset%)
DECLARE SUB PLAYCMF(buffer%())

REM $DYNAMIC
CLEAR

CLS

PRINT "SBK QuickBasic Play CMF File Example"

' Allocate 64K buffer for CMF file
DIM buffer%(1 TO 64,1 TO 512)

' Set I/O address
CTIOADDX (&H220)

' Check for Sound Blaster Card
IF (SBCHKCRD% > 4) THEN

     ' Initialize driver
     IF (SMINIT% <> 0) THEN

	  ' Load music file
	  IF (LODCMF("FFARES.CMF", VARSEG(buffer%(1,1)), VARPTR(buffer%(1,1))) <> 0) THEN

	       ' Check for file version number
	       IF buffer%(3,1) < &h101 THEN
		    PRINT "Old version not supported."
	       ELSE
		    CALL PLAYCMF(buffer%())
	       ENDIF

	  ENDIF

	  ' Terminate driver before exit
	  CALL SMEXIT
     ELSE
	  PRINT "SBFMDRV driver not installed"
     ENDIF

ELSE
	PRINT "Sound Blaster Card not found"
END IF

END


' ------------------------------------------------------------------------ '


REM $STATIC
FUNCTION LODCMF% (filename$, segment%, offset%)

' This function loads voice file into buffer%

     DIM handle%, filelen&

     handle% = DOSOPEN(filename$)
     LODCMF% = 0

     IF (handle% <> 0) THEN
	  filelen& = FILESIZE&(handle%)

	  IF (DOSREAD%(handle%, offset%, segment%, filelen&) <> 0) THEN
	       LODCMF% = 1
	  ELSE
	       PRINT "Read file error."
	  END IF

	  DOSCLOSE(handle%)
     ELSE
	  PRINT "Open " + filename$ + "error."
     END IF

END FUNCTION


' ------------------------------------------------------------------------ '


SUB PLAYCMF (buffer%())

     DIM insblk AS INTEGER, musicblk AS INTEGER
     DIM time0rate AS INTEGER, freq AS LONG

     ' Get instrument table offset
     insblk = buffer%(4,1)

     ' Get music offset
     musicblk = buffer%(5,1)

     ' Reset driver
     CALL SMRESET

     ' Set song frequency
     freq = 1193180&
     freq = freq / buffer%(7,1)
     time0rate = freq
     CALL SMSONSPD(time0rate)

     ' Set instrument table
     CALL SMINST(buffer%(INT(insblk/2+1),1),buffer%(19,1))

     ' Start Music
     CALL SMPLAY(buffer%(INT(musicblk/2+1),1))

     ' Wait Music End

     CALL WAITMUS

END SUB


' ------------------------------------------------------------------------ '


SUB  WAITMUS

     DIM  userkey AS INTEGER, transpose AS INTEGER

     transpose = 0

     WHILE SMSTATUS% <> 0

	  c$ = INKEY$

	  IF c$ <> "" THEN

	       userkey = ASC(c$)

	       SELECT CASE userkey
		    CASE ASC("S"), ASC("s"), 27
			 CALL SMSTOP
		    CASE ASC("P"), ASC("p")
			 CALL SMPAUSE
		    CASE ASC("C"), ASC("c")
			 CALL SMRESUME
		    CASE 0
			 userkey = ASC(MID$(c$,2,1))

			 IF userkey = 75 THEN
			      transpose = transpose - 1
			 ELSEIF userkey = 77 THEN
			      transpose = transpose + 1
			 ENDIF

			 CALL SMTRNPOS(transpose)
	       END SELECT

	  ENDIF

     WEND

END SUB
