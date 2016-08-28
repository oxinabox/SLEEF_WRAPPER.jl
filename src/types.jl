# ccall will call the Conversions we have defined
# TODO: I am dubious about all of this; check it all.

using Base.Cartesian.@ntuple

@inline vinit8{T}(x::T) = Base.Cartesian.@ntuple 8 k->k==1 ? x : zero(T)
@inline vinit4{T}(x::T) = Base.Cartesian.@ntuple 4 k->k==1 ? x : zero(T)
@inline vinit2{T}(x::T) = Base.Cartesian.@ntuple 2 k->k==1 ? x : zero(T)

##Float64
typealias __m256d NTuple{4, VecElement{Float64}}
Base.convert(::Type{__m256d}, x::Float64) = __m256d(vinit4(x))
Base.convert(::Type{Float64}, x::__m256d) = first(x).value

typealias __m128d NTuple{2, VecElement{Float64}}
Base.convert(::Type{__m128d}, x::Float64) = __m128d(vinit2(x))
Base.convert(::Type{Float64}, x::__m128d) = first(x).value

##Float32
typealias __m256 NTuple{8, VecElement{Float32}}
Base.convert(::Type{__m256}, x::Float32) = __m256(vinit8(x))
Base.convert(::Type{Float32}, x::__m256) = first(x).value


typealias __m128 NTuple{4, VecElement{Float32}}
Base.convert(::Type{__m128}, x::Float32) = __m128(vinit4(x))
Base.convert(::Type{Float32}, x::__m128) = first(x).value

##Int32
typealias __m256i NTuple{8, VecElement{Int32}}
Base.convert(::Type{__m256i}, x::Float32) = __m256i(vinit8(x))
Base.convert(::Type{Int32}, x::__m256i) = first(x).value

typealias __m128i NTuple{4, VecElement{Int32}}
Base.convert(::Type{__m128i}, x::Float32) = __m128i(vinit4(x))
Base.convert(::Type{Int32}, x::__m128i) = first(x).value



##########

if SIMD_ARCH == "sse2"
	typealias VDouble __m128d
	typealias VInt __m128i
	typealias VFloat __m128
	typealias VInt2 __m128i

elseif SIMD_ARCH == "avx" || SIMD_ARCH == "fma4"
	typealias VDouble __m256d
	typealias VInt __m128i
	typealias VFloat __m256

	immutable VInt2
		x::VInt
		y::VInt
	end
elseif SIMD_ARCH == "AVX2"
	typealias VDouble __m256d
	typealias VInt __m128i
	typealias VFloat __m256
	typealias VInt2 __m256i
elseif SIMD_ARCH == "purec"
	typealias VDouble Float64
	typealias VInt Int32
	typealias VFloat Float32
	typealias VInt2 Int32
else
	error("SIMD instruction set: $(SIMD_ARCH). Not Supported. This error should never occur. Please report this bug.")
end

###########
#Always:

immutable VDouble2
	x::VDouble
	y::VDouble
end
Base.convert(::Type{Tuple{Float64,Float64}}, d::VDouble2) = (convert(Float64, d.x), convert(Float64, d.y))

immutable VFloat2
	x::VFloat
	y::VFloat
end
Base.convert(::Type{Tuple{Float32,Float32}}, d::VFloat2) = (convert(Float32, d.x), convert(Float32, d.y))



