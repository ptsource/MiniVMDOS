program demovdr;

{ Set up memory limits, for a 16K stack and a 64K heap }
{$M 16384,0,65535}

{ Include the SBC Unit, and any other units needed }
uses sbc_tp6, dos, crt;


{ ------------------------------------------------------------------------ }

{ Get the file handle of a file with the filename specified }
function GetCreateFilehandle(Filename: String; var Error: Boolean) : integer;
var
  Regs : Registers;

begin
  Filename := Filename + #0;
  FillChar( Regs, SizeOf(Regs), 0 );
  With Regs Do
    begin
      AX := $3c00;
      DS := Seg(Filename);
      DX := Ofs(Filename)+1;
      CX := $20;
    end;

  intr($21,Regs);

  if (Lo(Regs.Flags) And $01) > 0  then begin
    Error := True;
    GetCreateFileHandle := 0;
    end
  else begin
    GetCreateFileHandle := Regs.AX;
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

{ start recording, stop by pressing Esc key }
procedure record_until_stopped;
begin

  repeat
    begin

      if keypressed then
        if Readkey = #27 then
          ctvd_stop;

    end;
  until not boolean(_ct_voice_status);

end;


{ ------------------------------------------------------------------------ }

procedure record_file(filename : string);
var
  handle: integer;
  error: Boolean;

begin

  handle := GetCreateFileHandle(filename,error);

  if not error then begin
    ctvd_speaker(0);

    if ctvd_input(handle,8000) = 0 then begin
      record_until_stopped;

      if ctvd_drv_error <> 0 then
        show_error
      else
        writeln('Voice record ended.');
    end

    else
      show_error;

    CloseFileHandle(handle);
  end

  else
    writeln('Create ',filename,' file error ...');

end;


{ ------------------------------------------------------------------------ }

{ main function }
begin  { program body }

  _ct_io_addx := $220;

  if boolean( sbc_check_card and $0004 ) then begin

    if boolean(sbc_scan_int) then begin

      if ctvd_init(16) = 0 then begin

        ctvd_speaker(0);

        record_file('TEMP.VOC');

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