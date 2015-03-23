open Core.Std

(** Applies a function f to each element in a stream of Fasta.Item.t derived from the provided
    file; closes the file when done. *)
val with_items : string -> f:(Fasta.Item.t -> unit) -> unit

(** Applies the function f: (Fasta.Item.t * int) -> ()) to a stream of items from the
    provided input file *)
val with_items_indexed : string -> f:(Fasta.Item.t * int -> unit) -> unit

(** Applies the function f to a stream of items matching the given predicate from the provided
    input file *)
val with_matching_items : string -> p:(Fasta.Item.t * int -> bool) -> f:(Fasta.Item.t * int -> unit) -> unit

(** A predicate that selects sequences with a given name *)
val match_name : string -> Fasta.Item.t * int -> bool

(** A predicate that selects sequences with a given index *)
val match_num : int -> Fasta.Item.t * int -> bool

(** Builds a matching function based on a proved sequence number or name  *)
val matcher : string option -> int option -> Fasta.Item.t * int -> bool
