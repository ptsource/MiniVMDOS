type
{ VOC file header }
  VOCHDR        = record
    id              : array[0..19] of char; { VOC file ID                   }
    voice_offset    : word;                 { offset of voice block         }
    version         : word;                 { version                       }
    check_code      : word;                 { verifier                      }
  end;
