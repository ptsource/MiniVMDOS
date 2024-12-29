program demovmp;

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

var
  voice_buffer : pointer;


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

{ load a file into memory }
function load_file(filename : string) : Boolean;
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

begin
  {$I-}
  Assign(F, filename);
  Reset(F,1);
  {$I+}

  load_file := False;

  if IOResult = 0 then begin
    file_size := FileSize(F);
    temp := word((file_size+15) shr 4);

    { allocate memory }
    if allocate_mem(temp) then begin
      file_size := longint(temp);
      file_size := file_size shl 16;
      voice_buffer := pointer(file_size);

      fp := voice_buffer;
      load_file := True;
      handle := 0;

      repeat

        BlockRead(F,fp^,$8000,temp);
        handle := handle + temp;

        if not Boolean(Hi(handle)) then
          fp := pointer( longint(PtrRec(fp).hi + $1000) shl 16 )
        else
          fp := pointer( longint(fp) + longint(handle) );

      until temp <> $8000;
    end

    else
      writeln('Memory allocation error ....');

    close(F);
  end


  else begin
    writeln('Open ',filename,' error ...');
  end;

end;


{ ------------------------------------------------------------------------ }

procedure output_voice;
const
  ESC            = 27;
  up_P           = 80;
  lo_p           = 112;
  up_C           = 67;
  lo_c           = 99;
  up_B           = 66;
  lo_b           = 98;
  up_S           = 83;
  lo_s           = 115;

  EXT            = 256;
  LEFTARROW      = (EXT+75);
  RIGHTARROW     = (EXT+77);

var
  key : char;
  keyval : integer;
  buf_ptr : pointer;
  temp : Longint;

begin

  temp := longint(voice_buffer) + longint((VOCHDR(voice_buffer^)).voice_offset);
  buf_ptr := pointer(temp);

  ctvm_speaker(1);

  if ctvm_output(buf_ptr) = 0 then begin
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
            up_S,lo_s :
              ctvm_stop;
            up_P,lo_p :
              ctvm_pause;
            up_C,lo_c :
              ctvm_continue;
            up_B,lo_b :
              ctvm_break_loop(1);
          end;

        end;

      end;
    until not boolean(_ct_voice_status);
  end;

  ctvm_speaker(0);
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
var
  version : word;

begin  { program body }

  _ct_io_addx := $220;

  if boolean( sbc_check_card and $0004 ) then begin

    if boolean(sbc_scan_int) then begin

      if load_drv then begin

        if ctvm_init = 0 then begin

          ctvm_speaker(0);

          version := ctvm_version;
          writeln('     CT-VOICE version ',Hi(version),'.',Lo(version):2);

          if load_file('DEMO.VOC')  then begin
            output_voice;
            dos_free_mem(voice_buffer);
          end;

          ctvm_terminate;

        end;
      end;
    end;
  end

  else
      writeln('Sound Blaster Card not found.');
end.
