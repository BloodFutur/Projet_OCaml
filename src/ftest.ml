open Gfile
open Gfile_exam 
open Exam
open Tools

open Fulkerson

let exam_schedule infile outfile =
  let assocs = exam infile in
    export_schedule outfile assocs

let test infile source sink outfile =
  let graph = from_file infile in
  let maxflow,_ = ford_fulkerson (gmap graph int_of_string) source sink in
  match maxflow with
  | f -> Printf.printf "max flow: %d" f;
  export outfile graph

let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 && Array.length Sys.argv <> 3 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n") ;
      exit 0
    end ;

  if Array.length Sys.argv = 5 then
    begin
      let _infile = Sys.argv.(1)
      and _outfile = Sys.argv.(4)
      and _source = int_of_string Sys.argv.(2)
      and _sink = int_of_string Sys.argv.(3)
      in

      test _infile _source _sink _outfile;
    end
  else
    begin (* Array.length Sys.argv = 3 *)
      let _infile = Sys.argv.(1)
      and _outfile = Sys.argv.(2)
      in
      exam_schedule _infile _outfile;
    end