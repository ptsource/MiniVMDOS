#include  <sbc.h>
#include  <sbcvoice.h>

#include  <io.h>
#include  <dos.h>
#include  <bios.h>
#include  <stdio.h>
#include  <fcntl.h>
#include  <string.h>
#include  <stdlib.h>

char far *load_voice_file(char *filename) ;


main()
{
	char	  far *voice_buffer ;

	  /*   set io address as factory default   */

     ct_io_addx = 0x220 ;

     if (sbc_check_card() & 4)
     {
	  if (sbc_scan_int())
	  {

#ifdef ALONE
	       if (load_drv())
	       {
#endif
		    if (!ctvm_init())
		    {

			 ctvm_speaker(0) ;

			 if (voice_buffer = load_voice_file("DEMO.VOC"))
			 {
			      output_voice(voice_buffer) ;
			      _dos_freemem(FP_SEG(voice_buffer)) ;
			 }

			 ctvm_terminate() ;
		    }
#ifdef ALONE
	       }
#endif
	  }
     }
     else
	  printf("Sound Blaster card not found.\n") ;

}


/*------------------------------------------------------------------------*/

#pragma loop_opt(off)

char far*load_voice_file(char *filename)
{
	int	    handle ;
	int	    byte_read ;
	long	    filesize ;
	char	    far *retptr, far *fp ;

	  /*   open voice file	 */

     if (!_dos_open(filename,O_RDONLY,&handle))
     {
	  filesize = filelength(handle) ;

	  if (!_dos_allocmem((int)((filesize+15) >> 4),&byte_read))
	  {
	       FP_SEG(retptr) = byte_read ;
	       FP_OFF(retptr) = 0 ;

	       fp = retptr ;

	       do
	       {
		    if (!_dos_read(handle,fp,0x8000,&byte_read))
		    {
			 if ( !(FP_OFF(fp) += byte_read) )
			      FP_SEG(fp) += 0x1000 ;
		    }
		    else
		    {
			 byte_read = 0 ;
			 _dos_freemem(FP_SEG(retptr)) ;
			 retptr = 0 ;
		    }

	       } while (byte_read == 0x8000) ;
	  }

	  _dos_close(handle) ;
     }
     else
	  printf("Open %s fails.\n",filename) ;

     return(retptr) ;
}

#pragma loop_opt(on)


/*------------------------------------------------------------------------*/


#pragma loop_opt (off)

output_voice(char far *buffer)
{
	unsigned    key ;

     buffer += ((VOCHDR far *)buffer)->voice_offset ;

     ctvm_speaker(1) ;

     if (ctvm_output(buffer) == NO_ERROR)
     {

	  while (ct_voice_status)
	  {
	       if (_bios_keybrd(_KEYBRD_READY))
	       {
		    if (key = _bios_keybrd(_KEYBRD_READ))
		    {
			 switch(toupper(key & 0xff))
			 {
			      case 'S' : ctvm_stop() ;
					 break ;
			      case 'P' : ctvm_pause() ;
					 break ;
			      case 'C' : ctvm_continue() ;
					 break ;
			      case 'B' : ctvm_break_loop(1) ;
					 break ;
			 }
		    }
	       }
	  }
     }

     ctvm_speaker(0) ;
}

#pragma loop_opt(on)


#ifdef ALONE

load_drv()
{
	extern char	 far * near voice_drv ;
	char		 far *fp ;

	char		 driver_file[100] ;
	char		 *p ;

	int		 ret_val = 0 ;
	int		 handle = 1 ;
	int		 temp ;
	long		 drvsize ;

	struct find_t	 file ;

     voice_drv = 0 ;

	  /*  locate driver through environment parameter  */

     if (p=getenv("SOUND"))
     {
	  strcat(strcpy(driver_file,p),"\\DRV\\CT-VOICE.DRV") ;

	       /*  handle set to 0, if found  */

	  handle = _dos_findfirst(driver_file,_A_NORMAL,&file) ;
     }

	  /*  locate driver in current directory */

     if (handle)
     {
	  strcpy(driver_file,"CT-VOICE.DRV") ;

	       /*  handle set to 0, if found  */

	  handle = _dos_findfirst(driver_file,_A_NORMAL,&file) ;
     }

     if (handle)
	  printf("Driver file does not exist.\n") ;
     else
     {
	  if (_dos_open(driver_file,O_RDONLY,&handle))
	       printf("Open %s error.\n",driver_file) ;
	  else
	  {
	       drvsize = filelength(handle) ;

	       if (!_dos_allocmem((unsigned)((drvsize + 15) >> 4),&temp))
	       {
		    FP_SEG(voice_drv) = temp ;
		    FP_OFF(voice_drv) = 0 ;

		    if (_dos_read(handle,voice_drv,(unsigned)drvsize,&temp))
		    {
			 _dos_freemem(FP_SEG(voice_drv)) ;
			 voice_drv = 0 ;
		    }
		    else
			 ret_val = 1 ;
	       }

	       _dos_close(handle) ;
	  }
     }

     return(ret_val) ;
}

#endif
