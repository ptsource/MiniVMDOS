program midiout;

{ Set up memory limits, for a 16K stack and a 64K heap }
{$M 16384,0,65535}

{ Include the SBC Unit, and any other units needed }
uses sbc_tp6, dos, crt;

const
  { look up table for a scale starting from 'Middle C' }
  note_num : array[0..7] of byte = ( 60,62,64,65,67,69,71,72 );


{ ------------------------------------------------------------- }

{ main function }
var
  i, j, note, dummy : word;
  pnum : byte;


begin

  { set I/O addx to $220 }
  _ct_io_addx := $220;

  if boolean( sbc_check_card and $0004 ) then begin

      if boolean( sbc_scan_int ) then begin

          for pnum := 0 to 4 do begin

              { program change command }
              dummy := sbmidi_out_shortmsg( $C0, pnum, 0 );


              { play the Middle C scale }
              for note := 0 to 7 do begin

                  { Note On command }
                  dummy := sbmidi_out_shortmsg( $90, note_num[note], $40 );


                  { delay loop }
                  for i := 0 to 150 do
                      for j := 0 to 1000 do begin
                      end;


                  { Note Off command }
                  dummy := sbmidi_out_shortmsg( $80, note_num[note], $40 );

              end;

          end;

      end

      else
          writeln('Interrupt Error.');

  end

  else
      writeln('Sound Blaster not available or wrong I/O address setting');

end.
