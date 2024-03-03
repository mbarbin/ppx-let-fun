(lang dune 3.14)

(name ppx-let-fun)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

(source
 (github mbarbin/ppx-let-fun))

(documentation "https://mbarbin.github.io/ppx-let-fun/")

(package
 (name ppx-let-fun)
 (synopsis
  "Allowing let-binding for functions whose last argument is a closure")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (expect-test-helpers
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_expect
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_here
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_let
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_conv
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_value
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppxlib
   (>= 0.31.0))
  (tilde_f
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))))
