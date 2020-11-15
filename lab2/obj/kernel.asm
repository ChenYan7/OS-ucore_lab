
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba c8 89 11 c0       	mov    $0xc01189c8,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 1f 5f 00 00       	call   c0105f75 <memset>

    cons_init();                // init the console
c0100056:	e8 5d 15 00 00       	call   c01015b8 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 00 61 10 c0 	movl   $0xc0106100,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 1c 61 10 c0 	movl   $0xc010611c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 0d 44 00 00       	call   c0104491 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 98 16 00 00       	call   c0101721 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 10 18 00 00       	call   c010189e <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 db 0c 00 00       	call   c0100d6e <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 f7 15 00 00       	call   c010168f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 e4 0b 00 00       	call   c0100ca0 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 21 61 10 c0 	movl   $0xc0106121,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 2f 61 10 c0 	movl   $0xc010612f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 3d 61 10 c0 	movl   $0xc010613d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 4b 61 10 c0 	movl   $0xc010614b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 59 61 10 c0 	movl   $0xc0106159,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 68 61 10 c0 	movl   $0xc0106168,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 88 61 10 c0 	movl   $0xc0106188,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 a7 61 10 c0 	movl   $0xc01061a7,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 ea 12 00 00       	call   c01015e4 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 57 54 00 00       	call   c010578e <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 71 12 00 00       	call   c01015e4 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 51 12 00 00       	call   c0101620 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 ac 61 10 c0    	movl   $0xc01061ac,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 ac 61 10 c0 	movl   $0xc01061ac,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 20 74 10 c0 	movl   $0xc0107420,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 d0 20 11 c0 	movl   $0xc01120d0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec d1 20 11 c0 	movl   $0xc01120d1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 58 4b 11 c0 	movl   $0xc0114b58,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 fd 56 00 00       	call   c0105de9 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 b6 61 10 c0 	movl   $0xc01061b6,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 cf 61 10 c0 	movl   $0xc01061cf,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 fe 60 10 	movl   $0xc01060fe,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 e7 61 10 c0 	movl   $0xc01061e7,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 ff 61 10 c0 	movl   $0xc01061ff,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 c8 89 11 	movl   $0xc01189c8,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 17 62 10 c0 	movl   $0xc0106217,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 30 62 10 c0 	movl   $0xc0106230,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 5a 62 10 c0 	movl   $0xc010625a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 76 62 10 c0 	movl   $0xc0106276,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	53                   	push   %ebx
c01009be:	83 ec 34             	sub    $0x34,%esp
     uint32_t *ebp = 0;
c01009c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     uint32_t esp = 0;
c01009c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cf:	89 e8                	mov    %ebp,%eax
c01009d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
c01009d4:	8b 45 ec             	mov    -0x14(%ebp),%eax

     ebp = (uint32_t *)read_ebp();
c01009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
     esp = read_eip();
c01009da:	e8 ca ff ff ff       	call   c01009a9 <read_eip>
c01009df:	89 45 f0             	mov    %eax,-0x10(%ebp)

     while (ebp)
c01009e2:	eb 75                	jmp    c0100a59 <print_stackframe+0x9f>
     {
         cprintf("ebp:0x%08x eip:0x%08x args:", (uint32_t)ebp, esp);
c01009e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01009ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f2:	c7 04 24 88 62 10 c0 	movl   $0xc0106288,(%esp)
c01009f9:	e8 3e f9 ff ff       	call   c010033c <cprintf>
         cprintf("0x%08x 0x%08x 0x%08x 0x%08x\n", ebp[2], ebp[3], ebp[4], ebp[5]);
c01009fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a01:	83 c0 14             	add    $0x14,%eax
c0100a04:	8b 18                	mov    (%eax),%ebx
c0100a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a09:	83 c0 10             	add    $0x10,%eax
c0100a0c:	8b 08                	mov    (%eax),%ecx
c0100a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a11:	83 c0 0c             	add    $0xc,%eax
c0100a14:	8b 10                	mov    (%eax),%edx
c0100a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a19:	83 c0 08             	add    $0x8,%eax
c0100a1c:	8b 00                	mov    (%eax),%eax
c0100a1e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100a22:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a26:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2e:	c7 04 24 a4 62 10 c0 	movl   $0xc01062a4,(%esp)
c0100a35:	e8 02 f9 ff ff       	call   c010033c <cprintf>

         print_debuginfo(esp - 1);
c0100a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a3d:	83 e8 01             	sub    $0x1,%eax
c0100a40:	89 04 24             	mov    %eax,(%esp)
c0100a43:	e8 be fe ff ff       	call   c0100906 <print_debuginfo>

         esp = ebp[1];
c0100a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a4b:	8b 40 04             	mov    0x4(%eax),%eax
c0100a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
         ebp = (uint32_t *)*ebp;
c0100a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a54:	8b 00                	mov    (%eax),%eax
c0100a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t esp = 0;

     ebp = (uint32_t *)read_ebp();
     esp = read_eip();

     while (ebp)
c0100a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a5d:	75 85                	jne    c01009e4 <print_stackframe+0x2a>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100a5f:	83 c4 34             	add    $0x34,%esp
c0100a62:	5b                   	pop    %ebx
c0100a63:	5d                   	pop    %ebp
c0100a64:	c3                   	ret    

c0100a65 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a65:	55                   	push   %ebp
c0100a66:	89 e5                	mov    %esp,%ebp
c0100a68:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a72:	eb 0c                	jmp    c0100a80 <parse+0x1b>
            *buf ++ = '\0';
c0100a74:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a77:	8d 50 01             	lea    0x1(%eax),%edx
c0100a7a:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a7d:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a83:	0f b6 00             	movzbl (%eax),%eax
c0100a86:	84 c0                	test   %al,%al
c0100a88:	74 1d                	je     c0100aa7 <parse+0x42>
c0100a8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8d:	0f b6 00             	movzbl (%eax),%eax
c0100a90:	0f be c0             	movsbl %al,%eax
c0100a93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a97:	c7 04 24 44 63 10 c0 	movl   $0xc0106344,(%esp)
c0100a9e:	e8 13 53 00 00       	call   c0105db6 <strchr>
c0100aa3:	85 c0                	test   %eax,%eax
c0100aa5:	75 cd                	jne    c0100a74 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aaa:	0f b6 00             	movzbl (%eax),%eax
c0100aad:	84 c0                	test   %al,%al
c0100aaf:	75 02                	jne    c0100ab3 <parse+0x4e>
            break;
c0100ab1:	eb 67                	jmp    c0100b1a <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ab3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ab7:	75 14                	jne    c0100acd <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ab9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ac0:	00 
c0100ac1:	c7 04 24 49 63 10 c0 	movl   $0xc0106349,(%esp)
c0100ac8:	e8 6f f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad0:	8d 50 01             	lea    0x1(%eax),%edx
c0100ad3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100ad6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100add:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ae0:	01 c2                	add    %eax,%edx
c0100ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ae5:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ae7:	eb 04                	jmp    c0100aed <parse+0x88>
            buf ++;
c0100ae9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af0:	0f b6 00             	movzbl (%eax),%eax
c0100af3:	84 c0                	test   %al,%al
c0100af5:	74 1d                	je     c0100b14 <parse+0xaf>
c0100af7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100afa:	0f b6 00             	movzbl (%eax),%eax
c0100afd:	0f be c0             	movsbl %al,%eax
c0100b00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b04:	c7 04 24 44 63 10 c0 	movl   $0xc0106344,(%esp)
c0100b0b:	e8 a6 52 00 00       	call   c0105db6 <strchr>
c0100b10:	85 c0                	test   %eax,%eax
c0100b12:	74 d5                	je     c0100ae9 <parse+0x84>
            buf ++;
        }
    }
c0100b14:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b15:	e9 66 ff ff ff       	jmp    c0100a80 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b1d:	c9                   	leave  
c0100b1e:	c3                   	ret    

c0100b1f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b1f:	55                   	push   %ebp
c0100b20:	89 e5                	mov    %esp,%ebp
c0100b22:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b25:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b2f:	89 04 24             	mov    %eax,(%esp)
c0100b32:	e8 2e ff ff ff       	call   c0100a65 <parse>
c0100b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b3e:	75 0a                	jne    c0100b4a <runcmd+0x2b>
        return 0;
c0100b40:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b45:	e9 85 00 00 00       	jmp    c0100bcf <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b51:	eb 5c                	jmp    c0100baf <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b53:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b59:	89 d0                	mov    %edx,%eax
c0100b5b:	01 c0                	add    %eax,%eax
c0100b5d:	01 d0                	add    %edx,%eax
c0100b5f:	c1 e0 02             	shl    $0x2,%eax
c0100b62:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b67:	8b 00                	mov    (%eax),%eax
c0100b69:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b6d:	89 04 24             	mov    %eax,(%esp)
c0100b70:	e8 a2 51 00 00       	call   c0105d17 <strcmp>
c0100b75:	85 c0                	test   %eax,%eax
c0100b77:	75 32                	jne    c0100bab <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b7c:	89 d0                	mov    %edx,%eax
c0100b7e:	01 c0                	add    %eax,%eax
c0100b80:	01 d0                	add    %edx,%eax
c0100b82:	c1 e0 02             	shl    $0x2,%eax
c0100b85:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b8a:	8b 40 08             	mov    0x8(%eax),%eax
c0100b8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100b90:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100b93:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100b96:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b9a:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100b9d:	83 c2 04             	add    $0x4,%edx
c0100ba0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100ba4:	89 0c 24             	mov    %ecx,(%esp)
c0100ba7:	ff d0                	call   *%eax
c0100ba9:	eb 24                	jmp    c0100bcf <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bb2:	83 f8 02             	cmp    $0x2,%eax
c0100bb5:	76 9c                	jbe    c0100b53 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bb7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bbe:	c7 04 24 67 63 10 c0 	movl   $0xc0106367,(%esp)
c0100bc5:	e8 72 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bcf:	c9                   	leave  
c0100bd0:	c3                   	ret    

c0100bd1 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bd1:	55                   	push   %ebp
c0100bd2:	89 e5                	mov    %esp,%ebp
c0100bd4:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bd7:	c7 04 24 80 63 10 c0 	movl   $0xc0106380,(%esp)
c0100bde:	e8 59 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100be3:	c7 04 24 a8 63 10 c0 	movl   $0xc01063a8,(%esp)
c0100bea:	e8 4d f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100bef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100bf3:	74 0b                	je     c0100c00 <kmonitor+0x2f>
        print_trapframe(tf);
c0100bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bf8:	89 04 24             	mov    %eax,(%esp)
c0100bfb:	e8 55 0e 00 00       	call   c0101a55 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c00:	c7 04 24 cd 63 10 c0 	movl   $0xc01063cd,(%esp)
c0100c07:	e8 27 f6 ff ff       	call   c0100233 <readline>
c0100c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c13:	74 18                	je     c0100c2d <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c1f:	89 04 24             	mov    %eax,(%esp)
c0100c22:	e8 f8 fe ff ff       	call   c0100b1f <runcmd>
c0100c27:	85 c0                	test   %eax,%eax
c0100c29:	79 02                	jns    c0100c2d <kmonitor+0x5c>
                break;
c0100c2b:	eb 02                	jmp    c0100c2f <kmonitor+0x5e>
            }
        }
    }
c0100c2d:	eb d1                	jmp    c0100c00 <kmonitor+0x2f>
}
c0100c2f:	c9                   	leave  
c0100c30:	c3                   	ret    

c0100c31 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c31:	55                   	push   %ebp
c0100c32:	89 e5                	mov    %esp,%ebp
c0100c34:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c3e:	eb 3f                	jmp    c0100c7f <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c40:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c43:	89 d0                	mov    %edx,%eax
c0100c45:	01 c0                	add    %eax,%eax
c0100c47:	01 d0                	add    %edx,%eax
c0100c49:	c1 e0 02             	shl    $0x2,%eax
c0100c4c:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c51:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c57:	89 d0                	mov    %edx,%eax
c0100c59:	01 c0                	add    %eax,%eax
c0100c5b:	01 d0                	add    %edx,%eax
c0100c5d:	c1 e0 02             	shl    $0x2,%eax
c0100c60:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c65:	8b 00                	mov    (%eax),%eax
c0100c67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c6f:	c7 04 24 d1 63 10 c0 	movl   $0xc01063d1,(%esp)
c0100c76:	e8 c1 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c7b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c82:	83 f8 02             	cmp    $0x2,%eax
c0100c85:	76 b9                	jbe    c0100c40 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c8c:	c9                   	leave  
c0100c8d:	c3                   	ret    

c0100c8e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c8e:	55                   	push   %ebp
c0100c8f:	89 e5                	mov    %esp,%ebp
c0100c91:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c94:	e8 d7 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c9e:	c9                   	leave  
c0100c9f:	c3                   	ret    

c0100ca0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ca0:	55                   	push   %ebp
c0100ca1:	89 e5                	mov    %esp,%ebp
c0100ca3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ca6:	e8 0f fd ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb0:	c9                   	leave  
c0100cb1:	c3                   	ret    

c0100cb2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cb2:	55                   	push   %ebp
c0100cb3:	89 e5                	mov    %esp,%ebp
c0100cb5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cb8:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cbd:	85 c0                	test   %eax,%eax
c0100cbf:	74 02                	je     c0100cc3 <__panic+0x11>
        goto panic_dead;
c0100cc1:	eb 48                	jmp    c0100d0b <__panic+0x59>
    }
    is_panic = 1;
c0100cc3:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cca:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ccd:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cd6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce1:	c7 04 24 da 63 10 c0 	movl   $0xc01063da,(%esp)
c0100ce8:	e8 4f f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf4:	8b 45 10             	mov    0x10(%ebp),%eax
c0100cf7:	89 04 24             	mov    %eax,(%esp)
c0100cfa:	e8 0a f6 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100cff:	c7 04 24 f6 63 10 c0 	movl   $0xc01063f6,(%esp)
c0100d06:	e8 31 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d0b:	e8 85 09 00 00       	call   c0101695 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d17:	e8 b5 fe ff ff       	call   c0100bd1 <kmonitor>
    }
c0100d1c:	eb f2                	jmp    c0100d10 <__panic+0x5e>

c0100d1e <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d1e:	55                   	push   %ebp
c0100d1f:	89 e5                	mov    %esp,%ebp
c0100d21:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d24:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d2d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d31:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d38:	c7 04 24 f8 63 10 c0 	movl   $0xc01063f8,(%esp)
c0100d3f:	e8 f8 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4b:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d4e:	89 04 24             	mov    %eax,(%esp)
c0100d51:	e8 b3 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d56:	c7 04 24 f6 63 10 c0 	movl   $0xc01063f6,(%esp)
c0100d5d:	e8 da f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d62:	c9                   	leave  
c0100d63:	c3                   	ret    

c0100d64 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d64:	55                   	push   %ebp
c0100d65:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d67:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d6c:	5d                   	pop    %ebp
c0100d6d:	c3                   	ret    

c0100d6e <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d6e:	55                   	push   %ebp
c0100d6f:	89 e5                	mov    %esp,%ebp
c0100d71:	83 ec 28             	sub    $0x28,%esp
c0100d74:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d7a:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d7e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d82:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d86:	ee                   	out    %al,(%dx)
c0100d87:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d8d:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d91:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d95:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d99:	ee                   	out    %al,(%dx)
c0100d9a:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100da0:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100da4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100da8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dac:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dad:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100db4:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100db7:	c7 04 24 16 64 10 c0 	movl   $0xc0106416,(%esp)
c0100dbe:	e8 79 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dc3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dca:	e8 24 09 00 00       	call   c01016f3 <pic_enable>
}
c0100dcf:	c9                   	leave  
c0100dd0:	c3                   	ret    

c0100dd1 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dd1:	55                   	push   %ebp
c0100dd2:	89 e5                	mov    %esp,%ebp
c0100dd4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dd7:	9c                   	pushf  
c0100dd8:	58                   	pop    %eax
c0100dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100ddf:	25 00 02 00 00       	and    $0x200,%eax
c0100de4:	85 c0                	test   %eax,%eax
c0100de6:	74 0c                	je     c0100df4 <__intr_save+0x23>
        intr_disable();
c0100de8:	e8 a8 08 00 00       	call   c0101695 <intr_disable>
        return 1;
c0100ded:	b8 01 00 00 00       	mov    $0x1,%eax
c0100df2:	eb 05                	jmp    c0100df9 <__intr_save+0x28>
    }
    return 0;
c0100df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df9:	c9                   	leave  
c0100dfa:	c3                   	ret    

c0100dfb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100dfb:	55                   	push   %ebp
c0100dfc:	89 e5                	mov    %esp,%ebp
c0100dfe:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e05:	74 05                	je     c0100e0c <__intr_restore+0x11>
        intr_enable();
c0100e07:	e8 83 08 00 00       	call   c010168f <intr_enable>
    }
}
c0100e0c:	c9                   	leave  
c0100e0d:	c3                   	ret    

c0100e0e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e0e:	55                   	push   %ebp
c0100e0f:	89 e5                	mov    %esp,%ebp
c0100e11:	83 ec 10             	sub    $0x10,%esp
c0100e14:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e1a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e1e:	89 c2                	mov    %eax,%edx
c0100e20:	ec                   	in     (%dx),%al
c0100e21:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e24:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e2a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e2e:	89 c2                	mov    %eax,%edx
c0100e30:	ec                   	in     (%dx),%al
c0100e31:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e34:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e3a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e3e:	89 c2                	mov    %eax,%edx
c0100e40:	ec                   	in     (%dx),%al
c0100e41:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e44:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e4a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e4e:	89 c2                	mov    %eax,%edx
c0100e50:	ec                   	in     (%dx),%al
c0100e51:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e54:	c9                   	leave  
c0100e55:	c3                   	ret    

c0100e56 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e56:	55                   	push   %ebp
c0100e57:	89 e5                	mov    %esp,%ebp
c0100e59:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e5c:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e66:	0f b7 00             	movzwl (%eax),%eax
c0100e69:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e70:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e78:	0f b7 00             	movzwl (%eax),%eax
c0100e7b:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e7f:	74 12                	je     c0100e93 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e81:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e88:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e8f:	b4 03 
c0100e91:	eb 13                	jmp    c0100ea6 <cga_init+0x50>
    } else {
        *cp = was;
c0100e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e96:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e9a:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e9d:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ea4:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ea6:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ead:	0f b7 c0             	movzwl %ax,%eax
c0100eb0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100eb4:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ebc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ec0:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ec1:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec8:	83 c0 01             	add    $0x1,%eax
c0100ecb:	0f b7 c0             	movzwl %ax,%eax
c0100ece:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ed2:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ed6:	89 c2                	mov    %eax,%edx
c0100ed8:	ec                   	in     (%dx),%al
c0100ed9:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100edc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ee0:	0f b6 c0             	movzbl %al,%eax
c0100ee3:	c1 e0 08             	shl    $0x8,%eax
c0100ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ee9:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ef0:	0f b7 c0             	movzwl %ax,%eax
c0100ef3:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100ef7:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100efb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100eff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f03:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f04:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f0b:	83 c0 01             	add    $0x1,%eax
c0100f0e:	0f b7 c0             	movzwl %ax,%eax
c0100f11:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f15:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f19:	89 c2                	mov    %eax,%edx
c0100f1b:	ec                   	in     (%dx),%al
c0100f1c:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f1f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f23:	0f b6 c0             	movzbl %al,%eax
c0100f26:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f2c:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f34:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f3a:	c9                   	leave  
c0100f3b:	c3                   	ret    

c0100f3c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f3c:	55                   	push   %ebp
c0100f3d:	89 e5                	mov    %esp,%ebp
c0100f3f:	83 ec 48             	sub    $0x48,%esp
c0100f42:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f48:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f4c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f50:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f54:	ee                   	out    %al,(%dx)
c0100f55:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f5b:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f5f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f63:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f67:	ee                   	out    %al,(%dx)
c0100f68:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f6e:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f72:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f76:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f7a:	ee                   	out    %al,(%dx)
c0100f7b:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f81:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f85:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f89:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f8d:	ee                   	out    %al,(%dx)
c0100f8e:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100f94:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100f98:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f9c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fa0:	ee                   	out    %al,(%dx)
c0100fa1:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fa7:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fab:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100faf:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fb3:	ee                   	out    %al,(%dx)
c0100fb4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fba:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fbe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fc2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fc6:	ee                   	out    %al,(%dx)
c0100fc7:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fcd:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fd1:	89 c2                	mov    %eax,%edx
c0100fd3:	ec                   	in     (%dx),%al
c0100fd4:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100fd7:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fdb:	3c ff                	cmp    $0xff,%al
c0100fdd:	0f 95 c0             	setne  %al
c0100fe0:	0f b6 c0             	movzbl %al,%eax
c0100fe3:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100fe8:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fee:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0100ff2:	89 c2                	mov    %eax,%edx
c0100ff4:	ec                   	in     (%dx),%al
c0100ff5:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0100ff8:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0100ffe:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101002:	89 c2                	mov    %eax,%edx
c0101004:	ec                   	in     (%dx),%al
c0101005:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101008:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010100d:	85 c0                	test   %eax,%eax
c010100f:	74 0c                	je     c010101d <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101011:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101018:	e8 d6 06 00 00       	call   c01016f3 <pic_enable>
    }
}
c010101d:	c9                   	leave  
c010101e:	c3                   	ret    

c010101f <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010101f:	55                   	push   %ebp
c0101020:	89 e5                	mov    %esp,%ebp
c0101022:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101025:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010102c:	eb 09                	jmp    c0101037 <lpt_putc_sub+0x18>
        delay();
c010102e:	e8 db fd ff ff       	call   c0100e0e <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101033:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101037:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010103d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101041:	89 c2                	mov    %eax,%edx
c0101043:	ec                   	in     (%dx),%al
c0101044:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101047:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010104b:	84 c0                	test   %al,%al
c010104d:	78 09                	js     c0101058 <lpt_putc_sub+0x39>
c010104f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101056:	7e d6                	jle    c010102e <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101058:	8b 45 08             	mov    0x8(%ebp),%eax
c010105b:	0f b6 c0             	movzbl %al,%eax
c010105e:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101064:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101067:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010106b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010106f:	ee                   	out    %al,(%dx)
c0101070:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101076:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010107a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010107e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101082:	ee                   	out    %al,(%dx)
c0101083:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c0101089:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c010108d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101091:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101095:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101096:	c9                   	leave  
c0101097:	c3                   	ret    

c0101098 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101098:	55                   	push   %ebp
c0101099:	89 e5                	mov    %esp,%ebp
c010109b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010109e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010a2:	74 0d                	je     c01010b1 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010a7:	89 04 24             	mov    %eax,(%esp)
c01010aa:	e8 70 ff ff ff       	call   c010101f <lpt_putc_sub>
c01010af:	eb 24                	jmp    c01010d5 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010b1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010b8:	e8 62 ff ff ff       	call   c010101f <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010bd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010c4:	e8 56 ff ff ff       	call   c010101f <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010c9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d0:	e8 4a ff ff ff       	call   c010101f <lpt_putc_sub>
    }
}
c01010d5:	c9                   	leave  
c01010d6:	c3                   	ret    

c01010d7 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010d7:	55                   	push   %ebp
c01010d8:	89 e5                	mov    %esp,%ebp
c01010da:	53                   	push   %ebx
c01010db:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010de:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e1:	b0 00                	mov    $0x0,%al
c01010e3:	85 c0                	test   %eax,%eax
c01010e5:	75 07                	jne    c01010ee <cga_putc+0x17>
        c |= 0x0700;
c01010e7:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f1:	0f b6 c0             	movzbl %al,%eax
c01010f4:	83 f8 0a             	cmp    $0xa,%eax
c01010f7:	74 4c                	je     c0101145 <cga_putc+0x6e>
c01010f9:	83 f8 0d             	cmp    $0xd,%eax
c01010fc:	74 57                	je     c0101155 <cga_putc+0x7e>
c01010fe:	83 f8 08             	cmp    $0x8,%eax
c0101101:	0f 85 88 00 00 00    	jne    c010118f <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101107:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010110e:	66 85 c0             	test   %ax,%ax
c0101111:	74 30                	je     c0101143 <cga_putc+0x6c>
            crt_pos --;
c0101113:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010111a:	83 e8 01             	sub    $0x1,%eax
c010111d:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101123:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101128:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010112f:	0f b7 d2             	movzwl %dx,%edx
c0101132:	01 d2                	add    %edx,%edx
c0101134:	01 c2                	add    %eax,%edx
c0101136:	8b 45 08             	mov    0x8(%ebp),%eax
c0101139:	b0 00                	mov    $0x0,%al
c010113b:	83 c8 20             	or     $0x20,%eax
c010113e:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101141:	eb 72                	jmp    c01011b5 <cga_putc+0xde>
c0101143:	eb 70                	jmp    c01011b5 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101145:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010114c:	83 c0 50             	add    $0x50,%eax
c010114f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101155:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c010115c:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101163:	0f b7 c1             	movzwl %cx,%eax
c0101166:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010116c:	c1 e8 10             	shr    $0x10,%eax
c010116f:	89 c2                	mov    %eax,%edx
c0101171:	66 c1 ea 06          	shr    $0x6,%dx
c0101175:	89 d0                	mov    %edx,%eax
c0101177:	c1 e0 02             	shl    $0x2,%eax
c010117a:	01 d0                	add    %edx,%eax
c010117c:	c1 e0 04             	shl    $0x4,%eax
c010117f:	29 c1                	sub    %eax,%ecx
c0101181:	89 ca                	mov    %ecx,%edx
c0101183:	89 d8                	mov    %ebx,%eax
c0101185:	29 d0                	sub    %edx,%eax
c0101187:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c010118d:	eb 26                	jmp    c01011b5 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010118f:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c0101195:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010119c:	8d 50 01             	lea    0x1(%eax),%edx
c010119f:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011a6:	0f b7 c0             	movzwl %ax,%eax
c01011a9:	01 c0                	add    %eax,%eax
c01011ab:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01011b1:	66 89 02             	mov    %ax,(%edx)
        break;
c01011b4:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011b5:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011bc:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011c0:	76 5b                	jbe    c010121d <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011c2:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011c7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011cd:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011d2:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011d9:	00 
c01011da:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011de:	89 04 24             	mov    %eax,(%esp)
c01011e1:	e8 ce 4d 00 00       	call   c0105fb4 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011e6:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011ed:	eb 15                	jmp    c0101204 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c01011ef:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011f7:	01 d2                	add    %edx,%edx
c01011f9:	01 d0                	add    %edx,%eax
c01011fb:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101200:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101204:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010120b:	7e e2                	jle    c01011ef <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010120d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101214:	83 e8 50             	sub    $0x50,%eax
c0101217:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010121d:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101224:	0f b7 c0             	movzwl %ax,%eax
c0101227:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010122b:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010122f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101233:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101237:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101238:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010123f:	66 c1 e8 08          	shr    $0x8,%ax
c0101243:	0f b6 c0             	movzbl %al,%eax
c0101246:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010124d:	83 c2 01             	add    $0x1,%edx
c0101250:	0f b7 d2             	movzwl %dx,%edx
c0101253:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101257:	88 45 ed             	mov    %al,-0x13(%ebp)
c010125a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010125e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101262:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101263:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010126a:	0f b7 c0             	movzwl %ax,%eax
c010126d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101271:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101275:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101279:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010127d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010127e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101285:	0f b6 c0             	movzbl %al,%eax
c0101288:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010128f:	83 c2 01             	add    $0x1,%edx
c0101292:	0f b7 d2             	movzwl %dx,%edx
c0101295:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101299:	88 45 e5             	mov    %al,-0x1b(%ebp)
c010129c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012a0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012a4:	ee                   	out    %al,(%dx)
}
c01012a5:	83 c4 34             	add    $0x34,%esp
c01012a8:	5b                   	pop    %ebx
c01012a9:	5d                   	pop    %ebp
c01012aa:	c3                   	ret    

c01012ab <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012ab:	55                   	push   %ebp
c01012ac:	89 e5                	mov    %esp,%ebp
c01012ae:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012b8:	eb 09                	jmp    c01012c3 <serial_putc_sub+0x18>
        delay();
c01012ba:	e8 4f fb ff ff       	call   c0100e0e <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012c3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012c9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012cd:	89 c2                	mov    %eax,%edx
c01012cf:	ec                   	in     (%dx),%al
c01012d0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012d3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012d7:	0f b6 c0             	movzbl %al,%eax
c01012da:	83 e0 20             	and    $0x20,%eax
c01012dd:	85 c0                	test   %eax,%eax
c01012df:	75 09                	jne    c01012ea <serial_putc_sub+0x3f>
c01012e1:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012e8:	7e d0                	jle    c01012ba <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01012ed:	0f b6 c0             	movzbl %al,%eax
c01012f0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01012f6:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012f9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01012fd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101301:	ee                   	out    %al,(%dx)
}
c0101302:	c9                   	leave  
c0101303:	c3                   	ret    

c0101304 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101304:	55                   	push   %ebp
c0101305:	89 e5                	mov    %esp,%ebp
c0101307:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010130a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010130e:	74 0d                	je     c010131d <serial_putc+0x19>
        serial_putc_sub(c);
c0101310:	8b 45 08             	mov    0x8(%ebp),%eax
c0101313:	89 04 24             	mov    %eax,(%esp)
c0101316:	e8 90 ff ff ff       	call   c01012ab <serial_putc_sub>
c010131b:	eb 24                	jmp    c0101341 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010131d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101324:	e8 82 ff ff ff       	call   c01012ab <serial_putc_sub>
        serial_putc_sub(' ');
c0101329:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101330:	e8 76 ff ff ff       	call   c01012ab <serial_putc_sub>
        serial_putc_sub('\b');
c0101335:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010133c:	e8 6a ff ff ff       	call   c01012ab <serial_putc_sub>
    }
}
c0101341:	c9                   	leave  
c0101342:	c3                   	ret    

c0101343 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101343:	55                   	push   %ebp
c0101344:	89 e5                	mov    %esp,%ebp
c0101346:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101349:	eb 33                	jmp    c010137e <cons_intr+0x3b>
        if (c != 0) {
c010134b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010134f:	74 2d                	je     c010137e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101351:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101356:	8d 50 01             	lea    0x1(%eax),%edx
c0101359:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010135f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101362:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101368:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010136d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101372:	75 0a                	jne    c010137e <cons_intr+0x3b>
                cons.wpos = 0;
c0101374:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010137b:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010137e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101381:	ff d0                	call   *%eax
c0101383:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101386:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010138a:	75 bf                	jne    c010134b <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c010138c:	c9                   	leave  
c010138d:	c3                   	ret    

c010138e <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010138e:	55                   	push   %ebp
c010138f:	89 e5                	mov    %esp,%ebp
c0101391:	83 ec 10             	sub    $0x10,%esp
c0101394:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010139a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010139e:	89 c2                	mov    %eax,%edx
c01013a0:	ec                   	in     (%dx),%al
c01013a1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013a4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013a8:	0f b6 c0             	movzbl %al,%eax
c01013ab:	83 e0 01             	and    $0x1,%eax
c01013ae:	85 c0                	test   %eax,%eax
c01013b0:	75 07                	jne    c01013b9 <serial_proc_data+0x2b>
        return -1;
c01013b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013b7:	eb 2a                	jmp    c01013e3 <serial_proc_data+0x55>
c01013b9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013bf:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013c3:	89 c2                	mov    %eax,%edx
c01013c5:	ec                   	in     (%dx),%al
c01013c6:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013c9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013cd:	0f b6 c0             	movzbl %al,%eax
c01013d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013d3:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013d7:	75 07                	jne    c01013e0 <serial_proc_data+0x52>
        c = '\b';
c01013d9:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013e3:	c9                   	leave  
c01013e4:	c3                   	ret    

c01013e5 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013e5:	55                   	push   %ebp
c01013e6:	89 e5                	mov    %esp,%ebp
c01013e8:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013eb:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013f0:	85 c0                	test   %eax,%eax
c01013f2:	74 0c                	je     c0101400 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c01013f4:	c7 04 24 8e 13 10 c0 	movl   $0xc010138e,(%esp)
c01013fb:	e8 43 ff ff ff       	call   c0101343 <cons_intr>
    }
}
c0101400:	c9                   	leave  
c0101401:	c3                   	ret    

c0101402 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101402:	55                   	push   %ebp
c0101403:	89 e5                	mov    %esp,%ebp
c0101405:	83 ec 38             	sub    $0x38,%esp
c0101408:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010140e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101412:	89 c2                	mov    %eax,%edx
c0101414:	ec                   	in     (%dx),%al
c0101415:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101418:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010141c:	0f b6 c0             	movzbl %al,%eax
c010141f:	83 e0 01             	and    $0x1,%eax
c0101422:	85 c0                	test   %eax,%eax
c0101424:	75 0a                	jne    c0101430 <kbd_proc_data+0x2e>
        return -1;
c0101426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010142b:	e9 59 01 00 00       	jmp    c0101589 <kbd_proc_data+0x187>
c0101430:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101436:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010143a:	89 c2                	mov    %eax,%edx
c010143c:	ec                   	in     (%dx),%al
c010143d:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101440:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101444:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101447:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010144b:	75 17                	jne    c0101464 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010144d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101452:	83 c8 40             	or     $0x40,%eax
c0101455:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010145a:	b8 00 00 00 00       	mov    $0x0,%eax
c010145f:	e9 25 01 00 00       	jmp    c0101589 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101464:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101468:	84 c0                	test   %al,%al
c010146a:	79 47                	jns    c01014b3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010146c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101471:	83 e0 40             	and    $0x40,%eax
c0101474:	85 c0                	test   %eax,%eax
c0101476:	75 09                	jne    c0101481 <kbd_proc_data+0x7f>
c0101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147c:	83 e0 7f             	and    $0x7f,%eax
c010147f:	eb 04                	jmp    c0101485 <kbd_proc_data+0x83>
c0101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101485:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101488:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148c:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101493:	83 c8 40             	or     $0x40,%eax
c0101496:	0f b6 c0             	movzbl %al,%eax
c0101499:	f7 d0                	not    %eax
c010149b:	89 c2                	mov    %eax,%edx
c010149d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014a2:	21 d0                	and    %edx,%eax
c01014a4:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014a9:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ae:	e9 d6 00 00 00       	jmp    c0101589 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014b3:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b8:	83 e0 40             	and    $0x40,%eax
c01014bb:	85 c0                	test   %eax,%eax
c01014bd:	74 11                	je     c01014d0 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014bf:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014c3:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c8:	83 e0 bf             	and    $0xffffffbf,%eax
c01014cb:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014d0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d4:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014db:	0f b6 d0             	movzbl %al,%edx
c01014de:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e3:	09 d0                	or     %edx,%eax
c01014e5:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ee:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c01014f5:	0f b6 d0             	movzbl %al,%edx
c01014f8:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014fd:	31 d0                	xor    %edx,%eax
c01014ff:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101504:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101509:	83 e0 03             	and    $0x3,%eax
c010150c:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101513:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101517:	01 d0                	add    %edx,%eax
c0101519:	0f b6 00             	movzbl (%eax),%eax
c010151c:	0f b6 c0             	movzbl %al,%eax
c010151f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101522:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101527:	83 e0 08             	and    $0x8,%eax
c010152a:	85 c0                	test   %eax,%eax
c010152c:	74 22                	je     c0101550 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010152e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101532:	7e 0c                	jle    c0101540 <kbd_proc_data+0x13e>
c0101534:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101538:	7f 06                	jg     c0101540 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010153a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010153e:	eb 10                	jmp    c0101550 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101540:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101544:	7e 0a                	jle    c0101550 <kbd_proc_data+0x14e>
c0101546:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010154a:	7f 04                	jg     c0101550 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010154c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101550:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101555:	f7 d0                	not    %eax
c0101557:	83 e0 06             	and    $0x6,%eax
c010155a:	85 c0                	test   %eax,%eax
c010155c:	75 28                	jne    c0101586 <kbd_proc_data+0x184>
c010155e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101565:	75 1f                	jne    c0101586 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101567:	c7 04 24 31 64 10 c0 	movl   $0xc0106431,(%esp)
c010156e:	e8 c9 ed ff ff       	call   c010033c <cprintf>
c0101573:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101579:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010157d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101581:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101585:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101586:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101589:	c9                   	leave  
c010158a:	c3                   	ret    

