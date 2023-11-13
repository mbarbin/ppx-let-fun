(lang dune 3.11)

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
 (description
  "Allowing let-binding for functions whose last argument is a closure")
 (depends
  (ocaml
   (>= 5.1))
  (dune
   (>= 3.11))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_jane
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
