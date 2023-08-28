type xy_point = { x : float; y : float } [@@deriving yaml]

type common_point = {
  (* the index of the point in the gpx file *)
  gpx_index : int;
  (* the coordinates in the google png image *)
  google : xy_point;
  (* the coordinates in the scanned co map *)
  co : xy_point;
}
[@@deriving yaml]

type project = {
  pdf : string;
  gpx_file : string;
  google_png_file : string;
  co_png_file : string;
  common_points : common_point list;
}
[@@deriving yaml]

type point = { lat : float; lon : float; ele : float; time : float }
[@@deriving yaml]

type gpx = { title : string; points : point list; wpts : point list }
[@@deriving yaml]

let deserialize str =
  match Yaml.of_string str with
  | Ok yaml_value -> (
      match project_of_yaml yaml_value with
      | Ok t -> t
      | Error (`Msg e) -> failwith ("Error - convert to project: " ^ e))
  | Error (`Msg e) -> failwith ("Error - parsing: " ^ e)

let serialize v =
  let yaml_structure = project_to_yaml v in
  match Yaml.to_string yaml_structure with
  | Ok s -> s
  | Error (`Msg e) -> failwith e
