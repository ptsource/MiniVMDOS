Creative Sound Blaster SDK

This  file  contains important  and  latest information  of SBK
version 2.00.


1. Programming languages supported


SBK version 2.00 supports the following programming languages :

        -  Assembly language
        -  Microsoft C version 5.0, 6.0
        -  Turbo C version 2.0
        -  Microsoft QuickBasic version 4.5
        -  Microsoft Basic PDS version 7.0
        -  Turbo Pascal version 6.0



2. MIDI Interface


SBK version 2.00 provides the low-level MIDI interface  functions to
facilitate programming using Sound Blaster MIDI interface.

To  use  these functions,  you  have to include one of the following
Include files :

        SBMIDI.H        for C
        SBMIDI.BI       for BASIC

You  must take  special care to avoid calling the FM  Music and MIDI
functions simultaneously as they are using the same system timer for
timing.



3. Corrections to SBK Manual


   Page 1-4 :  MIDI Sub-directory
 
      The examples for MIDI I/O are in the sub-directory \MIDI under
      the  directories  \QBASIC,  \MSC  and  \TPASCAL  which is  not
      available on the manual at printing time.

      The directories \QBASIC, \MSC and \TPASCAL consist of the sub-
      directories as below :

      For \QBASIC and \MSC :

        \INCLUDE        :  include files
        \LIB            :  libraries
        \VOICE          :  examples for voice I/O
        \MUSIC          :  examples for FM music
        \SPEECH         :  examples for Text-to-Speech
        \MIDI           :  examples for MIDI I/O

      For \TPASCAL :

        \UNIT           :  include files and TPU
        \VOICE          :  examples for voice I/O
        \MUSIC          :  examples for FM music
        \SPEECH         :  examples for Text-to-Speech
        \MIDI           :  examples for MIDI I/O



   Page 1-7 :  Use of the SBC C Object Libraries
 
      The SBC C libraries are organized into sub-directories of \LIB
      as follows :

        \LIB
            \ALONE      :  libraries for External drivers
            \EMBED      :  libraries for Embedded drivers



   Page 1-15 :  How to use this Manual
 
      The correct description of Chapter 6 should be as follow :

      Chapter 6        describes the  MIDI Interface functions.  You
                       should  read  this if  your program  sends or
                       receives MIDI codes.



   Page 3-114 :  Turbo Pascal Example 2
 
      The  correct  name for  this  program  should  be  DEMOVDR.PAS
      instead of DEMOVDR.C.



   Page 6-21 :  Basic Example 2
 
      The correct statement of the program description is as follow :

      This program  calls the MIDI Low  Level Interface functions to
      display the data from MIDI synthesizer keyboard.

