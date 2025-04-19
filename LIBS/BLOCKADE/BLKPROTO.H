

#ifndef Blk_Protos_Loaded
#define Blk_Protos_Loaded

/* -------- blkade.c -------- */

int blockade( char *filename, size_t bufsize);
int calc_crc_file( char *filename, long offset, size_t bufsize, long *crcptr);
long blk_fsize( FILE *);

/* ------ chkblk.c  ------ */

unsigned long chkblk(char *buffer, int size, unsigned long init);

/* ------ blkade1.c  ------ */

char *get_blk_err_msg( int );

/* ------ blkade2.c  ------ */

unsigned long chksum8( char *, int , unsigned long);

/* ------ blkade3.c  ------ */ 

unsigned long chksum32( char *, int , unsigned long);

/* ------ blkade4.c  ------ */ 

unsigned long crc32(char *buffer, int size, unsigned long init);
int showcrc( long crc);

/* ------    end     ------ */
#endif

