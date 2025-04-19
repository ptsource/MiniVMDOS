
/* -------------------------------------------------------------- */
/*            Blockade(tm) demonstration program.                 */
/*                                                                */
/*  Demonstrates the use of the blockade self checking routines.  */
/* -------------------------------------------------------------- */

#include "allstds.h"             /* Standard stuff  */
#ifdef __TURBOC__                /* defined in BC++ */
 #pragma hdrstop
#endif

#include "blkproto.h"            /* function prototypes for the library */
#include "signatur.h"            /* holds the signature string          */

/* ------------------------------------------- */

int main( int argc,char * *argv );
void do_args( int, char **);
int patch_checksum( char *, unsigned );

/* ------------------------------------------- */

int fix_mode = 0;              /* 1 = patch to fix... */
int corrupt_mode = 0;          /* 1 = Corrupt to force error */
unsigned fix_value;            /* value to use to patch      */

#ifdef __TURBOC__
int patch_overide = 0;         /* There shouldn't be any value  */
#else
int patch_overide = 1;         /* But MSC uses the checksum area ?! */
#endif

/* ------------------------------------------- */

main(int argc,char **argv)
{
 int stat;
 char *sp;

 printf("\n");
 printf("BLOCKADE (tm) demo program (%s). \n", argv[0]);
 printf(" Switches:\n");
 printf("    /C  - corrupt myself so self check fails.\n");
 printf("    /F  - fix myself so self check passes.\n\n");

 do_args( argc, argv);

 if (fix_mode || corrupt_mode)
        { stat = patch_checksum( argv[0], fix_value);  }

 printf("Checking myself for changes..\n");

 stat = blockade( argv[0], 780);       /* the heart of the demo.. */

 printf ("Results of file self check = %d\n", stat);

 sp = get_blk_err_msg( stat);
 printf("Status message from file self check was \"%s\". \n", sp);
 if (stat == 7)
    printf("Run \"Brand DEMO\" to initialize this file and retry..\n");
 return(0);
 }

/*-------------------------------------------------------------------*/
/*  Gathers up the command line switches.                            */
/*                                                                   */
/*-------------------------------------------------------------------*/

void do_args( int argc, char **argv)
 {
   char buf[4], *sp;
   int j;

  for (j = 1; j < argc; j++)
    {
      sp = buf;
      strncpy( buf, argv[j], sizeof(buf)-1);
      strupr( buf );
      if (*sp =='-') *sp = '\\';       /* accommodate those unix guys..*/
      if (*sp =='/') sp++;             /* look to next char...         */
      else           continue;         /* nothing I know how to handle */

      if (*sp == 'F')
           {  fix_mode = 1;     fix_value = 0;  }
      if (*sp == 'C')
           {  corrupt_mode = 1; fix_value = 1;  }
      if (*sp == 'O')
           {  patch_overide = 1;
              fix_mode = 1;     fix_value = 0;  }
   }
 }

/* -------------------------------------------------------------- */

#pragma pack(1)                /* MSC only, ignored by TC/BC */

typedef struct exeheadr {       /* Structure of .EXE file header */
       unsigned char sig[2];
       unsigned mod512;
       unsigned num_pages;
       unsigned reloc_cnt;
       unsigned hdr_size;
       unsigned min_para;
       unsigned max_para;
       unsigned stack_seg;
       unsigned start_sp;
       unsigned checksum;        /* here's where we patch... */
       unsigned entry_ip;
       unsigned code_seg;
       unsigned relo_offset;
       unsigned short    ovl_num;
       unsigned short    relo_stuff[80];
       } EXEHDR;

 EXEHDR   exehdr;

/* --------------------------------------------------------------- */

int patch_checksum( char *infile, unsigned value)
{
 size_t stat, check, ok_to_patch = 1;
 FILE *fd;

 if (fix_mode)      printf("Zeroing DEMO file patch area...\n");
 if (corrupt_mode)  printf("Corrupting DEMO file...\n");

 if ((fd = fopen(infile,"r+b")) == NULL)
  {
     fprintf(stderr,"Unable to open %s .\n",infile);
     return(2);
  }

  stat = fread( (void *)&exehdr, 1, sizeof(exehdr), fd);
  if (stat != sizeof(exehdr))
      {  printf ("Error reading exe header of demo file\n");     }

  if ((exehdr.sig[0] != 'M') || (exehdr.sig[1] != 'Z'))
      {
         printf ("Error, not a valid EXE file signature.\n");
      }

  check = exehdr.checksum;
  if (check != 0 && check != 1)
    {
      printf("Warning unexpected value (%u) found in Demo patch area.\n",check);
      if (!patch_overide) ok_to_patch = 0;
    }

  if (ok_to_patch)
           exehdr.checksum = value;

  rewind(fd);
  stat = fwrite( (void *)&exehdr, 1, sizeof(exehdr), fd);
  if (stat != sizeof(exehdr))
      {  printf ("Error writing to demo file. \n");     }

  fclose(fd);
  return(0);
}

/* ------------------------------------------------------ */
