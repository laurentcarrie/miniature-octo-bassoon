module Log = Dolog.Log

let () =
  let () = Printexc.record_backtrace true in
  try
    Log.set_log_level Log.INFO;
    Log.set_output stdout;
    Log.color_on ();
    let _ = Log.info "begin work " in

    let trk_filename = Array.get Sys.argv 1 in
    let trk = Yaml_of_trkbin.Reader.model_of_gpx trk_filename in
    let () = Yaml_of_trkbin.Mp.write_mp_file_segs trk in
    let () = Yaml_of_trkbin.Mp.write_mp_wpts trk in
    ()
  with e ->
    let msg = Printexc.to_string e and stack = Printexc.get_backtrace () in
    Printf.eprintf "there was an error: %s%s\n" msg stack;
    Stdlib.exit 1
