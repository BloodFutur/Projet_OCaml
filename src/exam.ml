open Fulkerson
open Graph
open Tools
open Fulkersontools
open Gfile_exam


open Gfile

(* Combine arcs into a single arc between two nodes and remove arcs with label 0 *)
let simplify_graph graph =
  let g1 = e_fold graph (fun g a -> match find_arc g a.tgt a.src with
      | None -> g
      | Some arc -> if arc.lbl > a.lbl
        then add_arc (add_arc g arc.src arc.tgt (- a.lbl)) a.src a.tgt (-a.lbl)
        else add_arc (add_arc g arc.src arc.tgt (-arc.lbl)) a.src a.tgt (-arc.lbl)
    ) graph in
  let g2 = e_fold g1 (fun g a -> if a.lbl = 0 then g else add_arc g a.src a.tgt a.lbl) (clone_nodes g1) in
  e_fold g2 (fun g a -> if a.lbl > 0 then add_arc g a.src a.tgt a.lbl else add_arc g a.tgt a.src (-a.lbl)) (clone_nodes g2)


(* Remove 1 on each arc for a given path *)
let decrease_flow graph path =
  List.fold_left (fun g a ->  add_arc g a.src a.tgt (-1)) graph (arcs_from_nodes graph path)

(* Return list path of all class-room-time-proctor path assignment in a given graph*)
let find_paths_crtp graph = 
  let rec loop_paths g lpaths = match (find_path g 0 1) with
    | None -> lpaths
    | Some path -> loop_paths (decrease_flow g path) (path::lpaths)
  in loop_paths graph []


(* 
   Convert a path list into a human readable association list
   Example: 0 4 6 8 9 1 -> MIC1 GEI15 14h Patrick   
*)
let get_assocs list_paths lc lr lt lp =
  (* loop through all path*)
  let rec loop lassocs lc2 lr2 = function
    | [] -> lassocs
    | [_;c;r;t;p;_]::rest -> 
      let ac = List.assoc c lc2 in
      let ar = List.assoc r lr2 in
      let at = List.assoc t lt in
      let ap = List.assoc p lp in
      loop ((ac,ar,at,ap)::lassocs) lc2 lr2 rest
    | _ -> failwith "get_assocs: wrong path"
    (* map n-uplet to 2-uplet with id and name if necessary*)
  in loop [] (List.map (fun (id,name,_) -> (id,name)) lc) (List.map (fun (id,name,_) -> (id,name)) lr) list_paths


let beautiful_string_of_int n = if n = max_int then "∞" else string_of_int n

let print_3tuple = function
  | (a,b,c) -> Printf.printf "(%d,%s,%d)" a b c

let print_2tuple = function
  | (a,b) -> Printf.printf "(%d,%s)" a b

let exam (infile: string) =
  (* Get all lists from input file*)
  let list_classes, list_rooms, list_times, list_proctors = from_efile infile in

  (* Print lists*)
  Printf.printf "\nClasses list:\n\t";  List.iter print_3tuple list_classes;
  Printf.printf "\nRooms list:\n\t";    List.iter print_3tuple list_rooms;
  Printf.printf "\nTimes list:\n\t";    List.iter print_2tuple list_times;
  Printf.printf "\nProctors list:\n\t"; List.iter print_2tuple list_proctors;

  (* Make graph from lists and export it*)
  let graph = make_graph list_classes list_rooms list_times list_proctors in
  export "graphs/exam_schedule/original.txt" (gmap graph beautiful_string_of_int);

  (* Compute Ford-Fulkson algorithm to get maximum flow*)
  let flow, flow_graph = ford_fulkerson graph 0 1 in
  Printf.printf "\n\nMaximum flow = %d\n" flow;

  (* Export flow graph*)
  export "graphs/exam_schedule/flow.txt" (gmap flow_graph beautiful_string_of_int);

  (* Simplify graph and export it*)
  let simplified_graph = simplify_graph flow_graph in
  export "graphs/exam_schedule/simplified.txt" (gmap simplified_graph beautiful_string_of_int);

  (* Solution exists only if max_flow = number of classes*)
  if flow = List.length list_classes then
    (* Find associations*)
    let paths = find_paths_crtp simplified_graph in
    let assocs = get_assocs paths list_classes list_rooms list_times list_proctors in
    Some assocs
  else
    None


