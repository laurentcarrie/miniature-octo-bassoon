module Log = Dolog.Log

let () =
  Log.set_log_level Log.INFO;
  Log.set_output stdout;
  Log.color_on ();
  let _ = Log.info "begin work" in
  let trk_filename = Array.get Sys.argv 1 in
  let _ = Log.info trk_filename in
  ()
