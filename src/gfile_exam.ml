open Graph

type path = string


let read_class line counter =
  try Scanf.sscanf line "c %s %d" (fun s d -> (s, d, counter))
  with e ->
    Printf.printf "Cannot read class in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

let read_room line counter = 
  try Scanf.sscanf line "r %s %d" (fun s d -> (s, d, counter))
  with e ->
    Printf.printf "Cannot read room in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"
    
let read_time line counter =
  try Scanf.sscanf line "t %s" (fun s -> (s, counter))
  with e ->
    Printf.printf "Cannot read time in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"
  
let read_proctor line counter =
  try Scanf.sscanf line "p %s" (fun s -> (s, counter))
  with e ->
    Printf.printf "Cannot read proctor in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"
  

let read_comment line =
  try Scanf.sscanf line " %%" ()
  with _ ->
    Printf.printf "Unknown line:\n%s\n%!" line ;
    failwith "from_file"

let print_3tuple = function
  | (a,b,c) -> Printf.printf "(%s,%d,%d)" a b c
  

let print_2tuple = function
  | (a,b) -> Printf.printf "(%s,%d)" a b

let make_nodes list_class list_room list_time list_proctor= 
  (*for each element in class create node, node 0 is source node 1 is sink*)
  let graph_class = List.fold_left (fun acu (_,_,a) -> new_node acu a) (new_node empty_graph 0) list_class
  in
  let graph_room = List.fold_left (fun acu (_,_,a) -> new_node acu a) graph_class list_room
  in
  let graph_time = List.fold_left (fun acu (_,a) -> new_node acu a) graph_room list_time
  in
  let graph_proctor = List.fold_left (fun acu (_,a) -> new_node acu a) graph_time list_proctor
  in
  new_node graph_proctor 1


let make_graph list_class list_room list_time list_proctor = 
  Printf.printf "\nclass list:";
  List.iter print_3tuple list_class;
  Printf.printf "\nroom list:";
  List.iter print_3tuple list_room;
  Printf.printf "\ntime list:";
  List.iter print_2tuple list_time;
  Printf.printf "\nproctor list";
  List.iter print_2tuple list_proctor;
  (*for each element in class create node, node 0 is source node 1 is sink*)
  let graph_nodes = make_nodes list_class list_room list_time list_proctor
  in
  (*add arcs from source to class and from class to room (if enough capacity in the room)*)
  let graph_arcs_cr = 
    List.fold_left (fun acu (_,people, id) -> List.fold_left (fun acur (_,capacity,idr) -> 
      if capacity>=people then new_arc acur {src=id;tgt=idr;lbl=max_int} else acur) (new_arc acu {src=0; tgt=id; lbl=1}) list_room) graph_nodes list_class
  in 
  (*add arcs from room to time slot*)
  let graph_arcs_rt = 
    List.fold_left (fun acu (_,_,idr) -> List.fold_left (fun acut (_,idt) -> new_arc acut {src=idr; tgt=idt; lbl=1}) acu list_time) graph_arcs_cr list_room
  in
  (*add arcs from time to proctor; and from proctor to sink (1 proctor can oversee at most 3 exams)*)
  let graph_arcs_tp =
    List.fold_left (fun acu (_, idt) -> List.fold_left (fun acup (_, idp) -> new_arc (new_arc acup {src=idp; tgt=1; lbl=3}) {src=idt; tgt=idp; lbl=1}) acu list_proctor) graph_arcs_rt list_time
  in
  graph_arcs_tp
  

let from_efile path = 
  let infile = open_in path in 

  let rec loop graph counter list_class list_room list_time list_proctor =
    try 
      let line = input_line infile in
    
        if line="" then loop graph counter list_class list_room list_time list_proctor
        else match line.[0] with
        |'c' -> loop graph (counter+1) ((read_class line counter)::list_class) list_room list_time list_proctor
        |'r' -> loop graph (counter+1) list_class ((read_room line counter)::list_room) list_time list_proctor
        |'t' -> loop graph (counter+1) list_class list_room ((read_time line counter)::list_time) list_proctor
        |'p' -> loop graph (counter+1) list_class list_room list_time ((read_proctor line counter)::list_proctor)
        |_-> read_comment line; loop graph counter list_class list_room list_time list_proctor
      

      with End_of_file -> make_graph list_class list_room list_time list_proctor



      in
      let final_graph = loop empty_graph 2 [] [] [] []
    in
    close_in infile;
    final_graph
     