# BernsteinEllipses.jl

[![Build Status](https://travis-ci.org/ettersi/Bernstein.jl.svg?branch=master)](https://travis-ci.org/ettersi/BernsteinEllipses.jl)
[![codecov.io](http://codecov.io/github/ettersi/Bernstein.jl/coverage.svg?branch=master)](http://codecov.io/github/ettersi/BernsteinEllipses.jl?branch=master)

Convenience functions for working with Bernstein ellipses.

Exported functions:

 - `jouk(z)`: Forward Joukowsky map `jouk(z) = (z + inv(z))/2`.
 - `ijouk(x)`: Inverse Joukowsky map. Different branches of this map can be selected using keywords arguments.

Unexported functions due to likely name clashes:

 - `radius(x) = abs(ijouk(x))`
 - `semimajor(x)`: Semi-major axis of the Bernstein ellipse through `x`.
 - `semiminor(x)`: Semi-minor axis of the Bernstein ellipse through `x`.
 - `semiminor(x,xr)`: Imaginary component of the point in the upper half-plane where the line `{ x̃ | real(x̃) = xr }` intersects the Bernstein ellipse through `x`.
