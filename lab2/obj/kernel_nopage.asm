
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba c8 89 11 00       	mov    $0x1189c8,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 1f 5f 00 00       	call   105f75 <memset>

    cons_init();                // init the console
  100056:	e8 5d 15 00 00       	call   1015b8 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 00 61 10 00 	movl   $0x106100,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 1c 61 10 00 	movl   $0x10611c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 0d 44 00 00       	call   104491 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 98 16 00 00       	call   101721 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 10 18 00 00       	call   10189e <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 db 0c 00 00       	call   100d6e <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 f7 15 00 00       	call   10168f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 e4 0b 00 00       	call   100ca0 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 21 61 10 00 	movl   $0x106121,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 2f 61 10 00 	movl   $0x10612f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 3d 61 10 00 	movl   $0x10613d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 4b 61 10 00 	movl   $0x10614b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 59 61 10 00 	movl   $0x106159,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 68 61 10 00 	movl   $0x106168,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 88 61 10 00 	movl   $0x106188,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 a7 61 10 00 	movl   $0x1061a7,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 ea 12 00 00       	call   1015e4 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 57 54 00 00       	call   10578e <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 71 12 00 00       	call   1015e4 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 51 12 00 00       	call   101620 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 ac 61 10 00    	movl   $0x1061ac,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 ac 61 10 00 	movl   $0x1061ac,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 20 74 10 00 	movl   $0x107420,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 d0 20 11 00 	movl   $0x1120d0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec d1 20 11 00 	movl   $0x1120d1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 58 4b 11 00 	movl   $0x114b58,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 fd 56 00 00       	call   105de9 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 b6 61 10 00 	movl   $0x1061b6,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 cf 61 10 00 	movl   $0x1061cf,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 fe 60 10 	movl   $0x1060fe,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 e7 61 10 00 	movl   $0x1061e7,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 ff 61 10 00 	movl   $0x1061ff,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 c8 89 11 	movl   $0x1189c8,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 17 62 10 00 	movl   $0x106217,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 30 62 10 00 	movl   $0x106230,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 5a 62 10 00 	movl   $0x10625a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 76 62 10 00 	movl   $0x106276,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	53                   	push   %ebx
  1009be:	83 ec 34             	sub    $0x34,%esp
     uint32_t *ebp = 0;
  1009c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     uint32_t esp = 0;
  1009c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cf:	89 e8                	mov    %ebp,%eax
  1009d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
  1009d4:	8b 45 ec             	mov    -0x14(%ebp),%eax

     ebp = (uint32_t *)read_ebp();
  1009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
     esp = read_eip();
  1009da:	e8 ca ff ff ff       	call   1009a9 <read_eip>
  1009df:	89 45 f0             	mov    %eax,-0x10(%ebp)

     while (ebp)
  1009e2:	eb 75                	jmp    100a59 <print_stackframe+0x9f>
     {
         cprintf("ebp:0x%08x eip:0x%08x args:", (uint32_t)ebp, esp);
  1009e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1009ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f2:	c7 04 24 88 62 10 00 	movl   $0x106288,(%esp)
  1009f9:	e8 3e f9 ff ff       	call   10033c <cprintf>
         cprintf("0x%08x 0x%08x 0x%08x 0x%08x\n", ebp[2], ebp[3], ebp[4], ebp[5]);
  1009fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a01:	83 c0 14             	add    $0x14,%eax
  100a04:	8b 18                	mov    (%eax),%ebx
  100a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a09:	83 c0 10             	add    $0x10,%eax
  100a0c:	8b 08                	mov    (%eax),%ecx
  100a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a11:	83 c0 0c             	add    $0xc,%eax
  100a14:	8b 10                	mov    (%eax),%edx
  100a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a19:	83 c0 08             	add    $0x8,%eax
  100a1c:	8b 00                	mov    (%eax),%eax
  100a1e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a22:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a26:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2e:	c7 04 24 a4 62 10 00 	movl   $0x1062a4,(%esp)
  100a35:	e8 02 f9 ff ff       	call   10033c <cprintf>

         print_debuginfo(esp - 1);
  100a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a3d:	83 e8 01             	sub    $0x1,%eax
  100a40:	89 04 24             	mov    %eax,(%esp)
  100a43:	e8 be fe ff ff       	call   100906 <print_debuginfo>

         esp = ebp[1];
  100a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a4b:	8b 40 04             	mov    0x4(%eax),%eax
  100a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
         ebp = (uint32_t *)*ebp;
  100a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a54:	8b 00                	mov    (%eax),%eax
  100a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t esp = 0;

     ebp = (uint32_t *)read_ebp();
     esp = read_eip();

     while (ebp)
  100a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a5d:	75 85                	jne    1009e4 <print_stackframe+0x2a>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100a5f:	83 c4 34             	add    $0x34,%esp
  100a62:	5b                   	pop    %ebx
  100a63:	5d                   	pop    %ebp
  100a64:	c3                   	ret    

00100a65 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a65:	55                   	push   %ebp
  100a66:	89 e5                	mov    %esp,%ebp
  100a68:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a72:	eb 0c                	jmp    100a80 <parse+0x1b>
            *buf ++ = '\0';
  100a74:	8b 45 08             	mov    0x8(%ebp),%eax
  100a77:	8d 50 01             	lea    0x1(%eax),%edx
  100a7a:	89 55 08             	mov    %edx,0x8(%ebp)
  100a7d:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a80:	8b 45 08             	mov    0x8(%ebp),%eax
  100a83:	0f b6 00             	movzbl (%eax),%eax
  100a86:	84 c0                	test   %al,%al
  100a88:	74 1d                	je     100aa7 <parse+0x42>
  100a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8d:	0f b6 00             	movzbl (%eax),%eax
  100a90:	0f be c0             	movsbl %al,%eax
  100a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a97:	c7 04 24 44 63 10 00 	movl   $0x106344,(%esp)
  100a9e:	e8 13 53 00 00       	call   105db6 <strchr>
  100aa3:	85 c0                	test   %eax,%eax
  100aa5:	75 cd                	jne    100a74 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  100aaa:	0f b6 00             	movzbl (%eax),%eax
  100aad:	84 c0                	test   %al,%al
  100aaf:	75 02                	jne    100ab3 <parse+0x4e>
            break;
  100ab1:	eb 67                	jmp    100b1a <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ab3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ab7:	75 14                	jne    100acd <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ab9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ac0:	00 
  100ac1:	c7 04 24 49 63 10 00 	movl   $0x106349,(%esp)
  100ac8:	e8 6f f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad0:	8d 50 01             	lea    0x1(%eax),%edx
  100ad3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ad6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100add:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ae0:	01 c2                	add    %eax,%edx
  100ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae5:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae7:	eb 04                	jmp    100aed <parse+0x88>
            buf ++;
  100ae9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100aed:	8b 45 08             	mov    0x8(%ebp),%eax
  100af0:	0f b6 00             	movzbl (%eax),%eax
  100af3:	84 c0                	test   %al,%al
  100af5:	74 1d                	je     100b14 <parse+0xaf>
  100af7:	8b 45 08             	mov    0x8(%ebp),%eax
  100afa:	0f b6 00             	movzbl (%eax),%eax
  100afd:	0f be c0             	movsbl %al,%eax
  100b00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b04:	c7 04 24 44 63 10 00 	movl   $0x106344,(%esp)
  100b0b:	e8 a6 52 00 00       	call   105db6 <strchr>
  100b10:	85 c0                	test   %eax,%eax
  100b12:	74 d5                	je     100ae9 <parse+0x84>
            buf ++;
        }
    }
  100b14:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b15:	e9 66 ff ff ff       	jmp    100a80 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b1d:	c9                   	leave  
  100b1e:	c3                   	ret    

00100b1f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b1f:	55                   	push   %ebp
  100b20:	89 e5                	mov    %esp,%ebp
  100b22:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b25:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2f:	89 04 24             	mov    %eax,(%esp)
  100b32:	e8 2e ff ff ff       	call   100a65 <parse>
  100b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b3e:	75 0a                	jne    100b4a <runcmd+0x2b>
        return 0;
  100b40:	b8 00 00 00 00       	mov    $0x0,%eax
  100b45:	e9 85 00 00 00       	jmp    100bcf <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b51:	eb 5c                	jmp    100baf <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b53:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b59:	89 d0                	mov    %edx,%eax
  100b5b:	01 c0                	add    %eax,%eax
  100b5d:	01 d0                	add    %edx,%eax
  100b5f:	c1 e0 02             	shl    $0x2,%eax
  100b62:	05 20 70 11 00       	add    $0x117020,%eax
  100b67:	8b 00                	mov    (%eax),%eax
  100b69:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b6d:	89 04 24             	mov    %eax,(%esp)
  100b70:	e8 a2 51 00 00       	call   105d17 <strcmp>
  100b75:	85 c0                	test   %eax,%eax
  100b77:	75 32                	jne    100bab <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b7c:	89 d0                	mov    %edx,%eax
  100b7e:	01 c0                	add    %eax,%eax
  100b80:	01 d0                	add    %edx,%eax
  100b82:	c1 e0 02             	shl    $0x2,%eax
  100b85:	05 20 70 11 00       	add    $0x117020,%eax
  100b8a:	8b 40 08             	mov    0x8(%eax),%eax
  100b8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b90:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b96:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b9a:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b9d:	83 c2 04             	add    $0x4,%edx
  100ba0:	89 54 24 04          	mov    %edx,0x4(%esp)
  100ba4:	89 0c 24             	mov    %ecx,(%esp)
  100ba7:	ff d0                	call   *%eax
  100ba9:	eb 24                	jmp    100bcf <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb2:	83 f8 02             	cmp    $0x2,%eax
  100bb5:	76 9c                	jbe    100b53 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bb7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bba:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bbe:	c7 04 24 67 63 10 00 	movl   $0x106367,(%esp)
  100bc5:	e8 72 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bcf:	c9                   	leave  
  100bd0:	c3                   	ret    

00100bd1 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bd1:	55                   	push   %ebp
  100bd2:	89 e5                	mov    %esp,%ebp
  100bd4:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bd7:	c7 04 24 80 63 10 00 	movl   $0x106380,(%esp)
  100bde:	e8 59 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100be3:	c7 04 24 a8 63 10 00 	movl   $0x1063a8,(%esp)
  100bea:	e8 4d f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100bef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bf3:	74 0b                	je     100c00 <kmonitor+0x2f>
        print_trapframe(tf);
  100bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf8:	89 04 24             	mov    %eax,(%esp)
  100bfb:	e8 55 0e 00 00       	call   101a55 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c00:	c7 04 24 cd 63 10 00 	movl   $0x1063cd,(%esp)
  100c07:	e8 27 f6 ff ff       	call   100233 <readline>
  100c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c13:	74 18                	je     100c2d <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c15:	8b 45 08             	mov    0x8(%ebp),%eax
  100c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c1f:	89 04 24             	mov    %eax,(%esp)
  100c22:	e8 f8 fe ff ff       	call   100b1f <runcmd>
  100c27:	85 c0                	test   %eax,%eax
  100c29:	79 02                	jns    100c2d <kmonitor+0x5c>
                break;
  100c2b:	eb 02                	jmp    100c2f <kmonitor+0x5e>
            }
        }
    }
  100c2d:	eb d1                	jmp    100c00 <kmonitor+0x2f>
}
  100c2f:	c9                   	leave  
  100c30:	c3                   	ret    

00100c31 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c31:	55                   	push   %ebp
  100c32:	89 e5                	mov    %esp,%ebp
  100c34:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c3e:	eb 3f                	jmp    100c7f <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c43:	89 d0                	mov    %edx,%eax
  100c45:	01 c0                	add    %eax,%eax
  100c47:	01 d0                	add    %edx,%eax
  100c49:	c1 e0 02             	shl    $0x2,%eax
  100c4c:	05 20 70 11 00       	add    $0x117020,%eax
  100c51:	8b 48 04             	mov    0x4(%eax),%ecx
  100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c57:	89 d0                	mov    %edx,%eax
  100c59:	01 c0                	add    %eax,%eax
  100c5b:	01 d0                	add    %edx,%eax
  100c5d:	c1 e0 02             	shl    $0x2,%eax
  100c60:	05 20 70 11 00       	add    $0x117020,%eax
  100c65:	8b 00                	mov    (%eax),%eax
  100c67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c6f:	c7 04 24 d1 63 10 00 	movl   $0x1063d1,(%esp)
  100c76:	e8 c1 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c7b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c82:	83 f8 02             	cmp    $0x2,%eax
  100c85:	76 b9                	jbe    100c40 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8c:	c9                   	leave  
  100c8d:	c3                   	ret    

00100c8e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c8e:	55                   	push   %ebp
  100c8f:	89 e5                	mov    %esp,%ebp
  100c91:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c94:	e8 d7 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9e:	c9                   	leave  
  100c9f:	c3                   	ret    

00100ca0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100ca0:	55                   	push   %ebp
  100ca1:	89 e5                	mov    %esp,%ebp
  100ca3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ca6:	e8 0f fd ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb0:	c9                   	leave  
  100cb1:	c3                   	ret    

00100cb2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cb2:	55                   	push   %ebp
  100cb3:	89 e5                	mov    %esp,%ebp
  100cb5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cb8:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cbd:	85 c0                	test   %eax,%eax
  100cbf:	74 02                	je     100cc3 <__panic+0x11>
        goto panic_dead;
  100cc1:	eb 48                	jmp    100d0b <__panic+0x59>
    }
    is_panic = 1;
  100cc3:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cca:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ccd:	8d 45 14             	lea    0x14(%ebp),%eax
  100cd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cd6:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cda:	8b 45 08             	mov    0x8(%ebp),%eax
  100cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce1:	c7 04 24 da 63 10 00 	movl   $0x1063da,(%esp)
  100ce8:	e8 4f f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf4:	8b 45 10             	mov    0x10(%ebp),%eax
  100cf7:	89 04 24             	mov    %eax,(%esp)
  100cfa:	e8 0a f6 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100cff:	c7 04 24 f6 63 10 00 	movl   $0x1063f6,(%esp)
  100d06:	e8 31 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d0b:	e8 85 09 00 00       	call   101695 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d17:	e8 b5 fe ff ff       	call   100bd1 <kmonitor>
    }
  100d1c:	eb f2                	jmp    100d10 <__panic+0x5e>

00100d1e <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d1e:	55                   	push   %ebp
  100d1f:	89 e5                	mov    %esp,%ebp
  100d21:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d24:	8d 45 14             	lea    0x14(%ebp),%eax
  100d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d31:	8b 45 08             	mov    0x8(%ebp),%eax
  100d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d38:	c7 04 24 f8 63 10 00 	movl   $0x1063f8,(%esp)
  100d3f:	e8 f8 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4b:	8b 45 10             	mov    0x10(%ebp),%eax
  100d4e:	89 04 24             	mov    %eax,(%esp)
  100d51:	e8 b3 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d56:	c7 04 24 f6 63 10 00 	movl   $0x1063f6,(%esp)
  100d5d:	e8 da f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d62:	c9                   	leave  
  100d63:	c3                   	ret    

00100d64 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d64:	55                   	push   %ebp
  100d65:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d67:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d6c:	5d                   	pop    %ebp
  100d6d:	c3                   	ret    

00100d6e <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d6e:	55                   	push   %ebp
  100d6f:	89 e5                	mov    %esp,%ebp
  100d71:	83 ec 28             	sub    $0x28,%esp
  100d74:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d7a:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d7e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d82:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d86:	ee                   	out    %al,(%dx)
  100d87:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8d:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d91:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d95:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d99:	ee                   	out    %al,(%dx)
  100d9a:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100da0:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100da4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dac:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dad:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100db4:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db7:	c7 04 24 16 64 10 00 	movl   $0x106416,(%esp)
  100dbe:	e8 79 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dc3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dca:	e8 24 09 00 00       	call   1016f3 <pic_enable>
}
  100dcf:	c9                   	leave  
  100dd0:	c3                   	ret    

00100dd1 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dd1:	55                   	push   %ebp
  100dd2:	89 e5                	mov    %esp,%ebp
  100dd4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dd7:	9c                   	pushf  
  100dd8:	58                   	pop    %eax
  100dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100ddf:	25 00 02 00 00       	and    $0x200,%eax
  100de4:	85 c0                	test   %eax,%eax
  100de6:	74 0c                	je     100df4 <__intr_save+0x23>
        intr_disable();
  100de8:	e8 a8 08 00 00       	call   101695 <intr_disable>
        return 1;
  100ded:	b8 01 00 00 00       	mov    $0x1,%eax
  100df2:	eb 05                	jmp    100df9 <__intr_save+0x28>
    }
    return 0;
  100df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df9:	c9                   	leave  
  100dfa:	c3                   	ret    

00100dfb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100dfb:	55                   	push   %ebp
  100dfc:	89 e5                	mov    %esp,%ebp
  100dfe:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e05:	74 05                	je     100e0c <__intr_restore+0x11>
        intr_enable();
  100e07:	e8 83 08 00 00       	call   10168f <intr_enable>
    }
}
  100e0c:	c9                   	leave  
  100e0d:	c3                   	ret    

00100e0e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e0e:	55                   	push   %ebp
  100e0f:	89 e5                	mov    %esp,%ebp
  100e11:	83 ec 10             	sub    $0x10,%esp
  100e14:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e1a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e1e:	89 c2                	mov    %eax,%edx
  100e20:	ec                   	in     (%dx),%al
  100e21:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e24:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e2a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e2e:	89 c2                	mov    %eax,%edx
  100e30:	ec                   	in     (%dx),%al
  100e31:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e34:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e3a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e3e:	89 c2                	mov    %eax,%edx
  100e40:	ec                   	in     (%dx),%al
  100e41:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e44:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e4a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e4e:	89 c2                	mov    %eax,%edx
  100e50:	ec                   	in     (%dx),%al
  100e51:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e54:	c9                   	leave  
  100e55:	c3                   	ret    

00100e56 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e56:	55                   	push   %ebp
  100e57:	89 e5                	mov    %esp,%ebp
  100e59:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e5c:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e66:	0f b7 00             	movzwl (%eax),%eax
  100e69:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e70:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e78:	0f b7 00             	movzwl (%eax),%eax
  100e7b:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e7f:	74 12                	je     100e93 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e81:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e88:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100e8f:	b4 03 
  100e91:	eb 13                	jmp    100ea6 <cga_init+0x50>
    } else {
        *cp = was;
  100e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e96:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e9a:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e9d:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ea4:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ea6:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ead:	0f b7 c0             	movzwl %ax,%eax
  100eb0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100eb4:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ebc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ec0:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ec1:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec8:	83 c0 01             	add    $0x1,%eax
  100ecb:	0f b7 c0             	movzwl %ax,%eax
  100ece:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ed2:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ed6:	89 c2                	mov    %eax,%edx
  100ed8:	ec                   	in     (%dx),%al
  100ed9:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100edc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ee0:	0f b6 c0             	movzbl %al,%eax
  100ee3:	c1 e0 08             	shl    $0x8,%eax
  100ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ee9:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ef0:	0f b7 c0             	movzwl %ax,%eax
  100ef3:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ef7:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100efb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f03:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f04:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f0b:	83 c0 01             	add    $0x1,%eax
  100f0e:	0f b7 c0             	movzwl %ax,%eax
  100f11:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f15:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f19:	89 c2                	mov    %eax,%edx
  100f1b:	ec                   	in     (%dx),%al
  100f1c:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f1f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f23:	0f b6 c0             	movzbl %al,%eax
  100f26:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f2c:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f34:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f3a:	c9                   	leave  
  100f3b:	c3                   	ret    

00100f3c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f3c:	55                   	push   %ebp
  100f3d:	89 e5                	mov    %esp,%ebp
  100f3f:	83 ec 48             	sub    $0x48,%esp
  100f42:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f48:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f4c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f50:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f54:	ee                   	out    %al,(%dx)
  100f55:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f5b:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f5f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f63:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f67:	ee                   	out    %al,(%dx)
  100f68:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f6e:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f72:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f76:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f7a:	ee                   	out    %al,(%dx)
  100f7b:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f81:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f85:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f89:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f8d:	ee                   	out    %al,(%dx)
  100f8e:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f94:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f98:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f9c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fa0:	ee                   	out    %al,(%dx)
  100fa1:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fa7:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fab:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100faf:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fb3:	ee                   	out    %al,(%dx)
  100fb4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fba:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fbe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fc2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fc6:	ee                   	out    %al,(%dx)
  100fc7:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fcd:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fd1:	89 c2                	mov    %eax,%edx
  100fd3:	ec                   	in     (%dx),%al
  100fd4:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fd7:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fdb:	3c ff                	cmp    $0xff,%al
  100fdd:	0f 95 c0             	setne  %al
  100fe0:	0f b6 c0             	movzbl %al,%eax
  100fe3:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100fe8:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fee:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100ff2:	89 c2                	mov    %eax,%edx
  100ff4:	ec                   	in     (%dx),%al
  100ff5:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100ff8:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100ffe:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101002:	89 c2                	mov    %eax,%edx
  101004:	ec                   	in     (%dx),%al
  101005:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101008:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10100d:	85 c0                	test   %eax,%eax
  10100f:	74 0c                	je     10101d <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101011:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101018:	e8 d6 06 00 00       	call   1016f3 <pic_enable>
    }
}
  10101d:	c9                   	leave  
  10101e:	c3                   	ret    

0010101f <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10101f:	55                   	push   %ebp
  101020:	89 e5                	mov    %esp,%ebp
  101022:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101025:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10102c:	eb 09                	jmp    101037 <lpt_putc_sub+0x18>
        delay();
  10102e:	e8 db fd ff ff       	call   100e0e <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101033:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101037:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10103d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101041:	89 c2                	mov    %eax,%edx
  101043:	ec                   	in     (%dx),%al
  101044:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101047:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10104b:	84 c0                	test   %al,%al
  10104d:	78 09                	js     101058 <lpt_putc_sub+0x39>
  10104f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101056:	7e d6                	jle    10102e <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101058:	8b 45 08             	mov    0x8(%ebp),%eax
  10105b:	0f b6 c0             	movzbl %al,%eax
  10105e:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101064:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101067:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10106b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10106f:	ee                   	out    %al,(%dx)
  101070:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101076:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10107a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10107e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101082:	ee                   	out    %al,(%dx)
  101083:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101089:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10108d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101091:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101095:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101096:	c9                   	leave  
  101097:	c3                   	ret    

00101098 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101098:	55                   	push   %ebp
  101099:	89 e5                	mov    %esp,%ebp
  10109b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10109e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010a2:	74 0d                	je     1010b1 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a7:	89 04 24             	mov    %eax,(%esp)
  1010aa:	e8 70 ff ff ff       	call   10101f <lpt_putc_sub>
  1010af:	eb 24                	jmp    1010d5 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010b1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010b8:	e8 62 ff ff ff       	call   10101f <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010bd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010c4:	e8 56 ff ff ff       	call   10101f <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010c9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d0:	e8 4a ff ff ff       	call   10101f <lpt_putc_sub>
    }
}
  1010d5:	c9                   	leave  
  1010d6:	c3                   	ret    

001010d7 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010d7:	55                   	push   %ebp
  1010d8:	89 e5                	mov    %esp,%ebp
  1010da:	53                   	push   %ebx
  1010db:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010de:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e1:	b0 00                	mov    $0x0,%al
  1010e3:	85 c0                	test   %eax,%eax
  1010e5:	75 07                	jne    1010ee <cga_putc+0x17>
        c |= 0x0700;
  1010e7:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f1:	0f b6 c0             	movzbl %al,%eax
  1010f4:	83 f8 0a             	cmp    $0xa,%eax
  1010f7:	74 4c                	je     101145 <cga_putc+0x6e>
  1010f9:	83 f8 0d             	cmp    $0xd,%eax
  1010fc:	74 57                	je     101155 <cga_putc+0x7e>
  1010fe:	83 f8 08             	cmp    $0x8,%eax
  101101:	0f 85 88 00 00 00    	jne    10118f <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101107:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10110e:	66 85 c0             	test   %ax,%ax
  101111:	74 30                	je     101143 <cga_putc+0x6c>
            crt_pos --;
  101113:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10111a:	83 e8 01             	sub    $0x1,%eax
  10111d:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101123:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101128:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10112f:	0f b7 d2             	movzwl %dx,%edx
  101132:	01 d2                	add    %edx,%edx
  101134:	01 c2                	add    %eax,%edx
  101136:	8b 45 08             	mov    0x8(%ebp),%eax
  101139:	b0 00                	mov    $0x0,%al
  10113b:	83 c8 20             	or     $0x20,%eax
  10113e:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101141:	eb 72                	jmp    1011b5 <cga_putc+0xde>
  101143:	eb 70                	jmp    1011b5 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101145:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10114c:	83 c0 50             	add    $0x50,%eax
  10114f:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101155:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  10115c:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101163:	0f b7 c1             	movzwl %cx,%eax
  101166:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10116c:	c1 e8 10             	shr    $0x10,%eax
  10116f:	89 c2                	mov    %eax,%edx
  101171:	66 c1 ea 06          	shr    $0x6,%dx
  101175:	89 d0                	mov    %edx,%eax
  101177:	c1 e0 02             	shl    $0x2,%eax
  10117a:	01 d0                	add    %edx,%eax
  10117c:	c1 e0 04             	shl    $0x4,%eax
  10117f:	29 c1                	sub    %eax,%ecx
  101181:	89 ca                	mov    %ecx,%edx
  101183:	89 d8                	mov    %ebx,%eax
  101185:	29 d0                	sub    %edx,%eax
  101187:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  10118d:	eb 26                	jmp    1011b5 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10118f:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  101195:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10119c:	8d 50 01             	lea    0x1(%eax),%edx
  10119f:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011a6:	0f b7 c0             	movzwl %ax,%eax
  1011a9:	01 c0                	add    %eax,%eax
  1011ab:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1011b1:	66 89 02             	mov    %ax,(%edx)
        break;
  1011b4:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011b5:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011bc:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011c0:	76 5b                	jbe    10121d <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011c2:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011c7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011cd:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011d2:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011d9:	00 
  1011da:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011de:	89 04 24             	mov    %eax,(%esp)
  1011e1:	e8 ce 4d 00 00       	call   105fb4 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011e6:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011ed:	eb 15                	jmp    101204 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011ef:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011f7:	01 d2                	add    %edx,%edx
  1011f9:	01 d0                	add    %edx,%eax
  1011fb:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101200:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101204:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10120b:	7e e2                	jle    1011ef <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10120d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101214:	83 e8 50             	sub    $0x50,%eax
  101217:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10121d:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101224:	0f b7 c0             	movzwl %ax,%eax
  101227:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10122b:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10122f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101233:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101237:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101238:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10123f:	66 c1 e8 08          	shr    $0x8,%ax
  101243:	0f b6 c0             	movzbl %al,%eax
  101246:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10124d:	83 c2 01             	add    $0x1,%edx
  101250:	0f b7 d2             	movzwl %dx,%edx
  101253:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101257:	88 45 ed             	mov    %al,-0x13(%ebp)
  10125a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10125e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101262:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101263:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10126a:	0f b7 c0             	movzwl %ax,%eax
  10126d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101271:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101275:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101279:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10127d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10127e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101285:	0f b6 c0             	movzbl %al,%eax
  101288:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10128f:	83 c2 01             	add    $0x1,%edx
  101292:	0f b7 d2             	movzwl %dx,%edx
  101295:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101299:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10129c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012a0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012a4:	ee                   	out    %al,(%dx)
}
  1012a5:	83 c4 34             	add    $0x34,%esp
  1012a8:	5b                   	pop    %ebx
  1012a9:	5d                   	pop    %ebp
  1012aa:	c3                   	ret    

001012ab <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012ab:	55                   	push   %ebp
  1012ac:	89 e5                	mov    %esp,%ebp
  1012ae:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012b8:	eb 09                	jmp    1012c3 <serial_putc_sub+0x18>
        delay();
  1012ba:	e8 4f fb ff ff       	call   100e0e <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012c3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012c9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012cd:	89 c2                	mov    %eax,%edx
  1012cf:	ec                   	in     (%dx),%al
  1012d0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012d3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012d7:	0f b6 c0             	movzbl %al,%eax
  1012da:	83 e0 20             	and    $0x20,%eax
  1012dd:	85 c0                	test   %eax,%eax
  1012df:	75 09                	jne    1012ea <serial_putc_sub+0x3f>
  1012e1:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012e8:	7e d0                	jle    1012ba <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ed:	0f b6 c0             	movzbl %al,%eax
  1012f0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012f6:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012f9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012fd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101301:	ee                   	out    %al,(%dx)
}
  101302:	c9                   	leave  
  101303:	c3                   	ret    

00101304 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101304:	55                   	push   %ebp
  101305:	89 e5                	mov    %esp,%ebp
  101307:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10130a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10130e:	74 0d                	je     10131d <serial_putc+0x19>
        serial_putc_sub(c);
  101310:	8b 45 08             	mov    0x8(%ebp),%eax
  101313:	89 04 24             	mov    %eax,(%esp)
  101316:	e8 90 ff ff ff       	call   1012ab <serial_putc_sub>
  10131b:	eb 24                	jmp    101341 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10131d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101324:	e8 82 ff ff ff       	call   1012ab <serial_putc_sub>
        serial_putc_sub(' ');
  101329:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101330:	e8 76 ff ff ff       	call   1012ab <serial_putc_sub>
        serial_putc_sub('\b');
  101335:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133c:	e8 6a ff ff ff       	call   1012ab <serial_putc_sub>
    }
}
  101341:	c9                   	leave  
  101342:	c3                   	ret    

00101343 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101343:	55                   	push   %ebp
  101344:	89 e5                	mov    %esp,%ebp
  101346:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101349:	eb 33                	jmp    10137e <cons_intr+0x3b>
        if (c != 0) {
  10134b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10134f:	74 2d                	je     10137e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101351:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101356:	8d 50 01             	lea    0x1(%eax),%edx
  101359:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10135f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101362:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101368:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10136d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101372:	75 0a                	jne    10137e <cons_intr+0x3b>
                cons.wpos = 0;
  101374:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10137b:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10137e:	8b 45 08             	mov    0x8(%ebp),%eax
  101381:	ff d0                	call   *%eax
  101383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101386:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10138a:	75 bf                	jne    10134b <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10138c:	c9                   	leave  
  10138d:	c3                   	ret    

0010138e <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10138e:	55                   	push   %ebp
  10138f:	89 e5                	mov    %esp,%ebp
  101391:	83 ec 10             	sub    $0x10,%esp
  101394:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10139a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10139e:	89 c2                	mov    %eax,%edx
  1013a0:	ec                   	in     (%dx),%al
  1013a1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013a4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013a8:	0f b6 c0             	movzbl %al,%eax
  1013ab:	83 e0 01             	and    $0x1,%eax
  1013ae:	85 c0                	test   %eax,%eax
  1013b0:	75 07                	jne    1013b9 <serial_proc_data+0x2b>
        return -1;
  1013b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013b7:	eb 2a                	jmp    1013e3 <serial_proc_data+0x55>
  1013b9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013bf:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013c3:	89 c2                	mov    %eax,%edx
  1013c5:	ec                   	in     (%dx),%al
  1013c6:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013c9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013cd:	0f b6 c0             	movzbl %al,%eax
  1013d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013d3:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013d7:	75 07                	jne    1013e0 <serial_proc_data+0x52>
        c = '\b';
  1013d9:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013e3:	c9                   	leave  
  1013e4:	c3                   	ret    

001013e5 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013e5:	55                   	push   %ebp
  1013e6:	89 e5                	mov    %esp,%ebp
  1013e8:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013eb:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1013f0:	85 c0                	test   %eax,%eax
  1013f2:	74 0c                	je     101400 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013f4:	c7 04 24 8e 13 10 00 	movl   $0x10138e,(%esp)
  1013fb:	e8 43 ff ff ff       	call   101343 <cons_intr>
    }
}
  101400:	c9                   	leave  
  101401:	c3                   	ret    

00101402 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101402:	55                   	push   %ebp
  101403:	89 e5                	mov    %esp,%ebp
  101405:	83 ec 38             	sub    $0x38,%esp
  101408:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10140e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101412:	89 c2                	mov    %eax,%edx
  101414:	ec                   	in     (%dx),%al
  101415:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101418:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10141c:	0f b6 c0             	movzbl %al,%eax
  10141f:	83 e0 01             	and    $0x1,%eax
  101422:	85 c0                	test   %eax,%eax
  101424:	75 0a                	jne    101430 <kbd_proc_data+0x2e>
        return -1;
  101426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10142b:	e9 59 01 00 00       	jmp    101589 <kbd_proc_data+0x187>
  101430:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101436:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10143a:	89 c2                	mov    %eax,%edx
  10143c:	ec                   	in     (%dx),%al
  10143d:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101440:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101444:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101447:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10144b:	75 17                	jne    101464 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10144d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101452:	83 c8 40             	or     $0x40,%eax
  101455:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10145a:	b8 00 00 00 00       	mov    $0x0,%eax
  10145f:	e9 25 01 00 00       	jmp    101589 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101464:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101468:	84 c0                	test   %al,%al
  10146a:	79 47                	jns    1014b3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10146c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101471:	83 e0 40             	and    $0x40,%eax
  101474:	85 c0                	test   %eax,%eax
  101476:	75 09                	jne    101481 <kbd_proc_data+0x7f>
  101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147c:	83 e0 7f             	and    $0x7f,%eax
  10147f:	eb 04                	jmp    101485 <kbd_proc_data+0x83>
  101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101485:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101488:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148c:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101493:	83 c8 40             	or     $0x40,%eax
  101496:	0f b6 c0             	movzbl %al,%eax
  101499:	f7 d0                	not    %eax
  10149b:	89 c2                	mov    %eax,%edx
  10149d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014a2:	21 d0                	and    %edx,%eax
  1014a4:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014a9:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ae:	e9 d6 00 00 00       	jmp    101589 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014b3:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b8:	83 e0 40             	and    $0x40,%eax
  1014bb:	85 c0                	test   %eax,%eax
  1014bd:	74 11                	je     1014d0 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014bf:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014c3:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014c8:	83 e0 bf             	and    $0xffffffbf,%eax
  1014cb:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014d0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d4:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014db:	0f b6 d0             	movzbl %al,%edx
  1014de:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e3:	09 d0                	or     %edx,%eax
  1014e5:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ee:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  1014f5:	0f b6 d0             	movzbl %al,%edx
  1014f8:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014fd:	31 d0                	xor    %edx,%eax
  1014ff:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101504:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101509:	83 e0 03             	and    $0x3,%eax
  10150c:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101513:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101517:	01 d0                	add    %edx,%eax
  101519:	0f b6 00             	movzbl (%eax),%eax
  10151c:	0f b6 c0             	movzbl %al,%eax
  10151f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101522:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101527:	83 e0 08             	and    $0x8,%eax
  10152a:	85 c0                	test   %eax,%eax
  10152c:	74 22                	je     101550 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10152e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101532:	7e 0c                	jle    101540 <kbd_proc_data+0x13e>
  101534:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101538:	7f 06                	jg     101540 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10153a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10153e:	eb 10                	jmp    101550 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101540:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101544:	7e 0a                	jle    101550 <kbd_proc_data+0x14e>
  101546:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10154a:	7f 04                	jg     101550 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10154c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101550:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101555:	f7 d0                	not    %eax
  101557:	83 e0 06             	and    $0x6,%eax
  10155a:	85 c0                	test   %eax,%eax
  10155c:	75 28                	jne    101586 <kbd_proc_data+0x184>
  10155e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101565:	75 1f                	jne    101586 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101567:	c7 04 24 31 64 10 00 	movl   $0x106431,(%esp)
  10156e:	e8 c9 ed ff ff       	call   10033c <cprintf>
  101573:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101579:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10157d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101581:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101585:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101586:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101589:	c9                   	leave  
  10158a:	c3                   	ret    

