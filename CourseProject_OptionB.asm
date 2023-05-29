; CIS 11
; Janaye Jackson
; Devin Keomany
; Ignacio R Gama
; Course Project
; Test Score Calculator
; Description: LC-3 Program that will take 5 scores 
;		from user and output the min, max, 
;		and average of those 5 scores. Also,
;		it will output the letter grade.
; Inputs: 5 test scores
; Ouputs: Max, Min, and Average of test scores 
; 		Letter grade
; Side effects: 

.ORIG x3000

;START OF PROGRAM

; OPENING
LEA	 R0, START				; LOAD OPENEING STATEMENT
PUTS						; OUTPUT OPENING STATEMENT
START	.STRINGZ "Enter 5 scores: (0 - 99)"	; STRING FOR OPENING PHRASE

LD R0, NEWLINE				; OUTPUT A NEWLINE
OUT					



; START FUNCTION TO GET GRADES
	LD R5, NUM_GRADES		; COUNTER FOR AMOUNT OF GRADES
	AND R6, R6, #0			; CLEAR REGISTER 6
	LEA R6, GRADES			; LOAD GRADES ARRAY

LOOP					; LOOP TO GET ALL GRADES
	AND R1, R1, #0			; CLEAR REGISTERS
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	LD R4, DECODE_DEC		; DECIMAL TRANSLATION

	GETC				; GET FIRST NUM CHARACTER
	OUT				; OUTPUT USER INPUT
	
	ADD R1, R0, #0			; COPY INPUT TO R1
	ADD R1, R1, R4			; CONVERT TO DECIMAL	
	ADD R2, R2, #10			; ADD 10 TO R2 FOR MULTIPLICATION COUNTER


MULT10	ADD R3, R3, R1			; ADD INPUT TO R3 (FOR MULTIPLICATION)
	ADD R2, R2, #-1			; DECREMENT COUNTER
	BRp MULT10			; LOOP UNTIL COUNTER IS ZERO

	GETC				; GET SECOND NUM CHARACTER
	OUT				; OUTPUT USER INPUT
	
	ADD R0, R0, R4			; CONVERT TO DECIMAL
	ADD R3, R3, R0			; ADD FIRST INPUT(X10) TO SECOND INPUT
		

	LD R0, SPACE			; ADD A SPACE
	OUT				; PRINT SPACE

	STR R3, R6, #0			; STORE VALUE IN ARRAY
	JSR LETTER			; GET LETTER VALUE
	
	LD R0, NEWLINE 			; OUTPUT A NEWLINE
	OUT				
	
	ADD R6, R6, #1			; MOVE TO NEXT SPACE IN ARRAY
	ADD R5, R5, #-1			; DECREMENT LOOP COUNTER	
	BRp LOOP			; LOOP 

LD R0, NEWLINE				; OUTPUT NEWLINE
OUT					



; MAIN FUNCTION TO CALUCLATE AVERAGE
CALC_AVERAGE
	LD R1, NUM_GRADES		; LOAD TOTAL NUMBER OF GRADES
	LEA R2, GRADES			; LOAD STARTING VALUE OF GRADES
	AND R3, R3, #0			; CLEAR REGISTER
	AND R6, R6, #0			

SUM_LOOP				; LOOP TO ADD ALL NUMBERS
	LDR R4, R2, #0			; LOAD START OF ARRAY TO R4
	ADD R3, R3, R4			; HOLD SUM IN R3
	ADD R2, R2, #1			; MOVE TO NEXT LOCATION IN ARRAY
	ADD R1, R1, #-1			; DECREMENT COUNTER
	BRp SUM_LOOP			; LOOP
	
; DIVISON
	LD R1, NUM_GRADES		; TOTAL NUMBER OF GRADES
	NOT R1, R1			; 1S' COMPLEMENT
	ADD R1, R1, #1			; 2S' COMPLEMENT
	AND R4, R4, #0			; CLEAR REGISTER
	ADD R4, R3, #0			; PLACE AVERAGE IN R4

