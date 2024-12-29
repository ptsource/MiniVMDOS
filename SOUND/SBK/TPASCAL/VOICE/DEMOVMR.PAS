program demovmr;

{ Set up memory limits, for a 16K stack and a 64K heap.
  Note that this is necessary because the program is
  using DOS to allocate memory.  Otherwise, the heap
  will occupy the remaining memory and causes allocate_mem
  function returns False. }

{$M 16384,0,65535}

{ Include the SBC Unit, and any other units needed }
uses sbc_tp6, dos, crt;

{ Include type-defined for VOC header }
{$I sbcvoice.inc }


{ ------------------------------------------------------------------------ }

{ Allocate memory via DOS INT 21H. It can allocate more
  than 64 K with offset is 0. It is used here to enable
  the program to play any file including those larger
  than 64 K. }
function allocate_mem(var blk_size: word) : Boolean;
var
  Regs : Registers;

begin
  FillChar( Regs, SizeOf(Regs), 0 );
  With Regs Do
    begin
      AX := $4800;
      BX := blk_size;
    end;

  intr($21,Regs);

  if Lo(Regs.Flags) And FCarry = 0  then begin
    allocate_mem := True;
    blk_size:= Regs.AX;
    end
  else
    allocate_mem := False;

end;


{ ------------------------------------------------------------------------ }

{ free allocated memory }
procedure dos_free_mem(free_buf: pointer);
var
  Regs : Registers;

begin
  FillChar( Regs, SizeOf(Regs), 0 );
  With Regs Do
    begin
      AX := $4900;
      ES := Seg(free_buf^);
    end;

  intr($21,Regs);

end;


{ ------------------------------------------------------------------------ }

function write_file(var F: file; buffer: pointer; size: longint) : boolean;
type
  PtrRec = record
    lo, hi : word
  end;

var
  byte_to_write, byte_written, temp : word;

begin

  write_file := True;
  temp := 0;
  repeat

    begin

      byte_to_write := $8000;

      if size < $8000 then
        byte_to_write := Word(size);

      BlockWrite(F,buffer^,byte_to_write,byte_written);

      if byte_written <> byte_to_write then begin
        writeln('Disk Full ...');
        write_file := False;
        size := 0;
      end

      else begin
        temp := temp + byte_written;

        if not Boolean(Hi(temp)) then
          buffer := pointer( longint(PtrRec(buffer).hi + $1000) shl 16 )
        else
          buffer := pointer( longint(buffer) + longint(temp) );

        size := size - byte_written;
      end;

    end;

  until not boolean(Lo(word(size)));

end;


{ ------------------------------------------------------------------------ }

{ start recording, stop by pressing Esc key }
function recording(buffer: pointer; buffer_size: longint) : boolean;
begin
  recording := False;
  ctvm_speaker(0);

  if ctvm_input(buffer,buffer_size,8000) = 0 then begin
    recording := True;

    repeat
      begin

        if keypressed then
          if Readkey = #27 then
            ctvm_stop;

      end;
    until not boolean(_ct_voice_status);

  end;

end;


{ ------------------------------------------------------------------------ }

procedure save_voice_file(filename: string; buffer: pointer);
var
  F : file;
  voicesize, temp : longint;
  header : VOCHDR;
  dummy : boolean;
  S : String[20];

begin
  S := 'Creative Voice File';
  move( S[1], header.id, 20 );
  header.id[19] := #26;
  header.voice_offset := SizeOf(VOCHDR);
  header.version := $010a;
  header.check_code := $1129;

  {$I-}
  Assign(F, filename);
  Rewrite(F,1);
  {$I+}

  if IOResult = 0 then begin

    if write_file(F,@header,longint(SizeOf(VOCHDR))) then begin

      voicesize := longint( pointer(longint(buffer)+1)^ );
      voicesize := voicesize and $00ffffff;

      { add 5 bytes for the bloack header and terminating block }
      voicesize := voicesize + 5;

      dummy := write_file(F,buffer,voicesize);
    end;

    Close(F);
  end

  else
    writeln('Create ',filename,' error.');

end;


{ ------------------------------------------------------------------------ }

{ Voice recording }
procedure record_voice(filename: string);
var
  voice_buffer : pointer;
  buffer_size, tmp : longint;
  temp : word;

begin

  buffer_size := $20000;
  temp := word((buffer_size+15) shr 4);

  { allocate memory }
  if allocate_mem(temp) then begin
    tmp := longint(temp);
    tmp := tmp shl 16;
    voice_buffer := pointer(tmp);

    if recording(voice_buffer,buffer_size) then
        save_voice_file(filename,voice_buffer);

    dos_free_mem(voice_buffer);
  end;

end;


{ ------------------------------------------------------------------------ }

{ load CT-VOICE.DRV into memory }
function load_drv : boolean;
type
  PtrRec = record
    lo, hi : word
  end;

var
  handle, temp : word;
  file_size : longint;
  fp : pointer;
  Regs : Registers;
  F : file;
  driver_file : string;
  drv_info : SearchRec;

begin
  _voice_drv := Longint(0);
  load_drv := False;

  driver_file := GetEnv('SOUND');

  { search SOUND environment for CT-VOICE.DRV }
  if driver_file <> '' then begin

    driver_file := driver_file + '\DRV\CT-VOICE.DRV';
    FindFirst(driver_file,Archive,drv_info);

  end;

  { not found, search current directory for CT-VOICE.DRV }
  if DosError <> 0 then begin

    driver_file := 'CT-VOICE.DRV';
    FindFirst(driver_file,Archive,drv_info);

  end;

  if DosError = 0 then begin
    {$I-}
    Assign(F, driver_file);
    Reset(F,1);
    {$I+}

    if IOResult = 0 then begin
      file_size := FileSize(F);
      temp := word((file_size+15) shr 4);

      { allocate memory }
      if allocate_mem(temp) then begin
        file_size := longint(temp);
        file_size := file_size shl 16;
        _voice_drv := file_size;

        fp := pointer(_voice_drv);
        load_drv := True;
        handle := 0;

        repeat

          BlockRead(F,fp^,$8000,temp);
          handle := handle + temp;

          if not Boolean(Hi(handle)) then
            fp := pointer( longint(PtrRec(fp).hi + $1000) shl 16 )
          else
            fp := pointer( longint(fp) + longint(handle) );

        until temp <> $8000;
      end;

      close(F);
    end

    else
      writeln('Could not open CT-VOICE.DRV ...');
  end

  else
    writeln('Driver file does not exist ...');

end;


{ ------------------------------------------------------------------------ }

{ main function }
begin  { program body }

  _ct_io_addx := $220;

  if boolean( sbc_check_card and $0004 ) then begin

    if boolean(sbc_scan_int) then begin

      if load_drv then begin

        if ctvm_init = 0 then begin

          ctvm_speaker(0);

          record_voice('TEMP.VOC');

          ctvm_terminate;

        end;

      end;

    end;

  end

  else
      writeln('Sound Blaster Card not found.');

end.

