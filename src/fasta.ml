open Core_kernel.Std
open Re2

type item = {
  name : string;
  sequence : string;
}

let sequence_name_re = Regex.create_exn "^>(.*)$"

let not_header l = not (Regex.matches sequence_name_re l)

let stream_take_while p stream =
  let rec loop buf =
    match Stream.peek stream with
    | None -> List.rev buf
    | Some line ->
       if p line then
         let () = Stream.junk stream in
         loop (line :: buf)
       else List.rev buf in
  loop []

let fasta_stream_of_channel channel =
  let line_stream =
    Stream.from (fun _ -> In_channel.input_line channel) in
  let fasta_stream_fn _ =
    try
      let header = Stream.next line_stream in
      if Regex.matches sequence_name_re header then
        let data = String.concat ?sep:None (stream_take_while not_header line_stream) in
        Some { name = header; sequence = data }
      else None
    with Stream.Failure -> None in
  Stream.from fasta_stream_fn
  
