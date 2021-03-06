*DECK ZQCBI
      SUBROUTINE ZQCBI (LUN, KPRINT, IPASS)
C***BEGIN PROLOGUE  ZQCBI
C***SUBSIDIARY
C***PURPOSE  Quick check for SLATEC subroutine
C            ZBESI
C***LIBRARY   SLATEC
C***CATEGORY  C10B4
C***TYPE      COMPLEX (CQCBI-C, ZQCBI-Z)
C***KEYWORDS  QUICK CHECK, ZBESI
C***AUTHOR  Amos, Don, (SNL)
C           Goudy, Sue, (SNL)
C           Walton, Lee, (SNL)
C***DESCRIPTION
C
C *Usage:
C
C        INTEGER  LUN, KPRINT, IPASS
C
C        CALL ZQCBI (LUN, KPRINT, IPASS)
C
C *Arguments:
C
C     LUN    :IN  is the unit number to which output is to be written.
C
C     KPRINT :IN  controls the amount of output, as specified in the
C                 SLATEC Guidelines.
C
C     IPASS  :OUT indicates whether the test passed or failed.
C                 A value of one is good, indicating no failures.
C
C *Description:
C
C                 *** A DOUBLE PRECISION ROUTINE ***
C
C   ZQCBI is a quick check routine for the complex I Bessel function
C    generated by subroutine ZBESI.
C
C   ZQCBI generates sequences crossing formula boundaries which
C    are started by one formula and terminated in a region where
C    another formula applies. The terminated value is checked by
C    the formula appropriate to that region.
C
C***REFERENCES  Abramowitz, M. and Stegun, I. A., Handbook
C                 of Mathematical Functions, Dover Publications,
C                 New York, 1964.
C               Amos, D. E., A Subroutine Package for Bessel
C                 Functions of a Complex Argument and Nonnegative
C                 Order, SAND85-1018, May, 1985.
C***ROUTINES CALLED  ZBESI, ZBESK, ZWRSK, ZABS, ZDIV, I1MACH, D1MACH
C***REVISION HISTORY  (YYMMDD)
C   830501  DATE WRITTEN
C   890831  Revised to meet new SLATEC standards
C***END PROLOGUE  ZQCBI
C
C*Internal Notes:
C   Machine constants are defined by functions I1MACH and D1MACH.
C
C   The parameter MQC can have values 1 (the default) for a faster,
C   less definitive test or 2 for a slower, more definitive test.
C
C**End
C
C  Set test complexity parameter.
C
      INTEGER  MQC
      PARAMETER (MQC=1)
C
C  Declare arguments.
C
      INTEGER  LUN, KPRINT, IPASS
C
C  Declare external functions.
C
      INTEGER  I1MACH
      DOUBLE PRECISION  D1MACH, ZABS
      EXTERNAL  I1MACH, D1MACH, ZABS
C
C  Declare local variables.
C
      DOUBLE PRECISION  CKR,CKI, CONER,CONEI, CSGNR,CSGNI, CWR,CWI,
     *   CYR,CYI, WR,WI, YR,YI, ZR,ZI, ZNR,ZNI, ZTR,ZTI
      DOUBLE PRECISION  AA, AB, AER, ALIM, ARG, ATOL, AW, CARG, CT, DIG,
     *   ELIM, EPS, ER, ERTOL, FILM, FNU, FNUL, GNU, HPI, PI, R, RL,
     *   RLT, RM, R1, R1M4, R1M5, R2, SARG, SLAK, ST, STI, STR, T, TOL,
     *   TS, ZSCR, ZZR
      INTEGER  I, ICASE, IERR, IL, INU, IPRNT, IR, IT, ITL, K, KDO,
     *   KEPS, KK, KODE, K1, K2, LFLG, MFLG, N, NL, NZI, NZK, NZ1, NZ2,
     *   N1
      DIMENSION  AER(20), CKR(2), CKI(2), KDO(20), KEPS(20), T(20),
     *   WR(20), WI(20), YR(20), YI(20)
C
C***FIRST EXECUTABLE STATEMENT  ZQCBI
      IF (KPRINT.GE.2) THEN
        WRITE (LUN,99999)
