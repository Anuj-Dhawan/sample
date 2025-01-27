       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOANAPP.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT LOAN-INPUT-FILE ASSIGN TO 'LOANIN.DAT'
               ORGANIZATION IS SEQUENTIAL.
           SELECT LOAN-OUTPUT-FILE ASSIGN TO 'LOANOUT.DAT'
               ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  LOAN-INPUT-FILE.
       01  LOAN-INPUT-RECORD.
           05  CUSTOMER-ID         PIC X(05).
           05  CUSTOMER-NAME       PIC X(20).
           05  LOAN-AMOUNT         PIC 9(7)V99.
           05  CREDIT-SCORE        PIC 9(03).

       FD  LOAN-OUTPUT-FILE.
       01  LOAN-OUTPUT-RECORD      PIC X(80).

       WORKING-STORAGE SECTION.
       01  WS-RECORD-COUNT         PIC 9(05) VALUE 0.
       01  EOF-FLAG                PIC X VALUE 'N'.
           88  EOF-REACHED         VALUE 'Y'.
           88  NOT-EOF             VALUE 'N'.
       01  WS-CUSTOMER-STATUS      PIC X(20).

       PROCEDURE DIVISION.
           OPEN INPUT LOAN-INPUT-FILE
           OPEN OUTPUT LOAN-OUTPUT-FILE

           PERFORM UNTIL EOF-REACHED
               READ LOAN-INPUT-FILE
                   AT END
                       SET EOF-REACHED TO TRUE
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       PERFORM PROCESS-LOAN-RECORD
               END-READ
           END-PERFORM

           CLOSE LOAN-INPUT-FILE
           CLOSE LOAN-OUTPUT-FILE

           DISPLAY 'TOTAL LOAN APPLICATIONS PROCESSED: ' WS-RECORD-COUNT
           STOP RUN.

       PROCESS-LOAN-RECORD.
           IF CREDIT-SCORE >= 700
               MOVE 'APPROVED' TO WS-CUSTOMER-STATUS
           ELSE
               MOVE 'DENIED' TO WS-CUSTOMER-STATUS
           END-IF
           STRING CUSTOMER-ID DELIMITED BY SPACE
                  CUSTOMER-NAME DELIMITED BY SPACE
                  WS-CUSTOMER-STATUS DELIMITED BY SPACE
                  INTO LOAN-OUTPUT-RECORD
           WRITE LOAN-OUTPUT-RECORD.
