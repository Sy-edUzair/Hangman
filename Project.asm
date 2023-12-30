INCLUDE Irvine32.inc
INCLUDE macros.inc
.data
randomNumber DWORD ?
manyWords   BYTE 20 DUP(?),0
			BYTE 20 DUP(?),0
			BYTE 20 DUP(?),0
			BYTE 20 DUP(?),0
			BYTE 20 DUP(?),0
			BYTE 20 DUP(?),0
			BYTE 20 DUP(?),0
			BYTE 0	
len equ $ - manyWords
gameLives DWORD ?
selectedWord BYTE 20 DUP(?),0
lengthArray DWORD ?
guessLetter BYTE ?
guessWords BYTE 50 DUP(?)
guessLetterArray BYTE 50 DUP(?)
dash BYTE '-'
gameLoop BYTE 10

filename BYTE "words.txt",0
fileHandle HANDLE ?
.code
main PROC


jump_game_start:
call CRLF
	mwrite"      __   __  _______  __    _  _______  __   __  _______  __    _       " 
	call CRLF
	mwrite"     |  | |  ||   _   ||  |  | ||       ||  |_|  ||   _   ||  |  | |      " 
	call CRLF
	mwrite"     |  |_|  ||  |_|  ||   |_| ||    ___||       ||  |_|  ||   |_| |      " 
	call CRLF
	mwrite"     |       ||       ||       ||   | __ |       ||       ||       |      " 
	call CRLF
	mwrite"     |       ||       ||  _    ||   ||  ||       ||       ||  _    |      "
	call CRLF
	mwrite"     |   _   ||   _   || | |   ||   |_| || ||_|| ||   _   || | |   |      " 
	call CRLF
	mwrite"     |__| |__||__| |__||_|  |__||_______||_|   |_||__| |__||_|  |__|      " 
	CALL crlf
	call CRLF
	call CRLF
	mwrite"     MADE BY:   SYED UZAIR HUSSAIN (22K-4212)  " 
	CALL crlf
	mwrite"                MUSSADIQ KAMAL (22k-4432)     " 
	call CRLF

		;mov edx,OFFSET filename
		;call CreateOutputFile
		;mov fileHandle,eax
		;mov eax,fileHandle
		;mov edx,OFFSET manyWords
		;mov ecx,len
		;call WriteToFile
		;mov eax,fileHandle
		;call closeFile


		call makeDash

		mov edx,OFFSET filename
		call OpenInputFile
		mov fileHandle,eax
		mov edx,OFFSET manyWords
		mov ecx,len
		call ReadfromFile
		mov manywords[eax],0

		call Randomize
		mov eax,8
		call RandomRange
		mov randomNumber,eax
		mov edx,randomNumber
		call findstring
		INVOKE Str_copy,ADDR [edi],ADDR selectedWord
		mov edx, offset selectedWord
		call WriteString
		call Crlf			;new line
		call makeDash
		mov gameLives,7
inputWord:
	call printHangman
	cmp gameLives,0
	je gameover

	mov  eax,yellow+(black*16)
    call SetTextColor

	mwrite "Guess a letter: "
	call ReadChar

	push eax
	sub al,'a'
	cmp al,'z'-'a'
	jbe lowercase
	jmp inputWord

lowercase:
	pop eax
	mov guessLetter,al
	call WriteChar
	call CRLF
	call CRLF

	mov  eax,white+(black*16)
    call SetTextColor

	mov ecx,LENGTHOF guessLetterArray
	mov edi,OFFSET guessLetterArray
	mov al,guessLetter
	repne scasb           ;this will scan whole string and see if that letter exists or not(built in instruction)
	je guessedAgain
	call makeGuessLetterArray

	mov ecx,LENGTHOF selectedWord
	mov edi,OFFSET selectedWord
	mov al,guessLetter
	repne scasb
	jne decLive

	mov esi,0
	mov edi,0
	mov ecx,LENGTHOF selectedWord
	mov al,guessLetter

searchloop2:
	cmp selectedWord[esi * TYPE selectedWord],al
	jne next2
	mov guessWords[edi * TYPE guessWords],al
	next2:
	inc esi
	inc edi
LOOP searchloop2

	mov ecx,LENGTHOF guessWords
	mov edi,OFFSET guessWords
	mov al,dash
	repne scasb
	jne gameWon
	jmp inputWord


guessedAgain:
	mov  eax,red+(black*16)
	call SetTextColor
	mwrite "Sorry you have already guessed: "
	mov al,guessLetter
	call WriteChar
	call CRLF
	mov  eax,white+(black*16)
	call SetTextColor

	jmp inputWord

decLive:
	dec gameLives
	jmp inputWord
