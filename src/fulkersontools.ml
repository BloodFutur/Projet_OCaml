open Graph
open Tools

type path = id list

(* From a given graph, returns Some path if a path was found between s and t*)
  let find_path gr visited s t =
    (* Depth-first search algorithm to determine a path from s to t in gr *)
    let rec path_dfs (visited: id list) (acc: path) (s: id)=
      Printf.printf "node visited: %d \n" s;
      if s=t then 
        List.rev(s::acc)
    (* else List.map (fun a-> (path_dfs gr (List.append visited [s]) ((a.src)::acc) a.tgt t) else acc) (out_arcs gr s) *)
      else
        let rec loop = function
        |[]->[]
        |a::rest -> if (not (List.mem a.tgt visited)) && (a.lbl>0) 
                    then (match (path_dfs (s::visited) (a.src::acc) a.tgt) with
                          |[]-> loop rest
                          |p -> p)
                    else loop rest 
      in
      loop (out_arcs gr s)
    in
    match path_dfs visited [] s with
    |[] -> None
    |p -> Some p



(* From a given graph, returns Some path if a path was found between s and t*)
let find_path_bfs gr s t =
  (* Breadth-first search algorithm to determine a path from s to t in gr *)
  let q = Queue.create () in
  Queue.push s q;
  let visited = [] in
  let rec path_bfs queue vis acc =
    if (Queue.is_empty queue) then acc
    else
      let v = Queue.pop queue in
      Printf.printf "\nvisited node : %d\n" v;
      if v = t then List.rev (v::acc) 
      else 
        let rec loop vis = function
        | [] -> ()
        | a::rest -> if (not (List.mem a.tgt vis)) && (a.lbl > 0) 
                     then begin Queue.push a.tgt queue; loop (a.tgt::vis) rest end
                     else loop vis rest
        in loop vis (out_arcs gr v);
        path_bfs queue vis (v::acc)
  in 
    match path_bfs q visited [] with
    |[] -> None
    |p -> Some p




  (*
  let rec path_bfs visited acc s=
    Printf.printf "node visited: %d \n" s;
    if s=t then
      List.rev(s::acc)
    else
      
    in
    path_bfs [s] [] s
*)
  
  

(* gets minimal flow from path (id list)*)
let min_flow gr p = 
  let rec loop acu p1= 
    match p1 with
    |[] -> acu
    |_::[] -> acu
    |node1::(node2::rest) -> 
      match find_arc gr node1 node2 with
      |None -> failwith("Edge not found")
      |Some arc -> if (acu<arc.lbl) then loop acu (node2::rest) else loop arc.lbl (node2::rest)
  in
  loop max_int p


let rec update_flows grf path flow = 
  match path with
  |[] -> grf
  |_::[] -> grf
  |node1::(node2::rest) -> 
    let graph1 = add_arc grf node1 node2 flow in
    update_flows graph1 (node2::rest) flow

let rec update_capacities grc path flow =
  match path with 
  |[] -> grc
  |_::[] -> grc
  |node1::(node2::rest) -> 
    let graph1 = add_arc grc node1 node2 (-flow) in
    let graph2 = add_arc graph1 node2 node1 flow in
    update_capacities graph2 (node2::rest) flow


let max_flow_node node1 gr =
  let rec loop acu = function
    |[] -> acu 
    |arc::rest -> loop (acu+arc.lbl) rest
  in
  loop 0 (out_arcs gr node1)