99999   FORMAT (' QUICK CHECK ROUTINE FOR THE I BESSEL FUNCTION FROM ',
     *     'ZBESI'/)
      ENDIF
C-----------------------------------------------------------------------
C     Set parameters related to machine constants.
C     TOL is the approximate unit roundoff limited to 1.0D-18.
C     ELIM is the approximate exponential over- and underflow limit.
C     exp(-ELIM).lt.exp(-ALIM)=exp(-ELIM)/TOL    and
C     exp(ELIM).gt.exp(ALIM)=exp(ELIM)*TOL       are intervals near
C     underflow and overflow limits where scaled arithmetic is done.
C     RL is the lower boundary of the asymptotic expansion for large Z.
C     DIG = number of base 10 digits in TOL = 10**(-DIG).
C     FNUL is the lower boundary of the asymptotic series for large FNU.
C-----------------------------------------------------------------------
      R1M4 = D1MACH(4)
      TOL = MAX(R1M4,1.0D-18)
      ATOL = 100.0D0*TOL
      AA = -LOG10(R1M4)
      K1 = I1MACH(12)
      K2 = I1MACH(13)
      R1M5 = D1MACH(5)
      K = MIN(ABS(K1),ABS(K2))
      ELIM = 2.303D0*(K*R1M5-3.0D0)
      AB = AA*2.303D0
      ALIM = ELIM + MAX(-AB,-41.45D0)
      DIG = MIN(AA,18.0D0)
      FNUL = 10.0D0 + 6.0D0*(DIG-3.0D0)
      RL = 1.2D0*DIG + 3.0D0
      SLAK = 3.0D0+4.0D0*(-LOG10(TOL)-7.0D0)/11.0D0
      SLAK = MAX(SLAK,3.0D0)
      ERTOL = TOL*10.0D0**SLAK
      RM = 0.5D0*(ALIM + ELIM)
      RM = MIN(RM,200.0D0)
      RM = MAX(RM,RL+10.0D0)
      R2 = MIN(RM,FNUL)
      R1 = 2.0D0*SQRT(FNUL+1.0D0)
      IF (KPRINT.GE.2) THEN
        WRITE (LUN,99998)
99998   FORMAT (' PARAMETERS'/
     *     5X,'TOL ',8X,'ELIM',8X,'ALIM',8X,'RL  ',8X,'FNUL',8X,'DIG')
        WRITE (LUN,99997) TOL, ELIM, ALIM, RL, FNUL, DIG
99997   FORMAT (1X,6D12.4/)
      ENDIF
C-----------------------------------------------------------------------
C     Set other constants needed in the tests.
C-----------------------------------------------------------------------
      ZZR = 1.0D0/TOL
      CONER = 1.0D0
      CONEI = 0.0D0
      HPI = 2.0D0*ATAN(1.0D0)
      PI = HPI + HPI
C-----------------------------------------------------------------------
C     Generate angles for construction of complex Z to be used in tests.
C-----------------------------------------------------------------------
C     KDO(K), K = 1,IL  determines which of the IL angles in -PI to PI
C     are used to compute values of Z.
C       KDO(K) = 0  means that the index K will be used for one or two
C                   values of Z, depending on the choice of KEPS(K)
C              = 1  means that the index K and the corresponding angle
C                   will be skipped
C     KEPS(K), K = 1,IL determines which of the angles get incremented
C     up and down to put values of Z in regions where different
C     formulae are used.
C       KEPS(K)  = 0  means that the angle will be used without change
C                = 1  means that the angle will be incremented up and
C                   down by EPS
C     The angles to be used are stored in the T(I) array, I = 1,ITL.
C-----------------------------------------------------------------------
      IF (MQC.NE.2) THEN
        NL = 2
        IL = 5
        DO 5 I = 1,IL
          KEPS(I) = 0
          KDO(I) = 0
    5   CONTINUE
      ELSE
        NL = 4
        IL = 13
        DO 6 I = 1,IL
          KDO(I) = 0
          KEPS(I) = 0
    6   CONTINUE
        KDO(2) = 1
        KDO(6) = 1
        KDO(8) = 1
        KDO(12) = 1
        KEPS(3) = 1
        KEPS(4) = 1
        KEPS(5) = 1
        KEPS(9) = 1
        KEPS(10) = 1
        KEPS(11) = 1
      ENDIF
      I = 2
      EPS = 0.01D0
      FILM = IL - 1
      T(1) = -PI + EPS
      DO 30 K = 2,IL
        IF (KDO(K).EQ.0) THEN
          T(I) = PI*(-IL+2*K-1)/FILM
          IF (KEPS(K).NE.0) THEN
            TS = T(I)
            T(I) = TS - EPS
            I = I + 1
            T(I) = TS + EPS
          ELSE
            I = I + 1
          ENDIF
        ENDIF
   30 CONTINUE
      ITL = I - 1
