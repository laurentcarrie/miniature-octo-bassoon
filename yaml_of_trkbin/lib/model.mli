(**
 sheet data model
*)

type chord = string
type row = chord list
type section = { name : string; rows : row list }

type trk = {
  title : string;
(*  authors : string list; *)
  (*  path : string; *)
(*  sections : section list; *)
}

val deserialize : string -> trk
(*
    deserialize a string to yaml
*)

val serialize : trk -> string
