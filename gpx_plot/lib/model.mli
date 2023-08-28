type xy_point = { x : float; y : float }

type common_point = {
  (* the index of the point in the gpx file *)
  gpx_index : int;
  (* the coordinates in the google png image *)
  google : xy_point;
  (* the coordinates in the scanned co map *)
  co : xy_point;
}

type project = {
  pdf : string;
  gpx_file : string;
  google_png_file : string;
  co_png_file : string;
  common_points : common_point list;
}

type point = { lat : float; lon : float; ele : float; time : float }
type gpx = { title : string; points : point list; wpts : point list }

val deserialize : string -> project
(*
    deserialize a string to yaml
*)

val serialize : project -> string
