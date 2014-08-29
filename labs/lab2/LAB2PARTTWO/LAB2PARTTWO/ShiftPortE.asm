/*Lab 2 Part 2
* Name:		Brandon Pollack
* Section #:	1524
* TA Name:	Ivan
* Description: rotate port e left*/
 SHIFTPORTE:
 lds R16, PORTE_OUT
 ROL R16
 sts PORTE_OUT, R16

 rjmp SPEEDCHECK
