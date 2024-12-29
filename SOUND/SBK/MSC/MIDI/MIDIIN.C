/* ----------------------------------------------------------------
 *   This program read in the MIDI code through DSP and display
 *   it on screen. The user can terminate the process by pressing
 *   ESC key.
 * ----------------------------------------------------------------*/

#include  <stdio.h>
#include  <bios.h>
#include  <sbc.h>
#include  <sbmidi.h>


main()
{
     long midi_code, time_stamp;
     unsigned char midi_byte;


     /* Set I/O address to 220H */

     ct_io_addx = 0x220 ;

     if ( sbc_check_card() & 4 )
     {
        if ( sbc_scan_int() )
        {
            /* Start input */

            sbmidi_start_input();


            while ( 1 )
            {
                /*  Check for ESC key  */

                if ( _bios_keybrd(_KEYBRD_READY) )
                    if (_bios_keybrd(_KEYBRD_READ) == 0x11b)
                        break;


                /*  Read the MIDI input from buffer */

                if ( midi_code = sbmidi_get_input() )
                {

                    midi_byte = (unsigned char)(midi_code & 0x000000ff);
                    time_stamp = midi_code >> 8;

                    printf("\nMIDI Byte : %02x hex    Time Stamp : %8lu msec",
                            midi_byte, time_stamp);
                }
            }


            /* Stop input */

            sbmidi_stop_input();


            /* read the remaining codes in the buffer */

            while ( midi_code = sbmidi_get_input() )
            {
                midi_byte = (unsigned char)(midi_code & 0x000000ff);
                time_stamp = midi_code >> 8;

                printf("\nMIDI Byte : %02x hex    Time Stamp : %8lu msec",
                        midi_byte, time_stamp);
            }
        }
        else
            printf("Interrupt Error.\n") ;
     }
     else
        printf("Sound Blaster not available or wrong I/O address setting\n");
}

