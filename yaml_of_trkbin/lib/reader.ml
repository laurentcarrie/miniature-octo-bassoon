module Log = Dolog.Log



let _ =
Log.info "unused"

let trk_trkfile trk_filename =
    let _ = In_channel.open_bin trk_filename in
    let _ : Model.trk = {
            title="hello";
             }





             in
        ()



let model_of_gpx gpx_filename =
    let x = Xml.parse_file gpx_filename in
    let _ = x in
    let trk : Model.trk = {
        title="hello"
    } in
    trk

