using BinDeps

@BinDeps.setup

sleef = library_dependency("sleef")

provides(Sources, URI("http://shibatch.sourceforge.net/download/sleef-2.80.tar.gz"), sleef, SHA="d6c2314aee8c5201ca79237784aa2bb4fb3bbc727efa2f4386f04ad3d1bc0050")

prefix = usrdir(sleef)
sleefsrcdir = joinpath(srcdir(sleef), "sleef-2.80/simd")

const CCOPTS = split("-O -Wall -Wno-unused -Wno-attributes -lm")
const ARCHOPTS = ["-DENABLE_SSE2", "-msse2"]


if is_apple()
	const LIBBUILTOPTS = `-dynamiclib`
	const LIBFN = "sleef.dynlib"
elseif is_unix()
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
					#`$CC -c -fPIC $CCOPTS $ARCHOPTS sleefsimddp.c -o sleefsimddp.o`
                    #`$CC -c -fPIC $CCOPTS $ARCHOPTS sleefsimdsp.c -o sleefsimdsp.o`
					CCompile("sleefsimddp.c", "sleefsimddp.o", [CCOPTS; "-c"; "-fPIC"; ARCHOPTS],String[])
					CCompile("sleefsimdsp.c", "sleefsimdsp.o", [CCOPTS; "-c"; "-fPIC"; ARCHOPTS],String[])
					`gcc $LIBBUILTOPTS -o $LIBFN sleefsimdsp.o sleefsimddp.o`
					#CCompile("sleefsimddp.o sleefsimdsp.o",LIBFN, [LIBBUILTOPTS]], String[] )
					`cp $LIBFN $(joinpath(prefix,"lib",LIBFN))`
                end
				)
        end
    end), sleef)

@BinDeps.install Dict([(:sleef, :jl_sleef)])
