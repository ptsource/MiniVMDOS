/* ----------------------------------------------------------------
 *   This program plays a 'C major scale' by programming DSP and
 *   send the MIDI commands to MIDI keyboard.
 * ----------------------------------------------------------------*/

#include <stdio.h>
#include <sbc.h>
#include <sbmidi.h>


/* Look up table for MIDI value of a 'scale' starts from 'middle C' */

unsigned char  note_num[] = { 60, 62, 64, 65, 67, 69, 71, 72 } ;



#pragma loop_opt(off)
main ()
{
     unsigned int   i, j, note;
     unsigned char  pnum;



     /* Set I/O address to 220H */

     ct_io_addx = 0x220;

     if ( sbc_check_card () & 4 )
     {
        if ( sbc_scan_int() )
        {
            for ( pnum= 0; pnum < 5; pnum++ )
            {
                /* program change command */

                sbmidi_out_shortmsg( 0xC0, pnum, 0 );


                /* play the Middle C scale */

                for ( note=0; note < 8; note++ )
                {
                    /* Note On command */

                    sbmidi_out_shortmsg( 0x90, note_num[note], 0x40 );


                    /* delay loop */

                    for (i=0; i<100; i++)
                    {
                        for (j=0; j < 1000; j++);
                    }

                    /* Note Off command */

                    sbmidi_out_shortmsg( 0x80, note_num[note], 0x40 );
                }
            }
        }
        else
            printf("Interrupt Error.\n");
     }
     else
        printf("Sound Blaster not available or wrong I/O address setting\n");
}
#pragma loop_opt(on)

