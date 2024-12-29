#include  <sbc.h>
#include  <sbcvoice.h>

#include  <dos.h>
#include  <bios.h>
#include  <stdio.h>
#include  <fcntl.h>


save_voice_file(char *,char far *) ;


main()
{
	  /*   set io address as factory default   */

     ct_io_addx = 0x220 ;

     if (sbc_check_card() & 4)
     {
	  if (sbc_scan_int())
	  {
	       if (!ctvm_init())
	       {
		    ctvm_speaker(0) ;

		    record_voice("TEMP.VOC") ;

		    ctvm_terminate() ;
	       }
	  }
     }
     else
	  printf("Sound Blaster card not found.\n") ;

}


/*------------------------------------------------------------------------*/


record_voice(char *filename)
{
	int	  temp ;
	char	  far *voice_buffer ;
	long	  buffer_size = 0x20000L;

     if (!_dos_allocmem((int)((buffer_size+15)>>4),&temp))
     {
	  FP_SEG(voice_buffer) = temp ;
	  FP_OFF(voice_buffer) = 0 ;

	  if (recording(voice_buffer,buffer_size))
	       save_voice_file(filename,voice_buffer) ;

	  _dos_freemem(FP_SEG(voice_buffer)) ;
     }
}


/*------------------------------------------------------------------------*/


#pragma loop_opt(off)

recording(char far*buffer,long buffer_size)
{
	int    ret_val = 0 ;

     ctvm_speaker(0) ;

     if (ctvm_input(buffer,buffer_size,8000) == NO_ERROR)
     {

	  ret_val = 1 ;

	  while (ct_voice_status)
	  {
	       if (_bios_keybrd(_KEYBRD_READY))
	       {
			 /*  check for escape key  */

		    if (_bios_keybrd(_KEYBRD_READ) == 0x11b)
			 ctvm_stop() ;
	       }
	  }
     }

     return(ret_val) ;
}

#pragma loop_opt(on)


/*------------------------------------------------------------------------*/


save_voice_file(char *filename,char far *buffer)
{
	int	    handle ;
	long	    voicesize ;
	VOCHDR	    header ;

     strcpy(header.id,"Creative Voice File\x01A") ;
     header.voice_offset = sizeof(VOCHDR) ;
     header.version = 0x10a ;
     header.check_code = ~header.version + 0x1234 ;


     if (_dos_creat(filename,_A_NORMAL,&handle))
	  printf("Create %s error.\n",filename) ;
     else
     {
	  if (write_file(handle,(char far*)&header,(long)sizeof(VOCHDR)))
	  {

		    /*	get the recorded data block size  */

	       voicesize = *(buffer+3) ;
	       voicesize <<= 16 ;
	       voicesize += *(unsigned far *)(buffer+1) ;

		    /*	include the block type, block length  */
		    /*	and terminator block type	      */

	       voicesize += 5 ;

	       write_file(handle,buffer,voicesize) ;
	  }

	  _dos_close(handle) ;
     }
}


/*------------------------------------------------------------------------*/

#pragma loop_opt(off)

write_file(int handle,char far *buffer,long size)
{
	int	    ret_val = 1 ;
	unsigned    byte_to_write, byte_written ;

     while (size)
     {
	  byte_to_write = 0x8000 ;

	  if (size < 0x8000)
	       byte_to_write = (int)size ;

	  if (_dos_write(handle,buffer,byte_to_write,&byte_written))
	  {
	       printf("Write file error.\n") ;
	       ret_val = 0 ;
	       break ;
	  }
	  else
	  {
	       if (byte_written != byte_to_write)
	       {
		    printf("Disk full.\n") ;
		    ret_val = 0 ;
		    break ;
	       }
	       else
	       {
		    if (FP_OFF(buffer) < 0x8000)
			 FP_OFF(buffer) += byte_written ;
		    else
		    {
			 FP_OFF(buffer) += byte_written ;
			 FP_SEG(buffer) += 0x1000 ;
		    }

		    size -= byte_written ;
	       }
	  }
     }
     return(ret_val) ;
}
#pragma loop_opt(on)
