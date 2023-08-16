module Log = Dolog.Log



let _ =
Log.info "unused"

let trk_trkfile trk_filename =
    let _ = In_channel.open_bin trk_filename in
    let _ : Model.trk = {
            title="hello";
             }in
        ()