C-----------------------------------------------------------------------
C     Test values of Z in -PI.lt.arg(Z).le.PI near formula boundaries.
C-----------------------------------------------------------------------
      IF (KPRINT.GE.2) THEN
        WRITE (LUN,99996)
99996   FORMAT (' CHECKS ACROSS FORMULA BOUNDARIES')
      ENDIF
      LFLG = 0
      DO 220 ICASE = 1,6
        DO 210 KODE = 1,2
          DO 200 N = 1,NL
            N1 = N + 2
C-----------------------------------------------------------------------
C     Set values for R = magnitude of Z and for FNU to test computation
C     methods for the various regions of the (Z,FNU) plane.
C-----------------------------------------------------------------------
            DO 190 IR = 1,3
C------------ switch (icase)
              GO TO (50, 60, 70, 80, 90, 100), ICASE
   50         CONTINUE
                R = (2.0D0*(3-IR)+RL*(IR-1))/2.0D0
                GNU = R*R/4.0D0 - 0.2D0 - (N-1)
                FNU = MAX(0.0D0,GNU)
                GO TO 110
   60         CONTINUE
                R = (RL*(3-IR)+R2*(IR-1))/2.0D0
                GNU = SQRT(R+R) - 0.2D0 - (N-1)
                FNU = MAX(0.0D0,GNU)
                GO TO 110
   70         CONTINUE
                IF (R2.GE.RM) GO TO 220
                R = (R2*(3-IR)+RM*(IR-1))/2.0D0
                GNU = SQRT(R+R) - 0.2D0 - (N-1)
                FNU = MAX(0.0D0,GNU)
                GO TO 110
   80         CONTINUE
                IF (R1.GE.RL) GO TO 220
                R = (R1*(3-IR)+RL*(IR-1))/2.0D0
                FNU = FNUL - 0.2D0 - (N-1)
                GO TO 110
   90         CONTINUE
                R = (RL*(3-IR)+R2*(IR-1))/2.0D0
                FNU = FNUL - 0.2D0 - (N-1)
                GO TO 110
  100         CONTINUE
                IF (R2.GE.RM) GO TO 220
                R = (R2*(3-IR)+RM*(IR-1))/2.0D0
                FNU = FNUL - 0.2D0 - (N-1)
  110         CONTINUE
C------------ end switch
              DO 180 IT = 1,ITL
                CT = COS(T(IT))
                ST = SIN(T(IT))
                IF (ABS(CT).LT.ATOL) CT = 0.0D0
                IF (ABS(ST).LT.ATOL) ST = 0.0D0
                ZR = R*CT
                ZI = R*ST
                CALL ZBESI(ZR, ZI, FNU, KODE, N1, YR, YI, NZ1, IERR)
                IF (NZ1.NE.0) GO TO 180
