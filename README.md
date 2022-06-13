# sha_gen.sh
The bash script sha_gen.sh was built to provide evidence for the following conjecture.
For all pairs ($a$, $b$) with $1 \leq a \lt b$ and $b \neq 2a$, there exists an infinite
binary sequence with ($a$, $b$) as a pseudoperiod, and avoiding 3+-powers

This bash script is intended to be used with Walnut, an automated theorem prover for automatic words, see https://github.com/DistortedLight/Walnut.git.

Place the sha_gen.sh and og_gen.c in the bin folder in Walnut then run sha_gen.sh. 
The file clean.sh is optional. It removes all the output generated from running sha_gen.sh.  

The folder Outputs generated contains the output generated from running sha_gen.sh for about 10 days. 