gameWon:
	mov eax,1000
	call Delay
	mov eax,green+(black*16)
	call SETTEXTCOLOR

	call clrscr
	
					mwrite"+------+      "
					call CRLF
					mwrite"|      |      "
					call CRLF
					mwrite"|      O      "
					call CRLF
					mwrite"|			 "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					call CRLF
					mwrite"|  YOU WON!  | "
					call CRLF
					mwrite"+------------+ "

	mov eax,1000
	call Delay
	mov eax,cyan+(black*16)
	call SETTEXTCOLOR

	call Clrscr

					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|     \|/      "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					call CRLF
					mwrite"|  YOU WON!  | "
					call CRLF
					mwrite"+------------+ "

	mov eax,1000
	call Delay
	mov eax,red+(black*16)
	call SETTEXTCOLOR

	call clrscr

					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|     \|/      "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|     / \      "
					call CRLF
					mwrite"+------------+ "
					call CRLF
					mwrite"|  YOU WON!  | "
					call CRLF
					mwrite"+------------+ "
	dec gameLoop
	cmp gameLoop,0
	jne gameWon
	
	mov  eax,white+(black*16)
	call SetTextColor
	jmp jump_game_start

gameover:
	mov eax,1000
	call Delay
	mov eax,green+(black*16)
	call SETTEXTCOLOR

	call clrscr
	
					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|     /|\      "
					call CRLF
					mwrite"|     / \      "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					call CRLF
					mwrite"|  YOU LOST! | "
					call CRLF
					mwrite"+------------+ "

	mov eax,1000
	call Delay
	mov eax,cyan+(black*16)
	call SETTEXTCOLOR

	call clrscr

					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|     /|\      "
					call CRLF
					mwrite"|     / \      "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					call CRLF
					mwrite"|  YOU LOST! | "
					call CRLF
					mwrite"+------------+ "


	mov eax,1000
	call Delay
	mov eax,red+(black*16)
	call SETTEXTCOLOR

	call clrscr

					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|     /|\      "
					call CRLF
					mwrite"|     / \      "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					call CRLF
					mwrite"|  YOU LOST! | "
					call CRLF
					mwrite"+------------+ "
		dec gameLoop
		cmp gameLoop,0
		jne gameover

		mov  eax,white+(black*16)
		call SetTextColor

		jmp jump_game_start
exit
main ENDP


findstring PROC
	lea edi,manyWords
	mov ecx,len
	mov al,0
searcharray:
	sub edx,1
	jc done
	repne scasb
jmp searcharray

done:
ret
findstring ENDP

makeDash PROC
	mov edx,OFFSET selectedWord
	call StrLength
	mov lengthArray,eax
	mov al,'-'
	mov ecx,lengthArray
	mov edi,OFFSET guessWords
	rep stosb
	mov BYTE PTR [edi],0
	ret
makeDash ENDP


makeGuessLetterArray PROC
	mov edx,OFFSET guessLetterArray
	call StrLength
	mov lengthArray,eax

	mov edi,OFFSET guessLetterArray
	add edi,lengthArray

	mov al,guessLetter
	mov BYTE PTR [edi],al
ret
makeGuessLetterArray ENDP

printHangman PROC
	mov eax,gameLives

	cmp eax,7
	je sevenlife
	cmp eax,6
	je sixlife
	cmp eax, 5
	je fivelife
	cmp eax, 4
	je fourlife
	cmp eax, 3
	je threelife
	cmp eax, 2
	je twolife
	cmp eax, 1
	je onelife
	cmp eax, 0
	je zerolife


sevenlife:
call CRLF
					mwrite"+------+       "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					jmp next
sixlife:
call CRLF
					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					jmp next

	
fivelife:
call CRLF
					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					jmp next

fourlife:
call CRLF
					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					jmp next

threelife: 
call CRLF
					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|     /|       "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					jmp next


twolife:
call CRLF
					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|     /|\      "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					jmp next


onelife:
call CRLF
					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|     /|\      "
					call CRLF
					mwrite"|     /        "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					jmp next

zerolife:
call CRLF
					mwrite"+------+       "
					call CRLF
					mwrite"|      |       "
					call CRLF
					mwrite"|      O       "
					call CRLF
					mwrite"|     /|\      "
					call CRLF
					mwrite"|     / \      "
					call CRLF
					mwrite"|              "
					call CRLF
					mwrite"+------------+ "
					jmp next
next:
	call CRLF
	mov edx,OFFSET guessWords
	call WriteString
	call CRLF
	mwrite"Guess letters are: "
	mov edx,OFFSET guessLetterArray
	call WriteString
	call Crlf
	ret
printHangman ENDP
END main