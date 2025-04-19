
/*---------------------------------------------------------------------*/
/*   Contains messages corresponding to the error codes returned       */
/*   by blockade() & calc_crc_file().                                  */
/*                                                                     */
/*   Returns a read only pointer to the appropriate message.           */
/*                                                                     */
/*                                                                     */
/*---------------------------------------------------------------------*/

char * get_blk_err_msg(int num)
{
  char *sp;
  static char *blk_err_msgs[] = {
    "No error",                          /*  0  */
    "No memory for buffer",              /*  1  */
    "Error opening file",                /*  2  */
    "No memory for file buffering",
    "File buffering failure",            /*  4  */
    "Fseek error",
    "Error reading data block",          /*  6  */
    "Invalid data block info",
    "Error reading file",                /*  8  */
    "Error reading file",                /*  9  */
    "Error reading file",                /* 10  */
    "Check Value error",                 /* 11  */
    "File size error",                   /* 12  */
    "Invalid error number" };            /* 13  */

   if (num == -1) num = 11;
   if (num == -2) num = 12;
   if ((num < 0) || (num > 12))  num = 13;    /* out of range */
   sp = blk_err_msgs[num];
   return(sp);
  }

/*---------------------------------------------------------------------*/
