# SLEEF

[![Build Status](https://travis-ci.org/oxinabox/SLEEF.jl.svg?branch=master)](https://travis-ci.org/oxinabox/SLEEF.jl)

[![Coverage Status](https://coveralls.io/repos/oxinabox/SLEEF.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/oxinabox/SLEEF.jl?branch=master)

[![codecov.io](http://codecov.io/github/oxinabox/SLEEF.jl/coverage.svg?branch=master)](http://codecov.io/github/oxinabox/SLEEF.jl?branch=master)



This is a julia binding for  Naoki Shibata's [SLEEF](https://github.com/shibatch/sleef)

>In this library, functions for evaluating some elementary functions
> are implemented. The algorithm is intentended for efficient evaluation
> utilizing SIMD instruction sets ...

Right now it is only set up to compile for SSE2; it is probably not too hard to tweak it to do all the other SIMD archetectures that SLEEF supports.

Functions named are prefixed with an `x`, vs usual libm names.
Using multiple dispatch, Float32, and Float64 functions share the same names.

In general all functions are accurate to within 1ulp.
The functions: `xsin_u1`, `xcos_u1`,  `xtan_u1`,  `xasin_u1`, `xacos_u1`,  `xatan_u1`,  `xlog_u1`,  `xcbrt_u1`, `xsincos_u1`, `xatan2_u1`, are varitations on `xsin`, `xcos`, `xtan` etc that are within 1ulp;
Their base forms are accurate to within 2ulp (AFAICT).
Functions without this varientent form (eg `xexp`) are already accurace to within 1ulp (also AFAICT).

`xilogb` is only available with `Float64`, idk why, its just not defined in SLEEF for single precision floats.


# See Also

 - Fine work happening at [Libm.jl](https://github.com/JuliaMath/Libm.jl), where a pure julia sleef port in in progress
 - [SLEEF](https://github.com/shibatch/sleef)
 - [Future of OpenLibm in julia (Julia Issue #18102)](https://github.com/JuliaLang/julia/issues/18102)
 - [Yeppp.jl](https://github.com/JuliaMath/Yeppp.jl): Julia bindings for Yeppp!: another SIMD math library. Whereas SLEEF optimises math operations over scalars using SIMD; Yeppp! optimises math operations over vectors -- which honestly makes a lot more sense given what SIMD stands for. 