0010158b <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10158b:	55                   	push   %ebp
  10158c:	89 e5                	mov    %esp,%ebp
  10158e:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101591:	c7 04 24 02 14 10 00 	movl   $0x101402,(%esp)
  101598:	e8 a6 fd ff ff       	call   101343 <cons_intr>
}
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <kbd_init>:

static void
kbd_init(void) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015a5:	e8 e1 ff ff ff       	call   10158b <kbd_intr>
    pic_enable(IRQ_KBD);
  1015aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015b1:	e8 3d 01 00 00       	call   1016f3 <pic_enable>
}
  1015b6:	c9                   	leave  
  1015b7:	c3                   	ret    

001015b8 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015b8:	55                   	push   %ebp
  1015b9:	89 e5                	mov    %esp,%ebp
  1015bb:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015be:	e8 93 f8 ff ff       	call   100e56 <cga_init>
    serial_init();
  1015c3:	e8 74 f9 ff ff       	call   100f3c <serial_init>
    kbd_init();
  1015c8:	e8 d2 ff ff ff       	call   10159f <kbd_init>
    if (!serial_exists) {
  1015cd:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015d2:	85 c0                	test   %eax,%eax
  1015d4:	75 0c                	jne    1015e2 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015d6:	c7 04 24 3d 64 10 00 	movl   $0x10643d,(%esp)
  1015dd:	e8 5a ed ff ff       	call   10033c <cprintf>
    }
}
  1015e2:	c9                   	leave  
  1015e3:	c3                   	ret    

001015e4 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015e4:	55                   	push   %ebp
  1015e5:	89 e5                	mov    %esp,%ebp
  1015e7:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015ea:	e8 e2 f7 ff ff       	call   100dd1 <__intr_save>
  1015ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015f5:	89 04 24             	mov    %eax,(%esp)
  1015f8:	e8 9b fa ff ff       	call   101098 <lpt_putc>
        cga_putc(c);
  1015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101600:	89 04 24             	mov    %eax,(%esp)
  101603:	e8 cf fa ff ff       	call   1010d7 <cga_putc>
        serial_putc(c);
  101608:	8b 45 08             	mov    0x8(%ebp),%eax
  10160b:	89 04 24             	mov    %eax,(%esp)
  10160e:	e8 f1 fc ff ff       	call   101304 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101616:	89 04 24             	mov    %eax,(%esp)
  101619:	e8 dd f7 ff ff       	call   100dfb <__intr_restore>
}
  10161e:	c9                   	leave  
  10161f:	c3                   	ret    

00101620 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101620:	55                   	push   %ebp
  101621:	89 e5                	mov    %esp,%ebp
  101623:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101626:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10162d:	e8 9f f7 ff ff       	call   100dd1 <__intr_save>
  101632:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101635:	e8 ab fd ff ff       	call   1013e5 <serial_intr>
        kbd_intr();
  10163a:	e8 4c ff ff ff       	call   10158b <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10163f:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101645:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10164a:	39 c2                	cmp    %eax,%edx
  10164c:	74 31                	je     10167f <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10164e:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101653:	8d 50 01             	lea    0x1(%eax),%edx
  101656:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  10165c:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101663:	0f b6 c0             	movzbl %al,%eax
  101666:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101669:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10166e:	3d 00 02 00 00       	cmp    $0x200,%eax
  101673:	75 0a                	jne    10167f <cons_getc+0x5f>
                cons.rpos = 0;
  101675:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  10167c:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101682:	89 04 24             	mov    %eax,(%esp)
  101685:	e8 71 f7 ff ff       	call   100dfb <__intr_restore>
    return c;
  10168a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10168d:	c9                   	leave  
  10168e:	c3                   	ret    

0010168f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10168f:	55                   	push   %ebp
  101690:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  101692:	fb                   	sti    
    sti();
}
  101693:	5d                   	pop    %ebp
  101694:	c3                   	ret    

00101695 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101695:	55                   	push   %ebp
  101696:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101698:	fa                   	cli    
    cli();
}
  101699:	5d                   	pop    %ebp
  10169a:	c3                   	ret    

0010169b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10169b:	55                   	push   %ebp
  10169c:	89 e5                	mov    %esp,%ebp
  10169e:	83 ec 14             	sub    $0x14,%esp
  1016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016a8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ac:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016b2:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016b7:	85 c0                	test   %eax,%eax
  1016b9:	74 36                	je     1016f1 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016bb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016bf:	0f b6 c0             	movzbl %al,%eax
  1016c2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c8:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016cb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016cf:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016d3:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016d4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d8:	66 c1 e8 08          	shr    $0x8,%ax
  1016dc:	0f b6 c0             	movzbl %al,%eax
  1016df:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016e5:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016e8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016ec:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f0:	ee                   	out    %al,(%dx)
    }
}
  1016f1:	c9                   	leave  
  1016f2:	c3                   	ret    

001016f3 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016f3:	55                   	push   %ebp
  1016f4:	89 e5                	mov    %esp,%ebp
  1016f6:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1016fc:	ba 01 00 00 00       	mov    $0x1,%edx
  101701:	89 c1                	mov    %eax,%ecx
  101703:	d3 e2                	shl    %cl,%edx
  101705:	89 d0                	mov    %edx,%eax
  101707:	f7 d0                	not    %eax
  101709:	89 c2                	mov    %eax,%edx
  10170b:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101712:	21 d0                	and    %edx,%eax
  101714:	0f b7 c0             	movzwl %ax,%eax
  101717:	89 04 24             	mov    %eax,(%esp)
  10171a:	e8 7c ff ff ff       	call   10169b <pic_setmask>
}
  10171f:	c9                   	leave  
  101720:	c3                   	ret    

00101721 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101721:	55                   	push   %ebp
  101722:	89 e5                	mov    %esp,%ebp
  101724:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101727:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  10172e:	00 00 00 
  101731:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101737:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10173b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10173f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101743:	ee                   	out    %al,(%dx)
  101744:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10174a:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10174e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101752:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101756:	ee                   	out    %al,(%dx)
  101757:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10175d:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101761:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101765:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101769:	ee                   	out    %al,(%dx)
  10176a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101770:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101774:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101778:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10177c:	ee                   	out    %al,(%dx)
  10177d:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101783:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101787:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10178b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
  101790:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101796:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10179a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10179e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017a2:	ee                   	out    %al,(%dx)
  1017a3:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017a9:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017ad:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017b1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017b5:	ee                   	out    %al,(%dx)
  1017b6:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017bc:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017c0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017c4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017c8:	ee                   	out    %al,(%dx)
  1017c9:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017cf:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017d3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017d7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017db:	ee                   	out    %al,(%dx)
  1017dc:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017e2:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017e6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017ea:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017ee:	ee                   	out    %al,(%dx)
  1017ef:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  1017f5:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1017f9:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017fd:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101801:	ee                   	out    %al,(%dx)
  101802:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101808:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10180c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101810:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101814:	ee                   	out    %al,(%dx)
  101815:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10181b:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10181f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101823:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101827:	ee                   	out    %al,(%dx)
  101828:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10182e:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101832:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101836:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10183a:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10183b:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101842:	66 83 f8 ff          	cmp    $0xffff,%ax
  101846:	74 12                	je     10185a <pic_init+0x139>
        pic_setmask(irq_mask);
  101848:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10184f:	0f b7 c0             	movzwl %ax,%eax
  101852:	89 04 24             	mov    %eax,(%esp)
  101855:	e8 41 fe ff ff       	call   10169b <pic_setmask>
    }
}
  10185a:	c9                   	leave  
  10185b:	c3                   	ret    

0010185c <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  10185c:	55                   	push   %ebp
  10185d:	89 e5                	mov    %esp,%ebp
  10185f:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101862:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101869:	00 
  10186a:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
  101871:	e8 c6 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101876:	c7 04 24 6a 64 10 00 	movl   $0x10646a,(%esp)
  10187d:	e8 ba ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  101882:	c7 44 24 08 78 64 10 	movl   $0x106478,0x8(%esp)
  101889:	00 
  10188a:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101891:	00 
  101892:	c7 04 24 8e 64 10 00 	movl   $0x10648e,(%esp)
  101899:	e8 14 f4 ff ff       	call   100cb2 <__panic>

0010189e <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10189e:	55                   	push   %ebp
  10189f:	89 e5                	mov    %esp,%ebp
  1018a1:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i ++) {
  1018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018ab:	e9 c3 00 00 00       	jmp    101973 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b3:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018ba:	89 c2                	mov    %eax,%edx
  1018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bf:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018c6:	00 
  1018c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ca:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018d1:	00 08 00 
  1018d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d7:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018de:	00 
  1018df:	83 e2 e0             	and    $0xffffffe0,%edx
  1018e2:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ec:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018f3:	00 
  1018f4:	83 e2 1f             	and    $0x1f,%edx
  1018f7:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101901:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101908:	00 
  101909:	83 e2 f0             	and    $0xfffffff0,%edx
  10190c:	83 ca 0e             	or     $0xe,%edx
  10190f:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101919:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101920:	00 
  101921:	83 e2 ef             	and    $0xffffffef,%edx
  101924:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101935:	00 
  101936:	83 e2 9f             	and    $0xffffff9f,%edx
  101939:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101940:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101943:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10194a:	00 
  10194b:	83 ca 80             	or     $0xffffff80,%edx
  10194e:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101955:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101958:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10195f:	c1 e8 10             	shr    $0x10,%eax
  101962:	89 c2                	mov    %eax,%edx
  101964:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101967:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10196e:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i ++) {
  10196f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101973:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10197a:	0f 8e 30 ff ff ff    	jle    1018b0 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101980:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101985:	66 a3 88 84 11 00    	mov    %ax,0x118488
  10198b:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  101992:	08 00 
  101994:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  10199b:	83 e0 e0             	and    $0xffffffe0,%eax
  10199e:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019a3:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019aa:	83 e0 1f             	and    $0x1f,%eax
  1019ad:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019b2:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019b9:	83 e0 f0             	and    $0xfffffff0,%eax
  1019bc:	83 c8 0e             	or     $0xe,%eax
  1019bf:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019c4:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019cb:	83 e0 ef             	and    $0xffffffef,%eax
  1019ce:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019d3:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019da:	83 c8 60             	or     $0x60,%eax
  1019dd:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019e2:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019e9:	83 c8 80             	or     $0xffffff80,%eax
  1019ec:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019f1:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019f6:	c1 e8 10             	shr    $0x10,%eax
  1019f9:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019ff:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a09:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101a0c:	c9                   	leave  
  101a0d:	c3                   	ret    

00101a0e <trapname>:

static const char *
trapname(int trapno) {
  101a0e:	55                   	push   %ebp
  101a0f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a11:	8b 45 08             	mov    0x8(%ebp),%eax
  101a14:	83 f8 13             	cmp    $0x13,%eax
  101a17:	77 0c                	ja     101a25 <trapname+0x17>
        return excnames[trapno];
  101a19:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1c:	8b 04 85 e0 67 10 00 	mov    0x1067e0(,%eax,4),%eax
  101a23:	eb 18                	jmp    101a3d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a25:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a29:	7e 0d                	jle    101a38 <trapname+0x2a>
  101a2b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a2f:	7f 07                	jg     101a38 <trapname+0x2a>
        return "Hardware Interrupt";
  101a31:	b8 9f 64 10 00       	mov    $0x10649f,%eax
  101a36:	eb 05                	jmp    101a3d <trapname+0x2f>
    }
    return "(unknown trap)";
  101a38:	b8 b2 64 10 00       	mov    $0x1064b2,%eax
}
  101a3d:	5d                   	pop    %ebp
  101a3e:	c3                   	ret    

00101a3f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a3f:	55                   	push   %ebp
  101a40:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a42:	8b 45 08             	mov    0x8(%ebp),%eax
  101a45:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a49:	66 83 f8 08          	cmp    $0x8,%ax
  101a4d:	0f 94 c0             	sete   %al
  101a50:	0f b6 c0             	movzbl %al,%eax
}
  101a53:	5d                   	pop    %ebp
  101a54:	c3                   	ret    

00101a55 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a55:	55                   	push   %ebp
  101a56:	89 e5                	mov    %esp,%ebp
  101a58:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a62:	c7 04 24 f3 64 10 00 	movl   $0x1064f3,(%esp)
  101a69:	e8 ce e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a71:	89 04 24             	mov    %eax,(%esp)
  101a74:	e8 a1 01 00 00       	call   101c1a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a79:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a80:	0f b7 c0             	movzwl %ax,%eax
  101a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a87:	c7 04 24 04 65 10 00 	movl   $0x106504,(%esp)
  101a8e:	e8 a9 e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a93:	8b 45 08             	mov    0x8(%ebp),%eax
  101a96:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a9a:	0f b7 c0             	movzwl %ax,%eax
  101a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa1:	c7 04 24 17 65 10 00 	movl   $0x106517,(%esp)
  101aa8:	e8 8f e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aad:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab0:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ab4:	0f b7 c0             	movzwl %ax,%eax
  101ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abb:	c7 04 24 2a 65 10 00 	movl   $0x10652a,(%esp)
  101ac2:	e8 75 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aca:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ace:	0f b7 c0             	movzwl %ax,%eax
  101ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad5:	c7 04 24 3d 65 10 00 	movl   $0x10653d,(%esp)
  101adc:	e8 5b e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae4:	8b 40 30             	mov    0x30(%eax),%eax
  101ae7:	89 04 24             	mov    %eax,(%esp)
  101aea:	e8 1f ff ff ff       	call   101a0e <trapname>
  101aef:	8b 55 08             	mov    0x8(%ebp),%edx
  101af2:	8b 52 30             	mov    0x30(%edx),%edx
  101af5:	89 44 24 08          	mov    %eax,0x8(%esp)
  101af9:	89 54 24 04          	mov    %edx,0x4(%esp)
  101afd:	c7 04 24 50 65 10 00 	movl   $0x106550,(%esp)
  101b04:	e8 33 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b09:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0c:	8b 40 34             	mov    0x34(%eax),%eax
  101b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b13:	c7 04 24 62 65 10 00 	movl   $0x106562,(%esp)
  101b1a:	e8 1d e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b22:	8b 40 38             	mov    0x38(%eax),%eax
  101b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b29:	c7 04 24 71 65 10 00 	movl   $0x106571,(%esp)
  101b30:	e8 07 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b35:	8b 45 08             	mov    0x8(%ebp),%eax
  101b38:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b3c:	0f b7 c0             	movzwl %ax,%eax
  101b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b43:	c7 04 24 80 65 10 00 	movl   $0x106580,(%esp)
  101b4a:	e8 ed e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b52:	8b 40 40             	mov    0x40(%eax),%eax
  101b55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b59:	c7 04 24 93 65 10 00 	movl   $0x106593,(%esp)
  101b60:	e8 d7 e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b6c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b73:	eb 3e                	jmp    101bb3 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b75:	8b 45 08             	mov    0x8(%ebp),%eax
  101b78:	8b 50 40             	mov    0x40(%eax),%edx
  101b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b7e:	21 d0                	and    %edx,%eax
  101b80:	85 c0                	test   %eax,%eax
  101b82:	74 28                	je     101bac <print_trapframe+0x157>
  101b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b87:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b8e:	85 c0                	test   %eax,%eax
  101b90:	74 1a                	je     101bac <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b95:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba0:	c7 04 24 a2 65 10 00 	movl   $0x1065a2,(%esp)
  101ba7:	e8 90 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bb0:	d1 65 f0             	shll   -0x10(%ebp)
  101bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb6:	83 f8 17             	cmp    $0x17,%eax
  101bb9:	76 ba                	jbe    101b75 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	8b 40 40             	mov    0x40(%eax),%eax
  101bc1:	25 00 30 00 00       	and    $0x3000,%eax
  101bc6:	c1 e8 0c             	shr    $0xc,%eax
  101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcd:	c7 04 24 a6 65 10 00 	movl   $0x1065a6,(%esp)
  101bd4:	e8 63 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdc:	89 04 24             	mov    %eax,(%esp)
  101bdf:	e8 5b fe ff ff       	call   101a3f <trap_in_kernel>
  101be4:	85 c0                	test   %eax,%eax
  101be6:	75 30                	jne    101c18 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101be8:	8b 45 08             	mov    0x8(%ebp),%eax
  101beb:	8b 40 44             	mov    0x44(%eax),%eax
  101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf2:	c7 04 24 af 65 10 00 	movl   $0x1065af,(%esp)
  101bf9:	e8 3e e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101c01:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c05:	0f b7 c0             	movzwl %ax,%eax
  101c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0c:	c7 04 24 be 65 10 00 	movl   $0x1065be,(%esp)
  101c13:	e8 24 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c18:	c9                   	leave  
  101c19:	c3                   	ret    

00101c1a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c1a:	55                   	push   %ebp
  101c1b:	89 e5                	mov    %esp,%ebp
  101c1d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c20:	8b 45 08             	mov    0x8(%ebp),%eax
  101c23:	8b 00                	mov    (%eax),%eax
  101c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c29:	c7 04 24 d1 65 10 00 	movl   $0x1065d1,(%esp)
  101c30:	e8 07 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c35:	8b 45 08             	mov    0x8(%ebp),%eax
  101c38:	8b 40 04             	mov    0x4(%eax),%eax
  101c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3f:	c7 04 24 e0 65 10 00 	movl   $0x1065e0,(%esp)
  101c46:	e8 f1 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4e:	8b 40 08             	mov    0x8(%eax),%eax
  101c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c55:	c7 04 24 ef 65 10 00 	movl   $0x1065ef,(%esp)
  101c5c:	e8 db e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c61:	8b 45 08             	mov    0x8(%ebp),%eax
  101c64:	8b 40 0c             	mov    0xc(%eax),%eax
  101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6b:	c7 04 24 fe 65 10 00 	movl   $0x1065fe,(%esp)
  101c72:	e8 c5 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c77:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7a:	8b 40 10             	mov    0x10(%eax),%eax
  101c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c81:	c7 04 24 0d 66 10 00 	movl   $0x10660d,(%esp)
  101c88:	e8 af e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c90:	8b 40 14             	mov    0x14(%eax),%eax
  101c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c97:	c7 04 24 1c 66 10 00 	movl   $0x10661c,(%esp)
  101c9e:	e8 99 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca6:	8b 40 18             	mov    0x18(%eax),%eax
  101ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cad:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  101cb4:	e8 83 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbc:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc3:	c7 04 24 3a 66 10 00 	movl   $0x10663a,(%esp)
  101cca:	e8 6d e6 ff ff       	call   10033c <cprintf>
}
  101ccf:	c9                   	leave  
  101cd0:	c3                   	ret    

00101cd1 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cd1:	55                   	push   %ebp
  101cd2:	89 e5                	mov    %esp,%ebp
  101cd4:	57                   	push   %edi
  101cd5:	56                   	push   %esi
  101cd6:	53                   	push   %ebx
  101cd7:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101cda:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdd:	8b 40 30             	mov    0x30(%eax),%eax
  101ce0:	83 f8 2f             	cmp    $0x2f,%eax
  101ce3:	77 21                	ja     101d06 <trap_dispatch+0x35>
  101ce5:	83 f8 2e             	cmp    $0x2e,%eax
  101ce8:	0f 83 e4 01 00 00    	jae    101ed2 <trap_dispatch+0x201>
  101cee:	83 f8 21             	cmp    $0x21,%eax
  101cf1:	0f 84 82 00 00 00    	je     101d79 <trap_dispatch+0xa8>
  101cf7:	83 f8 24             	cmp    $0x24,%eax
  101cfa:	74 54                	je     101d50 <trap_dispatch+0x7f>
  101cfc:	83 f8 20             	cmp    $0x20,%eax
  101cff:	74 1c                	je     101d1d <trap_dispatch+0x4c>
  101d01:	e9 94 01 00 00       	jmp    101e9a <trap_dispatch+0x1c9>
  101d06:	83 f8 78             	cmp    $0x78,%eax
  101d09:	0f 84 93 00 00 00    	je     101da2 <trap_dispatch+0xd1>
  101d0f:	83 f8 79             	cmp    $0x79,%eax
  101d12:	0f 84 09 01 00 00    	je     101e21 <trap_dispatch+0x150>
  101d18:	e9 7d 01 00 00       	jmp    101e9a <trap_dispatch+0x1c9>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d1d:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d22:	83 c0 01             	add    $0x1,%eax
  101d25:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks==TICK_NUM ) {
  101d2a:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d2f:	83 f8 64             	cmp    $0x64,%eax
  101d32:	75 17                	jne    101d4b <trap_dispatch+0x7a>
            ticks-=TICK_NUM;
  101d34:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d39:	83 e8 64             	sub    $0x64,%eax
  101d3c:	a3 4c 89 11 00       	mov    %eax,0x11894c
            print_ticks();
  101d41:	e8 16 fb ff ff       	call   10185c <print_ticks>
        }
        break;
  101d46:	e9 88 01 00 00       	jmp    101ed3 <trap_dispatch+0x202>
  101d4b:	e9 83 01 00 00       	jmp    101ed3 <trap_dispatch+0x202>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d50:	e8 cb f8 ff ff       	call   101620 <cons_getc>
  101d55:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d58:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d5c:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d60:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d68:	c7 04 24 49 66 10 00 	movl   $0x106649,(%esp)
  101d6f:	e8 c8 e5 ff ff       	call   10033c <cprintf>
        break;
  101d74:	e9 5a 01 00 00       	jmp    101ed3 <trap_dispatch+0x202>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d79:	e8 a2 f8 ff ff       	call   101620 <cons_getc>
  101d7e:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d81:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d85:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d89:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d91:	c7 04 24 5b 66 10 00 	movl   $0x10665b,(%esp)
  101d98:	e8 9f e5 ff ff       	call   10033c <cprintf>
        break;
  101d9d:	e9 31 01 00 00       	jmp    101ed3 <trap_dispatch+0x202>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101da2:	8b 45 08             	mov    0x8(%ebp),%eax
  101da5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101da9:	66 83 f8 1b          	cmp    $0x1b,%ax
  101dad:	74 6d                	je     101e1c <trap_dispatch+0x14b>
            switchk2u = *tf;
  101daf:	8b 45 08             	mov    0x8(%ebp),%eax
  101db2:	ba 60 89 11 00       	mov    $0x118960,%edx
  101db7:	89 c3                	mov    %eax,%ebx
  101db9:	b8 13 00 00 00       	mov    $0x13,%eax
  101dbe:	89 d7                	mov    %edx,%edi
  101dc0:	89 de                	mov    %ebx,%esi
  101dc2:	89 c1                	mov    %eax,%ecx
  101dc4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101dc6:	66 c7 05 9c 89 11 00 	movw   $0x1b,0x11899c
  101dcd:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101dcf:	66 c7 05 a8 89 11 00 	movw   $0x23,0x1189a8
  101dd6:	23 00 
  101dd8:	0f b7 05 a8 89 11 00 	movzwl 0x1189a8,%eax
  101ddf:	66 a3 88 89 11 00    	mov    %ax,0x118988
  101de5:	0f b7 05 88 89 11 00 	movzwl 0x118988,%eax
  101dec:	66 a3 8c 89 11 00    	mov    %ax,0x11898c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101df2:	8b 45 08             	mov    0x8(%ebp),%eax
  101df5:	83 c0 44             	add    $0x44,%eax
  101df8:	a3 a4 89 11 00       	mov    %eax,0x1189a4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101dfd:	a1 a0 89 11 00       	mov    0x1189a0,%eax
  101e02:	80 cc 30             	or     $0x30,%ah
  101e05:	a3 a0 89 11 00       	mov    %eax,0x1189a0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0d:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e10:	b8 60 89 11 00       	mov    $0x118960,%eax
  101e15:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e17:	e9 b7 00 00 00       	jmp    101ed3 <trap_dispatch+0x202>
  101e1c:	e9 b2 00 00 00       	jmp    101ed3 <trap_dispatch+0x202>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101e21:	8b 45 08             	mov    0x8(%ebp),%eax
  101e24:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e28:	66 83 f8 08          	cmp    $0x8,%ax
  101e2c:	74 6a                	je     101e98 <trap_dispatch+0x1c7>
            tf->tf_cs = KERNEL_CS;
  101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e31:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e37:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3a:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e47:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e51:	8b 40 40             	mov    0x40(%eax),%eax
  101e54:	80 e4 cf             	and    $0xcf,%ah
  101e57:	89 c2                	mov    %eax,%edx
  101e59:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5c:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e62:	8b 40 44             	mov    0x44(%eax),%eax
  101e65:	83 e8 44             	sub    $0x44,%eax
  101e68:	a3 ac 89 11 00       	mov    %eax,0x1189ac
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e6d:	a1 ac 89 11 00       	mov    0x1189ac,%eax
  101e72:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e79:	00 
  101e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  101e7d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e81:	89 04 24             	mov    %eax,(%esp)
  101e84:	e8 2b 41 00 00       	call   105fb4 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e89:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8c:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e8f:	a1 ac 89 11 00       	mov    0x1189ac,%eax
  101e94:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e96:	eb 3b                	jmp    101ed3 <trap_dispatch+0x202>
  101e98:	eb 39                	jmp    101ed3 <trap_dispatch+0x202>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ea1:	0f b7 c0             	movzwl %ax,%eax
  101ea4:	83 e0 03             	and    $0x3,%eax
  101ea7:	85 c0                	test   %eax,%eax
  101ea9:	75 28                	jne    101ed3 <trap_dispatch+0x202>
            print_trapframe(tf);
  101eab:	8b 45 08             	mov    0x8(%ebp),%eax
  101eae:	89 04 24             	mov    %eax,(%esp)
  101eb1:	e8 9f fb ff ff       	call   101a55 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101eb6:	c7 44 24 08 6a 66 10 	movl   $0x10666a,0x8(%esp)
  101ebd:	00 
  101ebe:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  101ec5:	00 
  101ec6:	c7 04 24 8e 64 10 00 	movl   $0x10648e,(%esp)
  101ecd:	e8 e0 ed ff ff       	call   100cb2 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ed2:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ed3:	83 c4 2c             	add    $0x2c,%esp
  101ed6:	5b                   	pop    %ebx
  101ed7:	5e                   	pop    %esi
  101ed8:	5f                   	pop    %edi
  101ed9:	5d                   	pop    %ebp
  101eda:	c3                   	ret    

00101edb <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101edb:	55                   	push   %ebp
  101edc:	89 e5                	mov    %esp,%ebp
  101ede:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee4:	89 04 24             	mov    %eax,(%esp)
  101ee7:	e8 e5 fd ff ff       	call   101cd1 <trap_dispatch>
}
  101eec:	c9                   	leave  
  101eed:	c3                   	ret    

00101eee <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101eee:	1e                   	push   %ds
    pushl %es
  101eef:	06                   	push   %es
    pushl %fs
  101ef0:	0f a0                	push   %fs
    pushl %gs
  101ef2:	0f a8                	push   %gs
    pushal
  101ef4:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ef5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101efa:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101efc:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101efe:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101eff:	e8 d7 ff ff ff       	call   101edb <trap>

    # pop the pushed stack pointer
    popl %esp
  101f04:	5c                   	pop    %esp

00101f05 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f05:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f06:	0f a9                	pop    %gs
    popl %fs
  101f08:	0f a1                	pop    %fs
    popl %es
  101f0a:	07                   	pop    %es
    popl %ds
  101f0b:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f0c:	83 c4 08             	add    $0x8,%esp
    iret
  101f0f:	cf                   	iret   

00101f10 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $0
  101f12:	6a 00                	push   $0x0
  jmp __alltraps
  101f14:	e9 d5 ff ff ff       	jmp    101eee <__alltraps>

00101f19 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $1
  101f1b:	6a 01                	push   $0x1
  jmp __alltraps
  101f1d:	e9 cc ff ff ff       	jmp    101eee <__alltraps>

00101f22 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $2
  101f24:	6a 02                	push   $0x2
  jmp __alltraps
  101f26:	e9 c3 ff ff ff       	jmp    101eee <__alltraps>

00101f2b <vector3>:
.globl vector3
vector3:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $3
  101f2d:	6a 03                	push   $0x3
  jmp __alltraps
  101f2f:	e9 ba ff ff ff       	jmp    101eee <__alltraps>

00101f34 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $4
  101f36:	6a 04                	push   $0x4
  jmp __alltraps
  101f38:	e9 b1 ff ff ff       	jmp    101eee <__alltraps>

00101f3d <vector5>:
.globl vector5
vector5:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $5
  101f3f:	6a 05                	push   $0x5
  jmp __alltraps
  101f41:	e9 a8 ff ff ff       	jmp    101eee <__alltraps>

00101f46 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $6
  101f48:	6a 06                	push   $0x6
  jmp __alltraps
  101f4a:	e9 9f ff ff ff       	jmp    101eee <__alltraps>

00101f4f <vector7>:
.globl vector7
vector7:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $7
  101f51:	6a 07                	push   $0x7
  jmp __alltraps
  101f53:	e9 96 ff ff ff       	jmp    101eee <__alltraps>

00101f58 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f58:	6a 08                	push   $0x8
  jmp __alltraps
  101f5a:	e9 8f ff ff ff       	jmp    101eee <__alltraps>

00101f5f <vector9>:
.globl vector9
vector9:
  pushl $9
  101f5f:	6a 09                	push   $0x9
  jmp __alltraps
  101f61:	e9 88 ff ff ff       	jmp    101eee <__alltraps>

00101f66 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f66:	6a 0a                	push   $0xa
  jmp __alltraps
  101f68:	e9 81 ff ff ff       	jmp    101eee <__alltraps>

00101f6d <vector11>:
.globl vector11
vector11:
  pushl $11
  101f6d:	6a 0b                	push   $0xb
  jmp __alltraps
  101f6f:	e9 7a ff ff ff       	jmp    101eee <__alltraps>

00101f74 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f74:	6a 0c                	push   $0xc
  jmp __alltraps
  101f76:	e9 73 ff ff ff       	jmp    101eee <__alltraps>

00101f7b <vector13>:
.globl vector13
vector13:
  pushl $13
  101f7b:	6a 0d                	push   $0xd
  jmp __alltraps
  101f7d:	e9 6c ff ff ff       	jmp    101eee <__alltraps>

00101f82 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f82:	6a 0e                	push   $0xe
  jmp __alltraps
  101f84:	e9 65 ff ff ff       	jmp    101eee <__alltraps>

00101f89 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $15
  101f8b:	6a 0f                	push   $0xf
  jmp __alltraps
  101f8d:	e9 5c ff ff ff       	jmp    101eee <__alltraps>

00101f92 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $16
  101f94:	6a 10                	push   $0x10
  jmp __alltraps
  101f96:	e9 53 ff ff ff       	jmp    101eee <__alltraps>

00101f9b <vector17>:
.globl vector17
vector17:
  pushl $17
  101f9b:	6a 11                	push   $0x11
  jmp __alltraps
  101f9d:	e9 4c ff ff ff       	jmp    101eee <__alltraps>

00101fa2 <vector18>:
.globl vector18
vector18:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $18
  101fa4:	6a 12                	push   $0x12
  jmp __alltraps
  101fa6:	e9 43 ff ff ff       	jmp    101eee <__alltraps>

00101fab <vector19>:
.globl vector19
vector19:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $19
  101fad:	6a 13                	push   $0x13
  jmp __alltraps
  101faf:	e9 3a ff ff ff       	jmp    101eee <__alltraps>

00101fb4 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $20
  101fb6:	6a 14                	push   $0x14
  jmp __alltraps
  101fb8:	e9 31 ff ff ff       	jmp    101eee <__alltraps>

00101fbd <vector21>:
.globl vector21
vector21:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $21
  101fbf:	6a 15                	push   $0x15
  jmp __alltraps
  101fc1:	e9 28 ff ff ff       	jmp    101eee <__alltraps>

00101fc6 <vector22>:
.globl vector22
vector22:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $22
  101fc8:	6a 16                	push   $0x16
  jmp __alltraps
  101fca:	e9 1f ff ff ff       	jmp    101eee <__alltraps>

00101fcf <vector23>:
.globl vector23
vector23:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $23
  101fd1:	6a 17                	push   $0x17
  jmp __alltraps
  101fd3:	e9 16 ff ff ff       	jmp    101eee <__alltraps>

00101fd8 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $24
  101fda:	6a 18                	push   $0x18
  jmp __alltraps
  101fdc:	e9 0d ff ff ff       	jmp    101eee <__alltraps>

00101fe1 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $25
  101fe3:	6a 19                	push   $0x19
  jmp __alltraps
  101fe5:	e9 04 ff ff ff       	jmp    101eee <__alltraps>

00101fea <vector26>:
.globl vector26
vector26:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $26
  101fec:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fee:	e9 fb fe ff ff       	jmp    101eee <__alltraps>

00101ff3 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $27
  101ff5:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ff7:	e9 f2 fe ff ff       	jmp    101eee <__alltraps>

00101ffc <vector28>:
.globl vector28
vector28:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $28
  101ffe:	6a 1c                	push   $0x1c
  jmp __alltraps
  102000:	e9 e9 fe ff ff       	jmp    101eee <__alltraps>

00102005 <vector29>:
.globl vector29
vector29:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $29
  102007:	6a 1d                	push   $0x1d
  jmp __alltraps
  102009:	e9 e0 fe ff ff       	jmp    101eee <__alltraps>

0010200e <vector30>:
.globl vector30
vector30:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $30
  102010:	6a 1e                	push   $0x1e
  jmp __alltraps
  102012:	e9 d7 fe ff ff       	jmp    101eee <__alltraps>

