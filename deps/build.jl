using BinDeps
include("./cpuarch_detect.jl")

@BinDeps.setup

sleef = library_dependency("sleef")

provides(Sources, URI("http://shibatch.sourceforge.net/download/sleef-2.80.tar.gz"), sleef, SHA="d6c2314aee8c5201ca79237784aa2bb4fb3bbc727efa2f4386f04ad3d1bc0050")

prefix = usrdir(sleef)



#Hack for ordered dict -- don't create dict, just tuple of pairs
const simd_opts = (
"fma4" => ["-DENABLE_FMA4", "-mavx", "-mfma4"],
"avx2" => ["-DENABLE_AVX2", "-mavx2", "-mfma"],
"avx" => ["-DENABLE_AVX", "-mavx"],
"sse2" => ["-DENABLE_SSE2", "-msse2"],
# ARM NEON support is not quiet yet written
#"neon" => ["-DENABLE_NEON", "-mfloat-abi=softfp", "-mfpu=neon", "-static"]
)

const simd_flags = map(first, simd_opts)
const SIMD_ARCH = find_cpuflag(simd_flags, "purec", "JLSLEEF_ARCH")


if SIMD_ARCH=="purec"
	sleefsrcdir = joinpath(srcdir(sleef), "sleef-2.80/purec")
	const ARCHOPTS = String[]
	const prebuild = @build_steps begin
		`echo "building for No SIMD"`
	end
else
	sleefsrcdir = joinpath(srcdir(sleef), "sleef-2.80/simd")
	const ARCHOPTS = Dict(simd_opts)[SIMD_ARCH]
	const prebuild = @build_steps begin
		`echo "building for $SIMD_ARCH SIMD"`
		`ln -s sleefsimddp.c sleefdp.c`
		`ln -s sleefsimdsp.c sleefsp.c`
	end

end

const CCOPTS = split("-O -Wall -Wno-unused -Wno-attributes -lm")

if is_apple()
	const LIBBUILTOPTS = `-dynamiclib`
	const LIBFN = "sleef.dylib"
elseif is_linux()
	const LIBBUILTOPTS = `-shared`
	const LIBFN = "sleef.so"
else
	@assert is_windows()
	error("Windows not currently supported.")
end



provides(SimpleBuild,
    (@build_steps begin
        GetSources(sleef)
        @build_steps begin
            ChangeDirectory(sleefsrcdir)
            FileRule(joinpath(prefix,"lib", LIBFN),
                @build_steps begin
                    CreateDirectory(joinpath(prefix, "lib"))
					prebuild
					CCompile("sleefdp.c", "sleefdp.o", [CCOPTS; "-c"; "-fPIC"; ARCHOPTS],String[])
					CCompile("sleefsp.c", "sleefsp.o", [CCOPTS; "-c"; "-fPIC"; ARCHOPTS],String[])
					`gcc $LIBBUILTOPTS -o $LIBFN sleefsp.o sleefdp.o`
					#CCompile("sleefsimddp.o sleefsimdsp.o",LIBFN, [LIBBUILTOPTS]], String[] )
					`cp $LIBFN $(joinpath(prefix,"lib",LIBFN))`
                end
				)
        end
    end), sleef)

@BinDeps.install Dict([(:sleef, :jl_sleef)])

# Write the SIMD_ARCH to the deps.jl file. 
# Recording what SIMD_ARCH was it build for is part of the deps
# and we need to make that available to the dep's consuming code
open(joinpath(BinDeps.depsdir(sleef), "deps.jl"), "a") do fp
	println(fp, "\nconst SIMD_ARCH = \"$(SIMD_ARCH)\"")
end

