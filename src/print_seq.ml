open Core.Std
open Extensions

let print_seq file_name seq_name print_header =
  Fatk.with_items
    (fun stream ->
     let matching_seqs =
       Stream.filter (fun (fa: Fasta.item) -> fa.name = seq_name) stream in
     let handler =
       match print_header with
       | true -> (fun (fa : Fasta.item) ->
                  print_char '>';
                  print_string fa.name;
                  print_newline ();
                  print_string fa.sequence;
                  print_newline ())
       | false -> (fun (fa : Fasta.item) ->
                   print_string fa.sequence;
                   print_newline ()) in
     Stream.iter handler matching_seqs) file_name

let cmd =
  Command.basic
    ~summary:"Print selected sequence in the provided FASTA file"
    Command.Spec.(
    empty
    +> anon ("file" %: file)
    +> flag "-n" (required string) ~doc: " sequence name"
    +> flag "-h" no_arg ~doc: " print sequence headers"
  )
  (fun file_name seq_name print_header () -> print_seq file_name seq_name print_header)
                                    
  
