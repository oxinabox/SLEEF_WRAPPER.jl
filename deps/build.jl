using BinDeps

@BinDeps.setup

sleef = library_dependency("sleef")

provides(Sources, URI("http://shibatch.sourceforge.net/download/sleef-2.80.tar.gz"), sleef, SHA="d6c2314aee8c5201ca79237784aa2bb4fb3bbc727efa2f4386f04ad3d1bc0050")

prefix = usrdir(sleef)
sleefsrcdir = joinpath(srcdir(sleef), "sleef-2.80/simd")

const CCOPTS = `-O -Wall -Wno-unused -Wno-attributes -lm`
const CC = `gcc`
const ARCHOPTS = `-DENABLE_SSE2 -msse2`

provides(BuildProcess,
    (@build_steps begin
        GetSources(sleef)
        @build_steps begin
            ChangeDirectory(sleefsrcdir)
            FileRule(joinpath(libdir(sleef), "libsleef.so"),
                @build_steps begin
                    CreateDirectory(joinpath(prefix, "lib"))
                    `$CC -c -fPIC $CCOPTS $ARCHOPTS sleefsimddp.c -o sleefsimddp.o`
                    `$CC -c -fPIC $CCOPTS $ARCHOPTS sleefsimdsp.c -o sleefsimdsp.o`
					`$CC sleefsimdsp.o sleefsimddp.o -shared -o libsleef.so`
					`cp libsleef.so $prefix/lib/libsleef.so`
                end)
        end
    end), sleef)

@BinDeps.install Dict([(:sleef, :libsleef)])
