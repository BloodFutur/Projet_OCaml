open Graph

type path = string

(*
  Make a graph from classes,rooms,times and proctors lists
*)
val make_graph: (int * string * int) list -> (int * string * int) list -> (int * string) list -> (int * string) list -> int graph

(*
  Make classes, rooms, times and proctors lists from a file   
*)
val from_efile: path -> (int * string * int) list * (int * string * int) list * (int * string) list * (int * string) list

(*
  Export a schedule to a file
  The format is made to be human readable   
*)
val export_schedule: path -> (string * string * string * string) list option -> unit