c010158b <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010158b:	55                   	push   %ebp
c010158c:	89 e5                	mov    %esp,%ebp
c010158e:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101591:	c7 04 24 02 14 10 c0 	movl   $0xc0101402,(%esp)
c0101598:	e8 a6 fd ff ff       	call   c0101343 <cons_intr>
}
c010159d:	c9                   	leave  
c010159e:	c3                   	ret    

c010159f <kbd_init>:

static void
kbd_init(void) {
c010159f:	55                   	push   %ebp
c01015a0:	89 e5                	mov    %esp,%ebp
c01015a2:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015a5:	e8 e1 ff ff ff       	call   c010158b <kbd_intr>
    pic_enable(IRQ_KBD);
c01015aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015b1:	e8 3d 01 00 00       	call   c01016f3 <pic_enable>
}
c01015b6:	c9                   	leave  
c01015b7:	c3                   	ret    

c01015b8 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015b8:	55                   	push   %ebp
c01015b9:	89 e5                	mov    %esp,%ebp
c01015bb:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015be:	e8 93 f8 ff ff       	call   c0100e56 <cga_init>
    serial_init();
c01015c3:	e8 74 f9 ff ff       	call   c0100f3c <serial_init>
    kbd_init();
c01015c8:	e8 d2 ff ff ff       	call   c010159f <kbd_init>
    if (!serial_exists) {
c01015cd:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015d2:	85 c0                	test   %eax,%eax
c01015d4:	75 0c                	jne    c01015e2 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015d6:	c7 04 24 3d 64 10 c0 	movl   $0xc010643d,(%esp)
c01015dd:	e8 5a ed ff ff       	call   c010033c <cprintf>
    }
}
c01015e2:	c9                   	leave  
c01015e3:	c3                   	ret    

c01015e4 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015e4:	55                   	push   %ebp
c01015e5:	89 e5                	mov    %esp,%ebp
c01015e7:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015ea:	e8 e2 f7 ff ff       	call   c0100dd1 <__intr_save>
c01015ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01015f5:	89 04 24             	mov    %eax,(%esp)
c01015f8:	e8 9b fa ff ff       	call   c0101098 <lpt_putc>
        cga_putc(c);
c01015fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101600:	89 04 24             	mov    %eax,(%esp)
c0101603:	e8 cf fa ff ff       	call   c01010d7 <cga_putc>
        serial_putc(c);
c0101608:	8b 45 08             	mov    0x8(%ebp),%eax
c010160b:	89 04 24             	mov    %eax,(%esp)
c010160e:	e8 f1 fc ff ff       	call   c0101304 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101613:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101616:	89 04 24             	mov    %eax,(%esp)
c0101619:	e8 dd f7 ff ff       	call   c0100dfb <__intr_restore>
}
c010161e:	c9                   	leave  
c010161f:	c3                   	ret    

c0101620 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101620:	55                   	push   %ebp
c0101621:	89 e5                	mov    %esp,%ebp
c0101623:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101626:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010162d:	e8 9f f7 ff ff       	call   c0100dd1 <__intr_save>
c0101632:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101635:	e8 ab fd ff ff       	call   c01013e5 <serial_intr>
        kbd_intr();
c010163a:	e8 4c ff ff ff       	call   c010158b <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010163f:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101645:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010164a:	39 c2                	cmp    %eax,%edx
c010164c:	74 31                	je     c010167f <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010164e:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101653:	8d 50 01             	lea    0x1(%eax),%edx
c0101656:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c010165c:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101663:	0f b6 c0             	movzbl %al,%eax
c0101666:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101669:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010166e:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101673:	75 0a                	jne    c010167f <cons_getc+0x5f>
                cons.rpos = 0;
c0101675:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c010167c:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101682:	89 04 24             	mov    %eax,(%esp)
c0101685:	e8 71 f7 ff ff       	call   c0100dfb <__intr_restore>
    return c;
c010168a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010168d:	c9                   	leave  
c010168e:	c3                   	ret    

c010168f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010168f:	55                   	push   %ebp
c0101690:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101692:	fb                   	sti    
    sti();
}
c0101693:	5d                   	pop    %ebp
c0101694:	c3                   	ret    

c0101695 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101695:	55                   	push   %ebp
c0101696:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101698:	fa                   	cli    
    cli();
}
c0101699:	5d                   	pop    %ebp
c010169a:	c3                   	ret    

c010169b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010169b:	55                   	push   %ebp
c010169c:	89 e5                	mov    %esp,%ebp
c010169e:	83 ec 14             	sub    $0x14,%esp
c01016a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016a8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ac:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016b2:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016b7:	85 c0                	test   %eax,%eax
c01016b9:	74 36                	je     c01016f1 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016bb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016bf:	0f b6 c0             	movzbl %al,%eax
c01016c2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016c8:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016cb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016cf:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016d3:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016d4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d8:	66 c1 e8 08          	shr    $0x8,%ax
c01016dc:	0f b6 c0             	movzbl %al,%eax
c01016df:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016e5:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016e8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016ec:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016f0:	ee                   	out    %al,(%dx)
    }
}
c01016f1:	c9                   	leave  
c01016f2:	c3                   	ret    

c01016f3 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016f3:	55                   	push   %ebp
c01016f4:	89 e5                	mov    %esp,%ebp
c01016f6:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01016f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01016fc:	ba 01 00 00 00       	mov    $0x1,%edx
c0101701:	89 c1                	mov    %eax,%ecx
c0101703:	d3 e2                	shl    %cl,%edx
c0101705:	89 d0                	mov    %edx,%eax
c0101707:	f7 d0                	not    %eax
c0101709:	89 c2                	mov    %eax,%edx
c010170b:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101712:	21 d0                	and    %edx,%eax
c0101714:	0f b7 c0             	movzwl %ax,%eax
c0101717:	89 04 24             	mov    %eax,(%esp)
c010171a:	e8 7c ff ff ff       	call   c010169b <pic_setmask>
}
c010171f:	c9                   	leave  
c0101720:	c3                   	ret    

c0101721 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101721:	55                   	push   %ebp
c0101722:	89 e5                	mov    %esp,%ebp
c0101724:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101727:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c010172e:	00 00 00 
c0101731:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101737:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010173b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010173f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101743:	ee                   	out    %al,(%dx)
c0101744:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010174a:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010174e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101752:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101756:	ee                   	out    %al,(%dx)
c0101757:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010175d:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101761:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101765:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101769:	ee                   	out    %al,(%dx)
c010176a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101770:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101774:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101778:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010177c:	ee                   	out    %al,(%dx)
c010177d:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101783:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0101787:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010178b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010178f:	ee                   	out    %al,(%dx)
c0101790:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0101796:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010179a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010179e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017a2:	ee                   	out    %al,(%dx)
c01017a3:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017a9:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017ad:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017b1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017b5:	ee                   	out    %al,(%dx)
c01017b6:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017bc:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017c0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017c4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017c8:	ee                   	out    %al,(%dx)
c01017c9:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017cf:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017d3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017d7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017db:	ee                   	out    %al,(%dx)
c01017dc:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017e2:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017e6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017ea:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017ee:	ee                   	out    %al,(%dx)
c01017ef:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c01017f5:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01017f9:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01017fd:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101801:	ee                   	out    %al,(%dx)
c0101802:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101808:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010180c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101810:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101814:	ee                   	out    %al,(%dx)
c0101815:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010181b:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010181f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101823:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101827:	ee                   	out    %al,(%dx)
c0101828:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010182e:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101832:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101836:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010183a:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010183b:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101842:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101846:	74 12                	je     c010185a <pic_init+0x139>
        pic_setmask(irq_mask);
c0101848:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010184f:	0f b7 c0             	movzwl %ax,%eax
c0101852:	89 04 24             	mov    %eax,(%esp)
c0101855:	e8 41 fe ff ff       	call   c010169b <pic_setmask>
    }
}
c010185a:	c9                   	leave  
c010185b:	c3                   	ret    

c010185c <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
c010185c:	55                   	push   %ebp
c010185d:	89 e5                	mov    %esp,%ebp
c010185f:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101862:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101869:	00 
c010186a:	c7 04 24 60 64 10 c0 	movl   $0xc0106460,(%esp)
c0101871:	e8 c6 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101876:	c7 04 24 6a 64 10 c0 	movl   $0xc010646a,(%esp)
c010187d:	e8 ba ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c0101882:	c7 44 24 08 78 64 10 	movl   $0xc0106478,0x8(%esp)
c0101889:	c0 
c010188a:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c0101891:	00 
c0101892:	c7 04 24 8e 64 10 c0 	movl   $0xc010648e,(%esp)
c0101899:	e8 14 f4 ff ff       	call   c0100cb2 <__panic>

c010189e <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010189e:	55                   	push   %ebp
c010189f:	89 e5                	mov    %esp,%ebp
c01018a1:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i ++) {
c01018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018ab:	e9 c3 00 00 00       	jmp    c0101973 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b3:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018ba:	89 c2                	mov    %eax,%edx
c01018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018bf:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018c6:	c0 
c01018c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ca:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018d1:	c0 08 00 
c01018d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d7:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018de:	c0 
c01018df:	83 e2 e0             	and    $0xffffffe0,%edx
c01018e2:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ec:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018f3:	c0 
c01018f4:	83 e2 1f             	and    $0x1f,%edx
c01018f7:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101901:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101908:	c0 
c0101909:	83 e2 f0             	and    $0xfffffff0,%edx
c010190c:	83 ca 0e             	or     $0xe,%edx
c010190f:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101919:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101920:	c0 
c0101921:	83 e2 ef             	and    $0xffffffef,%edx
c0101924:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101935:	c0 
c0101936:	83 e2 9f             	and    $0xffffff9f,%edx
c0101939:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101940:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101943:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010194a:	c0 
c010194b:	83 ca 80             	or     $0xffffff80,%edx
c010194e:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101955:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101958:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010195f:	c1 e8 10             	shr    $0x10,%eax
c0101962:	89 c2                	mov    %eax,%edx
c0101964:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101967:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010196e:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i ++) {
c010196f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101973:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010197a:	0f 8e 30 ff ff ff    	jle    c01018b0 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101980:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101985:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c010198b:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c0101992:	08 00 
c0101994:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c010199b:	83 e0 e0             	and    $0xffffffe0,%eax
c010199e:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019a3:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019aa:	83 e0 1f             	and    $0x1f,%eax
c01019ad:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019b2:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019b9:	83 e0 f0             	and    $0xfffffff0,%eax
c01019bc:	83 c8 0e             	or     $0xe,%eax
c01019bf:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019c4:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019cb:	83 e0 ef             	and    $0xffffffef,%eax
c01019ce:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019d3:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019da:	83 c8 60             	or     $0x60,%eax
c01019dd:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019e2:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019e9:	83 c8 80             	or     $0xffffff80,%eax
c01019ec:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019f1:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019f6:	c1 e8 10             	shr    $0x10,%eax
c01019f9:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019ff:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a06:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a09:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
c0101a0c:	c9                   	leave  
c0101a0d:	c3                   	ret    

c0101a0e <trapname>:

static const char *
trapname(int trapno) {
c0101a0e:	55                   	push   %ebp
c0101a0f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a14:	83 f8 13             	cmp    $0x13,%eax
c0101a17:	77 0c                	ja     c0101a25 <trapname+0x17>
        return excnames[trapno];
c0101a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1c:	8b 04 85 e0 67 10 c0 	mov    -0x3fef9820(,%eax,4),%eax
c0101a23:	eb 18                	jmp    c0101a3d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a25:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a29:	7e 0d                	jle    c0101a38 <trapname+0x2a>
c0101a2b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a2f:	7f 07                	jg     c0101a38 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a31:	b8 9f 64 10 c0       	mov    $0xc010649f,%eax
c0101a36:	eb 05                	jmp    c0101a3d <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a38:	b8 b2 64 10 c0       	mov    $0xc01064b2,%eax
}
c0101a3d:	5d                   	pop    %ebp
c0101a3e:	c3                   	ret    

c0101a3f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a3f:	55                   	push   %ebp
c0101a40:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a45:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a49:	66 83 f8 08          	cmp    $0x8,%ax
c0101a4d:	0f 94 c0             	sete   %al
c0101a50:	0f b6 c0             	movzbl %al,%eax
}
c0101a53:	5d                   	pop    %ebp
c0101a54:	c3                   	ret    

c0101a55 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a55:	55                   	push   %ebp
c0101a56:	89 e5                	mov    %esp,%ebp
c0101a58:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a62:	c7 04 24 f3 64 10 c0 	movl   $0xc01064f3,(%esp)
c0101a69:	e8 ce e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a71:	89 04 24             	mov    %eax,(%esp)
c0101a74:	e8 a1 01 00 00       	call   c0101c1a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a80:	0f b7 c0             	movzwl %ax,%eax
c0101a83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a87:	c7 04 24 04 65 10 c0 	movl   $0xc0106504,(%esp)
c0101a8e:	e8 a9 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a96:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a9a:	0f b7 c0             	movzwl %ax,%eax
c0101a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa1:	c7 04 24 17 65 10 c0 	movl   $0xc0106517,(%esp)
c0101aa8:	e8 8f e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab0:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ab4:	0f b7 c0             	movzwl %ax,%eax
c0101ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101abb:	c7 04 24 2a 65 10 c0 	movl   $0xc010652a,(%esp)
c0101ac2:	e8 75 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aca:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ace:	0f b7 c0             	movzwl %ax,%eax
c0101ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad5:	c7 04 24 3d 65 10 c0 	movl   $0xc010653d,(%esp)
c0101adc:	e8 5b e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae4:	8b 40 30             	mov    0x30(%eax),%eax
c0101ae7:	89 04 24             	mov    %eax,(%esp)
c0101aea:	e8 1f ff ff ff       	call   c0101a0e <trapname>
c0101aef:	8b 55 08             	mov    0x8(%ebp),%edx
c0101af2:	8b 52 30             	mov    0x30(%edx),%edx
c0101af5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101af9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101afd:	c7 04 24 50 65 10 c0 	movl   $0xc0106550,(%esp)
c0101b04:	e8 33 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0c:	8b 40 34             	mov    0x34(%eax),%eax
c0101b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b13:	c7 04 24 62 65 10 c0 	movl   $0xc0106562,(%esp)
c0101b1a:	e8 1d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b22:	8b 40 38             	mov    0x38(%eax),%eax
c0101b25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b29:	c7 04 24 71 65 10 c0 	movl   $0xc0106571,(%esp)
c0101b30:	e8 07 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b38:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b3c:	0f b7 c0             	movzwl %ax,%eax
c0101b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b43:	c7 04 24 80 65 10 c0 	movl   $0xc0106580,(%esp)
c0101b4a:	e8 ed e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b52:	8b 40 40             	mov    0x40(%eax),%eax
c0101b55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b59:	c7 04 24 93 65 10 c0 	movl   $0xc0106593,(%esp)
c0101b60:	e8 d7 e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b6c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b73:	eb 3e                	jmp    c0101bb3 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b78:	8b 50 40             	mov    0x40(%eax),%edx
c0101b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b7e:	21 d0                	and    %edx,%eax
c0101b80:	85 c0                	test   %eax,%eax
c0101b82:	74 28                	je     c0101bac <print_trapframe+0x157>
c0101b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b87:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b8e:	85 c0                	test   %eax,%eax
c0101b90:	74 1a                	je     c0101bac <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b95:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba0:	c7 04 24 a2 65 10 c0 	movl   $0xc01065a2,(%esp)
c0101ba7:	e8 90 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bb0:	d1 65 f0             	shll   -0x10(%ebp)
c0101bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb6:	83 f8 17             	cmp    $0x17,%eax
c0101bb9:	76 ba                	jbe    c0101b75 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbe:	8b 40 40             	mov    0x40(%eax),%eax
c0101bc1:	25 00 30 00 00       	and    $0x3000,%eax
c0101bc6:	c1 e8 0c             	shr    $0xc,%eax
c0101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bcd:	c7 04 24 a6 65 10 c0 	movl   $0xc01065a6,(%esp)
c0101bd4:	e8 63 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdc:	89 04 24             	mov    %eax,(%esp)
c0101bdf:	e8 5b fe ff ff       	call   c0101a3f <trap_in_kernel>
c0101be4:	85 c0                	test   %eax,%eax
c0101be6:	75 30                	jne    c0101c18 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101beb:	8b 40 44             	mov    0x44(%eax),%eax
c0101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf2:	c7 04 24 af 65 10 c0 	movl   $0xc01065af,(%esp)
c0101bf9:	e8 3e e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c01:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c05:	0f b7 c0             	movzwl %ax,%eax
c0101c08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0c:	c7 04 24 be 65 10 c0 	movl   $0xc01065be,(%esp)
c0101c13:	e8 24 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101c18:	c9                   	leave  
c0101c19:	c3                   	ret    

c0101c1a <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c1a:	55                   	push   %ebp
c0101c1b:	89 e5                	mov    %esp,%ebp
c0101c1d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c23:	8b 00                	mov    (%eax),%eax
c0101c25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c29:	c7 04 24 d1 65 10 c0 	movl   $0xc01065d1,(%esp)
c0101c30:	e8 07 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c38:	8b 40 04             	mov    0x4(%eax),%eax
c0101c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3f:	c7 04 24 e0 65 10 c0 	movl   $0xc01065e0,(%esp)
c0101c46:	e8 f1 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4e:	8b 40 08             	mov    0x8(%eax),%eax
c0101c51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c55:	c7 04 24 ef 65 10 c0 	movl   $0xc01065ef,(%esp)
c0101c5c:	e8 db e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c64:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6b:	c7 04 24 fe 65 10 c0 	movl   $0xc01065fe,(%esp)
c0101c72:	e8 c5 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7a:	8b 40 10             	mov    0x10(%eax),%eax
c0101c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c81:	c7 04 24 0d 66 10 c0 	movl   $0xc010660d,(%esp)
c0101c88:	e8 af e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c90:	8b 40 14             	mov    0x14(%eax),%eax
c0101c93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c97:	c7 04 24 1c 66 10 c0 	movl   $0xc010661c,(%esp)
c0101c9e:	e8 99 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ca3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca6:	8b 40 18             	mov    0x18(%eax),%eax
c0101ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cad:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0101cb4:	e8 83 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbc:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc3:	c7 04 24 3a 66 10 c0 	movl   $0xc010663a,(%esp)
c0101cca:	e8 6d e6 ff ff       	call   c010033c <cprintf>
}
c0101ccf:	c9                   	leave  
c0101cd0:	c3                   	ret    

c0101cd1 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cd1:	55                   	push   %ebp
c0101cd2:	89 e5                	mov    %esp,%ebp
c0101cd4:	57                   	push   %edi
c0101cd5:	56                   	push   %esi
c0101cd6:	53                   	push   %ebx
c0101cd7:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdd:	8b 40 30             	mov    0x30(%eax),%eax
c0101ce0:	83 f8 2f             	cmp    $0x2f,%eax
c0101ce3:	77 21                	ja     c0101d06 <trap_dispatch+0x35>
c0101ce5:	83 f8 2e             	cmp    $0x2e,%eax
c0101ce8:	0f 83 e4 01 00 00    	jae    c0101ed2 <trap_dispatch+0x201>
c0101cee:	83 f8 21             	cmp    $0x21,%eax
c0101cf1:	0f 84 82 00 00 00    	je     c0101d79 <trap_dispatch+0xa8>
c0101cf7:	83 f8 24             	cmp    $0x24,%eax
c0101cfa:	74 54                	je     c0101d50 <trap_dispatch+0x7f>
c0101cfc:	83 f8 20             	cmp    $0x20,%eax
c0101cff:	74 1c                	je     c0101d1d <trap_dispatch+0x4c>
c0101d01:	e9 94 01 00 00       	jmp    c0101e9a <trap_dispatch+0x1c9>
c0101d06:	83 f8 78             	cmp    $0x78,%eax
c0101d09:	0f 84 93 00 00 00    	je     c0101da2 <trap_dispatch+0xd1>
c0101d0f:	83 f8 79             	cmp    $0x79,%eax
c0101d12:	0f 84 09 01 00 00    	je     c0101e21 <trap_dispatch+0x150>
c0101d18:	e9 7d 01 00 00       	jmp    c0101e9a <trap_dispatch+0x1c9>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d1d:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d22:	83 c0 01             	add    $0x1,%eax
c0101d25:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks==TICK_NUM ) {
c0101d2a:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d2f:	83 f8 64             	cmp    $0x64,%eax
c0101d32:	75 17                	jne    c0101d4b <trap_dispatch+0x7a>
            ticks-=TICK_NUM;
c0101d34:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d39:	83 e8 64             	sub    $0x64,%eax
c0101d3c:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
            print_ticks();
c0101d41:	e8 16 fb ff ff       	call   c010185c <print_ticks>
        }
        break;
c0101d46:	e9 88 01 00 00       	jmp    c0101ed3 <trap_dispatch+0x202>
c0101d4b:	e9 83 01 00 00       	jmp    c0101ed3 <trap_dispatch+0x202>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d50:	e8 cb f8 ff ff       	call   c0101620 <cons_getc>
c0101d55:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d58:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101d5c:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101d60:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d68:	c7 04 24 49 66 10 c0 	movl   $0xc0106649,(%esp)
c0101d6f:	e8 c8 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d74:	e9 5a 01 00 00       	jmp    c0101ed3 <trap_dispatch+0x202>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d79:	e8 a2 f8 ff ff       	call   c0101620 <cons_getc>
c0101d7e:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d81:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101d85:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101d89:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d91:	c7 04 24 5b 66 10 c0 	movl   $0xc010665b,(%esp)
c0101d98:	e8 9f e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d9d:	e9 31 01 00 00       	jmp    c0101ed3 <trap_dispatch+0x202>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
c0101da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101da9:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101dad:	74 6d                	je     c0101e1c <trap_dispatch+0x14b>
            switchk2u = *tf;
c0101daf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db2:	ba 60 89 11 c0       	mov    $0xc0118960,%edx
c0101db7:	89 c3                	mov    %eax,%ebx
c0101db9:	b8 13 00 00 00       	mov    $0x13,%eax
c0101dbe:	89 d7                	mov    %edx,%edi
c0101dc0:	89 de                	mov    %ebx,%esi
c0101dc2:	89 c1                	mov    %eax,%ecx
c0101dc4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
c0101dc6:	66 c7 05 9c 89 11 c0 	movw   $0x1b,0xc011899c
c0101dcd:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0101dcf:	66 c7 05 a8 89 11 c0 	movw   $0x23,0xc01189a8
c0101dd6:	23 00 
c0101dd8:	0f b7 05 a8 89 11 c0 	movzwl 0xc01189a8,%eax
c0101ddf:	66 a3 88 89 11 c0    	mov    %ax,0xc0118988
c0101de5:	0f b7 05 88 89 11 c0 	movzwl 0xc0118988,%eax
c0101dec:	66 a3 8c 89 11 c0    	mov    %ax,0xc011898c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0101df2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df5:	83 c0 44             	add    $0x44,%eax
c0101df8:	a3 a4 89 11 c0       	mov    %eax,0xc01189a4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101dfd:	a1 a0 89 11 c0       	mov    0xc01189a0,%eax
c0101e02:	80 cc 30             	or     $0x30,%ah
c0101e05:	a3 a0 89 11 c0       	mov    %eax,0xc01189a0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e0d:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101e10:	b8 60 89 11 c0       	mov    $0xc0118960,%eax
c0101e15:	89 02                	mov    %eax,(%edx)
        }
        break;
c0101e17:	e9 b7 00 00 00       	jmp    c0101ed3 <trap_dispatch+0x202>
c0101e1c:	e9 b2 00 00 00       	jmp    c0101ed3 <trap_dispatch+0x202>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c0101e21:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e24:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e28:	66 83 f8 08          	cmp    $0x8,%ax
c0101e2c:	74 6a                	je     c0101e98 <trap_dispatch+0x1c7>
            tf->tf_cs = KERNEL_CS;
c0101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e31:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101e37:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e3a:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e43:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e51:	8b 40 40             	mov    0x40(%eax),%eax
c0101e54:	80 e4 cf             	and    $0xcf,%ah
c0101e57:	89 c2                	mov    %eax,%edx
c0101e59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5c:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e62:	8b 40 44             	mov    0x44(%eax),%eax
c0101e65:	83 e8 44             	sub    $0x44,%eax
c0101e68:	a3 ac 89 11 c0       	mov    %eax,0xc01189ac
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101e6d:	a1 ac 89 11 c0       	mov    0xc01189ac,%eax
c0101e72:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101e79:	00 
c0101e7a:	8b 55 08             	mov    0x8(%ebp),%edx
c0101e7d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101e81:	89 04 24             	mov    %eax,(%esp)
c0101e84:	e8 2b 41 00 00       	call   c0105fb4 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0101e89:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8c:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101e8f:	a1 ac 89 11 c0       	mov    0xc01189ac,%eax
c0101e94:	89 02                	mov    %eax,(%edx)
        }
        break;
c0101e96:	eb 3b                	jmp    c0101ed3 <trap_dispatch+0x202>
c0101e98:	eb 39                	jmp    c0101ed3 <trap_dispatch+0x202>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ea1:	0f b7 c0             	movzwl %ax,%eax
c0101ea4:	83 e0 03             	and    $0x3,%eax
c0101ea7:	85 c0                	test   %eax,%eax
c0101ea9:	75 28                	jne    c0101ed3 <trap_dispatch+0x202>
            print_trapframe(tf);
c0101eab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eae:	89 04 24             	mov    %eax,(%esp)
c0101eb1:	e8 9f fb ff ff       	call   c0101a55 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101eb6:	c7 44 24 08 6a 66 10 	movl   $0xc010666a,0x8(%esp)
c0101ebd:	c0 
c0101ebe:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0101ec5:	00 
c0101ec6:	c7 04 24 8e 64 10 c0 	movl   $0xc010648e,(%esp)
c0101ecd:	e8 e0 ed ff ff       	call   c0100cb2 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101ed2:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101ed3:	83 c4 2c             	add    $0x2c,%esp
c0101ed6:	5b                   	pop    %ebx
c0101ed7:	5e                   	pop    %esi
c0101ed8:	5f                   	pop    %edi
c0101ed9:	5d                   	pop    %ebp
c0101eda:	c3                   	ret    

c0101edb <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101edb:	55                   	push   %ebp
c0101edc:	89 e5                	mov    %esp,%ebp
c0101ede:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee4:	89 04 24             	mov    %eax,(%esp)
c0101ee7:	e8 e5 fd ff ff       	call   c0101cd1 <trap_dispatch>
}
c0101eec:	c9                   	leave  
c0101eed:	c3                   	ret    

c0101eee <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101eee:	1e                   	push   %ds
    pushl %es
c0101eef:	06                   	push   %es
    pushl %fs
c0101ef0:	0f a0                	push   %fs
    pushl %gs
c0101ef2:	0f a8                	push   %gs
    pushal
c0101ef4:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101ef5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101efa:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101efc:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101efe:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101eff:	e8 d7 ff ff ff       	call   c0101edb <trap>

    # pop the pushed stack pointer
    popl %esp
c0101f04:	5c                   	pop    %esp

c0101f05 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101f05:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101f06:	0f a9                	pop    %gs
    popl %fs
c0101f08:	0f a1                	pop    %fs
    popl %es
c0101f0a:	07                   	pop    %es
    popl %ds
c0101f0b:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101f0c:	83 c4 08             	add    $0x8,%esp
    iret
c0101f0f:	cf                   	iret   

c0101f10 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f10:	6a 00                	push   $0x0
  pushl $0
c0101f12:	6a 00                	push   $0x0
  jmp __alltraps
c0101f14:	e9 d5 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f19 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f19:	6a 00                	push   $0x0
  pushl $1
c0101f1b:	6a 01                	push   $0x1
  jmp __alltraps
c0101f1d:	e9 cc ff ff ff       	jmp    c0101eee <__alltraps>

c0101f22 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f22:	6a 00                	push   $0x0
  pushl $2
c0101f24:	6a 02                	push   $0x2
  jmp __alltraps
c0101f26:	e9 c3 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f2b <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f2b:	6a 00                	push   $0x0
  pushl $3
c0101f2d:	6a 03                	push   $0x3
  jmp __alltraps
c0101f2f:	e9 ba ff ff ff       	jmp    c0101eee <__alltraps>

c0101f34 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f34:	6a 00                	push   $0x0
  pushl $4
c0101f36:	6a 04                	push   $0x4
  jmp __alltraps
c0101f38:	e9 b1 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f3d <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f3d:	6a 00                	push   $0x0
  pushl $5
c0101f3f:	6a 05                	push   $0x5
  jmp __alltraps
c0101f41:	e9 a8 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f46 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f46:	6a 00                	push   $0x0
  pushl $6
c0101f48:	6a 06                	push   $0x6
  jmp __alltraps
c0101f4a:	e9 9f ff ff ff       	jmp    c0101eee <__alltraps>

c0101f4f <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f4f:	6a 00                	push   $0x0
  pushl $7
c0101f51:	6a 07                	push   $0x7
  jmp __alltraps
c0101f53:	e9 96 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f58 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f58:	6a 08                	push   $0x8
  jmp __alltraps
c0101f5a:	e9 8f ff ff ff       	jmp    c0101eee <__alltraps>

c0101f5f <vector9>:
.globl vector9
vector9:
  pushl $9
c0101f5f:	6a 09                	push   $0x9
  jmp __alltraps
c0101f61:	e9 88 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f66 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f66:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f68:	e9 81 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f6d <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f6d:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f6f:	e9 7a ff ff ff       	jmp    c0101eee <__alltraps>

c0101f74 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f74:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f76:	e9 73 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f7b <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f7b:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f7d:	e9 6c ff ff ff       	jmp    c0101eee <__alltraps>

c0101f82 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f82:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f84:	e9 65 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f89 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f89:	6a 00                	push   $0x0
  pushl $15
c0101f8b:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f8d:	e9 5c ff ff ff       	jmp    c0101eee <__alltraps>

c0101f92 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f92:	6a 00                	push   $0x0
  pushl $16
c0101f94:	6a 10                	push   $0x10
  jmp __alltraps
c0101f96:	e9 53 ff ff ff       	jmp    c0101eee <__alltraps>

c0101f9b <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f9b:	6a 11                	push   $0x11
  jmp __alltraps
c0101f9d:	e9 4c ff ff ff       	jmp    c0101eee <__alltraps>

c0101fa2 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101fa2:	6a 00                	push   $0x0
  pushl $18
c0101fa4:	6a 12                	push   $0x12
  jmp __alltraps
c0101fa6:	e9 43 ff ff ff       	jmp    c0101eee <__alltraps>

c0101fab <vector19>:
.globl vector19
vector19:
  pushl $0
c0101fab:	6a 00                	push   $0x0
  pushl $19
c0101fad:	6a 13                	push   $0x13
  jmp __alltraps
c0101faf:	e9 3a ff ff ff       	jmp    c0101eee <__alltraps>

c0101fb4 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101fb4:	6a 00                	push   $0x0
  pushl $20
c0101fb6:	6a 14                	push   $0x14
  jmp __alltraps
c0101fb8:	e9 31 ff ff ff       	jmp    c0101eee <__alltraps>

c0101fbd <vector21>:
.globl vector21
vector21:
  pushl $0
c0101fbd:	6a 00                	push   $0x0
  pushl $21
c0101fbf:	6a 15                	push   $0x15
  jmp __alltraps
c0101fc1:	e9 28 ff ff ff       	jmp    c0101eee <__alltraps>

c0101fc6 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $22
c0101fc8:	6a 16                	push   $0x16
  jmp __alltraps
c0101fca:	e9 1f ff ff ff       	jmp    c0101eee <__alltraps>

c0101fcf <vector23>:
.globl vector23
vector23:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $23
c0101fd1:	6a 17                	push   $0x17
  jmp __alltraps
c0101fd3:	e9 16 ff ff ff       	jmp    c0101eee <__alltraps>

c0101fd8 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $24
c0101fda:	6a 18                	push   $0x18
  jmp __alltraps
c0101fdc:	e9 0d ff ff ff       	jmp    c0101eee <__alltraps>

c0101fe1 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $25
c0101fe3:	6a 19                	push   $0x19
  jmp __alltraps
c0101fe5:	e9 04 ff ff ff       	jmp    c0101eee <__alltraps>

c0101fea <vector26>:
.globl vector26
vector26:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $26
c0101fec:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101fee:	e9 fb fe ff ff       	jmp    c0101eee <__alltraps>

c0101ff3 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $27
c0101ff5:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ff7:	e9 f2 fe ff ff       	jmp    c0101eee <__alltraps>

c0101ffc <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $28
c0101ffe:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102000:	e9 e9 fe ff ff       	jmp    c0101eee <__alltraps>

c0102005 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $29
c0102007:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102009:	e9 e0 fe ff ff       	jmp    c0101eee <__alltraps>

c010200e <vector30>:
.globl vector30
vector30:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $30
c0102010:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102012:	e9 d7 fe ff ff       	jmp    c0101eee <__alltraps>

c0102017 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $31
c0102019:	6a 1f                	push   $0x1f
  jmp __alltraps
c010201b:	e9 ce fe ff ff       	jmp    c0101eee <__alltraps>

c0102020 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $32
c0102022:	6a 20                	push   $0x20
  jmp __alltraps
c0102024:	e9 c5 fe ff ff       	jmp    c0101eee <__alltraps>

c0102029 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $33
c010202b:	6a 21                	push   $0x21
  jmp __alltraps
c010202d:	e9 bc fe ff ff       	jmp    c0101eee <__alltraps>

c0102032 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $34
c0102034:	6a 22                	push   $0x22
  jmp __alltraps
c0102036:	e9 b3 fe ff ff       	jmp    c0101eee <__alltraps>

c010203b <vector35>:
.globl vector35
vector35:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $35
c010203d:	6a 23                	push   $0x23
  jmp __alltraps
