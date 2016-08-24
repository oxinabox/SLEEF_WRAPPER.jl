# This file is derived from parts of Julia's math tests from https://github.com/JuliaLang/julia/blob/master/test/math.jl

# Test math functions. We compare to BigFloat instead of hard-coding
# values, assuming that BigFloat has an independent and independently
# tested implementation.
for T in (Float32, Float64)
    x = T(1//3)
    y = T(1//2)
    yi = 4
    # Test random values
    @test xacos(x) ≈ acos(big(x))
    @test xacos_u1(x) ≈ acos(big(x))
    @test xacosh(1+x) ≈ acosh(big(1+x))
    @test xasin(x) ≈ asin(big(x))
    @test xasin_u1(x) ≈ asin(big(x))
    @test xasinh(x) ≈ asinh(big(x))
    @test xatan(x) ≈ atan(big(x))
    @test xatan_u1(x) ≈ atan(big(x))
    @test xatan2(x,y) ≈ atan2(big(x),big(y))
    @test xatan2_u1(x,y) ≈ atan2(big(x),big(y))
    @test atanh(x) ≈ atanh(big(x))
    @test xatanh(x) ≈ atanh(big(x))
    @test xcbrt(x) ≈ cbrt(big(x))
    @test xcos(x) ≈ cos(big(x))
    @test xcos_u1(x) ≈ cos(big(x))
    @test xcosh(x) ≈ cosh(big(x))
    @test xexp(x) ≈ exp(big(x))
    @test xexp10(x) ≈ exp10(big(x))
    @test xexp2(x) ≈ exp2(big(x))
    @test xexpm1(x) ≈ expm1(big(x))
    @test xlog(x) ≈ log(big(x))
    @test xlog_u1(x) ≈ log(big(x))
    @test xlog10(x) ≈ log10(big(x))
    @test xlog1p(x) ≈ log1p(big(x))
    @test xsin(x) ≈ sin(big(x))
    @test xsin_u1(x) ≈ sin(big(x))
    @test xsinh(x) ≈ sinh(big(x))
    @test xtan(x) ≈ tan(big(x))
    @test xtan_u1(x) ≈ tan(big(x))
    @test tanh(x) ≈ tanh(big(x))

    # Test special values
    @test isequal(xacos(T(1)), T(0))
    @test isequal(xacosh(T(1)), T(0))
    @test_approx_eq_eps xasin(T(1)) T(pi)/2 eps(T)
    @test_approx_eq_eps xasin_u1(T(1)) T(pi)/2 eps(T)
    @test_approx_eq_eps xatan(T(1)) T(pi)/4 eps(T)
    @test_approx_eq_eps xatan_u1(T(1)) T(pi)/4 eps(T)
    @test_approx_eq_eps xatan2(T(1),T(1)) T(pi)/4 eps(T)
    @test_approx_eq_eps xatan2_u1(T(1),T(1)) T(pi)/4 eps(T)
    @test isequal(xcbrt(T(0)), T(0))
    @test isequal(xcbrt(T(1)), T(1))
    @test isequal(xcbrt(T(1000000000)), T(1000))
    @test isequal(xcos(T(0)), T(1))
    @test isequal(xcos_u1(T(0)), T(1))
    @test_approx_eq_eps xcos(T(pi)/2) T(0) eps(T)
    @test_approx_eq_eps xcos_u1(T(pi)/2) T(0) eps(T)
    @test isequal(xcos(T(pi)), T(-1))
    @test isequal(xcos_u1(T(pi)), T(-1))
    @test_approx_eq_eps xexp(T(1)) T(e) 10*eps(T)
    @test isequal(xexp10(T(1)), T(10))
    @test isequal(xexp2(T(1)), T(2))
    @test isequal(xexpm1(T(0)), T(0))
    @test_approx_eq_eps xexpm1(T(1)) T(e)-1 10*eps(T)
    @test isequal(xlog(T(1)), T(0))
    @test isequal(xlog_u1(T(1)), T(0))
    @test_approx_eq_eps xlog(T(e)) T(1) eps(T)
    @test_approx_eq_eps xlog_u1(T(e)) T(1) eps(T)
    @test isequal(xlog10(T(1)), T(0))
    @test isequal(xlog10(T(10)), T(1))
    @test isequal(xlog1p(T(0)), T(0))
    @test_approx_eq_eps xlog1p(T(e)-1) T(1) eps(T)
    @test isequal(xsin(T(0)), T(0))
    @test isequal(xsin_u1(T(0)), T(0))
    @test isequal(xsin(T(pi)/2), T(1))
    @test isequal(xsin_u1(T(pi)/2), T(1))
    @test_approx_eq_eps xsin(T(pi)) T(0) eps(T)
    @test_approx_eq_eps xsin_u1(T(pi)) T(0) eps(T)
    @test isequal(xtan(T(0)), T(0))
    @test isequal(xtan_u1(T(0)), T(0))
    @test_approx_eq_eps xtan(T(pi)/4) T(1) eps(T)
    @test_approx_eq_eps xtan_u1(T(pi)/4) T(1) eps(T)

    # Test inverses
    @test xacos(xcos(x)) ≈ x
    @test xacos_u1(xcos_u1(x)) ≈ x
    @test xacosh(xcosh(x)) ≈ x
    @test xasin(xsin(x)) ≈ x
    @test xasin_u1(xsin_u1(x)) ≈ x
    @test xcbrt(x)^3 ≈ x
    @test xcbrt_u1(x)^3 ≈ x
    @test xcbrt_u1(x^3) ≈ x
    @test xasinh(xsinh(x)) ≈ x
    @test xatan(xtan(x)) ≈ x
    @test xatan_u1(xtan_u1(x)) ≈ x
    @test xatan2(x,y) ≈ xatan(x/y)
    @test xatan2_u1(x,y) ≈ xatan_u1(x/y)
    @test xatanh(xtanh(x)) ≈ x
    @test xcos(xacos(x)) ≈ x
    @test xcos_u1(xacos_u1(x)) ≈ x
    @test xcosh(xacosh(1+x)) ≈ 1+x
    @test xexp(log(x)) ≈ x
    @test xexp10(log10(x)) ≈ x
    @test xexp2(log2(x)) ≈ x
    @test xexpm1(log1p(x)) ≈ x
    @test xlog(xexp(x)) ≈ x
    @test xlog10(xexp10(x)) ≈ x
    @test xlog1p(xexpm1(x)) ≈ x
    @test xsin(xasin(x)) ≈ x
    @test xsin_u1(xasin_u1(x)) ≈ x
    @test xsinh(xasinh(x)) ≈ x
    @test xtan(xatan(x)) ≈ x
    @test xtan_u1(xatan_u1(x)) ≈ x
    @test xtanh(xatanh(x)) ≈ x

    # Test some properties
    @test xcosh(x) ≈ (xexp(x)+xexp(-x))/2
    @test xcosh(x)^2-xsinh(x)^2 ≈ 1
    @test xsin(x)^2+xcos(x)^2 ≈ 1
    @test xsin_u1(x)^2+xcos_u1(x)^2 ≈ 1
    @test xsinh(x) ≈ (xexp(x)-xexp(-x))/2
    @test xtan(x) ≈ xsin(x)/xcos(x)
    @test xtan_u1(x) ≈ xsin_u1(x)/xcos_u1(x)
    @test xtanh(x) ≈ xsinh(x)/xcosh(x)

    #Edge cases
    @test isinf(xlog(zero(T)))
    @test isnan(xlog(convert(T,NaN)))
    @test isinf(xlog1p(-one(T)))
    @test isnan(xlog1p(convert(T,NaN)))
	@test_throws DomainError xlog(-one(T))
	@test_throws DomainError xlog1p(convert(T,-2.0))

end