00102017 <vector31>:
.globl vector31
vector31:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $31
  102019:	6a 1f                	push   $0x1f
  jmp __alltraps
  10201b:	e9 ce fe ff ff       	jmp    101eee <__alltraps>

00102020 <vector32>:
.globl vector32
vector32:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $32
  102022:	6a 20                	push   $0x20
  jmp __alltraps
  102024:	e9 c5 fe ff ff       	jmp    101eee <__alltraps>

00102029 <vector33>:
.globl vector33
vector33:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $33
  10202b:	6a 21                	push   $0x21
  jmp __alltraps
  10202d:	e9 bc fe ff ff       	jmp    101eee <__alltraps>

00102032 <vector34>:
.globl vector34
vector34:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $34
  102034:	6a 22                	push   $0x22
  jmp __alltraps
  102036:	e9 b3 fe ff ff       	jmp    101eee <__alltraps>

0010203b <vector35>:
.globl vector35
vector35:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $35
  10203d:	6a 23                	push   $0x23
  jmp __alltraps
  10203f:	e9 aa fe ff ff       	jmp    101eee <__alltraps>

00102044 <vector36>:
.globl vector36
vector36:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $36
  102046:	6a 24                	push   $0x24
  jmp __alltraps
  102048:	e9 a1 fe ff ff       	jmp    101eee <__alltraps>

0010204d <vector37>:
.globl vector37
vector37:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $37
  10204f:	6a 25                	push   $0x25
  jmp __alltraps
  102051:	e9 98 fe ff ff       	jmp    101eee <__alltraps>

00102056 <vector38>:
.globl vector38
vector38:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $38
  102058:	6a 26                	push   $0x26
  jmp __alltraps
  10205a:	e9 8f fe ff ff       	jmp    101eee <__alltraps>

0010205f <vector39>:
.globl vector39
vector39:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $39
  102061:	6a 27                	push   $0x27
  jmp __alltraps
  102063:	e9 86 fe ff ff       	jmp    101eee <__alltraps>

00102068 <vector40>:
.globl vector40
vector40:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $40
  10206a:	6a 28                	push   $0x28
  jmp __alltraps
  10206c:	e9 7d fe ff ff       	jmp    101eee <__alltraps>

00102071 <vector41>:
.globl vector41
vector41:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $41
  102073:	6a 29                	push   $0x29
  jmp __alltraps
  102075:	e9 74 fe ff ff       	jmp    101eee <__alltraps>

0010207a <vector42>:
.globl vector42
vector42:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $42
  10207c:	6a 2a                	push   $0x2a
  jmp __alltraps
  10207e:	e9 6b fe ff ff       	jmp    101eee <__alltraps>

00102083 <vector43>:
.globl vector43
vector43:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $43
  102085:	6a 2b                	push   $0x2b
  jmp __alltraps
  102087:	e9 62 fe ff ff       	jmp    101eee <__alltraps>

0010208c <vector44>:
.globl vector44
vector44:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $44
  10208e:	6a 2c                	push   $0x2c
  jmp __alltraps
  102090:	e9 59 fe ff ff       	jmp    101eee <__alltraps>

00102095 <vector45>:
.globl vector45
vector45:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $45
  102097:	6a 2d                	push   $0x2d
  jmp __alltraps
  102099:	e9 50 fe ff ff       	jmp    101eee <__alltraps>

0010209e <vector46>:
.globl vector46
vector46:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $46
  1020a0:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020a2:	e9 47 fe ff ff       	jmp    101eee <__alltraps>

001020a7 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $47
  1020a9:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020ab:	e9 3e fe ff ff       	jmp    101eee <__alltraps>

001020b0 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $48
  1020b2:	6a 30                	push   $0x30
  jmp __alltraps
  1020b4:	e9 35 fe ff ff       	jmp    101eee <__alltraps>

001020b9 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $49
  1020bb:	6a 31                	push   $0x31
  jmp __alltraps
  1020bd:	e9 2c fe ff ff       	jmp    101eee <__alltraps>

001020c2 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $50
  1020c4:	6a 32                	push   $0x32
  jmp __alltraps
  1020c6:	e9 23 fe ff ff       	jmp    101eee <__alltraps>

001020cb <vector51>:
.globl vector51
vector51:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $51
  1020cd:	6a 33                	push   $0x33
  jmp __alltraps
  1020cf:	e9 1a fe ff ff       	jmp    101eee <__alltraps>

001020d4 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $52
  1020d6:	6a 34                	push   $0x34
  jmp __alltraps
  1020d8:	e9 11 fe ff ff       	jmp    101eee <__alltraps>

001020dd <vector53>:
.globl vector53
vector53:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $53
  1020df:	6a 35                	push   $0x35
  jmp __alltraps
  1020e1:	e9 08 fe ff ff       	jmp    101eee <__alltraps>

001020e6 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $54
  1020e8:	6a 36                	push   $0x36
  jmp __alltraps
  1020ea:	e9 ff fd ff ff       	jmp    101eee <__alltraps>

001020ef <vector55>:
.globl vector55
vector55:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $55
  1020f1:	6a 37                	push   $0x37
  jmp __alltraps
  1020f3:	e9 f6 fd ff ff       	jmp    101eee <__alltraps>

001020f8 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $56
  1020fa:	6a 38                	push   $0x38
  jmp __alltraps
  1020fc:	e9 ed fd ff ff       	jmp    101eee <__alltraps>

00102101 <vector57>:
.globl vector57
vector57:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $57
  102103:	6a 39                	push   $0x39
  jmp __alltraps
  102105:	e9 e4 fd ff ff       	jmp    101eee <__alltraps>

0010210a <vector58>:
.globl vector58
vector58:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $58
  10210c:	6a 3a                	push   $0x3a
  jmp __alltraps
  10210e:	e9 db fd ff ff       	jmp    101eee <__alltraps>

00102113 <vector59>:
.globl vector59
vector59:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $59
  102115:	6a 3b                	push   $0x3b
  jmp __alltraps
  102117:	e9 d2 fd ff ff       	jmp    101eee <__alltraps>

0010211c <vector60>:
.globl vector60
vector60:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $60
  10211e:	6a 3c                	push   $0x3c
  jmp __alltraps
  102120:	e9 c9 fd ff ff       	jmp    101eee <__alltraps>

00102125 <vector61>:
.globl vector61
vector61:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $61
  102127:	6a 3d                	push   $0x3d
  jmp __alltraps
  102129:	e9 c0 fd ff ff       	jmp    101eee <__alltraps>

0010212e <vector62>:
.globl vector62
vector62:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $62
  102130:	6a 3e                	push   $0x3e
  jmp __alltraps
  102132:	e9 b7 fd ff ff       	jmp    101eee <__alltraps>

00102137 <vector63>:
.globl vector63
vector63:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $63
  102139:	6a 3f                	push   $0x3f
  jmp __alltraps
  10213b:	e9 ae fd ff ff       	jmp    101eee <__alltraps>

00102140 <vector64>:
.globl vector64
vector64:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $64
  102142:	6a 40                	push   $0x40
  jmp __alltraps
  102144:	e9 a5 fd ff ff       	jmp    101eee <__alltraps>

00102149 <vector65>:
.globl vector65
vector65:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $65
  10214b:	6a 41                	push   $0x41
  jmp __alltraps
  10214d:	e9 9c fd ff ff       	jmp    101eee <__alltraps>

00102152 <vector66>:
.globl vector66
vector66:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $66
  102154:	6a 42                	push   $0x42
  jmp __alltraps
  102156:	e9 93 fd ff ff       	jmp    101eee <__alltraps>

0010215b <vector67>:
.globl vector67
vector67:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $67
  10215d:	6a 43                	push   $0x43
  jmp __alltraps
  10215f:	e9 8a fd ff ff       	jmp    101eee <__alltraps>

00102164 <vector68>:
.globl vector68
vector68:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $68
  102166:	6a 44                	push   $0x44
  jmp __alltraps
  102168:	e9 81 fd ff ff       	jmp    101eee <__alltraps>

0010216d <vector69>:
.globl vector69
vector69:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $69
  10216f:	6a 45                	push   $0x45
  jmp __alltraps
  102171:	e9 78 fd ff ff       	jmp    101eee <__alltraps>

00102176 <vector70>:
.globl vector70
vector70:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $70
  102178:	6a 46                	push   $0x46
  jmp __alltraps
  10217a:	e9 6f fd ff ff       	jmp    101eee <__alltraps>

0010217f <vector71>:
.globl vector71
vector71:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $71
  102181:	6a 47                	push   $0x47
  jmp __alltraps
  102183:	e9 66 fd ff ff       	jmp    101eee <__alltraps>

00102188 <vector72>:
.globl vector72
vector72:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $72
  10218a:	6a 48                	push   $0x48
  jmp __alltraps
  10218c:	e9 5d fd ff ff       	jmp    101eee <__alltraps>

00102191 <vector73>:
.globl vector73
vector73:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $73
  102193:	6a 49                	push   $0x49
  jmp __alltraps
  102195:	e9 54 fd ff ff       	jmp    101eee <__alltraps>

0010219a <vector74>:
.globl vector74
vector74:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $74
  10219c:	6a 4a                	push   $0x4a
  jmp __alltraps
  10219e:	e9 4b fd ff ff       	jmp    101eee <__alltraps>

001021a3 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $75
  1021a5:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021a7:	e9 42 fd ff ff       	jmp    101eee <__alltraps>

001021ac <vector76>:
.globl vector76
vector76:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $76
  1021ae:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021b0:	e9 39 fd ff ff       	jmp    101eee <__alltraps>

001021b5 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $77
  1021b7:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021b9:	e9 30 fd ff ff       	jmp    101eee <__alltraps>

001021be <vector78>:
.globl vector78
vector78:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $78
  1021c0:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021c2:	e9 27 fd ff ff       	jmp    101eee <__alltraps>

001021c7 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $79
  1021c9:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021cb:	e9 1e fd ff ff       	jmp    101eee <__alltraps>

001021d0 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $80
  1021d2:	6a 50                	push   $0x50
  jmp __alltraps
  1021d4:	e9 15 fd ff ff       	jmp    101eee <__alltraps>

001021d9 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $81
  1021db:	6a 51                	push   $0x51
  jmp __alltraps
  1021dd:	e9 0c fd ff ff       	jmp    101eee <__alltraps>

001021e2 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $82
  1021e4:	6a 52                	push   $0x52
  jmp __alltraps
  1021e6:	e9 03 fd ff ff       	jmp    101eee <__alltraps>

001021eb <vector83>:
.globl vector83
vector83:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $83
  1021ed:	6a 53                	push   $0x53
  jmp __alltraps
  1021ef:	e9 fa fc ff ff       	jmp    101eee <__alltraps>

001021f4 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $84
  1021f6:	6a 54                	push   $0x54
  jmp __alltraps
  1021f8:	e9 f1 fc ff ff       	jmp    101eee <__alltraps>

001021fd <vector85>:
.globl vector85
vector85:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $85
  1021ff:	6a 55                	push   $0x55
  jmp __alltraps
  102201:	e9 e8 fc ff ff       	jmp    101eee <__alltraps>

00102206 <vector86>:
.globl vector86
vector86:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $86
  102208:	6a 56                	push   $0x56
  jmp __alltraps
  10220a:	e9 df fc ff ff       	jmp    101eee <__alltraps>

0010220f <vector87>:
.globl vector87
vector87:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $87
  102211:	6a 57                	push   $0x57
  jmp __alltraps
  102213:	e9 d6 fc ff ff       	jmp    101eee <__alltraps>

00102218 <vector88>:
.globl vector88
vector88:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $88
  10221a:	6a 58                	push   $0x58
  jmp __alltraps
  10221c:	e9 cd fc ff ff       	jmp    101eee <__alltraps>

00102221 <vector89>:
.globl vector89
vector89:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $89
  102223:	6a 59                	push   $0x59
  jmp __alltraps
  102225:	e9 c4 fc ff ff       	jmp    101eee <__alltraps>

0010222a <vector90>:
.globl vector90
vector90:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $90
  10222c:	6a 5a                	push   $0x5a
  jmp __alltraps
  10222e:	e9 bb fc ff ff       	jmp    101eee <__alltraps>

00102233 <vector91>:
.globl vector91
vector91:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $91
  102235:	6a 5b                	push   $0x5b
  jmp __alltraps
  102237:	e9 b2 fc ff ff       	jmp    101eee <__alltraps>

0010223c <vector92>:
.globl vector92
vector92:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $92
  10223e:	6a 5c                	push   $0x5c
  jmp __alltraps
  102240:	e9 a9 fc ff ff       	jmp    101eee <__alltraps>

00102245 <vector93>:
.globl vector93
vector93:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $93
  102247:	6a 5d                	push   $0x5d
  jmp __alltraps
  102249:	e9 a0 fc ff ff       	jmp    101eee <__alltraps>

0010224e <vector94>:
.globl vector94
vector94:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $94
  102250:	6a 5e                	push   $0x5e
  jmp __alltraps
  102252:	e9 97 fc ff ff       	jmp    101eee <__alltraps>

00102257 <vector95>:
.globl vector95
vector95:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $95
  102259:	6a 5f                	push   $0x5f
  jmp __alltraps
  10225b:	e9 8e fc ff ff       	jmp    101eee <__alltraps>

00102260 <vector96>:
.globl vector96
vector96:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $96
  102262:	6a 60                	push   $0x60
  jmp __alltraps
  102264:	e9 85 fc ff ff       	jmp    101eee <__alltraps>

00102269 <vector97>:
.globl vector97
vector97:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $97
  10226b:	6a 61                	push   $0x61
  jmp __alltraps
  10226d:	e9 7c fc ff ff       	jmp    101eee <__alltraps>

00102272 <vector98>:
.globl vector98
vector98:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $98
  102274:	6a 62                	push   $0x62
  jmp __alltraps
  102276:	e9 73 fc ff ff       	jmp    101eee <__alltraps>

0010227b <vector99>:
.globl vector99
vector99:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $99
  10227d:	6a 63                	push   $0x63
  jmp __alltraps
  10227f:	e9 6a fc ff ff       	jmp    101eee <__alltraps>

00102284 <vector100>:
.globl vector100
vector100:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $100
  102286:	6a 64                	push   $0x64
  jmp __alltraps
  102288:	e9 61 fc ff ff       	jmp    101eee <__alltraps>

0010228d <vector101>:
.globl vector101
vector101:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $101
  10228f:	6a 65                	push   $0x65
  jmp __alltraps
  102291:	e9 58 fc ff ff       	jmp    101eee <__alltraps>

00102296 <vector102>:
.globl vector102
vector102:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $102
  102298:	6a 66                	push   $0x66
  jmp __alltraps
  10229a:	e9 4f fc ff ff       	jmp    101eee <__alltraps>

0010229f <vector103>:
.globl vector103
vector103:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $103
  1022a1:	6a 67                	push   $0x67
  jmp __alltraps
  1022a3:	e9 46 fc ff ff       	jmp    101eee <__alltraps>

001022a8 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $104
  1022aa:	6a 68                	push   $0x68
  jmp __alltraps
  1022ac:	e9 3d fc ff ff       	jmp    101eee <__alltraps>

001022b1 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $105
  1022b3:	6a 69                	push   $0x69
  jmp __alltraps
  1022b5:	e9 34 fc ff ff       	jmp    101eee <__alltraps>

001022ba <vector106>:
.globl vector106
vector106:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $106
  1022bc:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022be:	e9 2b fc ff ff       	jmp    101eee <__alltraps>

001022c3 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $107
  1022c5:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022c7:	e9 22 fc ff ff       	jmp    101eee <__alltraps>

001022cc <vector108>:
.globl vector108
vector108:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $108
  1022ce:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022d0:	e9 19 fc ff ff       	jmp    101eee <__alltraps>

001022d5 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $109
  1022d7:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022d9:	e9 10 fc ff ff       	jmp    101eee <__alltraps>

001022de <vector110>:
.globl vector110
vector110:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $110
  1022e0:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022e2:	e9 07 fc ff ff       	jmp    101eee <__alltraps>

001022e7 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $111
  1022e9:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022eb:	e9 fe fb ff ff       	jmp    101eee <__alltraps>

001022f0 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $112
  1022f2:	6a 70                	push   $0x70
  jmp __alltraps
  1022f4:	e9 f5 fb ff ff       	jmp    101eee <__alltraps>

001022f9 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $113
  1022fb:	6a 71                	push   $0x71
  jmp __alltraps
  1022fd:	e9 ec fb ff ff       	jmp    101eee <__alltraps>

00102302 <vector114>:
.globl vector114
vector114:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $114
  102304:	6a 72                	push   $0x72
  jmp __alltraps
  102306:	e9 e3 fb ff ff       	jmp    101eee <__alltraps>

0010230b <vector115>:
.globl vector115
vector115:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $115
  10230d:	6a 73                	push   $0x73
  jmp __alltraps
  10230f:	e9 da fb ff ff       	jmp    101eee <__alltraps>

00102314 <vector116>:
.globl vector116
vector116:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $116
  102316:	6a 74                	push   $0x74
  jmp __alltraps
  102318:	e9 d1 fb ff ff       	jmp    101eee <__alltraps>

0010231d <vector117>:
.globl vector117
vector117:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $117
  10231f:	6a 75                	push   $0x75
  jmp __alltraps
  102321:	e9 c8 fb ff ff       	jmp    101eee <__alltraps>

00102326 <vector118>:
.globl vector118
vector118:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $118
  102328:	6a 76                	push   $0x76
  jmp __alltraps
  10232a:	e9 bf fb ff ff       	jmp    101eee <__alltraps>

0010232f <vector119>:
.globl vector119
vector119:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $119
  102331:	6a 77                	push   $0x77
  jmp __alltraps
  102333:	e9 b6 fb ff ff       	jmp    101eee <__alltraps>

00102338 <vector120>:
.globl vector120
vector120:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $120
  10233a:	6a 78                	push   $0x78
  jmp __alltraps
  10233c:	e9 ad fb ff ff       	jmp    101eee <__alltraps>

00102341 <vector121>:
.globl vector121
vector121:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $121
  102343:	6a 79                	push   $0x79
  jmp __alltraps
  102345:	e9 a4 fb ff ff       	jmp    101eee <__alltraps>

0010234a <vector122>:
.globl vector122
vector122:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $122
  10234c:	6a 7a                	push   $0x7a
  jmp __alltraps
  10234e:	e9 9b fb ff ff       	jmp    101eee <__alltraps>

00102353 <vector123>:
.globl vector123
vector123:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $123
  102355:	6a 7b                	push   $0x7b
  jmp __alltraps
  102357:	e9 92 fb ff ff       	jmp    101eee <__alltraps>

0010235c <vector124>:
.globl vector124
vector124:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $124
  10235e:	6a 7c                	push   $0x7c
  jmp __alltraps
  102360:	e9 89 fb ff ff       	jmp    101eee <__alltraps>

00102365 <vector125>:
.globl vector125
vector125:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $125
  102367:	6a 7d                	push   $0x7d
  jmp __alltraps
  102369:	e9 80 fb ff ff       	jmp    101eee <__alltraps>

0010236e <vector126>:
.globl vector126
vector126:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $126
  102370:	6a 7e                	push   $0x7e
  jmp __alltraps
  102372:	e9 77 fb ff ff       	jmp    101eee <__alltraps>

00102377 <vector127>:
.globl vector127
vector127:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $127
  102379:	6a 7f                	push   $0x7f
  jmp __alltraps
  10237b:	e9 6e fb ff ff       	jmp    101eee <__alltraps>

00102380 <vector128>:
.globl vector128
vector128:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $128
  102382:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102387:	e9 62 fb ff ff       	jmp    101eee <__alltraps>

0010238c <vector129>:
.globl vector129
vector129:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $129
  10238e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102393:	e9 56 fb ff ff       	jmp    101eee <__alltraps>

00102398 <vector130>:
.globl vector130
vector130:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $130
  10239a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10239f:	e9 4a fb ff ff       	jmp    101eee <__alltraps>

001023a4 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $131
  1023a6:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023ab:	e9 3e fb ff ff       	jmp    101eee <__alltraps>

001023b0 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $132
  1023b2:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023b7:	e9 32 fb ff ff       	jmp    101eee <__alltraps>

001023bc <vector133>:
.globl vector133
vector133:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $133
  1023be:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023c3:	e9 26 fb ff ff       	jmp    101eee <__alltraps>

001023c8 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $134
  1023ca:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023cf:	e9 1a fb ff ff       	jmp    101eee <__alltraps>

001023d4 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $135
  1023d6:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023db:	e9 0e fb ff ff       	jmp    101eee <__alltraps>

001023e0 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $136
  1023e2:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023e7:	e9 02 fb ff ff       	jmp    101eee <__alltraps>

001023ec <vector137>:
.globl vector137
vector137:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $137
  1023ee:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023f3:	e9 f6 fa ff ff       	jmp    101eee <__alltraps>

001023f8 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $138
  1023fa:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023ff:	e9 ea fa ff ff       	jmp    101eee <__alltraps>

00102404 <vector139>:
.globl vector139
vector139:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $139
  102406:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10240b:	e9 de fa ff ff       	jmp    101eee <__alltraps>

00102410 <vector140>:
.globl vector140
vector140:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $140
  102412:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102417:	e9 d2 fa ff ff       	jmp    101eee <__alltraps>

0010241c <vector141>:
.globl vector141
vector141:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $141
  10241e:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102423:	e9 c6 fa ff ff       	jmp    101eee <__alltraps>

00102428 <vector142>:
.globl vector142
vector142:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $142
  10242a:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10242f:	e9 ba fa ff ff       	jmp    101eee <__alltraps>

00102434 <vector143>:
.globl vector143
vector143:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $143
  102436:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10243b:	e9 ae fa ff ff       	jmp    101eee <__alltraps>

00102440 <vector144>:
.globl vector144
vector144:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $144
  102442:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102447:	e9 a2 fa ff ff       	jmp    101eee <__alltraps>

0010244c <vector145>:
.globl vector145
vector145:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $145
  10244e:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102453:	e9 96 fa ff ff       	jmp    101eee <__alltraps>

00102458 <vector146>:
.globl vector146
vector146:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $146
  10245a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10245f:	e9 8a fa ff ff       	jmp    101eee <__alltraps>

00102464 <vector147>:
.globl vector147
vector147:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $147
  102466:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10246b:	e9 7e fa ff ff       	jmp    101eee <__alltraps>

00102470 <vector148>:
.globl vector148
vector148:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $148
  102472:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102477:	e9 72 fa ff ff       	jmp    101eee <__alltraps>

0010247c <vector149>:
.globl vector149
vector149:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $149
  10247e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102483:	e9 66 fa ff ff       	jmp    101eee <__alltraps>

00102488 <vector150>:
.globl vector150
vector150:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $150
  10248a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10248f:	e9 5a fa ff ff       	jmp    101eee <__alltraps>

00102494 <vector151>:
.globl vector151
vector151:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $151
  102496:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10249b:	e9 4e fa ff ff       	jmp    101eee <__alltraps>

001024a0 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $152
  1024a2:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024a7:	e9 42 fa ff ff       	jmp    101eee <__alltraps>

001024ac <vector153>:
.globl vector153
vector153:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $153
  1024ae:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024b3:	e9 36 fa ff ff       	jmp    101eee <__alltraps>

001024b8 <vector154>:
.globl vector154
vector154:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $154
  1024ba:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024bf:	e9 2a fa ff ff       	jmp    101eee <__alltraps>

001024c4 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $155
  1024c6:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024cb:	e9 1e fa ff ff       	jmp    101eee <__alltraps>

001024d0 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $156
  1024d2:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024d7:	e9 12 fa ff ff       	jmp    101eee <__alltraps>

001024dc <vector157>:
.globl vector157
vector157:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $157
  1024de:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024e3:	e9 06 fa ff ff       	jmp    101eee <__alltraps>

001024e8 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $158
  1024ea:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024ef:	e9 fa f9 ff ff       	jmp    101eee <__alltraps>

001024f4 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $159
  1024f6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024fb:	e9 ee f9 ff ff       	jmp    101eee <__alltraps>

00102500 <vector160>:
.globl vector160
vector160:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $160
  102502:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102507:	e9 e2 f9 ff ff       	jmp    101eee <__alltraps>

0010250c <vector161>:
.globl vector161
vector161:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $161
  10250e:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102513:	e9 d6 f9 ff ff       	jmp    101eee <__alltraps>

00102518 <vector162>:
.globl vector162
vector162:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $162
  10251a:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10251f:	e9 ca f9 ff ff       	jmp    101eee <__alltraps>

00102524 <vector163>:
.globl vector163
vector163:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $163
  102526:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10252b:	e9 be f9 ff ff       	jmp    101eee <__alltraps>

00102530 <vector164>:
.globl vector164
vector164:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $164
  102532:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102537:	e9 b2 f9 ff ff       	jmp    101eee <__alltraps>

0010253c <vector165>:
.globl vector165
vector165:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $165
  10253e:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102543:	e9 a6 f9 ff ff       	jmp    101eee <__alltraps>

00102548 <vector166>:
.globl vector166
vector166:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $166
  10254a:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10254f:	e9 9a f9 ff ff       	jmp    101eee <__alltraps>

00102554 <vector167>:
.globl vector167
vector167:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $167
  102556:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10255b:	e9 8e f9 ff ff       	jmp    101eee <__alltraps>

00102560 <vector168>:
.globl vector168
vector168:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $168
  102562:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102567:	e9 82 f9 ff ff       	jmp    101eee <__alltraps>

0010256c <vector169>:
.globl vector169
vector169:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $169
  10256e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102573:	e9 76 f9 ff ff       	jmp    101eee <__alltraps>

00102578 <vector170>:
.globl vector170
vector170:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $170
  10257a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10257f:	e9 6a f9 ff ff       	jmp    101eee <__alltraps>

00102584 <vector171>:
.globl vector171
vector171:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $171
  102586:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10258b:	e9 5e f9 ff ff       	jmp    101eee <__alltraps>

00102590 <vector172>:
.globl vector172
vector172:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $172
  102592:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102597:	e9 52 f9 ff ff       	jmp    101eee <__alltraps>

0010259c <vector173>:
.globl vector173
vector173:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $173
  10259e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025a3:	e9 46 f9 ff ff       	jmp    101eee <__alltraps>

001025a8 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $174
  1025aa:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025af:	e9 3a f9 ff ff       	jmp    101eee <__alltraps>

001025b4 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $175
  1025b6:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025bb:	e9 2e f9 ff ff       	jmp    101eee <__alltraps>

001025c0 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $176
  1025c2:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025c7:	e9 22 f9 ff ff       	jmp    101eee <__alltraps>

001025cc <vector177>:
.globl vector177
vector177:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $177
  1025ce:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025d3:	e9 16 f9 ff ff       	jmp    101eee <__alltraps>

001025d8 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $178
  1025da:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025df:	e9 0a f9 ff ff       	jmp    101eee <__alltraps>

001025e4 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $179
  1025e6:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025eb:	e9 fe f8 ff ff       	jmp    101eee <__alltraps>

001025f0 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $180
  1025f2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025f7:	e9 f2 f8 ff ff       	jmp    101eee <__alltraps>

001025fc <vector181>:
.globl vector181
vector181:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $181
  1025fe:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102603:	e9 e6 f8 ff ff       	jmp    101eee <__alltraps>

00102608 <vector182>:
.globl vector182
vector182:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $182
  10260a:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10260f:	e9 da f8 ff ff       	jmp    101eee <__alltraps>

00102614 <vector183>:
.globl vector183
vector183:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $183
  102616:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10261b:	e9 ce f8 ff ff       	jmp    101eee <__alltraps>

00102620 <vector184>:
.globl vector184
vector184:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $184
  102622:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102627:	e9 c2 f8 ff ff       	jmp    101eee <__alltraps>

0010262c <vector185>:
.globl vector185
vector185:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $185
  10262e:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102633:	e9 b6 f8 ff ff       	jmp    101eee <__alltraps>

00102638 <vector186>:
.globl vector186
vector186:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $186
  10263a:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10263f:	e9 aa f8 ff ff       	jmp    101eee <__alltraps>

00102644 <vector187>:
.globl vector187
vector187:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $187
  102646:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10264b:	e9 9e f8 ff ff       	jmp    101eee <__alltraps>

00102650 <vector188>:
.globl vector188
vector188:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $188
  102652:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102657:	e9 92 f8 ff ff       	jmp    101eee <__alltraps>

0010265c <vector189>:
.globl vector189
vector189:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $189
  10265e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102663:	e9 86 f8 ff ff       	jmp    101eee <__alltraps>

00102668 <vector190>:
.globl vector190
vector190:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $190
  10266a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10266f:	e9 7a f8 ff ff       	jmp    101eee <__alltraps>

00102674 <vector191>:
.globl vector191
vector191:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $191
  102676:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10267b:	e9 6e f8 ff ff       	jmp    101eee <__alltraps>

00102680 <vector192>:
.globl vector192
vector192:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $192
  102682:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102687:	e9 62 f8 ff ff       	jmp    101eee <__alltraps>

0010268c <vector193>:
.globl vector193
vector193:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $193
  10268e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102693:	e9 56 f8 ff ff       	jmp    101eee <__alltraps>

00102698 <vector194>:
.globl vector194
vector194:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $194
  10269a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10269f:	e9 4a f8 ff ff       	jmp    101eee <__alltraps>

001026a4 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $195
  1026a6:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026ab:	e9 3e f8 ff ff       	jmp    101eee <__alltraps>

001026b0 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $196
  1026b2:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026b7:	e9 32 f8 ff ff       	jmp    101eee <__alltraps>

001026bc <vector197>:
.globl vector197
vector197:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $197
  1026be:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026c3:	e9 26 f8 ff ff       	jmp    101eee <__alltraps>

001026c8 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $198
  1026ca:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026cf:	e9 1a f8 ff ff       	jmp    101eee <__alltraps>

001026d4 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $199
  1026d6:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026db:	e9 0e f8 ff ff       	jmp    101eee <__alltraps>

001026e0 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $200
  1026e2:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026e7:	e9 02 f8 ff ff       	jmp    101eee <__alltraps>

001026ec <vector201>:
.globl vector201
vector201:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $201
  1026ee:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026f3:	e9 f6 f7 ff ff       	jmp    101eee <__alltraps>

001026f8 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $202
  1026fa:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026ff:	e9 ea f7 ff ff       	jmp    101eee <__alltraps>

00102704 <vector203>:
.globl vector203
vector203:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $203
  102706:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10270b:	e9 de f7 ff ff       	jmp    101eee <__alltraps>

00102710 <vector204>:
.globl vector204
vector204:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $204
  102712:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102717:	e9 d2 f7 ff ff       	jmp    101eee <__alltraps>

0010271c <vector205>:
.globl vector205
vector205:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $205
  10271e:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102723:	e9 c6 f7 ff ff       	jmp    101eee <__alltraps>

00102728 <vector206>:
.globl vector206
vector206:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $206
  10272a:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10272f:	e9 ba f7 ff ff       	jmp    101eee <__alltraps>

00102734 <vector207>:
.globl vector207
vector207:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $207
  102736:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10273b:	e9 ae f7 ff ff       	jmp    101eee <__alltraps>

00102740 <vector208>:
.globl vector208
vector208:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $208
  102742:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102747:	e9 a2 f7 ff ff       	jmp    101eee <__alltraps>

0010274c <vector209>:
.globl vector209
vector209:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $209
  10274e:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102753:	e9 96 f7 ff ff       	jmp    101eee <__alltraps>

00102758 <vector210>:
.globl vector210
vector210:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $210
  10275a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10275f:	e9 8a f7 ff ff       	jmp    101eee <__alltraps>

00102764 <vector211>:
.globl vector211
vector211:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $211
  102766:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10276b:	e9 7e f7 ff ff       	jmp    101eee <__alltraps>

00102770 <vector212>:
.globl vector212
vector212:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $212
  102772:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102777:	e9 72 f7 ff ff       	jmp    101eee <__alltraps>

0010277c <vector213>:
.globl vector213
vector213:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $213
  10277e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102783:	e9 66 f7 ff ff       	jmp    101eee <__alltraps>

00102788 <vector214>:
.globl vector214
vector214:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $214
  10278a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10278f:	e9 5a f7 ff ff       	jmp    101eee <__alltraps>

00102794 <vector215>:
.globl vector215
vector215:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $215
  102796:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10279b:	e9 4e f7 ff ff       	jmp    101eee <__alltraps>

001027a0 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $216
  1027a2:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027a7:	e9 42 f7 ff ff       	jmp    101eee <__alltraps>

001027ac <vector217>:
.globl vector217
vector217:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $217
  1027ae:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027b3:	e9 36 f7 ff ff       	jmp    101eee <__alltraps>

001027b8 <vector218>:
.globl vector218
vector218:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $218
  1027ba:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027bf:	e9 2a f7 ff ff       	jmp    101eee <__alltraps>

001027c4 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $219
  1027c6:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027cb:	e9 1e f7 ff ff       	jmp    101eee <__alltraps>

001027d0 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $220
  1027d2:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027d7:	e9 12 f7 ff ff       	jmp    101eee <__alltraps>

001027dc <vector221>:
.globl vector221
vector221:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $221
  1027de:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027e3:	e9 06 f7 ff ff       	jmp    101eee <__alltraps>

001027e8 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $222
  1027ea:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027ef:	e9 fa f6 ff ff       	jmp    101eee <__alltraps>

001027f4 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $223
  1027f6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027fb:	e9 ee f6 ff ff       	jmp    101eee <__alltraps>

00102800 <vector224>:
.globl vector224
vector224:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $224
  102802:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102807:	e9 e2 f6 ff ff       	jmp    101eee <__alltraps>

0010280c <vector225>:
.globl vector225
vector225:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $225
  10280e:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102813:	e9 d6 f6 ff ff       	jmp    101eee <__alltraps>

00102818 <vector226>:
.globl vector226
vector226:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $226
  10281a:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10281f:	e9 ca f6 ff ff       	jmp    101eee <__alltraps>

00102824 <vector227>:
.globl vector227
vector227:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $227
  102826:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10282b:	e9 be f6 ff ff       	jmp    101eee <__alltraps>

00102830 <vector228>:
.globl vector228
vector228:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $228
  102832:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102837:	e9 b2 f6 ff ff       	jmp    101eee <__alltraps>

0010283c <vector229>:
.globl vector229
vector229:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $229
  10283e:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102843:	e9 a6 f6 ff ff       	jmp    101eee <__alltraps>

00102848 <vector230>:
.globl vector230
vector230:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $230
  10284a:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10284f:	e9 9a f6 ff ff       	jmp    101eee <__alltraps>

00102854 <vector231>:
.globl vector231
vector231:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $231
  102856:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10285b:	e9 8e f6 ff ff       	jmp    101eee <__alltraps>

