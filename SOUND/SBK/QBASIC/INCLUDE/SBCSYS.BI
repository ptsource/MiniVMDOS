 TYPE regs
     ax AS INTEGER
     bx AS INTEGER
     cx AS INTEGER
     dx AS INTEGER
     bp AS INTEGER
     si AS INTEGER
     di AS INTEGER
     flags AS INTEGER
     ds AS INTEGER
     es AS INTEGER
 END TYPE


DECLARE SUB INTERRUPTX (intnum AS INTEGER, iregs AS regs, oregs AS regs)
DECLARE SUB DOSINT21 (iregs AS regs, oregs AS regs)
DECLARE FUNCTION ALLOCMEM% (PARASIZE%)
DECLARE SUB FREEMEM (segment%)
DECLARE FUNCTION LOADDRV% ()
DECLARE FUNCTION DOSOPEN% (filename$)
DECLARE FUNCTION DOSCREATE% (filename$)
DECLARE SUB DOSCLOSE (handle%)
DECLARE FUNCTION DOSWRITE% (handle%, segment%, offset%, size&)
DECLARE FUNCTION DOSREAD% (handle%, segment%, offset%, size&)
DECLARE FUNCTION FINDFILE% (filename$)
DECLARE FUNCTION FILESIZE& (BYVAL handle%)
