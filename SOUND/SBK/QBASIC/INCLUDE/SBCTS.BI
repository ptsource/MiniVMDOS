DECLARE FUNCTION STINIT% CDECL ALIAS "_sbts_init"
DECLARE SUB STSETTING CDECL ALIAS "_sbts_settings" (BYVAL gender%, BYVAL tone%, BYVAL volume%, BYVAL pitch%, BYVAL speed%)
DECLARE SUB STSAY CDECL ALIAS "_basicsay" (SEG engstr$)
