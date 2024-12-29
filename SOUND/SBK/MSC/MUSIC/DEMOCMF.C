#include  <io.h>
#include  <dos.h>
#include  <bios.h>
#include  <fcntl.h>
#include  <sbcmusic.h>

	char	    far  *music_buffer = 0 ;
	char	    transpose = 0 ;

main(int argc,char *argv[])
{
	int    version ;

     if (sbfm_init())
     {
	  version = sbfm_version() ;

	  printf("Driver version %d.%02d\n",version >> 8,version & 255) ;

	  play_cmf_file("FFARES.CMF") ;

	  sbfm_terminate() ;
     }
     else
	  printf("SBFMDRV not installed or FM Driver initialization error.\n") ;
}


play_cmf_file(char *filename)
{
     if (load_file(filename))
     {
	  start_music() ;
	  wait_music_end() ;
     }
}


load_file(char *filename)
{
	int	    handle ;
	int	    temp ;
	int	    ret_val = 0 ;
	long	    file_size ;
	char	    far *fp ;

     if (!_dos_open(filename,O_RDONLY,&handle))
     {
	  file_size = filelength(handle) ;

	  if (!_dos_allocmem((int)((file_size+15) >> 4),&temp))
	  {
	       FP_SEG(music_buffer) = temp ;
	       FP_OFF(music_buffer) = 0 ;

	       fp = music_buffer ;

	       ret_val = 1 ;

	       do
	       {
		    if (!_dos_read(handle,fp,0x8000,&temp))
		    {
			 if ( !(FP_OFF(fp) += temp) )
			      FP_SEG(fp) += 0x1000 ;
		    }
		    else
		    {
			 ret_val = 0 ;
			 printf("Load file error.\n") ;
		    }

	       } while (temp == 0x8000) ;
	  }

	  _dos_close(handle) ;
     }
     else
	  printf("Error in openning %s.",filename) ;

     return(ret_val) ;
}



start_music()
{
	char	    far *inst_ptr ;
	char	    far *music_ptr ;

	int	    timer0_frequency ;

	  /*  get instrument block and music block address  */

     inst_ptr = music_buffer + *(int far*)(music_buffer + 6) ;
     music_ptr = music_buffer + *(int far*)(music_buffer + 8) ;

     sbfm_reset() ;

	  /*  set song speed */

     timer0_frequency = (int)(1193180L / (*(int far*)(music_buffer + 12))) ;
     sbfm_song_speed(timer0_frequency) ;

	  /*  set instrument table */

     if (FP_OFF(inst_ptr))
	  sbfm_instrument(inst_ptr,*(music_buffer+0x24)) ;

     sbfm_play_music(music_ptr) ;
}


#pragma loop_opt(off)

wait_music_end()
{
	unsigned	 key ;

     while(key = sbfm_read_status())
     {
	  if (key != 255)
	       printf("Status: %c - %d\n",key,key) ;

	  if (_bios_keybrd(_KEYBRD_READY))
	  {

	       if ((key=_bios_keybrd(_KEYBRD_READ)) & 0xff)
		    key = toupper(key & 255) ;

	       switch(key)
	       {
		    case 0x1b : sbfm_stop_music() ;
				 break ;
		    case 0x4b00: sbfm_transpose(--transpose) ;
				 printf("Transpose: %d\n",transpose) ;
				 break ;
		    case 0x4d00: sbfm_transpose(++transpose) ;
				 printf("Transpose: %d\n",transpose) ;
				 break ;
		    case 'P'   : sbfm_pause_music() ;
				 break ;
		    case 'C'   : sbfm_resume_music() ;
				 break ;
	       }
	  }
     }
}
#pragma loop_opt(on)
