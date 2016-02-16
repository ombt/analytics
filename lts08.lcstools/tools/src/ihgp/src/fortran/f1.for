// EXEC PROC=FORTGO
C
C BASIC RULES FOR FORTRAN:
C
C 0) ONLY USE CAPITAL LETTERS.
C 1) VARIABLE NAMES MUST BE 6 CHARACTERS OR LESS. 
C 2) THE VARIABLE CAN ONLY CONTAIN LETTERS OR NUMBERS.
C 3) DECLARE ALL VARIABLES BEFORE YOU USE THEM.
C 4) A LETTER "C" IN COLUMN 1 INDICATES A COMMENT.
C 5) FORTRAN INSTRUCTIONS MUST BE TYPE BETWEEN COLUMNS
C    7 AND 72 INCLUSIVE.
C
C CALCULATE AN AREA FOR A CIRCLE AND PRINT RESULTS.
C
C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012
C
      PROGRAM MYAREA
C
C DECLARE VARIABLES.
C
      REAL RADIUS, AREA
C
C GET RADIUS FROM USER.
C
      PRINT *, 'ENTER CIRCLE RADIUS: '
      READ *, RADIUS
C
C CALCULATE AREA AND PRINT.
C
      AREA = 3.14156*RADIUS**2
      PRINT *, 'AREA IS ... ', AREA
C
C ALL DONE
C
      END
/*
3.0
/*