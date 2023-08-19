(**
 sheet data model
*)

type point = { lat : float; lon : float; ele : float; time : float }
type gpx = { title : string; points : point list; wpts : point list }

val deserialize : string -> gpx
(*
    deserialize a string to yaml
*)

val serialize : gpx -> string
