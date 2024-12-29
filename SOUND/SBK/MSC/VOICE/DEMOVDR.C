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
		   record_file ("TEMP.VOC") ;

		   ctvd_terminate () ;
	       }
	       else
		    show_error () ;
	  }
	  else
	       printf ( "Interrupt Error\n" ) ;
     }
     else
	  printf ( "Sound Blaster card not found\n" ) ;

}
/* ------------------------------------------------------------ */

record_file ( char *filename )
{
    int 	handle ;

    /* create and record a voice file */

    if ( !_dos_creat(filename, _A_NORMAL, &handle) )
    {
	ctvd_speaker ( 0 ) ;

	if ( ctvd_input(handle, 8000) == NO_ERROR )
	{
	   record_until_stopped () ;

	   if ( ctvd_drv_error () )
		show_error () ;
	   else
		printf ("Voice record ended.\n") ;
	}
	else
	       show_error () ;

	_dos_close (handle) ;
    }
    else
	printf ( "Create %s file error\n", filename ) ;
}
/* ------------------------------------------------------------ */

#pragma loop_opt(off)	/* turn off loop optimiaztion */

record_until_stopped ()
{
 unsigned key ;

     /* Polls for hot key while playing voice file */

     while ( ct_voice_status )
     {
	if ( _bios_keybrd ( _KEYBRD_READY ) )
	{
	    /* check for [ESC] key */

	    if ( (key = _bios_keybrd(_KEYBRD_READ) & 0xff) == 0x1b )
		  ctvd_stop () ;
	}
     }

     printf ("Voice stopped.\n") ;
}

#pragma loop_opt(on)

/* ------------------------------------------------------------------- */

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