DIV_LOOP				; DIVISION
	ADD R4, R4, #0			; TEST FOR NEGATIVE OR ZERO VALUE
	BRnz OUT_AVG			; OUTPUT AVERAGE
	ADD R6, R6, #1			; INCREMENT FOR QUOTIENT
	ADD R4, R4, R1			; CONTINUOUSLY SUBTRACT 5 FROM AVG
	BRp DIV_LOOP			; LOOP

OUT_AVG					; OUTPUT AVERGAE
	ST R6, AVERAGE			; STORE AVERAGE IN R6
	LEA R0, AVG_OUT			; LOAD STRING
	PUTS				; OUTPUT STRING
	AND R1, R1, #0			; CLEAR REGISTERS
	AND R3, R3, #0
	AND R4, R4, #0
	ADD R3, R3, R6			; COPY R6 TO R3
	ST R3, SAVE			; ST R3 IN SAVE
	JSR CONVERT			; JUMP TO CONVERT SUBROUTINE
	LD R3, SAVE			; LOAD SAVE INTO R3
	JSR LETTER			; JUMP TO LETTER SUBROUTINE

LD R0, NEWLINE				; OUTPUT NEWLINE
OUT



; MAIN FUNCTION TO CALCULATE MAX
CALC_MAX
	LD R1, NUM_GRADES		; LOAD NUMBER OF GRADES 
	LEA R2, GRADES			; LOAD ARRAY OF GRADES
	LD R4, GRADES			; R4 = TO FIRST NUMBER IN ARRAY
	ST R4, MAX			; STORE GRADE GRADE IN MAX
	ADD R2, R2, #1			; MOVE TO NEXT VALUE IN ARRAY
	ADD R1, R1, #-1			; DECREMENT COUNTER
MAX_LOOP
	LDR R5, R2, #0			; LOAD NEXT ELEMENT OF ARRAY
	LD R4, MAX			; R4 = TO MAX NUMBER
	NOT R4, R4 			; 1S COMPLEMENT
	ADD R4, R4, #1			; 2S COMPLEMENT
	ADD R4, R4, R5			; COMPARE VALUES
BRp UPDATE_MAX				; BRANCH IF POSITIVE
	ADD R2, R2, #1			; MOVE TO NEXT VALUE IN ARRAY
	ADD R1, R1, #-1			; DECREMENT COUNTER
	BRp MAX_LOOP			; BRANCH IF POSITIVE
	ADD R1, R1, #0			; COPY R1 TO R1
	BRnz CALC_MIN			; BRANCH IF NEGATIVE OR ZERO

UPDATE_MAX				; UPDATE MAX VALUE
	ST R5, MAX			; STORE R5 IN MAX 
	ADD R2, R2, #1			; MOVE TO NEXT VALUE IN ARRAY
	ADD R1, R1, #-1			; DECREMENT COUNTER
	BRp MAX_LOOP			; BRANCH IF POSITIVE



; MAIN FUNCTION TO CALCULATE MAX
CALC_MIN
	LD R1, NUM_GRADES		; LOAD NUMBER OF GRADES 
	LEA R2, GRADES			; LOAD ARRAY OF GRADES
	LD R4, GRADES			; R4 = TO FIRST NUMBER IN ARRAY
	ST R4, MIN			; STORE GRADE IN MIN
	ADD R2, R2, #1			; MOVE TO NEXT VALUE IN ARRAY
	ADD R1, R1, #-1			; DECREMENT COUNTER
MIN_LOOP
	LDR R5, R2, #0			; LOAD NEXT ELEMENT OF ARRAY
	LD R4, MIN			; R4 = TO MIN NUMBER
	AND R3, R3, #0			; CLEAR REGISTER
	ADD R3, R3, R5			; COPY R5 TO R3
	NOT R3, R3 			; 1S COMPLEMENT
	ADD R3, R3, #1			; 2S COMPLEMENT
	ADD R4, R4, R3			; COMPARE VALUES
