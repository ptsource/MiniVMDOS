program demofm;

{ Set up memory limits, for a 16K stack and a 64K heap }
{$M 16384,0,65535}

{ Include the SBC Unit, and any other units needed }
uses sbc_tp6, dos, crt;

const
  { instrument table }
  inst : array[0..9] of array[0..15] of byte =
                ( ( $21,$11,$4c,$00,$f1,$f2,$63,$72,
                    $00,$00,$04,$00,$00,$00,$00,$00 ),

                  ( $a5,$b1,$d2,$80,$81,$f1,$03,$05,
                    $00,$00,$02,$00,$00,$00,$00,$00 ),

                  ( $71,$62,$1c,$05,$51,$52,$03,$13,
                    $00,$00,$0e,$00,$00,$00,$00,$00 ),

                  ( $11,$01,$8a,$40,$f1,$f1,$11,$b3,
                    $00,$00,$06,$00,$00,$00,$00,$00 ),

                  ( $21,$11,$11,$00,$a3,$c4,$43,$22,
                    $02,$00,$0d,$00,$00,$00,$00,$00 ),

                  ( $31,$a1,$1c,$80,$41,$92,$0b,$3b,
                    $00,$00,$0e,$00,$00,$00,$00,$00 ),

                  ( $71,$62,$c5,$05,$6e,$8b,$17,$0e,
                    $00,$00,$02,$00,$00,$00,$00,$00 ),

                  ( $41,$91,$83,$00,$65,$32,$05,$74,
                    $00,$00,$0a,$00,$00,$00,$00,$00 ),

                  ( $32,$16,$87,$80,$a1,$7d,$10,$33,
                    $00,$00,$08,$00,$00,$00,$00,$00 ),

                  ( $01,$13,$8d,$00,$51,$52,$53,$7c,
                    $01,$00,$0c,$00,$00,$00,$00,$00 ) );


{ ------------------------------------------------------------------------ }

procedure play_scale;
const
  { look up table starting for a scale starting from 'Middle C' }
  note_num : array[0..7] of byte = ( 60,62,64,65,67,69,71,72 );

var
  i,j : word;
  instrument, note : byte;

begin

  for instrument := 0 to 9 do begin
    sbfd_program_change(0,instrument);

    for note := 0 to 7 do begin
      sbfd_note_on(0,note_num[note],$40);

      for i := 0 to 150 do
        for j := 0 to 1000 do begin
        end;

      sbfd_note_off(0,note_num[note],$40);
    end;

  end;

end;


{ ------------------------------------------------------------------------ }

{ main function }
begin

  { set I/O addx to $220 }
  _ct_io_addx := $220;

  if boolean( sbc_check_card and $0002 ) then begin

    sbfd_init;
    sbfd_instrument(@inst);
    play_scale;
    sbfd_reset;

  end

  else
    writeln('Sound Blaster not available or wrong I/O address setting');

end.
