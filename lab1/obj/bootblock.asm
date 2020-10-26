
obj/bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    7c00:	fa                   	cli    
    cld                                             # String operations increment
    7c01:	fc                   	cld    

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
    movw %ax, %ds                                   # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
    movw %ax, %ss                                   # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c0a:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c0c:	a8 02                	test   $0x2,%al
    jnz seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    7c14:	e4 64                	in     $0x64,%al
    testb $0x2, %al
    7c16:	a8 02                	test   $0x2,%al
    jnz seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
    7c1c:	e6 60                	out    %al,$0x60

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	6c                   	insb   (%dx),%es:(%edi)
    7c22:	7c 0f                	jl     7c33 <protcseg+0x1>
    movl %cr0, %eax
    7c24:	20 c0                	and    %al,%al
    orl $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
    movl %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh

00007c32 <protcseg>:

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds                                   # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
    movw %ax, %es                                   # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
    movw %ax, %fs                                   # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
    movw %ax, %gs                                   # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
    movw %ax, %ss                                   # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    7c40:	bd 00 00 00 00       	mov    $0x0,%ebp
    movl $start, %esp
    7c45:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    call bootmain
    7c4a:	e8 d5 00 00 00       	call   7d24 <bootmain>

00007c4f <spin>:

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin
    7c4f:	eb fe                	jmp    7c4f <spin>
    7c51:	8d 76 00             	lea    0x0(%esi),%esi

00007c54 <gdt>:
	...
    7c5c:	ff                   	(bad)  
    7c5d:	ff 00                	incl   (%eax)
    7c5f:	00 00                	add    %al,(%eax)
    7c61:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c68:	00                   	.byte 0x0
    7c69:	92                   	xchg   %eax,%edx
    7c6a:	cf                   	iret   
	...

00007c6c <gdtdesc>:
    7c6c:	17                   	pop    %ss
    7c6d:	00 54 7c 00          	add    %dl,0x0(%esp,%edi,2)
	...

00007c72 <readseg>:
/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c72:	55                   	push   %ebp
    7c73:	89 e5                	mov    %esp,%ebp
    7c75:	57                   	push   %edi
    7c76:	56                   	push   %esi
    7c77:	e8 30 01 00 00       	call   7dac <__x86.get_pc_thunk.si>
    7c7c:	81 c6 cc 01 00 00    	add    $0x1cc,%esi
    7c82:	53                   	push   %ebx
    7c83:	89 c3                	mov    %eax,%ebx
    uintptr_t end_va = va + count;
    7c85:	01 d0                	add    %edx,%eax
    7c87:	31 d2                	xor    %edx,%edx
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    7c89:	83 ec 08             	sub    $0x8,%esp
    uintptr_t end_va = va + count;
    7c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    7c8f:	89 c8                	mov    %ecx,%eax
    7c91:	f7 b6 10 00 00 00    	divl   0x10(%esi)

    // round down to sector boundary
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;
    7c97:	40                   	inc    %eax
    va -= offset % SECTSIZE;
    7c98:	29 d3                	sub    %edx,%ebx
    uint32_t secno = (offset / SECTSIZE) + 1;
    7c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7c9d:	3b 5d ec             	cmp    -0x14(%ebp),%ebx
    7ca0:	73 7b                	jae    7d1d <readseg+0xab>
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7ca2:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7ca7:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7ca8:	83 e0 c0             	and    $0xffffffc0,%eax
    7cab:	3c 40                	cmp    $0x40,%al
    7cad:	75 f3                	jne    7ca2 <readseg+0x30>
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
    7caf:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cb4:	b0 01                	mov    $0x1,%al
    7cb6:	ee                   	out    %al,(%dx)
    7cb7:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7cbc:	8a 45 f0             	mov    -0x10(%ebp),%al
    7cbf:	ee                   	out    %al,(%dx)
    outb(0x1F4, (secno >> 8) & 0xFF);
    7cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7cc3:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cc8:	c1 e8 08             	shr    $0x8,%eax
    7ccb:	ee                   	out    %al,(%dx)
    outb(0x1F5, (secno >> 16) & 0xFF);
    7ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7ccf:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7cd4:	c1 e8 10             	shr    $0x10,%eax
    7cd7:	ee                   	out    %al,(%dx)
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    7cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7cdb:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7ce0:	c1 e8 18             	shr    $0x18,%eax
    7ce3:	83 e0 0f             	and    $0xf,%eax
    7ce6:	83 c8 e0             	or     $0xffffffe0,%eax
    7ce9:	ee                   	out    %al,(%dx)
    7cea:	b0 20                	mov    $0x20,%al
    7cec:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cf1:	ee                   	out    %al,(%dx)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7cf2:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cf7:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7cf8:	83 e0 c0             	and    $0xffffffc0,%eax
    7cfb:	3c 40                	cmp    $0x40,%al
    7cfd:	75 f3                	jne    7cf2 <readseg+0x80>
    insl(0x1F0, dst, SECTSIZE / 4);
    7cff:	8b 8e 10 00 00 00    	mov    0x10(%esi),%ecx
    asm volatile (
    7d05:	89 df                	mov    %ebx,%edi
    7d07:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7d0c:	c1 e9 02             	shr    $0x2,%ecx
    7d0f:	fc                   	cld    
    7d10:	f2 6d                	repnz insl (%dx),%es:(%edi)
    for (; va < end_va; va += SECTSIZE, secno ++) {
    7d12:	ff 45 f0             	incl   -0x10(%ebp)
    7d15:	03 9e 10 00 00 00    	add    0x10(%esi),%ebx
    7d1b:	eb 80                	jmp    7c9d <readseg+0x2b>
        readsect((void *)va, secno);
    }
}
    7d1d:	58                   	pop    %eax
    7d1e:	5a                   	pop    %edx
    7d1f:	5b                   	pop    %ebx
    7d20:	5e                   	pop    %esi
    7d21:	5f                   	pop    %edi
    7d22:	5d                   	pop    %ebp
    7d23:	c3                   	ret    

