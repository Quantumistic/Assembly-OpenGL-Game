.data

.type msg, @object
.type window_creation_err_msg, @object

name:

	.ascii "Assembly Game\0"

window_creation_err_msg:

	.ascii "Window Creation Failed\n\0"

.text

.global _start

.extern create_window
.extern exit
.extern printf

.type _start, @function
.type window_creation_error, @notype

/*
 *
 * The entrypoint to the program
 *
 */

_start:

	movq $name, %rdi
	movl $0x0320, %esi
	movl $0x0320, %edx
	movl $0x01, %ecx
	callq create_window

	cmpl $0x01, %eax
	je window_creation_error

	xorl %edi, %edi
	callq exit

window_creation_error:

	movq $window_creation_err_msg, %rdi
	callq printf

	movl $0x01, %edi
	callq exit
