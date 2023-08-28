module Log = Dolog.Log

let work project =
  let () = Log.info "gpx : %s" project.Model.gpx_file in
  let gpx = Reader.model_of_gpx project.Model.gpx_file in
  let () = Mp.write_mp_file_segs gpx in
  let () = Mp.write_mp_wpts gpx in
  let () = Mp.write_mp_infos project in
  let () = Main_tex.write_tex_file project in
  ()
