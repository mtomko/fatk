module Stream = struct
  include Stream

  (* adapted slightly from http://ocaml.org/learn/tutorials/streams.html *)
  let fold ~stream ~init ~f =
    let result = ref init in
    Stream.iter
      (fun x -> result := f !result x)
      stream;
    !result

  (* takes from the stream while the predicate is true, leaving the first element
     which does not satisfy the predicate at the head of the stream *)
  let take_while ~pred ~stream =
    let rec loop buf =
      match Stream.peek stream with
      | None -> List.rev buf
      | Some e ->
         if pred e then
           let () = Stream.junk stream in
           loop (e :: buf)
         else List.rev buf in
    loop []

end
