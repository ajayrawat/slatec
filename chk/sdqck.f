*DECK SDQCK
      SUBROUTINE SDQCK (LUN, KPRINT, IPASS)
C***BEGIN PROLOGUE  SDQCK
C***PURPOSE  Quick check for SLATEC routines SDRIV1, SDRIV2 and SDRIV3.
C***LIBRARY   SLATEC (SDRIVE)
C***CATEGORY  I1A2, I1A1B
C***TYPE      SINGLE PRECISION (SDQCK-S, DDQCK-D, CDQCK-C)
C***KEYWORDS  QUICK CHECK, SDRIV1, SDRIV2, SDRIV3
C***AUTHOR  Kahaner, D. K., (NIST)
C             National Institute of Standards and Technology
C             Gaithersburg, MD  20899
C           Sutherland, C. D., (LANL)
C             Mail Stop D466
C             Los Alamos National Laboratory
C             Los Alamos, NM  87545
C***DESCRIPTION
C
C  For assistance in determining the cause of a failure of these
C  routines contact C. D. Sutherland at commercial telephone number
C  (505)667-6949, FTS telephone number 8-843-6949, or electronic mail
C  address CDS@LANL.GOV .
C
C***ROUTINES CALLED  R1MACH, SDF, SDRIV1, SDRIV2, SDRIV3, XERCLR
C***REVISION HISTORY  (YYMMDD)
C   890405  DATE WRITTEN
C   890405  Revised to meet SLATEC standards.
C***END PROLOGUE  SDQCK
      EXTERNAL SDF
      REAL ALFA, EPS, EWT(1), HMAX, R1MACH, T, TOUT
      INTEGER IERFLG, IERROR, IMPL, IPASS, KPRINT, LENIW, LENIWX, LENW,
     8        LENWMX, LENWX, LIWMX, LUN, MINT, MITER, ML, MSTATE, MU,
     8        MXORD, MXSTEP, N, NDE, NFE, NJE, NROOT, NSTATE, NSTEP,
     8        NTASK, NX
      PARAMETER(ALFA = 1.E0, HMAX = 15.E0, IERROR = 3, IMPL = 0,
     8          LENWMX = 342, LIWMX = 53, MITER = 5, ML = 2, MU = 2,
     8          MXORD = 5, MXSTEP = 1000, N = 3, NROOT = 0, NTASK = 1)
      REAL WORK(LENWMX), Y(N+1)
      INTEGER IWORK(LIWMX)
      DATA EWT(1) /.00001E0/
C***FIRST EXECUTABLE STATEMENT  SDQCK
      EPS = R1MACH(4)**(1.E0/3.E0)
      IPASS = 1