00102860 <vector232>:
.globl vector232
vector232:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $232
  102862:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102867:	e9 82 f6 ff ff       	jmp    101eee <__alltraps>

0010286c <vector233>:
.globl vector233
vector233:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $233
  10286e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102873:	e9 76 f6 ff ff       	jmp    101eee <__alltraps>

00102878 <vector234>:
.globl vector234
vector234:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $234
  10287a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10287f:	e9 6a f6 ff ff       	jmp    101eee <__alltraps>

00102884 <vector235>:
.globl vector235
vector235:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $235
  102886:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10288b:	e9 5e f6 ff ff       	jmp    101eee <__alltraps>

00102890 <vector236>:
.globl vector236
vector236:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $236
  102892:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102897:	e9 52 f6 ff ff       	jmp    101eee <__alltraps>

0010289c <vector237>:
.globl vector237
vector237:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $237
  10289e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028a3:	e9 46 f6 ff ff       	jmp    101eee <__alltraps>

001028a8 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $238
  1028aa:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028af:	e9 3a f6 ff ff       	jmp    101eee <__alltraps>

001028b4 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $239
  1028b6:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028bb:	e9 2e f6 ff ff       	jmp    101eee <__alltraps>

001028c0 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $240
  1028c2:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028c7:	e9 22 f6 ff ff       	jmp    101eee <__alltraps>

001028cc <vector241>:
.globl vector241
vector241:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $241
  1028ce:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028d3:	e9 16 f6 ff ff       	jmp    101eee <__alltraps>

001028d8 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $242
  1028da:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028df:	e9 0a f6 ff ff       	jmp    101eee <__alltraps>

001028e4 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $243
  1028e6:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028eb:	e9 fe f5 ff ff       	jmp    101eee <__alltraps>

001028f0 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $244
  1028f2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028f7:	e9 f2 f5 ff ff       	jmp    101eee <__alltraps>

001028fc <vector245>:
.globl vector245
vector245:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $245
  1028fe:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102903:	e9 e6 f5 ff ff       	jmp    101eee <__alltraps>

00102908 <vector246>:
.globl vector246
vector246:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $246
  10290a:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10290f:	e9 da f5 ff ff       	jmp    101eee <__alltraps>

00102914 <vector247>:
.globl vector247
vector247:
  pushl $0
  102914:	6a 00                	push   $0x0
  pushl $247
  102916:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10291b:	e9 ce f5 ff ff       	jmp    101eee <__alltraps>

00102920 <vector248>:
.globl vector248
vector248:
  pushl $0
  102920:	6a 00                	push   $0x0
  pushl $248
  102922:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102927:	e9 c2 f5 ff ff       	jmp    101eee <__alltraps>

0010292c <vector249>:
.globl vector249
vector249:
  pushl $0
  10292c:	6a 00                	push   $0x0
  pushl $249
  10292e:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102933:	e9 b6 f5 ff ff       	jmp    101eee <__alltraps>

00102938 <vector250>:
.globl vector250
vector250:
  pushl $0
  102938:	6a 00                	push   $0x0
  pushl $250
  10293a:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10293f:	e9 aa f5 ff ff       	jmp    101eee <__alltraps>

00102944 <vector251>:
.globl vector251
vector251:
  pushl $0
  102944:	6a 00                	push   $0x0
  pushl $251
  102946:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10294b:	e9 9e f5 ff ff       	jmp    101eee <__alltraps>

00102950 <vector252>:
.globl vector252
vector252:
  pushl $0
  102950:	6a 00                	push   $0x0
  pushl $252
  102952:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102957:	e9 92 f5 ff ff       	jmp    101eee <__alltraps>

0010295c <vector253>:
.globl vector253
vector253:
  pushl $0
  10295c:	6a 00                	push   $0x0
  pushl $253
  10295e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102963:	e9 86 f5 ff ff       	jmp    101eee <__alltraps>

00102968 <vector254>:
.globl vector254
vector254:
  pushl $0
  102968:	6a 00                	push   $0x0
  pushl $254
  10296a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10296f:	e9 7a f5 ff ff       	jmp    101eee <__alltraps>

00102974 <vector255>:
.globl vector255
vector255:
  pushl $0
  102974:	6a 00                	push   $0x0
  pushl $255
  102976:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10297b:	e9 6e f5 ff ff       	jmp    101eee <__alltraps>

00102980 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102980:	55                   	push   %ebp
  102981:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102983:	8b 55 08             	mov    0x8(%ebp),%edx
  102986:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  10298b:	29 c2                	sub    %eax,%edx
  10298d:	89 d0                	mov    %edx,%eax
  10298f:	c1 f8 02             	sar    $0x2,%eax
  102992:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102998:	5d                   	pop    %ebp
  102999:	c3                   	ret    

0010299a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10299a:	55                   	push   %ebp
  10299b:	89 e5                	mov    %esp,%ebp
  10299d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a3:	89 04 24             	mov    %eax,(%esp)
  1029a6:	e8 d5 ff ff ff       	call   102980 <page2ppn>
  1029ab:	c1 e0 0c             	shl    $0xc,%eax
}
  1029ae:	c9                   	leave  
  1029af:	c3                   	ret    

001029b0 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1029b0:	55                   	push   %ebp
  1029b1:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b6:	8b 00                	mov    (%eax),%eax
}
  1029b8:	5d                   	pop    %ebp
  1029b9:	c3                   	ret    

001029ba <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1029ba:	55                   	push   %ebp
  1029bb:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029c3:	89 10                	mov    %edx,(%eax)
}
  1029c5:	5d                   	pop    %ebp
  1029c6:	c3                   	ret    

001029c7 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1029c7:	55                   	push   %ebp
  1029c8:	89 e5                	mov    %esp,%ebp
  1029ca:	83 ec 10             	sub    $0x10,%esp
  1029cd:	c7 45 fc b0 89 11 00 	movl   $0x1189b0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1029d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1029da:	89 50 04             	mov    %edx,0x4(%eax)
  1029dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029e0:	8b 50 04             	mov    0x4(%eax),%edx
  1029e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029e6:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);   //未更改，建立一个空的双向链表
    nr_free = 0;             //设置空块总量为0
  1029e8:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  1029ef:	00 00 00 
}
  1029f2:	c9                   	leave  
  1029f3:	c3                   	ret    

001029f4 <default_init_memmap>:
/**
 * 初始化管理空闲内存页的数据结构
 * 探测到一个基址为base，大小为n 的空间，将它加入list（开始时做一点检查）
 */
static void
default_init_memmap(struct Page *base, size_t n) {
  1029f4:	55                   	push   %ebp
  1029f5:	89 e5                	mov    %esp,%ebp
  1029f7:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1029fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1029fe:	75 24                	jne    102a24 <default_init_memmap+0x30>
  102a00:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  102a07:	00 
  102a08:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102a0f:	00 
  102a10:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  102a17:	00 
  102a18:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102a1f:	e8 8e e2 ff ff       	call   100cb2 <__panic>
    struct Page *p = base;
  102a24:	8b 45 08             	mov    0x8(%ebp),%eax
  102a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102a2a:	eb 7d                	jmp    102aa9 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a2f:	83 c0 04             	add    $0x4,%eax
  102a32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a39:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a42:	0f a3 10             	bt     %edx,(%eax)
  102a45:	19 c0                	sbb    %eax,%eax
  102a47:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102a4a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a4e:	0f 95 c0             	setne  %al
  102a51:	0f b6 c0             	movzbl %al,%eax
  102a54:	85 c0                	test   %eax,%eax
  102a56:	75 24                	jne    102a7c <default_init_memmap+0x88>
  102a58:	c7 44 24 0c 61 68 10 	movl   $0x106861,0xc(%esp)
  102a5f:	00 
  102a60:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102a67:	00 
  102a68:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  102a6f:	00 
  102a70:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102a77:	e8 36 e2 ff ff       	call   100cb2 <__panic>
        p->flags = p->property = 0;
  102a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a7f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a89:	8b 50 08             	mov    0x8(%eax),%edx
  102a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a8f:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  102a92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a99:	00 
  102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a9d:	89 04 24             	mov    %eax,(%esp)
  102aa0:	e8 15 ff ff ff       	call   1029ba <set_page_ref>
 */
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102aa5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102aac:	89 d0                	mov    %edx,%eax
  102aae:	c1 e0 02             	shl    $0x2,%eax
  102ab1:	01 d0                	add    %edx,%eax
  102ab3:	c1 e0 02             	shl    $0x2,%eax
  102ab6:	89 c2                	mov    %eax,%edx
  102ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  102abb:	01 d0                	add    %edx,%eax
  102abd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ac0:	0f 85 66 ff ff ff    	jne    102a2c <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102acc:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102acf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad2:	83 c0 04             	add    $0x4,%eax
  102ad5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102adc:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102adf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ae2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ae5:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  102ae8:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  102aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102af1:	01 d0                	add    %edx,%eax
  102af3:	a3 b8 89 11 00       	mov    %eax,0x1189b8
    // 按地址序，依次往后排列。双向链表，头指针指向的前一个就是最后一个。
    list_add_before(&free_list, &(base->page_link)); 
  102af8:	8b 45 08             	mov    0x8(%ebp),%eax
  102afb:	83 c0 0c             	add    $0xc,%eax
  102afe:	c7 45 dc b0 89 11 00 	movl   $0x1189b0,-0x24(%ebp)
  102b05:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102b08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b0b:	8b 00                	mov    (%eax),%eax
  102b0d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102b13:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b19:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b1f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b22:	89 10                	mov    %edx,(%eax)
  102b24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b27:	8b 10                	mov    (%eax),%edx
  102b29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b2c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b32:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b35:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b3b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b3e:	89 10                	mov    %edx,(%eax)
}
  102b40:	c9                   	leave  
  102b41:	c3                   	ret    

00102b42 <default_alloc_pages>:

// 可以发现，现在的分配方法中list是无序的，就是根据释放时序。
// 取的时候，直接去找第一个可行的。
static struct Page *
default_alloc_pages(size_t n) {
  102b42:	55                   	push   %ebp
  102b43:	89 e5                	mov    %esp,%ebp
  102b45:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102b48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b4c:	75 24                	jne    102b72 <default_alloc_pages+0x30>
  102b4e:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  102b55:	00 
  102b56:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102b5d:	00 
  102b5e:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  102b65:	00 
  102b66:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102b6d:	e8 40 e1 ff ff       	call   100cb2 <__panic>
    // 要的页数比剩余free的页数都多，return null
    if (n > nr_free) {
  102b72:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102b77:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b7a:	73 0a                	jae    102b86 <default_alloc_pages+0x44>
        return NULL;
  102b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  102b81:	e9 3d 01 00 00       	jmp    102cc3 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
  102b86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102b8d:	c7 45 f0 b0 89 11 00 	movl   $0x1189b0,-0x10(%ebp)
    // 找了一圈后退出 TODO: list有空的头结点吗？有吧。
    while ((le = list_next(le)) != &free_list) {
  102b94:	eb 1c                	jmp    102bb2 <default_alloc_pages+0x70>
        // 找到这个节点所在的基于Page的变量
        struct Page *p = le2page(le, page_link);
  102b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b99:	83 e8 0c             	sub    $0xc,%eax
  102b9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        // 找到了一个满足的，就把这个空间（的首页）拿出来
        if (p->property >= n) {
  102b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ba2:	8b 40 08             	mov    0x8(%eax),%eax
  102ba5:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ba8:	72 08                	jb     102bb2 <default_alloc_pages+0x70>
            page = p;
  102baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102bb0:	eb 18                	jmp    102bca <default_alloc_pages+0x88>
  102bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bbb:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    // 找了一圈后退出 TODO: list有空的头结点吗？有吧。
    while ((le = list_next(le)) != &free_list) {
  102bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bc1:	81 7d f0 b0 89 11 00 	cmpl   $0x1189b0,-0x10(%ebp)
  102bc8:	75 cc                	jne    102b96 <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
    //如果找到了可行区域
    if (page != NULL) {
  102bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102bce:	0f 84 ec 00 00 00    	je     102cc0 <default_alloc_pages+0x17e>
        // 这个可行区域的空间大于需求空间，拆分，将剩下的一段放到list中【free_list的后面一个】
        if (page->property > n) {
  102bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bd7:	8b 40 08             	mov    0x8(%eax),%eax
  102bda:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bdd:	0f 86 8c 00 00 00    	jbe    102c6f <default_alloc_pages+0x12d>
            struct Page *p = page + n;
  102be3:	8b 55 08             	mov    0x8(%ebp),%edx
  102be6:	89 d0                	mov    %edx,%eax
  102be8:	c1 e0 02             	shl    $0x2,%eax
  102beb:	01 d0                	add    %edx,%eax
  102bed:	c1 e0 02             	shl    $0x2,%eax
  102bf0:	89 c2                	mov    %eax,%edx
  102bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bf5:	01 d0                	add    %edx,%eax
  102bf7:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bfd:	8b 40 08             	mov    0x8(%eax),%eax
  102c00:	2b 45 08             	sub    0x8(%ebp),%eax
  102c03:	89 c2                	mov    %eax,%edx
  102c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c08:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  102c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c0e:	83 c0 04             	add    $0x4,%eax
  102c11:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102c18:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102c1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102c21:	0f ab 10             	bts    %edx,(%eax)
            // 加入后来的，p
            list_add_after(&(page->page_link), &(p->page_link));
  102c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c27:	83 c0 0c             	add    $0xc,%eax
  102c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c2d:	83 c2 0c             	add    $0xc,%edx
  102c30:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102c33:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102c36:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c39:	8b 40 04             	mov    0x4(%eax),%eax
  102c3c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c3f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102c42:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c45:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102c48:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102c4b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102c51:	89 10                	mov    %edx,(%eax)
  102c53:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c56:	8b 10                	mov    (%eax),%edx
  102c58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c5b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c61:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c64:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c67:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c6a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102c6d:	89 10                	mov    %edx,(%eax)
            // list_add(&free_list, &(p->page_link));
        }
        // 删除原来的
        list_del(&(page->page_link));
  102c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c72:	83 c0 0c             	add    $0xc,%eax
  102c75:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102c78:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c7b:	8b 40 04             	mov    0x4(%eax),%eax
  102c7e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102c81:	8b 12                	mov    (%edx),%edx
  102c83:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102c86:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102c89:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102c8c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102c8f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c92:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c95:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102c98:	89 10                	mov    %edx,(%eax)
        // 更新空余空间的状态
        nr_free -= n;
  102c9a:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102c9f:	2b 45 08             	sub    0x8(%ebp),%eax
  102ca2:	a3 b8 89 11 00       	mov    %eax,0x1189b8
        //page被使用了，所以把它的属性clear掉
        ClearPageProperty(page);
  102ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102caa:	83 c0 04             	add    $0x4,%eax
  102cad:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102cb4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cb7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102cba:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102cbd:	0f b3 10             	btr    %edx,(%eax)
    }
    // 返回page
    return page;
  102cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102cc3:	c9                   	leave  
  102cc4:	c3                   	ret    

00102cc5 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102cc5:	55                   	push   %ebp
  102cc6:	89 e5                	mov    %esp,%ebp
  102cc8:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
  102cce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cd2:	75 24                	jne    102cf8 <default_free_pages+0x33>
  102cd4:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  102cdb:	00 
  102cdc:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102ce3:	00 
  102ce4:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  102ceb:	00 
  102cec:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102cf3:	e8 ba df ff ff       	call   100cb2 <__panic>
    struct Page *p = base;
  102cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // 先更改被释放的这几页的标记位
    for (; p != base + n; p ++) {
  102cfe:	e9 9d 00 00 00       	jmp    102da0 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d06:	83 c0 04             	add    $0x4,%eax
  102d09:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  102d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d19:	0f a3 10             	bt     %edx,(%eax)
  102d1c:	19 c0                	sbb    %eax,%eax
  102d1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
  102d21:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d25:	0f 95 c0             	setne  %al
  102d28:	0f b6 c0             	movzbl %al,%eax
  102d2b:	85 c0                	test   %eax,%eax
  102d2d:	75 2c                	jne    102d5b <default_free_pages+0x96>
  102d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d32:	83 c0 04             	add    $0x4,%eax
  102d35:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  102d3c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d42:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102d45:	0f a3 10             	bt     %edx,(%eax)
  102d48:	19 c0                	sbb    %eax,%eax
  102d4a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  102d4d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  102d51:	0f 95 c0             	setne  %al
  102d54:	0f b6 c0             	movzbl %al,%eax
  102d57:	85 c0                	test   %eax,%eax
  102d59:	74 24                	je     102d7f <default_free_pages+0xba>
  102d5b:	c7 44 24 0c 74 68 10 	movl   $0x106874,0xc(%esp)
  102d62:	00 
  102d63:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102d6a:	00 
  102d6b:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  102d72:	00 
  102d73:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102d7a:	e8 33 df ff ff       	call   100cb2 <__panic>
        p->flags = 0;
  102d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102d89:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d90:	00 
  102d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d94:	89 04 24             	mov    %eax,(%esp)
  102d97:	e8 1e fc ff ff       	call   1029ba <set_page_ref>
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    // 先更改被释放的这几页的标记位
    for (; p != base + n; p ++) {
  102d9c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102da3:	89 d0                	mov    %edx,%eax
  102da5:	c1 e0 02             	shl    $0x2,%eax
  102da8:	01 d0                	add    %edx,%eax
  102daa:	c1 e0 02             	shl    $0x2,%eax
  102dad:	89 c2                	mov    %eax,%edx
  102daf:	8b 45 08             	mov    0x8(%ebp),%eax
  102db2:	01 d0                	add    %edx,%eax
  102db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102db7:	0f 85 46 ff ff ff    	jne    102d03 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    // 将这几块视为一个连续的内存空间
    base->property = n;
  102dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dc3:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc9:	83 c0 04             	add    $0x4,%eax
  102dcc:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  102dd3:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dd6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102dd9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102ddc:	0f ab 10             	bts    %edx,(%eax)
  102ddf:	c7 45 c4 b0 89 11 00 	movl   $0x1189b0,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102de6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102de9:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *next_entry = list_next(&free_list);
  102dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 找到base的前一块空块
    while (next_entry != &free_list && le2page(next_entry, page_link) < base)
  102def:	eb 0f                	jmp    102e00 <default_free_pages+0x13b>
  102df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102df4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  102df7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102dfa:	8b 40 04             	mov    0x4(%eax),%eax
        next_entry = list_next(next_entry);
  102dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 将这几块视为一个连续的内存空间
    base->property = n;
    SetPageProperty(base);
    list_entry_t *next_entry = list_next(&free_list);
    // 找到base的前一块空块
    while (next_entry != &free_list && le2page(next_entry, page_link) < base)
  102e00:	81 7d f0 b0 89 11 00 	cmpl   $0x1189b0,-0x10(%ebp)
  102e07:	74 0b                	je     102e14 <default_free_pages+0x14f>
  102e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e0c:	83 e8 0c             	sub    $0xc,%eax
  102e0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  102e12:	72 dd                	jb     102df1 <default_free_pages+0x12c>
  102e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e17:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102e1a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102e1d:	8b 00                	mov    (%eax),%eax
        next_entry = list_next(next_entry);
    // Merge block
    list_entry_t *prev_entry = list_prev(next_entry);
  102e1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    list_entry_t *insert_entry = prev_entry;
  102e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e25:	89 45 ec             	mov    %eax,-0x14(%ebp)
    // 如果和前一块挨在一起，就和前一块合并
    if (prev_entry != &free_list) {
  102e28:	81 7d e8 b0 89 11 00 	cmpl   $0x1189b0,-0x18(%ebp)
  102e2f:	0f 84 8e 00 00 00    	je     102ec3 <default_free_pages+0x1fe>
        p = le2page(prev_entry, page_link);
  102e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e38:	83 e8 0c             	sub    $0xc,%eax
  102e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (p + p->property == base) {
  102e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e41:	8b 50 08             	mov    0x8(%eax),%edx
  102e44:	89 d0                	mov    %edx,%eax
  102e46:	c1 e0 02             	shl    $0x2,%eax
  102e49:	01 d0                	add    %edx,%eax
  102e4b:	c1 e0 02             	shl    $0x2,%eax
  102e4e:	89 c2                	mov    %eax,%edx
  102e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e53:	01 d0                	add    %edx,%eax
  102e55:	3b 45 08             	cmp    0x8(%ebp),%eax
  102e58:	75 69                	jne    102ec3 <default_free_pages+0x1fe>
            p->property += base->property;
  102e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e5d:	8b 50 08             	mov    0x8(%eax),%edx
  102e60:	8b 45 08             	mov    0x8(%ebp),%eax
  102e63:	8b 40 08             	mov    0x8(%eax),%eax
  102e66:	01 c2                	add    %eax,%edx
  102e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e6b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e71:	83 c0 04             	add    $0x4,%eax
  102e74:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102e7b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e7e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e81:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102e84:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e8a:	89 45 08             	mov    %eax,0x8(%ebp)
  102e8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e90:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102e93:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e96:	8b 00                	mov    (%eax),%eax
            insert_entry = list_prev(prev_entry);
  102e98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e9e:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102ea1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102ea4:	8b 40 04             	mov    0x4(%eax),%eax
  102ea7:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102eaa:	8b 12                	mov    (%edx),%edx
  102eac:	89 55 a8             	mov    %edx,-0x58(%ebp)
  102eaf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102eb2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102eb5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102eb8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102ebb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102ebe:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102ec1:	89 10                	mov    %edx,(%eax)
            list_del(prev_entry);
        }
    }
    if (next_entry != &free_list) {
  102ec3:	81 7d f0 b0 89 11 00 	cmpl   $0x1189b0,-0x10(%ebp)
  102eca:	74 7a                	je     102f46 <default_free_pages+0x281>
        p = le2page(next_entry, page_link);
  102ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ecf:	83 e8 0c             	sub    $0xc,%eax
  102ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
  102ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed8:	8b 50 08             	mov    0x8(%eax),%edx
  102edb:	89 d0                	mov    %edx,%eax
  102edd:	c1 e0 02             	shl    $0x2,%eax
  102ee0:	01 d0                	add    %edx,%eax
  102ee2:	c1 e0 02             	shl    $0x2,%eax
  102ee5:	89 c2                	mov    %eax,%edx
  102ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eea:	01 d0                	add    %edx,%eax
  102eec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102eef:	75 55                	jne    102f46 <default_free_pages+0x281>
            base->property += p->property;
  102ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef4:	8b 50 08             	mov    0x8(%eax),%edx
  102ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102efa:	8b 40 08             	mov    0x8(%eax),%eax
  102efd:	01 c2                	add    %eax,%edx
  102eff:	8b 45 08             	mov    0x8(%ebp),%eax
  102f02:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f08:	83 c0 04             	add    $0x4,%eax
  102f0b:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  102f12:	89 45 9c             	mov    %eax,-0x64(%ebp)
  102f15:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102f18:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102f1b:	0f b3 10             	btr    %edx,(%eax)
  102f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f21:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102f24:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f27:	8b 40 04             	mov    0x4(%eax),%eax
  102f2a:	8b 55 98             	mov    -0x68(%ebp),%edx
  102f2d:	8b 12                	mov    (%edx),%edx
  102f2f:	89 55 94             	mov    %edx,-0x6c(%ebp)
  102f32:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102f35:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f38:	8b 55 90             	mov    -0x70(%ebp),%edx
  102f3b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f3e:	8b 45 90             	mov    -0x70(%ebp),%eax
  102f41:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102f44:	89 10                	mov    %edx,(%eax)
            list_del(next_entry);
        }
    }
    nr_free += n;
  102f46:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  102f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f4f:	01 d0                	add    %edx,%eax
  102f51:	a3 b8 89 11 00       	mov    %eax,0x1189b8
    list_add(insert_entry, &(base->page_link));
  102f56:	8b 45 08             	mov    0x8(%ebp),%eax
  102f59:	8d 50 0c             	lea    0xc(%eax),%edx
  102f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f5f:	89 45 8c             	mov    %eax,-0x74(%ebp)
  102f62:	89 55 88             	mov    %edx,-0x78(%ebp)
  102f65:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f68:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102f6b:	8b 45 88             	mov    -0x78(%ebp),%eax
  102f6e:	89 45 80             	mov    %eax,-0x80(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102f71:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102f74:	8b 40 04             	mov    0x4(%eax),%eax
  102f77:	8b 55 80             	mov    -0x80(%ebp),%edx
  102f7a:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102f80:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102f83:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
  102f89:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102f8f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  102f95:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102f9b:	89 10                	mov    %edx,(%eax)
  102f9d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  102fa3:	8b 10                	mov    (%eax),%edx
  102fa5:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102fab:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102fae:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102fb4:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  102fba:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102fbd:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102fc3:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  102fc9:	89 10                	mov    %edx,(%eax)
}
  102fcb:	c9                   	leave  
  102fcc:	c3                   	ret    

00102fcd <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102fcd:	55                   	push   %ebp
  102fce:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102fd0:	a1 b8 89 11 00       	mov    0x1189b8,%eax
}
  102fd5:	5d                   	pop    %ebp
  102fd6:	c3                   	ret    

00102fd7 <basic_check>:

static void
basic_check(void) {
  102fd7:	55                   	push   %ebp
  102fd8:	89 e5                	mov    %esp,%ebp
  102fda:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102fdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102ff0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ff7:	e8 85 0e 00 00       	call   103e81 <alloc_pages>
  102ffc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102fff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103003:	75 24                	jne    103029 <basic_check+0x52>
  103005:	c7 44 24 0c 99 68 10 	movl   $0x106899,0xc(%esp)
  10300c:	00 
  10300d:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103014:	00 
  103015:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10301c:	00 
  10301d:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103024:	e8 89 dc ff ff       	call   100cb2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103029:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103030:	e8 4c 0e 00 00       	call   103e81 <alloc_pages>
  103035:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103038:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10303c:	75 24                	jne    103062 <basic_check+0x8b>
  10303e:	c7 44 24 0c b5 68 10 	movl   $0x1068b5,0xc(%esp)
  103045:	00 
  103046:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10304d:	00 
  10304e:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  103055:	00 
  103056:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10305d:	e8 50 dc ff ff       	call   100cb2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103062:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103069:	e8 13 0e 00 00       	call   103e81 <alloc_pages>
  10306e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103075:	75 24                	jne    10309b <basic_check+0xc4>
  103077:	c7 44 24 0c d1 68 10 	movl   $0x1068d1,0xc(%esp)
  10307e:	00 
  10307f:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103086:	00 
  103087:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10308e:	00 
  10308f:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103096:	e8 17 dc ff ff       	call   100cb2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10309b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10309e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1030a1:	74 10                	je     1030b3 <basic_check+0xdc>
  1030a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1030a9:	74 08                	je     1030b3 <basic_check+0xdc>
  1030ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1030b1:	75 24                	jne    1030d7 <basic_check+0x100>
  1030b3:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  1030ba:	00 
  1030bb:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1030c2:	00 
  1030c3:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  1030ca:	00 
  1030cb:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1030d2:	e8 db db ff ff       	call   100cb2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  1030d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030da:	89 04 24             	mov    %eax,(%esp)
  1030dd:	e8 ce f8 ff ff       	call   1029b0 <page_ref>
  1030e2:	85 c0                	test   %eax,%eax
  1030e4:	75 1e                	jne    103104 <basic_check+0x12d>
  1030e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e9:	89 04 24             	mov    %eax,(%esp)
  1030ec:	e8 bf f8 ff ff       	call   1029b0 <page_ref>
  1030f1:	85 c0                	test   %eax,%eax
  1030f3:	75 0f                	jne    103104 <basic_check+0x12d>
  1030f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030f8:	89 04 24             	mov    %eax,(%esp)
  1030fb:	e8 b0 f8 ff ff       	call   1029b0 <page_ref>
  103100:	85 c0                	test   %eax,%eax
  103102:	74 24                	je     103128 <basic_check+0x151>
  103104:	c7 44 24 0c 14 69 10 	movl   $0x106914,0xc(%esp)
  10310b:	00 
  10310c:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103113:	00 
  103114:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  10311b:	00 
  10311c:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103123:	e8 8a db ff ff       	call   100cb2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10312b:	89 04 24             	mov    %eax,(%esp)
  10312e:	e8 67 f8 ff ff       	call   10299a <page2pa>
  103133:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103139:	c1 e2 0c             	shl    $0xc,%edx
  10313c:	39 d0                	cmp    %edx,%eax
  10313e:	72 24                	jb     103164 <basic_check+0x18d>
  103140:	c7 44 24 0c 50 69 10 	movl   $0x106950,0xc(%esp)
  103147:	00 
  103148:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10314f:	00 
  103150:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103157:	00 
  103158:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10315f:	e8 4e db ff ff       	call   100cb2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103167:	89 04 24             	mov    %eax,(%esp)
  10316a:	e8 2b f8 ff ff       	call   10299a <page2pa>
  10316f:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103175:	c1 e2 0c             	shl    $0xc,%edx
  103178:	39 d0                	cmp    %edx,%eax
  10317a:	72 24                	jb     1031a0 <basic_check+0x1c9>
  10317c:	c7 44 24 0c 6d 69 10 	movl   $0x10696d,0xc(%esp)
  103183:	00 
  103184:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10318b:	00 
  10318c:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  103193:	00 
  103194:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10319b:	e8 12 db ff ff       	call   100cb2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031a3:	89 04 24             	mov    %eax,(%esp)
  1031a6:	e8 ef f7 ff ff       	call   10299a <page2pa>
  1031ab:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1031b1:	c1 e2 0c             	shl    $0xc,%edx
  1031b4:	39 d0                	cmp    %edx,%eax
  1031b6:	72 24                	jb     1031dc <basic_check+0x205>
  1031b8:	c7 44 24 0c 8a 69 10 	movl   $0x10698a,0xc(%esp)
  1031bf:	00 
  1031c0:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1031c7:	00 
  1031c8:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  1031cf:	00 
  1031d0:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1031d7:	e8 d6 da ff ff       	call   100cb2 <__panic>

    list_entry_t free_list_store = free_list;
  1031dc:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  1031e1:	8b 15 b4 89 11 00    	mov    0x1189b4,%edx
  1031e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1031ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1031ed:	c7 45 e0 b0 89 11 00 	movl   $0x1189b0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1031f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1031fa:	89 50 04             	mov    %edx,0x4(%eax)
  1031fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103200:	8b 50 04             	mov    0x4(%eax),%edx
  103203:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103206:	89 10                	mov    %edx,(%eax)
  103208:	c7 45 dc b0 89 11 00 	movl   $0x1189b0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10320f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103212:	8b 40 04             	mov    0x4(%eax),%eax
  103215:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103218:	0f 94 c0             	sete   %al
  10321b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10321e:	85 c0                	test   %eax,%eax
  103220:	75 24                	jne    103246 <basic_check+0x26f>
  103222:	c7 44 24 0c a7 69 10 	movl   $0x1069a7,0xc(%esp)
  103229:	00 
  10322a:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103231:	00 
  103232:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  103239:	00 
  10323a:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103241:	e8 6c da ff ff       	call   100cb2 <__panic>

    unsigned int nr_free_store = nr_free;
  103246:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  10324b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10324e:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  103255:	00 00 00 

    assert(alloc_page() == NULL);
  103258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10325f:	e8 1d 0c 00 00       	call   103e81 <alloc_pages>
  103264:	85 c0                	test   %eax,%eax
  103266:	74 24                	je     10328c <basic_check+0x2b5>
  103268:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  10326f:	00 
  103270:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103277:	00 
  103278:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  10327f:	00 
  103280:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103287:	e8 26 da ff ff       	call   100cb2 <__panic>

    free_page(p0);
  10328c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103293:	00 
  103294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103297:	89 04 24             	mov    %eax,(%esp)
  10329a:	e8 1a 0c 00 00       	call   103eb9 <free_pages>
    free_page(p1);
  10329f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032a6:	00 
  1032a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032aa:	89 04 24             	mov    %eax,(%esp)
  1032ad:	e8 07 0c 00 00       	call   103eb9 <free_pages>
    free_page(p2);
  1032b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032b9:	00 
  1032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032bd:	89 04 24             	mov    %eax,(%esp)
  1032c0:	e8 f4 0b 00 00       	call   103eb9 <free_pages>
    assert(nr_free == 3);
  1032c5:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  1032ca:	83 f8 03             	cmp    $0x3,%eax
  1032cd:	74 24                	je     1032f3 <basic_check+0x31c>
  1032cf:	c7 44 24 0c d3 69 10 	movl   $0x1069d3,0xc(%esp)
  1032d6:	00 
  1032d7:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1032de:	00 
  1032df:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1032e6:	00 
  1032e7:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1032ee:	e8 bf d9 ff ff       	call   100cb2 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1032f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032fa:	e8 82 0b 00 00       	call   103e81 <alloc_pages>
  1032ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103302:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103306:	75 24                	jne    10332c <basic_check+0x355>
  103308:	c7 44 24 0c 99 68 10 	movl   $0x106899,0xc(%esp)
  10330f:	00 
  103310:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103317:	00 
  103318:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  10331f:	00 
  103320:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103327:	e8 86 d9 ff ff       	call   100cb2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10332c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103333:	e8 49 0b 00 00       	call   103e81 <alloc_pages>
  103338:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10333b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10333f:	75 24                	jne    103365 <basic_check+0x38e>
  103341:	c7 44 24 0c b5 68 10 	movl   $0x1068b5,0xc(%esp)
  103348:	00 
  103349:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103350:	00 
  103351:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103358:	00 
  103359:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103360:	e8 4d d9 ff ff       	call   100cb2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103365:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10336c:	e8 10 0b 00 00       	call   103e81 <alloc_pages>
  103371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103378:	75 24                	jne    10339e <basic_check+0x3c7>
  10337a:	c7 44 24 0c d1 68 10 	movl   $0x1068d1,0xc(%esp)
  103381:	00 
  103382:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103389:	00 
  10338a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  103391:	00 
  103392:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103399:	e8 14 d9 ff ff       	call   100cb2 <__panic>

    assert(alloc_page() == NULL);
  10339e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033a5:	e8 d7 0a 00 00       	call   103e81 <alloc_pages>
  1033aa:	85 c0                	test   %eax,%eax
  1033ac:	74 24                	je     1033d2 <basic_check+0x3fb>
  1033ae:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  1033b5:	00 
  1033b6:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1033bd:	00 
  1033be:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  1033c5:	00 
  1033c6:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1033cd:	e8 e0 d8 ff ff       	call   100cb2 <__panic>

    free_page(p0);
  1033d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033d9:	00 
  1033da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033dd:	89 04 24             	mov    %eax,(%esp)
  1033e0:	e8 d4 0a 00 00       	call   103eb9 <free_pages>
  1033e5:	c7 45 d8 b0 89 11 00 	movl   $0x1189b0,-0x28(%ebp)
  1033ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1033ef:	8b 40 04             	mov    0x4(%eax),%eax
  1033f2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1033f5:	0f 94 c0             	sete   %al
  1033f8:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1033fb:	85 c0                	test   %eax,%eax
  1033fd:	74 24                	je     103423 <basic_check+0x44c>
  1033ff:	c7 44 24 0c e0 69 10 	movl   $0x1069e0,0xc(%esp)
  103406:	00 
  103407:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10340e:	00 
  10340f:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103416:	00 
  103417:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10341e:	e8 8f d8 ff ff       	call   100cb2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103423:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10342a:	e8 52 0a 00 00       	call   103e81 <alloc_pages>
  10342f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103432:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103435:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103438:	74 24                	je     10345e <basic_check+0x487>
  10343a:	c7 44 24 0c f8 69 10 	movl   $0x1069f8,0xc(%esp)
  103441:	00 
  103442:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103449:	00 
  10344a:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  103451:	00 
  103452:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103459:	e8 54 d8 ff ff       	call   100cb2 <__panic>
    assert(alloc_page() == NULL);
  10345e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103465:	e8 17 0a 00 00       	call   103e81 <alloc_pages>
  10346a:	85 c0                	test   %eax,%eax
  10346c:	74 24                	je     103492 <basic_check+0x4bb>
  10346e:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  103475:	00 
  103476:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10347d:	00 
  10347e:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103485:	00 
  103486:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10348d:	e8 20 d8 ff ff       	call   100cb2 <__panic>

    assert(nr_free == 0);
  103492:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  103497:	85 c0                	test   %eax,%eax
  103499:	74 24                	je     1034bf <basic_check+0x4e8>
  10349b:	c7 44 24 0c 11 6a 10 	movl   $0x106a11,0xc(%esp)
  1034a2:	00 
  1034a3:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1034aa:	00 
  1034ab:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1034b2:	00 
  1034b3:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1034ba:	e8 f3 d7 ff ff       	call   100cb2 <__panic>
    free_list = free_list_store;
  1034bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1034c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1034c5:	a3 b0 89 11 00       	mov    %eax,0x1189b0
  1034ca:	89 15 b4 89 11 00    	mov    %edx,0x1189b4
    nr_free = nr_free_store;
  1034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034d3:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    free_page(p);
  1034d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1034df:	00 
  1034e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034e3:	89 04 24             	mov    %eax,(%esp)
  1034e6:	e8 ce 09 00 00       	call   103eb9 <free_pages>
    free_page(p1);
  1034eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1034f2:	00 
  1034f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034f6:	89 04 24             	mov    %eax,(%esp)
  1034f9:	e8 bb 09 00 00       	call   103eb9 <free_pages>
    free_page(p2);
  1034fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103505:	00 
  103506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103509:	89 04 24             	mov    %eax,(%esp)
  10350c:	e8 a8 09 00 00       	call   103eb9 <free_pages>
}
  103511:	c9                   	leave  
  103512:	c3                   	ret    

00103513 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103513:	55                   	push   %ebp
  103514:	89 e5                	mov    %esp,%ebp
  103516:	53                   	push   %ebx
  103517:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  10351d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103524:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10352b:	c7 45 ec b0 89 11 00 	movl   $0x1189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103532:	eb 6b                	jmp    10359f <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103537:	83 e8 0c             	sub    $0xc,%eax
  10353a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10353d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103540:	83 c0 04             	add    $0x4,%eax
  103543:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10354a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10354d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103550:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103553:	0f a3 10             	bt     %edx,(%eax)
  103556:	19 c0                	sbb    %eax,%eax
  103558:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10355b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10355f:	0f 95 c0             	setne  %al
  103562:	0f b6 c0             	movzbl %al,%eax
  103565:	85 c0                	test   %eax,%eax
  103567:	75 24                	jne    10358d <default_check+0x7a>
  103569:	c7 44 24 0c 1e 6a 10 	movl   $0x106a1e,0xc(%esp)
  103570:	00 
  103571:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103578:	00 
  103579:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  103580:	00 
  103581:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103588:	e8 25 d7 ff ff       	call   100cb2 <__panic>
        count ++, total += p->property;
  10358d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103591:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103594:	8b 50 08             	mov    0x8(%eax),%edx
  103597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10359a:	01 d0                	add    %edx,%eax
  10359c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10359f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1035a5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1035a8:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1035ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1035ae:	81 7d ec b0 89 11 00 	cmpl   $0x1189b0,-0x14(%ebp)
  1035b5:	0f 85 79 ff ff ff    	jne    103534 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1035bb:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1035be:	e8 28 09 00 00       	call   103eeb <nr_free_pages>
  1035c3:	39 c3                	cmp    %eax,%ebx
  1035c5:	74 24                	je     1035eb <default_check+0xd8>
  1035c7:	c7 44 24 0c 2e 6a 10 	movl   $0x106a2e,0xc(%esp)
  1035ce:	00 
  1035cf:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1035d6:	00 
  1035d7:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  1035de:	00 
  1035df:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1035e6:	e8 c7 d6 ff ff       	call   100cb2 <__panic>

    basic_check();
  1035eb:	e8 e7 f9 ff ff       	call   102fd7 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1035f0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1035f7:	e8 85 08 00 00       	call   103e81 <alloc_pages>
  1035fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1035ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103603:	75 24                	jne    103629 <default_check+0x116>
  103605:	c7 44 24 0c 47 6a 10 	movl   $0x106a47,0xc(%esp)
  10360c:	00 
  10360d:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103614:	00 
  103615:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  10361c:	00 
  10361d:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103624:	e8 89 d6 ff ff       	call   100cb2 <__panic>
    assert(!PageProperty(p0));
  103629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10362c:	83 c0 04             	add    $0x4,%eax
  10362f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103636:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103639:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10363c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10363f:	0f a3 10             	bt     %edx,(%eax)
  103642:	19 c0                	sbb    %eax,%eax
  103644:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103647:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10364b:	0f 95 c0             	setne  %al
  10364e:	0f b6 c0             	movzbl %al,%eax
  103651:	85 c0                	test   %eax,%eax
  103653:	74 24                	je     103679 <default_check+0x166>
  103655:	c7 44 24 0c 52 6a 10 	movl   $0x106a52,0xc(%esp)
  10365c:	00 
  10365d:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103664:	00 
  103665:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  10366c:	00 
  10366d:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103674:	e8 39 d6 ff ff       	call   100cb2 <__panic>

    list_entry_t free_list_store = free_list;
  103679:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  10367e:	8b 15 b4 89 11 00    	mov    0x1189b4,%edx
  103684:	89 45 80             	mov    %eax,-0x80(%ebp)
  103687:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10368a:	c7 45 b4 b0 89 11 00 	movl   $0x1189b0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103691:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103694:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103697:	89 50 04             	mov    %edx,0x4(%eax)
  10369a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10369d:	8b 50 04             	mov    0x4(%eax),%edx
  1036a0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1036a3:	89 10                	mov    %edx,(%eax)
  1036a5:	c7 45 b0 b0 89 11 00 	movl   $0x1189b0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1036ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036af:	8b 40 04             	mov    0x4(%eax),%eax
  1036b2:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1036b5:	0f 94 c0             	sete   %al
  1036b8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1036bb:	85 c0                	test   %eax,%eax
  1036bd:	75 24                	jne    1036e3 <default_check+0x1d0>
  1036bf:	c7 44 24 0c a7 69 10 	movl   $0x1069a7,0xc(%esp)
  1036c6:	00 
  1036c7:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1036ce:	00 
  1036cf:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  1036d6:	00 
  1036d7:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1036de:	e8 cf d5 ff ff       	call   100cb2 <__panic>
    assert(alloc_page() == NULL);
  1036e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036ea:	e8 92 07 00 00       	call   103e81 <alloc_pages>
  1036ef:	85 c0                	test   %eax,%eax
  1036f1:	74 24                	je     103717 <default_check+0x204>
  1036f3:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  1036fa:	00 
  1036fb:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103702:	00 
  103703:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  10370a:	00 
  10370b:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103712:	e8 9b d5 ff ff       	call   100cb2 <__panic>

    unsigned int nr_free_store = nr_free;
  103717:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  10371c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10371f:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  103726:	00 00 00 

    free_pages(p0 + 2, 3);
  103729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10372c:	83 c0 28             	add    $0x28,%eax
  10372f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103736:	00 
  103737:	89 04 24             	mov    %eax,(%esp)
  10373a:	e8 7a 07 00 00       	call   103eb9 <free_pages>
    assert(alloc_pages(4) == NULL);
  10373f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103746:	e8 36 07 00 00       	call   103e81 <alloc_pages>
  10374b:	85 c0                	test   %eax,%eax
  10374d:	74 24                	je     103773 <default_check+0x260>
  10374f:	c7 44 24 0c 64 6a 10 	movl   $0x106a64,0xc(%esp)
  103756:	00 
  103757:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10375e:	00 
  10375f:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  103766:	00 
  103767:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10376e:	e8 3f d5 ff ff       	call   100cb2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103776:	83 c0 28             	add    $0x28,%eax
  103779:	83 c0 04             	add    $0x4,%eax
  10377c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103783:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103786:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103789:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10378c:	0f a3 10             	bt     %edx,(%eax)
  10378f:	19 c0                	sbb    %eax,%eax
  103791:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103794:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103798:	0f 95 c0             	setne  %al
  10379b:	0f b6 c0             	movzbl %al,%eax
  10379e:	85 c0                	test   %eax,%eax
  1037a0:	74 0e                	je     1037b0 <default_check+0x29d>
  1037a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037a5:	83 c0 28             	add    $0x28,%eax
  1037a8:	8b 40 08             	mov    0x8(%eax),%eax
  1037ab:	83 f8 03             	cmp    $0x3,%eax
  1037ae:	74 24                	je     1037d4 <default_check+0x2c1>
  1037b0:	c7 44 24 0c 7c 6a 10 	movl   $0x106a7c,0xc(%esp)
  1037b7:	00 
  1037b8:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1037bf:	00 
  1037c0:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1037c7:	00 
  1037c8:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1037cf:	e8 de d4 ff ff       	call   100cb2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1037d4:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1037db:	e8 a1 06 00 00       	call   103e81 <alloc_pages>
  1037e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1037e3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1037e7:	75 24                	jne    10380d <default_check+0x2fa>
  1037e9:	c7 44 24 0c a8 6a 10 	movl   $0x106aa8,0xc(%esp)
  1037f0:	00 
  1037f1:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1037f8:	00 
  1037f9:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  103800:	00 
  103801:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103808:	e8 a5 d4 ff ff       	call   100cb2 <__panic>
    assert(alloc_page() == NULL);
  10380d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103814:	e8 68 06 00 00       	call   103e81 <alloc_pages>
  103819:	85 c0                	test   %eax,%eax
  10381b:	74 24                	je     103841 <default_check+0x32e>
  10381d:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  103824:	00 
  103825:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10382c:	00 
  10382d:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  103834:	00 
  103835:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10383c:	e8 71 d4 ff ff       	call   100cb2 <__panic>
    assert(p0 + 2 == p1);
  103841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103844:	83 c0 28             	add    $0x28,%eax
  103847:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10384a:	74 24                	je     103870 <default_check+0x35d>
  10384c:	c7 44 24 0c c6 6a 10 	movl   $0x106ac6,0xc(%esp)
  103853:	00 
  103854:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10385b:	00 
  10385c:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  103863:	00 
  103864:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10386b:	e8 42 d4 ff ff       	call   100cb2 <__panic>

    p2 = p0 + 1;
  103870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103873:	83 c0 14             	add    $0x14,%eax
  103876:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103879:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103880:	00 
  103881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103884:	89 04 24             	mov    %eax,(%esp)
  103887:	e8 2d 06 00 00       	call   103eb9 <free_pages>
    free_pages(p1, 3);
  10388c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103893:	00 
  103894:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103897:	89 04 24             	mov    %eax,(%esp)
  10389a:	e8 1a 06 00 00       	call   103eb9 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10389f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038a2:	83 c0 04             	add    $0x4,%eax
  1038a5:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1038ac:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1038af:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1038b2:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1038b5:	0f a3 10             	bt     %edx,(%eax)
  1038b8:	19 c0                	sbb    %eax,%eax
  1038ba:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1038bd:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1038c1:	0f 95 c0             	setne  %al
  1038c4:	0f b6 c0             	movzbl %al,%eax
  1038c7:	85 c0                	test   %eax,%eax
  1038c9:	74 0b                	je     1038d6 <default_check+0x3c3>
  1038cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038ce:	8b 40 08             	mov    0x8(%eax),%eax
  1038d1:	83 f8 01             	cmp    $0x1,%eax
  1038d4:	74 24                	je     1038fa <default_check+0x3e7>
  1038d6:	c7 44 24 0c d4 6a 10 	movl   $0x106ad4,0xc(%esp)
  1038dd:	00 
  1038de:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1038e5:	00 
  1038e6:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1038ed:	00 
  1038ee:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1038f5:	e8 b8 d3 ff ff       	call   100cb2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1038fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1038fd:	83 c0 04             	add    $0x4,%eax
  103900:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103907:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10390a:	8b 45 90             	mov    -0x70(%ebp),%eax
  10390d:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103910:	0f a3 10             	bt     %edx,(%eax)
  103913:	19 c0                	sbb    %eax,%eax
  103915:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103918:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10391c:	0f 95 c0             	setne  %al
  10391f:	0f b6 c0             	movzbl %al,%eax
  103922:	85 c0                	test   %eax,%eax
  103924:	74 0b                	je     103931 <default_check+0x41e>
  103926:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103929:	8b 40 08             	mov    0x8(%eax),%eax
  10392c:	83 f8 03             	cmp    $0x3,%eax
  10392f:	74 24                	je     103955 <default_check+0x442>
  103931:	c7 44 24 0c fc 6a 10 	movl   $0x106afc,0xc(%esp)
  103938:	00 
  103939:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103940:	00 
  103941:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  103948:	00 
  103949:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103950:	e8 5d d3 ff ff       	call   100cb2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103955:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10395c:	e8 20 05 00 00       	call   103e81 <alloc_pages>
  103961:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103967:	83 e8 14             	sub    $0x14,%eax
  10396a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10396d:	74 24                	je     103993 <default_check+0x480>
  10396f:	c7 44 24 0c 22 6b 10 	movl   $0x106b22,0xc(%esp)
  103976:	00 
  103977:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10397e:	00 
  10397f:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  103986:	00 
  103987:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10398e:	e8 1f d3 ff ff       	call   100cb2 <__panic>
    free_page(p0);
  103993:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10399a:	00 
  10399b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10399e:	89 04 24             	mov    %eax,(%esp)
  1039a1:	e8 13 05 00 00       	call   103eb9 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1039a6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1039ad:	e8 cf 04 00 00       	call   103e81 <alloc_pages>
  1039b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1039b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1039b8:	83 c0 14             	add    $0x14,%eax
  1039bb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1039be:	74 24                	je     1039e4 <default_check+0x4d1>
  1039c0:	c7 44 24 0c 40 6b 10 	movl   $0x106b40,0xc(%esp)
  1039c7:	00 
  1039c8:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1039cf:	00 
  1039d0:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  1039d7:	00 
  1039d8:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1039df:	e8 ce d2 ff ff       	call   100cb2 <__panic>

    free_pages(p0, 2);
  1039e4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1039eb:	00 
  1039ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1039ef:	89 04 24             	mov    %eax,(%esp)
  1039f2:	e8 c2 04 00 00       	call   103eb9 <free_pages>
    free_page(p2);
  1039f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1039fe:	00 
  1039ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a02:	89 04 24             	mov    %eax,(%esp)
  103a05:	e8 af 04 00 00       	call   103eb9 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a0a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103a11:	e8 6b 04 00 00       	call   103e81 <alloc_pages>
  103a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103a1d:	75 24                	jne    103a43 <default_check+0x530>
  103a1f:	c7 44 24 0c 60 6b 10 	movl   $0x106b60,0xc(%esp)
  103a26:	00 
  103a27:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103a2e:	00 
  103a2f:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  103a36:	00 
  103a37:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103a3e:	e8 6f d2 ff ff       	call   100cb2 <__panic>
    assert(alloc_page() == NULL);
  103a43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a4a:	e8 32 04 00 00       	call   103e81 <alloc_pages>
  103a4f:	85 c0                	test   %eax,%eax
  103a51:	74 24                	je     103a77 <default_check+0x564>
  103a53:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  103a5a:	00 
  103a5b:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103a62:	00 
  103a63:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  103a6a:	00 
  103a6b:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103a72:	e8 3b d2 ff ff       	call   100cb2 <__panic>

    assert(nr_free == 0);
  103a77:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  103a7c:	85 c0                	test   %eax,%eax
  103a7e:	74 24                	je     103aa4 <default_check+0x591>
  103a80:	c7 44 24 0c 11 6a 10 	movl   $0x106a11,0xc(%esp)
  103a87:	00 
  103a88:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103a8f:	00 
  103a90:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  103a97:	00 
  103a98:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103a9f:	e8 0e d2 ff ff       	call   100cb2 <__panic>
    nr_free = nr_free_store;
  103aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103aa7:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    free_list = free_list_store;
  103aac:	8b 45 80             	mov    -0x80(%ebp),%eax
  103aaf:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103ab2:	a3 b0 89 11 00       	mov    %eax,0x1189b0
  103ab7:	89 15 b4 89 11 00    	mov    %edx,0x1189b4
    free_pages(p0, 5);
  103abd:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103ac4:	00 
  103ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ac8:	89 04 24             	mov    %eax,(%esp)
  103acb:	e8 e9 03 00 00       	call   103eb9 <free_pages>

    le = &free_list;
  103ad0:	c7 45 ec b0 89 11 00 	movl   $0x1189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103ad7:	eb 1d                	jmp    103af6 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103adc:	83 e8 0c             	sub    $0xc,%eax
  103adf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103ae2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103ae6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103ae9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103aec:	8b 40 08             	mov    0x8(%eax),%eax
  103aef:	29 c2                	sub    %eax,%edx
  103af1:	89 d0                	mov    %edx,%eax
  103af3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103af9:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103afc:	8b 45 88             	mov    -0x78(%ebp),%eax
  103aff:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103b02:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b05:	81 7d ec b0 89 11 00 	cmpl   $0x1189b0,-0x14(%ebp)
  103b0c:	75 cb                	jne    103ad9 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103b12:	74 24                	je     103b38 <default_check+0x625>
  103b14:	c7 44 24 0c 7e 6b 10 	movl   $0x106b7e,0xc(%esp)
  103b1b:	00 
  103b1c:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103b23:	00 
  103b24:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
  103b2b:	00 
  103b2c:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103b33:	e8 7a d1 ff ff       	call   100cb2 <__panic>
    assert(total == 0);
  103b38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103b3c:	74 24                	je     103b62 <default_check+0x64f>
  103b3e:	c7 44 24 0c 89 6b 10 	movl   $0x106b89,0xc(%esp)
  103b45:	00 
  103b46:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103b4d:	00 
  103b4e:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
  103b55:	00 
  103b56:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103b5d:	e8 50 d1 ff ff       	call   100cb2 <__panic>
}
  103b62:	81 c4 94 00 00 00    	add    $0x94,%esp
  103b68:	5b                   	pop    %ebx
  103b69:	5d                   	pop    %ebp
  103b6a:	c3                   	ret    

00103b6b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103b6b:	55                   	push   %ebp
  103b6c:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  103b71:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  103b76:	29 c2                	sub    %eax,%edx
  103b78:	89 d0                	mov    %edx,%eax
  103b7a:	c1 f8 02             	sar    $0x2,%eax
  103b7d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103b83:	5d                   	pop    %ebp
  103b84:	c3                   	ret    

00103b85 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103b85:	55                   	push   %ebp
  103b86:	89 e5                	mov    %esp,%ebp
  103b88:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b8e:	89 04 24             	mov    %eax,(%esp)
  103b91:	e8 d5 ff ff ff       	call   103b6b <page2ppn>
  103b96:	c1 e0 0c             	shl    $0xc,%eax
}
  103b99:	c9                   	leave  
  103b9a:	c3                   	ret    

00103b9b <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103b9b:	55                   	push   %ebp
  103b9c:	89 e5                	mov    %esp,%ebp
  103b9e:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  103ba4:	c1 e8 0c             	shr    $0xc,%eax
  103ba7:	89 c2                	mov    %eax,%edx
  103ba9:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103bae:	39 c2                	cmp    %eax,%edx
  103bb0:	72 1c                	jb     103bce <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103bb2:	c7 44 24 08 c4 6b 10 	movl   $0x106bc4,0x8(%esp)
  103bb9:	00 
  103bba:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103bc1:	00 
  103bc2:	c7 04 24 e3 6b 10 00 	movl   $0x106be3,(%esp)
  103bc9:	e8 e4 d0 ff ff       	call   100cb2 <__panic>
    }
    return &pages[PPN(pa)];
  103bce:	8b 0d c4 89 11 00    	mov    0x1189c4,%ecx
  103bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  103bd7:	c1 e8 0c             	shr    $0xc,%eax
  103bda:	89 c2                	mov    %eax,%edx
  103bdc:	89 d0                	mov    %edx,%eax
  103bde:	c1 e0 02             	shl    $0x2,%eax
  103be1:	01 d0                	add    %edx,%eax
  103be3:	c1 e0 02             	shl    $0x2,%eax
  103be6:	01 c8                	add    %ecx,%eax
}
  103be8:	c9                   	leave  
  103be9:	c3                   	ret    

00103bea <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103bea:	55                   	push   %ebp
  103beb:	89 e5                	mov    %esp,%ebp
  103bed:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  103bf3:	89 04 24             	mov    %eax,(%esp)
  103bf6:	e8 8a ff ff ff       	call   103b85 <page2pa>
  103bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c01:	c1 e8 0c             	shr    $0xc,%eax
  103c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c07:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103c0c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103c0f:	72 23                	jb     103c34 <page2kva+0x4a>
  103c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c14:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c18:	c7 44 24 08 f4 6b 10 	movl   $0x106bf4,0x8(%esp)
  103c1f:	00 
  103c20:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103c27:	00 
  103c28:	c7 04 24 e3 6b 10 00 	movl   $0x106be3,(%esp)
  103c2f:	e8 7e d0 ff ff       	call   100cb2 <__panic>
  103c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c37:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103c3c:	c9                   	leave  
  103c3d:	c3                   	ret    

00103c3e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103c3e:	55                   	push   %ebp
  103c3f:	89 e5                	mov    %esp,%ebp
  103c41:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103c44:	8b 45 08             	mov    0x8(%ebp),%eax
  103c47:	83 e0 01             	and    $0x1,%eax
  103c4a:	85 c0                	test   %eax,%eax
  103c4c:	75 1c                	jne    103c6a <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103c4e:	c7 44 24 08 18 6c 10 	movl   $0x106c18,0x8(%esp)
  103c55:	00 
  103c56:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103c5d:	00 
  103c5e:	c7 04 24 e3 6b 10 00 	movl   $0x106be3,(%esp)
  103c65:	e8 48 d0 ff ff       	call   100cb2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  103c6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103c72:	89 04 24             	mov    %eax,(%esp)
  103c75:	e8 21 ff ff ff       	call   103b9b <pa2page>
}
  103c7a:	c9                   	leave  
  103c7b:	c3                   	ret    

