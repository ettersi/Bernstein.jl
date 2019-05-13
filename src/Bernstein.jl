module Bernstein

export jouk, ijouk

"""
    rsmo(x)

Evaluate `√(x^2-1)` with branch cut along `[-1,1]`.

The function name is the abbreviation of "root of square minus one".
"""
rsmo(x) = rsmo(float(x))
rsmo(x::Union{T,Complex{T}}) where {T<:AbstractFloat} = ifelse(!signbit(real(x)),1,-1)*sqrt(x^2-1)

"""
    jouk(z)

Joukowsky map `(z+z^-1)/2`.
"""
jouk(z) = (z+inv(z))/2

"""
    ijouk(x; halfplane=Val(false), branch=Val(true))

Inverse Joukowsky map `x ± √(x^2-1)`. The result `z` is
determined as follows.

+-----------+---------------+----------------+
|           | `!halfplane`  |  `halfplane`   |
+-----------+---------------+----------------+
| ` branch` | `abs(z) >= 1` | `imag(z) >= 0` |
| `!branch` | `abs(z) <= 1` | `imag(z) <= 0` |
+-----------+---------------+----------------+

"""
ijouk(x; halfplane=Val(false), branch=Val(true)) = ijouk(x,halfplane,branch)
ijouk(x,::Val{false},::Val{true} ) = x + rsmo(x)
ijouk(x,::Val{false},::Val{false}) = x - rsmo(x)
ijouk(x,::Val{true} ,::Val{true} ) = x + im*sqrt(1-x^2)
ijouk(x,::Val{true} ,::Val{false}) = x - im*sqrt(1-x^2)


"""
   radius(x; kwargs...) = abs(ijouk(x; kwargs...))
"""
radius(x; kwargs...) = abs(ijouk(x; kwargs...))

"""
   semimajor(x; kwargs...)

Semi-major axis of the Bernstein ellipse through `x`.

See [`ijouk`](@ref) regardings `kwargs`.
"""
semimajor(x; kwargs...) = (w = abs(ijouk(x; kwargs...)); (w+inv(w))/2)

"""
   semiminor(x; kwargs...)

Semi-minor axis of the Bernstein ellipse through `x`.

See [`ijouk`](@ref) regardings `kwargs`.
"""
semiminor(x; kwargs...) = (w = abs(ijouk(x; kwargs...)); (w-inv(w))/2)

"""
    semiminor(x,xr)

Imaginary component of the point in the upper half-plane
where the line `{ x̃ | real(x̃) = xr }` intersects the Bernstein
ellipse through `x`.
"""
function semiminor(x::Number,xr::Real; kwargs...)
    a = semimajor(x; kwargs...)
    b = semiminor(x; kwargs...)
    return b*sqrt(1 - (xr/a)^2)
end

end # module
