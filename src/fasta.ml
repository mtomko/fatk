open Core_kernel.Std
open Extensions
open Re2

type item = {
  name : string;
  sequence : string;
}

(* regex for the header line of a FASTA file *)
let sequence_name_re = Regex.create_exn "^>(.*)$"

(* helper function to pull the capturing group from a match *)
let extract_re_exn re = Regex.find_first_exn ~sub:(`Index 1) re

(* predicate matching lines that aren't FASTA headers *)
let not_header l = not (Regex.matches sequence_name_re l)

let fasta_stream_of_channel channel =
  let line_stream =
    Stream.from (fun _ -> In_channel.input_line channel) in
  let fasta_stream_fn _ =
    try
      let header = Stream.next line_stream in
      let name = extract_re_exn sequence_name_re header in
      if Regex.matches sequence_name_re header then
        let lines = Stream.take_while ~pred:not_header ~stream:line_stream in
        let data = String.concat ?sep:None lines in
        Some { name = name; sequence = data }
      else None
    with Stream.Failure -> None in
  Stream.from fasta_stream_fn
  