00103c7c <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103c7c:	55                   	push   %ebp
  103c7d:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  103c82:	8b 00                	mov    (%eax),%eax
}
  103c84:	5d                   	pop    %ebp
  103c85:	c3                   	ret    

00103c86 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103c86:	55                   	push   %ebp
  103c87:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103c89:	8b 45 08             	mov    0x8(%ebp),%eax
  103c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c8f:	89 10                	mov    %edx,(%eax)
}
  103c91:	5d                   	pop    %ebp
  103c92:	c3                   	ret    

00103c93 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103c93:	55                   	push   %ebp
  103c94:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103c96:	8b 45 08             	mov    0x8(%ebp),%eax
  103c99:	8b 00                	mov    (%eax),%eax
  103c9b:	8d 50 01             	lea    0x1(%eax),%edx
  103c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  103ca1:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ca6:	8b 00                	mov    (%eax),%eax
}
  103ca8:	5d                   	pop    %ebp
  103ca9:	c3                   	ret    

00103caa <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103caa:	55                   	push   %ebp
  103cab:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103cad:	8b 45 08             	mov    0x8(%ebp),%eax
  103cb0:	8b 00                	mov    (%eax),%eax
  103cb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  103cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  103cb8:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103cba:	8b 45 08             	mov    0x8(%ebp),%eax
  103cbd:	8b 00                	mov    (%eax),%eax
}
  103cbf:	5d                   	pop    %ebp
  103cc0:	c3                   	ret    

00103cc1 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103cc1:	55                   	push   %ebp
  103cc2:	89 e5                	mov    %esp,%ebp
  103cc4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103cc7:	9c                   	pushf  
  103cc8:	58                   	pop    %eax
  103cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103ccf:	25 00 02 00 00       	and    $0x200,%eax
  103cd4:	85 c0                	test   %eax,%eax
  103cd6:	74 0c                	je     103ce4 <__intr_save+0x23>
        intr_disable();
  103cd8:	e8 b8 d9 ff ff       	call   101695 <intr_disable>
        return 1;
  103cdd:	b8 01 00 00 00       	mov    $0x1,%eax
  103ce2:	eb 05                	jmp    103ce9 <__intr_save+0x28>
    }
    return 0;
  103ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103ce9:	c9                   	leave  
  103cea:	c3                   	ret    

00103ceb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103ceb:	55                   	push   %ebp
  103cec:	89 e5                	mov    %esp,%ebp
  103cee:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103cf1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103cf5:	74 05                	je     103cfc <__intr_restore+0x11>
        intr_enable();
  103cf7:	e8 93 d9 ff ff       	call   10168f <intr_enable>
    }
}
  103cfc:	c9                   	leave  
  103cfd:	c3                   	ret    

00103cfe <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103cfe:	55                   	push   %ebp
  103cff:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103d01:	8b 45 08             	mov    0x8(%ebp),%eax
  103d04:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103d07:	b8 23 00 00 00       	mov    $0x23,%eax
  103d0c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103d0e:	b8 23 00 00 00       	mov    $0x23,%eax
  103d13:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103d15:	b8 10 00 00 00       	mov    $0x10,%eax
  103d1a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103d1c:	b8 10 00 00 00       	mov    $0x10,%eax
  103d21:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103d23:	b8 10 00 00 00       	mov    $0x10,%eax
  103d28:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103d2a:	ea 31 3d 10 00 08 00 	ljmp   $0x8,$0x103d31
}
  103d31:	5d                   	pop    %ebp
  103d32:	c3                   	ret    

00103d33 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103d33:	55                   	push   %ebp
  103d34:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103d36:	8b 45 08             	mov    0x8(%ebp),%eax
  103d39:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103d3e:	5d                   	pop    %ebp
  103d3f:	c3                   	ret    

00103d40 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103d40:	55                   	push   %ebp
  103d41:	89 e5                	mov    %esp,%ebp
  103d43:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103d46:	b8 00 70 11 00       	mov    $0x117000,%eax
  103d4b:	89 04 24             	mov    %eax,(%esp)
  103d4e:	e8 e0 ff ff ff       	call   103d33 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103d53:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103d5a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103d5c:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103d63:	68 00 
  103d65:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103d6a:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103d70:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103d75:	c1 e8 10             	shr    $0x10,%eax
  103d78:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103d7d:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103d84:	83 e0 f0             	and    $0xfffffff0,%eax
  103d87:	83 c8 09             	or     $0x9,%eax
  103d8a:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d8f:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103d96:	83 e0 ef             	and    $0xffffffef,%eax
  103d99:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103d9e:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103da5:	83 e0 9f             	and    $0xffffff9f,%eax
  103da8:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103dad:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103db4:	83 c8 80             	or     $0xffffff80,%eax
  103db7:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103dbc:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103dc3:	83 e0 f0             	and    $0xfffffff0,%eax
  103dc6:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103dcb:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103dd2:	83 e0 ef             	and    $0xffffffef,%eax
  103dd5:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103dda:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103de1:	83 e0 df             	and    $0xffffffdf,%eax
  103de4:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103de9:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103df0:	83 c8 40             	or     $0x40,%eax
  103df3:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103df8:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103dff:	83 e0 7f             	and    $0x7f,%eax
  103e02:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103e07:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103e0c:	c1 e8 18             	shr    $0x18,%eax
  103e0f:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103e14:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103e1b:	e8 de fe ff ff       	call   103cfe <lgdt>
  103e20:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103e26:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103e2a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103e2d:	c9                   	leave  
  103e2e:	c3                   	ret    

00103e2f <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103e2f:	55                   	push   %ebp
  103e30:	89 e5                	mov    %esp,%ebp
  103e32:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103e35:	c7 05 bc 89 11 00 a8 	movl   $0x106ba8,0x1189bc
  103e3c:	6b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103e3f:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103e44:	8b 00                	mov    (%eax),%eax
  103e46:	89 44 24 04          	mov    %eax,0x4(%esp)
  103e4a:	c7 04 24 44 6c 10 00 	movl   $0x106c44,(%esp)
  103e51:	e8 e6 c4 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103e56:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103e5b:	8b 40 04             	mov    0x4(%eax),%eax
  103e5e:	ff d0                	call   *%eax
}
  103e60:	c9                   	leave  
  103e61:	c3                   	ret    

00103e62 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103e62:	55                   	push   %ebp
  103e63:	89 e5                	mov    %esp,%ebp
  103e65:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103e68:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103e6d:	8b 40 08             	mov    0x8(%eax),%eax
  103e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  103e73:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e77:	8b 55 08             	mov    0x8(%ebp),%edx
  103e7a:	89 14 24             	mov    %edx,(%esp)
  103e7d:	ff d0                	call   *%eax
}
  103e7f:	c9                   	leave  
  103e80:	c3                   	ret    

00103e81 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103e81:	55                   	push   %ebp
  103e82:	89 e5                	mov    %esp,%ebp
  103e84:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103e87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103e8e:	e8 2e fe ff ff       	call   103cc1 <__intr_save>
  103e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103e96:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  103e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  103ea1:	89 14 24             	mov    %edx,(%esp)
  103ea4:	ff d0                	call   *%eax
  103ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103eac:	89 04 24             	mov    %eax,(%esp)
  103eaf:	e8 37 fe ff ff       	call   103ceb <__intr_restore>
    return page;
  103eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103eb7:	c9                   	leave  
  103eb8:	c3                   	ret    

00103eb9 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103eb9:	55                   	push   %ebp
  103eba:	89 e5                	mov    %esp,%ebp
  103ebc:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103ebf:	e8 fd fd ff ff       	call   103cc1 <__intr_save>
  103ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103ec7:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103ecc:	8b 40 10             	mov    0x10(%eax),%eax
  103ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ed2:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  103ed9:	89 14 24             	mov    %edx,(%esp)
  103edc:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ee1:	89 04 24             	mov    %eax,(%esp)
  103ee4:	e8 02 fe ff ff       	call   103ceb <__intr_restore>
}
  103ee9:	c9                   	leave  
  103eea:	c3                   	ret    

00103eeb <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103eeb:	55                   	push   %ebp
  103eec:	89 e5                	mov    %esp,%ebp
  103eee:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103ef1:	e8 cb fd ff ff       	call   103cc1 <__intr_save>
  103ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103ef9:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103efe:	8b 40 14             	mov    0x14(%eax),%eax
  103f01:	ff d0                	call   *%eax
  103f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f09:	89 04 24             	mov    %eax,(%esp)
  103f0c:	e8 da fd ff ff       	call   103ceb <__intr_restore>
    return ret;
  103f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103f14:	c9                   	leave  
  103f15:	c3                   	ret    

