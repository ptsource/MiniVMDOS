#include  <sbcts.h>

main()
{
     if (sbts_init())
     {
	  printf("SBTALKER installed.\n\n") ;
	  sbts_say("SB-talker installed.") ;

	  printf("Press a key to continue...") ;
	  getch() ;

	  sbts_settings(0,0,9,5,5) ;
	  printf("I can speak louder.\n") ;
	  sbts_say("I can speak louder.") ;

	  printf("Press a key to continue...") ;
	  getch() ;

	  sbts_settings(0,0,9,9,5) ;
	  printf("I can change my pitch.\n") ;
	  sbts_say("I can change my ptich.") ;

	  printf("Press a key to continue...") ;
	  getch() ;

	  sbts_settings(0,0,9,9,9) ;
	  printf("I can speak very fast.\n\n") ;
	  sbts_say("I can speak very fast.") ;

     }
     else
	  printf("SBTALKER not installed.\n") ;
}
