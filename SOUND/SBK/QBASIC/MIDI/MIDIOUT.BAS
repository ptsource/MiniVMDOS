' $INCLUDE: 'SBC.BI'
' $INCLUDE: 'SBCSYS.BI'
' $INCLUDE: 'SBMIDI.BI'



REM $DYNAMIC
CLEAR

CLS

PRINT "SBK QuickBasic MIDI Out Interface Example"

DIM pnum  AS INTEGER, delay1 AS INTEGER, delay2 AS INTEGER, note AS INTEGER
DIM dummy AS INTEGER
DIM NOTENUM%(8)



' Set I/O address
CTIOADDX (&H220)

' Check for Sound Blaster Card
IF ((SBCHKCRD% AND 4) = 4) THEN

     ' Scan for interrupt
     IF (SBSCNINT% > 0) THEN

          ' Setup the MIDI note number
          FOR note = 1 TO 8
               READ NOTENUM%(note)
          NEXT


          ' Change 5 program number
          FOR pnum = 0 TO 4

               ' Program change command
               dummy = MIDIOSM%(&HC0, pnum, (0))

               ' Play a scale on channel 0
               FOR note = 1 TO 8

                    ' Note On command
                    dummy = MIDIOSM%(&H90, NOTENUM%(note), &H40)


                    ' Delay
                    FOR delay1 = 1 TO 100
                         FOR delay2 = 1 TO 4000
                         NEXT
                    NEXT

                    ' Note Off command
                    dummy = MIDIOSM%(&H80, NOTENUM%(note), &H40)

               NEXT

          NEXT

     ELSE
          PRINT "Interrupt Error"
     END IF
ELSE
     PRINT "Sound Blaster Card not found"
END IF

DATA   60, 62, 64, 65, 67, 69, 71, 72
END

