' $INCLUDE: 'SBC.BI'
' $INCLUDE: 'SBCSYS.BI'
' $INCLUDE: 'SBMIDI.BI'


REM $DYNAMIC
CLEAR

CLS

PRINT "SBK QuickBasic MIDI In Interface Example"

DIM midicode&, timestamp&, midibyte%
DIM userkey%, key$


' Set I/O address
CTIOADDX (&H220)

' Check for Sound Blaster Card
IF ((SBCHKCRD% AND 4) = 4) THEN

     ' Scan for interrupt
     IF (SBSCNINT% > 0) THEN

          ' start MIDI input
          CALL MIDISTIN

          ' Read MIDI Input from buffer
          DO

               ' Check for ESC key
               c$ = INKEY$

               IF (c$ <> "") THEN

                    userkey = ASC(c$)

                    IF userkey = 27 THEN
                         EXIT DO
                    END IF

               END IF

               ' Get MIDI code from buffer
               midicode& = MIDIGETI&

               IF (midicode& <> 0) THEN

                    ' MIDI byte
                    midibyte% = midicode& MOD 256

                    ' MIDI time stamp
                    timestamp& = CLNG((midicode& - CLNG(midibyte%)) / 256)

                    ' print data
                    PRINT "MIDI Byte : ";HEX$(midibyte%);TAB(16);" hex     ";
                    PRINT USING "Time Stamp : ######## msec"; timestamp&
              
               END IF

          LOOP

          ' Stop MIDI input
          CALL MIDISPIN

          ' Read the remaining codes in the buffer
          DO

               ' Get MIDI code from buffer
               midicode& = MIDIGETI&

               IF (midicode& <> 0) THEN

                    ' MIDI byte
                    midibyte% = midicode& MOD 256

                    ' MIDI time stamp
                    timestamp& = CLNG((midicode& - CLNG(midibyte%)) / 256)

                    ' print data
                    PRINT "MIDI Byte : ";HEX$(midibyte%);TAB(16);" hex     ";
                    PRINT USING "Time Stamp : ######## msec"; timestamp&
              
               END IF

          LOOP UNTIL (midicode& = 0)

     ELSE
          PRINT "Interrupt Error"
     END IF

ELSE
     PRINT "Sound Blaster Card not found"
END IF

END

