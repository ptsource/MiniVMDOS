#define  SIG_AR_SIZE  16

unsigned char sig_array[SIG_AR_SIZE] = { 
'c','h','k','_','s','i','g','n','a','t','u','r','e',  /* the signature */ 
   0,   0,  16    /*--- 13 ---*/
 }; 

unsigned long (*blkfunc)( char *, int, unsigned long) =  chksum32 ; 