c010203f:	e9 aa fe ff ff       	jmp    c0101eee <__alltraps>

c0102044 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $36
c0102046:	6a 24                	push   $0x24
  jmp __alltraps
c0102048:	e9 a1 fe ff ff       	jmp    c0101eee <__alltraps>

c010204d <vector37>:
.globl vector37
vector37:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $37
c010204f:	6a 25                	push   $0x25
  jmp __alltraps
c0102051:	e9 98 fe ff ff       	jmp    c0101eee <__alltraps>

c0102056 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $38
c0102058:	6a 26                	push   $0x26
  jmp __alltraps
c010205a:	e9 8f fe ff ff       	jmp    c0101eee <__alltraps>

c010205f <vector39>:
.globl vector39
vector39:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $39
c0102061:	6a 27                	push   $0x27
  jmp __alltraps
c0102063:	e9 86 fe ff ff       	jmp    c0101eee <__alltraps>

c0102068 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $40
c010206a:	6a 28                	push   $0x28
  jmp __alltraps
c010206c:	e9 7d fe ff ff       	jmp    c0101eee <__alltraps>

c0102071 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $41
c0102073:	6a 29                	push   $0x29
  jmp __alltraps
c0102075:	e9 74 fe ff ff       	jmp    c0101eee <__alltraps>

c010207a <vector42>:
.globl vector42
vector42:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $42
c010207c:	6a 2a                	push   $0x2a
  jmp __alltraps
c010207e:	e9 6b fe ff ff       	jmp    c0101eee <__alltraps>

c0102083 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $43
c0102085:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102087:	e9 62 fe ff ff       	jmp    c0101eee <__alltraps>

c010208c <vector44>:
.globl vector44
vector44:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $44
c010208e:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102090:	e9 59 fe ff ff       	jmp    c0101eee <__alltraps>

c0102095 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $45
c0102097:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102099:	e9 50 fe ff ff       	jmp    c0101eee <__alltraps>

c010209e <vector46>:
.globl vector46
vector46:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $46
c01020a0:	6a 2e                	push   $0x2e
  jmp __alltraps
c01020a2:	e9 47 fe ff ff       	jmp    c0101eee <__alltraps>

c01020a7 <vector47>:
.globl vector47
vector47:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $47
c01020a9:	6a 2f                	push   $0x2f
  jmp __alltraps
c01020ab:	e9 3e fe ff ff       	jmp    c0101eee <__alltraps>

c01020b0 <vector48>:
.globl vector48
vector48:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $48
c01020b2:	6a 30                	push   $0x30
  jmp __alltraps
c01020b4:	e9 35 fe ff ff       	jmp    c0101eee <__alltraps>

c01020b9 <vector49>:
.globl vector49
vector49:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $49
c01020bb:	6a 31                	push   $0x31
  jmp __alltraps
c01020bd:	e9 2c fe ff ff       	jmp    c0101eee <__alltraps>

c01020c2 <vector50>:
.globl vector50
vector50:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $50
c01020c4:	6a 32                	push   $0x32
  jmp __alltraps
c01020c6:	e9 23 fe ff ff       	jmp    c0101eee <__alltraps>

c01020cb <vector51>:
.globl vector51
vector51:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $51
c01020cd:	6a 33                	push   $0x33
  jmp __alltraps
c01020cf:	e9 1a fe ff ff       	jmp    c0101eee <__alltraps>

c01020d4 <vector52>:
.globl vector52
vector52:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $52
c01020d6:	6a 34                	push   $0x34
  jmp __alltraps
c01020d8:	e9 11 fe ff ff       	jmp    c0101eee <__alltraps>

c01020dd <vector53>:
.globl vector53
vector53:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $53
c01020df:	6a 35                	push   $0x35
  jmp __alltraps
c01020e1:	e9 08 fe ff ff       	jmp    c0101eee <__alltraps>

c01020e6 <vector54>:
.globl vector54
vector54:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $54
c01020e8:	6a 36                	push   $0x36
  jmp __alltraps
c01020ea:	e9 ff fd ff ff       	jmp    c0101eee <__alltraps>

c01020ef <vector55>:
.globl vector55
vector55:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $55
c01020f1:	6a 37                	push   $0x37
  jmp __alltraps
c01020f3:	e9 f6 fd ff ff       	jmp    c0101eee <__alltraps>

c01020f8 <vector56>:
.globl vector56
vector56:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $56
c01020fa:	6a 38                	push   $0x38
  jmp __alltraps
c01020fc:	e9 ed fd ff ff       	jmp    c0101eee <__alltraps>

c0102101 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $57
c0102103:	6a 39                	push   $0x39
  jmp __alltraps
c0102105:	e9 e4 fd ff ff       	jmp    c0101eee <__alltraps>

c010210a <vector58>:
.globl vector58
vector58:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $58
c010210c:	6a 3a                	push   $0x3a
  jmp __alltraps
c010210e:	e9 db fd ff ff       	jmp    c0101eee <__alltraps>

c0102113 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $59
c0102115:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102117:	e9 d2 fd ff ff       	jmp    c0101eee <__alltraps>

c010211c <vector60>:
.globl vector60
vector60:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $60
c010211e:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102120:	e9 c9 fd ff ff       	jmp    c0101eee <__alltraps>

c0102125 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $61
c0102127:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102129:	e9 c0 fd ff ff       	jmp    c0101eee <__alltraps>

c010212e <vector62>:
.globl vector62
vector62:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $62
c0102130:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102132:	e9 b7 fd ff ff       	jmp    c0101eee <__alltraps>

c0102137 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $63
c0102139:	6a 3f                	push   $0x3f
  jmp __alltraps
c010213b:	e9 ae fd ff ff       	jmp    c0101eee <__alltraps>

c0102140 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $64
c0102142:	6a 40                	push   $0x40
  jmp __alltraps
c0102144:	e9 a5 fd ff ff       	jmp    c0101eee <__alltraps>

c0102149 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $65
c010214b:	6a 41                	push   $0x41
  jmp __alltraps
c010214d:	e9 9c fd ff ff       	jmp    c0101eee <__alltraps>

c0102152 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $66
c0102154:	6a 42                	push   $0x42
  jmp __alltraps
c0102156:	e9 93 fd ff ff       	jmp    c0101eee <__alltraps>

c010215b <vector67>:
.globl vector67
vector67:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $67
c010215d:	6a 43                	push   $0x43
  jmp __alltraps
c010215f:	e9 8a fd ff ff       	jmp    c0101eee <__alltraps>

c0102164 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $68
c0102166:	6a 44                	push   $0x44
  jmp __alltraps
c0102168:	e9 81 fd ff ff       	jmp    c0101eee <__alltraps>

c010216d <vector69>:
.globl vector69
vector69:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $69
c010216f:	6a 45                	push   $0x45
  jmp __alltraps
c0102171:	e9 78 fd ff ff       	jmp    c0101eee <__alltraps>

c0102176 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $70
c0102178:	6a 46                	push   $0x46
  jmp __alltraps
c010217a:	e9 6f fd ff ff       	jmp    c0101eee <__alltraps>

c010217f <vector71>:
.globl vector71
vector71:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $71
c0102181:	6a 47                	push   $0x47
  jmp __alltraps
c0102183:	e9 66 fd ff ff       	jmp    c0101eee <__alltraps>

c0102188 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $72
c010218a:	6a 48                	push   $0x48
  jmp __alltraps
c010218c:	e9 5d fd ff ff       	jmp    c0101eee <__alltraps>

c0102191 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $73
c0102193:	6a 49                	push   $0x49
  jmp __alltraps
c0102195:	e9 54 fd ff ff       	jmp    c0101eee <__alltraps>

c010219a <vector74>:
.globl vector74
vector74:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $74
c010219c:	6a 4a                	push   $0x4a
  jmp __alltraps
c010219e:	e9 4b fd ff ff       	jmp    c0101eee <__alltraps>

c01021a3 <vector75>:
.globl vector75
vector75:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $75
c01021a5:	6a 4b                	push   $0x4b
  jmp __alltraps
c01021a7:	e9 42 fd ff ff       	jmp    c0101eee <__alltraps>

c01021ac <vector76>:
.globl vector76
vector76:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $76
c01021ae:	6a 4c                	push   $0x4c
  jmp __alltraps
c01021b0:	e9 39 fd ff ff       	jmp    c0101eee <__alltraps>

c01021b5 <vector77>:
.globl vector77
vector77:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $77
c01021b7:	6a 4d                	push   $0x4d
  jmp __alltraps
c01021b9:	e9 30 fd ff ff       	jmp    c0101eee <__alltraps>

c01021be <vector78>:
.globl vector78
vector78:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $78
c01021c0:	6a 4e                	push   $0x4e
  jmp __alltraps
c01021c2:	e9 27 fd ff ff       	jmp    c0101eee <__alltraps>

c01021c7 <vector79>:
.globl vector79
vector79:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $79
c01021c9:	6a 4f                	push   $0x4f
  jmp __alltraps
c01021cb:	e9 1e fd ff ff       	jmp    c0101eee <__alltraps>

c01021d0 <vector80>:
.globl vector80
vector80:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $80
c01021d2:	6a 50                	push   $0x50
  jmp __alltraps
c01021d4:	e9 15 fd ff ff       	jmp    c0101eee <__alltraps>

c01021d9 <vector81>:
.globl vector81
vector81:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $81
c01021db:	6a 51                	push   $0x51
  jmp __alltraps
c01021dd:	e9 0c fd ff ff       	jmp    c0101eee <__alltraps>

c01021e2 <vector82>:
.globl vector82
vector82:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $82
c01021e4:	6a 52                	push   $0x52
  jmp __alltraps
c01021e6:	e9 03 fd ff ff       	jmp    c0101eee <__alltraps>

c01021eb <vector83>:
.globl vector83
vector83:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $83
c01021ed:	6a 53                	push   $0x53
  jmp __alltraps
c01021ef:	e9 fa fc ff ff       	jmp    c0101eee <__alltraps>

c01021f4 <vector84>:
.globl vector84
vector84:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $84
c01021f6:	6a 54                	push   $0x54
  jmp __alltraps
c01021f8:	e9 f1 fc ff ff       	jmp    c0101eee <__alltraps>

c01021fd <vector85>:
.globl vector85
vector85:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $85
c01021ff:	6a 55                	push   $0x55
  jmp __alltraps
c0102201:	e9 e8 fc ff ff       	jmp    c0101eee <__alltraps>

c0102206 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $86
c0102208:	6a 56                	push   $0x56
  jmp __alltraps
c010220a:	e9 df fc ff ff       	jmp    c0101eee <__alltraps>

c010220f <vector87>:
.globl vector87
vector87:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $87
c0102211:	6a 57                	push   $0x57
  jmp __alltraps
c0102213:	e9 d6 fc ff ff       	jmp    c0101eee <__alltraps>

c0102218 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $88
c010221a:	6a 58                	push   $0x58
  jmp __alltraps
c010221c:	e9 cd fc ff ff       	jmp    c0101eee <__alltraps>

c0102221 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $89
c0102223:	6a 59                	push   $0x59
  jmp __alltraps
c0102225:	e9 c4 fc ff ff       	jmp    c0101eee <__alltraps>

c010222a <vector90>:
.globl vector90
vector90:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $90
c010222c:	6a 5a                	push   $0x5a
  jmp __alltraps
c010222e:	e9 bb fc ff ff       	jmp    c0101eee <__alltraps>

c0102233 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $91
c0102235:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102237:	e9 b2 fc ff ff       	jmp    c0101eee <__alltraps>

c010223c <vector92>:
.globl vector92
vector92:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $92
c010223e:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102240:	e9 a9 fc ff ff       	jmp    c0101eee <__alltraps>

c0102245 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $93
c0102247:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102249:	e9 a0 fc ff ff       	jmp    c0101eee <__alltraps>

c010224e <vector94>:
.globl vector94
vector94:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $94
c0102250:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102252:	e9 97 fc ff ff       	jmp    c0101eee <__alltraps>

c0102257 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102257:	6a 00                	push   $0x0
  pushl $95
c0102259:	6a 5f                	push   $0x5f
  jmp __alltraps
c010225b:	e9 8e fc ff ff       	jmp    c0101eee <__alltraps>

c0102260 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $96
c0102262:	6a 60                	push   $0x60
  jmp __alltraps
c0102264:	e9 85 fc ff ff       	jmp    c0101eee <__alltraps>

c0102269 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $97
c010226b:	6a 61                	push   $0x61
  jmp __alltraps
c010226d:	e9 7c fc ff ff       	jmp    c0101eee <__alltraps>

c0102272 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $98
c0102274:	6a 62                	push   $0x62
  jmp __alltraps
c0102276:	e9 73 fc ff ff       	jmp    c0101eee <__alltraps>

c010227b <vector99>:
.globl vector99
vector99:
  pushl $0
c010227b:	6a 00                	push   $0x0
  pushl $99
c010227d:	6a 63                	push   $0x63
  jmp __alltraps
c010227f:	e9 6a fc ff ff       	jmp    c0101eee <__alltraps>

c0102284 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $100
c0102286:	6a 64                	push   $0x64
  jmp __alltraps
c0102288:	e9 61 fc ff ff       	jmp    c0101eee <__alltraps>

c010228d <vector101>:
.globl vector101
vector101:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $101
c010228f:	6a 65                	push   $0x65
  jmp __alltraps
c0102291:	e9 58 fc ff ff       	jmp    c0101eee <__alltraps>

c0102296 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $102
c0102298:	6a 66                	push   $0x66
  jmp __alltraps
c010229a:	e9 4f fc ff ff       	jmp    c0101eee <__alltraps>

c010229f <vector103>:
.globl vector103
vector103:
  pushl $0
c010229f:	6a 00                	push   $0x0
  pushl $103
c01022a1:	6a 67                	push   $0x67
  jmp __alltraps
c01022a3:	e9 46 fc ff ff       	jmp    c0101eee <__alltraps>

c01022a8 <vector104>:
.globl vector104
vector104:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $104
c01022aa:	6a 68                	push   $0x68
  jmp __alltraps
c01022ac:	e9 3d fc ff ff       	jmp    c0101eee <__alltraps>

c01022b1 <vector105>:
.globl vector105
vector105:
  pushl $0
c01022b1:	6a 00                	push   $0x0
  pushl $105
c01022b3:	6a 69                	push   $0x69
  jmp __alltraps
c01022b5:	e9 34 fc ff ff       	jmp    c0101eee <__alltraps>

c01022ba <vector106>:
.globl vector106
vector106:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $106
c01022bc:	6a 6a                	push   $0x6a
  jmp __alltraps
c01022be:	e9 2b fc ff ff       	jmp    c0101eee <__alltraps>

c01022c3 <vector107>:
.globl vector107
vector107:
  pushl $0
c01022c3:	6a 00                	push   $0x0
  pushl $107
c01022c5:	6a 6b                	push   $0x6b
  jmp __alltraps
c01022c7:	e9 22 fc ff ff       	jmp    c0101eee <__alltraps>

c01022cc <vector108>:
.globl vector108
vector108:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $108
c01022ce:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022d0:	e9 19 fc ff ff       	jmp    c0101eee <__alltraps>

c01022d5 <vector109>:
.globl vector109
vector109:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $109
c01022d7:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022d9:	e9 10 fc ff ff       	jmp    c0101eee <__alltraps>

c01022de <vector110>:
.globl vector110
vector110:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $110
c01022e0:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022e2:	e9 07 fc ff ff       	jmp    c0101eee <__alltraps>

c01022e7 <vector111>:
.globl vector111
vector111:
  pushl $0
c01022e7:	6a 00                	push   $0x0
  pushl $111
c01022e9:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022eb:	e9 fe fb ff ff       	jmp    c0101eee <__alltraps>

c01022f0 <vector112>:
.globl vector112
vector112:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $112
c01022f2:	6a 70                	push   $0x70
  jmp __alltraps
c01022f4:	e9 f5 fb ff ff       	jmp    c0101eee <__alltraps>

c01022f9 <vector113>:
.globl vector113
vector113:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $113
c01022fb:	6a 71                	push   $0x71
  jmp __alltraps
c01022fd:	e9 ec fb ff ff       	jmp    c0101eee <__alltraps>

c0102302 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $114
c0102304:	6a 72                	push   $0x72
  jmp __alltraps
c0102306:	e9 e3 fb ff ff       	jmp    c0101eee <__alltraps>

c010230b <vector115>:
.globl vector115
vector115:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $115
c010230d:	6a 73                	push   $0x73
  jmp __alltraps
c010230f:	e9 da fb ff ff       	jmp    c0101eee <__alltraps>

c0102314 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $116
c0102316:	6a 74                	push   $0x74
  jmp __alltraps
c0102318:	e9 d1 fb ff ff       	jmp    c0101eee <__alltraps>

c010231d <vector117>:
.globl vector117
vector117:
  pushl $0
c010231d:	6a 00                	push   $0x0
  pushl $117
c010231f:	6a 75                	push   $0x75
  jmp __alltraps
c0102321:	e9 c8 fb ff ff       	jmp    c0101eee <__alltraps>

c0102326 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $118
c0102328:	6a 76                	push   $0x76
  jmp __alltraps
c010232a:	e9 bf fb ff ff       	jmp    c0101eee <__alltraps>

c010232f <vector119>:
.globl vector119
vector119:
  pushl $0
c010232f:	6a 00                	push   $0x0
  pushl $119
c0102331:	6a 77                	push   $0x77
  jmp __alltraps
c0102333:	e9 b6 fb ff ff       	jmp    c0101eee <__alltraps>

c0102338 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $120
c010233a:	6a 78                	push   $0x78
  jmp __alltraps
c010233c:	e9 ad fb ff ff       	jmp    c0101eee <__alltraps>

c0102341 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102341:	6a 00                	push   $0x0
  pushl $121
c0102343:	6a 79                	push   $0x79
  jmp __alltraps
c0102345:	e9 a4 fb ff ff       	jmp    c0101eee <__alltraps>

c010234a <vector122>:
.globl vector122
vector122:
  pushl $0
c010234a:	6a 00                	push   $0x0
  pushl $122
c010234c:	6a 7a                	push   $0x7a
  jmp __alltraps
c010234e:	e9 9b fb ff ff       	jmp    c0101eee <__alltraps>

c0102353 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102353:	6a 00                	push   $0x0
  pushl $123
c0102355:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102357:	e9 92 fb ff ff       	jmp    c0101eee <__alltraps>

c010235c <vector124>:
.globl vector124
vector124:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $124
c010235e:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102360:	e9 89 fb ff ff       	jmp    c0101eee <__alltraps>

c0102365 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102365:	6a 00                	push   $0x0
  pushl $125
c0102367:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102369:	e9 80 fb ff ff       	jmp    c0101eee <__alltraps>

c010236e <vector126>:
.globl vector126
vector126:
  pushl $0
c010236e:	6a 00                	push   $0x0
  pushl $126
c0102370:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102372:	e9 77 fb ff ff       	jmp    c0101eee <__alltraps>

c0102377 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102377:	6a 00                	push   $0x0
  pushl $127
c0102379:	6a 7f                	push   $0x7f
  jmp __alltraps
c010237b:	e9 6e fb ff ff       	jmp    c0101eee <__alltraps>

c0102380 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $128
c0102382:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102387:	e9 62 fb ff ff       	jmp    c0101eee <__alltraps>

c010238c <vector129>:
.globl vector129
vector129:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $129
c010238e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102393:	e9 56 fb ff ff       	jmp    c0101eee <__alltraps>

c0102398 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $130
c010239a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010239f:	e9 4a fb ff ff       	jmp    c0101eee <__alltraps>

c01023a4 <vector131>:
.globl vector131
vector131:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $131
c01023a6:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01023ab:	e9 3e fb ff ff       	jmp    c0101eee <__alltraps>

c01023b0 <vector132>:
.globl vector132
vector132:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $132
c01023b2:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01023b7:	e9 32 fb ff ff       	jmp    c0101eee <__alltraps>

c01023bc <vector133>:
.globl vector133
vector133:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $133
c01023be:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01023c3:	e9 26 fb ff ff       	jmp    c0101eee <__alltraps>

c01023c8 <vector134>:
.globl vector134
vector134:
  pushl $0
c01023c8:	6a 00                	push   $0x0
  pushl $134
c01023ca:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023cf:	e9 1a fb ff ff       	jmp    c0101eee <__alltraps>

c01023d4 <vector135>:
.globl vector135
vector135:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $135
c01023d6:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023db:	e9 0e fb ff ff       	jmp    c0101eee <__alltraps>

c01023e0 <vector136>:
.globl vector136
vector136:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $136
c01023e2:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023e7:	e9 02 fb ff ff       	jmp    c0101eee <__alltraps>

c01023ec <vector137>:
.globl vector137
vector137:
  pushl $0
c01023ec:	6a 00                	push   $0x0
  pushl $137
c01023ee:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023f3:	e9 f6 fa ff ff       	jmp    c0101eee <__alltraps>

c01023f8 <vector138>:
.globl vector138
vector138:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $138
c01023fa:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023ff:	e9 ea fa ff ff       	jmp    c0101eee <__alltraps>

c0102404 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $139
c0102406:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010240b:	e9 de fa ff ff       	jmp    c0101eee <__alltraps>

c0102410 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $140
c0102412:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102417:	e9 d2 fa ff ff       	jmp    c0101eee <__alltraps>

c010241c <vector141>:
.globl vector141
vector141:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $141
c010241e:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102423:	e9 c6 fa ff ff       	jmp    c0101eee <__alltraps>

c0102428 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $142
c010242a:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010242f:	e9 ba fa ff ff       	jmp    c0101eee <__alltraps>

c0102434 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $143
c0102436:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010243b:	e9 ae fa ff ff       	jmp    c0101eee <__alltraps>

c0102440 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $144
c0102442:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102447:	e9 a2 fa ff ff       	jmp    c0101eee <__alltraps>

c010244c <vector145>:
.globl vector145
vector145:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $145
c010244e:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102453:	e9 96 fa ff ff       	jmp    c0101eee <__alltraps>

c0102458 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $146
c010245a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010245f:	e9 8a fa ff ff       	jmp    c0101eee <__alltraps>

c0102464 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $147
c0102466:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010246b:	e9 7e fa ff ff       	jmp    c0101eee <__alltraps>

c0102470 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $148
c0102472:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102477:	e9 72 fa ff ff       	jmp    c0101eee <__alltraps>

c010247c <vector149>:
.globl vector149
vector149:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $149
c010247e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102483:	e9 66 fa ff ff       	jmp    c0101eee <__alltraps>

c0102488 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $150
c010248a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010248f:	e9 5a fa ff ff       	jmp    c0101eee <__alltraps>

c0102494 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $151
c0102496:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010249b:	e9 4e fa ff ff       	jmp    c0101eee <__alltraps>

c01024a0 <vector152>:
.globl vector152
vector152:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $152
c01024a2:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01024a7:	e9 42 fa ff ff       	jmp    c0101eee <__alltraps>

c01024ac <vector153>:
.globl vector153
vector153:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $153
c01024ae:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01024b3:	e9 36 fa ff ff       	jmp    c0101eee <__alltraps>

c01024b8 <vector154>:
.globl vector154
vector154:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $154
c01024ba:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01024bf:	e9 2a fa ff ff       	jmp    c0101eee <__alltraps>

c01024c4 <vector155>:
.globl vector155
vector155:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $155
c01024c6:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01024cb:	e9 1e fa ff ff       	jmp    c0101eee <__alltraps>

c01024d0 <vector156>:
.globl vector156
vector156:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $156
c01024d2:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024d7:	e9 12 fa ff ff       	jmp    c0101eee <__alltraps>

c01024dc <vector157>:
.globl vector157
vector157:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $157
c01024de:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024e3:	e9 06 fa ff ff       	jmp    c0101eee <__alltraps>

c01024e8 <vector158>:
.globl vector158
vector158:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $158
c01024ea:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024ef:	e9 fa f9 ff ff       	jmp    c0101eee <__alltraps>

c01024f4 <vector159>:
.globl vector159
vector159:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $159
c01024f6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024fb:	e9 ee f9 ff ff       	jmp    c0101eee <__alltraps>

c0102500 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $160
c0102502:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102507:	e9 e2 f9 ff ff       	jmp    c0101eee <__alltraps>

c010250c <vector161>:
.globl vector161
vector161:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $161
c010250e:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102513:	e9 d6 f9 ff ff       	jmp    c0101eee <__alltraps>

c0102518 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $162
c010251a:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010251f:	e9 ca f9 ff ff       	jmp    c0101eee <__alltraps>

c0102524 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $163
c0102526:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010252b:	e9 be f9 ff ff       	jmp    c0101eee <__alltraps>

c0102530 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $164
c0102532:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102537:	e9 b2 f9 ff ff       	jmp    c0101eee <__alltraps>

c010253c <vector165>:
.globl vector165
vector165:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $165
c010253e:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102543:	e9 a6 f9 ff ff       	jmp    c0101eee <__alltraps>

c0102548 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $166
c010254a:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010254f:	e9 9a f9 ff ff       	jmp    c0101eee <__alltraps>

c0102554 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $167
c0102556:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010255b:	e9 8e f9 ff ff       	jmp    c0101eee <__alltraps>

c0102560 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $168
c0102562:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102567:	e9 82 f9 ff ff       	jmp    c0101eee <__alltraps>

c010256c <vector169>:
.globl vector169
vector169:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $169
c010256e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102573:	e9 76 f9 ff ff       	jmp    c0101eee <__alltraps>

c0102578 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $170
c010257a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010257f:	e9 6a f9 ff ff       	jmp    c0101eee <__alltraps>

c0102584 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $171
c0102586:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010258b:	e9 5e f9 ff ff       	jmp    c0101eee <__alltraps>

c0102590 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $172
c0102592:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102597:	e9 52 f9 ff ff       	jmp    c0101eee <__alltraps>

c010259c <vector173>:
.globl vector173
vector173:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $173
c010259e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01025a3:	e9 46 f9 ff ff       	jmp    c0101eee <__alltraps>

c01025a8 <vector174>:
.globl vector174
vector174:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $174
c01025aa:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01025af:	e9 3a f9 ff ff       	jmp    c0101eee <__alltraps>

c01025b4 <vector175>:
.globl vector175
vector175:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $175
c01025b6:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01025bb:	e9 2e f9 ff ff       	jmp    c0101eee <__alltraps>

c01025c0 <vector176>:
.globl vector176
vector176:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $176
c01025c2:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01025c7:	e9 22 f9 ff ff       	jmp    c0101eee <__alltraps>

c01025cc <vector177>:
.globl vector177
vector177:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $177
c01025ce:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025d3:	e9 16 f9 ff ff       	jmp    c0101eee <__alltraps>

c01025d8 <vector178>:
.globl vector178
vector178:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $178
c01025da:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025df:	e9 0a f9 ff ff       	jmp    c0101eee <__alltraps>

c01025e4 <vector179>:
.globl vector179
vector179:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $179
c01025e6:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025eb:	e9 fe f8 ff ff       	jmp    c0101eee <__alltraps>

c01025f0 <vector180>:
.globl vector180
vector180:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $180
c01025f2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025f7:	e9 f2 f8 ff ff       	jmp    c0101eee <__alltraps>

c01025fc <vector181>:
.globl vector181
vector181:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $181
c01025fe:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102603:	e9 e6 f8 ff ff       	jmp    c0101eee <__alltraps>

c0102608 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $182
c010260a:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010260f:	e9 da f8 ff ff       	jmp    c0101eee <__alltraps>

c0102614 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $183
c0102616:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010261b:	e9 ce f8 ff ff       	jmp    c0101eee <__alltraps>

c0102620 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $184
c0102622:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102627:	e9 c2 f8 ff ff       	jmp    c0101eee <__alltraps>

c010262c <vector185>:
.globl vector185
vector185:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $185
c010262e:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102633:	e9 b6 f8 ff ff       	jmp    c0101eee <__alltraps>

c0102638 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $186
c010263a:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010263f:	e9 aa f8 ff ff       	jmp    c0101eee <__alltraps>

c0102644 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $187
c0102646:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010264b:	e9 9e f8 ff ff       	jmp    c0101eee <__alltraps>

c0102650 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $188
c0102652:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102657:	e9 92 f8 ff ff       	jmp    c0101eee <__alltraps>

c010265c <vector189>:
.globl vector189
vector189:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $189
c010265e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102663:	e9 86 f8 ff ff       	jmp    c0101eee <__alltraps>

c0102668 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $190
c010266a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010266f:	e9 7a f8 ff ff       	jmp    c0101eee <__alltraps>

c0102674 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $191
c0102676:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010267b:	e9 6e f8 ff ff       	jmp    c0101eee <__alltraps>

c0102680 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $192
c0102682:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102687:	e9 62 f8 ff ff       	jmp    c0101eee <__alltraps>

c010268c <vector193>:
.globl vector193
vector193:
  pushl $0
c010268c:	6a 00                	push   $0x0
  pushl $193
c010268e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102693:	e9 56 f8 ff ff       	jmp    c0101eee <__alltraps>

c0102698 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $194
c010269a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010269f:	e9 4a f8 ff ff       	jmp    c0101eee <__alltraps>

c01026a4 <vector195>:
.globl vector195
vector195:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $195
c01026a6:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01026ab:	e9 3e f8 ff ff       	jmp    c0101eee <__alltraps>

c01026b0 <vector196>:
.globl vector196
vector196:
  pushl $0
c01026b0:	6a 00                	push   $0x0
  pushl $196
c01026b2:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01026b7:	e9 32 f8 ff ff       	jmp    c0101eee <__alltraps>

c01026bc <vector197>:
.globl vector197
vector197:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $197
c01026be:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01026c3:	e9 26 f8 ff ff       	jmp    c0101eee <__alltraps>

c01026c8 <vector198>:
.globl vector198
vector198:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $198
c01026ca:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026cf:	e9 1a f8 ff ff       	jmp    c0101eee <__alltraps>

c01026d4 <vector199>:
.globl vector199
vector199:
  pushl $0
c01026d4:	6a 00                	push   $0x0
  pushl $199
c01026d6:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026db:	e9 0e f8 ff ff       	jmp    c0101eee <__alltraps>

c01026e0 <vector200>:
.globl vector200
vector200:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $200
c01026e2:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026e7:	e9 02 f8 ff ff       	jmp    c0101eee <__alltraps>

c01026ec <vector201>:
.globl vector201
vector201:
  pushl $0
c01026ec:	6a 00                	push   $0x0
  pushl $201
c01026ee:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026f3:	e9 f6 f7 ff ff       	jmp    c0101eee <__alltraps>

c01026f8 <vector202>:
.globl vector202
vector202:
  pushl $0
c01026f8:	6a 00                	push   $0x0
  pushl $202
c01026fa:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026ff:	e9 ea f7 ff ff       	jmp    c0101eee <__alltraps>

c0102704 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102704:	6a 00                	push   $0x0
  pushl $203
c0102706:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010270b:	e9 de f7 ff ff       	jmp    c0101eee <__alltraps>

c0102710 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102710:	6a 00                	push   $0x0
  pushl $204
c0102712:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102717:	e9 d2 f7 ff ff       	jmp    c0101eee <__alltraps>

c010271c <vector205>:
.globl vector205
vector205:
  pushl $0
c010271c:	6a 00                	push   $0x0
  pushl $205
c010271e:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102723:	e9 c6 f7 ff ff       	jmp    c0101eee <__alltraps>

c0102728 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102728:	6a 00                	push   $0x0
  pushl $206
c010272a:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010272f:	e9 ba f7 ff ff       	jmp    c0101eee <__alltraps>

c0102734 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102734:	6a 00                	push   $0x0
  pushl $207
c0102736:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010273b:	e9 ae f7 ff ff       	jmp    c0101eee <__alltraps>

c0102740 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102740:	6a 00                	push   $0x0
  pushl $208
c0102742:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102747:	e9 a2 f7 ff ff       	jmp    c0101eee <__alltraps>

c010274c <vector209>:
.globl vector209
vector209:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $209
c010274e:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102753:	e9 96 f7 ff ff       	jmp    c0101eee <__alltraps>

c0102758 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102758:	6a 00                	push   $0x0
  pushl $210
c010275a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010275f:	e9 8a f7 ff ff       	jmp    c0101eee <__alltraps>

c0102764 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102764:	6a 00                	push   $0x0
  pushl $211
c0102766:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010276b:	e9 7e f7 ff ff       	jmp    c0101eee <__alltraps>

c0102770 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $212
c0102772:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102777:	e9 72 f7 ff ff       	jmp    c0101eee <__alltraps>

c010277c <vector213>:
.globl vector213
vector213:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $213
c010277e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102783:	e9 66 f7 ff ff       	jmp    c0101eee <__alltraps>

c0102788 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102788:	6a 00                	push   $0x0
  pushl $214
c010278a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010278f:	e9 5a f7 ff ff       	jmp    c0101eee <__alltraps>

c0102794 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $215
c0102796:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010279b:	e9 4e f7 ff ff       	jmp    c0101eee <__alltraps>

c01027a0 <vector216>:
.globl vector216
vector216:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $216
c01027a2:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01027a7:	e9 42 f7 ff ff       	jmp    c0101eee <__alltraps>

c01027ac <vector217>:
.globl vector217
vector217:
  pushl $0
c01027ac:	6a 00                	push   $0x0
  pushl $217
c01027ae:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01027b3:	e9 36 f7 ff ff       	jmp    c0101eee <__alltraps>

c01027b8 <vector218>:
.globl vector218
vector218:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $218
c01027ba:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01027bf:	e9 2a f7 ff ff       	jmp    c0101eee <__alltraps>

c01027c4 <vector219>:
.globl vector219
vector219:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $219
c01027c6:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01027cb:	e9 1e f7 ff ff       	jmp    c0101eee <__alltraps>

c01027d0 <vector220>:
.globl vector220
vector220:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $220
c01027d2:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027d7:	e9 12 f7 ff ff       	jmp    c0101eee <__alltraps>

c01027dc <vector221>:
.globl vector221
vector221:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $221
c01027de:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027e3:	e9 06 f7 ff ff       	jmp    c0101eee <__alltraps>

c01027e8 <vector222>:
.globl vector222
vector222:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $222
c01027ea:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027ef:	e9 fa f6 ff ff       	jmp    c0101eee <__alltraps>

c01027f4 <vector223>:
.globl vector223
vector223:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $223
c01027f6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027fb:	e9 ee f6 ff ff       	jmp    c0101eee <__alltraps>

c0102800 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102800:	6a 00                	push   $0x0
  pushl $224
c0102802:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102807:	e9 e2 f6 ff ff       	jmp    c0101eee <__alltraps>

c010280c <vector225>:
.globl vector225
vector225:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $225
c010280e:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102813:	e9 d6 f6 ff ff       	jmp    c0101eee <__alltraps>

c0102818 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $226
c010281a:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010281f:	e9 ca f6 ff ff       	jmp    c0101eee <__alltraps>

c0102824 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102824:	6a 00                	push   $0x0
  pushl $227
c0102826:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010282b:	e9 be f6 ff ff       	jmp    c0101eee <__alltraps>

