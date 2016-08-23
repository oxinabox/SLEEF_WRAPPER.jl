julia> typealias VDouble NTuple{2, VecElement{Float64}}
Tuple{VecElement{Float64},VecElement{Float64}}


julia> VDouble((0.5,0.5))
(VecElement{Float64}(0.5),VecElement{Float64}(0.5))

julia> ccall((:xcos_u1,"libsleefsse2.so"),VDouble,(VDouble,), VDouble((0.5,0.5)))
(VecElement{Float64}(0.8775825618903728),VecElement{Float64}(0.8775825618903728))

julia> cos(0.5)
0.8775825618903728

