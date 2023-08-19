type point = { lat : float; lon : float; ele : float; time : float }
[@@deriving yaml]

type trk = { title : string; points : point list; wpts : point list }
[@@deriving yaml]

let deserialize str =
  match Yaml.of_string str with
  | Ok yaml_value -> (
      match trk_of_yaml yaml_value with
      | Ok t -> t
      | Error (`Msg e) -> failwith ("Error - convert to sheet: " ^ e))
  | Error (`Msg e) -> failwith ("Error - parsing: " ^ e)

let serialize v =
  let yaml_structure = trk_to_yaml v in
  match Yaml.to_string yaml_structure with
  | Ok s -> s
  | Error (`Msg e) -> failwith e
