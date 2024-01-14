open Gfile_exam 
open Exam
open Csv

let () =

  (* Check the number of command-line arguments *)
  if  Array.length Sys.argv <> 3 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n") ;
      exit 0
    end ;

  (* Aruguments are: infile(1) outfile(2)*)
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(2)
  in

  (* Solve problem for a given input *)
  let assocs = exam infile in
  (* Write human readable solution *)
  export_schedule outfile assocs;

  (* Write solution to a CSV file (exam_schedule/output/assocs.csv) *)
  let () = export_csv_assocs assocs in
  ()