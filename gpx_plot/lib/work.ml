module Log = Dolog.Log

let work ~workdir ~project =
  let () = Log.info "workdir : %s" workdir in
  let gpx = Reader.model_of_gpx ~workdir in
  let () = Mp.write_mp_file_segs ~workdir ~gpx in
  let () = Mp.write_mp_wpts ~workdir ~gpx in
  let () = Mp.write_mp_infos ~workdir ~project in
  let () = Main_tex.write_tex_file ~workdir ~project in
  let command =
    Printf.sprintf "( cd %s && lualatex main.tex ) 2>stderr 1>stdout " workdir
  in
  let () = Log.info "command : %s" command in
  let status = Unix.system command in
  let () =
    match status with
    | Unix.WEXITED 0 -> Log.info "SUCCESS"
    | Unix.WEXITED i -> Log.info "EXIT %d" i
    | Unix.WSIGNALED i -> Log.info "WSIGNALED %d" i
    | Unix.WSTOPPED i -> Log.info "WSTOPPED %d" i
  in
  ()
