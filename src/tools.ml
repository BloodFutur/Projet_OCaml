open Graph

type path = id list

let clone_nodes (gr: 'a graph) = n_fold gr new_node empty_graph

(* It folds over edges of the given graph and applies the function f, from an arc-empty copy*)
let gmap (gr: 'a graph) (f: 'a -> 'b) = e_fold gr (fun g e -> new_arc g {e with lbl=(f e.lbl)}) (clone_nodes gr)


(* Add n to the value fo the arc betwen id1 and id2. If the arc does not exist, it is created*)
let add_arc (gr: 'a graph) (id1: id) (id2: id) (n: int) =  match (find_arc gr id1 id2) with
  |None -> new_arc gr {src=id1 ; tgt=id2 ; lbl=n}
  |Some arc -> new_arc gr {arc with lbl=(arc.lbl + n)}

let rec print_list = function 
[] -> ()
| e::l -> print_int e ; print_string " " ; print_list l


(* From a given graph, returns Some path if a path was found between s and t*)
let find_path gr visited s t =
  (* Deep-first search algorithm to determine a path from s to t in gr *)
  let rec path_dfs (visited: id list) (acc: path) (s: id)=
    Printf.printf "node visited: %d \n" s;
    if s=t then 
      List.rev(s::acc)
  (* else List.map (fun a-> (path_dfs gr (List.append visited [s]) ((a.src)::acc) a.tgt t) else acc) (out_arcs gr s) *)
    else
      let rec loop = function
      |[]->[]
      |a::rest -> if (not (List.mem a.tgt visited)) && (a.lbl>0) then (match (path_dfs (s::visited) (a.src::acc) a.tgt) with
                                                          |[]-> loop rest
                                                          |p -> p)
                  else loop rest 
    in
    loop (out_arcs gr s)
  in
  match path_dfs visited [] s with
  |[] -> None
  |p -> Some p


(* gets minimal flow from path (id list)*)
let min_flow gr p = 
  let rec loop acu p1= 
    match p1 with
    |[] -> acu
    |_::[] -> acu
    |node1::(node2::rest) -> 
      match find_arc gr node1 node2 with
      |None -> failwith("Edge not found")
      |Some arc -> if (acu<arc.lbl) then loop acu rest else loop arc.lbl rest
  in
  loop max_int p


(* let rec update_flows gr path flow = 
  match path with
  |[] -> gr
  |_::[] -> gr
  |node1::(node2::rest) -> 
    let graph1 = add_arc gr node1 node2 flow in
    let graph2 = add_arc graph1 node2 node1 (-flow) in
    update_flows graph2 (node2::rest) flow *)

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
        update_capacities graph1 (node2::rest) flow


let max_flow_node node1 gr =
  let rec loop acu = function
    |[] -> acu 
    |arc::rest -> loop (acu+arc.lbl) rest
  in
  loop 0 (out_arcs gr node1)




(* let ford_fulkerson (gr_cp: 'a graph) (s: id) (t: id) =
  (* initialize an identical graph with 0 flow on all arcs *)
  let gr_flow = e_fold gr_cp (fun acc a -> new_arc acc {src=a.src ;  tgt=a.tgt ;  lbl=0}) (clone_nodes gr_cp)
  in 
  (* loop on possible paths from s to t*)
  let rec loop_paths grc grf = match find_path grc [] s t with
    |None -> max_flow_node s grf (* termination condition ??*)
    |Some p -> 
      let capacity = min_flow grf p in
      Printf.printf "capacity: %d \n" capacity; (*PROBLEM WITH CAPACITY*)
      let grf_update = update_flows grf p capacity in
      loop_paths grc grf_update
    in
    loop_paths gr_cp gr_flow *)




    (*New understanding of capacity and flow graphs

    this program finishes, need to fix capacity values found and edges direction*)


    let ford_fulkerson (gr_cp: 'a graph) (s: id) (t: id) =
      (* initialize an identical graph with 0 flow on all arcs *)
      let gr_flow = e_fold gr_cp (fun acc a -> new_arc acc {src=a.src ;  tgt=a.tgt ;  lbl=0}) (clone_nodes gr_cp)
      in 
      (* loop on possible paths from s to t*)
      let rec loop_paths grc grf = match find_path grc [] s t with
        |None -> max_flow_node s grf (* termination condition ??*)
        |Some p -> 
          let capacity = min_flow grc p in
          Printf.printf "capacity: %d \n" capacity; (*PROBLEM WITH CAPACITY*)
          let grf_update = update_flows grf p capacity in
          let grc_update = update_capacities grc p capacity in
          loop_paths grc_update grf_update
        in
        loop_paths gr_cp gr_flow
    
     


