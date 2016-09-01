module SLEEF

export xsin,  xcos,  xtan,  xasin,  xacos,  xatan,  xlog,
	xexp,  xsinh,  xcosh,  xtanh,  xasinh,  xacosh,  xatanh,
	xcbrt,  xexp2,  xexp10,  xexpm1,  xlog10,  xlog1p,
	xsin_u1, xcos_u1,  xtan_u1,  xasin_u1,
	xacos_u1,  xatan_u1,  xlog_u1,  xcbrt_u1,
	xsincos, xsincos_u1, xatan2, xatan2_u1, xpow,
	xldexp, xilogb


if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("SLEEF not properly installed. Please run Pkg.build(\"SLEEF\")")
end


include("sleef_inner.jl")

##############################


end # SLEEF Module
