# ppx-let-fun

[![CI Status](https://github.com/mbarbin/ppx-let-fun/workflows/ci/badge.svg)](https://github.com/mbarbin/ppx-let-fun/actions/workflows/ci.yml)
[![Deploy odoc Status](https://github.com/mbarbin/ppx-let-fun/workflows/deploy-odoc/badge.svg)](https://github.com/mbarbin/ppx-let-fun/actions/workflows/deploy-odoc.yml)

`ppx-let-fun` is an experimental ppx rewriter which allows you to use a
let-syntax style to handle functions applications that expects their last
argument to be a closure. It defines and rewrite the `let%fun` extension:

For example:

```ocaml
let print_hello_world file =
  Out_channel.with_open_text file (fun oc ->
    Out_channel.output_string oc "Hello, ";
    Out_channel.output_string oc "World\n")
```

Can be rewritten as:

```ocaml
let print_hello_world file =
  let%fun oc = Out_channel.with_open_text file in
  Out_channel.output_string oc "Hello, ";
  Out_channel.output_string oc "World\n"
```

### Possibly related

- [tilde_f](https://github.com/janestreet/tilde_f)
