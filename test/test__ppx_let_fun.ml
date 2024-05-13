(* Imagine you have an interface with a function [with_*] which allows you to
   introduce to the scope a value of a certain type, delimited inside a closure.
   Let's take the following [Resource.with_t] example below. *)

module Resource : sig
  type t

  val ignore : t -> unit
  val with_t : (t -> 'a) -> 'a
  val with_t_f : f:(t -> 'a) -> 'a
  val with_t_g : g:(t -> 'a) -> 'a
end = struct
  type t = unit

  let ignore () = ()
  let with_t f = f ()
  let with_t_f ~f = f ()
  let with_t_g ~g = g ()
end

(* The most direct vanilla style to use it would be passing it a syntactic closure. *)

let%expect_test "closure" = Resource.with_t (fun x -> Resource.ignore x)

(* Another style is to use the @@ operator. *)

let%expect_test "@@" = Resource.with_t @@ fun x -> Resource.ignore x

(* I wanted to try and use a let-syntax alternate.

   Granted, writing

   {[
     let%fun x = with_x in ...
   ]}

   is very closed to the use of '@@' which is already supported and used perhaps
   more pervasively:

   {[
     with_x @@ fun x -> ...
   ]}

   But, there are drawbacks:

   1. I'm not sure, but perhaps I find it inconsistent to be using [let%map]
   instead of infix operators such as [>>|] on one hand, and still using [@@]
   on the other hand.

   2. With the configuration I currently have for ocamlformat, this end up
   spanning two lines:

   {[
     with_x
     @@ fun x ->
     ...
   ]}

   3. '@@' doesn't work with labeled arguments, whereas perhaps something could
   be done using a let-syntax style.

   By the way, this relates to opam package named [tilde_f]: *)

let%expect_test "tilde_f" =
  Tilde_f.run
    (let%map.Tilde_f x = Resource.with_t |> Tilde_f.of_unlabeled in
     Resource.ignore x)
;;

let%expect_test "tilde_f" =
  Tilde_f.run
    (let%map.Tilde_f x = Resource.with_t_f in
     Resource.ignore x)
;;

(* But I wanted something sort of simpler, and avoiding having to wrap the
   resulting code, like it is done above with the outer [Tilde_f.run].

   Before implementing an actual ppx, I wanted to try out one more thing and
   thus abused the [ppx_let] extension using a bogus [Let_syntax.map] function,
   which doesn't have the normal type. *)

module Fun = struct
  module Let_syntax = struct
    module Let_syntax = struct
      let map t ~f = t f
    end
  end
end

let%expect_test "let%map.Fun" =
  let%map.Fun x = Resource.with_t in
  Resource.ignore x
;;

(* This isn't that bad, however this may be a bit surprising to abuse `let%map`
   that way, and I expect it will bite back at some point.

   Thus I experimented with a ppx rewriter to allow to write:

   {[
     let%fun x = with_x in ...
   ]}
*)

let%expect_test "let%fun" =
  let%fun x = Resource.with_t in
  Resource.ignore x
;;

(* Labels:

   For the cases the closure is expected to be labelled.

   I thought perhaps you could write something like this:

   {[
     let%fun.f x = with_x in ...
   ]}

   But it doesn't work, what's after the '.' is expected to be a module Path,
   thus starting with an uppercase letter.

   With the [let%map] hack, this requires the addition of another module for
   each label, for example [Fun_f] and [Fun_g] below:
*)

module Fun_f = struct
  module Let_syntax = struct
    module Let_syntax = struct
      let map t ~f = t ~f
    end
  end
end

module Fun_g = struct
  module Let_syntax = struct
    module Let_syntax = struct
      let map t ~f = t ~g:f
    end
  end
end

let%expect_test "let%map.Fun_f" =
  let%map.Fun_f x = Resource.with_t_f in
  Resource.ignore x
;;

let%expect_test "let%map.Fun_f" =
  let%map.Fun_g x = Resource.with_t_g in
  Resource.ignore x
;;

(* With [let%fun] I currently implemented it so that the module path is
   uncapitalized into a label. *)

let%expect_test "let%fun.f" =
  let%fun.F x = Resource.with_t_f in
  Resource.ignore x
;;

let%expect_test "let%fun.g" =
  let%fun.G x = Resource.with_t_g in
  Resource.ignore x
;;

(* That's sort of ugly. TBD, this is only an experiment. *)

(* Another idea to explore: use of let-binding operators. This in similar to
   using the let-syntax, perhaps I will switch to this after all. *)

let ( let& ) x f = x f

let%expect_test "let&" =
  let& x = Resource.with_t in
  Resource.ignore x
;;

let ( let&- ) x f = x ~f

let%expect_test "let&-" =
  let&- x = Resource.with_t_f in
  Resource.ignore x
;;
