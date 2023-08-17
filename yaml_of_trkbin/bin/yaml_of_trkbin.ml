module Log = Dolog.Log

let () =
  let () = Printexc.record_backtrace true in
  try
    Log.set_log_level Log.INFO;
    Log.set_output stdout;
    Log.color_on ();
    let _ = Log.info "begin work " in

    let trk_filename = Array.get Sys.argv 1 in
    let mp_filename = Array.get Sys.argv 2 in
    let width = Float.of_string (Array.get Sys.argv 3) in
    let height = Float.of_string (Array.get Sys.argv 4) in
    let x0 = Float.of_string (Array.get Sys.argv 5) in
    let y0 = Float.of_string (Array.get Sys.argv 6) in
    let ratio = Float.of_string (Array.get Sys.argv 7) in

    let _ = Log.info "%s" trk_filename in
    let trk = Yaml_of_trkbin.Reader.model_of_gpx trk_filename in
    (*    let data = Yaml_of_trkbin.Model.serialize x in *)
    (*    let _ = Log.info "%s" data in *)
    let _ =
      Yaml_of_trkbin.Mp.write_mp_file trk mp_filename width height x0 y0 ratio
    in
    ()
  with e ->
    let msg = Printexc.to_string e and stack = Printexc.get_backtrace () in
    Printf.eprintf "there was an error: %s%s\n" msg stack;
    Stdlib.exit 1
