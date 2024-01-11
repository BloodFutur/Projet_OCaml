open Fulkerson
open Graph
open Tools
open Fulkersontools

let simplify_graph graph =
  let g1 = e_fold graph (fun g a -> match find_arc g a.tgt a.src with
  | None -> g
  | Some arc -> if arc.lbl > a.lbl 
    then add_arc (add_arc g a.tgt a.src (- a.lbl)) a.src a.tgt (-a.lbl)
    else add_arc (add_arc g a.tgt a.src (-arc.lbl)) a.src a.tgt (-arc.lbl)
  ) graph in
  e_fold g1 (fun g a -> if a.lbl = 0 then g else add_arc g a.src a.tgt a.lbl) (clone_nodes g1)

let decrease_flow graph path =
  let rec loop g p = 
    match p with 
    | [] -> g
    | _::[] -> g
    | a::b::rest -> 
      match find_arc g a b with
      | None -> failwith "decrease_flow: arc not found"
      | Some _ -> loop (add_arc g a b (-1)) (b::rest)
  in loop graph path

(* Return list path of all class-room-time-protor path assignment in a given graph*)
let find_paths_crtp graph = 
  let rec loop_paths g lpaths = match (find_path g [] 0 1) with
  | None -> lpaths
  | Some path -> loop_paths (decrease_flow g path) (path::lpaths)
  in loop_paths graph []


let exam (gr: 'a graph) (s: id) (t: id) =
  let f,g = eford_fulkerson gr s t in
  let gs = simplify_graph g in
  let paths = find_paths_crtp gs in
  List.iter (fun p -> print_list p; Printf.printf "\n") paths;
  f,gs


