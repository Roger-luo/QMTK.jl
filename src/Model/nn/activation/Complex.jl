__NON_HOLOMOPHICS__ = [
    (:Real, x->:(real.($x)), x->:(real.($x))), # TO CHECK
    (:Imag, x->:(imag.($x)), x->:(-im .* real.($x))),
    (:Conj, x->:(conj.($x)), x->:(conj.($x))),
    (:Abs, x->:(abs.($x)), x->:(grad_abs.($x))),
    (:SquareAbs, x->:(abs.($x) .* abs.($x)), x->:()),
]