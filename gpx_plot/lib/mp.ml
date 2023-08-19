open Printf
module Log = Dolog.Log

let write_mp_file_segs gpx =
  let seed =
    ( (List.hd gpx.Model.points).lat,
      (List.hd gpx.Model.points).lon,
      (List.hd gpx.Model.points).lon,
      (List.hd gpx.Model.points).lon )
  in
  let latmin, latmax, lonmin, lonmax =
    List.fold_left
      (fun (latmin, latmax, lonmin, lonmax) p ->
        ( min latmin p.Model.lat,
          max latmax p.Model.lat,
          min lonmin p.Model.lon,
          max lonmax p.Model.lon ))
      seed (List.tl gpx.Model.points)
  in

  let _ = (latmin, latmax, lonmin, lonmax) in

  let origin =
    {
      (*      Model.lat = (latmin +. latmax) /. 2.0; *)
      (*      lon = (lonmin +. lonmax) /. 2.0; *)
      Model.lat = latmin;
      lon = lonmin;
      ele = 0.0;
      time = 0.0;
    }
  in

  let xyz_points : (float * float * float) list =
    List.map (fun point -> Gps.xyz_of_point origin point) gpx.Model.points
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

let write_mp_wpts gpx =
  let origin = List.hd gpx.Model.points in
  let fout = open_out "waypoints.mp" in
  let xyz_points : (float * float * float) list =
    List.map (fun point -> Gps.xyz_of_point origin point) gpx.Model.wpts
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
