program democmf;

{ Set up memory limits, for a 16K stack and a 64K heap.
  Note that this is necessary because the program is
  using DOS to allocate memory.  Otherwise, the heap
  will occupy the remaining memory and causes allocate_mem
  function returns False. }

{$M 16384,0,65535}

{ Include the SBC Unit, and any other units needed }
uses sbc_tp6, dos, crt;

{ Include type-defined for CMF header }
{$I sbcmusic.inc }

var
  transpose : Integer;
  music_buffer : pointer;


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

{ load a file into memory and use music_buffer to point to it }
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
      music_buffer := pointer(file_size);

      fp := music_buffer;
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

procedure start_music;
var
  temp : longint;
  inst_ptr, music_ptr : pointer;
  timer0_frequency : word;

begin

  temp := longint(music_buffer) + longint((CMFHDR(music_buffer^)).inst_blk);
  inst_ptr := pointer(temp);

  temp := longint(music_buffer) + longint((CMFHDR(music_buffer^)).music_blk);
  music_ptr := pointer(temp);

  sbfm_reset;

  timer0_frequency := word(longint(1193180) div (CMFHDR(music_buffer^)).clock_ticks);
  sbfm_song_speed(timer0_frequency);

  if boolean(Ofs(inst_ptr)) then
    sbfm_instrument(inst_ptr,(CMFHDR(music_buffer^)).inst_num);

  sbfm_play_music(music_ptr);

end;


{ ------------------------------------------------------------------------ }

procedure wait_music_end;
const
  ESC            = 27;
  up_P           = 80;
  lo_p           = 112;
  up_C           = 67;
  lo_c           = 99;

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
            sbfm_stop_music;

          LEFTARROW :
            begin
              transpose := transpose - 1;
              sbfm_transpose(transpose);
              writeln('Transpose : ',transpose);
            end;

          RIGHTARROW :
            begin
              transpose := transpose + 1;
              sbfm_transpose(transpose);
              writeln('Transpose : ',transpose);
            end;

          up_P,lo_p :
            sbfm_pause_music;

          up_C,lo_c :
            sbfm_resume_music;
        end;

      end;

    end;
  until not boolean(_ct_music_status);

end;


{ ------------------------------------------------------------------------ }

{ Play a CMF file with the filename specified }
procedure play_cmf_file(filename: string);

begin

  if load_file(filename)  then begin

    start_music;
    wait_music_end;

  end;

end;


{ ------------------------------------------------------------------------ }

{ main function }
var
  version : word;

begin

  if boolean(sbfm_init) then begin

      version := sbfm_version;
      writeln('     SBFMDRV version ',Hi(version),'.',Lo(version):2);

      play_cmf_file('FFARES.CMF');

      sbfm_terminate;
  end

  else
      writeln('FM Driver initialisation error.');
end.
