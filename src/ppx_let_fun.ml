open! Base
open! Ppxlib

let extension =
  let pattern
    : ( payload
        , (pattern * expression) list -> expression -> expression
        , expression )
        Ast_pattern.t
    =
    let open Ast_pattern in
    single_expr_payload (pexp_let __ (many (pack2 (value_binding ~pat:__ ~expr:__))) __)
    |> map2 ~f:(fun rec_flag bindings ->
      match rec_flag with
      | Recursive -> Location.raise_errorf "[let rec] is not supported."
      | Nonrecursive -> bindings)
  in
  Extension.declare_with_path_arg
    "fun"
    Expression
    pattern
    (fun ~loc ~path:_ ~arg bindings rhs ->
       let open (val Ast_builder.make loc) in
       match bindings with
       | [] | _ :: _ :: _ -> Location.raise_errorf ~loc "Expected exactly one binding."
       | [ (pattern, expression) ] ->
         let label =
           match arg with
           | None -> Nolabel
           | Some { loc = _; txt } -> Labelled (Longident.name txt |> String.uncapitalize)
         in
         pexp_apply
           expression
           [ label, pexp_function [ case ~lhs:pattern ~guard:None ~rhs ] ])
;;

let () =
  Driver.register_transformation "fun" ~rules:[ Context_free.Rule.extension extension ]
;;
