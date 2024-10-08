
TITLE MASM Template						(main.asm)
; Brandon Getz & Jeremy Reed
; April 22nd, 2023
; Lab 6
; The purpose of this lab is to create  aprogram that allows a user to run
; an operation based on multiple choices including a Coin Flipper Program,
; a Dice Roller Program, a String Searcher Program, and an Age Calculator
; Program + the option to quit the program. The program should allow the
; user to continue doing operations until the quit function is selected.

; Import the Irvine library functions
INCLUDE Irvine32.inc

MAX_CHARACTERS = 100

; Coin flipper const
HEADS = 0
TAILS = 1
MAX = 2


; Data declarations section used to declare variables for the program
.data
	
	menuHeaderMessage BYTE "Select an Option from the Menu Below: ", 0
	menuDividerMessage BYTE"---------------------------------------------------------------", 0
	askCoinFlipper BYTE "1. Coin Flipper Program", 0
	askDiceRoller BYTE "2. Dice Roller Program", 0
	askStringSearcher BYTE "3. String Searcher Program", 0
	askAgeCalc BYTE "4. Age Calculator Program", 0
	askExit BYTE "5. Exit Program", 0
	askSelection BYTE "Enter Selection Here: ", 0
	exitChoice BYTE "Enter a number when you would like to go back to the menu: ",0

	menuSelection DWORD 0
	exitSelection DWORD 0

	; Variables below are for CoinFlipperProc Procedure/Program(ss stands for StringSearcher)
	 inputCoinMessage BYTE "How many times do you want to flip the coin? ",0
	 headsOutcomeMessage BYTE "HEADS was flipped!",0
	 tailsOutcomeMessage BYTE "TAILS was flipped!",0
	 headsResultMessage BYTE "Total number of HEADS: ",0
	 tailsResultMessage BYTE "Total number of TAILS: ",0
	 headsCount DWORD 0
	 tailsCount DWORD 0
	 flipCount DWORD 0


	; Variables below are for StringSearcherProc Procedure/Program
	 askString BYTE "Enter a string: ", 0
	 userString BYTE MAX_CHARACTERS DUP(0)
	 askCharacter BYTE "Enter a character to use in the search: ", 0
	 userCharacter BYTE MAX_CHARACTERS DUP(0)
	 charFoundCount DWORD 0
	 ssOutputMessage1 BYTE "The character '", 0
	 ssOutputMessage2 BYTE "' was found ", 0
	 ssOutputMessage3 BYTE " times in the string.", 0
	 searchMessage1 BYTE "Performing search...", 0
	 searchMessage2 BYTE "Search completed.", 0
	 resultsMessage BYTE "Search results: ", 0
	 firstOcc DWORD 0
	 lastOcc DWORD 0
	 occMessage1 BYTE "First occurence: ", 0
	 occMessage2 BYTE "Last occurence: ", 0
	


; Code section used to write the code for the program.
.code
main PROC
	
	
	MenuQuestion:			; MenuQuestion loop makes it so the user can make another 
							; selection if they want to.
	call Clrscr
		; The below code prompts the user to select an option from the
		; menu. Based on the selection, an operation will take place
		mov	 edx, OFFSET menuHeaderMessage
		call WriteString
		call crlf
		mov	 edx, OFFSET askCoinFlipper
		call WriteString
		call crlf
		mov	 edx, OFFSET askDiceRoller
		call WriteString
		call crlf
		mov	 edx, OFFSET askStringSearcher
		call WriteString
		call crlf
		mov	 edx, OFFSET askAgeCalc
		call WriteString
		call crlf
		mov	 edx, OFFSET askExit
		call WriteString
		call crlf
		call crlf
		
		; Asking menu selection
		mov	 edx, OFFSET askSelection
		call WriteString
		call ReadDec
		mov menuSelection, eax
		JMP MenuChoice
	MenuChoice:
		cmp menuSelection, 1d
		JE CoinFlipper
		cmp menuSelection, 2d
		JE DiceRoller
		cmp menuSelection, 3d
		JE StringSearcher
		cmp menuSelection, 4d
		JE AgeCalculator
		cmp menuSelection, 5d
		JE ExitProgram
		JMP Next
	CoinFlipper:
		call CoinFlipperProc
		JMP MenuQuestion
	DiceRoller:
		call DiceRollerProc
		JMP MenuQuestion
	StringSearcher:
		call StringSearcherProc
		JMP MenuQuestion
	AgeCalculator:
		call AgeCalculatorProc
		JMP MenuQuestion
	ExitProgram:
		call ExitProc 
	Next:
		LOOP MenuChoice


main ENDP

CoinFlipperProc PROC
CALL Clrscr
; This procedure flips a coin 


	; Get the number of times the user wants to flip the coin
	MOV edx, OFFSET inputCoinMessage
	CALL WriteString
	CALL ReadDec
	MOV flipCount, eax

	; Setup a loop to flip the coin the user specified number of times
	MOV ecx, 0
	CALL Randomize				; seed/ setup the RNG


FlipCoinLoop:
	; while loop (ecx < flipCount)
	CMP ecx, flipCount
	JAE Next

	; code body
	MOV eax, MAX				; Generate a number between 0 and 2 
	CALL RandomRange

	; Determine the outcome of the coin flip and process it
	CMP eax, TAILS
	JE TailsFlip
	INC headsCount
	MOV edx, OFFSET headsOutcomeMessage
	CALL WriteString
	CALL Crlf
	JMP EndOfLoop

TailsFlip:			; flipped a tails
	; Body of the code to execute when a tails is flipped 
	INC tailsCount
	MOV edx, OFFSET tailsOutcomeMessage
	CALL WriteString
	CALL Crlf
	

EndOfLoop:
	INC ecx
	JMP FlipCoinLoop

Next:
	; Display results of all the coin flips
	MOV edx, OFFSET tailsResultMessage
	CALL WriteString
	MOV eax, tailsCount
	CALL WriteDec
	CALL Crlf

	MOV edx, OFFSET headsResultMessage
	CALL WriteString
	MOV eax, headsCount
	CALL WriteDec
	CALL Crlf


	; Reset values
	mov tailsCount, 0
	mov headsCount, 0
	mov flipCount, 0

	; Ask for them to enter when they would like to exit
	call crlf
	mov	 edx, OFFSET exitChoice
	call WriteString
	call ReadDec
	JMP Return
Return:
		ret


CoinFlipperProc ENDP

DiceRollerProc PROC

DiceRollerProc ENDP

StringSearcherProc PROC
call Clrscr

	; Ask the user to input a string
	mov edx, OFFSET askString
	call WriteString

	; Takes the user's input and stores it into userString variable
	mov edx, OFFSET userString
	mov ecx, MAX_CHARACTERS - 1
	call ReadString

	; Ask the user to input a character to search for within the string
	mov edx, OFFSET askCharacter
	call WriteString

	; Takes the user's input and stores it into userCharacter variable
	mov edx, OFFSET userCharacter
	mov ecx, MAX_CHARACTERS - 1
	call ReadString

	; Both WriteStrings below output searching messages(cosmetic)
	call crlf
	mov edx, OFFSET searchMessage1
	call WriteString
	call crlf
	mov edx, OFFSET searchMessage2
	call WriteString
	call crlf
	call crlf

	; Calls the procedure written below
	CALL SearchForChar

	; Output messages
	mov edx, OFFSET resultsMessage
	call WriteString
	call crlf
	mov edx, OFFSET ssOutputMessage1
	call WriteString
	mov edx, OFFSET userCharacter
	call WriteString
	mov edx, OFFSET ssOutputMessage2
	call WriteString
	mov eax, CharFoundCount
	call WriteDec
	mov edx, OFFSET ssOutputMessage3
	call WriteString
	call crlf

	; Output messages regarding first & last occurence
	mov edx, OFFSET occMessage1
	call WriteString
	mov eax, firstOcc
	call WriteDec
	call crlf

	mov edx, OFFSET occMessage2
	call WriteString
	mov eax, lastocc
	call WriteDec
	call crlf
	call crlf

	; Reset values
	mov firstOcc, 0
	mov lastOcc, 0
	mov charFoundCount, 0

	; Ask for them to enter when they would like to exit
	mov	 edx, OFFSET exitChoice
	call WriteString
	call ReadDec
	JMP Return
Return:
		ret

StringSearcherProc ENDP
; --------------------------------------------------------------------
SearchForChar PROC
; This procedure searches for a specified character (input from user)
; and searches for said character in the user inputted string. It then
; returns the # of times the character was located, as well as where in
; the word the character was located.
;
; --------------------------------------------------------------------
	; esi sets the index to 0 / ecx loops according to size of userString
	mov esi, 0
	mov ecx, SIZEOF userString
	mov bl, userCharacter
	CharacterSearch:
		cmp bl, userString[esi]
		JE CharacterFound
		JMP Next
	CharacterFound:
		inc charFoundCount
		; The logic behind the comparison below, is that if the charFoundCount
		; were to equal 1, then that would indicate that this was the first 
		; occurence of the letter. Therefore, the if statement sets the index
		; of userString = firstOccurence when charFoundCount is = 1.
		cmp charFoundCount, 1
		JE FirstOccurence
		mov lastOcc, esi
		add lastOcc, 1
		JMP Next
	FirstOccurence:
		mov firstOcc, esi
		; Need to add 1 to firstOcc to account for null value(0)
		add firstOcc, 1
	Next:
	inc esi
	LOOP CharacterSearch

	ret

SearchForChar ENDP

AgeCalculatorProc PROC

AgeCalculatorProc ENDP

ExitProc PROC
	 call ExitProcess
ExitProc ENDP


END main
