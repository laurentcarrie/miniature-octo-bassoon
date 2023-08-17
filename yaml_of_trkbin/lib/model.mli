(**
 sheet data model
*)

type point = { lat : float; lon : float; ele : float; time : float }

type trk = {
  title : string;
  points : point list;
      (*  authors : string list; *)
      (*  path : string; *)
      (*  sections : section list; *)
}

val deserialize : string -> trk
(*
    deserialize a string to yaml
*)

val serialize : trk -> string
