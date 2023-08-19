open Printf
module Log = Dolog.Log

let write_mp_file_segs trk =
  let origin = List.hd trk.Model.points in

  let xyz_points : (float * float * float) list =
    List.map (fun point -> Gps.xyz_of_point origin point) trk.Model.points
  in

  let fout = open_out "segments.mp" in

  let pair_of_point (x, y, _) = sprintf "(%f,%f)" x y in

  let pairs =
    List.fold_left
      (fun a b -> a ^ " -- " ^ b ^ "\n")
      (pair_of_point (List.hd xyz_points))
      (List.map pair_of_point (List.tl xyz_points))
  in

  let () = fprintf fout "%s" "vardef get_route(expr t)=\n" in
  let () = fprintf fout "path p ; p := %s ; \n" pairs in
  let () = fprintf fout "p := p transformed t ;\n" in
  let () = fprintf fout "p \n" in
  let () = fprintf fout "enddef;\n" in
  ()

let write_mp_wpts trk =
  let origin = List.hd trk.Model.points in
  let fout = open_out "waypoints.mp" in
  let xyz_points : (float * float * float) list =
    List.map (fun point -> Gps.xyz_of_point origin point) trk.Model.wpts
  in
  let () = fprintf fout "%s" "vardef get_wpts(suffix wpts)(expr t)=\n" in
  let (_ : int) =
    List.fold_left
      (fun counter (x, y, _) ->
        let () =
          fprintf fout "wpts%d = (%f,%f) transformed t ;\n" counter x y
        in
        counter + 1)
      0 xyz_points
  in
  let () = fprintf fout "enddef;\n" in
  ()
