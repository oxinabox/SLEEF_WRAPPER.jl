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


include("types.jl")


##########

function float32name(fname::Symbol)
	name_parts = split(string(fname),"_")
	new_name = name_parts[1]*"f"
	if length(name_parts) > 1
		new_name *= "_"*join(name_parts[2:end])
	end
	Symbol(new_name)
end


#########


for fname in (:xsin,  :xcos,  :xtan,  :xasin,  :xacos,  :xatan,  :xexp,  :xsinh,  :xcosh,  :xtanh,  :xasinh,  :xacosh,  :xatanh,  :xcbrt,  :xexp2,  :xexp10,  :xexpm1, :xsin_u1, :xcos_u1, :xtan_u1,  :xasin_u1,  :xacos_u1,  :xatan_u1, :xcbrt_u1)
	@eval begin
		function $fname(a::Float64)
			ret = ccall(($(QuoteNode(fname)), jl_sleef),VDouble,(VDouble,), a)
			Base.convert(Float64, ret)
		end

		function $fname(a::Float32)
			ret = ccall(($(QuoteNode(float32name(fname))), jl_sleef),VFloat,(VFloat,), a)
			Base.convert(Float32, ret)
		end
	end
end

for fname in (:xlog, :xlog10, :xlog_u1)
	@eval begin
		function $fname(a::Float64)
			isnan(a) || a >= 0.0 || throw(DomainError())
			ret = ccall(($(QuoteNode(fname)), jl_sleef),VDouble,(VDouble,), a)
			Base.convert(Float64, ret)
		end

		function $fname(a::Float32)
			isnan(a) || a >= 0f0 || throw(DomainError())
			ret = ccall(($(QuoteNode(float32name(fname))), jl_sleef),VFloat,(VFloat,), a)
			Base.convert(Float32, ret)
		end
	end
end

function xlog1p(a::Float64)
	isnan(a) || a >= -1.0 || throw(DomainError())
	ret = ccall((:xlog1p, jl_sleef),VDouble,(VDouble,), a)
	Base.convert(Float64, ret)
end

function xlog1p(a::Float32)
	isnan(a) || a >= -1f0 || throw(DomainError())
	ret = ccall((:xlog1pf, jl_sleef),VFloat,(VFloat,), a)
	Base.convert(Float32, ret)
end




for fname in [:xsincos, :xsincos_u1]
	@eval begin
		function $fname(a::Float64)
			ret = ccall(($(QuoteNode(fname)), jl_sleef),VDouble2,(VDouble,), a)
			Base.convert(Tuple{Float64,Float64}, ret)
		end

		function $fname(a::Float32)
			ret = ccall(($(QuoteNode(float32name(fname))), jl_sleef),VFloat2,(VFloat,), a)
			Base.convert(Tuple{Float32,Float32}, ret)
		end
	end
end


for fname in [:xatan2, :xpow, :xatan2_u1]
	@eval begin
		function $fname(a::Float64, b::Float64)
			ret = ccall(($(QuoteNode(fname)), jl_sleef),VDouble,(VDouble,VDouble), a, b)
			Base.convert(Float64, ret)
		end

		function $fname(a::Float32, b::Float32)
			ret = ccall(($(QuoteNode(float32name(fname))), jl_sleef),VFloat,(VFloat,VFloat), a, b)
			Base.convert(Float32, ret)
		end
	end
end



function xldexp(x::Float64, q::Int32)
	ret = ccall((:xldexp, jl_sleef),VDouble,(VDouble, VInt), xv, qv)
	Base.convert(Float64, ret)
end

function xldexp(x::Float32, q::Int32)
	ret = ccall((:xldexpf, jl_sleef),VDouble,(VFloat, VInt2), x, q)
	Base.convert(Float64, ret)
end



function xilogb(a::Float64) #Does not come in Float32 flavor
	ret = ccall((:xilogb, jl_sleef),VInt,(VDouble,), a)
	convert(Int32, ret)
end


##############################


end # SLEEF Module