c0102830 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $228
c0102832:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102837:	e9 b2 f6 ff ff       	jmp    c0101eee <__alltraps>

c010283c <vector229>:
.globl vector229
vector229:
  pushl $0
c010283c:	6a 00                	push   $0x0
  pushl $229
c010283e:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102843:	e9 a6 f6 ff ff       	jmp    c0101eee <__alltraps>

c0102848 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102848:	6a 00                	push   $0x0
  pushl $230
c010284a:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010284f:	e9 9a f6 ff ff       	jmp    c0101eee <__alltraps>

c0102854 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $231
c0102856:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010285b:	e9 8e f6 ff ff       	jmp    c0101eee <__alltraps>

c0102860 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102860:	6a 00                	push   $0x0
  pushl $232
c0102862:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102867:	e9 82 f6 ff ff       	jmp    c0101eee <__alltraps>

c010286c <vector233>:
.globl vector233
vector233:
  pushl $0
c010286c:	6a 00                	push   $0x0
  pushl $233
c010286e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102873:	e9 76 f6 ff ff       	jmp    c0101eee <__alltraps>

c0102878 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102878:	6a 00                	push   $0x0
  pushl $234
c010287a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010287f:	e9 6a f6 ff ff       	jmp    c0101eee <__alltraps>

c0102884 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102884:	6a 00                	push   $0x0
  pushl $235
c0102886:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010288b:	e9 5e f6 ff ff       	jmp    c0101eee <__alltraps>

c0102890 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102890:	6a 00                	push   $0x0
  pushl $236
c0102892:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102897:	e9 52 f6 ff ff       	jmp    c0101eee <__alltraps>

c010289c <vector237>:
.globl vector237
vector237:
  pushl $0
c010289c:	6a 00                	push   $0x0
  pushl $237
c010289e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01028a3:	e9 46 f6 ff ff       	jmp    c0101eee <__alltraps>

c01028a8 <vector238>:
.globl vector238
vector238:
  pushl $0
c01028a8:	6a 00                	push   $0x0
  pushl $238
c01028aa:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01028af:	e9 3a f6 ff ff       	jmp    c0101eee <__alltraps>

c01028b4 <vector239>:
.globl vector239
vector239:
  pushl $0
c01028b4:	6a 00                	push   $0x0
  pushl $239
c01028b6:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01028bb:	e9 2e f6 ff ff       	jmp    c0101eee <__alltraps>

c01028c0 <vector240>:
.globl vector240
vector240:
  pushl $0
c01028c0:	6a 00                	push   $0x0
  pushl $240
c01028c2:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01028c7:	e9 22 f6 ff ff       	jmp    c0101eee <__alltraps>

c01028cc <vector241>:
.globl vector241
vector241:
  pushl $0
c01028cc:	6a 00                	push   $0x0
  pushl $241
c01028ce:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028d3:	e9 16 f6 ff ff       	jmp    c0101eee <__alltraps>

c01028d8 <vector242>:
.globl vector242
vector242:
  pushl $0
c01028d8:	6a 00                	push   $0x0
  pushl $242
c01028da:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028df:	e9 0a f6 ff ff       	jmp    c0101eee <__alltraps>

c01028e4 <vector243>:
.globl vector243
vector243:
  pushl $0
c01028e4:	6a 00                	push   $0x0
  pushl $243
c01028e6:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028eb:	e9 fe f5 ff ff       	jmp    c0101eee <__alltraps>

c01028f0 <vector244>:
.globl vector244
vector244:
  pushl $0
c01028f0:	6a 00                	push   $0x0
  pushl $244
c01028f2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028f7:	e9 f2 f5 ff ff       	jmp    c0101eee <__alltraps>

c01028fc <vector245>:
.globl vector245
vector245:
  pushl $0
c01028fc:	6a 00                	push   $0x0
  pushl $245
c01028fe:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102903:	e9 e6 f5 ff ff       	jmp    c0101eee <__alltraps>

c0102908 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102908:	6a 00                	push   $0x0
  pushl $246
c010290a:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010290f:	e9 da f5 ff ff       	jmp    c0101eee <__alltraps>

c0102914 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102914:	6a 00                	push   $0x0
  pushl $247
c0102916:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010291b:	e9 ce f5 ff ff       	jmp    c0101eee <__alltraps>

c0102920 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102920:	6a 00                	push   $0x0
  pushl $248
c0102922:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102927:	e9 c2 f5 ff ff       	jmp    c0101eee <__alltraps>

c010292c <vector249>:
.globl vector249
vector249:
  pushl $0
c010292c:	6a 00                	push   $0x0
  pushl $249
c010292e:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102933:	e9 b6 f5 ff ff       	jmp    c0101eee <__alltraps>

c0102938 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102938:	6a 00                	push   $0x0
  pushl $250
c010293a:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010293f:	e9 aa f5 ff ff       	jmp    c0101eee <__alltraps>

c0102944 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102944:	6a 00                	push   $0x0
  pushl $251
c0102946:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010294b:	e9 9e f5 ff ff       	jmp    c0101eee <__alltraps>

c0102950 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102950:	6a 00                	push   $0x0
  pushl $252
c0102952:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102957:	e9 92 f5 ff ff       	jmp    c0101eee <__alltraps>

c010295c <vector253>:
.globl vector253
vector253:
  pushl $0
c010295c:	6a 00                	push   $0x0
  pushl $253
c010295e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102963:	e9 86 f5 ff ff       	jmp    c0101eee <__alltraps>

c0102968 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102968:	6a 00                	push   $0x0
  pushl $254
c010296a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010296f:	e9 7a f5 ff ff       	jmp    c0101eee <__alltraps>

c0102974 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102974:	6a 00                	push   $0x0
  pushl $255
c0102976:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010297b:	e9 6e f5 ff ff       	jmp    c0101eee <__alltraps>

c0102980 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102980:	55                   	push   %ebp
c0102981:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102983:	8b 55 08             	mov    0x8(%ebp),%edx
c0102986:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c010298b:	29 c2                	sub    %eax,%edx
c010298d:	89 d0                	mov    %edx,%eax
c010298f:	c1 f8 02             	sar    $0x2,%eax
c0102992:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102998:	5d                   	pop    %ebp
c0102999:	c3                   	ret    

c010299a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010299a:	55                   	push   %ebp
c010299b:	89 e5                	mov    %esp,%ebp
c010299d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01029a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a3:	89 04 24             	mov    %eax,(%esp)
c01029a6:	e8 d5 ff ff ff       	call   c0102980 <page2ppn>
c01029ab:	c1 e0 0c             	shl    $0xc,%eax
}
c01029ae:	c9                   	leave  
c01029af:	c3                   	ret    

c01029b0 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01029b0:	55                   	push   %ebp
c01029b1:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01029b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01029b6:	8b 00                	mov    (%eax),%eax
}
c01029b8:	5d                   	pop    %ebp
c01029b9:	c3                   	ret    

c01029ba <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01029ba:	55                   	push   %ebp
c01029bb:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01029bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029c3:	89 10                	mov    %edx,(%eax)
}
c01029c5:	5d                   	pop    %ebp
c01029c6:	c3                   	ret    

c01029c7 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01029c7:	55                   	push   %ebp
c01029c8:	89 e5                	mov    %esp,%ebp
c01029ca:	83 ec 10             	sub    $0x10,%esp
c01029cd:	c7 45 fc b0 89 11 c0 	movl   $0xc01189b0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01029d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01029da:	89 50 04             	mov    %edx,0x4(%eax)
c01029dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029e0:	8b 50 04             	mov    0x4(%eax),%edx
c01029e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029e6:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);   //未更改，建立一个空的双向链表
    nr_free = 0;             //设置空块总量为0
c01029e8:	c7 05 b8 89 11 c0 00 	movl   $0x0,0xc01189b8
c01029ef:	00 00 00 
}
c01029f2:	c9                   	leave  
c01029f3:	c3                   	ret    

c01029f4 <default_init_memmap>:
/**
 * 初始化管理空闲内存页的数据结构
 * 探测到一个基址为base，大小为n 的空间，将它加入list（开始时做一点检查）
 */
static void
default_init_memmap(struct Page *base, size_t n) {
c01029f4:	55                   	push   %ebp
c01029f5:	89 e5                	mov    %esp,%ebp
c01029f7:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01029fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01029fe:	75 24                	jne    c0102a24 <default_init_memmap+0x30>
c0102a00:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102a07:	c0 
c0102a08:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102a0f:	c0 
c0102a10:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c0102a17:	00 
c0102a18:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102a1f:	e8 8e e2 ff ff       	call   c0100cb2 <__panic>
    struct Page *p = base;
c0102a24:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102a2a:	eb 7d                	jmp    c0102aa9 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a2f:	83 c0 04             	add    $0x4,%eax
c0102a32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102a39:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102a42:	0f a3 10             	bt     %edx,(%eax)
c0102a45:	19 c0                	sbb    %eax,%eax
c0102a47:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102a4a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102a4e:	0f 95 c0             	setne  %al
c0102a51:	0f b6 c0             	movzbl %al,%eax
c0102a54:	85 c0                	test   %eax,%eax
c0102a56:	75 24                	jne    c0102a7c <default_init_memmap+0x88>
c0102a58:	c7 44 24 0c 61 68 10 	movl   $0xc0106861,0xc(%esp)
c0102a5f:	c0 
c0102a60:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102a67:	c0 
c0102a68:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
c0102a6f:	00 
c0102a70:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102a77:	e8 36 e2 ff ff       	call   c0100cb2 <__panic>
        p->flags = p->property = 0;
c0102a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a7f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a89:	8b 50 08             	mov    0x8(%eax),%edx
c0102a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a8f:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102a92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a99:	00 
c0102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a9d:	89 04 24             	mov    %eax,(%esp)
c0102aa0:	e8 15 ff ff ff       	call   c01029ba <set_page_ref>
 */
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102aa5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aac:	89 d0                	mov    %edx,%eax
c0102aae:	c1 e0 02             	shl    $0x2,%eax
c0102ab1:	01 d0                	add    %edx,%eax
c0102ab3:	c1 e0 02             	shl    $0x2,%eax
c0102ab6:	89 c2                	mov    %eax,%edx
c0102ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102abb:	01 d0                	add    %edx,%eax
c0102abd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ac0:	0f 85 66 ff ff ff    	jne    c0102a2c <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102acc:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad2:	83 c0 04             	add    $0x4,%eax
c0102ad5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102adc:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102adf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ae2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102ae5:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0102ae8:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c0102aee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102af1:	01 d0                	add    %edx,%eax
c0102af3:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8
    // 按地址序，依次往后排列。双向链表，头指针指向的前一个就是最后一个。
    list_add_before(&free_list, &(base->page_link)); 
c0102af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102afb:	83 c0 0c             	add    $0xc,%eax
c0102afe:	c7 45 dc b0 89 11 c0 	movl   $0xc01189b0,-0x24(%ebp)
c0102b05:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102b08:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b0b:	8b 00                	mov    (%eax),%eax
c0102b0d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102b13:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102b16:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b19:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b1f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b22:	89 10                	mov    %edx,(%eax)
c0102b24:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b27:	8b 10                	mov    (%eax),%edx
c0102b29:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b2c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b32:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b35:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b3b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b3e:	89 10                	mov    %edx,(%eax)
}
c0102b40:	c9                   	leave  
c0102b41:	c3                   	ret    

c0102b42 <default_alloc_pages>:

// 可以发现，现在的分配方法中list是无序的，就是根据释放时序。
// 取的时候，直接去找第一个可行的。
static struct Page *
default_alloc_pages(size_t n) {
c0102b42:	55                   	push   %ebp
c0102b43:	89 e5                	mov    %esp,%ebp
c0102b45:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102b48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b4c:	75 24                	jne    c0102b72 <default_alloc_pages+0x30>
c0102b4e:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102b55:	c0 
c0102b56:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102b5d:	c0 
c0102b5e:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
c0102b65:	00 
c0102b66:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102b6d:	e8 40 e1 ff ff       	call   c0100cb2 <__panic>
    // 要的页数比剩余free的页数都多，return null
    if (n > nr_free) {
c0102b72:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0102b77:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b7a:	73 0a                	jae    c0102b86 <default_alloc_pages+0x44>
        return NULL;
c0102b7c:	b8 00 00 00 00       	mov    $0x0,%eax
c0102b81:	e9 3d 01 00 00       	jmp    c0102cc3 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
c0102b86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102b8d:	c7 45 f0 b0 89 11 c0 	movl   $0xc01189b0,-0x10(%ebp)
    // 找了一圈后退出 TODO: list有空的头结点吗？有吧。
    while ((le = list_next(le)) != &free_list) {
c0102b94:	eb 1c                	jmp    c0102bb2 <default_alloc_pages+0x70>
        // 找到这个节点所在的基于Page的变量
        struct Page *p = le2page(le, page_link);
c0102b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b99:	83 e8 0c             	sub    $0xc,%eax
c0102b9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        // 找到了一个满足的，就把这个空间（的首页）拿出来
        if (p->property >= n) {
c0102b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ba2:	8b 40 08             	mov    0x8(%eax),%eax
c0102ba5:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ba8:	72 08                	jb     c0102bb2 <default_alloc_pages+0x70>
            page = p;
c0102baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102bb0:	eb 18                	jmp    c0102bca <default_alloc_pages+0x88>
c0102bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bbb:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    // 找了一圈后退出 TODO: list有空的头结点吗？有吧。
    while ((le = list_next(le)) != &free_list) {
c0102bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102bc1:	81 7d f0 b0 89 11 c0 	cmpl   $0xc01189b0,-0x10(%ebp)
c0102bc8:	75 cc                	jne    c0102b96 <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
    //如果找到了可行区域
    if (page != NULL) {
c0102bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102bce:	0f 84 ec 00 00 00    	je     c0102cc0 <default_alloc_pages+0x17e>
        // 这个可行区域的空间大于需求空间，拆分，将剩下的一段放到list中【free_list的后面一个】
        if (page->property > n) {
c0102bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bd7:	8b 40 08             	mov    0x8(%eax),%eax
c0102bda:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bdd:	0f 86 8c 00 00 00    	jbe    c0102c6f <default_alloc_pages+0x12d>
            struct Page *p = page + n;
c0102be3:	8b 55 08             	mov    0x8(%ebp),%edx
c0102be6:	89 d0                	mov    %edx,%eax
c0102be8:	c1 e0 02             	shl    $0x2,%eax
c0102beb:	01 d0                	add    %edx,%eax
c0102bed:	c1 e0 02             	shl    $0x2,%eax
c0102bf0:	89 c2                	mov    %eax,%edx
c0102bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bf5:	01 d0                	add    %edx,%eax
c0102bf7:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bfd:	8b 40 08             	mov    0x8(%eax),%eax
c0102c00:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c03:	89 c2                	mov    %eax,%edx
c0102c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c08:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c0e:	83 c0 04             	add    $0x4,%eax
c0102c11:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c18:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102c1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c21:	0f ab 10             	bts    %edx,(%eax)
            // 加入后来的，p
            list_add_after(&(page->page_link), &(p->page_link));
c0102c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c27:	83 c0 0c             	add    $0xc,%eax
c0102c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102c2d:	83 c2 0c             	add    $0xc,%edx
c0102c30:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102c33:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102c36:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102c39:	8b 40 04             	mov    0x4(%eax),%eax
c0102c3c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c3f:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102c42:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c45:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102c48:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c4b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c51:	89 10                	mov    %edx,(%eax)
c0102c53:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c56:	8b 10                	mov    (%eax),%edx
c0102c58:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c5b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c61:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c64:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c67:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c6a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102c6d:	89 10                	mov    %edx,(%eax)
            // list_add(&free_list, &(p->page_link));
        }
        // 删除原来的
        list_del(&(page->page_link));
c0102c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c72:	83 c0 0c             	add    $0xc,%eax
c0102c75:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102c78:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c7b:	8b 40 04             	mov    0x4(%eax),%eax
c0102c7e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102c81:	8b 12                	mov    (%edx),%edx
c0102c83:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102c86:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102c89:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102c8c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102c8f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c92:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c95:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102c98:	89 10                	mov    %edx,(%eax)
        // 更新空余空间的状态
        nr_free -= n;
c0102c9a:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0102c9f:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ca2:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8
        //page被使用了，所以把它的属性clear掉
        ClearPageProperty(page);
c0102ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102caa:	83 c0 04             	add    $0x4,%eax
c0102cad:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102cb4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cb7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102cba:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102cbd:	0f b3 10             	btr    %edx,(%eax)
    }
    // 返回page
    return page;
c0102cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102cc3:	c9                   	leave  
c0102cc4:	c3                   	ret    

c0102cc5 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102cc5:	55                   	push   %ebp
c0102cc6:	89 e5                	mov    %esp,%ebp
c0102cc8:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
c0102cce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102cd2:	75 24                	jne    c0102cf8 <default_free_pages+0x33>
c0102cd4:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102cdb:	c0 
c0102cdc:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102ce3:	c0 
c0102ce4:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0102ceb:	00 
c0102cec:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102cf3:	e8 ba df ff ff       	call   c0100cb2 <__panic>
    struct Page *p = base;
c0102cf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // 先更改被释放的这几页的标记位
    for (; p != base + n; p ++) {
c0102cfe:	e9 9d 00 00 00       	jmp    c0102da0 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d06:	83 c0 04             	add    $0x4,%eax
c0102d09:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0102d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d19:	0f a3 10             	bt     %edx,(%eax)
c0102d1c:	19 c0                	sbb    %eax,%eax
c0102d1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c0102d21:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0102d25:	0f 95 c0             	setne  %al
c0102d28:	0f b6 c0             	movzbl %al,%eax
c0102d2b:	85 c0                	test   %eax,%eax
c0102d2d:	75 2c                	jne    c0102d5b <default_free_pages+0x96>
c0102d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d32:	83 c0 04             	add    $0x4,%eax
c0102d35:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0102d3c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d42:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102d45:	0f a3 10             	bt     %edx,(%eax)
c0102d48:	19 c0                	sbb    %eax,%eax
c0102d4a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c0102d4d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0102d51:	0f 95 c0             	setne  %al
c0102d54:	0f b6 c0             	movzbl %al,%eax
c0102d57:	85 c0                	test   %eax,%eax
c0102d59:	74 24                	je     c0102d7f <default_free_pages+0xba>
c0102d5b:	c7 44 24 0c 74 68 10 	movl   $0xc0106874,0xc(%esp)
c0102d62:	c0 
c0102d63:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102d6a:	c0 
c0102d6b:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102d72:	00 
c0102d73:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102d7a:	e8 33 df ff ff       	call   c0100cb2 <__panic>
        p->flags = 0;
c0102d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102d89:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d90:	00 
c0102d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d94:	89 04 24             	mov    %eax,(%esp)
c0102d97:	e8 1e fc ff ff       	call   c01029ba <set_page_ref>
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    // 先更改被释放的这几页的标记位
    for (; p != base + n; p ++) {
c0102d9c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102da0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102da3:	89 d0                	mov    %edx,%eax
c0102da5:	c1 e0 02             	shl    $0x2,%eax
c0102da8:	01 d0                	add    %edx,%eax
c0102daa:	c1 e0 02             	shl    $0x2,%eax
c0102dad:	89 c2                	mov    %eax,%edx
c0102daf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db2:	01 d0                	add    %edx,%eax
c0102db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102db7:	0f 85 46 ff ff ff    	jne    c0102d03 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    // 将这几块视为一个连续的内存空间
    base->property = n;
c0102dbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102dc3:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102dc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc9:	83 c0 04             	add    $0x4,%eax
c0102dcc:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102dd3:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dd6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102dd9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ddc:	0f ab 10             	bts    %edx,(%eax)
c0102ddf:	c7 45 c4 b0 89 11 c0 	movl   $0xc01189b0,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102de6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102de9:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *next_entry = list_next(&free_list);
c0102dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 找到base的前一块空块
    while (next_entry != &free_list && le2page(next_entry, page_link) < base)
c0102def:	eb 0f                	jmp    c0102e00 <default_free_pages+0x13b>
c0102df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102df4:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0102df7:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102dfa:	8b 40 04             	mov    0x4(%eax),%eax
        next_entry = list_next(next_entry);
c0102dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 将这几块视为一个连续的内存空间
    base->property = n;
    SetPageProperty(base);
    list_entry_t *next_entry = list_next(&free_list);
    // 找到base的前一块空块
    while (next_entry != &free_list && le2page(next_entry, page_link) < base)
c0102e00:	81 7d f0 b0 89 11 c0 	cmpl   $0xc01189b0,-0x10(%ebp)
c0102e07:	74 0b                	je     c0102e14 <default_free_pages+0x14f>
c0102e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e0c:	83 e8 0c             	sub    $0xc,%eax
c0102e0f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102e12:	72 dd                	jb     c0102df1 <default_free_pages+0x12c>
c0102e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e17:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102e1a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102e1d:	8b 00                	mov    (%eax),%eax
        next_entry = list_next(next_entry);
    // Merge block
    list_entry_t *prev_entry = list_prev(next_entry);
c0102e1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    list_entry_t *insert_entry = prev_entry;
c0102e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e25:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // 如果和前一块挨在一起，就和前一块合并
    if (prev_entry != &free_list) {
c0102e28:	81 7d e8 b0 89 11 c0 	cmpl   $0xc01189b0,-0x18(%ebp)
c0102e2f:	0f 84 8e 00 00 00    	je     c0102ec3 <default_free_pages+0x1fe>
        p = le2page(prev_entry, page_link);
c0102e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e38:	83 e8 0c             	sub    $0xc,%eax
c0102e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p + p->property == base) {
c0102e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e41:	8b 50 08             	mov    0x8(%eax),%edx
c0102e44:	89 d0                	mov    %edx,%eax
c0102e46:	c1 e0 02             	shl    $0x2,%eax
c0102e49:	01 d0                	add    %edx,%eax
c0102e4b:	c1 e0 02             	shl    $0x2,%eax
c0102e4e:	89 c2                	mov    %eax,%edx
c0102e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e53:	01 d0                	add    %edx,%eax
c0102e55:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102e58:	75 69                	jne    c0102ec3 <default_free_pages+0x1fe>
            p->property += base->property;
c0102e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e5d:	8b 50 08             	mov    0x8(%eax),%edx
c0102e60:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e63:	8b 40 08             	mov    0x8(%eax),%eax
c0102e66:	01 c2                	add    %eax,%edx
c0102e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e6b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102e6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e71:	83 c0 04             	add    $0x4,%eax
c0102e74:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102e7b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e7e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e81:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102e84:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e8a:	89 45 08             	mov    %eax,0x8(%ebp)
c0102e8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e90:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102e93:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e96:	8b 00                	mov    (%eax),%eax
            insert_entry = list_prev(prev_entry);
c0102e98:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e9e:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102ea1:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102ea4:	8b 40 04             	mov    0x4(%eax),%eax
c0102ea7:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102eaa:	8b 12                	mov    (%edx),%edx
c0102eac:	89 55 a8             	mov    %edx,-0x58(%ebp)
c0102eaf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102eb2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102eb5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102eb8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102ebb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102ebe:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102ec1:	89 10                	mov    %edx,(%eax)
            list_del(prev_entry);
        }
    }
    if (next_entry != &free_list) {
c0102ec3:	81 7d f0 b0 89 11 c0 	cmpl   $0xc01189b0,-0x10(%ebp)
c0102eca:	74 7a                	je     c0102f46 <default_free_pages+0x281>
        p = le2page(next_entry, page_link);
c0102ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ecf:	83 e8 0c             	sub    $0xc,%eax
c0102ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
c0102ed5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ed8:	8b 50 08             	mov    0x8(%eax),%edx
c0102edb:	89 d0                	mov    %edx,%eax
c0102edd:	c1 e0 02             	shl    $0x2,%eax
c0102ee0:	01 d0                	add    %edx,%eax
c0102ee2:	c1 e0 02             	shl    $0x2,%eax
c0102ee5:	89 c2                	mov    %eax,%edx
c0102ee7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eea:	01 d0                	add    %edx,%eax
c0102eec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102eef:	75 55                	jne    c0102f46 <default_free_pages+0x281>
            base->property += p->property;
c0102ef1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef4:	8b 50 08             	mov    0x8(%eax),%edx
c0102ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102efa:	8b 40 08             	mov    0x8(%eax),%eax
c0102efd:	01 c2                	add    %eax,%edx
c0102eff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f02:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f08:	83 c0 04             	add    $0x4,%eax
c0102f0b:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0102f12:	89 45 9c             	mov    %eax,-0x64(%ebp)
c0102f15:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102f18:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102f1b:	0f b3 10             	btr    %edx,(%eax)
c0102f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f21:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102f24:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f27:	8b 40 04             	mov    0x4(%eax),%eax
c0102f2a:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102f2d:	8b 12                	mov    (%edx),%edx
c0102f2f:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0102f32:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102f35:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f38:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102f3b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f3e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102f41:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102f44:	89 10                	mov    %edx,(%eax)
            list_del(next_entry);
        }
    }
    nr_free += n;
c0102f46:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c0102f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f4f:	01 d0                	add    %edx,%eax
c0102f51:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8
    list_add(insert_entry, &(base->page_link));
c0102f56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f59:	8d 50 0c             	lea    0xc(%eax),%edx
c0102f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f5f:	89 45 8c             	mov    %eax,-0x74(%ebp)
c0102f62:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102f65:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f68:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102f6b:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102f6e:	89 45 80             	mov    %eax,-0x80(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102f71:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102f74:	8b 40 04             	mov    0x4(%eax),%eax
c0102f77:	8b 55 80             	mov    -0x80(%ebp),%edx
c0102f7a:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102f80:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102f83:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
c0102f89:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102f8f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0102f95:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102f9b:	89 10                	mov    %edx,(%eax)
c0102f9d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0102fa3:	8b 10                	mov    (%eax),%edx
c0102fa5:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102fab:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102fae:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102fb4:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c0102fba:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102fbd:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102fc3:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c0102fc9:	89 10                	mov    %edx,(%eax)
}
c0102fcb:	c9                   	leave  
c0102fcc:	c3                   	ret    

c0102fcd <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102fcd:	55                   	push   %ebp
c0102fce:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102fd0:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
}
c0102fd5:	5d                   	pop    %ebp
c0102fd6:	c3                   	ret    

c0102fd7 <basic_check>:

static void
basic_check(void) {
c0102fd7:	55                   	push   %ebp
c0102fd8:	89 e5                	mov    %esp,%ebp
c0102fda:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102fdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102ff0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ff7:	e8 85 0e 00 00       	call   c0103e81 <alloc_pages>
c0102ffc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102fff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103003:	75 24                	jne    c0103029 <basic_check+0x52>
c0103005:	c7 44 24 0c 99 68 10 	movl   $0xc0106899,0xc(%esp)
c010300c:	c0 
c010300d:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103014:	c0 
c0103015:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010301c:	00 
c010301d:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103024:	e8 89 dc ff ff       	call   c0100cb2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103029:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103030:	e8 4c 0e 00 00       	call   c0103e81 <alloc_pages>
c0103035:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103038:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010303c:	75 24                	jne    c0103062 <basic_check+0x8b>
c010303e:	c7 44 24 0c b5 68 10 	movl   $0xc01068b5,0xc(%esp)
c0103045:	c0 
c0103046:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010304d:	c0 
c010304e:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103055:	00 
c0103056:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010305d:	e8 50 dc ff ff       	call   c0100cb2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103062:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103069:	e8 13 0e 00 00       	call   c0103e81 <alloc_pages>
c010306e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103075:	75 24                	jne    c010309b <basic_check+0xc4>
c0103077:	c7 44 24 0c d1 68 10 	movl   $0xc01068d1,0xc(%esp)
c010307e:	c0 
c010307f:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103086:	c0 
c0103087:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010308e:	00 
c010308f:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103096:	e8 17 dc ff ff       	call   c0100cb2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010309b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010309e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01030a1:	74 10                	je     c01030b3 <basic_check+0xdc>
c01030a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01030a9:	74 08                	je     c01030b3 <basic_check+0xdc>
c01030ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01030b1:	75 24                	jne    c01030d7 <basic_check+0x100>
c01030b3:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c01030ba:	c0 
c01030bb:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01030c2:	c0 
c01030c3:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c01030ca:	00 
c01030cb:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01030d2:	e8 db db ff ff       	call   c0100cb2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01030d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030da:	89 04 24             	mov    %eax,(%esp)
c01030dd:	e8 ce f8 ff ff       	call   c01029b0 <page_ref>
c01030e2:	85 c0                	test   %eax,%eax
c01030e4:	75 1e                	jne    c0103104 <basic_check+0x12d>
c01030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030e9:	89 04 24             	mov    %eax,(%esp)
c01030ec:	e8 bf f8 ff ff       	call   c01029b0 <page_ref>
c01030f1:	85 c0                	test   %eax,%eax
c01030f3:	75 0f                	jne    c0103104 <basic_check+0x12d>
c01030f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030f8:	89 04 24             	mov    %eax,(%esp)
c01030fb:	e8 b0 f8 ff ff       	call   c01029b0 <page_ref>
c0103100:	85 c0                	test   %eax,%eax
c0103102:	74 24                	je     c0103128 <basic_check+0x151>
c0103104:	c7 44 24 0c 14 69 10 	movl   $0xc0106914,0xc(%esp)
c010310b:	c0 
c010310c:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103113:	c0 
c0103114:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010311b:	00 
c010311c:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103123:	e8 8a db ff ff       	call   c0100cb2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103128:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010312b:	89 04 24             	mov    %eax,(%esp)
c010312e:	e8 67 f8 ff ff       	call   c010299a <page2pa>
c0103133:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103139:	c1 e2 0c             	shl    $0xc,%edx
c010313c:	39 d0                	cmp    %edx,%eax
c010313e:	72 24                	jb     c0103164 <basic_check+0x18d>
c0103140:	c7 44 24 0c 50 69 10 	movl   $0xc0106950,0xc(%esp)
c0103147:	c0 
c0103148:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010314f:	c0 
c0103150:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103157:	00 
c0103158:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010315f:	e8 4e db ff ff       	call   c0100cb2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103164:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103167:	89 04 24             	mov    %eax,(%esp)
c010316a:	e8 2b f8 ff ff       	call   c010299a <page2pa>
c010316f:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103175:	c1 e2 0c             	shl    $0xc,%edx
c0103178:	39 d0                	cmp    %edx,%eax
c010317a:	72 24                	jb     c01031a0 <basic_check+0x1c9>
c010317c:	c7 44 24 0c 6d 69 10 	movl   $0xc010696d,0xc(%esp)
c0103183:	c0 
c0103184:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010318b:	c0 
c010318c:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103193:	00 
c0103194:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010319b:	e8 12 db ff ff       	call   c0100cb2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031a3:	89 04 24             	mov    %eax,(%esp)
c01031a6:	e8 ef f7 ff ff       	call   c010299a <page2pa>
c01031ab:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c01031b1:	c1 e2 0c             	shl    $0xc,%edx
c01031b4:	39 d0                	cmp    %edx,%eax
c01031b6:	72 24                	jb     c01031dc <basic_check+0x205>
c01031b8:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c01031bf:	c0 
c01031c0:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01031c7:	c0 
c01031c8:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c01031cf:	00 
c01031d0:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01031d7:	e8 d6 da ff ff       	call   c0100cb2 <__panic>

    list_entry_t free_list_store = free_list;
c01031dc:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c01031e1:	8b 15 b4 89 11 c0    	mov    0xc01189b4,%edx
c01031e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01031ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01031ed:	c7 45 e0 b0 89 11 c0 	movl   $0xc01189b0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01031f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01031fa:	89 50 04             	mov    %edx,0x4(%eax)
c01031fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103200:	8b 50 04             	mov    0x4(%eax),%edx
c0103203:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103206:	89 10                	mov    %edx,(%eax)
c0103208:	c7 45 dc b0 89 11 c0 	movl   $0xc01189b0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010320f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103212:	8b 40 04             	mov    0x4(%eax),%eax
c0103215:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103218:	0f 94 c0             	sete   %al
c010321b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010321e:	85 c0                	test   %eax,%eax
c0103220:	75 24                	jne    c0103246 <basic_check+0x26f>
c0103222:	c7 44 24 0c a7 69 10 	movl   $0xc01069a7,0xc(%esp)
c0103229:	c0 
c010322a:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103231:	c0 
c0103232:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103239:	00 
c010323a:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103241:	e8 6c da ff ff       	call   c0100cb2 <__panic>

    unsigned int nr_free_store = nr_free;
c0103246:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c010324b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010324e:	c7 05 b8 89 11 c0 00 	movl   $0x0,0xc01189b8
c0103255:	00 00 00 

    assert(alloc_page() == NULL);
c0103258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010325f:	e8 1d 0c 00 00       	call   c0103e81 <alloc_pages>
c0103264:	85 c0                	test   %eax,%eax
c0103266:	74 24                	je     c010328c <basic_check+0x2b5>
c0103268:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c010326f:	c0 
c0103270:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103277:	c0 
c0103278:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010327f:	00 
c0103280:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103287:	e8 26 da ff ff       	call   c0100cb2 <__panic>

    free_page(p0);
c010328c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103293:	00 
c0103294:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103297:	89 04 24             	mov    %eax,(%esp)
c010329a:	e8 1a 0c 00 00       	call   c0103eb9 <free_pages>
    free_page(p1);
c010329f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032a6:	00 
c01032a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032aa:	89 04 24             	mov    %eax,(%esp)
c01032ad:	e8 07 0c 00 00       	call   c0103eb9 <free_pages>
    free_page(p2);
c01032b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032b9:	00 
c01032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032bd:	89 04 24             	mov    %eax,(%esp)
c01032c0:	e8 f4 0b 00 00       	call   c0103eb9 <free_pages>
    assert(nr_free == 3);
c01032c5:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c01032ca:	83 f8 03             	cmp    $0x3,%eax
c01032cd:	74 24                	je     c01032f3 <basic_check+0x31c>
c01032cf:	c7 44 24 0c d3 69 10 	movl   $0xc01069d3,0xc(%esp)
c01032d6:	c0 
c01032d7:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01032de:	c0 
c01032df:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01032e6:	00 
c01032e7:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01032ee:	e8 bf d9 ff ff       	call   c0100cb2 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01032f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032fa:	e8 82 0b 00 00       	call   c0103e81 <alloc_pages>
c01032ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103302:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103306:	75 24                	jne    c010332c <basic_check+0x355>
c0103308:	c7 44 24 0c 99 68 10 	movl   $0xc0106899,0xc(%esp)
c010330f:	c0 
c0103310:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103317:	c0 
c0103318:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c010331f:	00 
c0103320:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103327:	e8 86 d9 ff ff       	call   c0100cb2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010332c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103333:	e8 49 0b 00 00       	call   c0103e81 <alloc_pages>
c0103338:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010333b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010333f:	75 24                	jne    c0103365 <basic_check+0x38e>
c0103341:	c7 44 24 0c b5 68 10 	movl   $0xc01068b5,0xc(%esp)
c0103348:	c0 
c0103349:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103350:	c0 
c0103351:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103358:	00 
c0103359:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103360:	e8 4d d9 ff ff       	call   c0100cb2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103365:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010336c:	e8 10 0b 00 00       	call   c0103e81 <alloc_pages>
c0103371:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103378:	75 24                	jne    c010339e <basic_check+0x3c7>
c010337a:	c7 44 24 0c d1 68 10 	movl   $0xc01068d1,0xc(%esp)
c0103381:	c0 
c0103382:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103389:	c0 
c010338a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103391:	00 
c0103392:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103399:	e8 14 d9 ff ff       	call   c0100cb2 <__panic>

    assert(alloc_page() == NULL);
c010339e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033a5:	e8 d7 0a 00 00       	call   c0103e81 <alloc_pages>
c01033aa:	85 c0                	test   %eax,%eax
c01033ac:	74 24                	je     c01033d2 <basic_check+0x3fb>
c01033ae:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c01033b5:	c0 
c01033b6:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01033bd:	c0 
c01033be:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01033c5:	00 
c01033c6:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01033cd:	e8 e0 d8 ff ff       	call   c0100cb2 <__panic>

    free_page(p0);
c01033d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033d9:	00 
c01033da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033dd:	89 04 24             	mov    %eax,(%esp)
c01033e0:	e8 d4 0a 00 00       	call   c0103eb9 <free_pages>
c01033e5:	c7 45 d8 b0 89 11 c0 	movl   $0xc01189b0,-0x28(%ebp)
c01033ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033ef:	8b 40 04             	mov    0x4(%eax),%eax
c01033f2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01033f5:	0f 94 c0             	sete   %al
c01033f8:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01033fb:	85 c0                	test   %eax,%eax
c01033fd:	74 24                	je     c0103423 <basic_check+0x44c>
c01033ff:	c7 44 24 0c e0 69 10 	movl   $0xc01069e0,0xc(%esp)
c0103406:	c0 
c0103407:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010340e:	c0 
c010340f:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103416:	00 
c0103417:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010341e:	e8 8f d8 ff ff       	call   c0100cb2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103423:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010342a:	e8 52 0a 00 00       	call   c0103e81 <alloc_pages>
c010342f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103432:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103435:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103438:	74 24                	je     c010345e <basic_check+0x487>
c010343a:	c7 44 24 0c f8 69 10 	movl   $0xc01069f8,0xc(%esp)
c0103441:	c0 
c0103442:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103449:	c0 
c010344a:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0103451:	00 
c0103452:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103459:	e8 54 d8 ff ff       	call   c0100cb2 <__panic>
    assert(alloc_page() == NULL);
c010345e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103465:	e8 17 0a 00 00       	call   c0103e81 <alloc_pages>
c010346a:	85 c0                	test   %eax,%eax
c010346c:	74 24                	je     c0103492 <basic_check+0x4bb>
c010346e:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103475:	c0 
c0103476:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010347d:	c0 
c010347e:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103485:	00 
c0103486:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010348d:	e8 20 d8 ff ff       	call   c0100cb2 <__panic>

    assert(nr_free == 0);
c0103492:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0103497:	85 c0                	test   %eax,%eax
c0103499:	74 24                	je     c01034bf <basic_check+0x4e8>
c010349b:	c7 44 24 0c 11 6a 10 	movl   $0xc0106a11,0xc(%esp)
c01034a2:	c0 
c01034a3:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01034aa:	c0 
c01034ab:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01034b2:	00 
c01034b3:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01034ba:	e8 f3 d7 ff ff       	call   c0100cb2 <__panic>
    free_list = free_list_store;
c01034bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01034c5:	a3 b0 89 11 c0       	mov    %eax,0xc01189b0
c01034ca:	89 15 b4 89 11 c0    	mov    %edx,0xc01189b4
    nr_free = nr_free_store;
c01034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034d3:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    free_page(p);
c01034d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01034df:	00 
c01034e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034e3:	89 04 24             	mov    %eax,(%esp)
c01034e6:	e8 ce 09 00 00       	call   c0103eb9 <free_pages>
    free_page(p1);
c01034eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01034f2:	00 
c01034f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034f6:	89 04 24             	mov    %eax,(%esp)
c01034f9:	e8 bb 09 00 00       	call   c0103eb9 <free_pages>
    free_page(p2);
c01034fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103505:	00 
c0103506:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103509:	89 04 24             	mov    %eax,(%esp)
c010350c:	e8 a8 09 00 00       	call   c0103eb9 <free_pages>
}
c0103511:	c9                   	leave  
c0103512:	c3                   	ret    

c0103513 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103513:	55                   	push   %ebp
c0103514:	89 e5                	mov    %esp,%ebp
c0103516:	53                   	push   %ebx
c0103517:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c010351d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103524:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010352b:	c7 45 ec b0 89 11 c0 	movl   $0xc01189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103532:	eb 6b                	jmp    c010359f <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103534:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103537:	83 e8 0c             	sub    $0xc,%eax
c010353a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010353d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103540:	83 c0 04             	add    $0x4,%eax
c0103543:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010354a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010354d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103550:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103553:	0f a3 10             	bt     %edx,(%eax)
c0103556:	19 c0                	sbb    %eax,%eax
c0103558:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010355b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010355f:	0f 95 c0             	setne  %al
c0103562:	0f b6 c0             	movzbl %al,%eax
c0103565:	85 c0                	test   %eax,%eax
c0103567:	75 24                	jne    c010358d <default_check+0x7a>
c0103569:	c7 44 24 0c 1e 6a 10 	movl   $0xc0106a1e,0xc(%esp)
c0103570:	c0 
c0103571:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103578:	c0 
c0103579:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0103580:	00 
c0103581:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103588:	e8 25 d7 ff ff       	call   c0100cb2 <__panic>
        count ++, total += p->property;
c010358d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103591:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103594:	8b 50 08             	mov    0x8(%eax),%edx
c0103597:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010359a:	01 d0                	add    %edx,%eax
c010359c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010359f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01035a5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035a8:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01035ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01035ae:	81 7d ec b0 89 11 c0 	cmpl   $0xc01189b0,-0x14(%ebp)
c01035b5:	0f 85 79 ff ff ff    	jne    c0103534 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01035bb:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01035be:	e8 28 09 00 00       	call   c0103eeb <nr_free_pages>
c01035c3:	39 c3                	cmp    %eax,%ebx
c01035c5:	74 24                	je     c01035eb <default_check+0xd8>
c01035c7:	c7 44 24 0c 2e 6a 10 	movl   $0xc0106a2e,0xc(%esp)
c01035ce:	c0 
c01035cf:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01035d6:	c0 
c01035d7:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c01035de:	00 
c01035df:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01035e6:	e8 c7 d6 ff ff       	call   c0100cb2 <__panic>

    basic_check();
c01035eb:	e8 e7 f9 ff ff       	call   c0102fd7 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01035f0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01035f7:	e8 85 08 00 00       	call   c0103e81 <alloc_pages>
c01035fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01035ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103603:	75 24                	jne    c0103629 <default_check+0x116>
c0103605:	c7 44 24 0c 47 6a 10 	movl   $0xc0106a47,0xc(%esp)
c010360c:	c0 
c010360d:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103614:	c0 
c0103615:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010361c:	00 
c010361d:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103624:	e8 89 d6 ff ff       	call   c0100cb2 <__panic>
    assert(!PageProperty(p0));
c0103629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010362c:	83 c0 04             	add    $0x4,%eax
c010362f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103636:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103639:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010363c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010363f:	0f a3 10             	bt     %edx,(%eax)
c0103642:	19 c0                	sbb    %eax,%eax
c0103644:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103647:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010364b:	0f 95 c0             	setne  %al
c010364e:	0f b6 c0             	movzbl %al,%eax
c0103651:	85 c0                	test   %eax,%eax
c0103653:	74 24                	je     c0103679 <default_check+0x166>
c0103655:	c7 44 24 0c 52 6a 10 	movl   $0xc0106a52,0xc(%esp)
c010365c:	c0 
c010365d:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103664:	c0 
c0103665:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010366c:	00 
c010366d:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103674:	e8 39 d6 ff ff       	call   c0100cb2 <__panic>

    list_entry_t free_list_store = free_list;
c0103679:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c010367e:	8b 15 b4 89 11 c0    	mov    0xc01189b4,%edx
c0103684:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103687:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010368a:	c7 45 b4 b0 89 11 c0 	movl   $0xc01189b0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103691:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103694:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103697:	89 50 04             	mov    %edx,0x4(%eax)
c010369a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010369d:	8b 50 04             	mov    0x4(%eax),%edx
c01036a0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01036a3:	89 10                	mov    %edx,(%eax)
c01036a5:	c7 45 b0 b0 89 11 c0 	movl   $0xc01189b0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01036ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036af:	8b 40 04             	mov    0x4(%eax),%eax
c01036b2:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01036b5:	0f 94 c0             	sete   %al
c01036b8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01036bb:	85 c0                	test   %eax,%eax
c01036bd:	75 24                	jne    c01036e3 <default_check+0x1d0>
c01036bf:	c7 44 24 0c a7 69 10 	movl   $0xc01069a7,0xc(%esp)
c01036c6:	c0 
c01036c7:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01036ce:	c0 
c01036cf:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01036d6:	00 
c01036d7:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01036de:	e8 cf d5 ff ff       	call   c0100cb2 <__panic>
    assert(alloc_page() == NULL);
c01036e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036ea:	e8 92 07 00 00       	call   c0103e81 <alloc_pages>
c01036ef:	85 c0                	test   %eax,%eax
c01036f1:	74 24                	je     c0103717 <default_check+0x204>
c01036f3:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c01036fa:	c0 
c01036fb:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103702:	c0 
c0103703:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c010370a:	00 
c010370b:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103712:	e8 9b d5 ff ff       	call   c0100cb2 <__panic>

    unsigned int nr_free_store = nr_free;
c0103717:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c010371c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010371f:	c7 05 b8 89 11 c0 00 	movl   $0x0,0xc01189b8
c0103726:	00 00 00 

    free_pages(p0 + 2, 3);
c0103729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010372c:	83 c0 28             	add    $0x28,%eax
c010372f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103736:	00 
c0103737:	89 04 24             	mov    %eax,(%esp)
c010373a:	e8 7a 07 00 00       	call   c0103eb9 <free_pages>
    assert(alloc_pages(4) == NULL);
c010373f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103746:	e8 36 07 00 00       	call   c0103e81 <alloc_pages>
c010374b:	85 c0                	test   %eax,%eax
c010374d:	74 24                	je     c0103773 <default_check+0x260>
c010374f:	c7 44 24 0c 64 6a 10 	movl   $0xc0106a64,0xc(%esp)
c0103756:	c0 
c0103757:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010375e:	c0 
c010375f:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0103766:	00 
c0103767:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010376e:	e8 3f d5 ff ff       	call   c0100cb2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103776:	83 c0 28             	add    $0x28,%eax
c0103779:	83 c0 04             	add    $0x4,%eax
c010377c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103783:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103786:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103789:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010378c:	0f a3 10             	bt     %edx,(%eax)
c010378f:	19 c0                	sbb    %eax,%eax
c0103791:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103794:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103798:	0f 95 c0             	setne  %al
c010379b:	0f b6 c0             	movzbl %al,%eax
c010379e:	85 c0                	test   %eax,%eax
c01037a0:	74 0e                	je     c01037b0 <default_check+0x29d>
c01037a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037a5:	83 c0 28             	add    $0x28,%eax
c01037a8:	8b 40 08             	mov    0x8(%eax),%eax
c01037ab:	83 f8 03             	cmp    $0x3,%eax
c01037ae:	74 24                	je     c01037d4 <default_check+0x2c1>
c01037b0:	c7 44 24 0c 7c 6a 10 	movl   $0xc0106a7c,0xc(%esp)
c01037b7:	c0 
c01037b8:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01037bf:	c0 
c01037c0:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01037c7:	00 
c01037c8:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01037cf:	e8 de d4 ff ff       	call   c0100cb2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01037d4:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01037db:	e8 a1 06 00 00       	call   c0103e81 <alloc_pages>
c01037e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01037e3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01037e7:	75 24                	jne    c010380d <default_check+0x2fa>
c01037e9:	c7 44 24 0c a8 6a 10 	movl   $0xc0106aa8,0xc(%esp)
c01037f0:	c0 
c01037f1:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01037f8:	c0 
c01037f9:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0103800:	00 
c0103801:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103808:	e8 a5 d4 ff ff       	call   c0100cb2 <__panic>
    assert(alloc_page() == NULL);
c010380d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103814:	e8 68 06 00 00       	call   c0103e81 <alloc_pages>
c0103819:	85 c0                	test   %eax,%eax
c010381b:	74 24                	je     c0103841 <default_check+0x32e>
c010381d:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103824:	c0 
c0103825:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010382c:	c0 
c010382d:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0103834:	00 
c0103835:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010383c:	e8 71 d4 ff ff       	call   c0100cb2 <__panic>
    assert(p0 + 2 == p1);
c0103841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103844:	83 c0 28             	add    $0x28,%eax
c0103847:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010384a:	74 24                	je     c0103870 <default_check+0x35d>
c010384c:	c7 44 24 0c c6 6a 10 	movl   $0xc0106ac6,0xc(%esp)
c0103853:	c0 
c0103854:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010385b:	c0 
c010385c:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c0103863:	00 
c0103864:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010386b:	e8 42 d4 ff ff       	call   c0100cb2 <__panic>

    p2 = p0 + 1;
c0103870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103873:	83 c0 14             	add    $0x14,%eax
c0103876:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103879:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103880:	00 
c0103881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103884:	89 04 24             	mov    %eax,(%esp)
c0103887:	e8 2d 06 00 00       	call   c0103eb9 <free_pages>
    free_pages(p1, 3);
c010388c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103893:	00 
c0103894:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103897:	89 04 24             	mov    %eax,(%esp)
c010389a:	e8 1a 06 00 00       	call   c0103eb9 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010389f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038a2:	83 c0 04             	add    $0x4,%eax
c01038a5:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01038ac:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01038af:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01038b2:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01038b5:	0f a3 10             	bt     %edx,(%eax)
c01038b8:	19 c0                	sbb    %eax,%eax
c01038ba:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01038bd:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01038c1:	0f 95 c0             	setne  %al
c01038c4:	0f b6 c0             	movzbl %al,%eax
c01038c7:	85 c0                	test   %eax,%eax
c01038c9:	74 0b                	je     c01038d6 <default_check+0x3c3>
c01038cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038ce:	8b 40 08             	mov    0x8(%eax),%eax
c01038d1:	83 f8 01             	cmp    $0x1,%eax
c01038d4:	74 24                	je     c01038fa <default_check+0x3e7>
c01038d6:	c7 44 24 0c d4 6a 10 	movl   $0xc0106ad4,0xc(%esp)
c01038dd:	c0 
c01038de:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01038e5:	c0 
c01038e6:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01038ed:	00 
c01038ee:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01038f5:	e8 b8 d3 ff ff       	call   c0100cb2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01038fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038fd:	83 c0 04             	add    $0x4,%eax
c0103900:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103907:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010390a:	8b 45 90             	mov    -0x70(%ebp),%eax
c010390d:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103910:	0f a3 10             	bt     %edx,(%eax)
c0103913:	19 c0                	sbb    %eax,%eax
c0103915:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103918:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010391c:	0f 95 c0             	setne  %al
c010391f:	0f b6 c0             	movzbl %al,%eax
c0103922:	85 c0                	test   %eax,%eax
c0103924:	74 0b                	je     c0103931 <default_check+0x41e>
c0103926:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103929:	8b 40 08             	mov    0x8(%eax),%eax
c010392c:	83 f8 03             	cmp    $0x3,%eax
c010392f:	74 24                	je     c0103955 <default_check+0x442>
c0103931:	c7 44 24 0c fc 6a 10 	movl   $0xc0106afc,0xc(%esp)
c0103938:	c0 
c0103939:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103940:	c0 
c0103941:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0103948:	00 
c0103949:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103950:	e8 5d d3 ff ff       	call   c0100cb2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103955:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010395c:	e8 20 05 00 00       	call   c0103e81 <alloc_pages>
c0103961:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103964:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103967:	83 e8 14             	sub    $0x14,%eax
c010396a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010396d:	74 24                	je     c0103993 <default_check+0x480>
c010396f:	c7 44 24 0c 22 6b 10 	movl   $0xc0106b22,0xc(%esp)
c0103976:	c0 
c0103977:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010397e:	c0 
c010397f:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0103986:	00 
c0103987:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010398e:	e8 1f d3 ff ff       	call   c0100cb2 <__panic>
    free_page(p0);
c0103993:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010399a:	00 
c010399b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010399e:	89 04 24             	mov    %eax,(%esp)
c01039a1:	e8 13 05 00 00       	call   c0103eb9 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01039a6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01039ad:	e8 cf 04 00 00       	call   c0103e81 <alloc_pages>
c01039b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01039b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01039b8:	83 c0 14             	add    $0x14,%eax
c01039bb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01039be:	74 24                	je     c01039e4 <default_check+0x4d1>
c01039c0:	c7 44 24 0c 40 6b 10 	movl   $0xc0106b40,0xc(%esp)
c01039c7:	c0 
c01039c8:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01039cf:	c0 
c01039d0:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c01039d7:	00 
c01039d8:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01039df:	e8 ce d2 ff ff       	call   c0100cb2 <__panic>

    free_pages(p0, 2);
c01039e4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01039eb:	00 
c01039ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039ef:	89 04 24             	mov    %eax,(%esp)
c01039f2:	e8 c2 04 00 00       	call   c0103eb9 <free_pages>
    free_page(p2);
c01039f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039fe:	00 
c01039ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a02:	89 04 24             	mov    %eax,(%esp)
c0103a05:	e8 af 04 00 00       	call   c0103eb9 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a0a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a11:	e8 6b 04 00 00       	call   c0103e81 <alloc_pages>
c0103a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103a1d:	75 24                	jne    c0103a43 <default_check+0x530>
c0103a1f:	c7 44 24 0c 60 6b 10 	movl   $0xc0106b60,0xc(%esp)
c0103a26:	c0 
c0103a27:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103a2e:	c0 
c0103a2f:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c0103a36:	00 
c0103a37:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103a3e:	e8 6f d2 ff ff       	call   c0100cb2 <__panic>
    assert(alloc_page() == NULL);
c0103a43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a4a:	e8 32 04 00 00       	call   c0103e81 <alloc_pages>
c0103a4f:	85 c0                	test   %eax,%eax
c0103a51:	74 24                	je     c0103a77 <default_check+0x564>
c0103a53:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103a5a:	c0 
c0103a5b:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103a62:	c0 
c0103a63:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c0103a6a:	00 
c0103a6b:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103a72:	e8 3b d2 ff ff       	call   c0100cb2 <__panic>

    assert(nr_free == 0);
c0103a77:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0103a7c:	85 c0                	test   %eax,%eax
c0103a7e:	74 24                	je     c0103aa4 <default_check+0x591>
c0103a80:	c7 44 24 0c 11 6a 10 	movl   $0xc0106a11,0xc(%esp)
c0103a87:	c0 
c0103a88:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103a8f:	c0 
c0103a90:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0103a97:	00 
c0103a98:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103a9f:	e8 0e d2 ff ff       	call   c0100cb2 <__panic>
    nr_free = nr_free_store;
c0103aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103aa7:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    free_list = free_list_store;
c0103aac:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103aaf:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103ab2:	a3 b0 89 11 c0       	mov    %eax,0xc01189b0
c0103ab7:	89 15 b4 89 11 c0    	mov    %edx,0xc01189b4
    free_pages(p0, 5);
c0103abd:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103ac4:	00 
c0103ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ac8:	89 04 24             	mov    %eax,(%esp)
c0103acb:	e8 e9 03 00 00       	call   c0103eb9 <free_pages>

    le = &free_list;
c0103ad0:	c7 45 ec b0 89 11 c0 	movl   $0xc01189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103ad7:	eb 1d                	jmp    c0103af6 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103adc:	83 e8 0c             	sub    $0xc,%eax
c0103adf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103ae2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103ae6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103ae9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103aec:	8b 40 08             	mov    0x8(%eax),%eax
c0103aef:	29 c2                	sub    %eax,%edx
c0103af1:	89 d0                	mov    %edx,%eax
c0103af3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103af9:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103afc:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103aff:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103b02:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b05:	81 7d ec b0 89 11 c0 	cmpl   $0xc01189b0,-0x14(%ebp)
c0103b0c:	75 cb                	jne    c0103ad9 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b12:	74 24                	je     c0103b38 <default_check+0x625>
c0103b14:	c7 44 24 0c 7e 6b 10 	movl   $0xc0106b7e,0xc(%esp)
c0103b1b:	c0 
c0103b1c:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103b23:	c0 
c0103b24:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
c0103b2b:	00 
c0103b2c:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103b33:	e8 7a d1 ff ff       	call   c0100cb2 <__panic>
    assert(total == 0);
c0103b38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b3c:	74 24                	je     c0103b62 <default_check+0x64f>
c0103b3e:	c7 44 24 0c 89 6b 10 	movl   $0xc0106b89,0xc(%esp)
c0103b45:	c0 
c0103b46:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103b4d:	c0 
c0103b4e:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
c0103b55:	00 
c0103b56:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103b5d:	e8 50 d1 ff ff       	call   c0100cb2 <__panic>
}
c0103b62:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103b68:	5b                   	pop    %ebx
c0103b69:	5d                   	pop    %ebp
c0103b6a:	c3                   	ret    

c0103b6b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103b6b:	55                   	push   %ebp
c0103b6c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103b6e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b71:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0103b76:	29 c2                	sub    %eax,%edx
c0103b78:	89 d0                	mov    %edx,%eax
c0103b7a:	c1 f8 02             	sar    $0x2,%eax
c0103b7d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103b83:	5d                   	pop    %ebp
c0103b84:	c3                   	ret    

c0103b85 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103b85:	55                   	push   %ebp
c0103b86:	89 e5                	mov    %esp,%ebp
c0103b88:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b8e:	89 04 24             	mov    %eax,(%esp)
c0103b91:	e8 d5 ff ff ff       	call   c0103b6b <page2ppn>
c0103b96:	c1 e0 0c             	shl    $0xc,%eax
}
c0103b99:	c9                   	leave  
c0103b9a:	c3                   	ret    

c0103b9b <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103b9b:	55                   	push   %ebp
c0103b9c:	89 e5                	mov    %esp,%ebp
c0103b9e:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103ba1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba4:	c1 e8 0c             	shr    $0xc,%eax
c0103ba7:	89 c2                	mov    %eax,%edx
c0103ba9:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103bae:	39 c2                	cmp    %eax,%edx
c0103bb0:	72 1c                	jb     c0103bce <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103bb2:	c7 44 24 08 c4 6b 10 	movl   $0xc0106bc4,0x8(%esp)
c0103bb9:	c0 
c0103bba:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103bc1:	00 
c0103bc2:	c7 04 24 e3 6b 10 c0 	movl   $0xc0106be3,(%esp)
c0103bc9:	e8 e4 d0 ff ff       	call   c0100cb2 <__panic>
    }
    return &pages[PPN(pa)];
c0103bce:	8b 0d c4 89 11 c0    	mov    0xc01189c4,%ecx
c0103bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd7:	c1 e8 0c             	shr    $0xc,%eax
c0103bda:	89 c2                	mov    %eax,%edx
c0103bdc:	89 d0                	mov    %edx,%eax
c0103bde:	c1 e0 02             	shl    $0x2,%eax
c0103be1:	01 d0                	add    %edx,%eax
c0103be3:	c1 e0 02             	shl    $0x2,%eax
c0103be6:	01 c8                	add    %ecx,%eax
}
c0103be8:	c9                   	leave  
c0103be9:	c3                   	ret    

