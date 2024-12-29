/*-----------------------------------------------------------------------------

     This program helps to show your Sound Blaster Developer Kit version
     number.

     To check your library version compile this program with following
     command:

	       CL /Ax sbkver.c /link SBCx
	  OR   CL /Ax sbkver.c /link SBCxR

     where 'x' can be replaced with one of following characters S, C, M
     and L.

-----------------------------------------------------------------------------*/

     extern char	 near sbclib_version_major ;
     extern char	 near sbclib_version_minor ;
     extern char	 near sbclib_edition ;

main()
{
     puts("Sound Blaster Developer Kit") ;
     puts("Microsoft C version\n") ;

     printf("Version: %d.%02d\n",sbclib_version_major,sbclib_version_minor) ;
     printf("Edition: %d\n\n",sbclib_edition) ;
}