C-----------------------------------------------------------------------
C     Compare values from ZBESI with values from ZWRSK, an alternative
C     method for calculating the complex Bessel I function.
C-----------------------------------------------------------------------
                ZNR = ZR
                ZNI = ZI
                IF (ZR.GE.0.0D0) THEN
                  CALL ZWRSK(ZNR, ZNI, FNU, KODE, N, WR, WI, NZ2, CKR,
     *               CKI, TOL, ELIM, ALIM)
                  IF (NZ2.NE.0) GO TO 180
                ELSE
                  ZNR = -ZR
                  ZNI = -ZI
                  INU = INT(FNU)
                  ARG = (FNU-INU)*PI
                  IF (ZI.LT.0.0D0) ARG = -ARG
                  CARG = COS(ARG)
                  SARG = SIN(ARG)
                  CSGNR = CARG
                  CSGNI = SARG
                  IF (MOD(INU,2).EQ.1) THEN
                    CSGNR = -CSGNR
                    CSGNI = -CSGNI
                  ENDIF
                  CALL ZWRSK(ZNR, ZNI, FNU, KODE, N, WR, WI, NZ2, CKR,
     *               CKI, TOL, ELIM, ALIM)
                  IF (NZ2.NE.0) GO TO 180
                  DO 130 I = 1,N
                    STR = WR(I)*CSGNR - WI(I)*CSGNI
                    WI(I) = WR(I)*CSGNI + WI(I)*CSGNR
                    WR(I) = STR
                    CSGNR = -CSGNR
                    CSGNI = -CSGNI
  130             CONTINUE
                ENDIF
                MFLG = 0
                DO 160 I = 1,N
                  AB = FNU + I - 1
                  AA = MAX(2.0D0,AB)
                  ZTR = WR(I)
                  ZTI = WI(I)
                  IF (ABS(ZTR).GT.1.0D0 .OR. ABS(ZTI).GT.1.0D0) THEN
                    ZSCR = TOL
                  ELSE
                    ZSCR = ZZR
C------------------ ZZR = 1.0D0/TOL
                  ENDIF
                  CWR = WR(I)*ZSCR
                  CWI = WI(I)*ZSCR
                  CYR = YR(I)*ZSCR
                  CYI = YI(I)*ZSCR
                  STR = CYR - CWR
                  STI = CYI - CWI
                  ER = ZABS(STR,STI)
                  AW = ZABS(CWR,CWI)
                  IF (AW.NE.0.0D0) THEN
                    IF (ZR.EQ.0.0D0) THEN
                      IF (ABS(ZI).LT.AA) THEN
                        ER = ER/AW
                      ELSE
                        STR = YR(I)-WR(I)
                        STI = YI(I)-WI(I)
                        ER = ZABS(STR,STI)
                      ENDIF
                    ELSE
                      ER = ER/AW
                    ENDIF
                  ELSE
                    ER = ZABS(YR(I),YI(I))
                  ENDIF
                  AER(I) = ER
                  IF (ER.GT.ERTOL) MFLG = 1
  160           CONTINUE
C-----------------------------------------------------------------------
C     Write failure reports for KPRINT.ge.2 and KPRINT.ge.3
C-----------------------------------------------------------------------
                IF (MFLG.NE.0) THEN
                  IF (LFLG.EQ.0) THEN
                    IF (KPRINT.GE.2) THEN
                      WRITE (LUN,99995) ERTOL
99995                 FORMAT (/' CASES WHICH UNDERFLOW OR VIOLATE THE ',
     *                   'RELATIVE ERROR TEST'/' WITH ERTOL = ', D12.4/)
                      WRITE (LUN,99994)
99994                 FORMAT (' INPUT TO ZBESI   Z, FNU, KODE, N')
                    ENDIF
                    IF (KPRINT.GE.3) THEN
                      WRITE (LUN,99993)
99993                 FORMAT (' ERROR TEST ON RESULTS FROM ZBESI AND ',
     *                   'ZWRSK   AER(K)')
                      WRITE (LUN,99992)
99992                 FORMAT (' RESULTS FROM ZBESI   NZ1, Y(KK)'/,
     *                   ' RESULTS FROM ZWRSK   NZ2, W(KK)')
                      WRITE (LUN,99991)
99991                 FORMAT (' TEST CASE INDICES   IT, IR, ICASE'/)
                    ENDIF
                  ENDIF
                  LFLG = LFLG + 1
                  IF (KPRINT.GE.2) THEN
                    WRITE (LUN,99990) ZR, ZI, FNU, KODE, N
99990               FORMAT ('   INPUT:    Z=',2D12.4,4X,'FNU=',D12.4,4X,
     *                 'KODE=',I3,4X,'N=',I3)
                  ENDIF
                  IF (KPRINT.GE.3) THEN
                    WRITE (LUN,99989) (AER(K),K=1,N)