c0103bea <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103bea:	55                   	push   %ebp
c0103beb:	89 e5                	mov    %esp,%ebp
c0103bed:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bf3:	89 04 24             	mov    %eax,(%esp)
c0103bf6:	e8 8a ff ff ff       	call   c0103b85 <page2pa>
c0103bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c01:	c1 e8 0c             	shr    $0xc,%eax
c0103c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c07:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103c0c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103c0f:	72 23                	jb     c0103c34 <page2kva+0x4a>
c0103c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c14:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c18:	c7 44 24 08 f4 6b 10 	movl   $0xc0106bf4,0x8(%esp)
c0103c1f:	c0 
c0103c20:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103c27:	00 
c0103c28:	c7 04 24 e3 6b 10 c0 	movl   $0xc0106be3,(%esp)
c0103c2f:	e8 7e d0 ff ff       	call   c0100cb2 <__panic>
c0103c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c37:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103c3c:	c9                   	leave  
c0103c3d:	c3                   	ret    

c0103c3e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103c3e:	55                   	push   %ebp
c0103c3f:	89 e5                	mov    %esp,%ebp
c0103c41:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c47:	83 e0 01             	and    $0x1,%eax
c0103c4a:	85 c0                	test   %eax,%eax
c0103c4c:	75 1c                	jne    c0103c6a <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103c4e:	c7 44 24 08 18 6c 10 	movl   $0xc0106c18,0x8(%esp)
c0103c55:	c0 
c0103c56:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103c5d:	00 
c0103c5e:	c7 04 24 e3 6b 10 c0 	movl   $0xc0106be3,(%esp)
c0103c65:	e8 48 d0 ff ff       	call   c0100cb2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103c6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c72:	89 04 24             	mov    %eax,(%esp)
c0103c75:	e8 21 ff ff ff       	call   c0103b9b <pa2page>
}
c0103c7a:	c9                   	leave  
c0103c7b:	c3                   	ret    

c0103c7c <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103c7c:	55                   	push   %ebp
c0103c7d:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103c7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c82:	8b 00                	mov    (%eax),%eax
}
c0103c84:	5d                   	pop    %ebp
c0103c85:	c3                   	ret    

c0103c86 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103c86:	55                   	push   %ebp
c0103c87:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103c89:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c8f:	89 10                	mov    %edx,(%eax)
}
c0103c91:	5d                   	pop    %ebp
c0103c92:	c3                   	ret    

c0103c93 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103c93:	55                   	push   %ebp
c0103c94:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103c96:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c99:	8b 00                	mov    (%eax),%eax
c0103c9b:	8d 50 01             	lea    0x1(%eax),%edx
c0103c9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ca1:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ca3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ca6:	8b 00                	mov    (%eax),%eax
}
c0103ca8:	5d                   	pop    %ebp
c0103ca9:	c3                   	ret    

c0103caa <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103caa:	55                   	push   %ebp
c0103cab:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103cad:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cb0:	8b 00                	mov    (%eax),%eax
c0103cb2:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cb8:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103cba:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cbd:	8b 00                	mov    (%eax),%eax
}
c0103cbf:	5d                   	pop    %ebp
c0103cc0:	c3                   	ret    

c0103cc1 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103cc1:	55                   	push   %ebp
c0103cc2:	89 e5                	mov    %esp,%ebp
c0103cc4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103cc7:	9c                   	pushf  
c0103cc8:	58                   	pop    %eax
c0103cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103ccf:	25 00 02 00 00       	and    $0x200,%eax
c0103cd4:	85 c0                	test   %eax,%eax
c0103cd6:	74 0c                	je     c0103ce4 <__intr_save+0x23>
        intr_disable();
c0103cd8:	e8 b8 d9 ff ff       	call   c0101695 <intr_disable>
        return 1;
c0103cdd:	b8 01 00 00 00       	mov    $0x1,%eax
c0103ce2:	eb 05                	jmp    c0103ce9 <__intr_save+0x28>
    }
    return 0;
c0103ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103ce9:	c9                   	leave  
c0103cea:	c3                   	ret    

c0103ceb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103ceb:	55                   	push   %ebp
c0103cec:	89 e5                	mov    %esp,%ebp
c0103cee:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103cf1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103cf5:	74 05                	je     c0103cfc <__intr_restore+0x11>
        intr_enable();
c0103cf7:	e8 93 d9 ff ff       	call   c010168f <intr_enable>
    }
}
c0103cfc:	c9                   	leave  
c0103cfd:	c3                   	ret    

c0103cfe <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103cfe:	55                   	push   %ebp
c0103cff:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d04:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103d07:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d0c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103d0e:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d13:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103d15:	b8 10 00 00 00       	mov    $0x10,%eax
c0103d1a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103d1c:	b8 10 00 00 00       	mov    $0x10,%eax
c0103d21:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103d23:	b8 10 00 00 00       	mov    $0x10,%eax
c0103d28:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103d2a:	ea 31 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103d31
}
c0103d31:	5d                   	pop    %ebp
c0103d32:	c3                   	ret    

c0103d33 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103d33:	55                   	push   %ebp
c0103d34:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d39:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103d3e:	5d                   	pop    %ebp
c0103d3f:	c3                   	ret    

c0103d40 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103d40:	55                   	push   %ebp
c0103d41:	89 e5                	mov    %esp,%ebp
c0103d43:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103d46:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103d4b:	89 04 24             	mov    %eax,(%esp)
c0103d4e:	e8 e0 ff ff ff       	call   c0103d33 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103d53:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103d5a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103d5c:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103d63:	68 00 
c0103d65:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103d6a:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103d70:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103d75:	c1 e8 10             	shr    $0x10,%eax
c0103d78:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103d7d:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103d84:	83 e0 f0             	and    $0xfffffff0,%eax
c0103d87:	83 c8 09             	or     $0x9,%eax
c0103d8a:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103d8f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103d96:	83 e0 ef             	and    $0xffffffef,%eax
c0103d99:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103d9e:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103da5:	83 e0 9f             	and    $0xffffff9f,%eax
c0103da8:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103dad:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103db4:	83 c8 80             	or     $0xffffff80,%eax
c0103db7:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103dbc:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103dc3:	83 e0 f0             	and    $0xfffffff0,%eax
c0103dc6:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103dcb:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103dd2:	83 e0 ef             	and    $0xffffffef,%eax
c0103dd5:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103dda:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103de1:	83 e0 df             	and    $0xffffffdf,%eax
c0103de4:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103de9:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103df0:	83 c8 40             	or     $0x40,%eax
c0103df3:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103df8:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103dff:	83 e0 7f             	and    $0x7f,%eax
c0103e02:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103e07:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103e0c:	c1 e8 18             	shr    $0x18,%eax
c0103e0f:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103e14:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103e1b:	e8 de fe ff ff       	call   c0103cfe <lgdt>
c0103e20:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103e26:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103e2a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103e2d:	c9                   	leave  
c0103e2e:	c3                   	ret    

c0103e2f <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103e2f:	55                   	push   %ebp
c0103e30:	89 e5                	mov    %esp,%ebp
c0103e32:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103e35:	c7 05 bc 89 11 c0 a8 	movl   $0xc0106ba8,0xc01189bc
c0103e3c:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103e3f:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103e44:	8b 00                	mov    (%eax),%eax
c0103e46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e4a:	c7 04 24 44 6c 10 c0 	movl   $0xc0106c44,(%esp)
c0103e51:	e8 e6 c4 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103e56:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103e5b:	8b 40 04             	mov    0x4(%eax),%eax
c0103e5e:	ff d0                	call   *%eax
}
c0103e60:	c9                   	leave  
c0103e61:	c3                   	ret    

c0103e62 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103e62:	55                   	push   %ebp
c0103e63:	89 e5                	mov    %esp,%ebp
c0103e65:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103e68:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103e6d:	8b 40 08             	mov    0x8(%eax),%eax
c0103e70:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103e73:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e77:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e7a:	89 14 24             	mov    %edx,(%esp)
c0103e7d:	ff d0                	call   *%eax
}
c0103e7f:	c9                   	leave  
c0103e80:	c3                   	ret    

c0103e81 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103e81:	55                   	push   %ebp
c0103e82:	89 e5                	mov    %esp,%ebp
c0103e84:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103e87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e8e:	e8 2e fe ff ff       	call   c0103cc1 <__intr_save>
c0103e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103e96:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103e9b:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e9e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ea1:	89 14 24             	mov    %edx,(%esp)
c0103ea4:	ff d0                	call   *%eax
c0103ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103eac:	89 04 24             	mov    %eax,(%esp)
c0103eaf:	e8 37 fe ff ff       	call   c0103ceb <__intr_restore>
    return page;
c0103eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103eb7:	c9                   	leave  
c0103eb8:	c3                   	ret    

c0103eb9 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103eb9:	55                   	push   %ebp
c0103eba:	89 e5                	mov    %esp,%ebp
c0103ebc:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ebf:	e8 fd fd ff ff       	call   c0103cc1 <__intr_save>
c0103ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103ec7:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103ecc:	8b 40 10             	mov    0x10(%eax),%eax
c0103ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ed2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ed6:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ed9:	89 14 24             	mov    %edx,(%esp)
c0103edc:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ee1:	89 04 24             	mov    %eax,(%esp)
c0103ee4:	e8 02 fe ff ff       	call   c0103ceb <__intr_restore>
}
c0103ee9:	c9                   	leave  
c0103eea:	c3                   	ret    

c0103eeb <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103eeb:	55                   	push   %ebp
c0103eec:	89 e5                	mov    %esp,%ebp
c0103eee:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ef1:	e8 cb fd ff ff       	call   c0103cc1 <__intr_save>
c0103ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103ef9:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103efe:	8b 40 14             	mov    0x14(%eax),%eax
c0103f01:	ff d0                	call   *%eax
c0103f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f09:	89 04 24             	mov    %eax,(%esp)
c0103f0c:	e8 da fd ff ff       	call   c0103ceb <__intr_restore>
    return ret;
c0103f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103f14:	c9                   	leave  
c0103f15:	c3                   	ret    

c0103f16 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103f16:	55                   	push   %ebp
c0103f17:	89 e5                	mov    %esp,%ebp
c0103f19:	57                   	push   %edi
c0103f1a:	56                   	push   %esi
c0103f1b:	53                   	push   %ebx
c0103f1c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103f22:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103f29:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103f30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103f37:	c7 04 24 5b 6c 10 c0 	movl   $0xc0106c5b,(%esp)
c0103f3e:	e8 f9 c3 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f43:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f4a:	e9 15 01 00 00       	jmp    c0104064 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103f4f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f52:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f55:	89 d0                	mov    %edx,%eax
c0103f57:	c1 e0 02             	shl    $0x2,%eax
c0103f5a:	01 d0                	add    %edx,%eax
c0103f5c:	c1 e0 02             	shl    $0x2,%eax
c0103f5f:	01 c8                	add    %ecx,%eax
c0103f61:	8b 50 08             	mov    0x8(%eax),%edx
c0103f64:	8b 40 04             	mov    0x4(%eax),%eax
c0103f67:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103f6a:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103f6d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f70:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f73:	89 d0                	mov    %edx,%eax
c0103f75:	c1 e0 02             	shl    $0x2,%eax
c0103f78:	01 d0                	add    %edx,%eax
c0103f7a:	c1 e0 02             	shl    $0x2,%eax
c0103f7d:	01 c8                	add    %ecx,%eax
c0103f7f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f82:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f85:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103f88:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103f8b:	01 c8                	add    %ecx,%eax
c0103f8d:	11 da                	adc    %ebx,%edx
c0103f8f:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103f92:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103f95:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f98:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f9b:	89 d0                	mov    %edx,%eax
c0103f9d:	c1 e0 02             	shl    $0x2,%eax
c0103fa0:	01 d0                	add    %edx,%eax
c0103fa2:	c1 e0 02             	shl    $0x2,%eax
c0103fa5:	01 c8                	add    %ecx,%eax
c0103fa7:	83 c0 14             	add    $0x14,%eax
c0103faa:	8b 00                	mov    (%eax),%eax
c0103fac:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103fb2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103fb5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103fb8:	83 c0 ff             	add    $0xffffffff,%eax
c0103fbb:	83 d2 ff             	adc    $0xffffffff,%edx
c0103fbe:	89 c6                	mov    %eax,%esi
c0103fc0:	89 d7                	mov    %edx,%edi
c0103fc2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fc8:	89 d0                	mov    %edx,%eax
c0103fca:	c1 e0 02             	shl    $0x2,%eax
c0103fcd:	01 d0                	add    %edx,%eax
c0103fcf:	c1 e0 02             	shl    $0x2,%eax
c0103fd2:	01 c8                	add    %ecx,%eax
c0103fd4:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103fd7:	8b 58 10             	mov    0x10(%eax),%ebx
c0103fda:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103fe0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103fe4:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103fe8:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103fec:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103fef:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ff2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ff6:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103ffa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103ffe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104002:	c7 04 24 68 6c 10 c0 	movl   $0xc0106c68,(%esp)
c0104009:	e8 2e c3 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010400e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104011:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104014:	89 d0                	mov    %edx,%eax
c0104016:	c1 e0 02             	shl    $0x2,%eax
c0104019:	01 d0                	add    %edx,%eax
c010401b:	c1 e0 02             	shl    $0x2,%eax
c010401e:	01 c8                	add    %ecx,%eax
c0104020:	83 c0 14             	add    $0x14,%eax
c0104023:	8b 00                	mov    (%eax),%eax
c0104025:	83 f8 01             	cmp    $0x1,%eax
c0104028:	75 36                	jne    c0104060 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010402a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010402d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104030:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104033:	77 2b                	ja     c0104060 <page_init+0x14a>
c0104035:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104038:	72 05                	jb     c010403f <page_init+0x129>
c010403a:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010403d:	73 21                	jae    c0104060 <page_init+0x14a>
c010403f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104043:	77 1b                	ja     c0104060 <page_init+0x14a>
c0104045:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104049:	72 09                	jb     c0104054 <page_init+0x13e>
c010404b:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104052:	77 0c                	ja     c0104060 <page_init+0x14a>
                maxpa = end;
c0104054:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104057:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010405a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010405d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104060:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104064:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104067:	8b 00                	mov    (%eax),%eax
c0104069:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010406c:	0f 8f dd fe ff ff    	jg     c0103f4f <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104072:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104076:	72 1d                	jb     c0104095 <page_init+0x17f>
c0104078:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010407c:	77 09                	ja     c0104087 <page_init+0x171>
c010407e:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104085:	76 0e                	jbe    c0104095 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104087:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010408e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104095:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104098:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010409b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010409f:	c1 ea 0c             	shr    $0xc,%edx
c01040a2:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01040a7:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01040ae:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c01040b3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01040b6:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01040b9:	01 d0                	add    %edx,%eax
c01040bb:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01040be:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01040c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01040c6:	f7 75 ac             	divl   -0x54(%ebp)
c01040c9:	89 d0                	mov    %edx,%eax
c01040cb:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01040ce:	29 c2                	sub    %eax,%edx
c01040d0:	89 d0                	mov    %edx,%eax
c01040d2:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4

    for (i = 0; i < npage; i ++) {
c01040d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01040de:	eb 2f                	jmp    c010410f <page_init+0x1f9>
        SetPageReserved(pages + i);
c01040e0:	8b 0d c4 89 11 c0    	mov    0xc01189c4,%ecx
c01040e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040e9:	89 d0                	mov    %edx,%eax
c01040eb:	c1 e0 02             	shl    $0x2,%eax
c01040ee:	01 d0                	add    %edx,%eax
c01040f0:	c1 e0 02             	shl    $0x2,%eax
c01040f3:	01 c8                	add    %ecx,%eax
c01040f5:	83 c0 04             	add    $0x4,%eax
c01040f8:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01040ff:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104102:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104105:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104108:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c010410b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010410f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104112:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104117:	39 c2                	cmp    %eax,%edx
c0104119:	72 c5                	jb     c01040e0 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010411b:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0104121:	89 d0                	mov    %edx,%eax
c0104123:	c1 e0 02             	shl    $0x2,%eax
c0104126:	01 d0                	add    %edx,%eax
c0104128:	c1 e0 02             	shl    $0x2,%eax
c010412b:	89 c2                	mov    %eax,%edx
c010412d:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0104132:	01 d0                	add    %edx,%eax
c0104134:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104137:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010413e:	77 23                	ja     c0104163 <page_init+0x24d>
c0104140:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104143:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104147:	c7 44 24 08 98 6c 10 	movl   $0xc0106c98,0x8(%esp)
c010414e:	c0 
c010414f:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104156:	00 
c0104157:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c010415e:	e8 4f cb ff ff       	call   c0100cb2 <__panic>
c0104163:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104166:	05 00 00 00 40       	add    $0x40000000,%eax
c010416b:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010416e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104175:	e9 74 01 00 00       	jmp    c01042ee <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010417a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010417d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104180:	89 d0                	mov    %edx,%eax
c0104182:	c1 e0 02             	shl    $0x2,%eax
c0104185:	01 d0                	add    %edx,%eax
c0104187:	c1 e0 02             	shl    $0x2,%eax
c010418a:	01 c8                	add    %ecx,%eax
c010418c:	8b 50 08             	mov    0x8(%eax),%edx
c010418f:	8b 40 04             	mov    0x4(%eax),%eax
c0104192:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104195:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104198:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010419b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010419e:	89 d0                	mov    %edx,%eax
c01041a0:	c1 e0 02             	shl    $0x2,%eax
c01041a3:	01 d0                	add    %edx,%eax
c01041a5:	c1 e0 02             	shl    $0x2,%eax
c01041a8:	01 c8                	add    %ecx,%eax
c01041aa:	8b 48 0c             	mov    0xc(%eax),%ecx
c01041ad:	8b 58 10             	mov    0x10(%eax),%ebx
c01041b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041b6:	01 c8                	add    %ecx,%eax
c01041b8:	11 da                	adc    %ebx,%edx
c01041ba:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01041bd:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01041c0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01041c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041c6:	89 d0                	mov    %edx,%eax
c01041c8:	c1 e0 02             	shl    $0x2,%eax
c01041cb:	01 d0                	add    %edx,%eax
c01041cd:	c1 e0 02             	shl    $0x2,%eax
c01041d0:	01 c8                	add    %ecx,%eax
c01041d2:	83 c0 14             	add    $0x14,%eax
c01041d5:	8b 00                	mov    (%eax),%eax
c01041d7:	83 f8 01             	cmp    $0x1,%eax
c01041da:	0f 85 0a 01 00 00    	jne    c01042ea <page_init+0x3d4>
            if (begin < freemem) {
c01041e0:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01041e3:	ba 00 00 00 00       	mov    $0x0,%edx
c01041e8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01041eb:	72 17                	jb     c0104204 <page_init+0x2ee>
c01041ed:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01041f0:	77 05                	ja     c01041f7 <page_init+0x2e1>
c01041f2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01041f5:	76 0d                	jbe    c0104204 <page_init+0x2ee>
                begin = freemem;
c01041f7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01041fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01041fd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104204:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104208:	72 1d                	jb     c0104227 <page_init+0x311>
c010420a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010420e:	77 09                	ja     c0104219 <page_init+0x303>
c0104210:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104217:	76 0e                	jbe    c0104227 <page_init+0x311>
                end = KMEMSIZE;
c0104219:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104220:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104227:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010422a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010422d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104230:	0f 87 b4 00 00 00    	ja     c01042ea <page_init+0x3d4>
c0104236:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104239:	72 09                	jb     c0104244 <page_init+0x32e>
c010423b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010423e:	0f 83 a6 00 00 00    	jae    c01042ea <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104244:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010424b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010424e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104251:	01 d0                	add    %edx,%eax
c0104253:	83 e8 01             	sub    $0x1,%eax
c0104256:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104259:	8b 45 98             	mov    -0x68(%ebp),%eax
c010425c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104261:	f7 75 9c             	divl   -0x64(%ebp)
c0104264:	89 d0                	mov    %edx,%eax
c0104266:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104269:	29 c2                	sub    %eax,%edx
c010426b:	89 d0                	mov    %edx,%eax
c010426d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104272:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104275:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104278:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010427b:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010427e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104281:	ba 00 00 00 00       	mov    $0x0,%edx
c0104286:	89 c7                	mov    %eax,%edi
c0104288:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010428e:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104291:	89 d0                	mov    %edx,%eax
c0104293:	83 e0 00             	and    $0x0,%eax
c0104296:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104299:	8b 45 80             	mov    -0x80(%ebp),%eax
c010429c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010429f:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01042a2:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01042a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042ab:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01042ae:	77 3a                	ja     c01042ea <page_init+0x3d4>
c01042b0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01042b3:	72 05                	jb     c01042ba <page_init+0x3a4>
c01042b5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01042b8:	73 30                	jae    c01042ea <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01042ba:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01042bd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01042c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01042c3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01042c6:	29 c8                	sub    %ecx,%eax
c01042c8:	19 da                	sbb    %ebx,%edx
c01042ca:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01042ce:	c1 ea 0c             	shr    $0xc,%edx
c01042d1:	89 c3                	mov    %eax,%ebx
c01042d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042d6:	89 04 24             	mov    %eax,(%esp)
c01042d9:	e8 bd f8 ff ff       	call   c0103b9b <pa2page>
c01042de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01042e2:	89 04 24             	mov    %eax,(%esp)
c01042e5:	e8 78 fb ff ff       	call   c0103e62 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01042ea:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01042ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01042f1:	8b 00                	mov    (%eax),%eax
c01042f3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01042f6:	0f 8f 7e fe ff ff    	jg     c010417a <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01042fc:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104302:	5b                   	pop    %ebx
c0104303:	5e                   	pop    %esi
c0104304:	5f                   	pop    %edi
c0104305:	5d                   	pop    %ebp
c0104306:	c3                   	ret    

c0104307 <enable_paging>:

static void
enable_paging(void) {
c0104307:	55                   	push   %ebp
c0104308:	89 e5                	mov    %esp,%ebp
c010430a:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010430d:	a1 c0 89 11 c0       	mov    0xc01189c0,%eax
c0104312:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104315:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104318:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010431b:	0f 20 c0             	mov    %cr0,%eax
c010431e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104321:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104324:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104327:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010432e:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104332:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104335:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104338:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010433b:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010433e:	c9                   	leave  
c010433f:	c3                   	ret    

c0104340 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104340:	55                   	push   %ebp
c0104341:	89 e5                	mov    %esp,%ebp
c0104343:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104346:	8b 45 14             	mov    0x14(%ebp),%eax
c0104349:	8b 55 0c             	mov    0xc(%ebp),%edx
c010434c:	31 d0                	xor    %edx,%eax
c010434e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104353:	85 c0                	test   %eax,%eax
c0104355:	74 24                	je     c010437b <boot_map_segment+0x3b>
c0104357:	c7 44 24 0c ca 6c 10 	movl   $0xc0106cca,0xc(%esp)
c010435e:	c0 
c010435f:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104366:	c0 
c0104367:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010436e:	00 
c010436f:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104376:	e8 37 c9 ff ff       	call   c0100cb2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010437b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104382:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104385:	25 ff 0f 00 00       	and    $0xfff,%eax
c010438a:	89 c2                	mov    %eax,%edx
c010438c:	8b 45 10             	mov    0x10(%ebp),%eax
c010438f:	01 c2                	add    %eax,%edx
c0104391:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104394:	01 d0                	add    %edx,%eax
c0104396:	83 e8 01             	sub    $0x1,%eax
c0104399:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010439c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010439f:	ba 00 00 00 00       	mov    $0x0,%edx
c01043a4:	f7 75 f0             	divl   -0x10(%ebp)
c01043a7:	89 d0                	mov    %edx,%eax
c01043a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01043ac:	29 c2                	sub    %eax,%edx
c01043ae:	89 d0                	mov    %edx,%eax
c01043b0:	c1 e8 0c             	shr    $0xc,%eax
c01043b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01043b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01043bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043c4:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01043c7:	8b 45 14             	mov    0x14(%ebp),%eax
c01043ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043d5:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01043d8:	eb 6b                	jmp    c0104445 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01043da:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01043e1:	00 
c01043e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01043e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01043ec:	89 04 24             	mov    %eax,(%esp)
c01043ef:	e8 cc 01 00 00       	call   c01045c0 <get_pte>
c01043f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01043f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01043fb:	75 24                	jne    c0104421 <boot_map_segment+0xe1>
c01043fd:	c7 44 24 0c f6 6c 10 	movl   $0xc0106cf6,0xc(%esp)
c0104404:	c0 
c0104405:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c010440c:	c0 
c010440d:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104414:	00 
c0104415:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c010441c:	e8 91 c8 ff ff       	call   c0100cb2 <__panic>
        *ptep = pa | PTE_P | perm;
c0104421:	8b 45 18             	mov    0x18(%ebp),%eax
c0104424:	8b 55 14             	mov    0x14(%ebp),%edx
c0104427:	09 d0                	or     %edx,%eax
c0104429:	83 c8 01             	or     $0x1,%eax
c010442c:	89 c2                	mov    %eax,%edx
c010442e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104431:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104433:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104437:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010443e:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104445:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104449:	75 8f                	jne    c01043da <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010444b:	c9                   	leave  
c010444c:	c3                   	ret    

c010444d <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010444d:	55                   	push   %ebp
c010444e:	89 e5                	mov    %esp,%ebp
c0104450:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104453:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010445a:	e8 22 fa ff ff       	call   c0103e81 <alloc_pages>
c010445f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104466:	75 1c                	jne    c0104484 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104468:	c7 44 24 08 03 6d 10 	movl   $0xc0106d03,0x8(%esp)
c010446f:	c0 
c0104470:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104477:	00 
c0104478:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c010447f:	e8 2e c8 ff ff       	call   c0100cb2 <__panic>
    }
    return page2kva(p);
c0104484:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104487:	89 04 24             	mov    %eax,(%esp)
c010448a:	e8 5b f7 ff ff       	call   c0103bea <page2kva>
}
c010448f:	c9                   	leave  
c0104490:	c3                   	ret    

c0104491 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104491:	55                   	push   %ebp
c0104492:	89 e5                	mov    %esp,%ebp
c0104494:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104497:	e8 93 f9 ff ff       	call   c0103e2f <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010449c:	e8 75 fa ff ff       	call   c0103f16 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01044a1:	e8 66 04 00 00       	call   c010490c <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01044a6:	e8 a2 ff ff ff       	call   c010444d <boot_alloc_page>
c01044ab:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01044b0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01044b5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01044bc:	00 
c01044bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044c4:	00 
c01044c5:	89 04 24             	mov    %eax,(%esp)
c01044c8:	e8 a8 1a 00 00       	call   c0105f75 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01044cd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01044d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044d5:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01044dc:	77 23                	ja     c0104501 <pmm_init+0x70>
c01044de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044e5:	c7 44 24 08 98 6c 10 	movl   $0xc0106c98,0x8(%esp)
c01044ec:	c0 
c01044ed:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01044f4:	00 
c01044f5:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c01044fc:	e8 b1 c7 ff ff       	call   c0100cb2 <__panic>
c0104501:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104504:	05 00 00 00 40       	add    $0x40000000,%eax
c0104509:	a3 c0 89 11 c0       	mov    %eax,0xc01189c0

    check_pgdir();
c010450e:	e8 17 04 00 00       	call   c010492a <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104513:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104518:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010451e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104523:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104526:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010452d:	77 23                	ja     c0104552 <pmm_init+0xc1>
c010452f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104532:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104536:	c7 44 24 08 98 6c 10 	movl   $0xc0106c98,0x8(%esp)
c010453d:	c0 
c010453e:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104545:	00 
c0104546:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c010454d:	e8 60 c7 ff ff       	call   c0100cb2 <__panic>
c0104552:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104555:	05 00 00 00 40       	add    $0x40000000,%eax
c010455a:	83 c8 03             	or     $0x3,%eax
c010455d:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010455f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104564:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010456b:	00 
c010456c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104573:	00 
c0104574:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010457b:	38 
c010457c:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104583:	c0 
c0104584:	89 04 24             	mov    %eax,(%esp)
c0104587:	e8 b4 fd ff ff       	call   c0104340 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010458c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104591:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104597:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010459d:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010459f:	e8 63 fd ff ff       	call   c0104307 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01045a4:	e8 97 f7 ff ff       	call   c0103d40 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01045a9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01045ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01045b4:	e8 0c 0a 00 00       	call   c0104fc5 <check_boot_pgdir>

    print_pgdir();
c01045b9:	e8 99 0e 00 00       	call   c0105457 <print_pgdir>

}
c01045be:	c9                   	leave  
c01045bf:	c3                   	ret    

c01045c0 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01045c0:	55                   	push   %ebp
c01045c1:	89 e5                	mov    %esp,%ebp
c01045c3:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
	pde_t *pdep = &pgdir[PDX(la)];
c01045c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045c9:	c1 e8 16             	shr    $0x16,%eax
c01045cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01045d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d6:	01 d0                	add    %edx,%eax
c01045d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //使用PDX，获取一级页表的位置，如果成功，直接返回
    if (!(*pdep & PTE_P)) {//如果失败
c01045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045de:	8b 00                	mov    (%eax),%eax
c01045e0:	83 e0 01             	and    $0x1,%eax
c01045e3:	85 c0                	test   %eax,%eax
c01045e5:	0f 85 af 00 00 00    	jne    c010469a <get_pte+0xda>
        struct Page *page;
        //根据create位判断是否创建这个二级页表
        //如果为0，不创建，不为0则创建
        if (!create || (page = alloc_page()) == NULL) {
c01045eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01045ef:	74 15                	je     c0104606 <get_pte+0x46>
c01045f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01045f8:	e8 84 f8 ff ff       	call   c0103e81 <alloc_pages>
c01045fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104600:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104604:	75 0a                	jne    c0104610 <get_pte+0x50>
            return NULL;
c0104606:	b8 00 00 00 00       	mov    $0x0,%eax
c010460b:	e9 e6 00 00 00       	jmp    c01046f6 <get_pte+0x136>
        }
        set_page_ref(page, 1);//要查找该页表，则引用次数+1
c0104610:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104617:	00 
c0104618:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010461b:	89 04 24             	mov    %eax,(%esp)
c010461e:	e8 63 f6 ff ff       	call   c0103c86 <set_page_ref>
        uintptr_t pa = page2pa(page);//得到该页的物理地址
c0104623:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104626:	89 04 24             	mov    %eax,(%esp)
c0104629:	e8 57 f5 ff ff       	call   c0103b85 <page2pa>
c010462e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);//转成虚拟地址并初始化
c0104631:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104634:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104637:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010463a:	c1 e8 0c             	shr    $0xc,%eax
c010463d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104640:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104645:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104648:	72 23                	jb     c010466d <get_pte+0xad>
c010464a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010464d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104651:	c7 44 24 08 f4 6b 10 	movl   $0xc0106bf4,0x8(%esp)
c0104658:	c0 
c0104659:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c0104660:	00 
c0104661:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104668:	e8 45 c6 ff ff       	call   c0100cb2 <__panic>
c010466d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104670:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104675:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010467c:	00 
c010467d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104684:	00 
c0104685:	89 04 24             	mov    %eax,(%esp)
c0104688:	e8 e8 18 00 00       	call   c0105f75 <memset>
        //因为这个页所代表的虚拟地址都没有被映射
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c010468d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104690:	83 c8 07             	or     $0x7,%eax
c0104693:	89 c2                	mov    %eax,%edx
c0104695:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104698:	89 10                	mov    %edx,(%eax)
        //设置控制位，同时设置PTE_U,PTE_W和PTE_P
    }
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010469d:	8b 00                	mov    (%eax),%eax
c010469f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01046a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046aa:	c1 e8 0c             	shr    $0xc,%eax
c01046ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01046b0:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046b5:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01046b8:	72 23                	jb     c01046dd <get_pte+0x11d>
c01046ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046c1:	c7 44 24 08 f4 6b 10 	movl   $0xc0106bf4,0x8(%esp)
c01046c8:	c0 
c01046c9:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
c01046d0:	00 
c01046d1:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c01046d8:	e8 d5 c5 ff ff       	call   c0100cb2 <__panic>
c01046dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046e0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01046e5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046e8:	c1 ea 0c             	shr    $0xc,%edx
c01046eb:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01046f1:	c1 e2 02             	shl    $0x2,%edx
c01046f4:	01 d0                	add    %edx,%eax
	//用KADDR返回二级页表所对应的线性地址
	//这里不是要求物理地址，而是需要找对应的二级页表项，在查询完二级页表之前，都还是在虚拟地址的范围。
}
c01046f6:	c9                   	leave  
c01046f7:	c3                   	ret    

c01046f8 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01046f8:	55                   	push   %ebp
c01046f9:	89 e5                	mov    %esp,%ebp
c01046fb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01046fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104705:	00 
c0104706:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104709:	89 44 24 04          	mov    %eax,0x4(%esp)
c010470d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104710:	89 04 24             	mov    %eax,(%esp)
c0104713:	e8 a8 fe ff ff       	call   c01045c0 <get_pte>
c0104718:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010471b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010471f:	74 08                	je     c0104729 <get_page+0x31>
        *ptep_store = ptep;
c0104721:	8b 45 10             	mov    0x10(%ebp),%eax
c0104724:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104727:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010472d:	74 1b                	je     c010474a <get_page+0x52>
c010472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104732:	8b 00                	mov    (%eax),%eax
c0104734:	83 e0 01             	and    $0x1,%eax
c0104737:	85 c0                	test   %eax,%eax
c0104739:	74 0f                	je     c010474a <get_page+0x52>
        return pa2page(*ptep);
c010473b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010473e:	8b 00                	mov    (%eax),%eax
c0104740:	89 04 24             	mov    %eax,(%esp)
c0104743:	e8 53 f4 ff ff       	call   c0103b9b <pa2page>
c0104748:	eb 05                	jmp    c010474f <get_page+0x57>
    }
    return NULL;
c010474a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010474f:	c9                   	leave  
c0104750:	c3                   	ret    

c0104751 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104751:	55                   	push   %ebp
c0104752:	89 e5                	mov    %esp,%ebp
c0104754:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
	if (*ptep & PTE_P) {  //PTE_P代表页存在
c0104757:	8b 45 10             	mov    0x10(%ebp),%eax
c010475a:	8b 00                	mov    (%eax),%eax
c010475c:	83 e0 01             	and    $0x1,%eax
c010475f:	85 c0                	test   %eax,%eax
c0104761:	74 4d                	je     c01047b0 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //从ptep值中获取相应的页面
c0104763:	8b 45 10             	mov    0x10(%ebp),%eax
c0104766:	8b 00                	mov    (%eax),%eax
c0104768:	89 04 24             	mov    %eax,(%esp)
c010476b:	e8 ce f4 ff ff       	call   c0103c3e <pte2page>
c0104770:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104776:	89 04 24             	mov    %eax,(%esp)
c0104779:	e8 2c f5 ff ff       	call   c0103caa <page_ref_dec>
c010477e:	85 c0                	test   %eax,%eax
c0104780:	75 13                	jne    c0104795 <page_remove_pte+0x44>
          //如果只被上一级页表引用一次，那么-1后就是0，页和对应的二级页表都能被直接释放
            free_page(page); //释放页
c0104782:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104789:	00 
c010478a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010478d:	89 04 24             	mov    %eax,(%esp)
c0104790:	e8 24 f7 ff ff       	call   c0103eb9 <free_pages>
        }
    		//但如果有更多的页表引用了它，则不能释放这个页，但可以取消对应二级页表的映射。
    		//即把传入的二级页表置为0
        *ptep = 0;
c0104795:	8b 45 10             	mov    0x10(%ebp),%eax
c0104798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la); //当修改的页表目前正在被进程使用时，使之无效
c010479e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a8:	89 04 24             	mov    %eax,(%esp)
c01047ab:	e8 ff 00 00 00       	call   c01048af <tlb_invalidate>
    }
}
c01047b0:	c9                   	leave  
c01047b1:	c3                   	ret    

c01047b2 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01047b2:	55                   	push   %ebp
c01047b3:	89 e5                	mov    %esp,%ebp
c01047b5:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01047b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047bf:	00 
c01047c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01047ca:	89 04 24             	mov    %eax,(%esp)
c01047cd:	e8 ee fd ff ff       	call   c01045c0 <get_pte>
c01047d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01047d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047d9:	74 19                	je     c01047f4 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01047db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047de:	89 44 24 08          	mov    %eax,0x8(%esp)
c01047e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01047ec:	89 04 24             	mov    %eax,(%esp)
c01047ef:	e8 5d ff ff ff       	call   c0104751 <page_remove_pte>
    }
}
c01047f4:	c9                   	leave  
c01047f5:	c3                   	ret    

c01047f6 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01047f6:	55                   	push   %ebp
c01047f7:	89 e5                	mov    %esp,%ebp
c01047f9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01047fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104803:	00 
c0104804:	8b 45 10             	mov    0x10(%ebp),%eax
c0104807:	89 44 24 04          	mov    %eax,0x4(%esp)
c010480b:	8b 45 08             	mov    0x8(%ebp),%eax
c010480e:	89 04 24             	mov    %eax,(%esp)
c0104811:	e8 aa fd ff ff       	call   c01045c0 <get_pte>
c0104816:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010481d:	75 0a                	jne    c0104829 <page_insert+0x33>
        return -E_NO_MEM;
c010481f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104824:	e9 84 00 00 00       	jmp    c01048ad <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104829:	8b 45 0c             	mov    0xc(%ebp),%eax
c010482c:	89 04 24             	mov    %eax,(%esp)
c010482f:	e8 5f f4 ff ff       	call   c0103c93 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104834:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104837:	8b 00                	mov    (%eax),%eax
c0104839:	83 e0 01             	and    $0x1,%eax
c010483c:	85 c0                	test   %eax,%eax
c010483e:	74 3e                	je     c010487e <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104840:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104843:	8b 00                	mov    (%eax),%eax
c0104845:	89 04 24             	mov    %eax,(%esp)
c0104848:	e8 f1 f3 ff ff       	call   c0103c3e <pte2page>
c010484d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104850:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104853:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104856:	75 0d                	jne    c0104865 <page_insert+0x6f>
            page_ref_dec(page);
c0104858:	8b 45 0c             	mov    0xc(%ebp),%eax
c010485b:	89 04 24             	mov    %eax,(%esp)
c010485e:	e8 47 f4 ff ff       	call   c0103caa <page_ref_dec>
c0104863:	eb 19                	jmp    c010487e <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104865:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104868:	89 44 24 08          	mov    %eax,0x8(%esp)
c010486c:	8b 45 10             	mov    0x10(%ebp),%eax
c010486f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104873:	8b 45 08             	mov    0x8(%ebp),%eax
c0104876:	89 04 24             	mov    %eax,(%esp)
c0104879:	e8 d3 fe ff ff       	call   c0104751 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010487e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104881:	89 04 24             	mov    %eax,(%esp)
c0104884:	e8 fc f2 ff ff       	call   c0103b85 <page2pa>
c0104889:	0b 45 14             	or     0x14(%ebp),%eax
c010488c:	83 c8 01             	or     $0x1,%eax
c010488f:	89 c2                	mov    %eax,%edx
c0104891:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104894:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104896:	8b 45 10             	mov    0x10(%ebp),%eax
c0104899:	89 44 24 04          	mov    %eax,0x4(%esp)
c010489d:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a0:	89 04 24             	mov    %eax,(%esp)
c01048a3:	e8 07 00 00 00       	call   c01048af <tlb_invalidate>
    return 0;
c01048a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048ad:	c9                   	leave  
c01048ae:	c3                   	ret    

c01048af <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01048af:	55                   	push   %ebp
c01048b0:	89 e5                	mov    %esp,%ebp
c01048b2:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01048b5:	0f 20 d8             	mov    %cr3,%eax
c01048b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01048bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01048be:	89 c2                	mov    %eax,%edx
c01048c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048c6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01048cd:	77 23                	ja     c01048f2 <tlb_invalidate+0x43>
c01048cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048d6:	c7 44 24 08 98 6c 10 	movl   $0xc0106c98,0x8(%esp)
c01048dd:	c0 
c01048de:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c01048e5:	00 
c01048e6:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c01048ed:	e8 c0 c3 ff ff       	call   c0100cb2 <__panic>
c01048f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048f5:	05 00 00 00 40       	add    $0x40000000,%eax
c01048fa:	39 c2                	cmp    %eax,%edx
c01048fc:	75 0c                	jne    c010490a <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01048fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104901:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104904:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104907:	0f 01 38             	invlpg (%eax)
    }
}
c010490a:	c9                   	leave  
c010490b:	c3                   	ret    

c010490c <check_alloc_page>:

static void
check_alloc_page(void) {
c010490c:	55                   	push   %ebp
c010490d:	89 e5                	mov    %esp,%ebp
c010490f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104912:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0104917:	8b 40 18             	mov    0x18(%eax),%eax
c010491a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010491c:	c7 04 24 1c 6d 10 c0 	movl   $0xc0106d1c,(%esp)
c0104923:	e8 14 ba ff ff       	call   c010033c <cprintf>
}
c0104928:	c9                   	leave  
c0104929:	c3                   	ret    

c010492a <check_pgdir>:

