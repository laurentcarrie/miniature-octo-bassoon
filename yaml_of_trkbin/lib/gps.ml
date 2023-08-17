module Log = Dolog.Log
(* https://en.wikipedia.org/wiki/Geodetic_coordinates *)

(* let equatorial_radius = 6_378_137.0 *)
let equatorial_radius = 1000.0

(* let polar_radius = 6_356_752.3142 *)

(* let n_of_coords point = *)
(*  let a2 = equatorial_radius *. equatorial_radius in *)
(*  let b2 = polar_radius *. polar_radius in *)
(*  let lat = point.Model.lat *. Float.pi /. 180.0 in *)
(*  (*  let lon = point.Model.lon *. Float.pi /. 180.0 in *) *)
(*  a2 /. sqrt ((a2 *. cos lat *. cos lat) +. (b2 *. sin lat *. sin lat)) *)

(* let xyz_of_point_2 point = *)
(*  let n = n_of_coords point in *)
(*  let lat = point.Model.lat *. Float.pi /. 180.0 in *)
(*  let lon = point.Model.lon *. Float.pi /. 180.0 in *)
(*  let h = point.Model.ele in *)
(*  let x = (n +. h) *. cos lat *. cos lon in *)
(*  let y = (n +. h) *. cos lat *. sin lon in *)
(*  let a2 = equatorial_radius *. equatorial_radius in *)
(*  let b2 = polar_radius *. polar_radius in *)
(*  let z = ((b2 /. a2 *. n) +. h) *. sin lat in *)
(*  (x, y, z) *)

let xyz_of_point origin point =
  let origin_lat = origin.Model.lat *. Float.pi /. 180.0 in
  let origin_lon = origin.Model.lon *. Float.pi /. 180.0 in
  let lat = point.Model.lat *. Float.pi /. 180.0 in
  let lon = point.Model.lon *. Float.pi /. 180.0 in
  let r = equatorial_radius *. cos origin_lat in
  let dlon = lon -. origin_lon in
  let dlat = lat -. origin_lat in

  let dx = r *. dlon in
  let _ = Log.info "dx %f" dx in
  let dy = equatorial_radius *. dlat *. 0.95 in
  let z = point.Model.ele in

  let _ = Log.info "xy %f ; %f" dx dy in
  (dx, dy, z)
