program midiin;

{ Set up memory limits, for a 16K stack and a 64K heap }
{$M 16384,0,65535}

{ Include the SBC Unit, and any other units needed }
uses sbc_tp6, dos, crt;

type
  TwoChar = array[0..1] of char;
  TwoCharPtr = ^TwoChar;

var
  HexStr : TwoChar;

{ ------------------------------------------------------------- }

{ Function to convert byte to hex array }
function IntToHexStr(x : byte) : TwoCharPtr;
var
  tmp, l : byte;

begin

  for l := 1 downto 0 do begin
      tmp := x and $0f;

      if (tmp >= 10) and (tmp <= 15) then
          HexStr[l] := CHR(tmp+$41-10)
      else
          HexStr[l] := CHR(tmp+$30);

      x := x shr 4;
  end;

  IntToHexStr := @HexStr;

end;


{ ------------------------------------------------------------- }

{ main function }
var
  midi_code, time_stamp : longint;
  midi_byte : byte;
  stop_flag : boolean;

begin

  { set I/O addx to $220 }
  _ct_io_addx := $220;

  if boolean( sbc_check_card and $0004 ) then begin

      if boolean( sbc_scan_int ) then begin

          { Start input }
          sbmidi_start_input;

          stop_flag := False;

          repeat
            begin

                { Check for ESC key }
                if keypressed then
                    if Readkey = #27 then
                        stop_flag := True;


                { Read the MIDI input from buffer }
                midi_code := sbmidi_get_input;

                if ( midi_code <> longint(0) ) then begin

                    midi_byte := byte(midi_code and $000000ff);
                    time_stamp := midi_code shr 8;
                    
                    writeln('MIDI Byte : ',(IntToHexStr(midi_byte))^:2,
                            ' hex    Time Stamp : ',time_stamp:8,' msec');
                end;

            end;
          until stop_flag;


          { Stop input }
          sbmidi_stop_input;

          { read the remaining codes in the buffer }
          repeat
            begin

                midi_code := sbmidi_get_input;

                if ( midi_code <> longint(0) ) then begin

                    midi_byte := byte(midi_code and $000000ff);
                    time_stamp := midi_code shr 8;

                    writeln('MIDI Byte : ',(IntToHexStr(midi_byte))^:2,
                            ' hex    Time Stamp : ',time_stamp:8,' msec');

                end;

            end;
          until not boolean(midi_code);

      end

      else
          writeln('Interrupt Error.');

  end

  else
      writeln('Sound Blaster not available or wrong I/O address setting');

end.