static void
check_pgdir(void) {
c010492a:	55                   	push   %ebp
c010492b:	89 e5                	mov    %esp,%ebp
c010492d:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104930:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104935:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010493a:	76 24                	jbe    c0104960 <check_pgdir+0x36>
c010493c:	c7 44 24 0c 3b 6d 10 	movl   $0xc0106d3b,0xc(%esp)
c0104943:	c0 
c0104944:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c010494b:	c0 
c010494c:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104953:	00 
c0104954:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c010495b:	e8 52 c3 ff ff       	call   c0100cb2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104960:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104965:	85 c0                	test   %eax,%eax
c0104967:	74 0e                	je     c0104977 <check_pgdir+0x4d>
c0104969:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010496e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104973:	85 c0                	test   %eax,%eax
c0104975:	74 24                	je     c010499b <check_pgdir+0x71>
c0104977:	c7 44 24 0c 58 6d 10 	movl   $0xc0106d58,0xc(%esp)
c010497e:	c0 
c010497f:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104986:	c0 
c0104987:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c010498e:	00 
c010498f:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104996:	e8 17 c3 ff ff       	call   c0100cb2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010499b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049a7:	00 
c01049a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049af:	00 
c01049b0:	89 04 24             	mov    %eax,(%esp)
c01049b3:	e8 40 fd ff ff       	call   c01046f8 <get_page>
c01049b8:	85 c0                	test   %eax,%eax
c01049ba:	74 24                	je     c01049e0 <check_pgdir+0xb6>
c01049bc:	c7 44 24 0c 90 6d 10 	movl   $0xc0106d90,0xc(%esp)
c01049c3:	c0 
c01049c4:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c01049cb:	c0 
c01049cc:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c01049d3:	00 
c01049d4:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c01049db:	e8 d2 c2 ff ff       	call   c0100cb2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01049e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049e7:	e8 95 f4 ff ff       	call   c0103e81 <alloc_pages>
c01049ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01049ef:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049f4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01049fb:	00 
c01049fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a03:	00 
c0104a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a07:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a0b:	89 04 24             	mov    %eax,(%esp)
c0104a0e:	e8 e3 fd ff ff       	call   c01047f6 <page_insert>
c0104a13:	85 c0                	test   %eax,%eax
c0104a15:	74 24                	je     c0104a3b <check_pgdir+0x111>
c0104a17:	c7 44 24 0c b8 6d 10 	movl   $0xc0106db8,0xc(%esp)
c0104a1e:	c0 
c0104a1f:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104a26:	c0 
c0104a27:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104a2e:	00 
c0104a2f:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104a36:	e8 77 c2 ff ff       	call   c0100cb2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104a3b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a40:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a47:	00 
c0104a48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a4f:	00 
c0104a50:	89 04 24             	mov    %eax,(%esp)
c0104a53:	e8 68 fb ff ff       	call   c01045c0 <get_pte>
c0104a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a5f:	75 24                	jne    c0104a85 <check_pgdir+0x15b>
c0104a61:	c7 44 24 0c e4 6d 10 	movl   $0xc0106de4,0xc(%esp)
c0104a68:	c0 
c0104a69:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104a70:	c0 
c0104a71:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104a78:	00 
c0104a79:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104a80:	e8 2d c2 ff ff       	call   c0100cb2 <__panic>
    assert(pa2page(*ptep) == p1);
c0104a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a88:	8b 00                	mov    (%eax),%eax
c0104a8a:	89 04 24             	mov    %eax,(%esp)
c0104a8d:	e8 09 f1 ff ff       	call   c0103b9b <pa2page>
c0104a92:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a95:	74 24                	je     c0104abb <check_pgdir+0x191>
c0104a97:	c7 44 24 0c 11 6e 10 	movl   $0xc0106e11,0xc(%esp)
c0104a9e:	c0 
c0104a9f:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104aa6:	c0 
c0104aa7:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104aae:	00 
c0104aaf:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104ab6:	e8 f7 c1 ff ff       	call   c0100cb2 <__panic>
    assert(page_ref(p1) == 1);
c0104abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104abe:	89 04 24             	mov    %eax,(%esp)
c0104ac1:	e8 b6 f1 ff ff       	call   c0103c7c <page_ref>
c0104ac6:	83 f8 01             	cmp    $0x1,%eax
c0104ac9:	74 24                	je     c0104aef <check_pgdir+0x1c5>
c0104acb:	c7 44 24 0c 26 6e 10 	movl   $0xc0106e26,0xc(%esp)
c0104ad2:	c0 
c0104ad3:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104ada:	c0 
c0104adb:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104ae2:	00 
c0104ae3:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104aea:	e8 c3 c1 ff ff       	call   c0100cb2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104aef:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104af4:	8b 00                	mov    (%eax),%eax
c0104af6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104afb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b01:	c1 e8 0c             	shr    $0xc,%eax
c0104b04:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b07:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104b0c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104b0f:	72 23                	jb     c0104b34 <check_pgdir+0x20a>
c0104b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b14:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b18:	c7 44 24 08 f4 6b 10 	movl   $0xc0106bf4,0x8(%esp)
c0104b1f:	c0 
c0104b20:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104b27:	00 
c0104b28:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104b2f:	e8 7e c1 ff ff       	call   c0100cb2 <__panic>
c0104b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b37:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104b3c:	83 c0 04             	add    $0x4,%eax
c0104b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104b42:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b4e:	00 
c0104b4f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b56:	00 
c0104b57:	89 04 24             	mov    %eax,(%esp)
c0104b5a:	e8 61 fa ff ff       	call   c01045c0 <get_pte>
c0104b5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104b62:	74 24                	je     c0104b88 <check_pgdir+0x25e>
c0104b64:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0104b6b:	c0 
c0104b6c:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104b73:	c0 
c0104b74:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104b7b:	00 
c0104b7c:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104b83:	e8 2a c1 ff ff       	call   c0100cb2 <__panic>

    p2 = alloc_page();
c0104b88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b8f:	e8 ed f2 ff ff       	call   c0103e81 <alloc_pages>
c0104b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104b97:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b9c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104ba3:	00 
c0104ba4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104bab:	00 
c0104bac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104baf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bb3:	89 04 24             	mov    %eax,(%esp)
c0104bb6:	e8 3b fc ff ff       	call   c01047f6 <page_insert>
c0104bbb:	85 c0                	test   %eax,%eax
c0104bbd:	74 24                	je     c0104be3 <check_pgdir+0x2b9>
c0104bbf:	c7 44 24 0c 60 6e 10 	movl   $0xc0106e60,0xc(%esp)
c0104bc6:	c0 
c0104bc7:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104bce:	c0 
c0104bcf:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104bd6:	00 
c0104bd7:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104bde:	e8 cf c0 ff ff       	call   c0100cb2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104be3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104be8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104bef:	00 
c0104bf0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104bf7:	00 
c0104bf8:	89 04 24             	mov    %eax,(%esp)
c0104bfb:	e8 c0 f9 ff ff       	call   c01045c0 <get_pte>
c0104c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c07:	75 24                	jne    c0104c2d <check_pgdir+0x303>
c0104c09:	c7 44 24 0c 98 6e 10 	movl   $0xc0106e98,0xc(%esp)
c0104c10:	c0 
c0104c11:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104c18:	c0 
c0104c19:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104c20:	00 
c0104c21:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104c28:	e8 85 c0 ff ff       	call   c0100cb2 <__panic>
    assert(*ptep & PTE_U);
c0104c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c30:	8b 00                	mov    (%eax),%eax
c0104c32:	83 e0 04             	and    $0x4,%eax
c0104c35:	85 c0                	test   %eax,%eax
c0104c37:	75 24                	jne    c0104c5d <check_pgdir+0x333>
c0104c39:	c7 44 24 0c c8 6e 10 	movl   $0xc0106ec8,0xc(%esp)
c0104c40:	c0 
c0104c41:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104c48:	c0 
c0104c49:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104c50:	00 
c0104c51:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104c58:	e8 55 c0 ff ff       	call   c0100cb2 <__panic>
    assert(*ptep & PTE_W);
c0104c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c60:	8b 00                	mov    (%eax),%eax
c0104c62:	83 e0 02             	and    $0x2,%eax
c0104c65:	85 c0                	test   %eax,%eax
c0104c67:	75 24                	jne    c0104c8d <check_pgdir+0x363>
c0104c69:	c7 44 24 0c d6 6e 10 	movl   $0xc0106ed6,0xc(%esp)
c0104c70:	c0 
c0104c71:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104c78:	c0 
c0104c79:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104c80:	00 
c0104c81:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104c88:	e8 25 c0 ff ff       	call   c0100cb2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104c8d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c92:	8b 00                	mov    (%eax),%eax
c0104c94:	83 e0 04             	and    $0x4,%eax
c0104c97:	85 c0                	test   %eax,%eax
c0104c99:	75 24                	jne    c0104cbf <check_pgdir+0x395>
c0104c9b:	c7 44 24 0c e4 6e 10 	movl   $0xc0106ee4,0xc(%esp)
c0104ca2:	c0 
c0104ca3:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104caa:	c0 
c0104cab:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104cb2:	00 
c0104cb3:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104cba:	e8 f3 bf ff ff       	call   c0100cb2 <__panic>
    assert(page_ref(p2) == 1);
c0104cbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cc2:	89 04 24             	mov    %eax,(%esp)
c0104cc5:	e8 b2 ef ff ff       	call   c0103c7c <page_ref>
c0104cca:	83 f8 01             	cmp    $0x1,%eax
c0104ccd:	74 24                	je     c0104cf3 <check_pgdir+0x3c9>
c0104ccf:	c7 44 24 0c fa 6e 10 	movl   $0xc0106efa,0xc(%esp)
c0104cd6:	c0 
c0104cd7:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104cde:	c0 
c0104cdf:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104ce6:	00 
c0104ce7:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104cee:	e8 bf bf ff ff       	call   c0100cb2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104cf3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cf8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104cff:	00 
c0104d00:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d07:	00 
c0104d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d0b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d0f:	89 04 24             	mov    %eax,(%esp)
c0104d12:	e8 df fa ff ff       	call   c01047f6 <page_insert>
c0104d17:	85 c0                	test   %eax,%eax
c0104d19:	74 24                	je     c0104d3f <check_pgdir+0x415>
c0104d1b:	c7 44 24 0c 0c 6f 10 	movl   $0xc0106f0c,0xc(%esp)
c0104d22:	c0 
c0104d23:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104d2a:	c0 
c0104d2b:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104d32:	00 
c0104d33:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104d3a:	e8 73 bf ff ff       	call   c0100cb2 <__panic>
    assert(page_ref(p1) == 2);
c0104d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d42:	89 04 24             	mov    %eax,(%esp)
c0104d45:	e8 32 ef ff ff       	call   c0103c7c <page_ref>
c0104d4a:	83 f8 02             	cmp    $0x2,%eax
c0104d4d:	74 24                	je     c0104d73 <check_pgdir+0x449>
c0104d4f:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c0104d56:	c0 
c0104d57:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104d5e:	c0 
c0104d5f:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104d66:	00 
c0104d67:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104d6e:	e8 3f bf ff ff       	call   c0100cb2 <__panic>
    assert(page_ref(p2) == 0);
c0104d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d76:	89 04 24             	mov    %eax,(%esp)
c0104d79:	e8 fe ee ff ff       	call   c0103c7c <page_ref>
c0104d7e:	85 c0                	test   %eax,%eax
c0104d80:	74 24                	je     c0104da6 <check_pgdir+0x47c>
c0104d82:	c7 44 24 0c 4a 6f 10 	movl   $0xc0106f4a,0xc(%esp)
c0104d89:	c0 
c0104d8a:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104d91:	c0 
c0104d92:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104d99:	00 
c0104d9a:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104da1:	e8 0c bf ff ff       	call   c0100cb2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104da6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104db2:	00 
c0104db3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104dba:	00 
c0104dbb:	89 04 24             	mov    %eax,(%esp)
c0104dbe:	e8 fd f7 ff ff       	call   c01045c0 <get_pte>
c0104dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104dc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104dca:	75 24                	jne    c0104df0 <check_pgdir+0x4c6>
c0104dcc:	c7 44 24 0c 98 6e 10 	movl   $0xc0106e98,0xc(%esp)
c0104dd3:	c0 
c0104dd4:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104ddb:	c0 
c0104ddc:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104de3:	00 
c0104de4:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104deb:	e8 c2 be ff ff       	call   c0100cb2 <__panic>
    assert(pa2page(*ptep) == p1);
c0104df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104df3:	8b 00                	mov    (%eax),%eax
c0104df5:	89 04 24             	mov    %eax,(%esp)
c0104df8:	e8 9e ed ff ff       	call   c0103b9b <pa2page>
c0104dfd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e00:	74 24                	je     c0104e26 <check_pgdir+0x4fc>
c0104e02:	c7 44 24 0c 11 6e 10 	movl   $0xc0106e11,0xc(%esp)
c0104e09:	c0 
c0104e0a:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104e11:	c0 
c0104e12:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104e19:	00 
c0104e1a:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104e21:	e8 8c be ff ff       	call   c0100cb2 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e29:	8b 00                	mov    (%eax),%eax
c0104e2b:	83 e0 04             	and    $0x4,%eax
c0104e2e:	85 c0                	test   %eax,%eax
c0104e30:	74 24                	je     c0104e56 <check_pgdir+0x52c>
c0104e32:	c7 44 24 0c 5c 6f 10 	movl   $0xc0106f5c,0xc(%esp)
c0104e39:	c0 
c0104e3a:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104e41:	c0 
c0104e42:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104e49:	00 
c0104e4a:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104e51:	e8 5c be ff ff       	call   c0100cb2 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104e56:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104e62:	00 
c0104e63:	89 04 24             	mov    %eax,(%esp)
c0104e66:	e8 47 f9 ff ff       	call   c01047b2 <page_remove>
    assert(page_ref(p1) == 1);
c0104e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e6e:	89 04 24             	mov    %eax,(%esp)
c0104e71:	e8 06 ee ff ff       	call   c0103c7c <page_ref>
c0104e76:	83 f8 01             	cmp    $0x1,%eax
c0104e79:	74 24                	je     c0104e9f <check_pgdir+0x575>
c0104e7b:	c7 44 24 0c 26 6e 10 	movl   $0xc0106e26,0xc(%esp)
c0104e82:	c0 
c0104e83:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104e8a:	c0 
c0104e8b:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104e92:	00 
c0104e93:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104e9a:	e8 13 be ff ff       	call   c0100cb2 <__panic>
    assert(page_ref(p2) == 0);
c0104e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ea2:	89 04 24             	mov    %eax,(%esp)
c0104ea5:	e8 d2 ed ff ff       	call   c0103c7c <page_ref>
c0104eaa:	85 c0                	test   %eax,%eax
c0104eac:	74 24                	je     c0104ed2 <check_pgdir+0x5a8>
c0104eae:	c7 44 24 0c 4a 6f 10 	movl   $0xc0106f4a,0xc(%esp)
c0104eb5:	c0 
c0104eb6:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104ebd:	c0 
c0104ebe:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104ec5:	00 
c0104ec6:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104ecd:	e8 e0 bd ff ff       	call   c0100cb2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104ed2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ed7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ede:	00 
c0104edf:	89 04 24             	mov    %eax,(%esp)
c0104ee2:	e8 cb f8 ff ff       	call   c01047b2 <page_remove>
    assert(page_ref(p1) == 0);
c0104ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eea:	89 04 24             	mov    %eax,(%esp)
c0104eed:	e8 8a ed ff ff       	call   c0103c7c <page_ref>
c0104ef2:	85 c0                	test   %eax,%eax
c0104ef4:	74 24                	je     c0104f1a <check_pgdir+0x5f0>
c0104ef6:	c7 44 24 0c 71 6f 10 	movl   $0xc0106f71,0xc(%esp)
c0104efd:	c0 
c0104efe:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104f05:	c0 
c0104f06:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0104f0d:	00 
c0104f0e:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104f15:	e8 98 bd ff ff       	call   c0100cb2 <__panic>
    assert(page_ref(p2) == 0);
c0104f1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f1d:	89 04 24             	mov    %eax,(%esp)
c0104f20:	e8 57 ed ff ff       	call   c0103c7c <page_ref>
c0104f25:	85 c0                	test   %eax,%eax
c0104f27:	74 24                	je     c0104f4d <check_pgdir+0x623>
c0104f29:	c7 44 24 0c 4a 6f 10 	movl   $0xc0106f4a,0xc(%esp)
c0104f30:	c0 
c0104f31:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104f38:	c0 
c0104f39:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0104f40:	00 
c0104f41:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104f48:	e8 65 bd ff ff       	call   c0100cb2 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104f4d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f52:	8b 00                	mov    (%eax),%eax
c0104f54:	89 04 24             	mov    %eax,(%esp)
c0104f57:	e8 3f ec ff ff       	call   c0103b9b <pa2page>
c0104f5c:	89 04 24             	mov    %eax,(%esp)
c0104f5f:	e8 18 ed ff ff       	call   c0103c7c <page_ref>
c0104f64:	83 f8 01             	cmp    $0x1,%eax
c0104f67:	74 24                	je     c0104f8d <check_pgdir+0x663>
c0104f69:	c7 44 24 0c 84 6f 10 	movl   $0xc0106f84,0xc(%esp)
c0104f70:	c0 
c0104f71:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0104f78:	c0 
c0104f79:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104f80:	00 
c0104f81:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0104f88:	e8 25 bd ff ff       	call   c0100cb2 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104f8d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f92:	8b 00                	mov    (%eax),%eax
c0104f94:	89 04 24             	mov    %eax,(%esp)
c0104f97:	e8 ff eb ff ff       	call   c0103b9b <pa2page>
c0104f9c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fa3:	00 
c0104fa4:	89 04 24             	mov    %eax,(%esp)
c0104fa7:	e8 0d ef ff ff       	call   c0103eb9 <free_pages>
    boot_pgdir[0] = 0;
c0104fac:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104fb7:	c7 04 24 aa 6f 10 c0 	movl   $0xc0106faa,(%esp)
c0104fbe:	e8 79 b3 ff ff       	call   c010033c <cprintf>
}
c0104fc3:	c9                   	leave  
c0104fc4:	c3                   	ret    

c0104fc5 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104fc5:	55                   	push   %ebp
c0104fc6:	89 e5                	mov    %esp,%ebp
c0104fc8:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104fcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104fd2:	e9 ca 00 00 00       	jmp    c01050a1 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fe0:	c1 e8 0c             	shr    $0xc,%eax
c0104fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104fe6:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104feb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104fee:	72 23                	jb     c0105013 <check_boot_pgdir+0x4e>
c0104ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ff3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ff7:	c7 44 24 08 f4 6b 10 	movl   $0xc0106bf4,0x8(%esp)
c0104ffe:	c0 
c0104fff:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105006:	00 
c0105007:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c010500e:	e8 9f bc ff ff       	call   c0100cb2 <__panic>
c0105013:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105016:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010501b:	89 c2                	mov    %eax,%edx
c010501d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105022:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105029:	00 
c010502a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010502e:	89 04 24             	mov    %eax,(%esp)
c0105031:	e8 8a f5 ff ff       	call   c01045c0 <get_pte>
c0105036:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105039:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010503d:	75 24                	jne    c0105063 <check_boot_pgdir+0x9e>
c010503f:	c7 44 24 0c c4 6f 10 	movl   $0xc0106fc4,0xc(%esp)
c0105046:	c0 
c0105047:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c010504e:	c0 
c010504f:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105056:	00 
c0105057:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c010505e:	e8 4f bc ff ff       	call   c0100cb2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105063:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105066:	8b 00                	mov    (%eax),%eax
c0105068:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010506d:	89 c2                	mov    %eax,%edx
c010506f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105072:	39 c2                	cmp    %eax,%edx
c0105074:	74 24                	je     c010509a <check_boot_pgdir+0xd5>
c0105076:	c7 44 24 0c 01 70 10 	movl   $0xc0107001,0xc(%esp)
c010507d:	c0 
c010507e:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0105085:	c0 
c0105086:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c010508d:	00 
c010508e:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0105095:	e8 18 bc ff ff       	call   c0100cb2 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010509a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01050a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050a4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01050a9:	39 c2                	cmp    %eax,%edx
c01050ab:	0f 82 26 ff ff ff    	jb     c0104fd7 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01050b1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050b6:	05 ac 0f 00 00       	add    $0xfac,%eax
c01050bb:	8b 00                	mov    (%eax),%eax
c01050bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050c2:	89 c2                	mov    %eax,%edx
c01050c4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01050cc:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01050d3:	77 23                	ja     c01050f8 <check_boot_pgdir+0x133>
c01050d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050dc:	c7 44 24 08 98 6c 10 	movl   $0xc0106c98,0x8(%esp)
c01050e3:	c0 
c01050e4:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01050eb:	00 
c01050ec:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c01050f3:	e8 ba bb ff ff       	call   c0100cb2 <__panic>
c01050f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050fb:	05 00 00 00 40       	add    $0x40000000,%eax
c0105100:	39 c2                	cmp    %eax,%edx
c0105102:	74 24                	je     c0105128 <check_boot_pgdir+0x163>
c0105104:	c7 44 24 0c 18 70 10 	movl   $0xc0107018,0xc(%esp)
c010510b:	c0 
c010510c:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0105113:	c0 
c0105114:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c010511b:	00 
c010511c:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0105123:	e8 8a bb ff ff       	call   c0100cb2 <__panic>

    assert(boot_pgdir[0] == 0);
c0105128:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010512d:	8b 00                	mov    (%eax),%eax
c010512f:	85 c0                	test   %eax,%eax
c0105131:	74 24                	je     c0105157 <check_boot_pgdir+0x192>
c0105133:	c7 44 24 0c 4c 70 10 	movl   $0xc010704c,0xc(%esp)
c010513a:	c0 
c010513b:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0105142:	c0 
c0105143:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c010514a:	00 
c010514b:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0105152:	e8 5b bb ff ff       	call   c0100cb2 <__panic>

    struct Page *p;
    p = alloc_page();
c0105157:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010515e:	e8 1e ed ff ff       	call   c0103e81 <alloc_pages>
c0105163:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105166:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010516b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105172:	00 
c0105173:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010517a:	00 
c010517b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010517e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105182:	89 04 24             	mov    %eax,(%esp)
c0105185:	e8 6c f6 ff ff       	call   c01047f6 <page_insert>
c010518a:	85 c0                	test   %eax,%eax
c010518c:	74 24                	je     c01051b2 <check_boot_pgdir+0x1ed>
c010518e:	c7 44 24 0c 60 70 10 	movl   $0xc0107060,0xc(%esp)
c0105195:	c0 
c0105196:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c010519d:	c0 
c010519e:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c01051a5:	00 
c01051a6:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c01051ad:	e8 00 bb ff ff       	call   c0100cb2 <__panic>
    assert(page_ref(p) == 1);
c01051b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051b5:	89 04 24             	mov    %eax,(%esp)
c01051b8:	e8 bf ea ff ff       	call   c0103c7c <page_ref>
c01051bd:	83 f8 01             	cmp    $0x1,%eax
c01051c0:	74 24                	je     c01051e6 <check_boot_pgdir+0x221>
c01051c2:	c7 44 24 0c 8e 70 10 	movl   $0xc010708e,0xc(%esp)
c01051c9:	c0 
c01051ca:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c01051d1:	c0 
c01051d2:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c01051d9:	00 
c01051da:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c01051e1:	e8 cc ba ff ff       	call   c0100cb2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01051e6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051eb:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01051f2:	00 
c01051f3:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01051fa:	00 
c01051fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051fe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105202:	89 04 24             	mov    %eax,(%esp)
c0105205:	e8 ec f5 ff ff       	call   c01047f6 <page_insert>
c010520a:	85 c0                	test   %eax,%eax
c010520c:	74 24                	je     c0105232 <check_boot_pgdir+0x26d>
c010520e:	c7 44 24 0c a0 70 10 	movl   $0xc01070a0,0xc(%esp)
c0105215:	c0 
c0105216:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c010521d:	c0 
c010521e:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105225:	00 
c0105226:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c010522d:	e8 80 ba ff ff       	call   c0100cb2 <__panic>
    assert(page_ref(p) == 2);
c0105232:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105235:	89 04 24             	mov    %eax,(%esp)
c0105238:	e8 3f ea ff ff       	call   c0103c7c <page_ref>
c010523d:	83 f8 02             	cmp    $0x2,%eax
c0105240:	74 24                	je     c0105266 <check_boot_pgdir+0x2a1>
c0105242:	c7 44 24 0c d7 70 10 	movl   $0xc01070d7,0xc(%esp)
c0105249:	c0 
c010524a:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c0105251:	c0 
c0105252:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105259:	00 
c010525a:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c0105261:	e8 4c ba ff ff       	call   c0100cb2 <__panic>

    const char *str = "ucore: Hello world!!";
c0105266:	c7 45 dc e8 70 10 c0 	movl   $0xc01070e8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c010526d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105270:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105274:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010527b:	e8 1e 0a 00 00       	call   c0105c9e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105280:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105287:	00 
c0105288:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010528f:	e8 83 0a 00 00       	call   c0105d17 <strcmp>
c0105294:	85 c0                	test   %eax,%eax
c0105296:	74 24                	je     c01052bc <check_boot_pgdir+0x2f7>
c0105298:	c7 44 24 0c 00 71 10 	movl   $0xc0107100,0xc(%esp)
c010529f:	c0 
c01052a0:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c01052a7:	c0 
c01052a8:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c01052af:	00 
c01052b0:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c01052b7:	e8 f6 b9 ff ff       	call   c0100cb2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01052bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052bf:	89 04 24             	mov    %eax,(%esp)
c01052c2:	e8 23 e9 ff ff       	call   c0103bea <page2kva>
c01052c7:	05 00 01 00 00       	add    $0x100,%eax
c01052cc:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01052cf:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052d6:	e8 6b 09 00 00       	call   c0105c46 <strlen>
c01052db:	85 c0                	test   %eax,%eax
c01052dd:	74 24                	je     c0105303 <check_boot_pgdir+0x33e>
c01052df:	c7 44 24 0c 38 71 10 	movl   $0xc0107138,0xc(%esp)
c01052e6:	c0 
c01052e7:	c7 44 24 08 e1 6c 10 	movl   $0xc0106ce1,0x8(%esp)
c01052ee:	c0 
c01052ef:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c01052f6:	00 
c01052f7:	c7 04 24 bc 6c 10 c0 	movl   $0xc0106cbc,(%esp)
c01052fe:	e8 af b9 ff ff       	call   c0100cb2 <__panic>

    free_page(p);
c0105303:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010530a:	00 
c010530b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010530e:	89 04 24             	mov    %eax,(%esp)
c0105311:	e8 a3 eb ff ff       	call   c0103eb9 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105316:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010531b:	8b 00                	mov    (%eax),%eax
c010531d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105322:	89 04 24             	mov    %eax,(%esp)
c0105325:	e8 71 e8 ff ff       	call   c0103b9b <pa2page>
c010532a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105331:	00 
c0105332:	89 04 24             	mov    %eax,(%esp)
c0105335:	e8 7f eb ff ff       	call   c0103eb9 <free_pages>
    boot_pgdir[0] = 0;
c010533a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010533f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105345:	c7 04 24 5c 71 10 c0 	movl   $0xc010715c,(%esp)
c010534c:	e8 eb af ff ff       	call   c010033c <cprintf>
}
c0105351:	c9                   	leave  
c0105352:	c3                   	ret    

c0105353 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105353:	55                   	push   %ebp
c0105354:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105356:	8b 45 08             	mov    0x8(%ebp),%eax
c0105359:	83 e0 04             	and    $0x4,%eax
c010535c:	85 c0                	test   %eax,%eax
c010535e:	74 07                	je     c0105367 <perm2str+0x14>
c0105360:	b8 75 00 00 00       	mov    $0x75,%eax
c0105365:	eb 05                	jmp    c010536c <perm2str+0x19>
c0105367:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010536c:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105371:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105378:	8b 45 08             	mov    0x8(%ebp),%eax
c010537b:	83 e0 02             	and    $0x2,%eax
c010537e:	85 c0                	test   %eax,%eax
c0105380:	74 07                	je     c0105389 <perm2str+0x36>
c0105382:	b8 77 00 00 00       	mov    $0x77,%eax
c0105387:	eb 05                	jmp    c010538e <perm2str+0x3b>
c0105389:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010538e:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0105393:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c010539a:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c010539f:	5d                   	pop    %ebp
c01053a0:	c3                   	ret    

c01053a1 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01053a1:	55                   	push   %ebp
c01053a2:	89 e5                	mov    %esp,%ebp
c01053a4:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01053a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01053aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053ad:	72 0a                	jb     c01053b9 <get_pgtable_items+0x18>
        return 0;
c01053af:	b8 00 00 00 00       	mov    $0x0,%eax
c01053b4:	e9 9c 00 00 00       	jmp    c0105455 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01053b9:	eb 04                	jmp    c01053bf <get_pgtable_items+0x1e>
        start ++;
c01053bb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01053bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01053c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053c5:	73 18                	jae    c01053df <get_pgtable_items+0x3e>
c01053c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01053ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01053d1:	8b 45 14             	mov    0x14(%ebp),%eax
c01053d4:	01 d0                	add    %edx,%eax
c01053d6:	8b 00                	mov    (%eax),%eax
c01053d8:	83 e0 01             	and    $0x1,%eax
c01053db:	85 c0                	test   %eax,%eax
c01053dd:	74 dc                	je     c01053bb <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01053df:	8b 45 10             	mov    0x10(%ebp),%eax
c01053e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053e5:	73 69                	jae    c0105450 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01053e7:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01053eb:	74 08                	je     c01053f5 <get_pgtable_items+0x54>
            *left_store = start;
c01053ed:	8b 45 18             	mov    0x18(%ebp),%eax
c01053f0:	8b 55 10             	mov    0x10(%ebp),%edx
c01053f3:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01053f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01053f8:	8d 50 01             	lea    0x1(%eax),%edx
c01053fb:	89 55 10             	mov    %edx,0x10(%ebp)
c01053fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105405:	8b 45 14             	mov    0x14(%ebp),%eax
c0105408:	01 d0                	add    %edx,%eax
c010540a:	8b 00                	mov    (%eax),%eax
c010540c:	83 e0 07             	and    $0x7,%eax
c010540f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105412:	eb 04                	jmp    c0105418 <get_pgtable_items+0x77>
            start ++;
c0105414:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105418:	8b 45 10             	mov    0x10(%ebp),%eax
c010541b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010541e:	73 1d                	jae    c010543d <get_pgtable_items+0x9c>
c0105420:	8b 45 10             	mov    0x10(%ebp),%eax
c0105423:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010542a:	8b 45 14             	mov    0x14(%ebp),%eax
c010542d:	01 d0                	add    %edx,%eax
c010542f:	8b 00                	mov    (%eax),%eax
c0105431:	83 e0 07             	and    $0x7,%eax
c0105434:	89 c2                	mov    %eax,%edx
c0105436:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105439:	39 c2                	cmp    %eax,%edx
c010543b:	74 d7                	je     c0105414 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c010543d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105441:	74 08                	je     c010544b <get_pgtable_items+0xaa>
            *right_store = start;
c0105443:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105446:	8b 55 10             	mov    0x10(%ebp),%edx
c0105449:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010544b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010544e:	eb 05                	jmp    c0105455 <get_pgtable_items+0xb4>
    }
    return 0;
c0105450:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105455:	c9                   	leave  
c0105456:	c3                   	ret    

c0105457 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105457:	55                   	push   %ebp
c0105458:	89 e5                	mov    %esp,%ebp
c010545a:	57                   	push   %edi
c010545b:	56                   	push   %esi
c010545c:	53                   	push   %ebx
c010545d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105460:	c7 04 24 7c 71 10 c0 	movl   $0xc010717c,(%esp)
c0105467:	e8 d0 ae ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c010546c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105473:	e9 fa 00 00 00       	jmp    c0105572 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010547b:	89 04 24             	mov    %eax,(%esp)
c010547e:	e8 d0 fe ff ff       	call   c0105353 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105483:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105486:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105489:	29 d1                	sub    %edx,%ecx
c010548b:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010548d:	89 d6                	mov    %edx,%esi
c010548f:	c1 e6 16             	shl    $0x16,%esi
c0105492:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105495:	89 d3                	mov    %edx,%ebx
c0105497:	c1 e3 16             	shl    $0x16,%ebx
c010549a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010549d:	89 d1                	mov    %edx,%ecx
c010549f:	c1 e1 16             	shl    $0x16,%ecx
c01054a2:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01054a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01054a8:	29 d7                	sub    %edx,%edi
c01054aa:	89 fa                	mov    %edi,%edx
c01054ac:	89 44 24 14          	mov    %eax,0x14(%esp)
c01054b0:	89 74 24 10          	mov    %esi,0x10(%esp)
c01054b4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01054b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01054bc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054c0:	c7 04 24 ad 71 10 c0 	movl   $0xc01071ad,(%esp)
c01054c7:	e8 70 ae ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01054cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054cf:	c1 e0 0a             	shl    $0xa,%eax
c01054d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01054d5:	eb 54                	jmp    c010552b <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01054d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054da:	89 04 24             	mov    %eax,(%esp)
c01054dd:	e8 71 fe ff ff       	call   c0105353 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01054e2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01054e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01054e8:	29 d1                	sub    %edx,%ecx
c01054ea:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01054ec:	89 d6                	mov    %edx,%esi
c01054ee:	c1 e6 0c             	shl    $0xc,%esi
c01054f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054f4:	89 d3                	mov    %edx,%ebx
c01054f6:	c1 e3 0c             	shl    $0xc,%ebx
c01054f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01054fc:	c1 e2 0c             	shl    $0xc,%edx
c01054ff:	89 d1                	mov    %edx,%ecx
c0105501:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105504:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105507:	29 d7                	sub    %edx,%edi
c0105509:	89 fa                	mov    %edi,%edx
c010550b:	89 44 24 14          	mov    %eax,0x14(%esp)
c010550f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105513:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105517:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010551b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010551f:	c7 04 24 cc 71 10 c0 	movl   $0xc01071cc,(%esp)
c0105526:	e8 11 ae ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010552b:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105533:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105536:	89 ce                	mov    %ecx,%esi
c0105538:	c1 e6 0a             	shl    $0xa,%esi
c010553b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010553e:	89 cb                	mov    %ecx,%ebx
c0105540:	c1 e3 0a             	shl    $0xa,%ebx
c0105543:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105546:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010554a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010554d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105551:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105555:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105559:	89 74 24 04          	mov    %esi,0x4(%esp)
c010555d:	89 1c 24             	mov    %ebx,(%esp)
c0105560:	e8 3c fe ff ff       	call   c01053a1 <get_pgtable_items>
c0105565:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105568:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010556c:	0f 85 65 ff ff ff    	jne    c01054d7 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105572:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105577:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010557a:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010557d:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105581:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105584:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105588:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010558c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105590:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105597:	00 
c0105598:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010559f:	e8 fd fd ff ff       	call   c01053a1 <get_pgtable_items>
c01055a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01055ab:	0f 85 c7 fe ff ff    	jne    c0105478 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01055b1:	c7 04 24 f0 71 10 c0 	movl   $0xc01071f0,(%esp)
c01055b8:	e8 7f ad ff ff       	call   c010033c <cprintf>
}
c01055bd:	83 c4 4c             	add    $0x4c,%esp
c01055c0:	5b                   	pop    %ebx
c01055c1:	5e                   	pop    %esi
c01055c2:	5f                   	pop    %edi
c01055c3:	5d                   	pop    %ebp
c01055c4:	c3                   	ret    

c01055c5 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01055c5:	55                   	push   %ebp
c01055c6:	89 e5                	mov    %esp,%ebp
c01055c8:	83 ec 58             	sub    $0x58,%esp
c01055cb:	8b 45 10             	mov    0x10(%ebp),%eax
c01055ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01055d1:	8b 45 14             	mov    0x14(%ebp),%eax
c01055d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01055d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01055da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01055dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055e0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01055e3:	8b 45 18             	mov    0x18(%ebp),%eax
c01055e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01055f2:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01055f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01055fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01055ff:	74 1c                	je     c010561d <printnum+0x58>
c0105601:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105604:	ba 00 00 00 00       	mov    $0x0,%edx
c0105609:	f7 75 e4             	divl   -0x1c(%ebp)
c010560c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010560f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105612:	ba 00 00 00 00       	mov    $0x0,%edx
c0105617:	f7 75 e4             	divl   -0x1c(%ebp)
c010561a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010561d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105620:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105623:	f7 75 e4             	divl   -0x1c(%ebp)
c0105626:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105629:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010562c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010562f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105632:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105635:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105638:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010563b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010563e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105641:	ba 00 00 00 00       	mov    $0x0,%edx
c0105646:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105649:	77 56                	ja     c01056a1 <printnum+0xdc>
c010564b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010564e:	72 05                	jb     c0105655 <printnum+0x90>
c0105650:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105653:	77 4c                	ja     c01056a1 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105655:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105658:	8d 50 ff             	lea    -0x1(%eax),%edx
c010565b:	8b 45 20             	mov    0x20(%ebp),%eax
c010565e:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105662:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105666:	8b 45 18             	mov    0x18(%ebp),%eax
c0105669:	89 44 24 10          	mov    %eax,0x10(%esp)
c010566d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105670:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105673:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105677:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010567b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010567e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105682:	8b 45 08             	mov    0x8(%ebp),%eax
c0105685:	89 04 24             	mov    %eax,(%esp)
c0105688:	e8 38 ff ff ff       	call   c01055c5 <printnum>
c010568d:	eb 1c                	jmp    c01056ab <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010568f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105692:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105696:	8b 45 20             	mov    0x20(%ebp),%eax
c0105699:	89 04 24             	mov    %eax,(%esp)
c010569c:	8b 45 08             	mov    0x8(%ebp),%eax
c010569f:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01056a1:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01056a5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01056a9:	7f e4                	jg     c010568f <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01056ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01056ae:	05 a4 72 10 c0       	add    $0xc01072a4,%eax
c01056b3:	0f b6 00             	movzbl (%eax),%eax
c01056b6:	0f be c0             	movsbl %al,%eax
c01056b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056bc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056c0:	89 04 24             	mov    %eax,(%esp)
c01056c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c6:	ff d0                	call   *%eax
}
c01056c8:	c9                   	leave  
c01056c9:	c3                   	ret    

c01056ca <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01056ca:	55                   	push   %ebp
c01056cb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01056cd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01056d1:	7e 14                	jle    c01056e7 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01056d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d6:	8b 00                	mov    (%eax),%eax
c01056d8:	8d 48 08             	lea    0x8(%eax),%ecx
c01056db:	8b 55 08             	mov    0x8(%ebp),%edx
c01056de:	89 0a                	mov    %ecx,(%edx)
c01056e0:	8b 50 04             	mov    0x4(%eax),%edx
c01056e3:	8b 00                	mov    (%eax),%eax
c01056e5:	eb 30                	jmp    c0105717 <getuint+0x4d>
    }
    else if (lflag) {
c01056e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01056eb:	74 16                	je     c0105703 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01056ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f0:	8b 00                	mov    (%eax),%eax
c01056f2:	8d 48 04             	lea    0x4(%eax),%ecx
c01056f5:	8b 55 08             	mov    0x8(%ebp),%edx
c01056f8:	89 0a                	mov    %ecx,(%edx)
c01056fa:	8b 00                	mov    (%eax),%eax
c01056fc:	ba 00 00 00 00       	mov    $0x0,%edx
c0105701:	eb 14                	jmp    c0105717 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105703:	8b 45 08             	mov    0x8(%ebp),%eax
c0105706:	8b 00                	mov    (%eax),%eax
c0105708:	8d 48 04             	lea    0x4(%eax),%ecx
c010570b:	8b 55 08             	mov    0x8(%ebp),%edx
c010570e:	89 0a                	mov    %ecx,(%edx)
c0105710:	8b 00                	mov    (%eax),%eax
c0105712:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105717:	5d                   	pop    %ebp
c0105718:	c3                   	ret    

c0105719 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105719:	55                   	push   %ebp
c010571a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010571c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105720:	7e 14                	jle    c0105736 <getint+0x1d>
        return va_arg(*ap, long long);
c0105722:	8b 45 08             	mov    0x8(%ebp),%eax
c0105725:	8b 00                	mov    (%eax),%eax
c0105727:	8d 48 08             	lea    0x8(%eax),%ecx
c010572a:	8b 55 08             	mov    0x8(%ebp),%edx
c010572d:	89 0a                	mov    %ecx,(%edx)
c010572f:	8b 50 04             	mov    0x4(%eax),%edx
c0105732:	8b 00                	mov    (%eax),%eax
c0105734:	eb 28                	jmp    c010575e <getint+0x45>
    }
    else if (lflag) {
c0105736:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010573a:	74 12                	je     c010574e <getint+0x35>
        return va_arg(*ap, long);
c010573c:	8b 45 08             	mov    0x8(%ebp),%eax
c010573f:	8b 00                	mov    (%eax),%eax
c0105741:	8d 48 04             	lea    0x4(%eax),%ecx
c0105744:	8b 55 08             	mov    0x8(%ebp),%edx
c0105747:	89 0a                	mov    %ecx,(%edx)
c0105749:	8b 00                	mov    (%eax),%eax
c010574b:	99                   	cltd   
c010574c:	eb 10                	jmp    c010575e <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010574e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105751:	8b 00                	mov    (%eax),%eax
c0105753:	8d 48 04             	lea    0x4(%eax),%ecx
c0105756:	8b 55 08             	mov    0x8(%ebp),%edx
c0105759:	89 0a                	mov    %ecx,(%edx)
c010575b:	8b 00                	mov    (%eax),%eax
c010575d:	99                   	cltd   
    }
}
c010575e:	5d                   	pop    %ebp
c010575f:	c3                   	ret    

c0105760 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105760:	55                   	push   %ebp
c0105761:	89 e5                	mov    %esp,%ebp
c0105763:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105766:	8d 45 14             	lea    0x14(%ebp),%eax
c0105769:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010576c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010576f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105773:	8b 45 10             	mov    0x10(%ebp),%eax
c0105776:	89 44 24 08          	mov    %eax,0x8(%esp)
c010577a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010577d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105781:	8b 45 08             	mov    0x8(%ebp),%eax
c0105784:	89 04 24             	mov    %eax,(%esp)
c0105787:	e8 02 00 00 00       	call   c010578e <vprintfmt>
    va_end(ap);
}
c010578c:	c9                   	leave  
c010578d:	c3                   	ret    

c010578e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010578e:	55                   	push   %ebp
c010578f:	89 e5                	mov    %esp,%ebp
c0105791:	56                   	push   %esi
c0105792:	53                   	push   %ebx
c0105793:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105796:	eb 18                	jmp    c01057b0 <vprintfmt+0x22>
            if (ch == '\0') {
c0105798:	85 db                	test   %ebx,%ebx
c010579a:	75 05                	jne    c01057a1 <vprintfmt+0x13>
                return;
c010579c:	e9 d1 03 00 00       	jmp    c0105b72 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01057a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a8:	89 1c 24             	mov    %ebx,(%esp)
c01057ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ae:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01057b3:	8d 50 01             	lea    0x1(%eax),%edx
c01057b6:	89 55 10             	mov    %edx,0x10(%ebp)
c01057b9:	0f b6 00             	movzbl (%eax),%eax
c01057bc:	0f b6 d8             	movzbl %al,%ebx
c01057bf:	83 fb 25             	cmp    $0x25,%ebx
c01057c2:	75 d4                	jne    c0105798 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01057c4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01057c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01057cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01057d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01057dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057df:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01057e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01057e5:	8d 50 01             	lea    0x1(%eax),%edx
c01057e8:	89 55 10             	mov    %edx,0x10(%ebp)
c01057eb:	0f b6 00             	movzbl (%eax),%eax
c01057ee:	0f b6 d8             	movzbl %al,%ebx
c01057f1:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01057f4:	83 f8 55             	cmp    $0x55,%eax
c01057f7:	0f 87 44 03 00 00    	ja     c0105b41 <vprintfmt+0x3b3>
c01057fd:	8b 04 85 c8 72 10 c0 	mov    -0x3fef8d38(,%eax,4),%eax
c0105804:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105806:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010580a:	eb d6                	jmp    c01057e2 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010580c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105810:	eb d0                	jmp    c01057e2 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105812:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105819:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010581c:	89 d0                	mov    %edx,%eax
c010581e:	c1 e0 02             	shl    $0x2,%eax
c0105821:	01 d0                	add    %edx,%eax
c0105823:	01 c0                	add    %eax,%eax
c0105825:	01 d8                	add    %ebx,%eax
c0105827:	83 e8 30             	sub    $0x30,%eax
c010582a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010582d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105830:	0f b6 00             	movzbl (%eax),%eax
c0105833:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105836:	83 fb 2f             	cmp    $0x2f,%ebx
c0105839:	7e 0b                	jle    c0105846 <vprintfmt+0xb8>
c010583b:	83 fb 39             	cmp    $0x39,%ebx
c010583e:	7f 06                	jg     c0105846 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105840:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105844:	eb d3                	jmp    c0105819 <vprintfmt+0x8b>
            goto process_precision;
c0105846:	eb 33                	jmp    c010587b <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105848:	8b 45 14             	mov    0x14(%ebp),%eax
c010584b:	8d 50 04             	lea    0x4(%eax),%edx
c010584e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105851:	8b 00                	mov    (%eax),%eax
c0105853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105856:	eb 23                	jmp    c010587b <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105858:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010585c:	79 0c                	jns    c010586a <vprintfmt+0xdc>
                width = 0;
c010585e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105865:	e9 78 ff ff ff       	jmp    c01057e2 <vprintfmt+0x54>
c010586a:	e9 73 ff ff ff       	jmp    c01057e2 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010586f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105876:	e9 67 ff ff ff       	jmp    c01057e2 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010587b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010587f:	79 12                	jns    c0105893 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105884:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105887:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010588e:	e9 4f ff ff ff       	jmp    c01057e2 <vprintfmt+0x54>
c0105893:	e9 4a ff ff ff       	jmp    c01057e2 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105898:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010589c:	e9 41 ff ff ff       	jmp    c01057e2 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01058a1:	8b 45 14             	mov    0x14(%ebp),%eax
c01058a4:	8d 50 04             	lea    0x4(%eax),%edx
c01058a7:	89 55 14             	mov    %edx,0x14(%ebp)
c01058aa:	8b 00                	mov    (%eax),%eax
c01058ac:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058af:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058b3:	89 04 24             	mov    %eax,(%esp)
c01058b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b9:	ff d0                	call   *%eax
            break;
c01058bb:	e9 ac 02 00 00       	jmp    c0105b6c <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01058c0:	8b 45 14             	mov    0x14(%ebp),%eax
c01058c3:	8d 50 04             	lea    0x4(%eax),%edx
c01058c6:	89 55 14             	mov    %edx,0x14(%ebp)
c01058c9:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01058cb:	85 db                	test   %ebx,%ebx
c01058cd:	79 02                	jns    c01058d1 <vprintfmt+0x143>
                err = -err;
c01058cf:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01058d1:	83 fb 06             	cmp    $0x6,%ebx
c01058d4:	7f 0b                	jg     c01058e1 <vprintfmt+0x153>
c01058d6:	8b 34 9d 88 72 10 c0 	mov    -0x3fef8d78(,%ebx,4),%esi
c01058dd:	85 f6                	test   %esi,%esi
c01058df:	75 23                	jne    c0105904 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01058e1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01058e5:	c7 44 24 08 b5 72 10 	movl   $0xc01072b5,0x8(%esp)
c01058ec:	c0 
c01058ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f7:	89 04 24             	mov    %eax,(%esp)
c01058fa:	e8 61 fe ff ff       	call   c0105760 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01058ff:	e9 68 02 00 00       	jmp    c0105b6c <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105904:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105908:	c7 44 24 08 be 72 10 	movl   $0xc01072be,0x8(%esp)
c010590f:	c0 
c0105910:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105913:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105917:	8b 45 08             	mov    0x8(%ebp),%eax
c010591a:	89 04 24             	mov    %eax,(%esp)
c010591d:	e8 3e fe ff ff       	call   c0105760 <printfmt>
            }
            break;
c0105922:	e9 45 02 00 00       	jmp    c0105b6c <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105927:	8b 45 14             	mov    0x14(%ebp),%eax
c010592a:	8d 50 04             	lea    0x4(%eax),%edx
c010592d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105930:	8b 30                	mov    (%eax),%esi
c0105932:	85 f6                	test   %esi,%esi
c0105934:	75 05                	jne    c010593b <vprintfmt+0x1ad>
                p = "(null)";
c0105936:	be c1 72 10 c0       	mov    $0xc01072c1,%esi
            }
            if (width > 0 && padc != '-') {
c010593b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010593f:	7e 3e                	jle    c010597f <vprintfmt+0x1f1>
c0105941:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105945:	74 38                	je     c010597f <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105947:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010594a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010594d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105951:	89 34 24             	mov    %esi,(%esp)
c0105954:	e8 15 03 00 00       	call   c0105c6e <strnlen>
c0105959:	29 c3                	sub    %eax,%ebx
c010595b:	89 d8                	mov    %ebx,%eax
c010595d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105960:	eb 17                	jmp    c0105979 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105962:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105966:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105969:	89 54 24 04          	mov    %edx,0x4(%esp)
c010596d:	89 04 24             	mov    %eax,(%esp)
c0105970:	8b 45 08             	mov    0x8(%ebp),%eax
c0105973:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105975:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105979:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010597d:	7f e3                	jg     c0105962 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010597f:	eb 38                	jmp    c01059b9 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105981:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105985:	74 1f                	je     c01059a6 <vprintfmt+0x218>
c0105987:	83 fb 1f             	cmp    $0x1f,%ebx
c010598a:	7e 05                	jle    c0105991 <vprintfmt+0x203>
c010598c:	83 fb 7e             	cmp    $0x7e,%ebx
c010598f:	7e 15                	jle    c01059a6 <vprintfmt+0x218>
                    putch('?', putdat);
c0105991:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105994:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105998:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010599f:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a2:	ff d0                	call   *%eax
c01059a4:	eb 0f                	jmp    c01059b5 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01059a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ad:	89 1c 24             	mov    %ebx,(%esp)
c01059b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b3:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059b5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059b9:	89 f0                	mov    %esi,%eax
c01059bb:	8d 70 01             	lea    0x1(%eax),%esi
c01059be:	0f b6 00             	movzbl (%eax),%eax
c01059c1:	0f be d8             	movsbl %al,%ebx
c01059c4:	85 db                	test   %ebx,%ebx
c01059c6:	74 10                	je     c01059d8 <vprintfmt+0x24a>
c01059c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059cc:	78 b3                	js     c0105981 <vprintfmt+0x1f3>
c01059ce:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01059d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059d6:	79 a9                	jns    c0105981 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01059d8:	eb 17                	jmp    c01059f1 <vprintfmt+0x263>
                putch(' ', putdat);
c01059da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059e1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01059e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01059eb:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01059ed:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059f5:	7f e3                	jg     c01059da <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01059f7:	e9 70 01 00 00       	jmp    c0105b6c <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01059fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a03:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a06:	89 04 24             	mov    %eax,(%esp)
c0105a09:	e8 0b fd ff ff       	call   c0105719 <getint>
c0105a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a11:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a1a:	85 d2                	test   %edx,%edx
c0105a1c:	79 26                	jns    c0105a44 <vprintfmt+0x2b6>
                putch('-', putdat);
c0105a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a25:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2f:	ff d0                	call   *%eax
                num = -(long long)num;
c0105a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a37:	f7 d8                	neg    %eax
c0105a39:	83 d2 00             	adc    $0x0,%edx
c0105a3c:	f7 da                	neg    %edx
c0105a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a41:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a4b:	e9 a8 00 00 00       	jmp    c0105af8 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a57:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a5a:	89 04 24             	mov    %eax,(%esp)
c0105a5d:	e8 68 fc ff ff       	call   c01056ca <getuint>
c0105a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a65:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a6f:	e9 84 00 00 00       	jmp    c0105af8 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a7b:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a7e:	89 04 24             	mov    %eax,(%esp)
c0105a81:	e8 44 fc ff ff       	call   c01056ca <getuint>
c0105a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105a8c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105a93:	eb 63                	jmp    c0105af8 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a9c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa6:	ff d0                	call   *%eax
            putch('x', putdat);
c0105aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aaf:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab9:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105abb:	8b 45 14             	mov    0x14(%ebp),%eax
c0105abe:	8d 50 04             	lea    0x4(%eax),%edx
c0105ac1:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ac4:	8b 00                	mov    (%eax),%eax
c0105ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ac9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ad0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105ad7:	eb 1f                	jmp    c0105af8 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105adc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ae0:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ae3:	89 04 24             	mov    %eax,(%esp)
c0105ae6:	e8 df fb ff ff       	call   c01056ca <getuint>
c0105aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105af1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105af8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105aff:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105b03:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105b06:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105b0a:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b14:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b18:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b26:	89 04 24             	mov    %eax,(%esp)
c0105b29:	e8 97 fa ff ff       	call   c01055c5 <printnum>
            break;
c0105b2e:	eb 3c                	jmp    c0105b6c <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b37:	89 1c 24             	mov    %ebx,(%esp)
c0105b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3d:	ff d0                	call   *%eax
            break;
c0105b3f:	eb 2b                	jmp    c0105b6c <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b48:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b52:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b54:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b58:	eb 04                	jmp    c0105b5e <vprintfmt+0x3d0>
c0105b5a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b61:	83 e8 01             	sub    $0x1,%eax
c0105b64:	0f b6 00             	movzbl (%eax),%eax
c0105b67:	3c 25                	cmp    $0x25,%al
c0105b69:	75 ef                	jne    c0105b5a <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105b6b:	90                   	nop
        }
    }
c0105b6c:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105b6d:	e9 3e fc ff ff       	jmp    c01057b0 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105b72:	83 c4 40             	add    $0x40,%esp
c0105b75:	5b                   	pop    %ebx
c0105b76:	5e                   	pop    %esi
c0105b77:	5d                   	pop    %ebp
c0105b78:	c3                   	ret    

c0105b79 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b79:	55                   	push   %ebp
c0105b7a:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7f:	8b 40 08             	mov    0x8(%eax),%eax
c0105b82:	8d 50 01             	lea    0x1(%eax),%edx
c0105b85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b88:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8e:	8b 10                	mov    (%eax),%edx
c0105b90:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b93:	8b 40 04             	mov    0x4(%eax),%eax
c0105b96:	39 c2                	cmp    %eax,%edx
c0105b98:	73 12                	jae    c0105bac <sprintputch+0x33>
        *b->buf ++ = ch;
c0105b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9d:	8b 00                	mov    (%eax),%eax
c0105b9f:	8d 48 01             	lea    0x1(%eax),%ecx
c0105ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ba5:	89 0a                	mov    %ecx,(%edx)
c0105ba7:	8b 55 08             	mov    0x8(%ebp),%edx
c0105baa:	88 10                	mov    %dl,(%eax)
    }
}
c0105bac:	5d                   	pop    %ebp
c0105bad:	c3                   	ret    

c0105bae <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105bae:	55                   	push   %ebp
c0105baf:	89 e5                	mov    %esp,%ebp
c0105bb1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105bb4:	8d 45 14             	lea    0x14(%ebp),%eax
c0105bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105bc1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bc4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd2:	89 04 24             	mov    %eax,(%esp)
c0105bd5:	e8 08 00 00 00       	call   c0105be2 <vsnprintf>
c0105bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105be0:	c9                   	leave  
c0105be1:	c3                   	ret    

c0105be2 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105be2:	55                   	push   %ebp
c0105be3:	89 e5                	mov    %esp,%ebp
c0105be5:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105beb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bf1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105bf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf7:	01 d0                	add    %edx,%eax
c0105bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c07:	74 0a                	je     c0105c13 <vsnprintf+0x31>
c0105c09:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c0f:	39 c2                	cmp    %eax,%edx
c0105c11:	76 07                	jbe    c0105c1a <vsnprintf+0x38>
        return -E_INVAL;
c0105c13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105c18:	eb 2a                	jmp    c0105c44 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c1a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c21:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c24:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c28:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c2f:	c7 04 24 79 5b 10 c0 	movl   $0xc0105b79,(%esp)
c0105c36:	e8 53 fb ff ff       	call   c010578e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c3e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c44:	c9                   	leave  
c0105c45:	c3                   	ret    

c0105c46 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105c46:	55                   	push   %ebp
c0105c47:	89 e5                	mov    %esp,%ebp
c0105c49:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105c53:	eb 04                	jmp    c0105c59 <strlen+0x13>
        cnt ++;
c0105c55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5c:	8d 50 01             	lea    0x1(%eax),%edx
c0105c5f:	89 55 08             	mov    %edx,0x8(%ebp)
c0105c62:	0f b6 00             	movzbl (%eax),%eax
c0105c65:	84 c0                	test   %al,%al
c0105c67:	75 ec                	jne    c0105c55 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105c6c:	c9                   	leave  
c0105c6d:	c3                   	ret    

c0105c6e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105c6e:	55                   	push   %ebp
c0105c6f:	89 e5                	mov    %esp,%ebp
c0105c71:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105c7b:	eb 04                	jmp    c0105c81 <strnlen+0x13>
        cnt ++;
c0105c7d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c84:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c87:	73 10                	jae    c0105c99 <strnlen+0x2b>
c0105c89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8c:	8d 50 01             	lea    0x1(%eax),%edx
c0105c8f:	89 55 08             	mov    %edx,0x8(%ebp)
c0105c92:	0f b6 00             	movzbl (%eax),%eax
c0105c95:	84 c0                	test   %al,%al
c0105c97:	75 e4                	jne    c0105c7d <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105c9c:	c9                   	leave  
c0105c9d:	c3                   	ret    

c0105c9e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105c9e:	55                   	push   %ebp
c0105c9f:	89 e5                	mov    %esp,%ebp
c0105ca1:	57                   	push   %edi
c0105ca2:	56                   	push   %esi
c0105ca3:	83 ec 20             	sub    $0x20,%esp
c0105ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cac:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105cb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cb8:	89 d1                	mov    %edx,%ecx
c0105cba:	89 c2                	mov    %eax,%edx
c0105cbc:	89 ce                	mov    %ecx,%esi
c0105cbe:	89 d7                	mov    %edx,%edi
c0105cc0:	ac                   	lods   %ds:(%esi),%al
c0105cc1:	aa                   	stos   %al,%es:(%edi)
c0105cc2:	84 c0                	test   %al,%al
c0105cc4:	75 fa                	jne    c0105cc0 <strcpy+0x22>
c0105cc6:	89 fa                	mov    %edi,%edx
c0105cc8:	89 f1                	mov    %esi,%ecx
c0105cca:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ccd:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105cd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105cd6:	83 c4 20             	add    $0x20,%esp
c0105cd9:	5e                   	pop    %esi
c0105cda:	5f                   	pop    %edi
c0105cdb:	5d                   	pop    %ebp
c0105cdc:	c3                   	ret    

c0105cdd <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105cdd:	55                   	push   %ebp
c0105cde:	89 e5                	mov    %esp,%ebp
c0105ce0:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105ce9:	eb 21                	jmp    c0105d0c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cee:	0f b6 10             	movzbl (%eax),%edx
c0105cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105cf4:	88 10                	mov    %dl,(%eax)
c0105cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105cf9:	0f b6 00             	movzbl (%eax),%eax
c0105cfc:	84 c0                	test   %al,%al
c0105cfe:	74 04                	je     c0105d04 <strncpy+0x27>
            src ++;
c0105d00:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105d04:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105d08:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105d0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d10:	75 d9                	jne    c0105ceb <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105d12:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d15:	c9                   	leave  
c0105d16:	c3                   	ret    

c0105d17 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105d17:	55                   	push   %ebp
c0105d18:	89 e5                	mov    %esp,%ebp
c0105d1a:	57                   	push   %edi
c0105d1b:	56                   	push   %esi
c0105d1c:	83 ec 20             	sub    $0x20,%esp
c0105d1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105d2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d31:	89 d1                	mov    %edx,%ecx
c0105d33:	89 c2                	mov    %eax,%edx
c0105d35:	89 ce                	mov    %ecx,%esi
c0105d37:	89 d7                	mov    %edx,%edi
c0105d39:	ac                   	lods   %ds:(%esi),%al
c0105d3a:	ae                   	scas   %es:(%edi),%al
c0105d3b:	75 08                	jne    c0105d45 <strcmp+0x2e>
c0105d3d:	84 c0                	test   %al,%al
c0105d3f:	75 f8                	jne    c0105d39 <strcmp+0x22>
c0105d41:	31 c0                	xor    %eax,%eax
c0105d43:	eb 04                	jmp    c0105d49 <strcmp+0x32>
c0105d45:	19 c0                	sbb    %eax,%eax
c0105d47:	0c 01                	or     $0x1,%al
c0105d49:	89 fa                	mov    %edi,%edx
c0105d4b:	89 f1                	mov    %esi,%ecx
c0105d4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d50:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d53:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105d59:	83 c4 20             	add    $0x20,%esp
c0105d5c:	5e                   	pop    %esi
c0105d5d:	5f                   	pop    %edi
c0105d5e:	5d                   	pop    %ebp
c0105d5f:	c3                   	ret    

c0105d60 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105d60:	55                   	push   %ebp
c0105d61:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d63:	eb 0c                	jmp    c0105d71 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105d65:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105d69:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d6d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d75:	74 1a                	je     c0105d91 <strncmp+0x31>
c0105d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7a:	0f b6 00             	movzbl (%eax),%eax
c0105d7d:	84 c0                	test   %al,%al
c0105d7f:	74 10                	je     c0105d91 <strncmp+0x31>
c0105d81:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d84:	0f b6 10             	movzbl (%eax),%edx
c0105d87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d8a:	0f b6 00             	movzbl (%eax),%eax
c0105d8d:	38 c2                	cmp    %al,%dl
c0105d8f:	74 d4                	je     c0105d65 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105d91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d95:	74 18                	je     c0105daf <strncmp+0x4f>
c0105d97:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9a:	0f b6 00             	movzbl (%eax),%eax
c0105d9d:	0f b6 d0             	movzbl %al,%edx
c0105da0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da3:	0f b6 00             	movzbl (%eax),%eax
c0105da6:	0f b6 c0             	movzbl %al,%eax
c0105da9:	29 c2                	sub    %eax,%edx
c0105dab:	89 d0                	mov    %edx,%eax
c0105dad:	eb 05                	jmp    c0105db4 <strncmp+0x54>
c0105daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105db4:	5d                   	pop    %ebp
c0105db5:	c3                   	ret    

c0105db6 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105db6:	55                   	push   %ebp
c0105db7:	89 e5                	mov    %esp,%ebp
c0105db9:	83 ec 04             	sub    $0x4,%esp
c0105dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dbf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105dc2:	eb 14                	jmp    c0105dd8 <strchr+0x22>
        if (*s == c) {
c0105dc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc7:	0f b6 00             	movzbl (%eax),%eax
c0105dca:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105dcd:	75 05                	jne    c0105dd4 <strchr+0x1e>
            return (char *)s;
c0105dcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd2:	eb 13                	jmp    c0105de7 <strchr+0x31>
        }
        s ++;
c0105dd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105dd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ddb:	0f b6 00             	movzbl (%eax),%eax
c0105dde:	84 c0                	test   %al,%al
c0105de0:	75 e2                	jne    c0105dc4 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105de7:	c9                   	leave  
c0105de8:	c3                   	ret    

c0105de9 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105de9:	55                   	push   %ebp
c0105dea:	89 e5                	mov    %esp,%ebp
c0105dec:	83 ec 04             	sub    $0x4,%esp
c0105def:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105df2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105df5:	eb 11                	jmp    c0105e08 <strfind+0x1f>
        if (*s == c) {
c0105df7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfa:	0f b6 00             	movzbl (%eax),%eax
c0105dfd:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105e00:	75 02                	jne    c0105e04 <strfind+0x1b>
            break;
c0105e02:	eb 0e                	jmp    c0105e12 <strfind+0x29>
        }
        s ++;
c0105e04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105e08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e0b:	0f b6 00             	movzbl (%eax),%eax
c0105e0e:	84 c0                	test   %al,%al
c0105e10:	75 e5                	jne    c0105df7 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105e12:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e15:	c9                   	leave  
c0105e16:	c3                   	ret    

c0105e17 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105e17:	55                   	push   %ebp
c0105e18:	89 e5                	mov    %esp,%ebp
c0105e1a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105e1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105e24:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105e2b:	eb 04                	jmp    c0105e31 <strtol+0x1a>
        s ++;
c0105e2d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105e31:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e34:	0f b6 00             	movzbl (%eax),%eax
c0105e37:	3c 20                	cmp    $0x20,%al
c0105e39:	74 f2                	je     c0105e2d <strtol+0x16>
c0105e3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e3e:	0f b6 00             	movzbl (%eax),%eax
c0105e41:	3c 09                	cmp    $0x9,%al
c0105e43:	74 e8                	je     c0105e2d <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105e45:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e48:	0f b6 00             	movzbl (%eax),%eax
c0105e4b:	3c 2b                	cmp    $0x2b,%al
c0105e4d:	75 06                	jne    c0105e55 <strtol+0x3e>
        s ++;
c0105e4f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e53:	eb 15                	jmp    c0105e6a <strtol+0x53>
    }
    else if (*s == '-') {
c0105e55:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e58:	0f b6 00             	movzbl (%eax),%eax
c0105e5b:	3c 2d                	cmp    $0x2d,%al
c0105e5d:	75 0b                	jne    c0105e6a <strtol+0x53>
        s ++, neg = 1;
c0105e5f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e63:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105e6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e6e:	74 06                	je     c0105e76 <strtol+0x5f>
c0105e70:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105e74:	75 24                	jne    c0105e9a <strtol+0x83>
c0105e76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e79:	0f b6 00             	movzbl (%eax),%eax
c0105e7c:	3c 30                	cmp    $0x30,%al
c0105e7e:	75 1a                	jne    c0105e9a <strtol+0x83>
c0105e80:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e83:	83 c0 01             	add    $0x1,%eax
c0105e86:	0f b6 00             	movzbl (%eax),%eax
c0105e89:	3c 78                	cmp    $0x78,%al
c0105e8b:	75 0d                	jne    c0105e9a <strtol+0x83>
        s += 2, base = 16;
c0105e8d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105e91:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105e98:	eb 2a                	jmp    c0105ec4 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e9e:	75 17                	jne    c0105eb7 <strtol+0xa0>
c0105ea0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea3:	0f b6 00             	movzbl (%eax),%eax
c0105ea6:	3c 30                	cmp    $0x30,%al
c0105ea8:	75 0d                	jne    c0105eb7 <strtol+0xa0>
        s ++, base = 8;
c0105eaa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105eae:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105eb5:	eb 0d                	jmp    c0105ec4 <strtol+0xad>
    }
    else if (base == 0) {
c0105eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ebb:	75 07                	jne    c0105ec4 <strtol+0xad>
        base = 10;
c0105ebd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105ec4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec7:	0f b6 00             	movzbl (%eax),%eax
c0105eca:	3c 2f                	cmp    $0x2f,%al
c0105ecc:	7e 1b                	jle    c0105ee9 <strtol+0xd2>
c0105ece:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed1:	0f b6 00             	movzbl (%eax),%eax
c0105ed4:	3c 39                	cmp    $0x39,%al
c0105ed6:	7f 11                	jg     c0105ee9 <strtol+0xd2>
            dig = *s - '0';
c0105ed8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105edb:	0f b6 00             	movzbl (%eax),%eax
c0105ede:	0f be c0             	movsbl %al,%eax
c0105ee1:	83 e8 30             	sub    $0x30,%eax
c0105ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ee7:	eb 48                	jmp    c0105f31 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105ee9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eec:	0f b6 00             	movzbl (%eax),%eax
c0105eef:	3c 60                	cmp    $0x60,%al
c0105ef1:	7e 1b                	jle    c0105f0e <strtol+0xf7>
c0105ef3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef6:	0f b6 00             	movzbl (%eax),%eax
c0105ef9:	3c 7a                	cmp    $0x7a,%al
c0105efb:	7f 11                	jg     c0105f0e <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105efd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f00:	0f b6 00             	movzbl (%eax),%eax
c0105f03:	0f be c0             	movsbl %al,%eax
c0105f06:	83 e8 57             	sub    $0x57,%eax
c0105f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f0c:	eb 23                	jmp    c0105f31 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105f0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f11:	0f b6 00             	movzbl (%eax),%eax
c0105f14:	3c 40                	cmp    $0x40,%al
c0105f16:	7e 3d                	jle    c0105f55 <strtol+0x13e>
c0105f18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f1b:	0f b6 00             	movzbl (%eax),%eax
c0105f1e:	3c 5a                	cmp    $0x5a,%al
c0105f20:	7f 33                	jg     c0105f55 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105f22:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f25:	0f b6 00             	movzbl (%eax),%eax
c0105f28:	0f be c0             	movsbl %al,%eax
c0105f2b:	83 e8 37             	sub    $0x37,%eax
c0105f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f34:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105f37:	7c 02                	jl     c0105f3b <strtol+0x124>
            break;
c0105f39:	eb 1a                	jmp    c0105f55 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105f3b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105f3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f42:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105f46:	89 c2                	mov    %eax,%edx
c0105f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f4b:	01 d0                	add    %edx,%eax
c0105f4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105f50:	e9 6f ff ff ff       	jmp    c0105ec4 <strtol+0xad>

    if (endptr) {
c0105f55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f59:	74 08                	je     c0105f63 <strtol+0x14c>
        *endptr = (char *) s;
c0105f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f5e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f61:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105f63:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105f67:	74 07                	je     c0105f70 <strtol+0x159>
c0105f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f6c:	f7 d8                	neg    %eax
c0105f6e:	eb 03                	jmp    c0105f73 <strtol+0x15c>
c0105f70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105f73:	c9                   	leave  
c0105f74:	c3                   	ret    

c0105f75 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105f75:	55                   	push   %ebp
c0105f76:	89 e5                	mov    %esp,%ebp
c0105f78:	57                   	push   %edi
c0105f79:	83 ec 24             	sub    $0x24,%esp
c0105f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f7f:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105f82:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105f86:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f89:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105f8c:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105f8f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105f95:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105f98:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105f9c:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105f9f:	89 d7                	mov    %edx,%edi
c0105fa1:	f3 aa                	rep stos %al,%es:(%edi)
c0105fa3:	89 fa                	mov    %edi,%edx
c0105fa5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105fa8:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105fae:	83 c4 24             	add    $0x24,%esp
c0105fb1:	5f                   	pop    %edi
c0105fb2:	5d                   	pop    %ebp
c0105fb3:	c3                   	ret    

c0105fb4 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105fb4:	55                   	push   %ebp
c0105fb5:	89 e5                	mov    %esp,%ebp
c0105fb7:	57                   	push   %edi
c0105fb8:	56                   	push   %esi
c0105fb9:	53                   	push   %ebx
c0105fba:	83 ec 30             	sub    $0x30,%esp
c0105fbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105fc9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fcc:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fd2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105fd5:	73 42                	jae    c0106019 <memmove+0x65>
c0105fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fe0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fe6:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105fe9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105fec:	c1 e8 02             	shr    $0x2,%eax
c0105fef:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105ff1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ff4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ff7:	89 d7                	mov    %edx,%edi
c0105ff9:	89 c6                	mov    %eax,%esi
c0105ffb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105ffd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106000:	83 e1 03             	and    $0x3,%ecx
c0106003:	74 02                	je     c0106007 <memmove+0x53>
c0106005:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106007:	89 f0                	mov    %esi,%eax
c0106009:	89 fa                	mov    %edi,%edx
c010600b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010600e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106011:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0106014:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106017:	eb 36                	jmp    c010604f <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0106019:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010601c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010601f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106022:	01 c2                	add    %eax,%edx
c0106024:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106027:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010602a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010602d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0106030:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106033:	89 c1                	mov    %eax,%ecx
c0106035:	89 d8                	mov    %ebx,%eax
c0106037:	89 d6                	mov    %edx,%esi
c0106039:	89 c7                	mov    %eax,%edi
c010603b:	fd                   	std    
c010603c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010603e:	fc                   	cld    
c010603f:	89 f8                	mov    %edi,%eax
c0106041:	89 f2                	mov    %esi,%edx
c0106043:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0106046:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0106049:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010604c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010604f:	83 c4 30             	add    $0x30,%esp
c0106052:	5b                   	pop    %ebx
c0106053:	5e                   	pop    %esi
c0106054:	5f                   	pop    %edi
c0106055:	5d                   	pop    %ebp
c0106056:	c3                   	ret    

c0106057 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0106057:	55                   	push   %ebp
c0106058:	89 e5                	mov    %esp,%ebp
c010605a:	57                   	push   %edi
c010605b:	56                   	push   %esi
c010605c:	83 ec 20             	sub    $0x20,%esp
c010605f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106062:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106065:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106068:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010606b:	8b 45 10             	mov    0x10(%ebp),%eax
c010606e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106071:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106074:	c1 e8 02             	shr    $0x2,%eax
c0106077:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0106079:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010607c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010607f:	89 d7                	mov    %edx,%edi
c0106081:	89 c6                	mov    %eax,%esi
c0106083:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106085:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0106088:	83 e1 03             	and    $0x3,%ecx
c010608b:	74 02                	je     c010608f <memcpy+0x38>
c010608d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010608f:	89 f0                	mov    %esi,%eax
c0106091:	89 fa                	mov    %edi,%edx
c0106093:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106096:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106099:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010609c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010609f:	83 c4 20             	add    $0x20,%esp
c01060a2:	5e                   	pop    %esi
c01060a3:	5f                   	pop    %edi
c01060a4:	5d                   	pop    %ebp
c01060a5:	c3                   	ret    

c01060a6 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01060a6:	55                   	push   %ebp
c01060a7:	89 e5                	mov    %esp,%ebp
c01060a9:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01060ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01060af:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01060b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01060b8:	eb 30                	jmp    c01060ea <memcmp+0x44>
        if (*s1 != *s2) {
c01060ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060bd:	0f b6 10             	movzbl (%eax),%edx
c01060c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060c3:	0f b6 00             	movzbl (%eax),%eax
c01060c6:	38 c2                	cmp    %al,%dl
c01060c8:	74 18                	je     c01060e2 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01060ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060cd:	0f b6 00             	movzbl (%eax),%eax
c01060d0:	0f b6 d0             	movzbl %al,%edx
c01060d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060d6:	0f b6 00             	movzbl (%eax),%eax
c01060d9:	0f b6 c0             	movzbl %al,%eax
c01060dc:	29 c2                	sub    %eax,%edx
c01060de:	89 d0                	mov    %edx,%eax
c01060e0:	eb 1a                	jmp    c01060fc <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01060e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01060e6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c01060ea:	8b 45 10             	mov    0x10(%ebp),%eax
c01060ed:	8d 50 ff             	lea    -0x1(%eax),%edx
c01060f0:	89 55 10             	mov    %edx,0x10(%ebp)
c01060f3:	85 c0                	test   %eax,%eax
c01060f5:	75 c3                	jne    c01060ba <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01060f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01060fc:	c9                   	leave  
c01060fd:	c3                   	ret    
