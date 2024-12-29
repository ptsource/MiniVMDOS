{ --------------------------------------------------------------------------

     This program helps to show your Sound Blaster Developer Kit version
     number.

     To check your library version compile this program with following
     command:

           TPC sbkver

  -------------------------------------------------------------------------- }

program sbkver;

{ Include the SBC Unit, and any other units needed }
uses sbc_tp6;

begin

      writeln('Sound Blaster Developer Kit');
      writeln('Turbo Pascal version');
      writeln;
      writeln('Version : ',sbclib_version_major + sbclib_version_minor/100:2:2);
      writeln('Edition : ',sbclib_edition);
end.
