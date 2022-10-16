This is simple library for polynomial manipulation that I develop as a passion project that combines both math and functional programming.
The algorithms I have so far implemented are "naive" and might get expanded in the future (e.g. Karatsuba's algorithm).
This library so far supports only univarite polynomials and I support for the multivariate ones is on the way.
<br>
<br>
In this library univariate polynomials are represented as lists. for example x^2 + 1 would be represented as [1,0,1]. 
Sparse representation might be implemented down the line.<br>
This library is not used for parsing although that might be implemented down the line.
<br>
<br>
Pol has normal functions for addition, multiplication and exponentiation as well as sffactor which stands for square free factorization of 
a given polynomial. Gcd is used to find GCD of two numbers or of two polynomials. If you want to find GCD of two polynomials in Z[x] use
primitive_euclidian defined in Pol. get_pol in Gcd is valid only if you are looking for a gcd in F[x] where F is a field (usually rationals or integers modulo prime).

