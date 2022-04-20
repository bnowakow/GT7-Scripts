__enableRemotePlaySizer_mod__ := 0

; For when you change the size of remote play
; Necessary because multiple scripts have different settings for the checks

GoTo EndRemotePlaySizerDef

RemotePlay_ChangeSize:


    if (__enableRemotePlaySizer_mod__ = 0){
      return
    }

    remote_play_offsetY := 71

    return


EndRemotePlaySizerDef:
