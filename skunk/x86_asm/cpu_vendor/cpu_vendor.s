	.text
.globl cpu_vendor
	.type	cpu_vendor, @function
cpu_vendor:
	pushl	%ebp
	movl	%esp, %ebp

	movl	$0, %eax
	cpuid
	movl	$buffer, %edi
	movl	%ebx, (%edi)
	movl	%edx, 4(%edi)
	movl	%ecx, 8(%edi)
	movb	$0, 12(%edi)

	movl	$buffer, %eax
	popl	%ebp
	ret
	.size	cpu_vendor, .-cpu_vendor
	.local	buffer
	.comm	buffer,13,1
	.section	.note.GNU-stack,"",@progbits
