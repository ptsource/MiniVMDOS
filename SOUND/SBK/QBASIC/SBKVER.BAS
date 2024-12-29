' -----------------------------------------------------------------------------
'
'    This program helps to show your Sound Blaster Developer Kit version
'    number.
'
'    To check your library version version compile this program with
'    following command:
'
'         BC sbkver ;
'         LINK sbkver,,,qbsbc bcom45 ;
'
' -----------------------------------------------------------------------------

DECLARE FUNCTION SBKVERMA%
DECLARE FUNCTION SBKVERMI%
DECLARE FUNCTION SBKEDITI%


PRINT "Sound Blaster Developer Kit"
PRINT "QuickBasic version" : PRINT

PRINT USING "Version: #.##"; SBKVERMA% + SBKVERMI%/100
PRINT USING "Edition: #"; SBKEDITI%
