#include <dos.h>
#include <sbc.h>
#include <bios.h>
#include <sbcvoice.h>
#include <stdio.h>
#include <fcntl.h>

main ( )
{
     /* Set port I/O address to 220h */

     ct_io_addx = 0x220 ;

     if ( sbc_check_card() & 4 )
     {
	  if ( sbc_scan_int () )
	  {
	       if ( !ctvd_init(16) )
	       {
		   output_file ("DEMO.VOC") ;

		   ctvd_terminate () ;
	       }
	       else
		    show_error () ;
	  }
	  else
	       printf ( "Interrupt error\n" ) ;
     }
     else
	  printf ( "Sound Blaster card not found\n" ) ;
}


/* ------------------------------------------------------------ */


output_file ( char *filename )
{
    int 	handle ;

    /* Open and play the voice file */

    if ( !_dos_open(filename, O_RDONLY, &handle) )
    {
	ctvd_speaker ( 1 ) ;

	if ( ctvd_output(handle) == NO_ERROR )
	{
	   play_voice_in_bkgnd () ;

	   if ( ctvd_drv_error () )
		show_error () ;
	   else
		printf ("Voice output ended.\n") ;
	}
	else
	       show_error () ;

	_dos_close (handle) ;
    }
    else
	printf ( "Open %s file error\n", filename ) ;
}
/* --------------------------------------------------------------- */

#pragma loop_opt(off)	/* turn off loop optimiaztion */

play_voice_in_bkgnd ()
{
 unsigned key ;

     /* Polls for hot key while playing voice file */

     while ( ct_voice_status )
     {
	if ( _bios_keybrd ( _KEYBRD_READY ) )
	{
	    switch ( (key = _bios_keybrd(_KEYBRD_READ) & 0xff) )
	    {
		case 0x1b : ctvd_stop () ;
			    printf ("Voice stopped.\n") ;
			    break ;

		case ' ' : ctvd_pause () ;
			   printf ( "Pause...\n"
				    "Pressed any key to continue.\n" );
			   _bios_keybrd(_KEYBRD_READ) ;
			   ctvd_continue () ;
			   break ;

		case 0x0d : ctvd_break_loop(1) ;
			    printf( "Break-out takes place immediately\n") ;
			    break ;

		case 0x9  : ctvd_break_loop(0) ;
			    printf( "Break-out takes place after the current"
				    " loop finishes\n" ) ;
			    break ;
	    }
	}
     }
}

#pragma loop_opt(on)   /* turn on the optimization again */

/* ---------------------------------------------------------------- */

show_error ()
{
  int	  err ;

     /* Show the driver error and the DOS extended error code */

     err = ctvd_drv_error () ;

     printf( "Driver error = %2d\n", err ) ;

     if ( err != 6 && err != 2 )
	  printf ( "DOS error = %2d\n", ctvd_ext_error () ) ;
}

