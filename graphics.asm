.data

.type window, @object
.type window_width, @object
.type window_height, @object
.type window_name, @object
.type glfw_err_msg, @object

window:

	.quad 0x00

window_width:

	.byte 0x00

window_height:

	.byte 0x00

window_name:

	.ascii "Hello There\0"

glfw_err_msg:

	.ascii "[%d] %s\n\0"

.text

.global create_window

.extern glfwSetErrorCallback
.extern glfwInit
.extern glfwWindowHint
.extern glfwCreateWindow
.extern glfwMakeContextCurrent
.extern glfwWindowShouldClose
.extern glfwPollEvents
.extern glfwDestroyWindow
.extern glfwTerminate
.extern printf

.type create_window, @function
.type window_creation_start, @notype
.type window_creation_error, @notype
.type window_loop, @notype
.type terminate_window, @notype
.type handle_glfw_error, @function

/*
 *
 * Creates a GLFW window.
 *
 * @param rdi
 *   The name of the window.
 *
 * @param esi
 *   The width of the window.
 *
 * @param edx
 *   The height of the window.
 *
 * @param ecx
 *   A flag that determines if GLFW errors are handled.
 *
 * @returns
 *   0 if the window creation is succesful; 1 if unsuccessful.
 *
 */

create_window:

	pushq %rbp
	movq %rsp, %rbp

	// movq %rdi, window_name
	// movl %esi, window_width
	// movl %edx, window_height

	cmpl $0x00, %ecx
	je window_creation_start

	leaq handle_glfw_error, %rdi
	callq glfwSetErrorCallback

window_creation_start:

	callq glfwInit

	cmpl $0x01, %eax
	jne window_creation_error

	movl $0x00022002, %edi
	movl $0x03, %esi
	callq glfwWindowHint

	movl $0x00022003, %edi
	movl $0x03, %esi
	callq glfwWindowHint

	movl $0x00022007, %edi
	movl $0x01, %esi
	callq glfwWindowHint

	movl $0x00022001, %edi
	movl $0x00030001, %esi
	callq glfwWindowHint

	movl $0x00022008, %edi
	movl $0x00032001, %esi
	callq glfwWindowHint
/*
	movl $window_width, %edi
	movl $window_height, %esi
	*/

	movl $0x0320, %edi
	movl $0x0320, %esi
	movq $window_name, %rdx
	xorq %rcx, %rcx
	xorq %r8, %r8
	callq glfwCreateWindow

	cmpq $0x00, %rax
	je window_creation_error

	movq %rax, window

	movq %rax, %rdi
	callq glfwMakeContextCurrent

window_loop:

	movq $window, %rdi
	callq glfwWindowShouldClose
	
	cmpq $0x00, %rax
	je terminate_window

	callq glfwPollEvents

	jmp window_loop

terminate_window:

	movq $window, %rdi
	callq glfwDestroyWindow

	callq glfwTerminate
	
	xorl %eax, %eax
	popq %rbp
	retq

window_creation_error:

	callq glfwTerminate

	movl $0x01, %eax
	popq %rbp
	retq

/*
 *
 * Handles a GLFW error.
 *
 * @param edi
 *   A numeric ID for the error.
 *
 * @param rsi
 *   The error message.
 *
 */

handle_glfw_error:

	pushq %rbp
	movq %rsp, %rbp

	movq %rsi, %rdx
	movl %edi, %esi
	movq $glfw_err_msg, %rdi
	callq printf

	popq %rbp
	retq