BRp UPDATE_MIN				; BRANCH IS POSITIVE
	ADD R2, R2, #1			; MOVE TO NEXT VALUE IN ARRAY
	ADD R1, R1, #-1			; DECREMENT COUNTER
	BRp MIN_LOOP			; ADD SPACE
	ADD R1, R1, #0			; COPY R1 TO R1
	BRnz OUTPUT			; BRANCH IF NEGATIVE OR ZERO

UPDATE_MIN				; UPDATE MIN VALUE
	ST R5, MIN			; STORE R5 IN MIN
	ADD R2, R2, #1			; MOVE TO NEXT VALUE IN ARRAY
	ADD R1, R1, #-1			; DECREMENT COUNTER
	BRp MIN_LOOP			; BRANCH IF POSITIVE

	
; MAIN FUNCTION FOR OUTPUT
OUTPUT
	LEA R0, MAX_OUT			; LOAD STRING
	PUTS				; OUTPUT STRING
	LD R3, MAX			; LD MAX TO R3
	ST R3, SAVE			; ST R3 IN SAVE
	AND R1, R1, #0			; CLEAR R1
	JSR CONVERT			; JUMP TO CONVERT SUBROUTINE
	LD R3, SAVE			; LOAD SAVE TO R3
	JSR LETTER			; JUMP TO LETTER SUBROUTINE
	LD R0, NEWLINE			; OUTPUT NEWLINE
	OUT				
	LEA R0, MIN_OUT			; LOAD STRING
	PUTS				; OUTPUT STRING
	LD R3, MIN			; LD MIN TO R3
	ST R3, SAVE			; ST R3 IN SAVE
	AND R1, R1, #0			; CLEAR R1
	JSR CONVERT			; JUMP TO CONVERT  SUBROUTINE
	LD R3, SAVE			; LOAD SAVE TO R3
	JSR LETTER			; JUMP TO LETTER SUBROUTINE
	LD R0, SPACE			; OUTPUT SPACE
	OUT	

HALT					; END PROGRAM


				;SUBROUTINES



; SUBROUTINE TO GET LETTER OF GRADE
LETTER
	AND R2, R2, #0			; CLEAR R2

; IF GRADE IS AN A 
AN_A	LD R0, A_N		; LOAD NUMBER VALUE 
	LD R1, A_L		; LOAD SYMBOL VALUE 

	ADD R2, R3, R0		; COMPARE INPUTS 
	BRzp STR_G		; IF POSITIVE OR ZERO STORE TO GRADE

; REPEAT CODE FOR LETTER A, BUT FOR B VALUES 
A_B	AND R2, R2, #0
	LD R0, B_N
	LD R1, B_L

	ADD R2, R3, R0
	BRzp STR_G

; REPEAT CODE FOR LETTER A, BUT FOR C VALUES 
A_C	AND R2, R2, #0
	LD R0, C_N
	LD R1, C_L

	ADD R2, R3, R0
	BRzp STR_G

; REPEAT CODE FOR LETTER A, BUT FOR D VALUES 
A_D	AND R2, R2, #0
	LD R0, D_N
	LD R1, D_L

	ADD R2, R3, R0
	BRzp STR_G

; REPEAT CODE FOR LETTER A, BUT FOR F VALUES 
A_F	AND R2, R2, #0
	LD R0, F_N
	LD R1, F_L

	ADD R2, R3, R0
	BRNZP STR_G

RET				; RETURN TO MAIN FUNCTION


STR_G	ST R7, SAVELOC1	  	; SAVE JSR LOCATION
	AND R0, R0, #0	 	; CLEAR R0
	ADD R0, R1, #0	 	; ADD LETTER TO R0
	OUT			; OUTPUT LEYYER
	LD R7, SAVELOC1		; RESTORE JSR LOCATION
