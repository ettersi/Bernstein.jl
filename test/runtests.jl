using BernsteinEllipses
using BernsteinEllipses: rsmo, radius, semimajor, semiminor

using Test

const BitsFloats = (Float32,Float64)
const Floats = (BitsFloats..., BigFloat)
const Reals = (Int, Floats...)
rnc(reals::Type) = (reals,complex.(reals))
rnc(reals::Tuple) = (reals...,complex.(reals)...)

@testset "rsmo" begin
    for T in rnc(Reals)
        @inferred rsmo(one(T))
    end

    @test rsmo(π) ≈ rsmo(big(π))
    @test rsmo(π*im) ≈ rsmo(big(π)*im)

    # Because integer types do not have a signed zero, (-im)^2 gets mapped
    # to the second quadrant (-1+0im) instead of the third (-1-im).
    # Make sure rsmo takes care of this case.
    @test rsmo(-im) == rsmo(-1.0im)

    x = -2.0; @test rsmo(complex(x,0.0)) == rsmo(complex(x,-0.0))
    x = -1.0; @test rsmo(complex(x,0.0)) == rsmo(complex(x,-0.0))
    x =  1.0; @test rsmo(complex(x,0.0)) == rsmo(complex(x,-0.0))
    x =  2.0; @test rsmo(complex(x,0.0)) == rsmo(complex(x,-0.0))

    y = -2.0; @test rsmo(complex(0.0,y)) == rsmo(complex(-0.0,y))
    y = -1.0; @test rsmo(complex(0.0,y)) == rsmo(complex(-0.0,y))
    y =  0.0; @test rsmo(complex(0.0,y)) == rsmo(complex(-0.0,y))
    y =  1.0; @test rsmo(complex(0.0,y)) == rsmo(complex(-0.0,y))
    y =  2.0; @test rsmo(complex(0.0,y)) == rsmo(complex(-0.0,y))

    x = -0.5; @test rsmo(complex(x,0.0)) == -rsmo(complex(x,-0.0))
    x =  0.0; @test rsmo(complex(x,0.0)) == -rsmo(complex(x,-0.0))
    x =  0.5; @test rsmo(complex(x,0.0)) == -rsmo(complex(x,-0.0))
end

@testset "jouk" begin
    for T in rnc(Reals)
        @inferred jouk(one(T))
        @inferred ijouk(one(T))
        @inferred ijouk(one(T),halfplane=Val(false),branch=Val(true))
        @inferred ijouk(one(T),halfplane=Val(false),branch=Val(false))
        @inferred ijouk(one(T),halfplane=Val(true),branch=Val(true))
        @inferred ijouk(one(T),halfplane=Val(true),branch=Val(false))
    end

    @test jouk(ijouk(π   )) ≈ π
    @test jouk(ijouk(π*im)) ≈ π*im
    @test jouk(ijouk(big(π)   )) ≈ π
    @test jouk(ijouk(big(π)*im)) ≈ π*im
    @test jouk(ijouk(1/π ,halfplane=Val(true))) ≈ 1/π
    @test jouk(ijouk(π*im,halfplane=Val(true))) ≈ π*im
    @test jouk(ijouk(1/big(π) ,halfplane=Val(true))) ≈ 1/big(π)
    @test jouk(ijouk(big(π)*im,halfplane=Val(true))) ≈ π*im

    for x in LinRange(-1,1,11)
        @test ijouk(complex(x,+0.0)) ≈ 1/ijouk(complex(x,-0.0))
        if x != 0
            @test ijouk(complex(1/x,+0.0), halfplane=Val(true)) ≈ 1/ijouk(complex(1/x,-0.0), halfplane=Val(true))
        end
    end

    @test abs(ijouk(π*im)) >= 1
    @test abs(ijouk(π*im, branch=Val(false))) <= 1
    @test imag(ijouk(π*im, halfplane=Val(true))) >= 0
    @test imag(ijouk(π*im, halfplane=Val(true), branch=Val(false))) <= 0
end

@testset "radius & friends" begin
    for T in rnc(Reals)
        @inferred radius(one(T))
        @inferred semimajor(one(T))
        @inferred semiminor(one(T))
        @inferred semiminor(one(T),one(real(T)))
    end

    @test radius(1) ≈ 1
    @test radius(1+1/4) ≈ 2
    @test radius(1+1/big(4)) ≈ big(2)
    @test semimajor(π) ≈ π
    @test semimajor(big(π)) ≈ big(π)
    @test semiminor(π*im) ≈ π
    @test semiminor(big(π)*im) ≈ big(π)
    @test semiminor(ComplexF64(π,ℯ),π) ≈ ℯ
    @test semiminor(Complex{BigFloat}(π,ℯ),big(π)) ≈ big(ℯ)
end