C                                            Exercise SDRIV1 for problem
C                                            with known solution.
      Y(4) = ALFA
      T = 0.E0
      Y(1) = 10.E0
      Y(2) = 0.E0
      Y(3) = 10.E0
      TOUT = 10.E0
      MSTATE = 1
      LENW = 342
      CALL SDRIV1 (N, T, Y, SDF, TOUT, MSTATE, EPS, WORK, LENW, IERFLG)
      NSTEP = WORK(LENW - (N + 50) + 3)
      NFE = WORK(LENW - (N + 50) + 4)
      NJE = WORK(LENW - (N + 50) + 5)
      IF (MSTATE .EQ. 2) THEN
        IF (ABS(1.E0 - Y(1)*1.5E0) .LE. EPS**(2.E0/3.E0) .AND.
     8  ABS(1.E0 - Y(2)*3.E0) .LE. EPS**(2.E0/3.E0) .AND.
     8  ABS(1.E0 - Y(3)) .LE. EPS**(2.E0/3.E0)) THEN
          IF (KPRINT .EQ. 2) THEN
            WRITE(LUN, '('' SDRIV1:The solution determined met '',
     8      ''the expected values.'' //)')
          ELSE IF (KPRINT .EQ. 3) THEN
            WRITE(LUN, '('' SDRIV1:The solution determined met '',
     8      ''the expected values.'')')
            WRITE(LUN, '('' The values of results are '')')
            WRITE(LUN, *) ' T ', T
            WRITE(LUN, *) ' Y(1) ', Y(1)
            WRITE(LUN, *) ' Y(2) ', Y(2)
            WRITE(LUN, *) ' Y(3) ', Y(3)
            WRITE(LUN, '(/)')
          END IF
        ELSE
          IF (KPRINT .EQ. 1) THEN
            WRITE(LUN, '('' SDRIV1:The solution determined is not '',
     8      ''accurate enough.'' //)')
          ELSE IF (KPRINT .EQ. 2) THEN
            WRITE(LUN, '('' SDRIV1:The solution determined is not '',
     8      ''accurate enough.'')')
            WRITE(LUN, '('' The values of parameters, results, and '',
     8      ''statistical quantities are:'')')
            WRITE(LUN, *) ' EPS = ', EPS
            WRITE(LUN, *) ' T ', T
            WRITE(LUN, *) ' Y(1) ', Y(1)
            WRITE(LUN, *) ' Y(2) ', Y(2)
            WRITE(LUN, *) ' Y(3) ', Y(3)
            WRITE(LUN, *)
     8      ' Number of steps taken is  ', NSTEP
            WRITE(LUN, *)
     8      ' Number of evaluations of the right hand side is  ', NFE
            WRITE(LUN, *)
     8      ' Number of evaluations of the Jacobian matrix is  ', NJE
            WRITE(LUN, '(//)')
          END IF
          IPASS = 0
        END IF
      ELSE
        IF (KPRINT .EQ. 1) THEN
          WRITE(LUN, '('' While using SDRIV1, a solution was not '',
     8    ''obtained.'' //)')
        ELSE IF (KPRINT .GE. 2) THEN
          WRITE(LUN, '('' While using SDRIV1, a solution was not '',
     8    ''obtained.'')')
          WRITE(LUN, '('' The values of parameters, results, and '',
     8    ''statistical quantities are:'')')
          WRITE(LUN, *)
     8    ' MSTATE = ', MSTATE, ', Error number = ', IERFLG
          WRITE(LUN, *) ' N ', N, ', EPS ', EPS, ', LENW ', LENW
          WRITE(LUN, *) ' T ', T
          WRITE(LUN, *) ' Y(1) ', Y(1)
          WRITE(LUN, *) ' Y(2) ', Y(2)
          WRITE(LUN, *) ' Y(3) ', Y(3)
          WRITE(LUN, *)
     8    ' Number of steps taken is  ', NSTEP
          WRITE(LUN, *)
     8    ' Number of evaluations of the right hand side is  ', NFE
          WRITE(LUN, *)
     8    ' Number of evaluations of the Jacobian matrix is  ', NJE
          WRITE(LUN, '(//)')
        END IF
        IPASS = 0
      END IF
      CALL XERCLR
C                                         Run SDRIV1 with invalid input.
      NX = 201
      T = 0.E0
      Y(1) = 10.E0
      Y(2) = 0.E0
      Y(3) = 10.E0
      Y(4) = ALFA
      TOUT = 10.E0
      MSTATE = 1
      LENW = 342
      CALL SDRIV1 (NX, T, Y, SDF, TOUT, MSTATE, EPS, WORK, LENW, IERFLG)
      IF (IERFLG .EQ. 21) THEN
        IF (KPRINT .EQ. 2) THEN
          WRITE(LUN, '('' SDRIV1:An invalid parameter has been '',
     8    ''correctly detected.'' //)')
        ELSE IF (KPRINT .EQ. 3) THEN
          WRITE(LUN, '('' SDRIV1:An invalid parameter has been '',
     8    ''correctly detected.'')')
          WRITE(LUN, *) ' The value of N was set to ', NX
          WRITE(LUN, *)
     8    ' MSTATE = ', MSTATE, ', Error number = ', IERFLG
          WRITE(LUN, '(/)')
        END IF
      ELSE
        IF (KPRINT .EQ. 1) THEN
          WRITE(LUN, '('' SDRIV1:An invalid parameter has not '',
     8    ''been correctly detected.'' //)')
        ELSE IF (KPRINT .GE. 2) THEN
          WRITE(LUN, '('' SDRIV1:An invalid parameter has not '',
     8    ''been correctly detected.'')')
          WRITE(LUN, *) ' The value of N was set to ', NX
          WRITE(LUN, *)
     8    ' MSTATE = ', MSTATE, ', Error number = ', IERFLG
          WRITE(LUN, '('' The values of parameters, results, and '',
     8    ''statistical quantities are:'')')
          WRITE(LUN, *) ' EPS ', EPS, ', LENW ', LENW
          WRITE(LUN, *) ' T ', T
          WRITE(LUN, *) ' Y(1) ', Y(1)
          WRITE(LUN, *) ' Y(2) ', Y(2)
          WRITE(LUN, *) ' Y(3) ', Y(3)
          WRITE(LUN, *)
     8    ' Number of steps taken is  ', NSTEP
          WRITE(LUN, *)
     8    ' Number of evaluations of the right hand side is  ', NFE
          WRITE(LUN, *)
     8    ' Number of evaluations of the Jacobian matrix is  ', NJE
          WRITE(LUN, '(//)')
        END IF
        IPASS = 0
      END IF
      CALL XERCLR
C                                            Exercise SDRIV2 for problem
C                                            with known solution.
      T = 0.E0
      Y(1) = 10.E0
      Y(2) = 0.E0
      Y(3) = 10.E0
      Y(4) = ALFA
      MSTATE = 1
      TOUT = 10.E0
      MINT = 1
      LENW = 298
      LENIW = 50
      CALL SDRIV2 (N, T, Y, SDF, TOUT, MSTATE, NROOT, EPS, EWT,
     8             MINT, WORK, LENW, IWORK, LENIW, SDF, IERFLG)
      NSTEP = IWORK(3)
      NFE = IWORK(4)
      NJE = IWORK(5)
      IF (MSTATE .EQ. 2) THEN
        IF (ABS(1.E0 - Y(1)*1.5E0) .LE. EPS**(2.E0/3.E0) .AND.
     8  ABS(1.E0 - Y(2)*3.E0) .LE. EPS**(2.E0/3.E0) .AND.
     8  ABS(1.E0 - Y(3)) .LE. EPS**(2.E0/3.E0)) THEN
          IF (KPRINT .EQ. 2) THEN
            WRITE(LUN, '('' SDRIV2:The solution determined met '',
     8      ''the expected values.'' //)')
          ELSE IF (KPRINT .EQ. 3) THEN
            WRITE(LUN, '('' SDRIV2:The solution determined met '',
     8      ''the expected values.'')')
            WRITE(LUN, '('' The values of results are '')')
            WRITE(LUN, *) ' T ', T
            WRITE(LUN, *) ' Y(1) ', Y(1)
            WRITE(LUN, *) ' Y(2) ', Y(2)
            WRITE(LUN, *) ' Y(3) ', Y(3)
            WRITE(LUN, '(/)')
          END IF
        ELSE
          IF (KPRINT .EQ. 1) THEN
            WRITE(LUN, '('' SDRIV2:The solution determined is not '',
     8      ''accurate enough.'' //)')
          ELSE IF (KPRINT .EQ. 2) THEN
            WRITE(LUN, '('' SDRIV2:The solution determined is not '',
     8      ''accurate enough.'')')
            WRITE(LUN, '('' The values of parameters, results, and '',
     8      ''statistical quantities are:'')')
            WRITE(LUN, *) ' EPS = ', EPS, ', EWT = ', EWT
            WRITE(LUN, *) ' T ', T
            WRITE(LUN, *) ' Y(1) ', Y(1)
            WRITE(LUN, *) ' Y(2) ', Y(2)
            WRITE(LUN, *) ' Y(3) ', Y(3)
            WRITE(LUN, *)
     8      ' Number of steps taken is  ', NSTEP
            WRITE(LUN, *)
     8      ' Number of evaluations of the right hand side is  ', NFE
            WRITE(LUN, *)
     8      ' Number of evaluations of the Jacobian matrix is  ', NJE
            WRITE(LUN, '(//)')
          END IF
          IPASS = 0
        END IF
      ELSE
        IF (KPRINT .EQ. 1) THEN
          WRITE(LUN, '('' While using SDRIV2, a solution was not '',
     8    ''obtained.'' //)')
        ELSE IF (KPRINT .GE. 2) THEN
          WRITE(LUN, '('' While using SDRIV2, a solution was not '',
     8    ''obtained.'')')
          WRITE(LUN, *)
     8    ' MSTATE = ', MSTATE, ', Error number = ', IERFLG
          WRITE(LUN, '('' The values of parameters, results, and '',
     8    ''statistical quantities are:'')')
          WRITE(LUN, *) ' EPS = ', EPS, ', EWT ', EWT
          WRITE(LUN, *)
     8    ' MINT = ', MINT, ', LENW ', LENW, ', LENIW ', LENIW
          WRITE(LUN, *) ' T ', T
          WRITE(LUN, *) ' Y(1) ', Y(1)
          WRITE(LUN, *) ' Y(2) ', Y(2)
          WRITE(LUN, *) ' Y(3) ', Y(3)
          WRITE(LUN, *)
     8    ' Number of steps taken is  ', NSTEP
          WRITE(LUN, *)
     8    ' Number of evaluations of the right hand side is  ', NFE
          WRITE(LUN, *)
     8    ' Number of evaluations of the Jacobian matrix is  ', NJE
          WRITE(LUN, '(//)')
        END IF
        IPASS = 0
      END IF
      CALL XERCLR
C                                         Run SDRIV2 with invalid input.
      T = 0.E0
      Y(1) = 10.E0
      Y(2) = 0.E0
      Y(3) = 10.E0
      Y(4) = ALFA
      TOUT = 10.E0
      MSTATE = 1
      MINT = 1
      LENWX = 1
      LENIW = 50
      CALL SDRIV2 (N, T, Y, SDF, TOUT, MSTATE, NROOT, EPS, EWT,
     8             MINT, WORK, LENWX, IWORK, LENIW, SDF, IERFLG)
      IF (IERFLG .EQ. 32) THEN
        IF (KPRINT .EQ. 2) THEN
          WRITE(LUN, '('' SDRIV2:An invalid parameter has been '',
     8    ''correctly detected.'' //)')
        ELSE IF (KPRINT .EQ. 3) THEN
          WRITE(LUN, '('' SDRIV2:An invalid parameter has been '',
     8    ''correctly detected.'')')
          WRITE(LUN, *)
     8    ' The value of LENW was set to ', LENWX
          WRITE(LUN, *)
     8    ' MSTATE = ', MSTATE, ', Error number = ', IERFLG
          WRITE(LUN, '(/)')
        END IF
      ELSE
        IF (KPRINT .EQ. 1) THEN
          WRITE(LUN, '('' SDRIV2:An invalid parameter has not '',
     8    ''been correctly detected.'' //)')
        ELSE IF (KPRINT .GE. 2) THEN
          WRITE(LUN, '('' SDRIV2:An invalid parameter has not '',
     8    ''been correctly detected.'')')
          WRITE(LUN, *) ' The value of LENW was set to ', LENWX
          WRITE(LUN, *)
     8    ' MSTATE = ', MSTATE, ', Error number = ', IERFLG
          WRITE(LUN, '('' The values of parameters, results, and '',
     8    ''statistical quantities are:'')')
          WRITE(LUN, *)
     8    ' EPS ', EPS, ', MINT ', MINT, ', LENW ', LENW,
     8    ', LENIW ', LENIW
          WRITE(LUN, *) ' T ', T
          WRITE(LUN, *) ' Y(1) ', Y(1)
          WRITE(LUN, *) ' Y(2) ', Y(2)
          WRITE(LUN, *) ' Y(3) ', Y(3)
          WRITE(LUN, *)
     8    ' Number of steps taken is  ', NSTEP
          WRITE(LUN, *)
     8    ' Number of evaluations of the right hand side is  ', NFE
          WRITE(LUN, *)
     8    ' Number of evaluations of the Jacobian matrix is  ', NJE
          WRITE(LUN, '(//)')
        END IF
        IPASS = 0
      END IF
      CALL XERCLR
C                                            Exercise SDRIV3 for problem
C                                            with known solution.
      T = 0.E0
      Y(1) = 10.E0
      Y(2) = 0.E0
      Y(3) = 10.E0
      Y(4) = ALFA
      NSTATE = 1
      TOUT = 10.E0
      MINT = 2
      LENW = 301
      LENIW = 53
      CALL SDRIV3 (N, T, Y, SDF, NSTATE, TOUT, NTASK, NROOT, EPS, EWT,
     8             IERROR, MINT, MITER, IMPL, ML, MU, MXORD, HMAX,
     8             WORK, LENW, IWORK, LENIW, SDF, SDF, NDE,
     8             MXSTEP, SDF, SDF, IERFLG)
      NSTEP = IWORK(3)
      NFE = IWORK(4)
      NJE = IWORK(5)
      IF (NSTATE .EQ. 2) THEN
        IF (ABS(1.E0 - Y(1)*1.5E0) .LE. EPS**(2.E0/3.E0) .AND.
     8  ABS(1.E0 - Y(2)*3.E0) .LE. EPS**(2.E0/3.E0) .AND.
     8  ABS(1.E0 - Y(3)) .LE. EPS**(2.E0/3.E0)) THEN
          IF (KPRINT .EQ. 2) THEN
            WRITE(LUN, '('' SDRIV3:The solution determined met '',
     8      ''the expected values.'' //)')
          ELSE IF (KPRINT .EQ. 3) THEN
            WRITE(LUN, '('' SDRIV3:The solution determined met '',
     8      ''the expected values.'')')
            WRITE(LUN, '('' The values of results are '')')
            WRITE(LUN, *) ' T ', T
            WRITE(LUN, *) ' Y(1) ', Y(1)
            WRITE(LUN, *) ' Y(2) ', Y(2)
            WRITE(LUN, *) ' Y(3) ', Y(3)
            WRITE(LUN, '(/)')
          END IF
        ELSE
          IF (KPRINT .EQ. 1) THEN
            WRITE(LUN, '('' SDRIV3:The solution determined is not '',
     8      ''accurate enough.'' //)')
          ELSE IF (KPRINT .GE. 2) THEN
            WRITE(LUN, '('' SDRIV3:The solution determined is not '',
     8      ''accurate enough.'')')
            WRITE(LUN, '('' The values of parameters, results, and '',
     8      ''statistical quantities are:'')')
            WRITE(LUN, *)
     8      ' EPS = ', EPS, ', EWT = ', EWT, ', IERROR = ', IERROR
            WRITE(LUN, *)
     8      ' MINT = ', MINT, ', MITER = ', MITER, ', IMPL = ', IMPL
            WRITE(LUN, *) ' T ', T
            WRITE(LUN, *) ' Y(1) ', Y(1)
            WRITE(LUN, *) ' Y(2) ', Y(2)
            WRITE(LUN, *) ' Y(3) ', Y(3)
            WRITE(LUN, *)
     8      ' Number of steps taken is  ', NSTEP
            WRITE(LUN, *)
     8      ' Number of evaluations of the right hand side is  ', NFE
            WRITE(LUN, *)
     8      ' Number of evaluations of the Jacobian matrix is  ', NJE
            WRITE(LUN, '(//)')
          END IF
          IPASS = 0
        END IF
      ELSE
        IF (KPRINT .EQ. 1) THEN
          WRITE(LUN, '('' While using SDRIV3, a solution was not '',
     8    ''obtained.'' //)')
        ELSE IF (KPRINT .GE. 2) THEN
          WRITE(LUN, '('' While using SDRIV3, a solution was not '',
     8    ''obtained.'')')
          WRITE(LUN, *)
     8    ' MSTATE = ', MSTATE, ', Error number = ', IERFLG
          WRITE(LUN, '('' The values of parameters, results, and '',
     8    ''statistical quantities are:'')')
          WRITE(LUN, *)
     8    ' EPS = ', EPS, ', EWT = ', EWT, ', IERROR = ', IERROR
          WRITE(LUN, *)
     8    ' MINT = ', MINT, ', MITER = ', MITER, ', IMPL = ', IMPL
          WRITE(LUN, *) ' T ', T
          WRITE(LUN, *) ' Y(1) ', Y(1)
          WRITE(LUN, *) ' Y(2) ', Y(2)
          WRITE(LUN, *) ' Y(3) ', Y(3)
          WRITE(LUN, *)
     8    ' Number of steps taken is  ', NSTEP
          WRITE(LUN, *)
     8    ' Number of evaluations of the right hand side is  ', NFE
          WRITE(LUN, *)
     8    ' Number of evaluations of the Jacobian matrix is  ', NJE
          WRITE(LUN, '(//)')
        END IF
        IPASS = 0
      END IF
      CALL XERCLR
C                                         Run SDRIV3 with invalid input.
      T = 0.E0
      Y(1) = 10.E0
      Y(2) = 0.E0
      Y(3) = 10.E0
      Y(4) = ALFA
      NSTATE = 1
      TOUT = 10.E0
      MINT = 2
      LENW = 301
      LENIWX = 1
      CALL SDRIV3 (N, T, Y, SDF, NSTATE, TOUT, NTASK, NROOT, EPS,
     8             EWT, IERROR, MINT, MITER, IMPL, ML, MU,
     8             MXORD, HMAX, WORK, LENW, IWORK, LENIWX, SDF,
     8             SDF, NDE, MXSTEP, SDF, SDF, IERFLG)
      IF (IERFLG .EQ. 33) THEN
        IF (KPRINT .EQ. 2) THEN
          WRITE(LUN, '('' SDRIV3:An invalid parameter has been '',
     8    ''correctly detected.'' //)')
        ELSE IF (KPRINT .EQ. 3) THEN
          WRITE(LUN, '('' SDRIV3:An invalid parameter has been '',
     8    ''correctly detected.'')')
          WRITE(LUN, *)
     8    ' The value of LENIW was set to ', LENIWX
          WRITE(LUN, *)
     8    ' NSTATE = ', NSTATE, ', Error number = ', IERFLG
          WRITE(LUN, '(/)')
        END IF
      ELSE
        IF (KPRINT .EQ. 1) THEN
          WRITE(LUN, '('' SDRIV3:An invalid parameter has not '',
     8    ''been correctly detected.'' //)')
        ELSE IF (KPRINT .GE. 2) THEN
          WRITE(LUN, '('' SDRIV3:An invalid parameter has not '',
     8    ''been correctly detected.'')')
          WRITE(LUN, *)
     8    ' The value of LENIW was set to ', LENIWX
          WRITE(LUN, *)
     8    ' NSTATE = ', NSTATE, ', Error number = ', IERFLG
          WRITE(LUN, '('' The values of parameters, results, and '',
     8    ''statistical quantities are:'')')
          WRITE(LUN, *)
     8    ' EPS = ', EPS, ', EWT = ', EWT, ', IERROR = ', IERROR
          WRITE(LUN, *)
     8    ' MINT = ', MINT, ', MITER = ', MITER, ', IMPL = ', IMPL
          WRITE(LUN, *) ' T ', T
          WRITE(LUN, *) ' Y(1) ', Y(1)
          WRITE(LUN, *) ' Y(2) ', Y(2)
          WRITE(LUN, *) ' Y(3) ', Y(3)
          WRITE(LUN, *)
     8    ' Number of steps taken is  ', NSTEP
          WRITE(LUN, *)
     8    ' Number of evaluations of the right hand side is  ', NFE
          WRITE(LUN, *)
     8    ' Number of evaluations of the Jacobian matrix is  ', NJE
          WRITE(LUN, '(//)')
        END IF
        IPASS = 0
      END IF
      CALL XERCLR
      RETURN
      END
