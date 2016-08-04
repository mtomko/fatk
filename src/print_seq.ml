open Core.Std
open Extensions

let print_seq file_name seq_name seq_number print_header =
  let p = Fatk.matcher seq_name seq_number in
  let f =
    match print_header with
    | true -> (fun elt -> print_endline (Fasta.to_string (fst elt)))
    | false -> (fun elt ->
                  let fa = fst elt in
                    print_string (Fasta.sequence fa);
                    print_newline ()) in
  Fatk.with_matching_items file_name

let cmd =
  Command.basic
    ~summary:"Print selected sequence in the provided FASTA file"
    Command.Spec.(
    empty
    +> anon ("file" %: string)
    +> anon (maybe ("seq_name" %: string))
    +> flag "-n" (optional int) ~doc:"seq_num The sequence number to print"
    +> flag "-h" no_arg ~doc: " print sequence headers"
  )
  (fun file_name seq_name seq_number print_header () -> print_seq file_name seq_name seq_number print_header)
