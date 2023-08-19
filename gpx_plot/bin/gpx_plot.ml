module Log = Dolog.Log

let () =
  let () = Printexc.record_backtrace true in
  try
    Log.set_log_level Log.INFO;
    Log.set_output stdout;
    Log.color_on ();
    let _ = Log.info "begin work " in

    let gpx_filename = Array.get Sys.argv 1 in
    let gpx = Gpx_plot.Reader.model_of_gpx gpx_filename in
    let () = Gpx_plot.Mp.write_mp_file_segs gpx in
    let () = Gpx_plot.Mp.write_mp_wpts gpx in
    ()
  with e ->
    let msg = Printexc.to_string e and stack = Printexc.get_backtrace () in
    Printf.eprintf "there was an error: %s%s\n" msg stack;
    Stdlib.exit 1
