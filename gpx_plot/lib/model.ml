let gpx_file = "input.gpx"
let google_png_file = "google.png"
let co_png_file = "co.pdf"

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

type view_type = Gpx_Google | Gpx_CO

type project = {
  (*  pdf : string; *)
  see_gpx : bool;
  see_google : bool;
  see_co : bool;
  view_type : view_type
  [@to_yaml fun i -> match i with | Gpx_Google -> `String "Gpx_Google" | Gpx_CO -> `String "Gpx_CO" ]
  [@of_yaml fun i -> match i with | `String "Gpx_Google" -> Gpx_Google | `String "Gpx_CO" -> Gpx_CO | _ -> raise runtime_error "bad yaml" ]
  ;

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
      | Error (`Msg e) -> failwith ("Yaml Error - convert to project: " ^ e))
  | Error (`Msg e) -> failwith ("Yaml Error - parsing: " ^ e)

let serialize v =
  let yaml_structure = project_to_yaml v in
  match Yaml.to_string yaml_structure with
  | Ok s -> s
  | Error (`Msg e) -> failwith e
