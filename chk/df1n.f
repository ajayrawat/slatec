*DECK DF1N
      DOUBLE PRECISION FUNCTION DF1N (X)
C***BEGIN PROLOGUE  DF1N
C***PURPOSE  Subsidiary to
C***LIBRARY   SLATEC
C***AUTHOR  (UNKNOWN)
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   ??????  DATE WRITTEN
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C***END PROLOGUE  DF1N
      DOUBLE PRECISION X
C***FIRST EXECUTABLE STATEMENT  DF1N
      DF1N=1.0D0/(X**4+X**2+1.0D0)
      RETURN
      END