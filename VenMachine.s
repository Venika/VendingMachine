@ Filename: VenMachine.s

@ Author: Venika Gaur
@ Purpose: Have a vending machine


@ Use these command to assemble, link and run this program

@    as -o VenMachine.o VenMachine.s
@    gcc -o VenMachine VenMachine.o
@    ./VenMachine.s

@ Code
@ Have to use C compiler to link because of C library uses.

.global main @ Have to use main because of C library uses.

main:
push {ip, lr} @Used with pop at end of main, for ease in returning
	@ Start of Code


	@ Start of printing welcome statements
	start_vendingmachine:
		ldr r0, =welcomeStatement1
		bl printf

		ldr r0, =welcomeStatement2
		bl printf
	@ End of printing welcome statements



@prompt for input

	ldr r0, =inputPrompt
	bl printf


@read input character from user

	ldr r7,=num
	ldr r8,[r7]


loop: 	
	
	cmp r8, #55		@checks if the input is equal to 55 cents
	bge selection
	
	
@Prompting the user to enter the value
	ldr r1, =str
	ldr r0, = stringInput
	bl scanf

@storing it in r5
	ldr r5, =str
	ldr r5, [r5]



@Check what the user input is and go to that function

	cmp r5, #'Q'
	beq quater
	
	cmp r5, #'P'
	beq penny
	
	cmp r5, #'D'
	beq dime
	
	cmp r5, #'F'
	beq fifty
	
	cmp r5, #'B'
	beq dollar
	
	cmp r5, #'N'
	beq nickel

	cmp r5, #'R'
	beq ret

	b invalid 	@if the input is invalid i.e. it is not one of the coins, go to invalid function




@All the functions here are the values of coins being entered and it increases the total to make sure it is above 55 cents before proceeding
	
quater:
	mov r6, #25
	add r8,r8,r6
	mov r1,r8
	ldr r0, =total 
	bl printf
	b loop
	

nickel:
	mov r6, #5
	add r8,r8,r6
	mov r1,r8
	ldr r0, =total
	bl printf

	b loop

penny:
	mov r6, #1
	add r8,r8,r6
	mov r1,r8
	ldr r0, =total
	bl printf

	b loop
	

dime:
	mov r6, #10
	add r8,r8,r6
	mov r1,r8
	ldr r0, =total 
	bl printf
	b loop

	

fifty:
	mov r6, #50
	add r8,r8,r6
	mov r1,r8
	ldr r0, =total 
	bl printf
	b loop

dollar:
	mov r6, #100
	add r8,r8,r6
	mov r1,r8
	ldr r0, =total 
	bl printf
	b loop
	



@This is for selecting the drinks and check what is selected

selection:

	ldr r0, =drinkSelect
	bl printf
	ldr r1, =str
	ldr r0, = stringInput
	bl scanf
	
	
	ldr r5, =str
	ldr r5, [r5]

	cmp r5, #'C'	@Selection is coke
	beq coke
	
	cmp r5, #'S'	@Selection is sprite
	beq sprite
	
	cmp r5, #'P'	@Selection is Dr Pepper
	beq pepper
	
	cmp r5, #'D'	@Selection is Diet Coke
	beq dietcoke
	
	cmp r5, #'M'	@Selection is Mellow Yellow
	beq mellow_yellow
	
	cmp r5, #'R'	@They are asking for their money back :(
	beq ret

	b invalid	@if the drink selection is invalid, it goes to the invalid functions and loops

invalid:
	ldr r0, =invalinput
	bl printf
	b loop



@The displays the drink selection

coke:
	
	ldr r0, =cokesel
	bl printf
	b change

sprite:
	ldr r0, =spritesel
	bl printf
	b change

pepper:
	ldr r0, =peppersel
	bl printf
	b change

dietcoke:
	ldr r0, =dietcokesel
	bl printf
	b change

mellow_yellow:
	ldr r0, =mellowsel
	bl printf
	b change



@This returns the money back if user changes their mind

ret:

	ldr r0, =return
	mov r1, r8
	bl printf
	b end



@This returns the extra change back

change:
	ldr r0, =chan
	sub r8, r8, #55
	mov r1, r8
	bl printf
	b end

end:
pop {ip, pc} @Used with push at start of Main, allowing program to end.



.data

@ Output statements

.balign 4
num:.word 0

.balign 4
numOutput: .asciz "%d \n"

.balign 4
welcomeStatement1: .asciz "\t\tWELCOME TO VENIKA'S VENDING MACHINE\n\n"

.balign 4
welcomeStatement2: .asciz "\t\The cost of each drink is 55 cents.\n\n Kindly enter the amount in coins of the following denominations- \n P Penny, N Nickel, D Dime, Q Quarter, F Fifty-cents & B Dollar Bill \n R Return \n"

.balign 4
inputPrompt: .asciz "\nEnter the coin or select return. \n" 

.balign 4 
drinkSelect: .asciz "\nPlease select your drink or return-(C)Coke, (S)Sprite, (P) Dr.Pepper, (D) Diet Coke, or (M) Mellow yellow. Press R to Return\n"

.balign 4
total: .asciz "Your total is %d cents\n"

.balign 4
stringInput: .asciz "%s" 

.balign 4
cokesel: .asciz "You selected Coke. Enjoy your drink!\n"

.balign 4
spritesel: .asciz "You selected Sprite. Enjoy your drink!\n"

.balign 4
peppersel: .asciz "You selected Dr.Pepper. Enjoy your drink!\n"

.balign 4
dietcokesel: .asciz "You selected Diet Coke. Enjoy your drink!\n"

.balign 4
mellowsel: .asciz "You selected Mellow Yellow. Enjoy your drink!\n"


.balign 4
invalinput: .asciz "Invalid input!!! Please choose again.\n"


.balign 4
return: .asciz "Returning back your money :( The total returned is %d cents.\n"

.balign 4
chan: .asciz "The total returned is %d cents.\n"

.balign 4
str: .word 0

.text
	