99989               FORMAT ('   ERROR:  AER(K)=',4D12.4)
                    KK = MAX(NZ1,NZ2) + 1
                    KK = MIN(N,KK)
                    WRITE (LUN,99988) NZ1, YR(KK), YI(KK),
     *                 NZ2, WR(KK), WI(KK)
99988               FORMAT (' RESULTS:  NZ1=',I3,4X,'Y(KK)=',2D12.4,
     *                 /11X,'NZ2=',I3,4X,'W(KK)=',2D12.4)
                    WRITE (LUN,99987) IT, IR, ICASE
99987               FORMAT ('    CASE:   IT=',I3,4X,'IR=',I3,4X,
     *                 'ICASE=',I3/)
                  ENDIF
                ENDIF
  180         CONTINUE
  190       CONTINUE
  200     CONTINUE
  210   CONTINUE
  220 CONTINUE
      IF (KPRINT.GE.2) THEN
        IF (LFLG.EQ.0) THEN
          WRITE (LUN,99986)
99986     FORMAT (' QUICK CHECKS OK')
        ELSE
          WRITE (LUN,99985) LFLG
99985     FORMAT(' ***',I5,' FAILURE(S) FOR ZBESI CHECKS NEAR FORMULA ',
     *       'BOUNDARIES')
        ENDIF
      ENDIF
C
C
      IPRNT = 0
      IF (MQC.EQ.1) GO TO 900
C-----------------------------------------------------------------------
C     Checks near underflow limits on series(I=1) and uniform
C     asymptotic expansion(I=2)
C     Compare 1/Z with I(Z,FNU)*K(Z,FNU+1) + I(Z,FNU+1)*K(Z,FNU) and
C     report cases for which the relative error is greater than ERTOL.
C-----------------------------------------------------------------------
      IF (KPRINT.GE.2) THEN
        WRITE (LUN,99984)
99984   FORMAT (/' CHECKS NEAR UNDERFLOW AND OVERFLOW LIMITS'/)
      ENDIF
      ZR = 1.4D0
      ZI = 1.4D0
      KODE = 1
      N = 20
      DO 280 I = 1,2
        FNU = 10.2D0
C-----------------------------------------------------------------------
C       Adjust FNU by repeating until 0.lt.NZI.lt.10
C-----------------------------------------------------------------------
  230   CONTINUE
        CALL ZBESI(ZR, ZI, FNU, KODE, N, YR, YI, NZI, IERR)
        IF (NZI.NE.0) THEN
          IF (NZI.GE.10) THEN
            FNU = FNU - 1.0D0
            GO TO 230
          ENDIF
        ELSE
          FNU = FNU + 5.0D0
          GO TO 230
        ENDIF
C------ End repeat
        CALL ZBESK(ZR, ZI, FNU, KODE, 2, WR, WI, NZK, IERR)
        CALL ZDIV(CONER, CONEI, ZR, ZI, ZTR, ZTI)
        CYR = WR(1)*YR(2) - WI(1)*YI(2)
        CYI = WR(1)*YI(2) + WI(1)*YR(2)
        CWR = WR(2)*YR(1) - WI(2)*YI(1)
        CWI = WR(2)*YI(1) + WI(2)*YR(1)
        CWR = CWR + CYR - ZTR
        CWI = CWI + CYI - ZTI
        ER = ZABS(CWR,CWI)/ZABS(ZTR,ZTI)
C-----------------------------------------------------------------------
C     Write failure reports for KPRINT.ge.2 and KPRINT.ge.3
C-----------------------------------------------------------------------
        IF (ER.GE.ERTOL) THEN
          IF (IPRNT.EQ.0) THEN
            IF (KPRINT.GE.2) THEN
              WRITE (LUN,99983)
99983         FORMAT (' INPUT TO ZBESI   Z, FNU, KODE, N')
            ENDIF
            IF (KPRINT.GE.3) THEN
              WRITE (LUN,99982)
99982         FORMAT (' COMPARE 1/Z WITH WRONSKIAN(ZBESI(Z,FNU),',
     *           'ZBESK(Z,FNU))'/)
            ENDIF
          ENDIF
          IPRNT = 1
          IF (KPRINT.GE.2) THEN
            WRITE (LUN,99981) ZR, ZI, FNU, KODE, N
