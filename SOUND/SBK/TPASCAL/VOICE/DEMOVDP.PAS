program demovdp;

{ Set up memory limits, for a 16K stack and a 64K heap }
{$M 16384,0,65535}

{ Include the SBC Unit, and any other units needed }
uses sbc_tp6, dos, crt;


{ ------------------------------------------------------------------------ }

{ Get the file handle of a file with the filename specified }
function GetFilehandle(Filename: String; var Error: Boolean) : integer;
var
  Regs : Registers;

begin
  Filename := Filename + #0;
  FillChar( Regs, SizeOf(Regs), 0 );
  With Regs Do
    begin
      AX := $3d00;
      DS := Seg(Filename);
      DX := Ofs(Filename)+1;
    end;

  intr($21,Regs);

  if (Lo(Regs.Flags) And $01) > 0  then begin
    Error := True;
    GetFileHandle := 0;
    end
  else begin
    GetFileHandle := Regs.AX;
    Error := False;
  end;
end;


{ ------------------------------------------------------------------------ }

{ Close a file }
procedure CloseFileHandle(handle: integer);
var
  Regs : Registers;

begin
  FillChar( Regs, SizeOf(Regs), 0 );
  With Regs Do
    begin
      AX := $3e00;
      BX := handle;
    end;

  intr($21,Regs);

end;


{ ------------------------------------------------------------------------ }

{ show the error code from the driver }
procedure show_error;
var
  err : integer;

begin

  err := ctvd_drv_error;

  writeln('Driver error = ',err);

  if (err <> 6) and (err <> 2) then
    writeln('DOS error = ',ctvd_ext_error);

end;


{ ------------------------------------------------------------------------ }

procedure play_voice_in_bkgnd;
const
  ESC            = 27;
  SPACE          = 32;
  TAB            = 9;
  CR             = 13;

  EXT            = 256;
  LEFTARROW      = (EXT+75);
  RIGHTARROW     = (EXT+77);

var
  key : char;
  keyval : integer;

begin

  repeat
    begin

      if keypressed then begin
        key := ReadKey;
        keyval := ord(key);

        if ((key = #0) and keypressed) then begin
          key := ReadKey;
          keyval := ord(key)+EXT;
        end;

        case (keyval) of
          ESC :
            begin
              ctvd_stop;
              writeln('     Voice Stopped ....');
            end;

          SPACE :
            begin
              ctvd_pause;
              writeln('     Pause ....');
              writeln('     Press any key to continue ....');
              key := Readkey;
              ctvd_continue;
            end;

          CR :
            begin
              ctvd_break_loop(1);
              writeln('     Break-out takes place immediately ....');
            end;

          TAB :
            begin
              ctvd_break_loop(0);
              writeln('     Break-out takes place after the current loop finishes ....');
            end;
        end;
      end;

    end;
  until not boolean(_ct_voice_status);

end;


{ ------------------------------------------------------------------------ }

procedure output_file(filename : string);
var
  handle: integer;
  error: Boolean;

begin

  handle := GetFileHandle(filename,error);

  if not error then begin
    ctvd_speaker(1);

    if ctvd_output(handle) = 0 then begin
      play_voice_in_bkgnd;

      if ctvd_drv_error <> 0 then
        show_error
      else
        writeln('Voice output ended.');
    end

    else
      show_error;

    ctvd_speaker(0);

    CloseFileHandle(handle);
  end

  else
    writeln('Open ',filename,' error ...');

end;


{ ------------------------------------------------------------------------ }

{ main function }
begin

  _ct_io_addx := $220;

  if boolean( sbc_check_card and $0004 ) then begin

    if boolean(sbc_scan_int) then begin

      if ctvd_init(16) = 0 then begin

        ctvd_speaker(0);

        output_file('DEMO.VOC');

        ctvd_terminate;

      end

      else
        show_error;

    end

    else
      writeln('Interrupt Error !');

  end

  else
      writeln('Sound Blaster Card not found.');
end.