00103f16 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103f16:	55                   	push   %ebp
  103f17:	89 e5                	mov    %esp,%ebp
  103f19:	57                   	push   %edi
  103f1a:	56                   	push   %esi
  103f1b:	53                   	push   %ebx
  103f1c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103f22:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103f29:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103f30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103f37:	c7 04 24 5b 6c 10 00 	movl   $0x106c5b,(%esp)
  103f3e:	e8 f9 c3 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103f43:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f4a:	e9 15 01 00 00       	jmp    104064 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103f4f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f52:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f55:	89 d0                	mov    %edx,%eax
  103f57:	c1 e0 02             	shl    $0x2,%eax
  103f5a:	01 d0                	add    %edx,%eax
  103f5c:	c1 e0 02             	shl    $0x2,%eax
  103f5f:	01 c8                	add    %ecx,%eax
  103f61:	8b 50 08             	mov    0x8(%eax),%edx
  103f64:	8b 40 04             	mov    0x4(%eax),%eax
  103f67:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103f6a:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103f6d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f70:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f73:	89 d0                	mov    %edx,%eax
  103f75:	c1 e0 02             	shl    $0x2,%eax
  103f78:	01 d0                	add    %edx,%eax
  103f7a:	c1 e0 02             	shl    $0x2,%eax
  103f7d:	01 c8                	add    %ecx,%eax
  103f7f:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f82:	8b 58 10             	mov    0x10(%eax),%ebx
  103f85:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103f88:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103f8b:	01 c8                	add    %ecx,%eax
  103f8d:	11 da                	adc    %ebx,%edx
  103f8f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103f92:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103f95:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f98:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f9b:	89 d0                	mov    %edx,%eax
  103f9d:	c1 e0 02             	shl    $0x2,%eax
  103fa0:	01 d0                	add    %edx,%eax
  103fa2:	c1 e0 02             	shl    $0x2,%eax
  103fa5:	01 c8                	add    %ecx,%eax
  103fa7:	83 c0 14             	add    $0x14,%eax
  103faa:	8b 00                	mov    (%eax),%eax
  103fac:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103fb2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103fb5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103fb8:	83 c0 ff             	add    $0xffffffff,%eax
  103fbb:	83 d2 ff             	adc    $0xffffffff,%edx
  103fbe:	89 c6                	mov    %eax,%esi
  103fc0:	89 d7                	mov    %edx,%edi
  103fc2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fc8:	89 d0                	mov    %edx,%eax
  103fca:	c1 e0 02             	shl    $0x2,%eax
  103fcd:	01 d0                	add    %edx,%eax
  103fcf:	c1 e0 02             	shl    $0x2,%eax
  103fd2:	01 c8                	add    %ecx,%eax
  103fd4:	8b 48 0c             	mov    0xc(%eax),%ecx
  103fd7:	8b 58 10             	mov    0x10(%eax),%ebx
  103fda:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103fe0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103fe4:	89 74 24 14          	mov    %esi,0x14(%esp)
  103fe8:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103fec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103fef:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103ff2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ff6:	89 54 24 10          	mov    %edx,0x10(%esp)
  103ffa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103ffe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104002:	c7 04 24 68 6c 10 00 	movl   $0x106c68,(%esp)
  104009:	e8 2e c3 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  10400e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104011:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104014:	89 d0                	mov    %edx,%eax
  104016:	c1 e0 02             	shl    $0x2,%eax
  104019:	01 d0                	add    %edx,%eax
  10401b:	c1 e0 02             	shl    $0x2,%eax
  10401e:	01 c8                	add    %ecx,%eax
  104020:	83 c0 14             	add    $0x14,%eax
  104023:	8b 00                	mov    (%eax),%eax
  104025:	83 f8 01             	cmp    $0x1,%eax
  104028:	75 36                	jne    104060 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  10402a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10402d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104030:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  104033:	77 2b                	ja     104060 <page_init+0x14a>
  104035:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  104038:	72 05                	jb     10403f <page_init+0x129>
  10403a:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  10403d:	73 21                	jae    104060 <page_init+0x14a>
  10403f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  104043:	77 1b                	ja     104060 <page_init+0x14a>
  104045:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  104049:	72 09                	jb     104054 <page_init+0x13e>
  10404b:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  104052:	77 0c                	ja     104060 <page_init+0x14a>
                maxpa = end;
  104054:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104057:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10405a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10405d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104060:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104064:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104067:	8b 00                	mov    (%eax),%eax
  104069:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10406c:	0f 8f dd fe ff ff    	jg     103f4f <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104072:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104076:	72 1d                	jb     104095 <page_init+0x17f>
  104078:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10407c:	77 09                	ja     104087 <page_init+0x171>
  10407e:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  104085:	76 0e                	jbe    104095 <page_init+0x17f>
        maxpa = KMEMSIZE;
  104087:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10408e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104095:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104098:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10409b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10409f:	c1 ea 0c             	shr    $0xc,%edx
  1040a2:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1040a7:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  1040ae:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  1040b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1040b6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1040b9:	01 d0                	add    %edx,%eax
  1040bb:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1040be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1040c1:	ba 00 00 00 00       	mov    $0x0,%edx
  1040c6:	f7 75 ac             	divl   -0x54(%ebp)
  1040c9:	89 d0                	mov    %edx,%eax
  1040cb:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1040ce:	29 c2                	sub    %eax,%edx
  1040d0:	89 d0                	mov    %edx,%eax
  1040d2:	a3 c4 89 11 00       	mov    %eax,0x1189c4

    for (i = 0; i < npage; i ++) {
  1040d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1040de:	eb 2f                	jmp    10410f <page_init+0x1f9>
        SetPageReserved(pages + i);
  1040e0:	8b 0d c4 89 11 00    	mov    0x1189c4,%ecx
  1040e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040e9:	89 d0                	mov    %edx,%eax
  1040eb:	c1 e0 02             	shl    $0x2,%eax
  1040ee:	01 d0                	add    %edx,%eax
  1040f0:	c1 e0 02             	shl    $0x2,%eax
  1040f3:	01 c8                	add    %ecx,%eax
  1040f5:	83 c0 04             	add    $0x4,%eax
  1040f8:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  1040ff:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104102:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104105:	8b 55 90             	mov    -0x70(%ebp),%edx
  104108:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  10410b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10410f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104112:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104117:	39 c2                	cmp    %eax,%edx
  104119:	72 c5                	jb     1040e0 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10411b:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  104121:	89 d0                	mov    %edx,%eax
  104123:	c1 e0 02             	shl    $0x2,%eax
  104126:	01 d0                	add    %edx,%eax
  104128:	c1 e0 02             	shl    $0x2,%eax
  10412b:	89 c2                	mov    %eax,%edx
  10412d:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  104132:	01 d0                	add    %edx,%eax
  104134:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104137:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  10413e:	77 23                	ja     104163 <page_init+0x24d>
  104140:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104143:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104147:	c7 44 24 08 98 6c 10 	movl   $0x106c98,0x8(%esp)
  10414e:	00 
  10414f:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104156:	00 
  104157:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  10415e:	e8 4f cb ff ff       	call   100cb2 <__panic>
  104163:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104166:	05 00 00 00 40       	add    $0x40000000,%eax
  10416b:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10416e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104175:	e9 74 01 00 00       	jmp    1042ee <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10417a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10417d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104180:	89 d0                	mov    %edx,%eax
  104182:	c1 e0 02             	shl    $0x2,%eax
  104185:	01 d0                	add    %edx,%eax
  104187:	c1 e0 02             	shl    $0x2,%eax
  10418a:	01 c8                	add    %ecx,%eax
  10418c:	8b 50 08             	mov    0x8(%eax),%edx
  10418f:	8b 40 04             	mov    0x4(%eax),%eax
  104192:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104195:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104198:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10419b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10419e:	89 d0                	mov    %edx,%eax
  1041a0:	c1 e0 02             	shl    $0x2,%eax
  1041a3:	01 d0                	add    %edx,%eax
  1041a5:	c1 e0 02             	shl    $0x2,%eax
  1041a8:	01 c8                	add    %ecx,%eax
  1041aa:	8b 48 0c             	mov    0xc(%eax),%ecx
  1041ad:	8b 58 10             	mov    0x10(%eax),%ebx
  1041b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041b6:	01 c8                	add    %ecx,%eax
  1041b8:	11 da                	adc    %ebx,%edx
  1041ba:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1041bd:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1041c0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1041c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041c6:	89 d0                	mov    %edx,%eax
  1041c8:	c1 e0 02             	shl    $0x2,%eax
  1041cb:	01 d0                	add    %edx,%eax
  1041cd:	c1 e0 02             	shl    $0x2,%eax
  1041d0:	01 c8                	add    %ecx,%eax
  1041d2:	83 c0 14             	add    $0x14,%eax
  1041d5:	8b 00                	mov    (%eax),%eax
  1041d7:	83 f8 01             	cmp    $0x1,%eax
  1041da:	0f 85 0a 01 00 00    	jne    1042ea <page_init+0x3d4>
            if (begin < freemem) {
  1041e0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1041e3:	ba 00 00 00 00       	mov    $0x0,%edx
  1041e8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1041eb:	72 17                	jb     104204 <page_init+0x2ee>
  1041ed:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1041f0:	77 05                	ja     1041f7 <page_init+0x2e1>
  1041f2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1041f5:	76 0d                	jbe    104204 <page_init+0x2ee>
                begin = freemem;
  1041f7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1041fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1041fd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104204:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104208:	72 1d                	jb     104227 <page_init+0x311>
  10420a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10420e:	77 09                	ja     104219 <page_init+0x303>
  104210:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104217:	76 0e                	jbe    104227 <page_init+0x311>
                end = KMEMSIZE;
  104219:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104220:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104227:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10422a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10422d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104230:	0f 87 b4 00 00 00    	ja     1042ea <page_init+0x3d4>
  104236:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104239:	72 09                	jb     104244 <page_init+0x32e>
  10423b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10423e:	0f 83 a6 00 00 00    	jae    1042ea <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104244:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  10424b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10424e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104251:	01 d0                	add    %edx,%eax
  104253:	83 e8 01             	sub    $0x1,%eax
  104256:	89 45 98             	mov    %eax,-0x68(%ebp)
  104259:	8b 45 98             	mov    -0x68(%ebp),%eax
  10425c:	ba 00 00 00 00       	mov    $0x0,%edx
  104261:	f7 75 9c             	divl   -0x64(%ebp)
  104264:	89 d0                	mov    %edx,%eax
  104266:	8b 55 98             	mov    -0x68(%ebp),%edx
  104269:	29 c2                	sub    %eax,%edx
  10426b:	89 d0                	mov    %edx,%eax
  10426d:	ba 00 00 00 00       	mov    $0x0,%edx
  104272:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104275:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104278:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10427b:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10427e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104281:	ba 00 00 00 00       	mov    $0x0,%edx
  104286:	89 c7                	mov    %eax,%edi
  104288:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10428e:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104291:	89 d0                	mov    %edx,%eax
  104293:	83 e0 00             	and    $0x0,%eax
  104296:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104299:	8b 45 80             	mov    -0x80(%ebp),%eax
  10429c:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10429f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1042a2:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1042a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042ab:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1042ae:	77 3a                	ja     1042ea <page_init+0x3d4>
  1042b0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1042b3:	72 05                	jb     1042ba <page_init+0x3a4>
  1042b5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1042b8:	73 30                	jae    1042ea <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1042ba:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1042bd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1042c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1042c3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1042c6:	29 c8                	sub    %ecx,%eax
  1042c8:	19 da                	sbb    %ebx,%edx
  1042ca:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1042ce:	c1 ea 0c             	shr    $0xc,%edx
  1042d1:	89 c3                	mov    %eax,%ebx
  1042d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042d6:	89 04 24             	mov    %eax,(%esp)
  1042d9:	e8 bd f8 ff ff       	call   103b9b <pa2page>
  1042de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1042e2:	89 04 24             	mov    %eax,(%esp)
  1042e5:	e8 78 fb ff ff       	call   103e62 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1042ea:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1042ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1042f1:	8b 00                	mov    (%eax),%eax
  1042f3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1042f6:	0f 8f 7e fe ff ff    	jg     10417a <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1042fc:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104302:	5b                   	pop    %ebx
  104303:	5e                   	pop    %esi
  104304:	5f                   	pop    %edi
  104305:	5d                   	pop    %ebp
  104306:	c3                   	ret    

00104307 <enable_paging>:

static void
enable_paging(void) {
  104307:	55                   	push   %ebp
  104308:	89 e5                	mov    %esp,%ebp
  10430a:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10430d:	a1 c0 89 11 00       	mov    0x1189c0,%eax
  104312:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104315:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104318:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10431b:	0f 20 c0             	mov    %cr0,%eax
  10431e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104321:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104324:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  104327:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10432e:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104332:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104335:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10433b:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10433e:	c9                   	leave  
  10433f:	c3                   	ret    

00104340 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104340:	55                   	push   %ebp
  104341:	89 e5                	mov    %esp,%ebp
  104343:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104346:	8b 45 14             	mov    0x14(%ebp),%eax
  104349:	8b 55 0c             	mov    0xc(%ebp),%edx
  10434c:	31 d0                	xor    %edx,%eax
  10434e:	25 ff 0f 00 00       	and    $0xfff,%eax
  104353:	85 c0                	test   %eax,%eax
  104355:	74 24                	je     10437b <boot_map_segment+0x3b>
  104357:	c7 44 24 0c ca 6c 10 	movl   $0x106cca,0xc(%esp)
  10435e:	00 
  10435f:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104366:	00 
  104367:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10436e:	00 
  10436f:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104376:	e8 37 c9 ff ff       	call   100cb2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10437b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104382:	8b 45 0c             	mov    0xc(%ebp),%eax
  104385:	25 ff 0f 00 00       	and    $0xfff,%eax
  10438a:	89 c2                	mov    %eax,%edx
  10438c:	8b 45 10             	mov    0x10(%ebp),%eax
  10438f:	01 c2                	add    %eax,%edx
  104391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104394:	01 d0                	add    %edx,%eax
  104396:	83 e8 01             	sub    $0x1,%eax
  104399:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10439c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10439f:	ba 00 00 00 00       	mov    $0x0,%edx
  1043a4:	f7 75 f0             	divl   -0x10(%ebp)
  1043a7:	89 d0                	mov    %edx,%eax
  1043a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1043ac:	29 c2                	sub    %eax,%edx
  1043ae:	89 d0                	mov    %edx,%eax
  1043b0:	c1 e8 0c             	shr    $0xc,%eax
  1043b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1043b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1043bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1043c4:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1043c7:	8b 45 14             	mov    0x14(%ebp),%eax
  1043ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1043d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1043d5:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1043d8:	eb 6b                	jmp    104445 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1043da:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1043e1:	00 
  1043e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1043ec:	89 04 24             	mov    %eax,(%esp)
  1043ef:	e8 cc 01 00 00       	call   1045c0 <get_pte>
  1043f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1043f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1043fb:	75 24                	jne    104421 <boot_map_segment+0xe1>
  1043fd:	c7 44 24 0c f6 6c 10 	movl   $0x106cf6,0xc(%esp)
  104404:	00 
  104405:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  10440c:	00 
  10440d:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104414:	00 
  104415:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  10441c:	e8 91 c8 ff ff       	call   100cb2 <__panic>
        *ptep = pa | PTE_P | perm;
  104421:	8b 45 18             	mov    0x18(%ebp),%eax
  104424:	8b 55 14             	mov    0x14(%ebp),%edx
  104427:	09 d0                	or     %edx,%eax
  104429:	83 c8 01             	or     $0x1,%eax
  10442c:	89 c2                	mov    %eax,%edx
  10442e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104431:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104433:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104437:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10443e:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104445:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104449:	75 8f                	jne    1043da <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10444b:	c9                   	leave  
  10444c:	c3                   	ret    

0010444d <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10444d:	55                   	push   %ebp
  10444e:	89 e5                	mov    %esp,%ebp
  104450:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104453:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10445a:	e8 22 fa ff ff       	call   103e81 <alloc_pages>
  10445f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104466:	75 1c                	jne    104484 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104468:	c7 44 24 08 03 6d 10 	movl   $0x106d03,0x8(%esp)
  10446f:	00 
  104470:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104477:	00 
  104478:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  10447f:	e8 2e c8 ff ff       	call   100cb2 <__panic>
    }
    return page2kva(p);
  104484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104487:	89 04 24             	mov    %eax,(%esp)
  10448a:	e8 5b f7 ff ff       	call   103bea <page2kva>
}
  10448f:	c9                   	leave  
  104490:	c3                   	ret    

00104491 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104491:	55                   	push   %ebp
  104492:	89 e5                	mov    %esp,%ebp
  104494:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104497:	e8 93 f9 ff ff       	call   103e2f <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10449c:	e8 75 fa ff ff       	call   103f16 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1044a1:	e8 66 04 00 00       	call   10490c <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1044a6:	e8 a2 ff ff ff       	call   10444d <boot_alloc_page>
  1044ab:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1044b0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1044b5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1044bc:	00 
  1044bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044c4:	00 
  1044c5:	89 04 24             	mov    %eax,(%esp)
  1044c8:	e8 a8 1a 00 00       	call   105f75 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  1044cd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1044d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1044d5:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1044dc:	77 23                	ja     104501 <pmm_init+0x70>
  1044de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044e5:	c7 44 24 08 98 6c 10 	movl   $0x106c98,0x8(%esp)
  1044ec:	00 
  1044ed:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1044f4:	00 
  1044f5:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1044fc:	e8 b1 c7 ff ff       	call   100cb2 <__panic>
  104501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104504:	05 00 00 00 40       	add    $0x40000000,%eax
  104509:	a3 c0 89 11 00       	mov    %eax,0x1189c0

    check_pgdir();
  10450e:	e8 17 04 00 00       	call   10492a <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104513:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104518:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10451e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104523:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104526:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10452d:	77 23                	ja     104552 <pmm_init+0xc1>
  10452f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104532:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104536:	c7 44 24 08 98 6c 10 	movl   $0x106c98,0x8(%esp)
  10453d:	00 
  10453e:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104545:	00 
  104546:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  10454d:	e8 60 c7 ff ff       	call   100cb2 <__panic>
  104552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104555:	05 00 00 00 40       	add    $0x40000000,%eax
  10455a:	83 c8 03             	or     $0x3,%eax
  10455d:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10455f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104564:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10456b:	00 
  10456c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104573:	00 
  104574:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10457b:	38 
  10457c:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104583:	c0 
  104584:	89 04 24             	mov    %eax,(%esp)
  104587:	e8 b4 fd ff ff       	call   104340 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10458c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104591:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104597:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10459d:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10459f:	e8 63 fd ff ff       	call   104307 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1045a4:	e8 97 f7 ff ff       	call   103d40 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1045a9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1045ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1045b4:	e8 0c 0a 00 00       	call   104fc5 <check_boot_pgdir>

    print_pgdir();
  1045b9:	e8 99 0e 00 00       	call   105457 <print_pgdir>

}
  1045be:	c9                   	leave  
  1045bf:	c3                   	ret    

001045c0 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1045c0:	55                   	push   %ebp
  1045c1:	89 e5                	mov    %esp,%ebp
  1045c3:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
	pde_t *pdep = &pgdir[PDX(la)];
  1045c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045c9:	c1 e8 16             	shr    $0x16,%eax
  1045cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1045d6:	01 d0                	add    %edx,%eax
  1045d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //使用PDX，获取一级页表的位置，如果成功，直接返回
    if (!(*pdep & PTE_P)) {//如果失败
  1045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045de:	8b 00                	mov    (%eax),%eax
  1045e0:	83 e0 01             	and    $0x1,%eax
  1045e3:	85 c0                	test   %eax,%eax
  1045e5:	0f 85 af 00 00 00    	jne    10469a <get_pte+0xda>
        struct Page *page;
        //根据create位判断是否创建这个二级页表
        //如果为0，不创建，不为0则创建
        if (!create || (page = alloc_page()) == NULL) {
  1045eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1045ef:	74 15                	je     104606 <get_pte+0x46>
  1045f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1045f8:	e8 84 f8 ff ff       	call   103e81 <alloc_pages>
  1045fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104600:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104604:	75 0a                	jne    104610 <get_pte+0x50>
            return NULL;
  104606:	b8 00 00 00 00       	mov    $0x0,%eax
  10460b:	e9 e6 00 00 00       	jmp    1046f6 <get_pte+0x136>
        }
        set_page_ref(page, 1);//要查找该页表，则引用次数+1
  104610:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104617:	00 
  104618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10461b:	89 04 24             	mov    %eax,(%esp)
  10461e:	e8 63 f6 ff ff       	call   103c86 <set_page_ref>
        uintptr_t pa = page2pa(page);//得到该页的物理地址
  104623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104626:	89 04 24             	mov    %eax,(%esp)
  104629:	e8 57 f5 ff ff       	call   103b85 <page2pa>
  10462e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);//转成虚拟地址并初始化
  104631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104634:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104637:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10463a:	c1 e8 0c             	shr    $0xc,%eax
  10463d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104640:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104645:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104648:	72 23                	jb     10466d <get_pte+0xad>
  10464a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10464d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104651:	c7 44 24 08 f4 6b 10 	movl   $0x106bf4,0x8(%esp)
  104658:	00 
  104659:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
  104660:	00 
  104661:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104668:	e8 45 c6 ff ff       	call   100cb2 <__panic>
  10466d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104670:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104675:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10467c:	00 
  10467d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104684:	00 
  104685:	89 04 24             	mov    %eax,(%esp)
  104688:	e8 e8 18 00 00       	call   105f75 <memset>
        //因为这个页所代表的虚拟地址都没有被映射
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  10468d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104690:	83 c8 07             	or     $0x7,%eax
  104693:	89 c2                	mov    %eax,%edx
  104695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104698:	89 10                	mov    %edx,(%eax)
        //设置控制位，同时设置PTE_U,PTE_W和PTE_P
    }
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  10469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10469d:	8b 00                	mov    (%eax),%eax
  10469f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1046a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1046a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046aa:	c1 e8 0c             	shr    $0xc,%eax
  1046ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1046b0:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1046b5:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1046b8:	72 23                	jb     1046dd <get_pte+0x11d>
  1046ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046c1:	c7 44 24 08 f4 6b 10 	movl   $0x106bf4,0x8(%esp)
  1046c8:	00 
  1046c9:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
  1046d0:	00 
  1046d1:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1046d8:	e8 d5 c5 ff ff       	call   100cb2 <__panic>
  1046dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046e0:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1046e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046e8:	c1 ea 0c             	shr    $0xc,%edx
  1046eb:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  1046f1:	c1 e2 02             	shl    $0x2,%edx
  1046f4:	01 d0                	add    %edx,%eax
	//用KADDR返回二级页表所对应的线性地址
	//这里不是要求物理地址，而是需要找对应的二级页表项，在查询完二级页表之前，都还是在虚拟地址的范围。
}
  1046f6:	c9                   	leave  
  1046f7:	c3                   	ret    

001046f8 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1046f8:	55                   	push   %ebp
  1046f9:	89 e5                	mov    %esp,%ebp
  1046fb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1046fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104705:	00 
  104706:	8b 45 0c             	mov    0xc(%ebp),%eax
  104709:	89 44 24 04          	mov    %eax,0x4(%esp)
  10470d:	8b 45 08             	mov    0x8(%ebp),%eax
  104710:	89 04 24             	mov    %eax,(%esp)
  104713:	e8 a8 fe ff ff       	call   1045c0 <get_pte>
  104718:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10471b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10471f:	74 08                	je     104729 <get_page+0x31>
        *ptep_store = ptep;
  104721:	8b 45 10             	mov    0x10(%ebp),%eax
  104724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104727:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10472d:	74 1b                	je     10474a <get_page+0x52>
  10472f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104732:	8b 00                	mov    (%eax),%eax
  104734:	83 e0 01             	and    $0x1,%eax
  104737:	85 c0                	test   %eax,%eax
  104739:	74 0f                	je     10474a <get_page+0x52>
        return pa2page(*ptep);
  10473b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10473e:	8b 00                	mov    (%eax),%eax
  104740:	89 04 24             	mov    %eax,(%esp)
  104743:	e8 53 f4 ff ff       	call   103b9b <pa2page>
  104748:	eb 05                	jmp    10474f <get_page+0x57>
    }
    return NULL;
  10474a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10474f:	c9                   	leave  
  104750:	c3                   	ret    

00104751 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104751:	55                   	push   %ebp
  104752:	89 e5                	mov    %esp,%ebp
  104754:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
	if (*ptep & PTE_P) {  //PTE_P代表页存在
  104757:	8b 45 10             	mov    0x10(%ebp),%eax
  10475a:	8b 00                	mov    (%eax),%eax
  10475c:	83 e0 01             	and    $0x1,%eax
  10475f:	85 c0                	test   %eax,%eax
  104761:	74 4d                	je     1047b0 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep); //从ptep值中获取相应的页面
  104763:	8b 45 10             	mov    0x10(%ebp),%eax
  104766:	8b 00                	mov    (%eax),%eax
  104768:	89 04 24             	mov    %eax,(%esp)
  10476b:	e8 ce f4 ff ff       	call   103c3e <pte2page>
  104770:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
  104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104776:	89 04 24             	mov    %eax,(%esp)
  104779:	e8 2c f5 ff ff       	call   103caa <page_ref_dec>
  10477e:	85 c0                	test   %eax,%eax
  104780:	75 13                	jne    104795 <page_remove_pte+0x44>
          //如果只被上一级页表引用一次，那么-1后就是0，页和对应的二级页表都能被直接释放
            free_page(page); //释放页
  104782:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104789:	00 
  10478a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10478d:	89 04 24             	mov    %eax,(%esp)
  104790:	e8 24 f7 ff ff       	call   103eb9 <free_pages>
        }
    		//但如果有更多的页表引用了它，则不能释放这个页，但可以取消对应二级页表的映射。
    		//即把传入的二级页表置为0
        *ptep = 0;
  104795:	8b 45 10             	mov    0x10(%ebp),%eax
  104798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la); //当修改的页表目前正在被进程使用时，使之无效
  10479e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1047a8:	89 04 24             	mov    %eax,(%esp)
  1047ab:	e8 ff 00 00 00       	call   1048af <tlb_invalidate>
    }
}
  1047b0:	c9                   	leave  
  1047b1:	c3                   	ret    

001047b2 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1047b2:	55                   	push   %ebp
  1047b3:	89 e5                	mov    %esp,%ebp
  1047b5:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1047b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047bf:	00 
  1047c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1047ca:	89 04 24             	mov    %eax,(%esp)
  1047cd:	e8 ee fd ff ff       	call   1045c0 <get_pte>
  1047d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1047d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1047d9:	74 19                	je     1047f4 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1047db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1047ec:	89 04 24             	mov    %eax,(%esp)
  1047ef:	e8 5d ff ff ff       	call   104751 <page_remove_pte>
    }
}
  1047f4:	c9                   	leave  
  1047f5:	c3                   	ret    

001047f6 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1047f6:	55                   	push   %ebp
  1047f7:	89 e5                	mov    %esp,%ebp
  1047f9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1047fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104803:	00 
  104804:	8b 45 10             	mov    0x10(%ebp),%eax
  104807:	89 44 24 04          	mov    %eax,0x4(%esp)
  10480b:	8b 45 08             	mov    0x8(%ebp),%eax
  10480e:	89 04 24             	mov    %eax,(%esp)
  104811:	e8 aa fd ff ff       	call   1045c0 <get_pte>
  104816:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10481d:	75 0a                	jne    104829 <page_insert+0x33>
        return -E_NO_MEM;
  10481f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104824:	e9 84 00 00 00       	jmp    1048ad <page_insert+0xb7>
    }
    page_ref_inc(page);
  104829:	8b 45 0c             	mov    0xc(%ebp),%eax
  10482c:	89 04 24             	mov    %eax,(%esp)
  10482f:	e8 5f f4 ff ff       	call   103c93 <page_ref_inc>
    if (*ptep & PTE_P) {
  104834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104837:	8b 00                	mov    (%eax),%eax
  104839:	83 e0 01             	and    $0x1,%eax
  10483c:	85 c0                	test   %eax,%eax
  10483e:	74 3e                	je     10487e <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104843:	8b 00                	mov    (%eax),%eax
  104845:	89 04 24             	mov    %eax,(%esp)
  104848:	e8 f1 f3 ff ff       	call   103c3e <pte2page>
  10484d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104853:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104856:	75 0d                	jne    104865 <page_insert+0x6f>
            page_ref_dec(page);
  104858:	8b 45 0c             	mov    0xc(%ebp),%eax
  10485b:	89 04 24             	mov    %eax,(%esp)
  10485e:	e8 47 f4 ff ff       	call   103caa <page_ref_dec>
  104863:	eb 19                	jmp    10487e <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104868:	89 44 24 08          	mov    %eax,0x8(%esp)
  10486c:	8b 45 10             	mov    0x10(%ebp),%eax
  10486f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104873:	8b 45 08             	mov    0x8(%ebp),%eax
  104876:	89 04 24             	mov    %eax,(%esp)
  104879:	e8 d3 fe ff ff       	call   104751 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10487e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104881:	89 04 24             	mov    %eax,(%esp)
  104884:	e8 fc f2 ff ff       	call   103b85 <page2pa>
  104889:	0b 45 14             	or     0x14(%ebp),%eax
  10488c:	83 c8 01             	or     $0x1,%eax
  10488f:	89 c2                	mov    %eax,%edx
  104891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104894:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104896:	8b 45 10             	mov    0x10(%ebp),%eax
  104899:	89 44 24 04          	mov    %eax,0x4(%esp)
  10489d:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a0:	89 04 24             	mov    %eax,(%esp)
  1048a3:	e8 07 00 00 00       	call   1048af <tlb_invalidate>
    return 0;
  1048a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1048ad:	c9                   	leave  
  1048ae:	c3                   	ret    

001048af <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1048af:	55                   	push   %ebp
  1048b0:	89 e5                	mov    %esp,%ebp
  1048b2:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1048b5:	0f 20 d8             	mov    %cr3,%eax
  1048b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1048bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1048be:	89 c2                	mov    %eax,%edx
  1048c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1048c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048c6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1048cd:	77 23                	ja     1048f2 <tlb_invalidate+0x43>
  1048cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1048d6:	c7 44 24 08 98 6c 10 	movl   $0x106c98,0x8(%esp)
  1048dd:	00 
  1048de:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  1048e5:	00 
  1048e6:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1048ed:	e8 c0 c3 ff ff       	call   100cb2 <__panic>
  1048f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048f5:	05 00 00 00 40       	add    $0x40000000,%eax
  1048fa:	39 c2                	cmp    %eax,%edx
  1048fc:	75 0c                	jne    10490a <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1048fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  104901:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104907:	0f 01 38             	invlpg (%eax)
    }
}
  10490a:	c9                   	leave  
  10490b:	c3                   	ret    

0010490c <check_alloc_page>:

static void
check_alloc_page(void) {
  10490c:	55                   	push   %ebp
  10490d:	89 e5                	mov    %esp,%ebp
  10490f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104912:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  104917:	8b 40 18             	mov    0x18(%eax),%eax
  10491a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10491c:	c7 04 24 1c 6d 10 00 	movl   $0x106d1c,(%esp)
  104923:	e8 14 ba ff ff       	call   10033c <cprintf>
}
  104928:	c9                   	leave  
  104929:	c3                   	ret    

0010492a <check_pgdir>:

static void
check_pgdir(void) {
  10492a:	55                   	push   %ebp
  10492b:	89 e5                	mov    %esp,%ebp
  10492d:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104930:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104935:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10493a:	76 24                	jbe    104960 <check_pgdir+0x36>
  10493c:	c7 44 24 0c 3b 6d 10 	movl   $0x106d3b,0xc(%esp)
  104943:	00 
  104944:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  10494b:	00 
  10494c:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104953:	00 
  104954:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  10495b:	e8 52 c3 ff ff       	call   100cb2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104960:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104965:	85 c0                	test   %eax,%eax
  104967:	74 0e                	je     104977 <check_pgdir+0x4d>
  104969:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10496e:	25 ff 0f 00 00       	and    $0xfff,%eax
  104973:	85 c0                	test   %eax,%eax
  104975:	74 24                	je     10499b <check_pgdir+0x71>
  104977:	c7 44 24 0c 58 6d 10 	movl   $0x106d58,0xc(%esp)
  10497e:	00 
  10497f:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104986:	00 
  104987:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  10498e:	00 
  10498f:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104996:	e8 17 c3 ff ff       	call   100cb2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10499b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049a7:	00 
  1049a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1049af:	00 
  1049b0:	89 04 24             	mov    %eax,(%esp)
  1049b3:	e8 40 fd ff ff       	call   1046f8 <get_page>
  1049b8:	85 c0                	test   %eax,%eax
  1049ba:	74 24                	je     1049e0 <check_pgdir+0xb6>
  1049bc:	c7 44 24 0c 90 6d 10 	movl   $0x106d90,0xc(%esp)
  1049c3:	00 
  1049c4:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  1049cb:	00 
  1049cc:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  1049d3:	00 
  1049d4:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1049db:	e8 d2 c2 ff ff       	call   100cb2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1049e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049e7:	e8 95 f4 ff ff       	call   103e81 <alloc_pages>
  1049ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1049ef:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049f4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1049fb:	00 
  1049fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a03:	00 
  104a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a07:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a0b:	89 04 24             	mov    %eax,(%esp)
  104a0e:	e8 e3 fd ff ff       	call   1047f6 <page_insert>
  104a13:	85 c0                	test   %eax,%eax
  104a15:	74 24                	je     104a3b <check_pgdir+0x111>
  104a17:	c7 44 24 0c b8 6d 10 	movl   $0x106db8,0xc(%esp)
  104a1e:	00 
  104a1f:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104a26:	00 
  104a27:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104a2e:	00 
  104a2f:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104a36:	e8 77 c2 ff ff       	call   100cb2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104a3b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a40:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a47:	00 
  104a48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a4f:	00 
  104a50:	89 04 24             	mov    %eax,(%esp)
  104a53:	e8 68 fb ff ff       	call   1045c0 <get_pte>
  104a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a5f:	75 24                	jne    104a85 <check_pgdir+0x15b>
  104a61:	c7 44 24 0c e4 6d 10 	movl   $0x106de4,0xc(%esp)
  104a68:	00 
  104a69:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104a70:	00 
  104a71:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104a78:	00 
  104a79:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104a80:	e8 2d c2 ff ff       	call   100cb2 <__panic>
    assert(pa2page(*ptep) == p1);
  104a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a88:	8b 00                	mov    (%eax),%eax
  104a8a:	89 04 24             	mov    %eax,(%esp)
  104a8d:	e8 09 f1 ff ff       	call   103b9b <pa2page>
  104a92:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a95:	74 24                	je     104abb <check_pgdir+0x191>
  104a97:	c7 44 24 0c 11 6e 10 	movl   $0x106e11,0xc(%esp)
  104a9e:	00 
  104a9f:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104aa6:	00 
  104aa7:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104aae:	00 
  104aaf:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104ab6:	e8 f7 c1 ff ff       	call   100cb2 <__panic>
    assert(page_ref(p1) == 1);
  104abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104abe:	89 04 24             	mov    %eax,(%esp)
  104ac1:	e8 b6 f1 ff ff       	call   103c7c <page_ref>
  104ac6:	83 f8 01             	cmp    $0x1,%eax
  104ac9:	74 24                	je     104aef <check_pgdir+0x1c5>
  104acb:	c7 44 24 0c 26 6e 10 	movl   $0x106e26,0xc(%esp)
  104ad2:	00 
  104ad3:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104ada:	00 
  104adb:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104ae2:	00 
  104ae3:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104aea:	e8 c3 c1 ff ff       	call   100cb2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104aef:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104af4:	8b 00                	mov    (%eax),%eax
  104af6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104afb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b01:	c1 e8 0c             	shr    $0xc,%eax
  104b04:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104b07:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104b0c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104b0f:	72 23                	jb     104b34 <check_pgdir+0x20a>
  104b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b14:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104b18:	c7 44 24 08 f4 6b 10 	movl   $0x106bf4,0x8(%esp)
  104b1f:	00 
  104b20:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104b27:	00 
  104b28:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104b2f:	e8 7e c1 ff ff       	call   100cb2 <__panic>
  104b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b37:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104b3c:	83 c0 04             	add    $0x4,%eax
  104b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104b42:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b4e:	00 
  104b4f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b56:	00 
  104b57:	89 04 24             	mov    %eax,(%esp)
  104b5a:	e8 61 fa ff ff       	call   1045c0 <get_pte>
  104b5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104b62:	74 24                	je     104b88 <check_pgdir+0x25e>
  104b64:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  104b6b:	00 
  104b6c:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104b73:	00 
  104b74:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104b7b:	00 
  104b7c:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104b83:	e8 2a c1 ff ff       	call   100cb2 <__panic>

    p2 = alloc_page();
  104b88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b8f:	e8 ed f2 ff ff       	call   103e81 <alloc_pages>
  104b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104b97:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b9c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104ba3:	00 
  104ba4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104bab:	00 
  104bac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104baf:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bb3:	89 04 24             	mov    %eax,(%esp)
  104bb6:	e8 3b fc ff ff       	call   1047f6 <page_insert>
  104bbb:	85 c0                	test   %eax,%eax
  104bbd:	74 24                	je     104be3 <check_pgdir+0x2b9>
  104bbf:	c7 44 24 0c 60 6e 10 	movl   $0x106e60,0xc(%esp)
  104bc6:	00 
  104bc7:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104bce:	00 
  104bcf:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104bd6:	00 
  104bd7:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104bde:	e8 cf c0 ff ff       	call   100cb2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104be3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104be8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104bef:	00 
  104bf0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104bf7:	00 
  104bf8:	89 04 24             	mov    %eax,(%esp)
  104bfb:	e8 c0 f9 ff ff       	call   1045c0 <get_pte>
  104c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c07:	75 24                	jne    104c2d <check_pgdir+0x303>
  104c09:	c7 44 24 0c 98 6e 10 	movl   $0x106e98,0xc(%esp)
  104c10:	00 
  104c11:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104c18:	00 
  104c19:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104c20:	00 
  104c21:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104c28:	e8 85 c0 ff ff       	call   100cb2 <__panic>
    assert(*ptep & PTE_U);
  104c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c30:	8b 00                	mov    (%eax),%eax
  104c32:	83 e0 04             	and    $0x4,%eax
  104c35:	85 c0                	test   %eax,%eax
  104c37:	75 24                	jne    104c5d <check_pgdir+0x333>
  104c39:	c7 44 24 0c c8 6e 10 	movl   $0x106ec8,0xc(%esp)
  104c40:	00 
  104c41:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104c48:	00 
  104c49:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104c50:	00 
  104c51:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104c58:	e8 55 c0 ff ff       	call   100cb2 <__panic>
    assert(*ptep & PTE_W);
  104c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c60:	8b 00                	mov    (%eax),%eax
  104c62:	83 e0 02             	and    $0x2,%eax
  104c65:	85 c0                	test   %eax,%eax
  104c67:	75 24                	jne    104c8d <check_pgdir+0x363>
  104c69:	c7 44 24 0c d6 6e 10 	movl   $0x106ed6,0xc(%esp)
  104c70:	00 
  104c71:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104c78:	00 
  104c79:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104c80:	00 
  104c81:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104c88:	e8 25 c0 ff ff       	call   100cb2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104c8d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c92:	8b 00                	mov    (%eax),%eax
  104c94:	83 e0 04             	and    $0x4,%eax
  104c97:	85 c0                	test   %eax,%eax
  104c99:	75 24                	jne    104cbf <check_pgdir+0x395>
  104c9b:	c7 44 24 0c e4 6e 10 	movl   $0x106ee4,0xc(%esp)
  104ca2:	00 
  104ca3:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104caa:	00 
  104cab:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104cb2:	00 
  104cb3:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104cba:	e8 f3 bf ff ff       	call   100cb2 <__panic>
    assert(page_ref(p2) == 1);
  104cbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cc2:	89 04 24             	mov    %eax,(%esp)
  104cc5:	e8 b2 ef ff ff       	call   103c7c <page_ref>
  104cca:	83 f8 01             	cmp    $0x1,%eax
  104ccd:	74 24                	je     104cf3 <check_pgdir+0x3c9>
  104ccf:	c7 44 24 0c fa 6e 10 	movl   $0x106efa,0xc(%esp)
  104cd6:	00 
  104cd7:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104cde:	00 
  104cdf:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104ce6:	00 
  104ce7:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104cee:	e8 bf bf ff ff       	call   100cb2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104cf3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cf8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104cff:	00 
  104d00:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104d07:	00 
  104d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d0b:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d0f:	89 04 24             	mov    %eax,(%esp)
  104d12:	e8 df fa ff ff       	call   1047f6 <page_insert>
  104d17:	85 c0                	test   %eax,%eax
  104d19:	74 24                	je     104d3f <check_pgdir+0x415>
  104d1b:	c7 44 24 0c 0c 6f 10 	movl   $0x106f0c,0xc(%esp)
  104d22:	00 
  104d23:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104d2a:	00 
  104d2b:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104d32:	00 
  104d33:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104d3a:	e8 73 bf ff ff       	call   100cb2 <__panic>
    assert(page_ref(p1) == 2);
  104d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d42:	89 04 24             	mov    %eax,(%esp)
  104d45:	e8 32 ef ff ff       	call   103c7c <page_ref>
  104d4a:	83 f8 02             	cmp    $0x2,%eax
  104d4d:	74 24                	je     104d73 <check_pgdir+0x449>
  104d4f:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  104d56:	00 
  104d57:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104d5e:	00 
  104d5f:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104d66:	00 
  104d67:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104d6e:	e8 3f bf ff ff       	call   100cb2 <__panic>
    assert(page_ref(p2) == 0);
  104d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d76:	89 04 24             	mov    %eax,(%esp)
  104d79:	e8 fe ee ff ff       	call   103c7c <page_ref>
  104d7e:	85 c0                	test   %eax,%eax
  104d80:	74 24                	je     104da6 <check_pgdir+0x47c>
  104d82:	c7 44 24 0c 4a 6f 10 	movl   $0x106f4a,0xc(%esp)
  104d89:	00 
  104d8a:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104d91:	00 
  104d92:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104d99:	00 
  104d9a:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104da1:	e8 0c bf ff ff       	call   100cb2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104da6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104db2:	00 
  104db3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104dba:	00 
  104dbb:	89 04 24             	mov    %eax,(%esp)
  104dbe:	e8 fd f7 ff ff       	call   1045c0 <get_pte>
  104dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104dc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104dca:	75 24                	jne    104df0 <check_pgdir+0x4c6>
  104dcc:	c7 44 24 0c 98 6e 10 	movl   $0x106e98,0xc(%esp)
  104dd3:	00 
  104dd4:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104ddb:	00 
  104ddc:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104de3:	00 
  104de4:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104deb:	e8 c2 be ff ff       	call   100cb2 <__panic>
    assert(pa2page(*ptep) == p1);
  104df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104df3:	8b 00                	mov    (%eax),%eax
  104df5:	89 04 24             	mov    %eax,(%esp)
  104df8:	e8 9e ed ff ff       	call   103b9b <pa2page>
  104dfd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104e00:	74 24                	je     104e26 <check_pgdir+0x4fc>
  104e02:	c7 44 24 0c 11 6e 10 	movl   $0x106e11,0xc(%esp)
  104e09:	00 
  104e0a:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104e11:	00 
  104e12:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104e19:	00 
  104e1a:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104e21:	e8 8c be ff ff       	call   100cb2 <__panic>
    assert((*ptep & PTE_U) == 0);
  104e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e29:	8b 00                	mov    (%eax),%eax
  104e2b:	83 e0 04             	and    $0x4,%eax
  104e2e:	85 c0                	test   %eax,%eax
  104e30:	74 24                	je     104e56 <check_pgdir+0x52c>
  104e32:	c7 44 24 0c 5c 6f 10 	movl   $0x106f5c,0xc(%esp)
  104e39:	00 
  104e3a:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104e41:	00 
  104e42:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104e49:	00 
  104e4a:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104e51:	e8 5c be ff ff       	call   100cb2 <__panic>

    page_remove(boot_pgdir, 0x0);
  104e56:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104e62:	00 
  104e63:	89 04 24             	mov    %eax,(%esp)
  104e66:	e8 47 f9 ff ff       	call   1047b2 <page_remove>
    assert(page_ref(p1) == 1);
  104e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e6e:	89 04 24             	mov    %eax,(%esp)
  104e71:	e8 06 ee ff ff       	call   103c7c <page_ref>
  104e76:	83 f8 01             	cmp    $0x1,%eax
  104e79:	74 24                	je     104e9f <check_pgdir+0x575>
  104e7b:	c7 44 24 0c 26 6e 10 	movl   $0x106e26,0xc(%esp)
  104e82:	00 
  104e83:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104e8a:	00 
  104e8b:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104e92:	00 
  104e93:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104e9a:	e8 13 be ff ff       	call   100cb2 <__panic>
    assert(page_ref(p2) == 0);
  104e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ea2:	89 04 24             	mov    %eax,(%esp)
  104ea5:	e8 d2 ed ff ff       	call   103c7c <page_ref>
  104eaa:	85 c0                	test   %eax,%eax
  104eac:	74 24                	je     104ed2 <check_pgdir+0x5a8>
  104eae:	c7 44 24 0c 4a 6f 10 	movl   $0x106f4a,0xc(%esp)
  104eb5:	00 
  104eb6:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104ebd:	00 
  104ebe:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104ec5:	00 
  104ec6:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104ecd:	e8 e0 bd ff ff       	call   100cb2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104ed2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ed7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ede:	00 
  104edf:	89 04 24             	mov    %eax,(%esp)
  104ee2:	e8 cb f8 ff ff       	call   1047b2 <page_remove>
    assert(page_ref(p1) == 0);
  104ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eea:	89 04 24             	mov    %eax,(%esp)
  104eed:	e8 8a ed ff ff       	call   103c7c <page_ref>
  104ef2:	85 c0                	test   %eax,%eax
  104ef4:	74 24                	je     104f1a <check_pgdir+0x5f0>
  104ef6:	c7 44 24 0c 71 6f 10 	movl   $0x106f71,0xc(%esp)
  104efd:	00 
  104efe:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104f05:	00 
  104f06:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  104f0d:	00 
  104f0e:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104f15:	e8 98 bd ff ff       	call   100cb2 <__panic>
    assert(page_ref(p2) == 0);
  104f1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f1d:	89 04 24             	mov    %eax,(%esp)
  104f20:	e8 57 ed ff ff       	call   103c7c <page_ref>
  104f25:	85 c0                	test   %eax,%eax
  104f27:	74 24                	je     104f4d <check_pgdir+0x623>
  104f29:	c7 44 24 0c 4a 6f 10 	movl   $0x106f4a,0xc(%esp)
  104f30:	00 
  104f31:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104f38:	00 
  104f39:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  104f40:	00 
  104f41:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104f48:	e8 65 bd ff ff       	call   100cb2 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104f4d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f52:	8b 00                	mov    (%eax),%eax
  104f54:	89 04 24             	mov    %eax,(%esp)
  104f57:	e8 3f ec ff ff       	call   103b9b <pa2page>
  104f5c:	89 04 24             	mov    %eax,(%esp)
  104f5f:	e8 18 ed ff ff       	call   103c7c <page_ref>
  104f64:	83 f8 01             	cmp    $0x1,%eax
  104f67:	74 24                	je     104f8d <check_pgdir+0x663>
  104f69:	c7 44 24 0c 84 6f 10 	movl   $0x106f84,0xc(%esp)
  104f70:	00 
  104f71:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  104f78:	00 
  104f79:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104f80:	00 
  104f81:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  104f88:	e8 25 bd ff ff       	call   100cb2 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104f8d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f92:	8b 00                	mov    (%eax),%eax
  104f94:	89 04 24             	mov    %eax,(%esp)
  104f97:	e8 ff eb ff ff       	call   103b9b <pa2page>
  104f9c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fa3:	00 
  104fa4:	89 04 24             	mov    %eax,(%esp)
  104fa7:	e8 0d ef ff ff       	call   103eb9 <free_pages>
    boot_pgdir[0] = 0;
  104fac:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104fb7:	c7 04 24 aa 6f 10 00 	movl   $0x106faa,(%esp)
  104fbe:	e8 79 b3 ff ff       	call   10033c <cprintf>
}
  104fc3:	c9                   	leave  
  104fc4:	c3                   	ret    

00104fc5 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104fc5:	55                   	push   %ebp
  104fc6:	89 e5                	mov    %esp,%ebp
  104fc8:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104fcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104fd2:	e9 ca 00 00 00       	jmp    1050a1 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fe0:	c1 e8 0c             	shr    $0xc,%eax
  104fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104fe6:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104feb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104fee:	72 23                	jb     105013 <check_boot_pgdir+0x4e>
  104ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ff3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ff7:	c7 44 24 08 f4 6b 10 	movl   $0x106bf4,0x8(%esp)
  104ffe:	00 
  104fff:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105006:	00 
  105007:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  10500e:	e8 9f bc ff ff       	call   100cb2 <__panic>
  105013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105016:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10501b:	89 c2                	mov    %eax,%edx
  10501d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105022:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105029:	00 
  10502a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10502e:	89 04 24             	mov    %eax,(%esp)
  105031:	e8 8a f5 ff ff       	call   1045c0 <get_pte>
  105036:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105039:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10503d:	75 24                	jne    105063 <check_boot_pgdir+0x9e>
  10503f:	c7 44 24 0c c4 6f 10 	movl   $0x106fc4,0xc(%esp)
  105046:	00 
  105047:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  10504e:	00 
  10504f:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105056:	00 
  105057:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  10505e:	e8 4f bc ff ff       	call   100cb2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  105063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105066:	8b 00                	mov    (%eax),%eax
  105068:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10506d:	89 c2                	mov    %eax,%edx
  10506f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105072:	39 c2                	cmp    %eax,%edx
  105074:	74 24                	je     10509a <check_boot_pgdir+0xd5>
  105076:	c7 44 24 0c 01 70 10 	movl   $0x107001,0xc(%esp)
  10507d:	00 
  10507e:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  105085:	00 
  105086:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  10508d:	00 
  10508e:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  105095:	e8 18 bc ff ff       	call   100cb2 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  10509a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1050a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1050a4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1050a9:	39 c2                	cmp    %eax,%edx
  1050ab:	0f 82 26 ff ff ff    	jb     104fd7 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1050b1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050b6:	05 ac 0f 00 00       	add    $0xfac,%eax
  1050bb:	8b 00                	mov    (%eax),%eax
  1050bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1050c2:	89 c2                	mov    %eax,%edx
  1050c4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1050cc:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  1050d3:	77 23                	ja     1050f8 <check_boot_pgdir+0x133>
  1050d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1050dc:	c7 44 24 08 98 6c 10 	movl   $0x106c98,0x8(%esp)
  1050e3:	00 
  1050e4:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  1050eb:	00 
  1050ec:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1050f3:	e8 ba bb ff ff       	call   100cb2 <__panic>
  1050f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050fb:	05 00 00 00 40       	add    $0x40000000,%eax
  105100:	39 c2                	cmp    %eax,%edx
  105102:	74 24                	je     105128 <check_boot_pgdir+0x163>
  105104:	c7 44 24 0c 18 70 10 	movl   $0x107018,0xc(%esp)
  10510b:	00 
  10510c:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  105113:	00 
  105114:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  10511b:	00 
  10511c:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  105123:	e8 8a bb ff ff       	call   100cb2 <__panic>

    assert(boot_pgdir[0] == 0);
  105128:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10512d:	8b 00                	mov    (%eax),%eax
  10512f:	85 c0                	test   %eax,%eax
  105131:	74 24                	je     105157 <check_boot_pgdir+0x192>
  105133:	c7 44 24 0c 4c 70 10 	movl   $0x10704c,0xc(%esp)
  10513a:	00 
  10513b:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  105142:	00 
  105143:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  10514a:	00 
  10514b:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  105152:	e8 5b bb ff ff       	call   100cb2 <__panic>

    struct Page *p;
    p = alloc_page();
  105157:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10515e:	e8 1e ed ff ff       	call   103e81 <alloc_pages>
  105163:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105166:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10516b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105172:	00 
  105173:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  10517a:	00 
  10517b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10517e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105182:	89 04 24             	mov    %eax,(%esp)
  105185:	e8 6c f6 ff ff       	call   1047f6 <page_insert>
  10518a:	85 c0                	test   %eax,%eax
  10518c:	74 24                	je     1051b2 <check_boot_pgdir+0x1ed>
  10518e:	c7 44 24 0c 60 70 10 	movl   $0x107060,0xc(%esp)
  105195:	00 
  105196:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  10519d:	00 
  10519e:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  1051a5:	00 
  1051a6:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1051ad:	e8 00 bb ff ff       	call   100cb2 <__panic>
    assert(page_ref(p) == 1);
  1051b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051b5:	89 04 24             	mov    %eax,(%esp)
  1051b8:	e8 bf ea ff ff       	call   103c7c <page_ref>
  1051bd:	83 f8 01             	cmp    $0x1,%eax
  1051c0:	74 24                	je     1051e6 <check_boot_pgdir+0x221>
  1051c2:	c7 44 24 0c 8e 70 10 	movl   $0x10708e,0xc(%esp)
  1051c9:	00 
  1051ca:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  1051d1:	00 
  1051d2:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  1051d9:	00 
  1051da:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1051e1:	e8 cc ba ff ff       	call   100cb2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1051e6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051eb:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1051f2:	00 
  1051f3:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1051fa:	00 
  1051fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  105202:	89 04 24             	mov    %eax,(%esp)
  105205:	e8 ec f5 ff ff       	call   1047f6 <page_insert>
  10520a:	85 c0                	test   %eax,%eax
  10520c:	74 24                	je     105232 <check_boot_pgdir+0x26d>
  10520e:	c7 44 24 0c a0 70 10 	movl   $0x1070a0,0xc(%esp)
  105215:	00 
  105216:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  10521d:	00 
  10521e:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
  105225:	00 
  105226:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  10522d:	e8 80 ba ff ff       	call   100cb2 <__panic>
    assert(page_ref(p) == 2);
  105232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105235:	89 04 24             	mov    %eax,(%esp)
  105238:	e8 3f ea ff ff       	call   103c7c <page_ref>
  10523d:	83 f8 02             	cmp    $0x2,%eax
  105240:	74 24                	je     105266 <check_boot_pgdir+0x2a1>
  105242:	c7 44 24 0c d7 70 10 	movl   $0x1070d7,0xc(%esp)
  105249:	00 
  10524a:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  105251:	00 
  105252:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  105259:	00 
  10525a:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  105261:	e8 4c ba ff ff       	call   100cb2 <__panic>

    const char *str = "ucore: Hello world!!";
  105266:	c7 45 dc e8 70 10 00 	movl   $0x1070e8,-0x24(%ebp)
    strcpy((void *)0x100, str);
  10526d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105270:	89 44 24 04          	mov    %eax,0x4(%esp)
  105274:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10527b:	e8 1e 0a 00 00       	call   105c9e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105280:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105287:	00 
  105288:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10528f:	e8 83 0a 00 00       	call   105d17 <strcmp>
  105294:	85 c0                	test   %eax,%eax
  105296:	74 24                	je     1052bc <check_boot_pgdir+0x2f7>
  105298:	c7 44 24 0c 00 71 10 	movl   $0x107100,0xc(%esp)
  10529f:	00 
  1052a0:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  1052a7:	00 
  1052a8:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
  1052af:	00 
  1052b0:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1052b7:	e8 f6 b9 ff ff       	call   100cb2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1052bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052bf:	89 04 24             	mov    %eax,(%esp)
  1052c2:	e8 23 e9 ff ff       	call   103bea <page2kva>
  1052c7:	05 00 01 00 00       	add    $0x100,%eax
  1052cc:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1052cf:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052d6:	e8 6b 09 00 00       	call   105c46 <strlen>
  1052db:	85 c0                	test   %eax,%eax
  1052dd:	74 24                	je     105303 <check_boot_pgdir+0x33e>
  1052df:	c7 44 24 0c 38 71 10 	movl   $0x107138,0xc(%esp)
  1052e6:	00 
  1052e7:	c7 44 24 08 e1 6c 10 	movl   $0x106ce1,0x8(%esp)
  1052ee:	00 
  1052ef:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
  1052f6:	00 
  1052f7:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1052fe:	e8 af b9 ff ff       	call   100cb2 <__panic>

    free_page(p);
  105303:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10530a:	00 
  10530b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10530e:	89 04 24             	mov    %eax,(%esp)
  105311:	e8 a3 eb ff ff       	call   103eb9 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  105316:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10531b:	8b 00                	mov    (%eax),%eax
  10531d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105322:	89 04 24             	mov    %eax,(%esp)
  105325:	e8 71 e8 ff ff       	call   103b9b <pa2page>
  10532a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105331:	00 
  105332:	89 04 24             	mov    %eax,(%esp)
  105335:	e8 7f eb ff ff       	call   103eb9 <free_pages>
    boot_pgdir[0] = 0;
  10533a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10533f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105345:	c7 04 24 5c 71 10 00 	movl   $0x10715c,(%esp)
  10534c:	e8 eb af ff ff       	call   10033c <cprintf>
}
  105351:	c9                   	leave  
  105352:	c3                   	ret    

00105353 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105353:	55                   	push   %ebp
  105354:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105356:	8b 45 08             	mov    0x8(%ebp),%eax
  105359:	83 e0 04             	and    $0x4,%eax
  10535c:	85 c0                	test   %eax,%eax
  10535e:	74 07                	je     105367 <perm2str+0x14>
  105360:	b8 75 00 00 00       	mov    $0x75,%eax
  105365:	eb 05                	jmp    10536c <perm2str+0x19>
  105367:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10536c:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105371:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105378:	8b 45 08             	mov    0x8(%ebp),%eax
  10537b:	83 e0 02             	and    $0x2,%eax
  10537e:	85 c0                	test   %eax,%eax
  105380:	74 07                	je     105389 <perm2str+0x36>
  105382:	b8 77 00 00 00       	mov    $0x77,%eax
  105387:	eb 05                	jmp    10538e <perm2str+0x3b>
  105389:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10538e:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  105393:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  10539a:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  10539f:	5d                   	pop    %ebp
  1053a0:	c3                   	ret    

001053a1 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1053a1:	55                   	push   %ebp
  1053a2:	89 e5                	mov    %esp,%ebp
  1053a4:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1053a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1053aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053ad:	72 0a                	jb     1053b9 <get_pgtable_items+0x18>
        return 0;
  1053af:	b8 00 00 00 00       	mov    $0x0,%eax
  1053b4:	e9 9c 00 00 00       	jmp    105455 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1053b9:	eb 04                	jmp    1053bf <get_pgtable_items+0x1e>
        start ++;
  1053bb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1053bf:	8b 45 10             	mov    0x10(%ebp),%eax
  1053c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053c5:	73 18                	jae    1053df <get_pgtable_items+0x3e>
  1053c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1053ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1053d1:	8b 45 14             	mov    0x14(%ebp),%eax
  1053d4:	01 d0                	add    %edx,%eax
  1053d6:	8b 00                	mov    (%eax),%eax
  1053d8:	83 e0 01             	and    $0x1,%eax
  1053db:	85 c0                	test   %eax,%eax
  1053dd:	74 dc                	je     1053bb <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1053df:	8b 45 10             	mov    0x10(%ebp),%eax
  1053e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053e5:	73 69                	jae    105450 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1053e7:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1053eb:	74 08                	je     1053f5 <get_pgtable_items+0x54>
            *left_store = start;
  1053ed:	8b 45 18             	mov    0x18(%ebp),%eax
  1053f0:	8b 55 10             	mov    0x10(%ebp),%edx
  1053f3:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1053f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1053f8:	8d 50 01             	lea    0x1(%eax),%edx
  1053fb:	89 55 10             	mov    %edx,0x10(%ebp)
  1053fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105405:	8b 45 14             	mov    0x14(%ebp),%eax
  105408:	01 d0                	add    %edx,%eax
  10540a:	8b 00                	mov    (%eax),%eax
  10540c:	83 e0 07             	and    $0x7,%eax
  10540f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105412:	eb 04                	jmp    105418 <get_pgtable_items+0x77>
            start ++;
  105414:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105418:	8b 45 10             	mov    0x10(%ebp),%eax
  10541b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10541e:	73 1d                	jae    10543d <get_pgtable_items+0x9c>
  105420:	8b 45 10             	mov    0x10(%ebp),%eax
  105423:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10542a:	8b 45 14             	mov    0x14(%ebp),%eax
  10542d:	01 d0                	add    %edx,%eax
  10542f:	8b 00                	mov    (%eax),%eax
  105431:	83 e0 07             	and    $0x7,%eax
  105434:	89 c2                	mov    %eax,%edx
  105436:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105439:	39 c2                	cmp    %eax,%edx
  10543b:	74 d7                	je     105414 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  10543d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105441:	74 08                	je     10544b <get_pgtable_items+0xaa>
            *right_store = start;
  105443:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105446:	8b 55 10             	mov    0x10(%ebp),%edx
  105449:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10544b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10544e:	eb 05                	jmp    105455 <get_pgtable_items+0xb4>
    }
    return 0;
  105450:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105455:	c9                   	leave  
  105456:	c3                   	ret    

00105457 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105457:	55                   	push   %ebp
  105458:	89 e5                	mov    %esp,%ebp
  10545a:	57                   	push   %edi
  10545b:	56                   	push   %esi
  10545c:	53                   	push   %ebx
  10545d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105460:	c7 04 24 7c 71 10 00 	movl   $0x10717c,(%esp)
  105467:	e8 d0 ae ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  10546c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105473:	e9 fa 00 00 00       	jmp    105572 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10547b:	89 04 24             	mov    %eax,(%esp)
  10547e:	e8 d0 fe ff ff       	call   105353 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105483:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105486:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105489:	29 d1                	sub    %edx,%ecx
  10548b:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10548d:	89 d6                	mov    %edx,%esi
  10548f:	c1 e6 16             	shl    $0x16,%esi
  105492:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105495:	89 d3                	mov    %edx,%ebx
  105497:	c1 e3 16             	shl    $0x16,%ebx
  10549a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10549d:	89 d1                	mov    %edx,%ecx
  10549f:	c1 e1 16             	shl    $0x16,%ecx
  1054a2:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1054a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1054a8:	29 d7                	sub    %edx,%edi
  1054aa:	89 fa                	mov    %edi,%edx
  1054ac:	89 44 24 14          	mov    %eax,0x14(%esp)
  1054b0:	89 74 24 10          	mov    %esi,0x10(%esp)
  1054b4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1054b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1054bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1054c0:	c7 04 24 ad 71 10 00 	movl   $0x1071ad,(%esp)
  1054c7:	e8 70 ae ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1054cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054cf:	c1 e0 0a             	shl    $0xa,%eax
  1054d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1054d5:	eb 54                	jmp    10552b <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1054d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054da:	89 04 24             	mov    %eax,(%esp)
  1054dd:	e8 71 fe ff ff       	call   105353 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1054e2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1054e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1054e8:	29 d1                	sub    %edx,%ecx
  1054ea:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1054ec:	89 d6                	mov    %edx,%esi
  1054ee:	c1 e6 0c             	shl    $0xc,%esi
  1054f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054f4:	89 d3                	mov    %edx,%ebx
  1054f6:	c1 e3 0c             	shl    $0xc,%ebx
  1054f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1054fc:	c1 e2 0c             	shl    $0xc,%edx
  1054ff:	89 d1                	mov    %edx,%ecx
  105501:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105504:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105507:	29 d7                	sub    %edx,%edi
  105509:	89 fa                	mov    %edi,%edx
  10550b:	89 44 24 14          	mov    %eax,0x14(%esp)
  10550f:	89 74 24 10          	mov    %esi,0x10(%esp)
  105513:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105517:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10551b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10551f:	c7 04 24 cc 71 10 00 	movl   $0x1071cc,(%esp)
  105526:	e8 11 ae ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10552b:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105533:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105536:	89 ce                	mov    %ecx,%esi
  105538:	c1 e6 0a             	shl    $0xa,%esi
  10553b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10553e:	89 cb                	mov    %ecx,%ebx
  105540:	c1 e3 0a             	shl    $0xa,%ebx
  105543:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105546:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10554a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10554d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105551:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105555:	89 44 24 08          	mov    %eax,0x8(%esp)
  105559:	89 74 24 04          	mov    %esi,0x4(%esp)
  10555d:	89 1c 24             	mov    %ebx,(%esp)
  105560:	e8 3c fe ff ff       	call   1053a1 <get_pgtable_items>
  105565:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105568:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10556c:	0f 85 65 ff ff ff    	jne    1054d7 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105572:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105577:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10557a:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10557d:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105581:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105584:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105588:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10558c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105590:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105597:	00 
  105598:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10559f:	e8 fd fd ff ff       	call   1053a1 <get_pgtable_items>
  1055a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1055ab:	0f 85 c7 fe ff ff    	jne    105478 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1055b1:	c7 04 24 f0 71 10 00 	movl   $0x1071f0,(%esp)
  1055b8:	e8 7f ad ff ff       	call   10033c <cprintf>
}
  1055bd:	83 c4 4c             	add    $0x4c,%esp
  1055c0:	5b                   	pop    %ebx
  1055c1:	5e                   	pop    %esi
  1055c2:	5f                   	pop    %edi
  1055c3:	5d                   	pop    %ebp
  1055c4:	c3                   	ret    

001055c5 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1055c5:	55                   	push   %ebp
  1055c6:	89 e5                	mov    %esp,%ebp
  1055c8:	83 ec 58             	sub    $0x58,%esp
  1055cb:	8b 45 10             	mov    0x10(%ebp),%eax
  1055ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1055d1:	8b 45 14             	mov    0x14(%ebp),%eax
  1055d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1055d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1055da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1055dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055e0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1055e3:	8b 45 18             	mov    0x18(%ebp),%eax
  1055e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1055ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1055f2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1055f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1055fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1055ff:	74 1c                	je     10561d <printnum+0x58>
  105601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105604:	ba 00 00 00 00       	mov    $0x0,%edx
  105609:	f7 75 e4             	divl   -0x1c(%ebp)
  10560c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10560f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105612:	ba 00 00 00 00       	mov    $0x0,%edx
  105617:	f7 75 e4             	divl   -0x1c(%ebp)
  10561a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10561d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105623:	f7 75 e4             	divl   -0x1c(%ebp)
  105626:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105629:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10562c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10562f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105632:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105635:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105638:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10563b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10563e:	8b 45 18             	mov    0x18(%ebp),%eax
  105641:	ba 00 00 00 00       	mov    $0x0,%edx
  105646:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105649:	77 56                	ja     1056a1 <printnum+0xdc>
  10564b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10564e:	72 05                	jb     105655 <printnum+0x90>
  105650:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105653:	77 4c                	ja     1056a1 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105655:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105658:	8d 50 ff             	lea    -0x1(%eax),%edx
  10565b:	8b 45 20             	mov    0x20(%ebp),%eax
  10565e:	89 44 24 18          	mov    %eax,0x18(%esp)
  105662:	89 54 24 14          	mov    %edx,0x14(%esp)
  105666:	8b 45 18             	mov    0x18(%ebp),%eax
  105669:	89 44 24 10          	mov    %eax,0x10(%esp)
  10566d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105670:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105673:	89 44 24 08          	mov    %eax,0x8(%esp)
  105677:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10567b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10567e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105682:	8b 45 08             	mov    0x8(%ebp),%eax
  105685:	89 04 24             	mov    %eax,(%esp)
  105688:	e8 38 ff ff ff       	call   1055c5 <printnum>
  10568d:	eb 1c                	jmp    1056ab <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10568f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105692:	89 44 24 04          	mov    %eax,0x4(%esp)
  105696:	8b 45 20             	mov    0x20(%ebp),%eax
  105699:	89 04 24             	mov    %eax,(%esp)
  10569c:	8b 45 08             	mov    0x8(%ebp),%eax
  10569f:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1056a1:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1056a5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1056a9:	7f e4                	jg     10568f <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1056ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1056ae:	05 a4 72 10 00       	add    $0x1072a4,%eax
  1056b3:	0f b6 00             	movzbl (%eax),%eax
  1056b6:	0f be c0             	movsbl %al,%eax
  1056b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056c0:	89 04 24             	mov    %eax,(%esp)
  1056c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c6:	ff d0                	call   *%eax
}
  1056c8:	c9                   	leave  
  1056c9:	c3                   	ret    

001056ca <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1056ca:	55                   	push   %ebp
  1056cb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1056cd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1056d1:	7e 14                	jle    1056e7 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1056d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d6:	8b 00                	mov    (%eax),%eax
  1056d8:	8d 48 08             	lea    0x8(%eax),%ecx
  1056db:	8b 55 08             	mov    0x8(%ebp),%edx
  1056de:	89 0a                	mov    %ecx,(%edx)
  1056e0:	8b 50 04             	mov    0x4(%eax),%edx
  1056e3:	8b 00                	mov    (%eax),%eax
  1056e5:	eb 30                	jmp    105717 <getuint+0x4d>
    }
    else if (lflag) {
  1056e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1056eb:	74 16                	je     105703 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1056ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1056f0:	8b 00                	mov    (%eax),%eax
  1056f2:	8d 48 04             	lea    0x4(%eax),%ecx
  1056f5:	8b 55 08             	mov    0x8(%ebp),%edx
  1056f8:	89 0a                	mov    %ecx,(%edx)
  1056fa:	8b 00                	mov    (%eax),%eax
  1056fc:	ba 00 00 00 00       	mov    $0x0,%edx
  105701:	eb 14                	jmp    105717 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105703:	8b 45 08             	mov    0x8(%ebp),%eax
  105706:	8b 00                	mov    (%eax),%eax
  105708:	8d 48 04             	lea    0x4(%eax),%ecx
  10570b:	8b 55 08             	mov    0x8(%ebp),%edx
  10570e:	89 0a                	mov    %ecx,(%edx)
  105710:	8b 00                	mov    (%eax),%eax
  105712:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105717:	5d                   	pop    %ebp
  105718:	c3                   	ret    

00105719 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105719:	55                   	push   %ebp
  10571a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10571c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105720:	7e 14                	jle    105736 <getint+0x1d>
        return va_arg(*ap, long long);
  105722:	8b 45 08             	mov    0x8(%ebp),%eax
  105725:	8b 00                	mov    (%eax),%eax
  105727:	8d 48 08             	lea    0x8(%eax),%ecx
  10572a:	8b 55 08             	mov    0x8(%ebp),%edx
  10572d:	89 0a                	mov    %ecx,(%edx)
  10572f:	8b 50 04             	mov    0x4(%eax),%edx
  105732:	8b 00                	mov    (%eax),%eax
  105734:	eb 28                	jmp    10575e <getint+0x45>
    }
    else if (lflag) {
  105736:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10573a:	74 12                	je     10574e <getint+0x35>
        return va_arg(*ap, long);
  10573c:	8b 45 08             	mov    0x8(%ebp),%eax
  10573f:	8b 00                	mov    (%eax),%eax
  105741:	8d 48 04             	lea    0x4(%eax),%ecx
  105744:	8b 55 08             	mov    0x8(%ebp),%edx
  105747:	89 0a                	mov    %ecx,(%edx)
  105749:	8b 00                	mov    (%eax),%eax
  10574b:	99                   	cltd   
  10574c:	eb 10                	jmp    10575e <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10574e:	8b 45 08             	mov    0x8(%ebp),%eax
  105751:	8b 00                	mov    (%eax),%eax
  105753:	8d 48 04             	lea    0x4(%eax),%ecx
  105756:	8b 55 08             	mov    0x8(%ebp),%edx
  105759:	89 0a                	mov    %ecx,(%edx)
  10575b:	8b 00                	mov    (%eax),%eax
  10575d:	99                   	cltd   
    }
}
  10575e:	5d                   	pop    %ebp
  10575f:	c3                   	ret    