99981       FORMAT (' INPUT: Z=',2D12.4,3X,'FNU=',D12.4,3X,'KODE=',I3,
     *         3X,'N=',I3)
          ENDIF
          IF (KPRINT.GE.3) THEN
            WRITE (LUN,99980) ZTR, ZTI, CWR+CYR, CWI+CYI
99980       FORMAT (' RESULTS:',15X,'1/Z=',2D12.4/
     *         10X,'WRON(ZBESI,ZBESK)=',2D12.4)
            WRITE (LUN,99979) ER
99979       FORMAT (' RELATIVE ERROR:',9X,'ER=',D12.4/)
          ENDIF
        ENDIF
        RLT = RL + RL
        ZR = RLT
        ZI = 0.0D0
  280 CONTINUE
C-----------------------------------------------------------------------
C     Check near overflow limits
C     Compare 1/Z with I(Z,FNU)*K(Z,FNU+1) + I(Z,FNU+1)*K(Z,FNU) and
C     report cases for which the relative error is greater than ERTOL.
C-----------------------------------------------------------------------
      ZR = ELIM
      ZI = 0.0D0
      FNU = 0.0D0
C-----------------------------------------------------------------------
C     Adjust FNU by repeating until NZK.lt.10
C     N = 20 set before DO 280 loop
C-----------------------------------------------------------------------
  290 CONTINUE
      CALL ZBESK(ZR, ZI, FNU, KODE, N, YR, YI, NZK, IERR)
      IF (NZK.GE.10) THEN
        IF (NZK.EQ.N) THEN
          FNU = FNU + 3.0D0
        ELSE
          FNU = FNU + 2.0D0
        ENDIF
        GO TO 290
      ENDIF
C---- End repeat
      GNU = FNU + (N-2)
      CALL ZBESI(ZR, ZI, GNU, KODE, 2, WR, WI, NZI, IERR)
      CALL ZDIV(CONER, CONEI, ZR, ZI, ZTR, ZTI)
      CYR = YR(N-1)*WR(2) - YI(N-1)*WI(2)
      CYI = YR(N-1)*WI(2) + YI(N-1)*WR(2)
      CWR = YR(N)*WR(1) - YI(N)*WI(1)
      CWI = YR(N)*WI(1) + YI(N)*WR(1)
      CWR = CWR + CYR - ZTR
      CWI = CWI + CYI - ZTI
      ER = ZABS(CWR,CWI)/ZABS(ZTR,ZTI)
      IF (ER.GE.ERTOL) THEN
        IF (IPRNT.EQ.0) THEN
          IF (KPRINT.GE.2) THEN
            WRITE (LUN,99983)
          ENDIF
          IF (KPRINT.GE.3) THEN
            WRITE (LUN,99982)
          ENDIF
        ENDIF
        IPRNT = 1
        IF (KPRINT.GE.2) THEN
          WRITE (LUN,99981) ZR, ZI, FNU, KODE, N
        ENDIF
        IF (KPRINT.GE.3) THEN
          WRITE (LUN,99980) ZTR, ZTI, CWR+CYR, CWI+CYI
          WRITE (LUN,99979) ER
        ENDIF
      ENDIF
      IF (KPRINT.GE.2) THEN
        IF (IPRNT.EQ.0) THEN
          WRITE (LUN,99986)
C 99986   FORMAT (' QUICK CHECKS OK')
        ELSE
          WRITE (LUN,99978)
99978     FORMAT (' ***',5X,'FAILURE(S) FOR ZBESI NEAR UNDERFLOW AND ',
     *       'OVERFLOW LIMITS')
        ENDIF
      ENDIF
  900 CONTINUE
      IPASS = 0
      IF (IPRNT.EQ.0.AND.LFLG.EQ.0) THEN
        IPASS = 1
      ENDIF
      IF (IPASS.EQ.1.AND.KPRINT.GE.2) THEN
        WRITE (LUN,99977)
99977   FORMAT (/' ****** ZBESI  PASSED ALL TESTS  ******'/)
      ENDIF
      IF (IPASS.EQ.0.AND.KPRINT.GE.1) THEN
        WRITE (LUN,99976)
99976   FORMAT (/' ****** ZBESI  FAILED SOME TESTS ******'/)
      ENDIF
      RETURN
      END
