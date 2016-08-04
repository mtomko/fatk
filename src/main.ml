open Core.Std
open Extensions

(*let trace = Log.make_trace "fatk"*)

(*let info = Log.make_info "fatk"*)

let command = Command.group ~summary:"Process FASTA files"
                            [ "list", List_seqs.cmd; "print", Print_seq.cmd; "sub", Sub_seq.cmd]

let () = Command.run ~version:"0.5.1" command