RET				; RETURN TO MAIN


; CONVERT DECIMAL INTO ASCCI VALUE AND TAKE CARE OF REMAINDER
CONVERT
	ST R7, SAVELOC1		; STORE JSR RETURN LOCATION
	LD R5, TRANSLATE_SYM	; TRANSLATE DECIMAL TO SYMBOL
	ADD R4, R3, #0		; COPY INPUT TO R4

DIV_LOOP2			; GET FIRST CHARACTER
	ADD R1, R1, #1		; COUNTER FOR DIVISION
	ADD R4, R4, #-10	; DIVIDE BY 10 
	BRp DIV_LOOP2		; LOOP UNTIL CANT DIVIDE


	ADD R1, R1, #-1		; SUBTRACT AN EXTRA 1
	ADD R4, R4, #10		; ADD 10 TO GET REMAINDER
	ADD R6, R4, #-10	; SUBTRACT 10 FROM R4 AND STORE IN R6
	BRnp POS

NEG 	ADD R1, R1, #1		; ADD TO QUOTIENT
	ADD R4, R4, #-10	; DIVIDE BY 10

POS 	ST R1, Q		; STORE QOUTIENT IN Q
	ST R4, R		; STORE REMAINDER IN R
	
	LD R0, Q		; LOAD QUOTIENT FOR OUTPUT
	ADD R0, R0, R5		; TRANSLATE
	OUT			; OUTPUT

	LD R0, R		; LOAD REMAINDER FOR OUTPUT
	ADD R0, R0, R5		; TRANSLATE
	OUT			; OUTPUT
	
	LD R0, SPACE		; OUTPUT SPACE
	OUT
	
	LD R7, SAVELOC1		; RESTORE JSR RETURN LOCATION
	RET			; RETURN TO MAIN


				; DATA 
NEWLINE			.FILL xA		; CREATES A NEW	LINE
SPACE			.FILL X20		; CREATES A SPACE BETWEEN CHARCTERS
DECODE_DEC 		.FILL #-48		; TRANSLATE ASCII VALUE TO DECIMAL
TRANSLATE_SYM		.FILL #48		; TRANSLATE DECIMAL TO ASCII

;VARIABLE
AVERAGE 		.FILL #0		; STORE AVERAGE
MAX			.FILL #0		; STORE MAX
MIN			.FILL #0		; STORE MIN
SAVE			.FILL #0		; STORE DECIMAL VALUES
R			.FILL X0		; STORE REMAINDER
Q			.FILL X0		; STORE QUOTIENT


;STRINGS 
AVG_OUT			.STRINGZ "Average Grade: "
MAX_OUT			.STRINGZ "Maximum Grade: "
MIN_OUT			.STRINGZ "Minimum Grade: "
	
GRADES 			.BLKW #5		; ALLOCATE SPACE FOR GRADES
NUM_GRADES		.FILL #5		; AMOUNT OF GRADES COLLECTED
	

; DATA TO DETERMINE GRADES
A_N	.FILL #-90				; VALUE OF AN A OR HIGHER
A_L	.FILL X41				; ASCII VALUE FOR OUTPUT

B_N	.FILL #-80				; VALUE OF A B OR HIGHER
B_L	.FILL X42				; ASCII VALUE FOR OUTPUT

C_N	.FILL #-70				; VALUE OF A C OR HIGHER
C_L	.FILL X43				; ASCII VALUE FOR OUTPUT
		
D_N	.FILL #-60				; VALUE OF A D OR HIGHER
D_L	.FILL X44				; ASCII VALUE FOR OUTPUT

F_N	.FILL #-50				; VALUE OF A F OR HIGHER
F_L	.FILL X46				; ASCII VALUE FOR OUTPUT


; SAVE LOCATION TO RETURN TO DATA OR LOCATION
SAVELOC1 .FILL X0


.END						; END PROGRAM