00007d24 <bootmain>:

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    7d24:	f3 0f 1e fb          	endbr32 
    7d28:	55                   	push   %ebp
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d29:	31 c9                	xor    %ecx,%ecx
bootmain(void) {
    7d2b:	89 e5                	mov    %esp,%ebp
    7d2d:	57                   	push   %edi
    7d2e:	e8 7d 00 00 00       	call   7db0 <__x86.get_pc_thunk.di>
    7d33:	81 c7 15 01 00 00    	add    $0x115,%edi
    7d39:	56                   	push   %esi
    7d3a:	53                   	push   %ebx
    7d3b:	83 ec 0c             	sub    $0xc,%esp
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    7d3e:	8b 97 10 00 00 00    	mov    0x10(%edi),%edx
    7d44:	8b 87 0c 00 00 00    	mov    0xc(%edi),%eax
    7d4a:	c1 e2 03             	shl    $0x3,%edx
    7d4d:	e8 20 ff ff ff       	call   7c72 <readseg>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
    7d52:	8b 87 0c 00 00 00    	mov    0xc(%edi),%eax
    7d58:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
    7d5e:	75 3a                	jne    7d9a <bootmain+0x76>
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d60:	8b 58 1c             	mov    0x1c(%eax),%ebx
    eph = ph + ELFHDR->e_phnum;
    7d63:	0f b7 70 2c          	movzwl 0x2c(%eax),%esi
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    7d67:	01 c3                	add    %eax,%ebx
    eph = ph + ELFHDR->e_phnum;
    7d69:	c1 e6 05             	shl    $0x5,%esi
    7d6c:	01 de                	add    %ebx,%esi
    for (; ph < eph; ph ++) {
    7d6e:	39 f3                	cmp    %esi,%ebx
    7d70:	73 18                	jae    7d8a <bootmain+0x66>
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d72:	8b 43 08             	mov    0x8(%ebx),%eax
    7d75:	8b 4b 04             	mov    0x4(%ebx),%ecx
    for (; ph < eph; ph ++) {
    7d78:	83 c3 20             	add    $0x20,%ebx
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    7d7b:	8b 53 f4             	mov    -0xc(%ebx),%edx
    7d7e:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d83:	e8 ea fe ff ff       	call   7c72 <readseg>
    7d88:	eb e4                	jmp    7d6e <bootmain+0x4a>
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
    7d8a:	8b 87 0c 00 00 00    	mov    0xc(%edi),%eax
    7d90:	8b 40 18             	mov    0x18(%eax),%eax
    7d93:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d98:	ff d0                	call   *%eax
}

static inline void
outw(uint16_t port, uint16_t data) {
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port));
    7d9a:	ba 00 8a ff ff       	mov    $0xffff8a00,%edx
    7d9f:	89 d0                	mov    %edx,%eax
    7da1:	66 ef                	out    %ax,(%dx)
    7da3:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7da8:	66 ef                	out    %ax,(%dx)
    7daa:	eb fe                	jmp    7daa <bootmain+0x86>

00007dac <__x86.get_pc_thunk.si>:
    7dac:	8b 34 24             	mov    (%esp),%esi
    7daf:	c3                   	ret    

00007db0 <__x86.get_pc_thunk.di>:
    7db0:	8b 3c 24             	mov    (%esp),%edi
    7db3:	c3                   	ret    
