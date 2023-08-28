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

  let fout = open_out "gpx.mp" in

  let pair_of_point (x, y, _) = sprintf "(%f,%f)" x y in

  let pairs =
    List.fold_left
      (fun a b -> a ^ " -- " ^ b ^ "\n")
      (pair_of_point (List.hd xyz_points))
      (List.map pair_of_point (List.tl xyz_points))
  in

  (*  let () = fprintf fout "%s" "vardef get_gpx(expr t)=\n" in *)
  let () = fprintf fout "path original_gpx ;\noriginal_gpx :=\n%s ; \n" pairs in
  (*  let () = fprintf fout "p := p transformed t ;\n" in *)
  (*  let () = fprintf fout "p \n" in *)
  (*  let () = fprintf fout "enddef;\n" in *)
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

let write_mp_infos project =
  let fout = open_out "infos.mp" in
  let () =
    fprintf fout
      "picture background_image ; \n\
       background_image = TEX(\"\\includegraphics[width=300pt]{%s}\");\n"
      project.Model.google_png_file
  in

  (* points of the original gpx file we want to use to reconcile the tracks *)
  let () = fprintf fout "%s\n" "\npair original_gpx_common[] ;\n" in

  let _ =
    List.fold_left
      (fun counter cp ->
        let () =
          fprintf fout "original_gpx_common%d = point %d of original_gpx ; \n"
            counter cp.Model.gpx_index
        in
        counter + 1)
      0 project.Model.common_points
  in

  let () = fprintf fout "%s\n" "\npair original_google_common[] ;\n" in
  let _ =
    List.fold_left
      (fun counter cp ->
        let () =
          fprintf fout "original_google_common%d = (%f,%f) ; \n" counter
            cp.Model.google.x cp.Model.google.y
        in
        counter + 1)
      0 project.Model.common_points
  in

  (*          pair pp[] ; *)
  (*        color pcolor ; *)
  (*        pcolor = (0,1,0) ; *)
  (*        draw p withcolor pcolor ; *)
  (*  *)
  (*        pp0 = point 166 of p ; *)
  (*        draw fullcircle scaled 5 shifted pp0 withcolor pcolor ; *)
  (*        dotlabel.ulft("0",pp0) withcolor pcolor ; *)
  (*  *)
  (*        pp1 = point 231 of p ; *)
  (*        draw fullcircle scaled 5 shifted pp1 withcolor pcolor ; *)
  (*        dotlabel.ulft("1",pp1) withcolor pcolor ; *)
  (*  *)
  (*        pp2 = point 900 of p ; *)
  (*        draw fullcircle scaled 5 shifted pp2 withcolor pcolor ; *)
  (*        dotlabel.ulft("2",pp2) withcolor pcolor ; *)
  (*  *)
  (*        pp3 = point 1106 of p ; *)
  (*        draw fullcircle scaled 5 shifted pp3 withcolor pcolor ; *)
  (*        dotlabel.ulft("3",pp3) withcolor pcolor ; *)
  ()
