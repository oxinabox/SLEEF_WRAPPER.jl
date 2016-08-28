using BinDeps

@BinDeps.setup

sleef = library_dependency("sleef")

provides(Sources, URI("http://shibatch.sourceforge.net/download/sleef-2.80.tar.gz"), sleef, SHA="d6c2314aee8c5201ca79237784aa2bb4fb3bbc727efa2f4386f04ad3d1bc0050")

prefix = usrdir(sleef)
sleefsrcdir = joinpath(srcdir(sleef), "sleef-2.80/simd")

const CCOPTS = split("-O -Wall -Wno-unused -Wno-attributes -lm")
const ARCHOPTS = ["-DENABLE_SSE2", "-msse2"]

#HACK we call it `sleef.so` even if it is a Mac dylib
const LIBBUILTOPTS = is_apple() ? `-dynamiclib` : `-shared`

provides(SimpleBuild,
    (@build_steps begin
        GetSources(sleef)
        @build_steps begin
            ChangeDirectory(sleefsrcdir)
            FileRule(joinpath(prefix,"lib", "sleef.so"),
                @build_steps begin
                    CreateDirectory(joinpath(prefix, "lib"))
					#`$CC -c -fPIC $CCOPTS $ARCHOPTS sleefsimddp.c -o sleefsimddp.o`
                    #`$CC -c -fPIC $CCOPTS $ARCHOPTS sleefsimdsp.c -o sleefsimdsp.o`
					CCompile("sleefsimddp.c", "sleefsimddp.o", [CCOPTS; "-c"; "-fPIC"; ARCHOPTS],String[])
					CCompile("sleefsimdsp.c", "sleefsimdsp.o", [CCOPTS; "-c"; "-fPIC"; ARCHOPTS],String[])
					`gcc sleefsimdsp.o sleefsimddp.o $LIBBUILTOPTS -o sleef.so`
					#CCompile("sleefsimddp.o sleefsimdsp.o", "sleef.so", [LIBBUILTOPTS]], String[] )
					`cp sleef.so $prefix/lib/sleef.so`
                end
				)
        end
    end), sleef)

@BinDeps.install Dict([(:sleef, :jl_sleef)])