00105760 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105760:	55                   	push   %ebp
  105761:	89 e5                	mov    %esp,%ebp
  105763:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105766:	8d 45 14             	lea    0x14(%ebp),%eax
  105769:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10576c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10576f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105773:	8b 45 10             	mov    0x10(%ebp),%eax
  105776:	89 44 24 08          	mov    %eax,0x8(%esp)
  10577a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10577d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105781:	8b 45 08             	mov    0x8(%ebp),%eax
  105784:	89 04 24             	mov    %eax,(%esp)
  105787:	e8 02 00 00 00       	call   10578e <vprintfmt>
    va_end(ap);
}
  10578c:	c9                   	leave  
  10578d:	c3                   	ret    

0010578e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10578e:	55                   	push   %ebp
  10578f:	89 e5                	mov    %esp,%ebp
  105791:	56                   	push   %esi
  105792:	53                   	push   %ebx
  105793:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105796:	eb 18                	jmp    1057b0 <vprintfmt+0x22>
            if (ch == '\0') {
  105798:	85 db                	test   %ebx,%ebx
  10579a:	75 05                	jne    1057a1 <vprintfmt+0x13>
                return;
  10579c:	e9 d1 03 00 00       	jmp    105b72 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1057a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a8:	89 1c 24             	mov    %ebx,(%esp)
  1057ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ae:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057b0:	8b 45 10             	mov    0x10(%ebp),%eax
  1057b3:	8d 50 01             	lea    0x1(%eax),%edx
  1057b6:	89 55 10             	mov    %edx,0x10(%ebp)
  1057b9:	0f b6 00             	movzbl (%eax),%eax
  1057bc:	0f b6 d8             	movzbl %al,%ebx
  1057bf:	83 fb 25             	cmp    $0x25,%ebx
  1057c2:	75 d4                	jne    105798 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1057c4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1057c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1057cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1057d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1057dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1057df:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1057e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1057e5:	8d 50 01             	lea    0x1(%eax),%edx
  1057e8:	89 55 10             	mov    %edx,0x10(%ebp)
  1057eb:	0f b6 00             	movzbl (%eax),%eax
  1057ee:	0f b6 d8             	movzbl %al,%ebx
  1057f1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1057f4:	83 f8 55             	cmp    $0x55,%eax
  1057f7:	0f 87 44 03 00 00    	ja     105b41 <vprintfmt+0x3b3>
  1057fd:	8b 04 85 c8 72 10 00 	mov    0x1072c8(,%eax,4),%eax
  105804:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105806:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10580a:	eb d6                	jmp    1057e2 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10580c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105810:	eb d0                	jmp    1057e2 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105812:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105819:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10581c:	89 d0                	mov    %edx,%eax
  10581e:	c1 e0 02             	shl    $0x2,%eax
  105821:	01 d0                	add    %edx,%eax
  105823:	01 c0                	add    %eax,%eax
  105825:	01 d8                	add    %ebx,%eax
  105827:	83 e8 30             	sub    $0x30,%eax
  10582a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10582d:	8b 45 10             	mov    0x10(%ebp),%eax
  105830:	0f b6 00             	movzbl (%eax),%eax
  105833:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105836:	83 fb 2f             	cmp    $0x2f,%ebx
  105839:	7e 0b                	jle    105846 <vprintfmt+0xb8>
  10583b:	83 fb 39             	cmp    $0x39,%ebx
  10583e:	7f 06                	jg     105846 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105840:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105844:	eb d3                	jmp    105819 <vprintfmt+0x8b>
            goto process_precision;
  105846:	eb 33                	jmp    10587b <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105848:	8b 45 14             	mov    0x14(%ebp),%eax
  10584b:	8d 50 04             	lea    0x4(%eax),%edx
  10584e:	89 55 14             	mov    %edx,0x14(%ebp)
  105851:	8b 00                	mov    (%eax),%eax
  105853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105856:	eb 23                	jmp    10587b <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105858:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10585c:	79 0c                	jns    10586a <vprintfmt+0xdc>
                width = 0;
  10585e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105865:	e9 78 ff ff ff       	jmp    1057e2 <vprintfmt+0x54>
  10586a:	e9 73 ff ff ff       	jmp    1057e2 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  10586f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105876:	e9 67 ff ff ff       	jmp    1057e2 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  10587b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10587f:	79 12                	jns    105893 <vprintfmt+0x105>
                width = precision, precision = -1;
  105881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105884:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105887:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10588e:	e9 4f ff ff ff       	jmp    1057e2 <vprintfmt+0x54>
  105893:	e9 4a ff ff ff       	jmp    1057e2 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105898:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10589c:	e9 41 ff ff ff       	jmp    1057e2 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1058a1:	8b 45 14             	mov    0x14(%ebp),%eax
  1058a4:	8d 50 04             	lea    0x4(%eax),%edx
  1058a7:	89 55 14             	mov    %edx,0x14(%ebp)
  1058aa:	8b 00                	mov    (%eax),%eax
  1058ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1058b3:	89 04 24             	mov    %eax,(%esp)
  1058b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b9:	ff d0                	call   *%eax
            break;
  1058bb:	e9 ac 02 00 00       	jmp    105b6c <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1058c0:	8b 45 14             	mov    0x14(%ebp),%eax
  1058c3:	8d 50 04             	lea    0x4(%eax),%edx
  1058c6:	89 55 14             	mov    %edx,0x14(%ebp)
  1058c9:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1058cb:	85 db                	test   %ebx,%ebx
  1058cd:	79 02                	jns    1058d1 <vprintfmt+0x143>
                err = -err;
  1058cf:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1058d1:	83 fb 06             	cmp    $0x6,%ebx
  1058d4:	7f 0b                	jg     1058e1 <vprintfmt+0x153>
  1058d6:	8b 34 9d 88 72 10 00 	mov    0x107288(,%ebx,4),%esi
  1058dd:	85 f6                	test   %esi,%esi
  1058df:	75 23                	jne    105904 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1058e1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1058e5:	c7 44 24 08 b5 72 10 	movl   $0x1072b5,0x8(%esp)
  1058ec:	00 
  1058ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f7:	89 04 24             	mov    %eax,(%esp)
  1058fa:	e8 61 fe ff ff       	call   105760 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1058ff:	e9 68 02 00 00       	jmp    105b6c <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105904:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105908:	c7 44 24 08 be 72 10 	movl   $0x1072be,0x8(%esp)
  10590f:	00 
  105910:	8b 45 0c             	mov    0xc(%ebp),%eax
  105913:	89 44 24 04          	mov    %eax,0x4(%esp)
  105917:	8b 45 08             	mov    0x8(%ebp),%eax
  10591a:	89 04 24             	mov    %eax,(%esp)
  10591d:	e8 3e fe ff ff       	call   105760 <printfmt>
            }
            break;
  105922:	e9 45 02 00 00       	jmp    105b6c <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105927:	8b 45 14             	mov    0x14(%ebp),%eax
  10592a:	8d 50 04             	lea    0x4(%eax),%edx
  10592d:	89 55 14             	mov    %edx,0x14(%ebp)
  105930:	8b 30                	mov    (%eax),%esi
  105932:	85 f6                	test   %esi,%esi
  105934:	75 05                	jne    10593b <vprintfmt+0x1ad>
                p = "(null)";
  105936:	be c1 72 10 00       	mov    $0x1072c1,%esi
            }
            if (width > 0 && padc != '-') {
  10593b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10593f:	7e 3e                	jle    10597f <vprintfmt+0x1f1>
  105941:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105945:	74 38                	je     10597f <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105947:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  10594a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10594d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105951:	89 34 24             	mov    %esi,(%esp)
  105954:	e8 15 03 00 00       	call   105c6e <strnlen>
  105959:	29 c3                	sub    %eax,%ebx
  10595b:	89 d8                	mov    %ebx,%eax
  10595d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105960:	eb 17                	jmp    105979 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105962:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105966:	8b 55 0c             	mov    0xc(%ebp),%edx
  105969:	89 54 24 04          	mov    %edx,0x4(%esp)
  10596d:	89 04 24             	mov    %eax,(%esp)
  105970:	8b 45 08             	mov    0x8(%ebp),%eax
  105973:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105975:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105979:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10597d:	7f e3                	jg     105962 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10597f:	eb 38                	jmp    1059b9 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105981:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105985:	74 1f                	je     1059a6 <vprintfmt+0x218>
  105987:	83 fb 1f             	cmp    $0x1f,%ebx
  10598a:	7e 05                	jle    105991 <vprintfmt+0x203>
  10598c:	83 fb 7e             	cmp    $0x7e,%ebx
  10598f:	7e 15                	jle    1059a6 <vprintfmt+0x218>
                    putch('?', putdat);
  105991:	8b 45 0c             	mov    0xc(%ebp),%eax
  105994:	89 44 24 04          	mov    %eax,0x4(%esp)
  105998:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10599f:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a2:	ff d0                	call   *%eax
  1059a4:	eb 0f                	jmp    1059b5 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1059a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ad:	89 1c 24             	mov    %ebx,(%esp)
  1059b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b3:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059b5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1059b9:	89 f0                	mov    %esi,%eax
  1059bb:	8d 70 01             	lea    0x1(%eax),%esi
  1059be:	0f b6 00             	movzbl (%eax),%eax
  1059c1:	0f be d8             	movsbl %al,%ebx
  1059c4:	85 db                	test   %ebx,%ebx
  1059c6:	74 10                	je     1059d8 <vprintfmt+0x24a>
  1059c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059cc:	78 b3                	js     105981 <vprintfmt+0x1f3>
  1059ce:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1059d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059d6:	79 a9                	jns    105981 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1059d8:	eb 17                	jmp    1059f1 <vprintfmt+0x263>
                putch(' ', putdat);
  1059da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1059e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1059eb:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1059ed:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1059f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059f5:	7f e3                	jg     1059da <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  1059f7:	e9 70 01 00 00       	jmp    105b6c <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1059fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a03:	8d 45 14             	lea    0x14(%ebp),%eax
  105a06:	89 04 24             	mov    %eax,(%esp)
  105a09:	e8 0b fd ff ff       	call   105719 <getint>
  105a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a11:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a1a:	85 d2                	test   %edx,%edx
  105a1c:	79 26                	jns    105a44 <vprintfmt+0x2b6>
                putch('-', putdat);
  105a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a25:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a2f:	ff d0                	call   *%eax
                num = -(long long)num;
  105a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a37:	f7 d8                	neg    %eax
  105a39:	83 d2 00             	adc    $0x0,%edx
  105a3c:	f7 da                	neg    %edx
  105a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a41:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105a44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a4b:	e9 a8 00 00 00       	jmp    105af8 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a57:	8d 45 14             	lea    0x14(%ebp),%eax
  105a5a:	89 04 24             	mov    %eax,(%esp)
  105a5d:	e8 68 fc ff ff       	call   1056ca <getuint>
  105a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a65:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105a68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a6f:	e9 84 00 00 00       	jmp    105af8 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a7b:	8d 45 14             	lea    0x14(%ebp),%eax
  105a7e:	89 04 24             	mov    %eax,(%esp)
  105a81:	e8 44 fc ff ff       	call   1056ca <getuint>
  105a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105a8c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105a93:	eb 63                	jmp    105af8 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a9c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa6:	ff d0                	call   *%eax
            putch('x', putdat);
  105aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aaf:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab9:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105abb:	8b 45 14             	mov    0x14(%ebp),%eax
  105abe:	8d 50 04             	lea    0x4(%eax),%edx
  105ac1:	89 55 14             	mov    %edx,0x14(%ebp)
  105ac4:	8b 00                	mov    (%eax),%eax
  105ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ac9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105ad0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105ad7:	eb 1f                	jmp    105af8 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ae0:	8d 45 14             	lea    0x14(%ebp),%eax
  105ae3:	89 04 24             	mov    %eax,(%esp)
  105ae6:	e8 df fb ff ff       	call   1056ca <getuint>
  105aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105af1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105af8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105aff:	89 54 24 18          	mov    %edx,0x18(%esp)
  105b03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105b06:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b14:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b18:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b23:	8b 45 08             	mov    0x8(%ebp),%eax
  105b26:	89 04 24             	mov    %eax,(%esp)
  105b29:	e8 97 fa ff ff       	call   1055c5 <printnum>
            break;
  105b2e:	eb 3c                	jmp    105b6c <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b37:	89 1c 24             	mov    %ebx,(%esp)
  105b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3d:	ff d0                	call   *%eax
            break;
  105b3f:	eb 2b                	jmp    105b6c <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b48:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b52:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105b54:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b58:	eb 04                	jmp    105b5e <vprintfmt+0x3d0>
  105b5a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b5e:	8b 45 10             	mov    0x10(%ebp),%eax
  105b61:	83 e8 01             	sub    $0x1,%eax
  105b64:	0f b6 00             	movzbl (%eax),%eax
  105b67:	3c 25                	cmp    $0x25,%al
  105b69:	75 ef                	jne    105b5a <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105b6b:	90                   	nop
        }
    }
  105b6c:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105b6d:	e9 3e fc ff ff       	jmp    1057b0 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105b72:	83 c4 40             	add    $0x40,%esp
  105b75:	5b                   	pop    %ebx
  105b76:	5e                   	pop    %esi
  105b77:	5d                   	pop    %ebp
  105b78:	c3                   	ret    

00105b79 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105b79:	55                   	push   %ebp
  105b7a:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b7f:	8b 40 08             	mov    0x8(%eax),%eax
  105b82:	8d 50 01             	lea    0x1(%eax),%edx
  105b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b88:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b8e:	8b 10                	mov    (%eax),%edx
  105b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b93:	8b 40 04             	mov    0x4(%eax),%eax
  105b96:	39 c2                	cmp    %eax,%edx
  105b98:	73 12                	jae    105bac <sprintputch+0x33>
        *b->buf ++ = ch;
  105b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b9d:	8b 00                	mov    (%eax),%eax
  105b9f:	8d 48 01             	lea    0x1(%eax),%ecx
  105ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ba5:	89 0a                	mov    %ecx,(%edx)
  105ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  105baa:	88 10                	mov    %dl,(%eax)
    }
}
  105bac:	5d                   	pop    %ebp
  105bad:	c3                   	ret    

00105bae <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105bae:	55                   	push   %ebp
  105baf:	89 e5                	mov    %esp,%ebp
  105bb1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105bb4:	8d 45 14             	lea    0x14(%ebp),%eax
  105bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105bc1:	8b 45 10             	mov    0x10(%ebp),%eax
  105bc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  105bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd2:	89 04 24             	mov    %eax,(%esp)
  105bd5:	e8 08 00 00 00       	call   105be2 <vsnprintf>
  105bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105be0:	c9                   	leave  
  105be1:	c3                   	ret    

00105be2 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105be2:	55                   	push   %ebp
  105be3:	89 e5                	mov    %esp,%ebp
  105be5:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105be8:	8b 45 08             	mov    0x8(%ebp),%eax
  105beb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bf1:	8d 50 ff             	lea    -0x1(%eax),%edx
  105bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf7:	01 d0                	add    %edx,%eax
  105bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105c07:	74 0a                	je     105c13 <vsnprintf+0x31>
  105c09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c0f:	39 c2                	cmp    %eax,%edx
  105c11:	76 07                	jbe    105c1a <vsnprintf+0x38>
        return -E_INVAL;
  105c13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105c18:	eb 2a                	jmp    105c44 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  105c1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c21:	8b 45 10             	mov    0x10(%ebp),%eax
  105c24:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c28:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c2f:	c7 04 24 79 5b 10 00 	movl   $0x105b79,(%esp)
  105c36:	e8 53 fb ff ff       	call   10578e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c3e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c44:	c9                   	leave  
  105c45:	c3                   	ret    

00105c46 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105c46:	55                   	push   %ebp
  105c47:	89 e5                	mov    %esp,%ebp
  105c49:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105c4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105c53:	eb 04                	jmp    105c59 <strlen+0x13>
        cnt ++;
  105c55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105c59:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5c:	8d 50 01             	lea    0x1(%eax),%edx
  105c5f:	89 55 08             	mov    %edx,0x8(%ebp)
  105c62:	0f b6 00             	movzbl (%eax),%eax
  105c65:	84 c0                	test   %al,%al
  105c67:	75 ec                	jne    105c55 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105c6c:	c9                   	leave  
  105c6d:	c3                   	ret    

00105c6e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105c6e:	55                   	push   %ebp
  105c6f:	89 e5                	mov    %esp,%ebp
  105c71:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105c7b:	eb 04                	jmp    105c81 <strnlen+0x13>
        cnt ++;
  105c7d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c84:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105c87:	73 10                	jae    105c99 <strnlen+0x2b>
  105c89:	8b 45 08             	mov    0x8(%ebp),%eax
  105c8c:	8d 50 01             	lea    0x1(%eax),%edx
  105c8f:	89 55 08             	mov    %edx,0x8(%ebp)
  105c92:	0f b6 00             	movzbl (%eax),%eax
  105c95:	84 c0                	test   %al,%al
  105c97:	75 e4                	jne    105c7d <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105c9c:	c9                   	leave  
  105c9d:	c3                   	ret    

00105c9e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105c9e:	55                   	push   %ebp
  105c9f:	89 e5                	mov    %esp,%ebp
  105ca1:	57                   	push   %edi
  105ca2:	56                   	push   %esi
  105ca3:	83 ec 20             	sub    $0x20,%esp
  105ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  105caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105cb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cb8:	89 d1                	mov    %edx,%ecx
  105cba:	89 c2                	mov    %eax,%edx
  105cbc:	89 ce                	mov    %ecx,%esi
  105cbe:	89 d7                	mov    %edx,%edi
  105cc0:	ac                   	lods   %ds:(%esi),%al
  105cc1:	aa                   	stos   %al,%es:(%edi)
  105cc2:	84 c0                	test   %al,%al
  105cc4:	75 fa                	jne    105cc0 <strcpy+0x22>
  105cc6:	89 fa                	mov    %edi,%edx
  105cc8:	89 f1                	mov    %esi,%ecx
  105cca:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ccd:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105cd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105cd6:	83 c4 20             	add    $0x20,%esp
  105cd9:	5e                   	pop    %esi
  105cda:	5f                   	pop    %edi
  105cdb:	5d                   	pop    %ebp
  105cdc:	c3                   	ret    

00105cdd <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105cdd:	55                   	push   %ebp
  105cde:	89 e5                	mov    %esp,%ebp
  105ce0:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105ce9:	eb 21                	jmp    105d0c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cee:	0f b6 10             	movzbl (%eax),%edx
  105cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105cf4:	88 10                	mov    %dl,(%eax)
  105cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105cf9:	0f b6 00             	movzbl (%eax),%eax
  105cfc:	84 c0                	test   %al,%al
  105cfe:	74 04                	je     105d04 <strncpy+0x27>
            src ++;
  105d00:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105d04:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105d08:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105d0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d10:	75 d9                	jne    105ceb <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105d12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d15:	c9                   	leave  
  105d16:	c3                   	ret    

00105d17 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105d17:	55                   	push   %ebp
  105d18:	89 e5                	mov    %esp,%ebp
  105d1a:	57                   	push   %edi
  105d1b:	56                   	push   %esi
  105d1c:	83 ec 20             	sub    $0x20,%esp
  105d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105d2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d31:	89 d1                	mov    %edx,%ecx
  105d33:	89 c2                	mov    %eax,%edx
  105d35:	89 ce                	mov    %ecx,%esi
  105d37:	89 d7                	mov    %edx,%edi
  105d39:	ac                   	lods   %ds:(%esi),%al
  105d3a:	ae                   	scas   %es:(%edi),%al
  105d3b:	75 08                	jne    105d45 <strcmp+0x2e>
  105d3d:	84 c0                	test   %al,%al
  105d3f:	75 f8                	jne    105d39 <strcmp+0x22>
  105d41:	31 c0                	xor    %eax,%eax
  105d43:	eb 04                	jmp    105d49 <strcmp+0x32>
  105d45:	19 c0                	sbb    %eax,%eax
  105d47:	0c 01                	or     $0x1,%al
  105d49:	89 fa                	mov    %edi,%edx
  105d4b:	89 f1                	mov    %esi,%ecx
  105d4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d50:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d53:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105d59:	83 c4 20             	add    $0x20,%esp
  105d5c:	5e                   	pop    %esi
  105d5d:	5f                   	pop    %edi
  105d5e:	5d                   	pop    %ebp
  105d5f:	c3                   	ret    

00105d60 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105d60:	55                   	push   %ebp
  105d61:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105d63:	eb 0c                	jmp    105d71 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105d65:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105d69:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d6d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d75:	74 1a                	je     105d91 <strncmp+0x31>
  105d77:	8b 45 08             	mov    0x8(%ebp),%eax
  105d7a:	0f b6 00             	movzbl (%eax),%eax
  105d7d:	84 c0                	test   %al,%al
  105d7f:	74 10                	je     105d91 <strncmp+0x31>
  105d81:	8b 45 08             	mov    0x8(%ebp),%eax
  105d84:	0f b6 10             	movzbl (%eax),%edx
  105d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d8a:	0f b6 00             	movzbl (%eax),%eax
  105d8d:	38 c2                	cmp    %al,%dl
  105d8f:	74 d4                	je     105d65 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105d91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d95:	74 18                	je     105daf <strncmp+0x4f>
  105d97:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9a:	0f b6 00             	movzbl (%eax),%eax
  105d9d:	0f b6 d0             	movzbl %al,%edx
  105da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105da3:	0f b6 00             	movzbl (%eax),%eax
  105da6:	0f b6 c0             	movzbl %al,%eax
  105da9:	29 c2                	sub    %eax,%edx
  105dab:	89 d0                	mov    %edx,%eax
  105dad:	eb 05                	jmp    105db4 <strncmp+0x54>
  105daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105db4:	5d                   	pop    %ebp
  105db5:	c3                   	ret    

00105db6 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105db6:	55                   	push   %ebp
  105db7:	89 e5                	mov    %esp,%ebp
  105db9:	83 ec 04             	sub    $0x4,%esp
  105dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dbf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105dc2:	eb 14                	jmp    105dd8 <strchr+0x22>
        if (*s == c) {
  105dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc7:	0f b6 00             	movzbl (%eax),%eax
  105dca:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105dcd:	75 05                	jne    105dd4 <strchr+0x1e>
            return (char *)s;
  105dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd2:	eb 13                	jmp    105de7 <strchr+0x31>
        }
        s ++;
  105dd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  105ddb:	0f b6 00             	movzbl (%eax),%eax
  105dde:	84 c0                	test   %al,%al
  105de0:	75 e2                	jne    105dc4 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105de7:	c9                   	leave  
  105de8:	c3                   	ret    

00105de9 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105de9:	55                   	push   %ebp
  105dea:	89 e5                	mov    %esp,%ebp
  105dec:	83 ec 04             	sub    $0x4,%esp
  105def:	8b 45 0c             	mov    0xc(%ebp),%eax
  105df2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105df5:	eb 11                	jmp    105e08 <strfind+0x1f>
        if (*s == c) {
  105df7:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfa:	0f b6 00             	movzbl (%eax),%eax
  105dfd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105e00:	75 02                	jne    105e04 <strfind+0x1b>
            break;
  105e02:	eb 0e                	jmp    105e12 <strfind+0x29>
        }
        s ++;
  105e04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105e08:	8b 45 08             	mov    0x8(%ebp),%eax
  105e0b:	0f b6 00             	movzbl (%eax),%eax
  105e0e:	84 c0                	test   %al,%al
  105e10:	75 e5                	jne    105df7 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105e12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e15:	c9                   	leave  
  105e16:	c3                   	ret    

00105e17 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105e17:	55                   	push   %ebp
  105e18:	89 e5                	mov    %esp,%ebp
  105e1a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105e1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105e24:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105e2b:	eb 04                	jmp    105e31 <strtol+0x1a>
        s ++;
  105e2d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105e31:	8b 45 08             	mov    0x8(%ebp),%eax
  105e34:	0f b6 00             	movzbl (%eax),%eax
  105e37:	3c 20                	cmp    $0x20,%al
  105e39:	74 f2                	je     105e2d <strtol+0x16>
  105e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e3e:	0f b6 00             	movzbl (%eax),%eax
  105e41:	3c 09                	cmp    $0x9,%al
  105e43:	74 e8                	je     105e2d <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105e45:	8b 45 08             	mov    0x8(%ebp),%eax
  105e48:	0f b6 00             	movzbl (%eax),%eax
  105e4b:	3c 2b                	cmp    $0x2b,%al
  105e4d:	75 06                	jne    105e55 <strtol+0x3e>
        s ++;
  105e4f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e53:	eb 15                	jmp    105e6a <strtol+0x53>
    }
    else if (*s == '-') {
  105e55:	8b 45 08             	mov    0x8(%ebp),%eax
  105e58:	0f b6 00             	movzbl (%eax),%eax
  105e5b:	3c 2d                	cmp    $0x2d,%al
  105e5d:	75 0b                	jne    105e6a <strtol+0x53>
        s ++, neg = 1;
  105e5f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e63:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105e6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e6e:	74 06                	je     105e76 <strtol+0x5f>
  105e70:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105e74:	75 24                	jne    105e9a <strtol+0x83>
  105e76:	8b 45 08             	mov    0x8(%ebp),%eax
  105e79:	0f b6 00             	movzbl (%eax),%eax
  105e7c:	3c 30                	cmp    $0x30,%al
  105e7e:	75 1a                	jne    105e9a <strtol+0x83>
  105e80:	8b 45 08             	mov    0x8(%ebp),%eax
  105e83:	83 c0 01             	add    $0x1,%eax
  105e86:	0f b6 00             	movzbl (%eax),%eax
  105e89:	3c 78                	cmp    $0x78,%al
  105e8b:	75 0d                	jne    105e9a <strtol+0x83>
        s += 2, base = 16;
  105e8d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105e91:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105e98:	eb 2a                	jmp    105ec4 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e9e:	75 17                	jne    105eb7 <strtol+0xa0>
  105ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea3:	0f b6 00             	movzbl (%eax),%eax
  105ea6:	3c 30                	cmp    $0x30,%al
  105ea8:	75 0d                	jne    105eb7 <strtol+0xa0>
        s ++, base = 8;
  105eaa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105eae:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105eb5:	eb 0d                	jmp    105ec4 <strtol+0xad>
    }
    else if (base == 0) {
  105eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ebb:	75 07                	jne    105ec4 <strtol+0xad>
        base = 10;
  105ebd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec7:	0f b6 00             	movzbl (%eax),%eax
  105eca:	3c 2f                	cmp    $0x2f,%al
  105ecc:	7e 1b                	jle    105ee9 <strtol+0xd2>
  105ece:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed1:	0f b6 00             	movzbl (%eax),%eax
  105ed4:	3c 39                	cmp    $0x39,%al
  105ed6:	7f 11                	jg     105ee9 <strtol+0xd2>
            dig = *s - '0';
  105ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  105edb:	0f b6 00             	movzbl (%eax),%eax
  105ede:	0f be c0             	movsbl %al,%eax
  105ee1:	83 e8 30             	sub    $0x30,%eax
  105ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ee7:	eb 48                	jmp    105f31 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  105eec:	0f b6 00             	movzbl (%eax),%eax
  105eef:	3c 60                	cmp    $0x60,%al
  105ef1:	7e 1b                	jle    105f0e <strtol+0xf7>
  105ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef6:	0f b6 00             	movzbl (%eax),%eax
  105ef9:	3c 7a                	cmp    $0x7a,%al
  105efb:	7f 11                	jg     105f0e <strtol+0xf7>
            dig = *s - 'a' + 10;
  105efd:	8b 45 08             	mov    0x8(%ebp),%eax
  105f00:	0f b6 00             	movzbl (%eax),%eax
  105f03:	0f be c0             	movsbl %al,%eax
  105f06:	83 e8 57             	sub    $0x57,%eax
  105f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f0c:	eb 23                	jmp    105f31 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f11:	0f b6 00             	movzbl (%eax),%eax
  105f14:	3c 40                	cmp    $0x40,%al
  105f16:	7e 3d                	jle    105f55 <strtol+0x13e>
  105f18:	8b 45 08             	mov    0x8(%ebp),%eax
  105f1b:	0f b6 00             	movzbl (%eax),%eax
  105f1e:	3c 5a                	cmp    $0x5a,%al
  105f20:	7f 33                	jg     105f55 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105f22:	8b 45 08             	mov    0x8(%ebp),%eax
  105f25:	0f b6 00             	movzbl (%eax),%eax
  105f28:	0f be c0             	movsbl %al,%eax
  105f2b:	83 e8 37             	sub    $0x37,%eax
  105f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f34:	3b 45 10             	cmp    0x10(%ebp),%eax
  105f37:	7c 02                	jl     105f3b <strtol+0x124>
            break;
  105f39:	eb 1a                	jmp    105f55 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105f3b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105f3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f42:	0f af 45 10          	imul   0x10(%ebp),%eax
  105f46:	89 c2                	mov    %eax,%edx
  105f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f4b:	01 d0                	add    %edx,%eax
  105f4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105f50:	e9 6f ff ff ff       	jmp    105ec4 <strtol+0xad>

    if (endptr) {
  105f55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105f59:	74 08                	je     105f63 <strtol+0x14c>
        *endptr = (char *) s;
  105f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  105f61:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105f63:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105f67:	74 07                	je     105f70 <strtol+0x159>
  105f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f6c:	f7 d8                	neg    %eax
  105f6e:	eb 03                	jmp    105f73 <strtol+0x15c>
  105f70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105f73:	c9                   	leave  
  105f74:	c3                   	ret    

00105f75 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105f75:	55                   	push   %ebp
  105f76:	89 e5                	mov    %esp,%ebp
  105f78:	57                   	push   %edi
  105f79:	83 ec 24             	sub    $0x24,%esp
  105f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f7f:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105f82:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105f86:	8b 55 08             	mov    0x8(%ebp),%edx
  105f89:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105f8c:	88 45 f7             	mov    %al,-0x9(%ebp)
  105f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  105f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105f95:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105f98:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105f9c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105f9f:	89 d7                	mov    %edx,%edi
  105fa1:	f3 aa                	rep stos %al,%es:(%edi)
  105fa3:	89 fa                	mov    %edi,%edx
  105fa5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105fa8:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105fae:	83 c4 24             	add    $0x24,%esp
  105fb1:	5f                   	pop    %edi
  105fb2:	5d                   	pop    %ebp
  105fb3:	c3                   	ret    

00105fb4 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105fb4:	55                   	push   %ebp
  105fb5:	89 e5                	mov    %esp,%ebp
  105fb7:	57                   	push   %edi
  105fb8:	56                   	push   %esi
  105fb9:	53                   	push   %ebx
  105fba:	83 ec 30             	sub    $0x30,%esp
  105fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  105fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  105fcc:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fd2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105fd5:	73 42                	jae    106019 <memmove+0x65>
  105fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105fe0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105fe6:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105fe9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105fec:	c1 e8 02             	shr    $0x2,%eax
  105fef:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105ff1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ff4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ff7:	89 d7                	mov    %edx,%edi
  105ff9:	89 c6                	mov    %eax,%esi
  105ffb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ffd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106000:	83 e1 03             	and    $0x3,%ecx
  106003:	74 02                	je     106007 <memmove+0x53>
  106005:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106007:	89 f0                	mov    %esi,%eax
  106009:	89 fa                	mov    %edi,%edx
  10600b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10600e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106011:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  106014:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106017:	eb 36                	jmp    10604f <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  106019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10601c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10601f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106022:	01 c2                	add    %eax,%edx
  106024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106027:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10602a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10602d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  106030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106033:	89 c1                	mov    %eax,%ecx
  106035:	89 d8                	mov    %ebx,%eax
  106037:	89 d6                	mov    %edx,%esi
  106039:	89 c7                	mov    %eax,%edi
  10603b:	fd                   	std    
  10603c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10603e:	fc                   	cld    
  10603f:	89 f8                	mov    %edi,%eax
  106041:	89 f2                	mov    %esi,%edx
  106043:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106046:	89 55 c8             	mov    %edx,-0x38(%ebp)
  106049:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  10604c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10604f:	83 c4 30             	add    $0x30,%esp
  106052:	5b                   	pop    %ebx
  106053:	5e                   	pop    %esi
  106054:	5f                   	pop    %edi
  106055:	5d                   	pop    %ebp
  106056:	c3                   	ret    

00106057 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  106057:	55                   	push   %ebp
  106058:	89 e5                	mov    %esp,%ebp
  10605a:	57                   	push   %edi
  10605b:	56                   	push   %esi
  10605c:	83 ec 20             	sub    $0x20,%esp
  10605f:	8b 45 08             	mov    0x8(%ebp),%eax
  106062:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106065:	8b 45 0c             	mov    0xc(%ebp),%eax
  106068:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10606b:	8b 45 10             	mov    0x10(%ebp),%eax
  10606e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106074:	c1 e8 02             	shr    $0x2,%eax
  106077:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  106079:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10607c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10607f:	89 d7                	mov    %edx,%edi
  106081:	89 c6                	mov    %eax,%esi
  106083:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106085:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106088:	83 e1 03             	and    $0x3,%ecx
  10608b:	74 02                	je     10608f <memcpy+0x38>
  10608d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10608f:	89 f0                	mov    %esi,%eax
  106091:	89 fa                	mov    %edi,%edx
  106093:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106096:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106099:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10609c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10609f:	83 c4 20             	add    $0x20,%esp
  1060a2:	5e                   	pop    %esi
  1060a3:	5f                   	pop    %edi
  1060a4:	5d                   	pop    %ebp
  1060a5:	c3                   	ret    

001060a6 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1060a6:	55                   	push   %ebp
  1060a7:	89 e5                	mov    %esp,%ebp
  1060a9:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1060ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1060af:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1060b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1060b8:	eb 30                	jmp    1060ea <memcmp+0x44>
        if (*s1 != *s2) {
  1060ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060bd:	0f b6 10             	movzbl (%eax),%edx
  1060c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060c3:	0f b6 00             	movzbl (%eax),%eax
  1060c6:	38 c2                	cmp    %al,%dl
  1060c8:	74 18                	je     1060e2 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1060ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060cd:	0f b6 00             	movzbl (%eax),%eax
  1060d0:	0f b6 d0             	movzbl %al,%edx
  1060d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060d6:	0f b6 00             	movzbl (%eax),%eax
  1060d9:	0f b6 c0             	movzbl %al,%eax
  1060dc:	29 c2                	sub    %eax,%edx
  1060de:	89 d0                	mov    %edx,%eax
  1060e0:	eb 1a                	jmp    1060fc <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1060e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1060e6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1060ea:	8b 45 10             	mov    0x10(%ebp),%eax
  1060ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  1060f0:	89 55 10             	mov    %edx,0x10(%ebp)
  1060f3:	85 c0                	test   %eax,%eax
  1060f5:	75 c3                	jne    1060ba <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1060f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1060fc:	c9                   	leave  
  1060fd:	c3                   	ret    
