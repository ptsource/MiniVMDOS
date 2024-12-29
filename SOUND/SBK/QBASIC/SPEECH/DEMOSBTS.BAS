' $INCLUDE: 'SBCTS.BI'

DECLARE SUB WAITKEY()

' Reserve 512 bytes stack space for SUB STSAY
CLEAR,,512

CLS

PRINT "QuickBaisc Text-to-Speech Example"
PRINT

' Check the existence of SBTALKER driver
IF (STINIT% <> 0) THEN

     PRINT "SBTALKER installed."
     STSAY "SB-talker installed."

     CALL WAITKEY

     ' Change the volume
     CALL STSETTING(0,0,9,5,5)
     PRINT "I can speek louder."
     STSAY "I can speak louder."

     CALL WAITKEY

     ' Change the pitch
     CALL STSETTING(0,0,9,9,5)
     PRINT "I can change my pitch."
     STSAY "I can change my pitch."

     CALL WAITKEY

     ' Change the speed
     CALL STSETTING(0,0,9,9,9)
     PRINT "I can speak very fast"
     STSAY "I can speak very fast"

ELSE
     PRINT "SBTALKER not installed."
ENDIF


' ---------------------------------------------------------------- '


SUB WAITKEY

     PRINT "Press a key to continue..."

     WHILE INKEY$ = ""
     WEND

END SUB
