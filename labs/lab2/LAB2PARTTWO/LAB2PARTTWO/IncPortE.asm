/*Lab 2 Part 2
* Name:		Brandon Pollack
* Section #:	1524
* TA Name:	Ivan
* Description: inc port e*/
 INCPORTE:
 lds R16, PORTE_OUT
 inc R16
 sts PORTE_OUT, R16
 
 rjmp SPEEDCHECK