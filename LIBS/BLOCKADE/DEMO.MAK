compile=CL /AS /W3 /Od  $*.C /c
#
demo.obj : demo.c  
        $(compile)

demo.exe : demo.obj  
 link demo,demo.exe,demo.map, blkdmoms.lib  ;
#              MSC uses the DEMO patch area... need to clear it w/ /O

# end of make file...




