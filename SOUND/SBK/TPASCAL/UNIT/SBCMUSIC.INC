type
{ CMF file header }
  CMFHDR        = record
    id              : array[0..3] of char;  { CMF file ID                   }
    version         : integer;              { version                       }
    inst_blk        : integer;              { offset of instrument block    }
    music_blk       : integer;              { offset of music block         }
    ticks_per_beat  : integer;              { ticks per beat                }
    clock_ticks     : integer;              { clocks ticks                  }
    music_title     : integer;              { offset title of music         }
    composer_name   : integer;              { offset music composer         }
    music_remark    : integer;              { offset music remarks          }
    channel_used    : array[0..15] of char; { channel in used               }
    inst_num        : integer;              { instrument number             }
    basic_tempo     : integer;              { basic tempo of music          }
  end;
