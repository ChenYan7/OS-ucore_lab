
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	53                   	push   %ebx
  100008:	83 ec 14             	sub    $0x14,%esp
  10000b:	e8 a4 02 00 00       	call   1002b4 <__x86.get_pc_thunk.bx>
  100010:	81 c3 40 09 01 00    	add    $0x10940,%ebx
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100016:	c7 c0 20 1e 11 00    	mov    $0x111e20,%eax
  10001c:	89 c2                	mov    %eax,%edx
  10001e:	c7 c0 50 09 11 00    	mov    $0x110950,%eax
  100024:	29 c2                	sub    %eax,%edx
  100026:	89 d0                	mov    %edx,%eax
  100028:	83 ec 04             	sub    $0x4,%esp
  10002b:	50                   	push   %eax
  10002c:	6a 00                	push   $0x0
  10002e:	c7 c0 50 09 11 00    	mov    $0x110950,%eax
  100034:	50                   	push   %eax
  100035:	e8 bd 33 00 00       	call   1033f7 <memset>
  10003a:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  10003d:	e8 f8 18 00 00       	call   10193a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100042:	8d 83 00 33 ff ff    	lea    -0xcd00(%ebx),%eax
  100048:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10004b:	83 ec 08             	sub    $0x8,%esp
  10004e:	ff 75 f4             	pushl  -0xc(%ebp)
  100051:	8d 83 1c 33 ff ff    	lea    -0xcce4(%ebx),%eax
  100057:	50                   	push   %eax
  100058:	e8 d2 02 00 00       	call   10032f <cprintf>
  10005d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100060:	e8 0f 0a 00 00       	call   100a74 <print_kerninfo>

    grade_backtrace();
  100065:	e8 a9 00 00 00       	call   100113 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10006a:	e8 c2 2f 00 00       	call   103031 <pmm_init>

    pic_init();                 // init interrupt controller
  10006f:	e8 6b 1a 00 00       	call   101adf <pic_init>
    idt_init();                 // init interrupt descriptor table
  100074:	e8 1d 1c 00 00       	call   101c96 <idt_init>

    clock_init();               // init clock interrupt
  100079:	e8 5c 0f 00 00       	call   100fda <clock_init>
    intr_enable();              // enable irq interrupt
  10007e:	e8 b6 1b 00 00       	call   101c39 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100083:	e8 cf 01 00 00       	call   100257 <lab1_switch_test>

    /* do nothing */
    while (1);
  100088:	eb fe                	jmp    100088 <kern_init+0x88>

0010008a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10008a:	f3 0f 1e fb          	endbr32 
  10008e:	55                   	push   %ebp
  10008f:	89 e5                	mov    %esp,%ebp
  100091:	53                   	push   %ebx
  100092:	83 ec 04             	sub    $0x4,%esp
  100095:	e8 16 02 00 00       	call   1002b0 <__x86.get_pc_thunk.ax>
  10009a:	05 b6 08 01 00       	add    $0x108b6,%eax
    mon_backtrace(0, NULL, NULL);
  10009f:	83 ec 04             	sub    $0x4,%esp
  1000a2:	6a 00                	push   $0x0
  1000a4:	6a 00                	push   $0x0
  1000a6:	6a 00                	push   $0x0
  1000a8:	89 c3                	mov    %eax,%ebx
  1000aa:	e8 04 0f 00 00       	call   100fb3 <mon_backtrace>
  1000af:	83 c4 10             	add    $0x10,%esp
}
  1000b2:	90                   	nop
  1000b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000b6:	c9                   	leave  
  1000b7:	c3                   	ret    

001000b8 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000b8:	f3 0f 1e fb          	endbr32 
  1000bc:	55                   	push   %ebp
  1000bd:	89 e5                	mov    %esp,%ebp
  1000bf:	53                   	push   %ebx
  1000c0:	83 ec 04             	sub    $0x4,%esp
  1000c3:	e8 e8 01 00 00       	call   1002b0 <__x86.get_pc_thunk.ax>
  1000c8:	05 88 08 01 00       	add    $0x10888,%eax
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000cd:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d3:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d9:	51                   	push   %ecx
  1000da:	52                   	push   %edx
  1000db:	53                   	push   %ebx
  1000dc:	50                   	push   %eax
  1000dd:	e8 a8 ff ff ff       	call   10008a <grade_backtrace2>
  1000e2:	83 c4 10             	add    $0x10,%esp
}
  1000e5:	90                   	nop
  1000e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000e9:	c9                   	leave  
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	f3 0f 1e fb          	endbr32 
  1000ef:	55                   	push   %ebp
  1000f0:	89 e5                	mov    %esp,%ebp
  1000f2:	83 ec 08             	sub    $0x8,%esp
  1000f5:	e8 b6 01 00 00       	call   1002b0 <__x86.get_pc_thunk.ax>
  1000fa:	05 56 08 01 00       	add    $0x10856,%eax
    grade_backtrace1(arg0, arg2);
  1000ff:	83 ec 08             	sub    $0x8,%esp
  100102:	ff 75 10             	pushl  0x10(%ebp)
  100105:	ff 75 08             	pushl  0x8(%ebp)
  100108:	e8 ab ff ff ff       	call   1000b8 <grade_backtrace1>
  10010d:	83 c4 10             	add    $0x10,%esp
}
  100110:	90                   	nop
  100111:	c9                   	leave  
  100112:	c3                   	ret    

00100113 <grade_backtrace>:

void
grade_backtrace(void) {
  100113:	f3 0f 1e fb          	endbr32 
  100117:	55                   	push   %ebp
  100118:	89 e5                	mov    %esp,%ebp
  10011a:	83 ec 08             	sub    $0x8,%esp
  10011d:	e8 8e 01 00 00       	call   1002b0 <__x86.get_pc_thunk.ax>
  100122:	05 2e 08 01 00       	add    $0x1082e,%eax
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100127:	8d 80 b0 f6 fe ff    	lea    -0x10950(%eax),%eax
  10012d:	83 ec 04             	sub    $0x4,%esp
  100130:	68 00 00 ff ff       	push   $0xffff0000
  100135:	50                   	push   %eax
  100136:	6a 00                	push   $0x0
  100138:	e8 ae ff ff ff       	call   1000eb <grade_backtrace0>
  10013d:	83 c4 10             	add    $0x10,%esp
}
  100140:	90                   	nop
  100141:	c9                   	leave  
  100142:	c3                   	ret    

00100143 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100143:	f3 0f 1e fb          	endbr32 
  100147:	55                   	push   %ebp
  100148:	89 e5                	mov    %esp,%ebp
  10014a:	53                   	push   %ebx
  10014b:	83 ec 14             	sub    $0x14,%esp
  10014e:	e8 61 01 00 00       	call   1002b4 <__x86.get_pc_thunk.bx>
  100153:	81 c3 fd 07 01 00    	add    $0x107fd,%ebx
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100159:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10015c:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015f:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100162:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100169:	0f b7 c0             	movzwl %ax,%eax
  10016c:	83 e0 03             	and    $0x3,%eax
  10016f:	89 c2                	mov    %eax,%edx
  100171:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  100177:	83 ec 04             	sub    $0x4,%esp
  10017a:	52                   	push   %edx
  10017b:	50                   	push   %eax
  10017c:	8d 83 21 33 ff ff    	lea    -0xccdf(%ebx),%eax
  100182:	50                   	push   %eax
  100183:	e8 a7 01 00 00       	call   10032f <cprintf>
  100188:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10018b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10018f:	0f b7 d0             	movzwl %ax,%edx
  100192:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  100198:	83 ec 04             	sub    $0x4,%esp
  10019b:	52                   	push   %edx
  10019c:	50                   	push   %eax
  10019d:	8d 83 2f 33 ff ff    	lea    -0xccd1(%ebx),%eax
  1001a3:	50                   	push   %eax
  1001a4:	e8 86 01 00 00       	call   10032f <cprintf>
  1001a9:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  1001ac:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001b0:	0f b7 d0             	movzwl %ax,%edx
  1001b3:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  1001b9:	83 ec 04             	sub    $0x4,%esp
  1001bc:	52                   	push   %edx
  1001bd:	50                   	push   %eax
  1001be:	8d 83 3d 33 ff ff    	lea    -0xccc3(%ebx),%eax
  1001c4:	50                   	push   %eax
  1001c5:	e8 65 01 00 00       	call   10032f <cprintf>
  1001ca:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  1001cd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001d1:	0f b7 d0             	movzwl %ax,%edx
  1001d4:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  1001da:	83 ec 04             	sub    $0x4,%esp
  1001dd:	52                   	push   %edx
  1001de:	50                   	push   %eax
  1001df:	8d 83 4b 33 ff ff    	lea    -0xccb5(%ebx),%eax
  1001e5:	50                   	push   %eax
  1001e6:	e8 44 01 00 00       	call   10032f <cprintf>
  1001eb:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ee:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001f2:	0f b7 d0             	movzwl %ax,%edx
  1001f5:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  1001fb:	83 ec 04             	sub    $0x4,%esp
  1001fe:	52                   	push   %edx
  1001ff:	50                   	push   %eax
  100200:	8d 83 59 33 ff ff    	lea    -0xcca7(%ebx),%eax
  100206:	50                   	push   %eax
  100207:	e8 23 01 00 00       	call   10032f <cprintf>
  10020c:	83 c4 10             	add    $0x10,%esp
    round ++;
  10020f:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  100215:	83 c0 01             	add    $0x1,%eax
  100218:	89 83 70 01 00 00    	mov    %eax,0x170(%ebx)
}
  10021e:	90                   	nop
  10021f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100222:	c9                   	leave  
  100223:	c3                   	ret    

00100224 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  100224:	f3 0f 1e fb          	endbr32 
  100228:	55                   	push   %ebp
  100229:	89 e5                	mov    %esp,%ebp
  10022b:	e8 80 00 00 00       	call   1002b0 <__x86.get_pc_thunk.ax>
  100230:	05 20 07 01 00       	add    $0x10720,%eax
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  100235:	83 ec 08             	sub    $0x8,%esp
  100238:	cd 78                	int    $0x78
  10023a:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  10023c:	90                   	nop
  10023d:	5d                   	pop    %ebp
  10023e:	c3                   	ret    

0010023f <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10023f:	f3 0f 1e fb          	endbr32 
  100243:	55                   	push   %ebp
  100244:	89 e5                	mov    %esp,%ebp
  100246:	e8 65 00 00 00       	call   1002b0 <__x86.get_pc_thunk.ax>
  10024b:	05 05 07 01 00       	add    $0x10705,%eax
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  100250:	cd 79                	int    $0x79
  100252:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  100254:	90                   	nop
  100255:	5d                   	pop    %ebp
  100256:	c3                   	ret    

00100257 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100257:	f3 0f 1e fb          	endbr32 
  10025b:	55                   	push   %ebp
  10025c:	89 e5                	mov    %esp,%ebp
  10025e:	53                   	push   %ebx
  10025f:	83 ec 04             	sub    $0x4,%esp
  100262:	e8 4d 00 00 00       	call   1002b4 <__x86.get_pc_thunk.bx>
  100267:	81 c3 e9 06 01 00    	add    $0x106e9,%ebx
    lab1_print_cur_status();
  10026d:	e8 d1 fe ff ff       	call   100143 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100272:	83 ec 0c             	sub    $0xc,%esp
  100275:	8d 83 68 33 ff ff    	lea    -0xcc98(%ebx),%eax
  10027b:	50                   	push   %eax
  10027c:	e8 ae 00 00 00       	call   10032f <cprintf>
  100281:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  100284:	e8 9b ff ff ff       	call   100224 <lab1_switch_to_user>
    lab1_print_cur_status();
  100289:	e8 b5 fe ff ff       	call   100143 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10028e:	83 ec 0c             	sub    $0xc,%esp
  100291:	8d 83 88 33 ff ff    	lea    -0xcc78(%ebx),%eax
  100297:	50                   	push   %eax
  100298:	e8 92 00 00 00       	call   10032f <cprintf>
  10029d:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1002a0:	e8 9a ff ff ff       	call   10023f <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1002a5:	e8 99 fe ff ff       	call   100143 <lab1_print_cur_status>
}
  1002aa:	90                   	nop
  1002ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002ae:	c9                   	leave  
  1002af:	c3                   	ret    

001002b0 <__x86.get_pc_thunk.ax>:
  1002b0:	8b 04 24             	mov    (%esp),%eax
  1002b3:	c3                   	ret    

001002b4 <__x86.get_pc_thunk.bx>:
  1002b4:	8b 1c 24             	mov    (%esp),%ebx
  1002b7:	c3                   	ret    

001002b8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002b8:	f3 0f 1e fb          	endbr32 
  1002bc:	55                   	push   %ebp
  1002bd:	89 e5                	mov    %esp,%ebp
  1002bf:	53                   	push   %ebx
  1002c0:	83 ec 04             	sub    $0x4,%esp
  1002c3:	e8 e8 ff ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1002c8:	05 88 06 01 00       	add    $0x10688,%eax
    cons_putc(c);
  1002cd:	83 ec 0c             	sub    $0xc,%esp
  1002d0:	ff 75 08             	pushl  0x8(%ebp)
  1002d3:	89 c3                	mov    %eax,%ebx
  1002d5:	e8 a7 16 00 00       	call   101981 <cons_putc>
  1002da:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e0:	8b 00                	mov    (%eax),%eax
  1002e2:	8d 50 01             	lea    0x1(%eax),%edx
  1002e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e8:	89 10                	mov    %edx,(%eax)
}
  1002ea:	90                   	nop
  1002eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002ee:	c9                   	leave  
  1002ef:	c3                   	ret    

001002f0 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002f0:	f3 0f 1e fb          	endbr32 
  1002f4:	55                   	push   %ebp
  1002f5:	89 e5                	mov    %esp,%ebp
  1002f7:	53                   	push   %ebx
  1002f8:	83 ec 14             	sub    $0x14,%esp
  1002fb:	e8 b0 ff ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  100300:	05 50 06 01 00       	add    $0x10650,%eax
    int cnt = 0;
  100305:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10030c:	ff 75 0c             	pushl  0xc(%ebp)
  10030f:	ff 75 08             	pushl  0x8(%ebp)
  100312:	8d 55 f4             	lea    -0xc(%ebp),%edx
  100315:	52                   	push   %edx
  100316:	8d 90 68 f9 fe ff    	lea    -0x10698(%eax),%edx
  10031c:	52                   	push   %edx
  10031d:	89 c3                	mov    %eax,%ebx
  10031f:	e8 7a 34 00 00       	call   10379e <vprintfmt>
  100324:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100327:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10032d:	c9                   	leave  
  10032e:	c3                   	ret    

0010032f <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10032f:	f3 0f 1e fb          	endbr32 
  100333:	55                   	push   %ebp
  100334:	89 e5                	mov    %esp,%ebp
  100336:	83 ec 18             	sub    $0x18,%esp
  100339:	e8 72 ff ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10033e:	05 12 06 01 00       	add    $0x10612,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100343:	8d 45 0c             	lea    0xc(%ebp),%eax
  100346:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034c:	83 ec 08             	sub    $0x8,%esp
  10034f:	50                   	push   %eax
  100350:	ff 75 08             	pushl  0x8(%ebp)
  100353:	e8 98 ff ff ff       	call   1002f0 <vcprintf>
  100358:	83 c4 10             	add    $0x10,%esp
  10035b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100361:	c9                   	leave  
  100362:	c3                   	ret    

00100363 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100363:	f3 0f 1e fb          	endbr32 
  100367:	55                   	push   %ebp
  100368:	89 e5                	mov    %esp,%ebp
  10036a:	53                   	push   %ebx
  10036b:	83 ec 04             	sub    $0x4,%esp
  10036e:	e8 3d ff ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  100373:	05 dd 05 01 00       	add    $0x105dd,%eax
    cons_putc(c);
  100378:	83 ec 0c             	sub    $0xc,%esp
  10037b:	ff 75 08             	pushl  0x8(%ebp)
  10037e:	89 c3                	mov    %eax,%ebx
  100380:	e8 fc 15 00 00       	call   101981 <cons_putc>
  100385:	83 c4 10             	add    $0x10,%esp
}
  100388:	90                   	nop
  100389:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10038c:	c9                   	leave  
  10038d:	c3                   	ret    

0010038e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10038e:	f3 0f 1e fb          	endbr32 
  100392:	55                   	push   %ebp
  100393:	89 e5                	mov    %esp,%ebp
  100395:	83 ec 18             	sub    $0x18,%esp
  100398:	e8 13 ff ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10039d:	05 b3 05 01 00       	add    $0x105b3,%eax
    int cnt = 0;
  1003a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1003a9:	eb 14                	jmp    1003bf <cputs+0x31>
        cputch(c, &cnt);
  1003ab:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1003af:	83 ec 08             	sub    $0x8,%esp
  1003b2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1003b5:	52                   	push   %edx
  1003b6:	50                   	push   %eax
  1003b7:	e8 fc fe ff ff       	call   1002b8 <cputch>
  1003bc:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1003c2:	8d 50 01             	lea    0x1(%eax),%edx
  1003c5:	89 55 08             	mov    %edx,0x8(%ebp)
  1003c8:	0f b6 00             	movzbl (%eax),%eax
  1003cb:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003ce:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003d2:	75 d7                	jne    1003ab <cputs+0x1d>
    }
    cputch('\n', &cnt);
  1003d4:	83 ec 08             	sub    $0x8,%esp
  1003d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003da:	50                   	push   %eax
  1003db:	6a 0a                	push   $0xa
  1003dd:	e8 d6 fe ff ff       	call   1002b8 <cputch>
  1003e2:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1003e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003e8:	c9                   	leave  
  1003e9:	c3                   	ret    

001003ea <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003ea:	f3 0f 1e fb          	endbr32 
  1003ee:	55                   	push   %ebp
  1003ef:	89 e5                	mov    %esp,%ebp
  1003f1:	53                   	push   %ebx
  1003f2:	83 ec 14             	sub    $0x14,%esp
  1003f5:	e8 ba fe ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  1003fa:	81 c3 56 05 01 00    	add    $0x10556,%ebx
    int c;
    while ((c = cons_getc()) == 0)
  100400:	90                   	nop
  100401:	e8 b9 15 00 00       	call   1019bf <cons_getc>
  100406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10040d:	74 f2                	je     100401 <getchar+0x17>
        /* do nothing */;
    return c;
  10040f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100412:	83 c4 14             	add    $0x14,%esp
  100415:	5b                   	pop    %ebx
  100416:	5d                   	pop    %ebp
  100417:	c3                   	ret    

00100418 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100418:	f3 0f 1e fb          	endbr32 
  10041c:	55                   	push   %ebp
  10041d:	89 e5                	mov    %esp,%ebp
  10041f:	53                   	push   %ebx
  100420:	83 ec 14             	sub    $0x14,%esp
  100423:	e8 8c fe ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100428:	81 c3 28 05 01 00    	add    $0x10528,%ebx
    if (prompt != NULL) {
  10042e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100432:	74 15                	je     100449 <readline+0x31>
        cprintf("%s", prompt);
  100434:	83 ec 08             	sub    $0x8,%esp
  100437:	ff 75 08             	pushl  0x8(%ebp)
  10043a:	8d 83 a7 33 ff ff    	lea    -0xcc59(%ebx),%eax
  100440:	50                   	push   %eax
  100441:	e8 e9 fe ff ff       	call   10032f <cprintf>
  100446:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100450:	e8 95 ff ff ff       	call   1003ea <getchar>
  100455:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100458:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10045c:	79 0a                	jns    100468 <readline+0x50>
            return NULL;
  10045e:	b8 00 00 00 00       	mov    $0x0,%eax
  100463:	e9 87 00 00 00       	jmp    1004ef <readline+0xd7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100468:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10046c:	7e 2c                	jle    10049a <readline+0x82>
  10046e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100475:	7f 23                	jg     10049a <readline+0x82>
            cputchar(c);
  100477:	83 ec 0c             	sub    $0xc,%esp
  10047a:	ff 75 f0             	pushl  -0x10(%ebp)
  10047d:	e8 e1 fe ff ff       	call   100363 <cputchar>
  100482:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100488:	8d 50 01             	lea    0x1(%eax),%edx
  10048b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	88 94 03 90 01 00 00 	mov    %dl,0x190(%ebx,%eax,1)
  100498:	eb 50                	jmp    1004ea <readline+0xd2>
        }
        else if (c == '\b' && i > 0) {
  10049a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10049e:	75 1a                	jne    1004ba <readline+0xa2>
  1004a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004a4:	7e 14                	jle    1004ba <readline+0xa2>
            cputchar(c);
  1004a6:	83 ec 0c             	sub    $0xc,%esp
  1004a9:	ff 75 f0             	pushl  -0x10(%ebp)
  1004ac:	e8 b2 fe ff ff       	call   100363 <cputchar>
  1004b1:	83 c4 10             	add    $0x10,%esp
            i --;
  1004b4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1004b8:	eb 30                	jmp    1004ea <readline+0xd2>
        }
        else if (c == '\n' || c == '\r') {
  1004ba:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1004be:	74 06                	je     1004c6 <readline+0xae>
  1004c0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1004c4:	75 8a                	jne    100450 <readline+0x38>
            cputchar(c);
  1004c6:	83 ec 0c             	sub    $0xc,%esp
  1004c9:	ff 75 f0             	pushl  -0x10(%ebp)
  1004cc:	e8 92 fe ff ff       	call   100363 <cputchar>
  1004d1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1004d4:	8d 93 90 01 00 00    	lea    0x190(%ebx),%edx
  1004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004dd:	01 d0                	add    %edx,%eax
  1004df:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1004e2:	8d 83 90 01 00 00    	lea    0x190(%ebx),%eax
  1004e8:	eb 05                	jmp    1004ef <readline+0xd7>
        c = getchar();
  1004ea:	e9 61 ff ff ff       	jmp    100450 <readline+0x38>
        }
    }
}
  1004ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1004f2:	c9                   	leave  
  1004f3:	c3                   	ret    

001004f4 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1004f4:	f3 0f 1e fb          	endbr32 
  1004f8:	55                   	push   %ebp
  1004f9:	89 e5                	mov    %esp,%ebp
  1004fb:	53                   	push   %ebx
  1004fc:	83 ec 14             	sub    $0x14,%esp
  1004ff:	e8 b0 fd ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100504:	81 c3 4c 04 01 00    	add    $0x1044c,%ebx
    if (is_panic) {
  10050a:	8b 83 90 05 00 00    	mov    0x590(%ebx),%eax
  100510:	85 c0                	test   %eax,%eax
  100512:	75 4e                	jne    100562 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100514:	c7 83 90 05 00 00 01 	movl   $0x1,0x590(%ebx)
  10051b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10051e:	8d 45 14             	lea    0x14(%ebp),%eax
  100521:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100524:	83 ec 04             	sub    $0x4,%esp
  100527:	ff 75 0c             	pushl  0xc(%ebp)
  10052a:	ff 75 08             	pushl  0x8(%ebp)
  10052d:	8d 83 aa 33 ff ff    	lea    -0xcc56(%ebx),%eax
  100533:	50                   	push   %eax
  100534:	e8 f6 fd ff ff       	call   10032f <cprintf>
  100539:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10053c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10053f:	83 ec 08             	sub    $0x8,%esp
  100542:	50                   	push   %eax
  100543:	ff 75 10             	pushl  0x10(%ebp)
  100546:	e8 a5 fd ff ff       	call   1002f0 <vcprintf>
  10054b:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10054e:	83 ec 0c             	sub    $0xc,%esp
  100551:	8d 83 c6 33 ff ff    	lea    -0xcc3a(%ebx),%eax
  100557:	50                   	push   %eax
  100558:	e8 d2 fd ff ff       	call   10032f <cprintf>
  10055d:	83 c4 10             	add    $0x10,%esp
  100560:	eb 01                	jmp    100563 <__panic+0x6f>
        goto panic_dead;
  100562:	90                   	nop
    va_end(ap);

panic_dead:
    intr_disable();
  100563:	e8 e7 16 00 00       	call   101c4f <intr_disable>
    while (1) {
        kmonitor(NULL);
  100568:	83 ec 0c             	sub    $0xc,%esp
  10056b:	6a 00                	push   $0x0
  10056d:	e8 1b 09 00 00       	call   100e8d <kmonitor>
  100572:	83 c4 10             	add    $0x10,%esp
  100575:	eb f1                	jmp    100568 <__panic+0x74>

00100577 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100577:	f3 0f 1e fb          	endbr32 
  10057b:	55                   	push   %ebp
  10057c:	89 e5                	mov    %esp,%ebp
  10057e:	53                   	push   %ebx
  10057f:	83 ec 14             	sub    $0x14,%esp
  100582:	e8 2d fd ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100587:	81 c3 c9 03 01 00    	add    $0x103c9,%ebx
    va_list ap;
    va_start(ap, fmt);
  10058d:	8d 45 14             	lea    0x14(%ebp),%eax
  100590:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100593:	83 ec 04             	sub    $0x4,%esp
  100596:	ff 75 0c             	pushl  0xc(%ebp)
  100599:	ff 75 08             	pushl  0x8(%ebp)
  10059c:	8d 83 c8 33 ff ff    	lea    -0xcc38(%ebx),%eax
  1005a2:	50                   	push   %eax
  1005a3:	e8 87 fd ff ff       	call   10032f <cprintf>
  1005a8:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1005ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ae:	83 ec 08             	sub    $0x8,%esp
  1005b1:	50                   	push   %eax
  1005b2:	ff 75 10             	pushl  0x10(%ebp)
  1005b5:	e8 36 fd ff ff       	call   1002f0 <vcprintf>
  1005ba:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1005bd:	83 ec 0c             	sub    $0xc,%esp
  1005c0:	8d 83 c6 33 ff ff    	lea    -0xcc3a(%ebx),%eax
  1005c6:	50                   	push   %eax
  1005c7:	e8 63 fd ff ff       	call   10032f <cprintf>
  1005cc:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1005cf:	90                   	nop
  1005d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1005d3:	c9                   	leave  
  1005d4:	c3                   	ret    

001005d5 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1005d5:	f3 0f 1e fb          	endbr32 
  1005d9:	55                   	push   %ebp
  1005da:	89 e5                	mov    %esp,%ebp
  1005dc:	e8 cf fc ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1005e1:	05 6f 03 01 00       	add    $0x1036f,%eax
    return is_panic;
  1005e6:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
}
  1005ec:	5d                   	pop    %ebp
  1005ed:	c3                   	ret    

001005ee <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1005ee:	f3 0f 1e fb          	endbr32 
  1005f2:	55                   	push   %ebp
  1005f3:	89 e5                	mov    %esp,%ebp
  1005f5:	83 ec 20             	sub    $0x20,%esp
  1005f8:	e8 b3 fc ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1005fd:	05 53 03 01 00       	add    $0x10353,%eax
    int l = *region_left, r = *region_right, any_matches = 0;
  100602:	8b 45 0c             	mov    0xc(%ebp),%eax
  100605:	8b 00                	mov    (%eax),%eax
  100607:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10060a:	8b 45 10             	mov    0x10(%ebp),%eax
  10060d:	8b 00                	mov    (%eax),%eax
  10060f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100612:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100619:	e9 d2 00 00 00       	jmp    1006f0 <stab_binsearch+0x102>
        int true_m = (l + r) / 2, m = true_m;
  10061e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100621:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	89 c2                	mov    %eax,%edx
  100628:	c1 ea 1f             	shr    $0x1f,%edx
  10062b:	01 d0                	add    %edx,%eax
  10062d:	d1 f8                	sar    %eax
  10062f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100632:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100635:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100638:	eb 04                	jmp    10063e <stab_binsearch+0x50>
            m --;
  10063a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10063e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100641:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100644:	7c 1f                	jl     100665 <stab_binsearch+0x77>
  100646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100649:	89 d0                	mov    %edx,%eax
  10064b:	01 c0                	add    %eax,%eax
  10064d:	01 d0                	add    %edx,%eax
  10064f:	c1 e0 02             	shl    $0x2,%eax
  100652:	89 c2                	mov    %eax,%edx
  100654:	8b 45 08             	mov    0x8(%ebp),%eax
  100657:	01 d0                	add    %edx,%eax
  100659:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10065d:	0f b6 c0             	movzbl %al,%eax
  100660:	39 45 14             	cmp    %eax,0x14(%ebp)
  100663:	75 d5                	jne    10063a <stab_binsearch+0x4c>
        }
        if (m < l) {    // no match in [l, m]
  100665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100668:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10066b:	7d 0b                	jge    100678 <stab_binsearch+0x8a>
            l = true_m + 1;
  10066d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100670:	83 c0 01             	add    $0x1,%eax
  100673:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100676:	eb 78                	jmp    1006f0 <stab_binsearch+0x102>
        }

        // actual binary search
        any_matches = 1;
  100678:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10067f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100682:	89 d0                	mov    %edx,%eax
  100684:	01 c0                	add    %eax,%eax
  100686:	01 d0                	add    %edx,%eax
  100688:	c1 e0 02             	shl    $0x2,%eax
  10068b:	89 c2                	mov    %eax,%edx
  10068d:	8b 45 08             	mov    0x8(%ebp),%eax
  100690:	01 d0                	add    %edx,%eax
  100692:	8b 40 08             	mov    0x8(%eax),%eax
  100695:	39 45 18             	cmp    %eax,0x18(%ebp)
  100698:	76 13                	jbe    1006ad <stab_binsearch+0xbf>
            *region_left = m;
  10069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1006a0:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006a5:	83 c0 01             	add    $0x1,%eax
  1006a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1006ab:	eb 43                	jmp    1006f0 <stab_binsearch+0x102>
        } else if (stabs[m].n_value > addr) {
  1006ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1006b0:	89 d0                	mov    %edx,%eax
  1006b2:	01 c0                	add    %eax,%eax
  1006b4:	01 d0                	add    %edx,%eax
  1006b6:	c1 e0 02             	shl    $0x2,%eax
  1006b9:	89 c2                	mov    %eax,%edx
  1006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1006be:	01 d0                	add    %edx,%eax
  1006c0:	8b 40 08             	mov    0x8(%eax),%eax
  1006c3:	39 45 18             	cmp    %eax,0x18(%ebp)
  1006c6:	73 16                	jae    1006de <stab_binsearch+0xf0>
            *region_right = m - 1;
  1006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1006ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1006d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1006d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006d6:	83 e8 01             	sub    $0x1,%eax
  1006d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1006dc:	eb 12                	jmp    1006f0 <stab_binsearch+0x102>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1006e4:	89 10                	mov    %edx,(%eax)
            l = m;
  1006e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1006ec:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  1006f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1006f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1006f6:	0f 8e 22 ff ff ff    	jle    10061e <stab_binsearch+0x30>
        }
    }

    if (!any_matches) {
  1006fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100700:	75 0f                	jne    100711 <stab_binsearch+0x123>
        *region_right = *region_left - 1;
  100702:	8b 45 0c             	mov    0xc(%ebp),%eax
  100705:	8b 00                	mov    (%eax),%eax
  100707:	8d 50 ff             	lea    -0x1(%eax),%edx
  10070a:	8b 45 10             	mov    0x10(%ebp),%eax
  10070d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10070f:	eb 3f                	jmp    100750 <stab_binsearch+0x162>
        l = *region_right;
  100711:	8b 45 10             	mov    0x10(%ebp),%eax
  100714:	8b 00                	mov    (%eax),%eax
  100716:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100719:	eb 04                	jmp    10071f <stab_binsearch+0x131>
  10071b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10071f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100722:	8b 00                	mov    (%eax),%eax
  100724:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100727:	7e 1f                	jle    100748 <stab_binsearch+0x15a>
  100729:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10072c:	89 d0                	mov    %edx,%eax
  10072e:	01 c0                	add    %eax,%eax
  100730:	01 d0                	add    %edx,%eax
  100732:	c1 e0 02             	shl    $0x2,%eax
  100735:	89 c2                	mov    %eax,%edx
  100737:	8b 45 08             	mov    0x8(%ebp),%eax
  10073a:	01 d0                	add    %edx,%eax
  10073c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100740:	0f b6 c0             	movzbl %al,%eax
  100743:	39 45 14             	cmp    %eax,0x14(%ebp)
  100746:	75 d3                	jne    10071b <stab_binsearch+0x12d>
        *region_left = l;
  100748:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10074e:	89 10                	mov    %edx,(%eax)
}
  100750:	90                   	nop
  100751:	c9                   	leave  
  100752:	c3                   	ret    

00100753 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100753:	f3 0f 1e fb          	endbr32 
  100757:	55                   	push   %ebp
  100758:	89 e5                	mov    %esp,%ebp
  10075a:	53                   	push   %ebx
  10075b:	83 ec 34             	sub    $0x34,%esp
  10075e:	e8 51 fb ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100763:	81 c3 ed 01 01 00    	add    $0x101ed,%ebx
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100769:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076c:	8d 93 e8 33 ff ff    	lea    -0xcc18(%ebx),%edx
  100772:	89 10                	mov    %edx,(%eax)
    info->eip_line = 0;
  100774:	8b 45 0c             	mov    0xc(%ebp),%eax
  100777:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100781:	8d 93 e8 33 ff ff    	lea    -0xcc18(%ebx),%edx
  100787:	89 50 08             	mov    %edx,0x8(%eax)
    info->eip_fn_namelen = 9;
  10078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100794:	8b 45 0c             	mov    0xc(%ebp),%eax
  100797:	8b 55 08             	mov    0x8(%ebp),%edx
  10079a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10079d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1007a7:	c7 c0 bc 44 10 00    	mov    $0x1044bc,%eax
  1007ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    stab_end = __STAB_END__;
  1007b0:	c7 c0 3c d3 10 00    	mov    $0x10d33c,%eax
  1007b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1007b9:	c7 c0 3d d3 10 00    	mov    $0x10d33d,%eax
  1007bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1007c2:	c7 c0 4b f4 10 00    	mov    $0x10f44b,%eax
  1007c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1007cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1007d1:	76 0d                	jbe    1007e0 <debuginfo_eip+0x8d>
  1007d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007d6:	83 e8 01             	sub    $0x1,%eax
  1007d9:	0f b6 00             	movzbl (%eax),%eax
  1007dc:	84 c0                	test   %al,%al
  1007de:	74 0a                	je     1007ea <debuginfo_eip+0x97>
        return -1;
  1007e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007e5:	e9 85 02 00 00       	jmp    100a6f <debuginfo_eip+0x31c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1007ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1007f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1007f4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1007f7:	c1 f8 02             	sar    $0x2,%eax
  1007fa:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100800:	83 e8 01             	sub    $0x1,%eax
  100803:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100806:	ff 75 08             	pushl  0x8(%ebp)
  100809:	6a 64                	push   $0x64
  10080b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10080e:	50                   	push   %eax
  10080f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100812:	50                   	push   %eax
  100813:	ff 75 f4             	pushl  -0xc(%ebp)
  100816:	e8 d3 fd ff ff       	call   1005ee <stab_binsearch>
  10081b:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10081e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100821:	85 c0                	test   %eax,%eax
  100823:	75 0a                	jne    10082f <debuginfo_eip+0xdc>
        return -1;
  100825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10082a:	e9 40 02 00 00       	jmp    100a6f <debuginfo_eip+0x31c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100832:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100838:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10083b:	ff 75 08             	pushl  0x8(%ebp)
  10083e:	6a 24                	push   $0x24
  100840:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100843:	50                   	push   %eax
  100844:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100847:	50                   	push   %eax
  100848:	ff 75 f4             	pushl  -0xc(%ebp)
  10084b:	e8 9e fd ff ff       	call   1005ee <stab_binsearch>
  100850:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  100853:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100856:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100859:	39 c2                	cmp    %eax,%edx
  10085b:	7f 78                	jg     1008d5 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10085d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100860:	89 c2                	mov    %eax,%edx
  100862:	89 d0                	mov    %edx,%eax
  100864:	01 c0                	add    %eax,%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	c1 e0 02             	shl    $0x2,%eax
  10086b:	89 c2                	mov    %eax,%edx
  10086d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100870:	01 d0                	add    %edx,%eax
  100872:	8b 10                	mov    (%eax),%edx
  100874:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100877:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10087a:	39 c2                	cmp    %eax,%edx
  10087c:	73 22                	jae    1008a0 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10087e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100881:	89 c2                	mov    %eax,%edx
  100883:	89 d0                	mov    %edx,%eax
  100885:	01 c0                	add    %eax,%eax
  100887:	01 d0                	add    %edx,%eax
  100889:	c1 e0 02             	shl    $0x2,%eax
  10088c:	89 c2                	mov    %eax,%edx
  10088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100891:	01 d0                	add    %edx,%eax
  100893:	8b 10                	mov    (%eax),%edx
  100895:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100898:	01 c2                	add    %eax,%edx
  10089a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10089d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008a3:	89 c2                	mov    %eax,%edx
  1008a5:	89 d0                	mov    %edx,%eax
  1008a7:	01 c0                	add    %eax,%eax
  1008a9:	01 d0                	add    %edx,%eax
  1008ab:	c1 e0 02             	shl    $0x2,%eax
  1008ae:	89 c2                	mov    %eax,%edx
  1008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008b3:	01 d0                	add    %edx,%eax
  1008b5:	8b 50 08             	mov    0x8(%eax),%edx
  1008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008bb:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008c1:	8b 40 10             	mov    0x10(%eax),%eax
  1008c4:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1008c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1008cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1008d3:	eb 15                	jmp    1008ea <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1008d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d8:	8b 55 08             	mov    0x8(%ebp),%edx
  1008db:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1008de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1008e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1008e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ed:	8b 40 08             	mov    0x8(%eax),%eax
  1008f0:	83 ec 08             	sub    $0x8,%esp
  1008f3:	6a 3a                	push   $0x3a
  1008f5:	50                   	push   %eax
  1008f6:	e8 54 29 00 00       	call   10324f <strfind>
  1008fb:	83 c4 10             	add    $0x10,%esp
  1008fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  100901:	8b 52 08             	mov    0x8(%edx),%edx
  100904:	29 d0                	sub    %edx,%eax
  100906:	89 c2                	mov    %eax,%edx
  100908:	8b 45 0c             	mov    0xc(%ebp),%eax
  10090b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10090e:	83 ec 0c             	sub    $0xc,%esp
  100911:	ff 75 08             	pushl  0x8(%ebp)
  100914:	6a 44                	push   $0x44
  100916:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100919:	50                   	push   %eax
  10091a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10091d:	50                   	push   %eax
  10091e:	ff 75 f4             	pushl  -0xc(%ebp)
  100921:	e8 c8 fc ff ff       	call   1005ee <stab_binsearch>
  100926:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10092c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10092f:	39 c2                	cmp    %eax,%edx
  100931:	7f 24                	jg     100957 <debuginfo_eip+0x204>
        info->eip_line = stabs[rline].n_desc;
  100933:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100936:	89 c2                	mov    %eax,%edx
  100938:	89 d0                	mov    %edx,%eax
  10093a:	01 c0                	add    %eax,%eax
  10093c:	01 d0                	add    %edx,%eax
  10093e:	c1 e0 02             	shl    $0x2,%eax
  100941:	89 c2                	mov    %eax,%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10094c:	0f b7 d0             	movzwl %ax,%edx
  10094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100952:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100955:	eb 13                	jmp    10096a <debuginfo_eip+0x217>
        return -1;
  100957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10095c:	e9 0e 01 00 00       	jmp    100a6f <debuginfo_eip+0x31c>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100961:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100964:	83 e8 01             	sub    $0x1,%eax
  100967:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10096a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10096d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100970:	39 c2                	cmp    %eax,%edx
  100972:	7c 56                	jl     1009ca <debuginfo_eip+0x277>
           && stabs[lline].n_type != N_SOL
  100974:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100977:	89 c2                	mov    %eax,%edx
  100979:	89 d0                	mov    %edx,%eax
  10097b:	01 c0                	add    %eax,%eax
  10097d:	01 d0                	add    %edx,%eax
  10097f:	c1 e0 02             	shl    $0x2,%eax
  100982:	89 c2                	mov    %eax,%edx
  100984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100987:	01 d0                	add    %edx,%eax
  100989:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10098d:	3c 84                	cmp    $0x84,%al
  10098f:	74 39                	je     1009ca <debuginfo_eip+0x277>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100991:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100994:	89 c2                	mov    %eax,%edx
  100996:	89 d0                	mov    %edx,%eax
  100998:	01 c0                	add    %eax,%eax
  10099a:	01 d0                	add    %edx,%eax
  10099c:	c1 e0 02             	shl    $0x2,%eax
  10099f:	89 c2                	mov    %eax,%edx
  1009a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009a4:	01 d0                	add    %edx,%eax
  1009a6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1009aa:	3c 64                	cmp    $0x64,%al
  1009ac:	75 b3                	jne    100961 <debuginfo_eip+0x20e>
  1009ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009b1:	89 c2                	mov    %eax,%edx
  1009b3:	89 d0                	mov    %edx,%eax
  1009b5:	01 c0                	add    %eax,%eax
  1009b7:	01 d0                	add    %edx,%eax
  1009b9:	c1 e0 02             	shl    $0x2,%eax
  1009bc:	89 c2                	mov    %eax,%edx
  1009be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c1:	01 d0                	add    %edx,%eax
  1009c3:	8b 40 08             	mov    0x8(%eax),%eax
  1009c6:	85 c0                	test   %eax,%eax
  1009c8:	74 97                	je     100961 <debuginfo_eip+0x20e>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1009ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1009cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009d0:	39 c2                	cmp    %eax,%edx
  1009d2:	7c 42                	jl     100a16 <debuginfo_eip+0x2c3>
  1009d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009d7:	89 c2                	mov    %eax,%edx
  1009d9:	89 d0                	mov    %edx,%eax
  1009db:	01 c0                	add    %eax,%eax
  1009dd:	01 d0                	add    %edx,%eax
  1009df:	c1 e0 02             	shl    $0x2,%eax
  1009e2:	89 c2                	mov    %eax,%edx
  1009e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e7:	01 d0                	add    %edx,%eax
  1009e9:	8b 10                	mov    (%eax),%edx
  1009eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ee:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1009f1:	39 c2                	cmp    %eax,%edx
  1009f3:	73 21                	jae    100a16 <debuginfo_eip+0x2c3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1009f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009f8:	89 c2                	mov    %eax,%edx
  1009fa:	89 d0                	mov    %edx,%eax
  1009fc:	01 c0                	add    %eax,%eax
  1009fe:	01 d0                	add    %edx,%eax
  100a00:	c1 e0 02             	shl    $0x2,%eax
  100a03:	89 c2                	mov    %eax,%edx
  100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a08:	01 d0                	add    %edx,%eax
  100a0a:	8b 10                	mov    (%eax),%edx
  100a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a0f:	01 c2                	add    %eax,%edx
  100a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a14:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100a16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100a1c:	39 c2                	cmp    %eax,%edx
  100a1e:	7d 4a                	jge    100a6a <debuginfo_eip+0x317>
        for (lline = lfun + 1;
  100a20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a23:	83 c0 01             	add    $0x1,%eax
  100a26:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100a29:	eb 18                	jmp    100a43 <debuginfo_eip+0x2f0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a2e:	8b 40 14             	mov    0x14(%eax),%eax
  100a31:	8d 50 01             	lea    0x1(%eax),%edx
  100a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a37:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100a3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a3d:	83 c0 01             	add    $0x1,%eax
  100a40:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100a43:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100a46:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100a49:	39 c2                	cmp    %eax,%edx
  100a4b:	7d 1d                	jge    100a6a <debuginfo_eip+0x317>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100a4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a50:	89 c2                	mov    %eax,%edx
  100a52:	89 d0                	mov    %edx,%eax
  100a54:	01 c0                	add    %eax,%eax
  100a56:	01 d0                	add    %edx,%eax
  100a58:	c1 e0 02             	shl    $0x2,%eax
  100a5b:	89 c2                	mov    %eax,%edx
  100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a60:	01 d0                	add    %edx,%eax
  100a62:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100a66:	3c a0                	cmp    $0xa0,%al
  100a68:	74 c1                	je     100a2b <debuginfo_eip+0x2d8>
        }
    }
    return 0;
  100a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100a6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a72:	c9                   	leave  
  100a73:	c3                   	ret    

00100a74 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100a74:	f3 0f 1e fb          	endbr32 
  100a78:	55                   	push   %ebp
  100a79:	89 e5                	mov    %esp,%ebp
  100a7b:	53                   	push   %ebx
  100a7c:	83 ec 04             	sub    $0x4,%esp
  100a7f:	e8 30 f8 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100a84:	81 c3 cc fe 00 00    	add    $0xfecc,%ebx
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100a8a:	83 ec 0c             	sub    $0xc,%esp
  100a8d:	8d 83 f2 33 ff ff    	lea    -0xcc0e(%ebx),%eax
  100a93:	50                   	push   %eax
  100a94:	e8 96 f8 ff ff       	call   10032f <cprintf>
  100a99:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100a9c:	83 ec 08             	sub    $0x8,%esp
  100a9f:	c7 c0 00 00 10 00    	mov    $0x100000,%eax
  100aa5:	50                   	push   %eax
  100aa6:	8d 83 0b 34 ff ff    	lea    -0xcbf5(%ebx),%eax
  100aac:	50                   	push   %eax
  100aad:	e8 7d f8 ff ff       	call   10032f <cprintf>
  100ab2:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100ab5:	83 ec 08             	sub    $0x8,%esp
  100ab8:	c7 c0 4d 3c 10 00    	mov    $0x103c4d,%eax
  100abe:	50                   	push   %eax
  100abf:	8d 83 23 34 ff ff    	lea    -0xcbdd(%ebx),%eax
  100ac5:	50                   	push   %eax
  100ac6:	e8 64 f8 ff ff       	call   10032f <cprintf>
  100acb:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100ace:	83 ec 08             	sub    $0x8,%esp
  100ad1:	c7 c0 50 09 11 00    	mov    $0x110950,%eax
  100ad7:	50                   	push   %eax
  100ad8:	8d 83 3b 34 ff ff    	lea    -0xcbc5(%ebx),%eax
  100ade:	50                   	push   %eax
  100adf:	e8 4b f8 ff ff       	call   10032f <cprintf>
  100ae4:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100ae7:	83 ec 08             	sub    $0x8,%esp
  100aea:	c7 c0 20 1e 11 00    	mov    $0x111e20,%eax
  100af0:	50                   	push   %eax
  100af1:	8d 83 53 34 ff ff    	lea    -0xcbad(%ebx),%eax
  100af7:	50                   	push   %eax
  100af8:	e8 32 f8 ff ff       	call   10032f <cprintf>
  100afd:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100b00:	c7 c0 20 1e 11 00    	mov    $0x111e20,%eax
  100b06:	89 c2                	mov    %eax,%edx
  100b08:	c7 c0 00 00 10 00    	mov    $0x100000,%eax
  100b0e:	29 c2                	sub    %eax,%edx
  100b10:	89 d0                	mov    %edx,%eax
  100b12:	05 ff 03 00 00       	add    $0x3ff,%eax
  100b17:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100b1d:	85 c0                	test   %eax,%eax
  100b1f:	0f 48 c2             	cmovs  %edx,%eax
  100b22:	c1 f8 0a             	sar    $0xa,%eax
  100b25:	83 ec 08             	sub    $0x8,%esp
  100b28:	50                   	push   %eax
  100b29:	8d 83 6c 34 ff ff    	lea    -0xcb94(%ebx),%eax
  100b2f:	50                   	push   %eax
  100b30:	e8 fa f7 ff ff       	call   10032f <cprintf>
  100b35:	83 c4 10             	add    $0x10,%esp
}
  100b38:	90                   	nop
  100b39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100b3c:	c9                   	leave  
  100b3d:	c3                   	ret    

00100b3e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100b3e:	f3 0f 1e fb          	endbr32 
  100b42:	55                   	push   %ebp
  100b43:	89 e5                	mov    %esp,%ebp
  100b45:	53                   	push   %ebx
  100b46:	81 ec 24 01 00 00    	sub    $0x124,%esp
  100b4c:	e8 63 f7 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100b51:	81 c3 ff fd 00 00    	add    $0xfdff,%ebx
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100b57:	83 ec 08             	sub    $0x8,%esp
  100b5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100b5d:	50                   	push   %eax
  100b5e:	ff 75 08             	pushl  0x8(%ebp)
  100b61:	e8 ed fb ff ff       	call   100753 <debuginfo_eip>
  100b66:	83 c4 10             	add    $0x10,%esp
  100b69:	85 c0                	test   %eax,%eax
  100b6b:	74 17                	je     100b84 <print_debuginfo+0x46>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100b6d:	83 ec 08             	sub    $0x8,%esp
  100b70:	ff 75 08             	pushl  0x8(%ebp)
  100b73:	8d 83 96 34 ff ff    	lea    -0xcb6a(%ebx),%eax
  100b79:	50                   	push   %eax
  100b7a:	e8 b0 f7 ff ff       	call   10032f <cprintf>
  100b7f:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100b82:	eb 67                	jmp    100beb <print_debuginfo+0xad>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b8b:	eb 1c                	jmp    100ba9 <print_debuginfo+0x6b>
            fnname[j] = info.eip_fn_name[j];
  100b8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b93:	01 d0                	add    %edx,%eax
  100b95:	0f b6 00             	movzbl (%eax),%eax
  100b98:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ba1:	01 ca                	add    %ecx,%edx
  100ba3:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100ba5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100bac:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100baf:	7c dc                	jl     100b8d <print_debuginfo+0x4f>
        fnname[j] = '\0';
  100bb1:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bba:	01 d0                	add    %edx,%eax
  100bbc:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  100bc5:	89 d1                	mov    %edx,%ecx
  100bc7:	29 c1                	sub    %eax,%ecx
  100bc9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100bcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100bcf:	83 ec 0c             	sub    $0xc,%esp
  100bd2:	51                   	push   %ecx
  100bd3:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100bd9:	51                   	push   %ecx
  100bda:	52                   	push   %edx
  100bdb:	50                   	push   %eax
  100bdc:	8d 83 b2 34 ff ff    	lea    -0xcb4e(%ebx),%eax
  100be2:	50                   	push   %eax
  100be3:	e8 47 f7 ff ff       	call   10032f <cprintf>
  100be8:	83 c4 20             	add    $0x20,%esp
}
  100beb:	90                   	nop
  100bec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bef:	c9                   	leave  
  100bf0:	c3                   	ret    

00100bf1 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100bf1:	f3 0f 1e fb          	endbr32 
  100bf5:	55                   	push   %ebp
  100bf6:	89 e5                	mov    %esp,%ebp
  100bf8:	83 ec 10             	sub    $0x10,%esp
  100bfb:	e8 b0 f6 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  100c00:	05 50 fd 00 00       	add    $0xfd50,%eax
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100c05:	8b 45 04             	mov    0x4(%ebp),%eax
  100c08:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100c0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100c0e:	c9                   	leave  
  100c0f:	c3                   	ret    

00100c10 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100c10:	f3 0f 1e fb          	endbr32 
  100c14:	55                   	push   %ebp
  100c15:	89 e5                	mov    %esp,%ebp
  100c17:	53                   	push   %ebx
  100c18:	83 ec 24             	sub    $0x24,%esp
  100c1b:	e8 94 f6 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100c20:	81 c3 30 fd 00 00    	add    $0xfd30,%ebx
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100c26:	89 e8                	mov    %ebp,%eax
  100c28:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100c2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c31:	e8 bb ff ff ff       	call   100bf1 <read_eip>
  100c36:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100c39:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100c40:	e9 93 00 00 00       	jmp    100cd8 <print_stackframe+0xc8>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100c45:	83 ec 04             	sub    $0x4,%esp
  100c48:	ff 75 f0             	pushl  -0x10(%ebp)
  100c4b:	ff 75 f4             	pushl  -0xc(%ebp)
  100c4e:	8d 83 c4 34 ff ff    	lea    -0xcb3c(%ebx),%eax
  100c54:	50                   	push   %eax
  100c55:	e8 d5 f6 ff ff       	call   10032f <cprintf>
  100c5a:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  100c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c60:	83 c0 08             	add    $0x8,%eax
  100c63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100c66:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100c6d:	eb 28                	jmp    100c97 <print_stackframe+0x87>
            cprintf("0x%08x ", args[j]);
  100c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100c72:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100c7c:	01 d0                	add    %edx,%eax
  100c7e:	8b 00                	mov    (%eax),%eax
  100c80:	83 ec 08             	sub    $0x8,%esp
  100c83:	50                   	push   %eax
  100c84:	8d 83 e0 34 ff ff    	lea    -0xcb20(%ebx),%eax
  100c8a:	50                   	push   %eax
  100c8b:	e8 9f f6 ff ff       	call   10032f <cprintf>
  100c90:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
  100c93:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100c97:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100c9b:	7e d2                	jle    100c6f <print_stackframe+0x5f>
        }
        cprintf("\n");
  100c9d:	83 ec 0c             	sub    $0xc,%esp
  100ca0:	8d 83 e8 34 ff ff    	lea    -0xcb18(%ebx),%eax
  100ca6:	50                   	push   %eax
  100ca7:	e8 83 f6 ff ff       	call   10032f <cprintf>
  100cac:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  100caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100cb2:	83 e8 01             	sub    $0x1,%eax
  100cb5:	83 ec 0c             	sub    $0xc,%esp
  100cb8:	50                   	push   %eax
  100cb9:	e8 80 fe ff ff       	call   100b3e <print_debuginfo>
  100cbe:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  100cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cc4:	83 c0 04             	add    $0x4,%eax
  100cc7:	8b 00                	mov    (%eax),%eax
  100cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ccf:	8b 00                	mov    (%eax),%eax
  100cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100cd4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100cd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cdc:	74 0a                	je     100ce8 <print_stackframe+0xd8>
  100cde:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100ce2:	0f 8e 5d ff ff ff    	jle    100c45 <print_stackframe+0x35>
    }
}
  100ce8:	90                   	nop
  100ce9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100cec:	c9                   	leave  
  100ced:	c3                   	ret    

00100cee <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100cee:	f3 0f 1e fb          	endbr32 
  100cf2:	55                   	push   %ebp
  100cf3:	89 e5                	mov    %esp,%ebp
  100cf5:	53                   	push   %ebx
  100cf6:	83 ec 14             	sub    $0x14,%esp
  100cf9:	e8 b6 f5 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100cfe:	81 c3 52 fc 00 00    	add    $0xfc52,%ebx
    int argc = 0;
  100d04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100d0b:	eb 0c                	jmp    100d19 <parse+0x2b>
            *buf ++ = '\0';
  100d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d10:	8d 50 01             	lea    0x1(%eax),%edx
  100d13:	89 55 08             	mov    %edx,0x8(%ebp)
  100d16:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100d19:	8b 45 08             	mov    0x8(%ebp),%eax
  100d1c:	0f b6 00             	movzbl (%eax),%eax
  100d1f:	84 c0                	test   %al,%al
  100d21:	74 20                	je     100d43 <parse+0x55>
  100d23:	8b 45 08             	mov    0x8(%ebp),%eax
  100d26:	0f b6 00             	movzbl (%eax),%eax
  100d29:	0f be c0             	movsbl %al,%eax
  100d2c:	83 ec 08             	sub    $0x8,%esp
  100d2f:	50                   	push   %eax
  100d30:	8d 83 6c 35 ff ff    	lea    -0xca94(%ebx),%eax
  100d36:	50                   	push   %eax
  100d37:	e8 d2 24 00 00       	call   10320e <strchr>
  100d3c:	83 c4 10             	add    $0x10,%esp
  100d3f:	85 c0                	test   %eax,%eax
  100d41:	75 ca                	jne    100d0d <parse+0x1f>
        }
        if (*buf == '\0') {
  100d43:	8b 45 08             	mov    0x8(%ebp),%eax
  100d46:	0f b6 00             	movzbl (%eax),%eax
  100d49:	84 c0                	test   %al,%al
  100d4b:	74 69                	je     100db6 <parse+0xc8>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100d4d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100d51:	75 14                	jne    100d67 <parse+0x79>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100d53:	83 ec 08             	sub    $0x8,%esp
  100d56:	6a 10                	push   $0x10
  100d58:	8d 83 71 35 ff ff    	lea    -0xca8f(%ebx),%eax
  100d5e:	50                   	push   %eax
  100d5f:	e8 cb f5 ff ff       	call   10032f <cprintf>
  100d64:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d6a:	8d 50 01             	lea    0x1(%eax),%edx
  100d6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100d70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d7a:	01 c2                	add    %eax,%edx
  100d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d7f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100d81:	eb 04                	jmp    100d87 <parse+0x99>
            buf ++;
  100d83:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100d87:	8b 45 08             	mov    0x8(%ebp),%eax
  100d8a:	0f b6 00             	movzbl (%eax),%eax
  100d8d:	84 c0                	test   %al,%al
  100d8f:	74 88                	je     100d19 <parse+0x2b>
  100d91:	8b 45 08             	mov    0x8(%ebp),%eax
  100d94:	0f b6 00             	movzbl (%eax),%eax
  100d97:	0f be c0             	movsbl %al,%eax
  100d9a:	83 ec 08             	sub    $0x8,%esp
  100d9d:	50                   	push   %eax
  100d9e:	8d 83 6c 35 ff ff    	lea    -0xca94(%ebx),%eax
  100da4:	50                   	push   %eax
  100da5:	e8 64 24 00 00       	call   10320e <strchr>
  100daa:	83 c4 10             	add    $0x10,%esp
  100dad:	85 c0                	test   %eax,%eax
  100daf:	74 d2                	je     100d83 <parse+0x95>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100db1:	e9 63 ff ff ff       	jmp    100d19 <parse+0x2b>
            break;
  100db6:	90                   	nop
        }
    }
    return argc;
  100db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100dbd:	c9                   	leave  
  100dbe:	c3                   	ret    

00100dbf <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100dbf:	f3 0f 1e fb          	endbr32 
  100dc3:	55                   	push   %ebp
  100dc4:	89 e5                	mov    %esp,%ebp
  100dc6:	56                   	push   %esi
  100dc7:	53                   	push   %ebx
  100dc8:	83 ec 50             	sub    $0x50,%esp
  100dcb:	e8 e4 f4 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100dd0:	81 c3 80 fb 00 00    	add    $0xfb80,%ebx
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100dd6:	83 ec 08             	sub    $0x8,%esp
  100dd9:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ddc:	50                   	push   %eax
  100ddd:	ff 75 08             	pushl  0x8(%ebp)
  100de0:	e8 09 ff ff ff       	call   100cee <parse>
  100de5:	83 c4 10             	add    $0x10,%esp
  100de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100deb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100def:	75 0a                	jne    100dfb <runcmd+0x3c>
        return 0;
  100df1:	b8 00 00 00 00       	mov    $0x0,%eax
  100df6:	e9 8b 00 00 00       	jmp    100e86 <runcmd+0xc7>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100dfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100e02:	eb 5f                	jmp    100e63 <runcmd+0xa4>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100e04:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100e0a:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
  100e10:	89 d0                	mov    %edx,%eax
  100e12:	01 c0                	add    %eax,%eax
  100e14:	01 d0                	add    %edx,%eax
  100e16:	c1 e0 02             	shl    $0x2,%eax
  100e19:	01 f0                	add    %esi,%eax
  100e1b:	8b 00                	mov    (%eax),%eax
  100e1d:	83 ec 08             	sub    $0x8,%esp
  100e20:	51                   	push   %ecx
  100e21:	50                   	push   %eax
  100e22:	e8 2c 23 00 00       	call   103153 <strcmp>
  100e27:	83 c4 10             	add    $0x10,%esp
  100e2a:	85 c0                	test   %eax,%eax
  100e2c:	75 31                	jne    100e5f <runcmd+0xa0>
            return commands[i].func(argc - 1, argv + 1, tf);
  100e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100e31:	8d 8b 18 00 00 00    	lea    0x18(%ebx),%ecx
  100e37:	89 d0                	mov    %edx,%eax
  100e39:	01 c0                	add    %eax,%eax
  100e3b:	01 d0                	add    %edx,%eax
  100e3d:	c1 e0 02             	shl    $0x2,%eax
  100e40:	01 c8                	add    %ecx,%eax
  100e42:	8b 10                	mov    (%eax),%edx
  100e44:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100e47:	83 c0 04             	add    $0x4,%eax
  100e4a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100e4d:	83 e9 01             	sub    $0x1,%ecx
  100e50:	83 ec 04             	sub    $0x4,%esp
  100e53:	ff 75 0c             	pushl  0xc(%ebp)
  100e56:	50                   	push   %eax
  100e57:	51                   	push   %ecx
  100e58:	ff d2                	call   *%edx
  100e5a:	83 c4 10             	add    $0x10,%esp
  100e5d:	eb 27                	jmp    100e86 <runcmd+0xc7>
    for (i = 0; i < NCOMMANDS; i ++) {
  100e5f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e66:	83 f8 02             	cmp    $0x2,%eax
  100e69:	76 99                	jbe    100e04 <runcmd+0x45>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100e6b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100e6e:	83 ec 08             	sub    $0x8,%esp
  100e71:	50                   	push   %eax
  100e72:	8d 83 8f 35 ff ff    	lea    -0xca71(%ebx),%eax
  100e78:	50                   	push   %eax
  100e79:	e8 b1 f4 ff ff       	call   10032f <cprintf>
  100e7e:	83 c4 10             	add    $0x10,%esp
    return 0;
  100e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100e89:	5b                   	pop    %ebx
  100e8a:	5e                   	pop    %esi
  100e8b:	5d                   	pop    %ebp
  100e8c:	c3                   	ret    

00100e8d <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100e8d:	f3 0f 1e fb          	endbr32 
  100e91:	55                   	push   %ebp
  100e92:	89 e5                	mov    %esp,%ebp
  100e94:	53                   	push   %ebx
  100e95:	83 ec 14             	sub    $0x14,%esp
  100e98:	e8 17 f4 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100e9d:	81 c3 b3 fa 00 00    	add    $0xfab3,%ebx
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ea3:	83 ec 0c             	sub    $0xc,%esp
  100ea6:	8d 83 a8 35 ff ff    	lea    -0xca58(%ebx),%eax
  100eac:	50                   	push   %eax
  100ead:	e8 7d f4 ff ff       	call   10032f <cprintf>
  100eb2:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100eb5:	83 ec 0c             	sub    $0xc,%esp
  100eb8:	8d 83 d0 35 ff ff    	lea    -0xca30(%ebx),%eax
  100ebe:	50                   	push   %eax
  100ebf:	e8 6b f4 ff ff       	call   10032f <cprintf>
  100ec4:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100ec7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ecb:	74 0e                	je     100edb <kmonitor+0x4e>
        print_trapframe(tf);
  100ecd:	83 ec 0c             	sub    $0xc,%esp
  100ed0:	ff 75 08             	pushl  0x8(%ebp)
  100ed3:	e8 c1 0f 00 00       	call   101e99 <print_trapframe>
  100ed8:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100edb:	83 ec 0c             	sub    $0xc,%esp
  100ede:	8d 83 f5 35 ff ff    	lea    -0xca0b(%ebx),%eax
  100ee4:	50                   	push   %eax
  100ee5:	e8 2e f5 ff ff       	call   100418 <readline>
  100eea:	83 c4 10             	add    $0x10,%esp
  100eed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ef0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ef4:	74 e5                	je     100edb <kmonitor+0x4e>
            if (runcmd(buf, tf) < 0) {
  100ef6:	83 ec 08             	sub    $0x8,%esp
  100ef9:	ff 75 08             	pushl  0x8(%ebp)
  100efc:	ff 75 f4             	pushl  -0xc(%ebp)
  100eff:	e8 bb fe ff ff       	call   100dbf <runcmd>
  100f04:	83 c4 10             	add    $0x10,%esp
  100f07:	85 c0                	test   %eax,%eax
  100f09:	78 02                	js     100f0d <kmonitor+0x80>
        if ((buf = readline("K> ")) != NULL) {
  100f0b:	eb ce                	jmp    100edb <kmonitor+0x4e>
                break;
  100f0d:	90                   	nop
            }
        }
    }
}
  100f0e:	90                   	nop
  100f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100f12:	c9                   	leave  
  100f13:	c3                   	ret    

00100f14 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100f14:	f3 0f 1e fb          	endbr32 
  100f18:	55                   	push   %ebp
  100f19:	89 e5                	mov    %esp,%ebp
  100f1b:	56                   	push   %esi
  100f1c:	53                   	push   %ebx
  100f1d:	83 ec 10             	sub    $0x10,%esp
  100f20:	e8 8f f3 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100f25:	81 c3 2b fa 00 00    	add    $0xfa2b,%ebx
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100f2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100f32:	eb 44                	jmp    100f78 <mon_help+0x64>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100f37:	8d 8b 14 00 00 00    	lea    0x14(%ebx),%ecx
  100f3d:	89 d0                	mov    %edx,%eax
  100f3f:	01 c0                	add    %eax,%eax
  100f41:	01 d0                	add    %edx,%eax
  100f43:	c1 e0 02             	shl    $0x2,%eax
  100f46:	01 c8                	add    %ecx,%eax
  100f48:	8b 08                	mov    (%eax),%ecx
  100f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100f4d:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
  100f53:	89 d0                	mov    %edx,%eax
  100f55:	01 c0                	add    %eax,%eax
  100f57:	01 d0                	add    %edx,%eax
  100f59:	c1 e0 02             	shl    $0x2,%eax
  100f5c:	01 f0                	add    %esi,%eax
  100f5e:	8b 00                	mov    (%eax),%eax
  100f60:	83 ec 04             	sub    $0x4,%esp
  100f63:	51                   	push   %ecx
  100f64:	50                   	push   %eax
  100f65:	8d 83 f9 35 ff ff    	lea    -0xca07(%ebx),%eax
  100f6b:	50                   	push   %eax
  100f6c:	e8 be f3 ff ff       	call   10032f <cprintf>
  100f71:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100f74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f7b:	83 f8 02             	cmp    $0x2,%eax
  100f7e:	76 b4                	jbe    100f34 <mon_help+0x20>
    }
    return 0;
  100f80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100f88:	5b                   	pop    %ebx
  100f89:	5e                   	pop    %esi
  100f8a:	5d                   	pop    %ebp
  100f8b:	c3                   	ret    

00100f8c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100f8c:	f3 0f 1e fb          	endbr32 
  100f90:	55                   	push   %ebp
  100f91:	89 e5                	mov    %esp,%ebp
  100f93:	53                   	push   %ebx
  100f94:	83 ec 04             	sub    $0x4,%esp
  100f97:	e8 14 f3 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  100f9c:	05 b4 f9 00 00       	add    $0xf9b4,%eax
    print_kerninfo();
  100fa1:	89 c3                	mov    %eax,%ebx
  100fa3:	e8 cc fa ff ff       	call   100a74 <print_kerninfo>
    return 0;
  100fa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100fad:	83 c4 04             	add    $0x4,%esp
  100fb0:	5b                   	pop    %ebx
  100fb1:	5d                   	pop    %ebp
  100fb2:	c3                   	ret    

00100fb3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100fb3:	f3 0f 1e fb          	endbr32 
  100fb7:	55                   	push   %ebp
  100fb8:	89 e5                	mov    %esp,%ebp
  100fba:	53                   	push   %ebx
  100fbb:	83 ec 04             	sub    $0x4,%esp
  100fbe:	e8 ed f2 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  100fc3:	05 8d f9 00 00       	add    $0xf98d,%eax
    print_stackframe();
  100fc8:	89 c3                	mov    %eax,%ebx
  100fca:	e8 41 fc ff ff       	call   100c10 <print_stackframe>
    return 0;
  100fcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100fd4:	83 c4 04             	add    $0x4,%esp
  100fd7:	5b                   	pop    %ebx
  100fd8:	5d                   	pop    %ebp
  100fd9:	c3                   	ret    

00100fda <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100fda:	f3 0f 1e fb          	endbr32 
  100fde:	55                   	push   %ebp
  100fdf:	89 e5                	mov    %esp,%ebp
  100fe1:	53                   	push   %ebx
  100fe2:	83 ec 14             	sub    $0x14,%esp
  100fe5:	e8 ca f2 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  100fea:	81 c3 66 f9 00 00    	add    $0xf966,%ebx
  100ff0:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100ff6:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ffa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ffe:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101002:	ee                   	out    %al,(%dx)
}
  101003:	90                   	nop
  101004:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  10100a:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10100e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101012:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101016:	ee                   	out    %al,(%dx)
}
  101017:	90                   	nop
  101018:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  10101e:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101022:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101026:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10102a:	ee                   	out    %al,(%dx)
}
  10102b:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  10102c:	c7 c0 a8 19 11 00    	mov    $0x1119a8,%eax
  101032:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("++ setup timer interrupts\n");
  101038:	83 ec 0c             	sub    $0xc,%esp
  10103b:	8d 83 02 36 ff ff    	lea    -0xc9fe(%ebx),%eax
  101041:	50                   	push   %eax
  101042:	e8 e8 f2 ff ff       	call   10032f <cprintf>
  101047:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  10104a:	83 ec 0c             	sub    $0xc,%esp
  10104d:	6a 00                	push   $0x0
  10104f:	e8 4e 0a 00 00       	call   101aa2 <pic_enable>
  101054:	83 c4 10             	add    $0x10,%esp
}
  101057:	90                   	nop
  101058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10105b:	c9                   	leave  
  10105c:	c3                   	ret    

0010105d <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  10105d:	f3 0f 1e fb          	endbr32 
  101061:	55                   	push   %ebp
  101062:	89 e5                	mov    %esp,%ebp
  101064:	83 ec 10             	sub    $0x10,%esp
  101067:	e8 44 f2 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10106c:	05 e4 f8 00 00       	add    $0xf8e4,%eax
  101071:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101077:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10107b:	89 c2                	mov    %eax,%edx
  10107d:	ec                   	in     (%dx),%al
  10107e:	88 45 f1             	mov    %al,-0xf(%ebp)
  101081:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  101087:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10108b:	89 c2                	mov    %eax,%edx
  10108d:	ec                   	in     (%dx),%al
  10108e:	88 45 f5             	mov    %al,-0xb(%ebp)
  101091:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  101097:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10109b:	89 c2                	mov    %eax,%edx
  10109d:	ec                   	in     (%dx),%al
  10109e:	88 45 f9             	mov    %al,-0x7(%ebp)
  1010a1:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  1010a7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1010ab:	89 c2                	mov    %eax,%edx
  1010ad:	ec                   	in     (%dx),%al
  1010ae:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  1010b1:	90                   	nop
  1010b2:	c9                   	leave  
  1010b3:	c3                   	ret    

001010b4 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  1010b4:	f3 0f 1e fb          	endbr32 
  1010b8:	55                   	push   %ebp
  1010b9:	89 e5                	mov    %esp,%ebp
  1010bb:	83 ec 20             	sub    $0x20,%esp
  1010be:	e8 70 09 00 00       	call   101a33 <__x86.get_pc_thunk.cx>
  1010c3:	81 c1 8d f8 00 00    	add    $0xf88d,%ecx
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  1010c9:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  1010d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010d3:	0f b7 00             	movzwl (%eax),%eax
  1010d6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  1010da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010dd:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  1010e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010e5:	0f b7 00             	movzwl (%eax),%eax
  1010e8:	66 3d 5a a5          	cmp    $0xa55a,%ax
  1010ec:	74 12                	je     101100 <cga_init+0x4c>
        cp = (uint16_t*)MONO_BUF;
  1010ee:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  1010f5:	66 c7 81 b6 05 00 00 	movw   $0x3b4,0x5b6(%ecx)
  1010fc:	b4 03 
  1010fe:	eb 13                	jmp    101113 <cga_init+0x5f>
    } else {
        *cp = was;
  101100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101103:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101107:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  10110a:	66 c7 81 b6 05 00 00 	movw   $0x3d4,0x5b6(%ecx)
  101111:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  101113:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  10111a:	0f b7 c0             	movzwl %ax,%eax
  10111d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101121:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101125:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101129:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10112d:	ee                   	out    %al,(%dx)
}
  10112e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  10112f:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  101136:	83 c0 01             	add    $0x1,%eax
  101139:	0f b7 c0             	movzwl %ax,%eax
  10113c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101140:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  101144:	89 c2                	mov    %eax,%edx
  101146:	ec                   	in     (%dx),%al
  101147:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  10114a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10114e:	0f b6 c0             	movzbl %al,%eax
  101151:	c1 e0 08             	shl    $0x8,%eax
  101154:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  101157:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  10115e:	0f b7 c0             	movzwl %ax,%eax
  101161:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101165:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101169:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10116d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101171:	ee                   	out    %al,(%dx)
}
  101172:	90                   	nop
    pos |= inb(addr_6845 + 1);
  101173:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  10117a:	83 c0 01             	add    $0x1,%eax
  10117d:	0f b7 c0             	movzwl %ax,%eax
  101180:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101184:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101188:	89 c2                	mov    %eax,%edx
  10118a:	ec                   	in     (%dx),%al
  10118b:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  10118e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101192:	0f b6 c0             	movzbl %al,%eax
  101195:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  101198:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10119b:	89 81 b0 05 00 00    	mov    %eax,0x5b0(%ecx)
    crt_pos = pos;
  1011a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1011a4:	66 89 81 b4 05 00 00 	mov    %ax,0x5b4(%ecx)
}
  1011ab:	90                   	nop
  1011ac:	c9                   	leave  
  1011ad:	c3                   	ret    

001011ae <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  1011ae:	f3 0f 1e fb          	endbr32 
  1011b2:	55                   	push   %ebp
  1011b3:	89 e5                	mov    %esp,%ebp
  1011b5:	53                   	push   %ebx
  1011b6:	83 ec 34             	sub    $0x34,%esp
  1011b9:	e8 75 08 00 00       	call   101a33 <__x86.get_pc_thunk.cx>
  1011be:	81 c1 92 f7 00 00    	add    $0xf792,%ecx
  1011c4:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  1011ca:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011ce:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1011d2:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1011d6:	ee                   	out    %al,(%dx)
}
  1011d7:	90                   	nop
  1011d8:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  1011de:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011e2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1011e6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1011ea:	ee                   	out    %al,(%dx)
}
  1011eb:	90                   	nop
  1011ec:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  1011f2:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011f6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1011fa:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1011fe:	ee                   	out    %al,(%dx)
}
  1011ff:	90                   	nop
  101200:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  101206:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10120a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10120e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101212:	ee                   	out    %al,(%dx)
}
  101213:	90                   	nop
  101214:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  10121a:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10121e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101222:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101226:	ee                   	out    %al,(%dx)
}
  101227:	90                   	nop
  101228:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  10122e:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101232:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101236:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10123a:	ee                   	out    %al,(%dx)
}
  10123b:	90                   	nop
  10123c:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101242:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101246:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10124a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10124e:	ee                   	out    %al,(%dx)
}
  10124f:	90                   	nop
  101250:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101256:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10125a:	89 c2                	mov    %eax,%edx
  10125c:	ec                   	in     (%dx),%al
  10125d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101260:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101264:	3c ff                	cmp    $0xff,%al
  101266:	0f 95 c0             	setne  %al
  101269:	0f b6 c0             	movzbl %al,%eax
  10126c:	89 81 b8 05 00 00    	mov    %eax,0x5b8(%ecx)
  101272:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101278:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10127c:	89 c2                	mov    %eax,%edx
  10127e:	ec                   	in     (%dx),%al
  10127f:	88 45 f1             	mov    %al,-0xf(%ebp)
  101282:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101288:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10128c:	89 c2                	mov    %eax,%edx
  10128e:	ec                   	in     (%dx),%al
  10128f:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101292:	8b 81 b8 05 00 00    	mov    0x5b8(%ecx),%eax
  101298:	85 c0                	test   %eax,%eax
  10129a:	74 0f                	je     1012ab <serial_init+0xfd>
        pic_enable(IRQ_COM1);
  10129c:	83 ec 0c             	sub    $0xc,%esp
  10129f:	6a 04                	push   $0x4
  1012a1:	89 cb                	mov    %ecx,%ebx
  1012a3:	e8 fa 07 00 00       	call   101aa2 <pic_enable>
  1012a8:	83 c4 10             	add    $0x10,%esp
    }
}
  1012ab:	90                   	nop
  1012ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012af:	c9                   	leave  
  1012b0:	c3                   	ret    

001012b1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1012b1:	f3 0f 1e fb          	endbr32 
  1012b5:	55                   	push   %ebp
  1012b6:	89 e5                	mov    %esp,%ebp
  1012b8:	83 ec 20             	sub    $0x20,%esp
  1012bb:	e8 f0 ef ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1012c0:	05 90 f6 00 00       	add    $0xf690,%eax
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cc:	eb 09                	jmp    1012d7 <lpt_putc_sub+0x26>
        delay();
  1012ce:	e8 8a fd ff ff       	call   10105d <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d7:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e1:	89 c2                	mov    %eax,%edx
  1012e3:	ec                   	in     (%dx),%al
  1012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012eb:	84 c0                	test   %al,%al
  1012ed:	78 09                	js     1012f8 <lpt_putc_sub+0x47>
  1012ef:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012f6:	7e d6                	jle    1012ce <lpt_putc_sub+0x1d>
    }
    outb(LPTPORT + 0, c);
  1012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012fb:	0f b6 c0             	movzbl %al,%eax
  1012fe:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101304:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101307:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10130b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10130f:	ee                   	out    %al,(%dx)
}
  101310:	90                   	nop
  101311:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101317:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10131b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10131f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101323:	ee                   	out    %al,(%dx)
}
  101324:	90                   	nop
  101325:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10132b:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10132f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101333:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101337:	ee                   	out    %al,(%dx)
}
  101338:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101339:	90                   	nop
  10133a:	c9                   	leave  
  10133b:	c3                   	ret    

0010133c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10133c:	f3 0f 1e fb          	endbr32 
  101340:	55                   	push   %ebp
  101341:	89 e5                	mov    %esp,%ebp
  101343:	e8 68 ef ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101348:	05 08 f6 00 00       	add    $0xf608,%eax
    if (c != '\b') {
  10134d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101351:	74 0d                	je     101360 <lpt_putc+0x24>
        lpt_putc_sub(c);
  101353:	ff 75 08             	pushl  0x8(%ebp)
  101356:	e8 56 ff ff ff       	call   1012b1 <lpt_putc_sub>
  10135b:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10135e:	eb 1e                	jmp    10137e <lpt_putc+0x42>
        lpt_putc_sub('\b');
  101360:	6a 08                	push   $0x8
  101362:	e8 4a ff ff ff       	call   1012b1 <lpt_putc_sub>
  101367:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10136a:	6a 20                	push   $0x20
  10136c:	e8 40 ff ff ff       	call   1012b1 <lpt_putc_sub>
  101371:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101374:	6a 08                	push   $0x8
  101376:	e8 36 ff ff ff       	call   1012b1 <lpt_putc_sub>
  10137b:	83 c4 04             	add    $0x4,%esp
}
  10137e:	90                   	nop
  10137f:	c9                   	leave  
  101380:	c3                   	ret    

00101381 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101381:	f3 0f 1e fb          	endbr32 
  101385:	55                   	push   %ebp
  101386:	89 e5                	mov    %esp,%ebp
  101388:	56                   	push   %esi
  101389:	53                   	push   %ebx
  10138a:	83 ec 20             	sub    $0x20,%esp
  10138d:	e8 22 ef ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  101392:	81 c3 be f5 00 00    	add    $0xf5be,%ebx
    // set black on white
    if (!(c & ~0xFF)) {
  101398:	8b 45 08             	mov    0x8(%ebp),%eax
  10139b:	b0 00                	mov    $0x0,%al
  10139d:	85 c0                	test   %eax,%eax
  10139f:	75 07                	jne    1013a8 <cga_putc+0x27>
        c |= 0x0700;
  1013a1:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ab:	0f b6 c0             	movzbl %al,%eax
  1013ae:	83 f8 0d             	cmp    $0xd,%eax
  1013b1:	74 6f                	je     101422 <cga_putc+0xa1>
  1013b3:	83 f8 0d             	cmp    $0xd,%eax
  1013b6:	0f 8f a1 00 00 00    	jg     10145d <cga_putc+0xdc>
  1013bc:	83 f8 08             	cmp    $0x8,%eax
  1013bf:	74 0a                	je     1013cb <cga_putc+0x4a>
  1013c1:	83 f8 0a             	cmp    $0xa,%eax
  1013c4:	74 4b                	je     101411 <cga_putc+0x90>
  1013c6:	e9 92 00 00 00       	jmp    10145d <cga_putc+0xdc>
    case '\b':
        if (crt_pos > 0) {
  1013cb:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  1013d2:	66 85 c0             	test   %ax,%ax
  1013d5:	0f 84 a8 00 00 00    	je     101483 <cga_putc+0x102>
            crt_pos --;
  1013db:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  1013e2:	83 e8 01             	sub    $0x1,%eax
  1013e5:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ef:	b0 00                	mov    $0x0,%al
  1013f1:	83 c8 20             	or     $0x20,%eax
  1013f4:	89 c1                	mov    %eax,%ecx
  1013f6:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  1013fc:	0f b7 93 b4 05 00 00 	movzwl 0x5b4(%ebx),%edx
  101403:	0f b7 d2             	movzwl %dx,%edx
  101406:	01 d2                	add    %edx,%edx
  101408:	01 d0                	add    %edx,%eax
  10140a:	89 ca                	mov    %ecx,%edx
  10140c:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10140f:	eb 72                	jmp    101483 <cga_putc+0x102>
    case '\n':
        crt_pos += CRT_COLS;
  101411:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101418:	83 c0 50             	add    $0x50,%eax
  10141b:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101422:	0f b7 b3 b4 05 00 00 	movzwl 0x5b4(%ebx),%esi
  101429:	0f b7 8b b4 05 00 00 	movzwl 0x5b4(%ebx),%ecx
  101430:	0f b7 c1             	movzwl %cx,%eax
  101433:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101439:	c1 e8 10             	shr    $0x10,%eax
  10143c:	89 c2                	mov    %eax,%edx
  10143e:	66 c1 ea 06          	shr    $0x6,%dx
  101442:	89 d0                	mov    %edx,%eax
  101444:	c1 e0 02             	shl    $0x2,%eax
  101447:	01 d0                	add    %edx,%eax
  101449:	c1 e0 04             	shl    $0x4,%eax
  10144c:	29 c1                	sub    %eax,%ecx
  10144e:	89 ca                	mov    %ecx,%edx
  101450:	89 f0                	mov    %esi,%eax
  101452:	29 d0                	sub    %edx,%eax
  101454:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
        break;
  10145b:	eb 27                	jmp    101484 <cga_putc+0x103>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10145d:	8b 8b b0 05 00 00    	mov    0x5b0(%ebx),%ecx
  101463:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  10146a:	8d 50 01             	lea    0x1(%eax),%edx
  10146d:	66 89 93 b4 05 00 00 	mov    %dx,0x5b4(%ebx)
  101474:	0f b7 c0             	movzwl %ax,%eax
  101477:	01 c0                	add    %eax,%eax
  101479:	01 c8                	add    %ecx,%eax
  10147b:	8b 55 08             	mov    0x8(%ebp),%edx
  10147e:	66 89 10             	mov    %dx,(%eax)
        break;
  101481:	eb 01                	jmp    101484 <cga_putc+0x103>
        break;
  101483:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101484:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  10148b:	66 3d cf 07          	cmp    $0x7cf,%ax
  10148f:	76 5d                	jbe    1014ee <cga_putc+0x16d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101491:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  101497:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10149d:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  1014a3:	83 ec 04             	sub    $0x4,%esp
  1014a6:	68 00 0f 00 00       	push   $0xf00
  1014ab:	52                   	push   %edx
  1014ac:	50                   	push   %eax
  1014ad:	e8 92 1f 00 00       	call   103444 <memmove>
  1014b2:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1014b5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1014bc:	eb 16                	jmp    1014d4 <cga_putc+0x153>
            crt_buf[i] = 0x0700 | ' ';
  1014be:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  1014c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1014c7:	01 d2                	add    %edx,%edx
  1014c9:	01 d0                	add    %edx,%eax
  1014cb:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1014d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1014d4:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1014db:	7e e1                	jle    1014be <cga_putc+0x13d>
        }
        crt_pos -= CRT_COLS;
  1014dd:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  1014e4:	83 e8 50             	sub    $0x50,%eax
  1014e7:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1014ee:	0f b7 83 b6 05 00 00 	movzwl 0x5b6(%ebx),%eax
  1014f5:	0f b7 c0             	movzwl %ax,%eax
  1014f8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1014fc:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101500:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101504:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101508:	ee                   	out    %al,(%dx)
}
  101509:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  10150a:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101511:	66 c1 e8 08          	shr    $0x8,%ax
  101515:	0f b6 c0             	movzbl %al,%eax
  101518:	0f b7 93 b6 05 00 00 	movzwl 0x5b6(%ebx),%edx
  10151f:	83 c2 01             	add    $0x1,%edx
  101522:	0f b7 d2             	movzwl %dx,%edx
  101525:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101529:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10152c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101530:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101534:	ee                   	out    %al,(%dx)
}
  101535:	90                   	nop
    outb(addr_6845, 15);
  101536:	0f b7 83 b6 05 00 00 	movzwl 0x5b6(%ebx),%eax
  10153d:	0f b7 c0             	movzwl %ax,%eax
  101540:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101544:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101548:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10154c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101550:	ee                   	out    %al,(%dx)
}
  101551:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101552:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101559:	0f b6 c0             	movzbl %al,%eax
  10155c:	0f b7 93 b6 05 00 00 	movzwl 0x5b6(%ebx),%edx
  101563:	83 c2 01             	add    $0x1,%edx
  101566:	0f b7 d2             	movzwl %dx,%edx
  101569:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10156d:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101570:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101574:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101578:	ee                   	out    %al,(%dx)
}
  101579:	90                   	nop
}
  10157a:	90                   	nop
  10157b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  10157e:	5b                   	pop    %ebx
  10157f:	5e                   	pop    %esi
  101580:	5d                   	pop    %ebp
  101581:	c3                   	ret    

00101582 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101582:	f3 0f 1e fb          	endbr32 
  101586:	55                   	push   %ebp
  101587:	89 e5                	mov    %esp,%ebp
  101589:	83 ec 10             	sub    $0x10,%esp
  10158c:	e8 1f ed ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101591:	05 bf f3 00 00       	add    $0xf3bf,%eax
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101596:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10159d:	eb 09                	jmp    1015a8 <serial_putc_sub+0x26>
        delay();
  10159f:	e8 b9 fa ff ff       	call   10105d <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1015a4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1015a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1015ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1015b2:	89 c2                	mov    %eax,%edx
  1015b4:	ec                   	in     (%dx),%al
  1015b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1015b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1015bc:	0f b6 c0             	movzbl %al,%eax
  1015bf:	83 e0 20             	and    $0x20,%eax
  1015c2:	85 c0                	test   %eax,%eax
  1015c4:	75 09                	jne    1015cf <serial_putc_sub+0x4d>
  1015c6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1015cd:	7e d0                	jle    10159f <serial_putc_sub+0x1d>
    }
    outb(COM1 + COM_TX, c);
  1015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d2:	0f b6 c0             	movzbl %al,%eax
  1015d5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1015db:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015de:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1015e2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1015e6:	ee                   	out    %al,(%dx)
}
  1015e7:	90                   	nop
}
  1015e8:	90                   	nop
  1015e9:	c9                   	leave  
  1015ea:	c3                   	ret    

001015eb <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1015eb:	f3 0f 1e fb          	endbr32 
  1015ef:	55                   	push   %ebp
  1015f0:	89 e5                	mov    %esp,%ebp
  1015f2:	e8 b9 ec ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1015f7:	05 59 f3 00 00       	add    $0xf359,%eax
    if (c != '\b') {
  1015fc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101600:	74 0d                	je     10160f <serial_putc+0x24>
        serial_putc_sub(c);
  101602:	ff 75 08             	pushl  0x8(%ebp)
  101605:	e8 78 ff ff ff       	call   101582 <serial_putc_sub>
  10160a:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10160d:	eb 1e                	jmp    10162d <serial_putc+0x42>
        serial_putc_sub('\b');
  10160f:	6a 08                	push   $0x8
  101611:	e8 6c ff ff ff       	call   101582 <serial_putc_sub>
  101616:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101619:	6a 20                	push   $0x20
  10161b:	e8 62 ff ff ff       	call   101582 <serial_putc_sub>
  101620:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101623:	6a 08                	push   $0x8
  101625:	e8 58 ff ff ff       	call   101582 <serial_putc_sub>
  10162a:	83 c4 04             	add    $0x4,%esp
}
  10162d:	90                   	nop
  10162e:	c9                   	leave  
  10162f:	c3                   	ret    

00101630 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101630:	f3 0f 1e fb          	endbr32 
  101634:	55                   	push   %ebp
  101635:	89 e5                	mov    %esp,%ebp
  101637:	53                   	push   %ebx
  101638:	83 ec 14             	sub    $0x14,%esp
  10163b:	e8 74 ec ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  101640:	81 c3 10 f3 00 00    	add    $0xf310,%ebx
    int c;
    while ((c = (*proc)()) != -1) {
  101646:	eb 36                	jmp    10167e <cons_intr+0x4e>
        if (c != 0) {
  101648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10164c:	74 30                	je     10167e <cons_intr+0x4e>
            cons.buf[cons.wpos ++] = c;
  10164e:	8b 83 d4 07 00 00    	mov    0x7d4(%ebx),%eax
  101654:	8d 50 01             	lea    0x1(%eax),%edx
  101657:	89 93 d4 07 00 00    	mov    %edx,0x7d4(%ebx)
  10165d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101660:	88 94 03 d0 05 00 00 	mov    %dl,0x5d0(%ebx,%eax,1)
            if (cons.wpos == CONSBUFSIZE) {
  101667:	8b 83 d4 07 00 00    	mov    0x7d4(%ebx),%eax
  10166d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101672:	75 0a                	jne    10167e <cons_intr+0x4e>
                cons.wpos = 0;
  101674:	c7 83 d4 07 00 00 00 	movl   $0x0,0x7d4(%ebx)
  10167b:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10167e:	8b 45 08             	mov    0x8(%ebp),%eax
  101681:	ff d0                	call   *%eax
  101683:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101686:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10168a:	75 bc                	jne    101648 <cons_intr+0x18>
            }
        }
    }
}
  10168c:	90                   	nop
  10168d:	90                   	nop
  10168e:	83 c4 14             	add    $0x14,%esp
  101691:	5b                   	pop    %ebx
  101692:	5d                   	pop    %ebp
  101693:	c3                   	ret    

00101694 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101694:	f3 0f 1e fb          	endbr32 
  101698:	55                   	push   %ebp
  101699:	89 e5                	mov    %esp,%ebp
  10169b:	83 ec 10             	sub    $0x10,%esp
  10169e:	e8 0d ec ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1016a3:	05 ad f2 00 00       	add    $0xf2ad,%eax
  1016a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1016ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1016b2:	89 c2                	mov    %eax,%edx
  1016b4:	ec                   	in     (%dx),%al
  1016b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1016b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1016bc:	0f b6 c0             	movzbl %al,%eax
  1016bf:	83 e0 01             	and    $0x1,%eax
  1016c2:	85 c0                	test   %eax,%eax
  1016c4:	75 07                	jne    1016cd <serial_proc_data+0x39>
        return -1;
  1016c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1016cb:	eb 2a                	jmp    1016f7 <serial_proc_data+0x63>
  1016cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1016d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1016d7:	89 c2                	mov    %eax,%edx
  1016d9:	ec                   	in     (%dx),%al
  1016da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1016dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1016e1:	0f b6 c0             	movzbl %al,%eax
  1016e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1016e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1016eb:	75 07                	jne    1016f4 <serial_proc_data+0x60>
        c = '\b';
  1016ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1016f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1016f7:	c9                   	leave  
  1016f8:	c3                   	ret    

001016f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1016f9:	f3 0f 1e fb          	endbr32 
  1016fd:	55                   	push   %ebp
  1016fe:	89 e5                	mov    %esp,%ebp
  101700:	83 ec 08             	sub    $0x8,%esp
  101703:	e8 a8 eb ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101708:	05 48 f2 00 00       	add    $0xf248,%eax
    if (serial_exists) {
  10170d:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  101713:	85 d2                	test   %edx,%edx
  101715:	74 12                	je     101729 <serial_intr+0x30>
        cons_intr(serial_proc_data);
  101717:	83 ec 0c             	sub    $0xc,%esp
  10171a:	8d 80 44 0d ff ff    	lea    -0xf2bc(%eax),%eax
  101720:	50                   	push   %eax
  101721:	e8 0a ff ff ff       	call   101630 <cons_intr>
  101726:	83 c4 10             	add    $0x10,%esp
    }
}
  101729:	90                   	nop
  10172a:	c9                   	leave  
  10172b:	c3                   	ret    

0010172c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10172c:	f3 0f 1e fb          	endbr32 
  101730:	55                   	push   %ebp
  101731:	89 e5                	mov    %esp,%ebp
  101733:	53                   	push   %ebx
  101734:	83 ec 24             	sub    $0x24,%esp
  101737:	e8 f7 02 00 00       	call   101a33 <__x86.get_pc_thunk.cx>
  10173c:	81 c1 14 f2 00 00    	add    $0xf214,%ecx
  101742:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101748:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10174c:	89 c2                	mov    %eax,%edx
  10174e:	ec                   	in     (%dx),%al
  10174f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101752:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101756:	0f b6 c0             	movzbl %al,%eax
  101759:	83 e0 01             	and    $0x1,%eax
  10175c:	85 c0                	test   %eax,%eax
  10175e:	75 0a                	jne    10176a <kbd_proc_data+0x3e>
        return -1;
  101760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101765:	e9 74 01 00 00       	jmp    1018de <kbd_proc_data+0x1b2>
  10176a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101770:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101774:	89 c2                	mov    %eax,%edx
  101776:	ec                   	in     (%dx),%al
  101777:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10177a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10177e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101781:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101785:	75 19                	jne    1017a0 <kbd_proc_data+0x74>
        // E0 escape character
        shift |= E0ESC;
  101787:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  10178d:	83 c8 40             	or     $0x40,%eax
  101790:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
        return 0;
  101796:	b8 00 00 00 00       	mov    $0x0,%eax
  10179b:	e9 3e 01 00 00       	jmp    1018de <kbd_proc_data+0x1b2>
    } else if (data & 0x80) {
  1017a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1017a4:	84 c0                	test   %al,%al
  1017a6:	79 4b                	jns    1017f3 <kbd_proc_data+0xc7>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1017a8:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1017ae:	83 e0 40             	and    $0x40,%eax
  1017b1:	85 c0                	test   %eax,%eax
  1017b3:	75 09                	jne    1017be <kbd_proc_data+0x92>
  1017b5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1017b9:	83 e0 7f             	and    $0x7f,%eax
  1017bc:	eb 04                	jmp    1017c2 <kbd_proc_data+0x96>
  1017be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1017c2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1017c5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1017c9:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
  1017d0:	ff 
  1017d1:	83 c8 40             	or     $0x40,%eax
  1017d4:	0f b6 c0             	movzbl %al,%eax
  1017d7:	f7 d0                	not    %eax
  1017d9:	89 c2                	mov    %eax,%edx
  1017db:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1017e1:	21 d0                	and    %edx,%eax
  1017e3:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
        return 0;
  1017e9:	b8 00 00 00 00       	mov    $0x0,%eax
  1017ee:	e9 eb 00 00 00       	jmp    1018de <kbd_proc_data+0x1b2>
    } else if (shift & E0ESC) {
  1017f3:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1017f9:	83 e0 40             	and    $0x40,%eax
  1017fc:	85 c0                	test   %eax,%eax
  1017fe:	74 13                	je     101813 <kbd_proc_data+0xe7>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101800:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101804:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  10180a:	83 e0 bf             	and    $0xffffffbf,%eax
  10180d:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
    }

    shift |= shiftcode[data];
  101813:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101817:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
  10181e:	ff 
  10181f:	0f b6 d0             	movzbl %al,%edx
  101822:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101828:	09 d0                	or     %edx,%eax
  10182a:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
    shift ^= togglecode[data];
  101830:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101834:	0f b6 84 01 b0 f7 ff 	movzbl -0x850(%ecx,%eax,1),%eax
  10183b:	ff 
  10183c:	0f b6 d0             	movzbl %al,%edx
  10183f:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101845:	31 d0                	xor    %edx,%eax
  101847:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)

    c = charcode[shift & (CTL | SHIFT)][data];
  10184d:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101853:	83 e0 03             	and    $0x3,%eax
  101856:	8b 94 81 34 00 00 00 	mov    0x34(%ecx,%eax,4),%edx
  10185d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101861:	01 d0                	add    %edx,%eax
  101863:	0f b6 00             	movzbl (%eax),%eax
  101866:	0f b6 c0             	movzbl %al,%eax
  101869:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10186c:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101872:	83 e0 08             	and    $0x8,%eax
  101875:	85 c0                	test   %eax,%eax
  101877:	74 22                	je     10189b <kbd_proc_data+0x16f>
        if ('a' <= c && c <= 'z')
  101879:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10187d:	7e 0c                	jle    10188b <kbd_proc_data+0x15f>
  10187f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101883:	7f 06                	jg     10188b <kbd_proc_data+0x15f>
            c += 'A' - 'a';
  101885:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101889:	eb 10                	jmp    10189b <kbd_proc_data+0x16f>
        else if ('A' <= c && c <= 'Z')
  10188b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10188f:	7e 0a                	jle    10189b <kbd_proc_data+0x16f>
  101891:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101895:	7f 04                	jg     10189b <kbd_proc_data+0x16f>
            c += 'a' - 'A';
  101897:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10189b:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1018a1:	f7 d0                	not    %eax
  1018a3:	83 e0 06             	and    $0x6,%eax
  1018a6:	85 c0                	test   %eax,%eax
  1018a8:	75 31                	jne    1018db <kbd_proc_data+0x1af>
  1018aa:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1018b1:	75 28                	jne    1018db <kbd_proc_data+0x1af>
        cprintf("Rebooting!\n");
  1018b3:	83 ec 0c             	sub    $0xc,%esp
  1018b6:	8d 81 1d 36 ff ff    	lea    -0xc9e3(%ecx),%eax
  1018bc:	50                   	push   %eax
  1018bd:	89 cb                	mov    %ecx,%ebx
  1018bf:	e8 6b ea ff ff       	call   10032f <cprintf>
  1018c4:	83 c4 10             	add    $0x10,%esp
  1018c7:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1018cd:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018d1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1018d5:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1018d9:	ee                   	out    %al,(%dx)
}
  1018da:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1018db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1018de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1018e1:	c9                   	leave  
  1018e2:	c3                   	ret    

001018e3 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1018e3:	f3 0f 1e fb          	endbr32 
  1018e7:	55                   	push   %ebp
  1018e8:	89 e5                	mov    %esp,%ebp
  1018ea:	83 ec 08             	sub    $0x8,%esp
  1018ed:	e8 be e9 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1018f2:	05 5e f0 00 00       	add    $0xf05e,%eax
    cons_intr(kbd_proc_data);
  1018f7:	83 ec 0c             	sub    $0xc,%esp
  1018fa:	8d 80 dc 0d ff ff    	lea    -0xf224(%eax),%eax
  101900:	50                   	push   %eax
  101901:	e8 2a fd ff ff       	call   101630 <cons_intr>
  101906:	83 c4 10             	add    $0x10,%esp
}
  101909:	90                   	nop
  10190a:	c9                   	leave  
  10190b:	c3                   	ret    

0010190c <kbd_init>:

static void
kbd_init(void) {
  10190c:	f3 0f 1e fb          	endbr32 
  101910:	55                   	push   %ebp
  101911:	89 e5                	mov    %esp,%ebp
  101913:	53                   	push   %ebx
  101914:	83 ec 04             	sub    $0x4,%esp
  101917:	e8 98 e9 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  10191c:	81 c3 34 f0 00 00    	add    $0xf034,%ebx
    // drain the kbd buffer
    kbd_intr();
  101922:	e8 bc ff ff ff       	call   1018e3 <kbd_intr>
    pic_enable(IRQ_KBD);
  101927:	83 ec 0c             	sub    $0xc,%esp
  10192a:	6a 01                	push   $0x1
  10192c:	e8 71 01 00 00       	call   101aa2 <pic_enable>
  101931:	83 c4 10             	add    $0x10,%esp
}
  101934:	90                   	nop
  101935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101938:	c9                   	leave  
  101939:	c3                   	ret    

0010193a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10193a:	f3 0f 1e fb          	endbr32 
  10193e:	55                   	push   %ebp
  10193f:	89 e5                	mov    %esp,%ebp
  101941:	53                   	push   %ebx
  101942:	83 ec 04             	sub    $0x4,%esp
  101945:	e8 6a e9 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  10194a:	81 c3 06 f0 00 00    	add    $0xf006,%ebx
    cga_init();
  101950:	e8 5f f7 ff ff       	call   1010b4 <cga_init>
    serial_init();
  101955:	e8 54 f8 ff ff       	call   1011ae <serial_init>
    kbd_init();
  10195a:	e8 ad ff ff ff       	call   10190c <kbd_init>
    if (!serial_exists) {
  10195f:	8b 83 b8 05 00 00    	mov    0x5b8(%ebx),%eax
  101965:	85 c0                	test   %eax,%eax
  101967:	75 12                	jne    10197b <cons_init+0x41>
        cprintf("serial port does not exist!!\n");
  101969:	83 ec 0c             	sub    $0xc,%esp
  10196c:	8d 83 29 36 ff ff    	lea    -0xc9d7(%ebx),%eax
  101972:	50                   	push   %eax
  101973:	e8 b7 e9 ff ff       	call   10032f <cprintf>
  101978:	83 c4 10             	add    $0x10,%esp
    }
}
  10197b:	90                   	nop
  10197c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10197f:	c9                   	leave  
  101980:	c3                   	ret    

00101981 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101981:	f3 0f 1e fb          	endbr32 
  101985:	55                   	push   %ebp
  101986:	89 e5                	mov    %esp,%ebp
  101988:	83 ec 08             	sub    $0x8,%esp
  10198b:	e8 20 e9 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101990:	05 c0 ef 00 00       	add    $0xefc0,%eax
    lpt_putc(c);
  101995:	ff 75 08             	pushl  0x8(%ebp)
  101998:	e8 9f f9 ff ff       	call   10133c <lpt_putc>
  10199d:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1019a0:	83 ec 0c             	sub    $0xc,%esp
  1019a3:	ff 75 08             	pushl  0x8(%ebp)
  1019a6:	e8 d6 f9 ff ff       	call   101381 <cga_putc>
  1019ab:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1019ae:	83 ec 0c             	sub    $0xc,%esp
  1019b1:	ff 75 08             	pushl  0x8(%ebp)
  1019b4:	e8 32 fc ff ff       	call   1015eb <serial_putc>
  1019b9:	83 c4 10             	add    $0x10,%esp
}
  1019bc:	90                   	nop
  1019bd:	c9                   	leave  
  1019be:	c3                   	ret    

001019bf <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1019bf:	f3 0f 1e fb          	endbr32 
  1019c3:	55                   	push   %ebp
  1019c4:	89 e5                	mov    %esp,%ebp
  1019c6:	53                   	push   %ebx
  1019c7:	83 ec 14             	sub    $0x14,%esp
  1019ca:	e8 e5 e8 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  1019cf:	81 c3 81 ef 00 00    	add    $0xef81,%ebx
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1019d5:	e8 1f fd ff ff       	call   1016f9 <serial_intr>
    kbd_intr();
  1019da:	e8 04 ff ff ff       	call   1018e3 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1019df:	8b 93 d0 07 00 00    	mov    0x7d0(%ebx),%edx
  1019e5:	8b 83 d4 07 00 00    	mov    0x7d4(%ebx),%eax
  1019eb:	39 c2                	cmp    %eax,%edx
  1019ed:	74 39                	je     101a28 <cons_getc+0x69>
        c = cons.buf[cons.rpos ++];
  1019ef:	8b 83 d0 07 00 00    	mov    0x7d0(%ebx),%eax
  1019f5:	8d 50 01             	lea    0x1(%eax),%edx
  1019f8:	89 93 d0 07 00 00    	mov    %edx,0x7d0(%ebx)
  1019fe:	0f b6 84 03 d0 05 00 	movzbl 0x5d0(%ebx,%eax,1),%eax
  101a05:	00 
  101a06:	0f b6 c0             	movzbl %al,%eax
  101a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101a0c:	8b 83 d0 07 00 00    	mov    0x7d0(%ebx),%eax
  101a12:	3d 00 02 00 00       	cmp    $0x200,%eax
  101a17:	75 0a                	jne    101a23 <cons_getc+0x64>
            cons.rpos = 0;
  101a19:	c7 83 d0 07 00 00 00 	movl   $0x0,0x7d0(%ebx)
  101a20:	00 00 00 
        }
        return c;
  101a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a26:	eb 05                	jmp    101a2d <cons_getc+0x6e>
    }
    return 0;
  101a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101a2d:	83 c4 14             	add    $0x14,%esp
  101a30:	5b                   	pop    %ebx
  101a31:	5d                   	pop    %ebp
  101a32:	c3                   	ret    

00101a33 <__x86.get_pc_thunk.cx>:
  101a33:	8b 0c 24             	mov    (%esp),%ecx
  101a36:	c3                   	ret    

00101a37 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101a37:	f3 0f 1e fb          	endbr32 
  101a3b:	55                   	push   %ebp
  101a3c:	89 e5                	mov    %esp,%ebp
  101a3e:	83 ec 14             	sub    $0x14,%esp
  101a41:	e8 6a e8 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101a46:	05 0a ef 00 00       	add    $0xef0a,%eax
  101a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  101a4e:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
    irq_mask = mask;
  101a52:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101a56:	66 89 90 b0 fb ff ff 	mov    %dx,-0x450(%eax)
    if (did_init) {
  101a5d:	8b 80 dc 07 00 00    	mov    0x7dc(%eax),%eax
  101a63:	85 c0                	test   %eax,%eax
  101a65:	74 38                	je     101a9f <pic_setmask+0x68>
        outb(IO_PIC1 + 1, mask);
  101a67:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101a6b:	0f b6 c0             	movzbl %al,%eax
  101a6e:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101a74:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101a77:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101a7b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101a7f:	ee                   	out    %al,(%dx)
}
  101a80:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101a81:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101a85:	66 c1 e8 08          	shr    $0x8,%ax
  101a89:	0f b6 c0             	movzbl %al,%eax
  101a8c:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101a92:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101a95:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101a99:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101a9d:	ee                   	out    %al,(%dx)
}
  101a9e:	90                   	nop
    }
}
  101a9f:	90                   	nop
  101aa0:	c9                   	leave  
  101aa1:	c3                   	ret    

00101aa2 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101aa2:	f3 0f 1e fb          	endbr32 
  101aa6:	55                   	push   %ebp
  101aa7:	89 e5                	mov    %esp,%ebp
  101aa9:	53                   	push   %ebx
  101aaa:	e8 01 e8 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101aaf:	05 a1 ee 00 00       	add    $0xeea1,%eax
    pic_setmask(irq_mask & ~(1 << irq));
  101ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  101ab7:	bb 01 00 00 00       	mov    $0x1,%ebx
  101abc:	89 d1                	mov    %edx,%ecx
  101abe:	d3 e3                	shl    %cl,%ebx
  101ac0:	89 da                	mov    %ebx,%edx
  101ac2:	f7 d2                	not    %edx
  101ac4:	0f b7 80 b0 fb ff ff 	movzwl -0x450(%eax),%eax
  101acb:	21 d0                	and    %edx,%eax
  101acd:	0f b7 c0             	movzwl %ax,%eax
  101ad0:	50                   	push   %eax
  101ad1:	e8 61 ff ff ff       	call   101a37 <pic_setmask>
  101ad6:	83 c4 04             	add    $0x4,%esp
}
  101ad9:	90                   	nop
  101ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101add:	c9                   	leave  
  101ade:	c3                   	ret    

00101adf <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101adf:	f3 0f 1e fb          	endbr32 
  101ae3:	55                   	push   %ebp
  101ae4:	89 e5                	mov    %esp,%ebp
  101ae6:	83 ec 40             	sub    $0x40,%esp
  101ae9:	e8 45 ff ff ff       	call   101a33 <__x86.get_pc_thunk.cx>
  101aee:	81 c1 62 ee 00 00    	add    $0xee62,%ecx
    did_init = 1;
  101af4:	c7 81 dc 07 00 00 01 	movl   $0x1,0x7dc(%ecx)
  101afb:	00 00 00 
  101afe:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101b04:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101b08:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101b0c:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101b10:	ee                   	out    %al,(%dx)
}
  101b11:	90                   	nop
  101b12:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101b18:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101b1c:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101b20:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101b24:	ee                   	out    %al,(%dx)
}
  101b25:	90                   	nop
  101b26:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101b2c:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101b30:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101b34:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101b38:	ee                   	out    %al,(%dx)
}
  101b39:	90                   	nop
  101b3a:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101b40:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101b44:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101b48:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101b4c:	ee                   	out    %al,(%dx)
}
  101b4d:	90                   	nop
  101b4e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101b54:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101b58:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101b5c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101b60:	ee                   	out    %al,(%dx)
}
  101b61:	90                   	nop
  101b62:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101b68:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101b6c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101b70:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101b74:	ee                   	out    %al,(%dx)
}
  101b75:	90                   	nop
  101b76:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101b7c:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101b80:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101b84:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101b88:	ee                   	out    %al,(%dx)
}
  101b89:	90                   	nop
  101b8a:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101b90:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101b94:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101b98:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101b9c:	ee                   	out    %al,(%dx)
}
  101b9d:	90                   	nop
  101b9e:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101ba4:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101ba8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101bac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101bb0:	ee                   	out    %al,(%dx)
}
  101bb1:	90                   	nop
  101bb2:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101bb8:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101bbc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101bc0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101bc4:	ee                   	out    %al,(%dx)
}
  101bc5:	90                   	nop
  101bc6:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101bcc:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101bd0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101bd4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101bd8:	ee                   	out    %al,(%dx)
}
  101bd9:	90                   	nop
  101bda:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101be0:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101be4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101be8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101bec:	ee                   	out    %al,(%dx)
}
  101bed:	90                   	nop
  101bee:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101bf4:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101bf8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101bfc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101c00:	ee                   	out    %al,(%dx)
}
  101c01:	90                   	nop
  101c02:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101c08:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101c0c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101c10:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101c14:	ee                   	out    %al,(%dx)
}
  101c15:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101c16:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
  101c1d:	66 83 f8 ff          	cmp    $0xffff,%ax
  101c21:	74 13                	je     101c36 <pic_init+0x157>
        pic_setmask(irq_mask);
  101c23:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
  101c2a:	0f b7 c0             	movzwl %ax,%eax
  101c2d:	50                   	push   %eax
  101c2e:	e8 04 fe ff ff       	call   101a37 <pic_setmask>
  101c33:	83 c4 04             	add    $0x4,%esp
    }
}
  101c36:	90                   	nop
  101c37:	c9                   	leave  
  101c38:	c3                   	ret    

00101c39 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101c39:	f3 0f 1e fb          	endbr32 
  101c3d:	55                   	push   %ebp
  101c3e:	89 e5                	mov    %esp,%ebp
  101c40:	e8 6b e6 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101c45:	05 0b ed 00 00       	add    $0xed0b,%eax
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101c4a:	fb                   	sti    
}
  101c4b:	90                   	nop
    sti();
}
  101c4c:	90                   	nop
  101c4d:	5d                   	pop    %ebp
  101c4e:	c3                   	ret    

00101c4f <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101c4f:	f3 0f 1e fb          	endbr32 
  101c53:	55                   	push   %ebp
  101c54:	89 e5                	mov    %esp,%ebp
  101c56:	e8 55 e6 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101c5b:	05 f5 ec 00 00       	add    $0xecf5,%eax

static inline void
cli(void) {
    asm volatile ("cli");
  101c60:	fa                   	cli    
}
  101c61:	90                   	nop
    cli();
}
  101c62:	90                   	nop
  101c63:	5d                   	pop    %ebp
  101c64:	c3                   	ret    

00101c65 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  101c65:	f3 0f 1e fb          	endbr32 
  101c69:	55                   	push   %ebp
  101c6a:	89 e5                	mov    %esp,%ebp
  101c6c:	53                   	push   %ebx
  101c6d:	83 ec 04             	sub    $0x4,%esp
  101c70:	e8 3b e6 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101c75:	05 db ec 00 00       	add    $0xecdb,%eax
    cprintf("%d ticks\n",TICK_NUM);
  101c7a:	83 ec 08             	sub    $0x8,%esp
  101c7d:	6a 64                	push   $0x64
  101c7f:	8d 90 47 36 ff ff    	lea    -0xc9b9(%eax),%edx
  101c85:	52                   	push   %edx
  101c86:	89 c3                	mov    %eax,%ebx
  101c88:	e8 a2 e6 ff ff       	call   10032f <cprintf>
  101c8d:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101c90:	90                   	nop
  101c91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101c94:	c9                   	leave  
  101c95:	c3                   	ret    

00101c96 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101c96:	f3 0f 1e fb          	endbr32 
  101c9a:	55                   	push   %ebp
  101c9b:	89 e5                	mov    %esp,%ebp
  101c9d:	83 ec 10             	sub    $0x10,%esp
  101ca0:	e8 0b e6 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101ca5:	05 ab ec 00 00       	add    $0xecab,%eax
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101cb1:	e9 c7 00 00 00       	jmp    101d7d <idt_init+0xe7>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101cb6:	c7 c2 02 05 11 00    	mov    $0x110502,%edx
  101cbc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  101cbf:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
  101cc2:	89 d1                	mov    %edx,%ecx
  101cc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101cc7:	66 89 8c d0 f0 07 00 	mov    %cx,0x7f0(%eax,%edx,8)
  101cce:	00 
  101ccf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101cd2:	66 c7 84 d0 f2 07 00 	movw   $0x8,0x7f2(%eax,%edx,8)
  101cd9:	00 08 00 
  101cdc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101cdf:	0f b6 8c d0 f4 07 00 	movzbl 0x7f4(%eax,%edx,8),%ecx
  101ce6:	00 
  101ce7:	83 e1 e0             	and    $0xffffffe0,%ecx
  101cea:	88 8c d0 f4 07 00 00 	mov    %cl,0x7f4(%eax,%edx,8)
  101cf1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101cf4:	0f b6 8c d0 f4 07 00 	movzbl 0x7f4(%eax,%edx,8),%ecx
  101cfb:	00 
  101cfc:	83 e1 1f             	and    $0x1f,%ecx
  101cff:	88 8c d0 f4 07 00 00 	mov    %cl,0x7f4(%eax,%edx,8)
  101d06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101d09:	0f b6 8c d0 f5 07 00 	movzbl 0x7f5(%eax,%edx,8),%ecx
  101d10:	00 
  101d11:	83 e1 f0             	and    $0xfffffff0,%ecx
  101d14:	83 c9 0e             	or     $0xe,%ecx
  101d17:	88 8c d0 f5 07 00 00 	mov    %cl,0x7f5(%eax,%edx,8)
  101d1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101d21:	0f b6 8c d0 f5 07 00 	movzbl 0x7f5(%eax,%edx,8),%ecx
  101d28:	00 
  101d29:	83 e1 ef             	and    $0xffffffef,%ecx
  101d2c:	88 8c d0 f5 07 00 00 	mov    %cl,0x7f5(%eax,%edx,8)
  101d33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101d36:	0f b6 8c d0 f5 07 00 	movzbl 0x7f5(%eax,%edx,8),%ecx
  101d3d:	00 
  101d3e:	83 e1 9f             	and    $0xffffff9f,%ecx
  101d41:	88 8c d0 f5 07 00 00 	mov    %cl,0x7f5(%eax,%edx,8)
  101d48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101d4b:	0f b6 8c d0 f5 07 00 	movzbl 0x7f5(%eax,%edx,8),%ecx
  101d52:	00 
  101d53:	83 c9 80             	or     $0xffffff80,%ecx
  101d56:	88 8c d0 f5 07 00 00 	mov    %cl,0x7f5(%eax,%edx,8)
  101d5d:	c7 c2 02 05 11 00    	mov    $0x110502,%edx
  101d63:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  101d66:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
  101d69:	c1 ea 10             	shr    $0x10,%edx
  101d6c:	89 d1                	mov    %edx,%ecx
  101d6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101d71:	66 89 8c d0 f6 07 00 	mov    %cx,0x7f6(%eax,%edx,8)
  101d78:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101d79:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101d7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101d80:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  101d86:	0f 86 2a ff ff ff    	jbe    101cb6 <idt_init+0x20>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101d8c:	c7 c2 02 05 11 00    	mov    $0x110502,%edx
  101d92:	8b 92 e4 01 00 00    	mov    0x1e4(%edx),%edx
  101d98:	66 89 90 b8 0b 00 00 	mov    %dx,0xbb8(%eax)
  101d9f:	66 c7 80 ba 0b 00 00 	movw   $0x8,0xbba(%eax)
  101da6:	08 00 
  101da8:	0f b6 90 bc 0b 00 00 	movzbl 0xbbc(%eax),%edx
  101daf:	83 e2 e0             	and    $0xffffffe0,%edx
  101db2:	88 90 bc 0b 00 00    	mov    %dl,0xbbc(%eax)
  101db8:	0f b6 90 bc 0b 00 00 	movzbl 0xbbc(%eax),%edx
  101dbf:	83 e2 1f             	and    $0x1f,%edx
  101dc2:	88 90 bc 0b 00 00    	mov    %dl,0xbbc(%eax)
  101dc8:	0f b6 90 bd 0b 00 00 	movzbl 0xbbd(%eax),%edx
  101dcf:	83 e2 f0             	and    $0xfffffff0,%edx
  101dd2:	83 ca 0e             	or     $0xe,%edx
  101dd5:	88 90 bd 0b 00 00    	mov    %dl,0xbbd(%eax)
  101ddb:	0f b6 90 bd 0b 00 00 	movzbl 0xbbd(%eax),%edx
  101de2:	83 e2 ef             	and    $0xffffffef,%edx
  101de5:	88 90 bd 0b 00 00    	mov    %dl,0xbbd(%eax)
  101deb:	0f b6 90 bd 0b 00 00 	movzbl 0xbbd(%eax),%edx
  101df2:	83 ca 60             	or     $0x60,%edx
  101df5:	88 90 bd 0b 00 00    	mov    %dl,0xbbd(%eax)
  101dfb:	0f b6 90 bd 0b 00 00 	movzbl 0xbbd(%eax),%edx
  101e02:	83 ca 80             	or     $0xffffff80,%edx
  101e05:	88 90 bd 0b 00 00    	mov    %dl,0xbbd(%eax)
  101e0b:	c7 c2 02 05 11 00    	mov    $0x110502,%edx
  101e11:	8b 92 e4 01 00 00    	mov    0x1e4(%edx),%edx
  101e17:	c1 ea 10             	shr    $0x10,%edx
  101e1a:	66 89 90 be 0b 00 00 	mov    %dx,0xbbe(%eax)
  101e21:	8d 80 50 00 00 00    	lea    0x50(%eax),%eax
  101e27:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101e2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101e2d:	0f 01 18             	lidtl  (%eax)
}
  101e30:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  101e31:	90                   	nop
  101e32:	c9                   	leave  
  101e33:	c3                   	ret    

00101e34 <trapname>:

static const char *
trapname(int trapno) {
  101e34:	f3 0f 1e fb          	endbr32 
  101e38:	55                   	push   %ebp
  101e39:	89 e5                	mov    %esp,%ebp
  101e3b:	e8 70 e4 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101e40:	05 10 eb 00 00       	add    $0xeb10,%eax
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101e45:	8b 55 08             	mov    0x8(%ebp),%edx
  101e48:	83 fa 13             	cmp    $0x13,%edx
  101e4b:	77 0c                	ja     101e59 <trapname+0x25>
        return excnames[trapno];
  101e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  101e50:	8b 84 90 f0 00 00 00 	mov    0xf0(%eax,%edx,4),%eax
  101e57:	eb 1a                	jmp    101e73 <trapname+0x3f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101e59:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101e5d:	7e 0e                	jle    101e6d <trapname+0x39>
  101e5f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101e63:	7f 08                	jg     101e6d <trapname+0x39>
        return "Hardware Interrupt";
  101e65:	8d 80 51 36 ff ff    	lea    -0xc9af(%eax),%eax
  101e6b:	eb 06                	jmp    101e73 <trapname+0x3f>
    }
    return "(unknown trap)";
  101e6d:	8d 80 64 36 ff ff    	lea    -0xc99c(%eax),%eax
}
  101e73:	5d                   	pop    %ebp
  101e74:	c3                   	ret    

00101e75 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101e75:	f3 0f 1e fb          	endbr32 
  101e79:	55                   	push   %ebp
  101e7a:	89 e5                	mov    %esp,%ebp
  101e7c:	e8 2f e4 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  101e81:	05 cf ea 00 00       	add    $0xeacf,%eax
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101e86:	8b 45 08             	mov    0x8(%ebp),%eax
  101e89:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e8d:	66 83 f8 08          	cmp    $0x8,%ax
  101e91:	0f 94 c0             	sete   %al
  101e94:	0f b6 c0             	movzbl %al,%eax
}
  101e97:	5d                   	pop    %ebp
  101e98:	c3                   	ret    

00101e99 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101e99:	f3 0f 1e fb          	endbr32 
  101e9d:	55                   	push   %ebp
  101e9e:	89 e5                	mov    %esp,%ebp
  101ea0:	53                   	push   %ebx
  101ea1:	83 ec 14             	sub    $0x14,%esp
  101ea4:	e8 0b e4 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  101ea9:	81 c3 a7 ea 00 00    	add    $0xeaa7,%ebx
    cprintf("trapframe at %p\n", tf);
  101eaf:	83 ec 08             	sub    $0x8,%esp
  101eb2:	ff 75 08             	pushl  0x8(%ebp)
  101eb5:	8d 83 a5 36 ff ff    	lea    -0xc95b(%ebx),%eax
  101ebb:	50                   	push   %eax
  101ebc:	e8 6e e4 ff ff       	call   10032f <cprintf>
  101ec1:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec7:	83 ec 0c             	sub    $0xc,%esp
  101eca:	50                   	push   %eax
  101ecb:	e8 d1 01 00 00       	call   1020a1 <print_regs>
  101ed0:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed6:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101eda:	0f b7 c0             	movzwl %ax,%eax
  101edd:	83 ec 08             	sub    $0x8,%esp
  101ee0:	50                   	push   %eax
  101ee1:	8d 83 b6 36 ff ff    	lea    -0xc94a(%ebx),%eax
  101ee7:	50                   	push   %eax
  101ee8:	e8 42 e4 ff ff       	call   10032f <cprintf>
  101eed:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ef7:	0f b7 c0             	movzwl %ax,%eax
  101efa:	83 ec 08             	sub    $0x8,%esp
  101efd:	50                   	push   %eax
  101efe:	8d 83 c9 36 ff ff    	lea    -0xc937(%ebx),%eax
  101f04:	50                   	push   %eax
  101f05:	e8 25 e4 ff ff       	call   10032f <cprintf>
  101f0a:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f10:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101f14:	0f b7 c0             	movzwl %ax,%eax
  101f17:	83 ec 08             	sub    $0x8,%esp
  101f1a:	50                   	push   %eax
  101f1b:	8d 83 dc 36 ff ff    	lea    -0xc924(%ebx),%eax
  101f21:	50                   	push   %eax
  101f22:	e8 08 e4 ff ff       	call   10032f <cprintf>
  101f27:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101f31:	0f b7 c0             	movzwl %ax,%eax
  101f34:	83 ec 08             	sub    $0x8,%esp
  101f37:	50                   	push   %eax
  101f38:	8d 83 ef 36 ff ff    	lea    -0xc911(%ebx),%eax
  101f3e:	50                   	push   %eax
  101f3f:	e8 eb e3 ff ff       	call   10032f <cprintf>
  101f44:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101f47:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4a:	8b 40 30             	mov    0x30(%eax),%eax
  101f4d:	83 ec 0c             	sub    $0xc,%esp
  101f50:	50                   	push   %eax
  101f51:	e8 de fe ff ff       	call   101e34 <trapname>
  101f56:	83 c4 10             	add    $0x10,%esp
  101f59:	8b 55 08             	mov    0x8(%ebp),%edx
  101f5c:	8b 52 30             	mov    0x30(%edx),%edx
  101f5f:	83 ec 04             	sub    $0x4,%esp
  101f62:	50                   	push   %eax
  101f63:	52                   	push   %edx
  101f64:	8d 83 02 37 ff ff    	lea    -0xc8fe(%ebx),%eax
  101f6a:	50                   	push   %eax
  101f6b:	e8 bf e3 ff ff       	call   10032f <cprintf>
  101f70:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101f73:	8b 45 08             	mov    0x8(%ebp),%eax
  101f76:	8b 40 34             	mov    0x34(%eax),%eax
  101f79:	83 ec 08             	sub    $0x8,%esp
  101f7c:	50                   	push   %eax
  101f7d:	8d 83 14 37 ff ff    	lea    -0xc8ec(%ebx),%eax
  101f83:	50                   	push   %eax
  101f84:	e8 a6 e3 ff ff       	call   10032f <cprintf>
  101f89:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8f:	8b 40 38             	mov    0x38(%eax),%eax
  101f92:	83 ec 08             	sub    $0x8,%esp
  101f95:	50                   	push   %eax
  101f96:	8d 83 23 37 ff ff    	lea    -0xc8dd(%ebx),%eax
  101f9c:	50                   	push   %eax
  101f9d:	e8 8d e3 ff ff       	call   10032f <cprintf>
  101fa2:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fac:	0f b7 c0             	movzwl %ax,%eax
  101faf:	83 ec 08             	sub    $0x8,%esp
  101fb2:	50                   	push   %eax
  101fb3:	8d 83 32 37 ff ff    	lea    -0xc8ce(%ebx),%eax
  101fb9:	50                   	push   %eax
  101fba:	e8 70 e3 ff ff       	call   10032f <cprintf>
  101fbf:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc5:	8b 40 40             	mov    0x40(%eax),%eax
  101fc8:	83 ec 08             	sub    $0x8,%esp
  101fcb:	50                   	push   %eax
  101fcc:	8d 83 45 37 ff ff    	lea    -0xc8bb(%ebx),%eax
  101fd2:	50                   	push   %eax
  101fd3:	e8 57 e3 ff ff       	call   10032f <cprintf>
  101fd8:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101fdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101fe2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101fe9:	eb 41                	jmp    10202c <print_trapframe+0x193>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101feb:	8b 45 08             	mov    0x8(%ebp),%eax
  101fee:	8b 50 40             	mov    0x40(%eax),%edx
  101ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ff4:	21 d0                	and    %edx,%eax
  101ff6:	85 c0                	test   %eax,%eax
  101ff8:	74 2b                	je     102025 <print_trapframe+0x18c>
  101ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ffd:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
  102004:	85 c0                	test   %eax,%eax
  102006:	74 1d                	je     102025 <print_trapframe+0x18c>
            cprintf("%s,", IA32flags[i]);
  102008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10200b:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
  102012:	83 ec 08             	sub    $0x8,%esp
  102015:	50                   	push   %eax
  102016:	8d 83 54 37 ff ff    	lea    -0xc8ac(%ebx),%eax
  10201c:	50                   	push   %eax
  10201d:	e8 0d e3 ff ff       	call   10032f <cprintf>
  102022:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  102025:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  102029:	d1 65 f0             	shll   -0x10(%ebp)
  10202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10202f:	83 f8 17             	cmp    $0x17,%eax
  102032:	76 b7                	jbe    101feb <print_trapframe+0x152>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  102034:	8b 45 08             	mov    0x8(%ebp),%eax
  102037:	8b 40 40             	mov    0x40(%eax),%eax
  10203a:	c1 e8 0c             	shr    $0xc,%eax
  10203d:	83 e0 03             	and    $0x3,%eax
  102040:	83 ec 08             	sub    $0x8,%esp
  102043:	50                   	push   %eax
  102044:	8d 83 58 37 ff ff    	lea    -0xc8a8(%ebx),%eax
  10204a:	50                   	push   %eax
  10204b:	e8 df e2 ff ff       	call   10032f <cprintf>
  102050:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  102053:	83 ec 0c             	sub    $0xc,%esp
  102056:	ff 75 08             	pushl  0x8(%ebp)
  102059:	e8 17 fe ff ff       	call   101e75 <trap_in_kernel>
  10205e:	83 c4 10             	add    $0x10,%esp
  102061:	85 c0                	test   %eax,%eax
  102063:	75 36                	jne    10209b <print_trapframe+0x202>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  102065:	8b 45 08             	mov    0x8(%ebp),%eax
  102068:	8b 40 44             	mov    0x44(%eax),%eax
  10206b:	83 ec 08             	sub    $0x8,%esp
  10206e:	50                   	push   %eax
  10206f:	8d 83 61 37 ff ff    	lea    -0xc89f(%ebx),%eax
  102075:	50                   	push   %eax
  102076:	e8 b4 e2 ff ff       	call   10032f <cprintf>
  10207b:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  10207e:	8b 45 08             	mov    0x8(%ebp),%eax
  102081:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  102085:	0f b7 c0             	movzwl %ax,%eax
  102088:	83 ec 08             	sub    $0x8,%esp
  10208b:	50                   	push   %eax
  10208c:	8d 83 70 37 ff ff    	lea    -0xc890(%ebx),%eax
  102092:	50                   	push   %eax
  102093:	e8 97 e2 ff ff       	call   10032f <cprintf>
  102098:	83 c4 10             	add    $0x10,%esp
    }
}
  10209b:	90                   	nop
  10209c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10209f:	c9                   	leave  
  1020a0:	c3                   	ret    

001020a1 <print_regs>:

void
print_regs(struct pushregs *regs) {
  1020a1:	f3 0f 1e fb          	endbr32 
  1020a5:	55                   	push   %ebp
  1020a6:	89 e5                	mov    %esp,%ebp
  1020a8:	53                   	push   %ebx
  1020a9:	83 ec 04             	sub    $0x4,%esp
  1020ac:	e8 03 e2 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  1020b1:	81 c3 9f e8 00 00    	add    $0xe89f,%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  1020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ba:	8b 00                	mov    (%eax),%eax
  1020bc:	83 ec 08             	sub    $0x8,%esp
  1020bf:	50                   	push   %eax
  1020c0:	8d 83 83 37 ff ff    	lea    -0xc87d(%ebx),%eax
  1020c6:	50                   	push   %eax
  1020c7:	e8 63 e2 ff ff       	call   10032f <cprintf>
  1020cc:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  1020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1020d2:	8b 40 04             	mov    0x4(%eax),%eax
  1020d5:	83 ec 08             	sub    $0x8,%esp
  1020d8:	50                   	push   %eax
  1020d9:	8d 83 92 37 ff ff    	lea    -0xc86e(%ebx),%eax
  1020df:	50                   	push   %eax
  1020e0:	e8 4a e2 ff ff       	call   10032f <cprintf>
  1020e5:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  1020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1020eb:	8b 40 08             	mov    0x8(%eax),%eax
  1020ee:	83 ec 08             	sub    $0x8,%esp
  1020f1:	50                   	push   %eax
  1020f2:	8d 83 a1 37 ff ff    	lea    -0xc85f(%ebx),%eax
  1020f8:	50                   	push   %eax
  1020f9:	e8 31 e2 ff ff       	call   10032f <cprintf>
  1020fe:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  102101:	8b 45 08             	mov    0x8(%ebp),%eax
  102104:	8b 40 0c             	mov    0xc(%eax),%eax
  102107:	83 ec 08             	sub    $0x8,%esp
  10210a:	50                   	push   %eax
  10210b:	8d 83 b0 37 ff ff    	lea    -0xc850(%ebx),%eax
  102111:	50                   	push   %eax
  102112:	e8 18 e2 ff ff       	call   10032f <cprintf>
  102117:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  10211a:	8b 45 08             	mov    0x8(%ebp),%eax
  10211d:	8b 40 10             	mov    0x10(%eax),%eax
  102120:	83 ec 08             	sub    $0x8,%esp
  102123:	50                   	push   %eax
  102124:	8d 83 bf 37 ff ff    	lea    -0xc841(%ebx),%eax
  10212a:	50                   	push   %eax
  10212b:	e8 ff e1 ff ff       	call   10032f <cprintf>
  102130:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  102133:	8b 45 08             	mov    0x8(%ebp),%eax
  102136:	8b 40 14             	mov    0x14(%eax),%eax
  102139:	83 ec 08             	sub    $0x8,%esp
  10213c:	50                   	push   %eax
  10213d:	8d 83 ce 37 ff ff    	lea    -0xc832(%ebx),%eax
  102143:	50                   	push   %eax
  102144:	e8 e6 e1 ff ff       	call   10032f <cprintf>
  102149:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  10214c:	8b 45 08             	mov    0x8(%ebp),%eax
  10214f:	8b 40 18             	mov    0x18(%eax),%eax
  102152:	83 ec 08             	sub    $0x8,%esp
  102155:	50                   	push   %eax
  102156:	8d 83 dd 37 ff ff    	lea    -0xc823(%ebx),%eax
  10215c:	50                   	push   %eax
  10215d:	e8 cd e1 ff ff       	call   10032f <cprintf>
  102162:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  102165:	8b 45 08             	mov    0x8(%ebp),%eax
  102168:	8b 40 1c             	mov    0x1c(%eax),%eax
  10216b:	83 ec 08             	sub    $0x8,%esp
  10216e:	50                   	push   %eax
  10216f:	8d 83 ec 37 ff ff    	lea    -0xc814(%ebx),%eax
  102175:	50                   	push   %eax
  102176:	e8 b4 e1 ff ff       	call   10032f <cprintf>
  10217b:	83 c4 10             	add    $0x10,%esp
}
  10217e:	90                   	nop
  10217f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102182:	c9                   	leave  
  102183:	c3                   	ret    

00102184 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  102184:	f3 0f 1e fb          	endbr32 
  102188:	55                   	push   %ebp
  102189:	89 e5                	mov    %esp,%ebp
  10218b:	57                   	push   %edi
  10218c:	56                   	push   %esi
  10218d:	53                   	push   %ebx
  10218e:	83 ec 1c             	sub    $0x1c,%esp
  102191:	e8 1e e1 ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  102196:	81 c3 ba e7 00 00    	add    $0xe7ba,%ebx
    char c;

    switch (tf->tf_trapno) {
  10219c:	8b 45 08             	mov    0x8(%ebp),%eax
  10219f:	8b 40 30             	mov    0x30(%eax),%eax
  1021a2:	83 f8 79             	cmp    $0x79,%eax
  1021a5:	0f 84 9c 01 00 00    	je     102347 <trap_dispatch+0x1c3>
  1021ab:	83 f8 79             	cmp    $0x79,%eax
  1021ae:	0f 87 13 02 00 00    	ja     1023c7 <trap_dispatch+0x243>
  1021b4:	83 f8 78             	cmp    $0x78,%eax
  1021b7:	0f 84 cc 00 00 00    	je     102289 <trap_dispatch+0x105>
  1021bd:	83 f8 78             	cmp    $0x78,%eax
  1021c0:	0f 87 01 02 00 00    	ja     1023c7 <trap_dispatch+0x243>
  1021c6:	83 f8 2f             	cmp    $0x2f,%eax
  1021c9:	0f 87 f8 01 00 00    	ja     1023c7 <trap_dispatch+0x243>
  1021cf:	83 f8 2e             	cmp    $0x2e,%eax
  1021d2:	0f 83 29 02 00 00    	jae    102401 <trap_dispatch+0x27d>
  1021d8:	83 f8 24             	cmp    $0x24,%eax
  1021db:	74 5a                	je     102237 <trap_dispatch+0xb3>
  1021dd:	83 f8 24             	cmp    $0x24,%eax
  1021e0:	0f 87 e1 01 00 00    	ja     1023c7 <trap_dispatch+0x243>
  1021e6:	83 f8 20             	cmp    $0x20,%eax
  1021e9:	74 0a                	je     1021f5 <trap_dispatch+0x71>
  1021eb:	83 f8 21             	cmp    $0x21,%eax
  1021ee:	74 70                	je     102260 <trap_dispatch+0xdc>
  1021f0:	e9 d2 01 00 00       	jmp    1023c7 <trap_dispatch+0x243>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  1021f5:	c7 c0 a8 19 11 00    	mov    $0x1119a8,%eax
  1021fb:	8b 00                	mov    (%eax),%eax
  1021fd:	8d 50 01             	lea    0x1(%eax),%edx
  102200:	c7 c0 a8 19 11 00    	mov    $0x1119a8,%eax
  102206:	89 10                	mov    %edx,(%eax)
        if (ticks % TICK_NUM == 0) {
  102208:	c7 c0 a8 19 11 00    	mov    $0x1119a8,%eax
  10220e:	8b 08                	mov    (%eax),%ecx
  102210:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  102215:	89 c8                	mov    %ecx,%eax
  102217:	f7 e2                	mul    %edx
  102219:	89 d0                	mov    %edx,%eax
  10221b:	c1 e8 05             	shr    $0x5,%eax
  10221e:	6b c0 64             	imul   $0x64,%eax,%eax
  102221:	29 c1                	sub    %eax,%ecx
  102223:	89 c8                	mov    %ecx,%eax
  102225:	85 c0                	test   %eax,%eax
  102227:	0f 85 d7 01 00 00    	jne    102404 <trap_dispatch+0x280>
            print_ticks();
  10222d:	e8 33 fa ff ff       	call   101c65 <print_ticks>
        }
        break;
  102232:	e9 cd 01 00 00       	jmp    102404 <trap_dispatch+0x280>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  102237:	e8 83 f7 ff ff       	call   1019bf <cons_getc>
  10223c:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  10223f:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  102243:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  102247:	83 ec 04             	sub    $0x4,%esp
  10224a:	52                   	push   %edx
  10224b:	50                   	push   %eax
  10224c:	8d 83 fb 37 ff ff    	lea    -0xc805(%ebx),%eax
  102252:	50                   	push   %eax
  102253:	e8 d7 e0 ff ff       	call   10032f <cprintf>
  102258:	83 c4 10             	add    $0x10,%esp
        break;
  10225b:	e9 ab 01 00 00       	jmp    10240b <trap_dispatch+0x287>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  102260:	e8 5a f7 ff ff       	call   1019bf <cons_getc>
  102265:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  102268:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  10226c:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  102270:	83 ec 04             	sub    $0x4,%esp
  102273:	52                   	push   %edx
  102274:	50                   	push   %eax
  102275:	8d 83 0d 38 ff ff    	lea    -0xc7f3(%ebx),%eax
  10227b:	50                   	push   %eax
  10227c:	e8 ae e0 ff ff       	call   10032f <cprintf>
  102281:	83 c4 10             	add    $0x10,%esp
        break;
  102284:	e9 82 01 00 00       	jmp    10240b <trap_dispatch+0x287>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  102289:	8b 45 08             	mov    0x8(%ebp),%eax
  10228c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102290:	66 83 f8 1b          	cmp    $0x1b,%ax
  102294:	0f 84 6d 01 00 00    	je     102407 <trap_dispatch+0x283>
            switchk2u = *tf;
  10229a:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  1022a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1022a3:	89 d6                	mov    %edx,%esi
  1022a5:	ba 4c 00 00 00       	mov    $0x4c,%edx
  1022aa:	8b 0e                	mov    (%esi),%ecx
  1022ac:	89 08                	mov    %ecx,(%eax)
  1022ae:	8b 4c 16 fc          	mov    -0x4(%esi,%edx,1),%ecx
  1022b2:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  1022b6:	8d 78 04             	lea    0x4(%eax),%edi
  1022b9:	83 e7 fc             	and    $0xfffffffc,%edi
  1022bc:	29 f8                	sub    %edi,%eax
  1022be:	29 c6                	sub    %eax,%esi
  1022c0:	01 c2                	add    %eax,%edx
  1022c2:	83 e2 fc             	and    $0xfffffffc,%edx
  1022c5:	89 d0                	mov    %edx,%eax
  1022c7:	c1 e8 02             	shr    $0x2,%eax
  1022ca:	89 c1                	mov    %eax,%ecx
  1022cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  1022ce:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  1022d4:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  1022da:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  1022e0:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  1022e6:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  1022ec:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  1022f0:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  1022f6:	66 89 50 28          	mov    %dx,0x28(%eax)
  1022fa:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  102300:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102304:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  10230a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  10230e:	8b 45 08             	mov    0x8(%ebp),%eax
  102311:	8d 50 44             	lea    0x44(%eax),%edx
  102314:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  10231a:	89 50 44             	mov    %edx,0x44(%eax)
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  10231d:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  102323:	8b 40 40             	mov    0x40(%eax),%eax
  102326:	80 cc 30             	or     $0x30,%ah
  102329:	89 c2                	mov    %eax,%edx
  10232b:	c7 c0 c0 19 11 00    	mov    $0x1119c0,%eax
  102331:	89 50 40             	mov    %edx,0x40(%eax)
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  102334:	8b 45 08             	mov    0x8(%ebp),%eax
  102337:	83 e8 04             	sub    $0x4,%eax
  10233a:	c7 c2 c0 19 11 00    	mov    $0x1119c0,%edx
  102340:	89 10                	mov    %edx,(%eax)
        }
        break;
  102342:	e9 c0 00 00 00       	jmp    102407 <trap_dispatch+0x283>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  102347:	8b 45 08             	mov    0x8(%ebp),%eax
  10234a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10234e:	66 83 f8 08          	cmp    $0x8,%ax
  102352:	0f 84 b2 00 00 00    	je     10240a <trap_dispatch+0x286>
            tf->tf_cs = KERNEL_CS;
  102358:	8b 45 08             	mov    0x8(%ebp),%eax
  10235b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  102361:	8b 45 08             	mov    0x8(%ebp),%eax
  102364:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  10236a:	8b 45 08             	mov    0x8(%ebp),%eax
  10236d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102371:	8b 45 08             	mov    0x8(%ebp),%eax
  102374:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  102378:	8b 45 08             	mov    0x8(%ebp),%eax
  10237b:	8b 40 40             	mov    0x40(%eax),%eax
  10237e:	80 e4 cf             	and    $0xcf,%ah
  102381:	89 c2                	mov    %eax,%edx
  102383:	8b 45 08             	mov    0x8(%ebp),%eax
  102386:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  102389:	8b 45 08             	mov    0x8(%ebp),%eax
  10238c:	8b 40 44             	mov    0x44(%eax),%eax
  10238f:	83 e8 44             	sub    $0x44,%eax
  102392:	89 c2                	mov    %eax,%edx
  102394:	c7 c0 0c 1a 11 00    	mov    $0x111a0c,%eax
  10239a:	89 10                	mov    %edx,(%eax)
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  10239c:	c7 c0 0c 1a 11 00    	mov    $0x111a0c,%eax
  1023a2:	8b 00                	mov    (%eax),%eax
  1023a4:	83 ec 04             	sub    $0x4,%esp
  1023a7:	6a 44                	push   $0x44
  1023a9:	ff 75 08             	pushl  0x8(%ebp)
  1023ac:	50                   	push   %eax
  1023ad:	e8 92 10 00 00       	call   103444 <memmove>
  1023b2:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  1023b5:	c7 c0 0c 1a 11 00    	mov    $0x111a0c,%eax
  1023bb:	8b 10                	mov    (%eax),%edx
  1023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1023c0:	83 e8 04             	sub    $0x4,%eax
  1023c3:	89 10                	mov    %edx,(%eax)
        }
        break;
  1023c5:	eb 43                	jmp    10240a <trap_dispatch+0x286>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  1023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1023ca:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1023ce:	0f b7 c0             	movzwl %ax,%eax
  1023d1:	83 e0 03             	and    $0x3,%eax
  1023d4:	85 c0                	test   %eax,%eax
  1023d6:	75 33                	jne    10240b <trap_dispatch+0x287>
            print_trapframe(tf);
  1023d8:	83 ec 0c             	sub    $0xc,%esp
  1023db:	ff 75 08             	pushl  0x8(%ebp)
  1023de:	e8 b6 fa ff ff       	call   101e99 <print_trapframe>
  1023e3:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  1023e6:	83 ec 04             	sub    $0x4,%esp
  1023e9:	8d 83 1c 38 ff ff    	lea    -0xc7e4(%ebx),%eax
  1023ef:	50                   	push   %eax
  1023f0:	68 d2 00 00 00       	push   $0xd2
  1023f5:	8d 83 38 38 ff ff    	lea    -0xc7c8(%ebx),%eax
  1023fb:	50                   	push   %eax
  1023fc:	e8 f3 e0 ff ff       	call   1004f4 <__panic>
        break;
  102401:	90                   	nop
  102402:	eb 07                	jmp    10240b <trap_dispatch+0x287>
        break;
  102404:	90                   	nop
  102405:	eb 04                	jmp    10240b <trap_dispatch+0x287>
        break;
  102407:	90                   	nop
  102408:	eb 01                	jmp    10240b <trap_dispatch+0x287>
        break;
  10240a:	90                   	nop
        }
    }
}
  10240b:	90                   	nop
  10240c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  10240f:	5b                   	pop    %ebx
  102410:	5e                   	pop    %esi
  102411:	5f                   	pop    %edi
  102412:	5d                   	pop    %ebp
  102413:	c3                   	ret    

00102414 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102414:	f3 0f 1e fb          	endbr32 
  102418:	55                   	push   %ebp
  102419:	89 e5                	mov    %esp,%ebp
  10241b:	83 ec 08             	sub    $0x8,%esp
  10241e:	e8 8d de ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  102423:	05 2d e5 00 00       	add    $0xe52d,%eax
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102428:	83 ec 0c             	sub    $0xc,%esp
  10242b:	ff 75 08             	pushl  0x8(%ebp)
  10242e:	e8 51 fd ff ff       	call   102184 <trap_dispatch>
  102433:	83 c4 10             	add    $0x10,%esp
}
  102436:	90                   	nop
  102437:	c9                   	leave  
  102438:	c3                   	ret    

00102439 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $0
  10243b:	6a 00                	push   $0x0
  jmp __alltraps
  10243d:	e9 67 0a 00 00       	jmp    102ea9 <__alltraps>

00102442 <vector1>:
.globl vector1
vector1:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $1
  102444:	6a 01                	push   $0x1
  jmp __alltraps
  102446:	e9 5e 0a 00 00       	jmp    102ea9 <__alltraps>

0010244b <vector2>:
.globl vector2
vector2:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $2
  10244d:	6a 02                	push   $0x2
  jmp __alltraps
  10244f:	e9 55 0a 00 00       	jmp    102ea9 <__alltraps>

00102454 <vector3>:
.globl vector3
vector3:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $3
  102456:	6a 03                	push   $0x3
  jmp __alltraps
  102458:	e9 4c 0a 00 00       	jmp    102ea9 <__alltraps>

0010245d <vector4>:
.globl vector4
vector4:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $4
  10245f:	6a 04                	push   $0x4
  jmp __alltraps
  102461:	e9 43 0a 00 00       	jmp    102ea9 <__alltraps>

00102466 <vector5>:
.globl vector5
vector5:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $5
  102468:	6a 05                	push   $0x5
  jmp __alltraps
  10246a:	e9 3a 0a 00 00       	jmp    102ea9 <__alltraps>

0010246f <vector6>:
.globl vector6
vector6:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $6
  102471:	6a 06                	push   $0x6
  jmp __alltraps
  102473:	e9 31 0a 00 00       	jmp    102ea9 <__alltraps>

00102478 <vector7>:
.globl vector7
vector7:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $7
  10247a:	6a 07                	push   $0x7
  jmp __alltraps
  10247c:	e9 28 0a 00 00       	jmp    102ea9 <__alltraps>

00102481 <vector8>:
.globl vector8
vector8:
  pushl $8
  102481:	6a 08                	push   $0x8
  jmp __alltraps
  102483:	e9 21 0a 00 00       	jmp    102ea9 <__alltraps>

00102488 <vector9>:
.globl vector9
vector9:
  pushl $9
  102488:	6a 09                	push   $0x9
  jmp __alltraps
  10248a:	e9 1a 0a 00 00       	jmp    102ea9 <__alltraps>

0010248f <vector10>:
.globl vector10
vector10:
  pushl $10
  10248f:	6a 0a                	push   $0xa
  jmp __alltraps
  102491:	e9 13 0a 00 00       	jmp    102ea9 <__alltraps>

00102496 <vector11>:
.globl vector11
vector11:
  pushl $11
  102496:	6a 0b                	push   $0xb
  jmp __alltraps
  102498:	e9 0c 0a 00 00       	jmp    102ea9 <__alltraps>

0010249d <vector12>:
.globl vector12
vector12:
  pushl $12
  10249d:	6a 0c                	push   $0xc
  jmp __alltraps
  10249f:	e9 05 0a 00 00       	jmp    102ea9 <__alltraps>

001024a4 <vector13>:
.globl vector13
vector13:
  pushl $13
  1024a4:	6a 0d                	push   $0xd
  jmp __alltraps
  1024a6:	e9 fe 09 00 00       	jmp    102ea9 <__alltraps>

001024ab <vector14>:
.globl vector14
vector14:
  pushl $14
  1024ab:	6a 0e                	push   $0xe
  jmp __alltraps
  1024ad:	e9 f7 09 00 00       	jmp    102ea9 <__alltraps>

001024b2 <vector15>:
.globl vector15
vector15:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $15
  1024b4:	6a 0f                	push   $0xf
  jmp __alltraps
  1024b6:	e9 ee 09 00 00       	jmp    102ea9 <__alltraps>

001024bb <vector16>:
.globl vector16
vector16:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $16
  1024bd:	6a 10                	push   $0x10
  jmp __alltraps
  1024bf:	e9 e5 09 00 00       	jmp    102ea9 <__alltraps>

001024c4 <vector17>:
.globl vector17
vector17:
  pushl $17
  1024c4:	6a 11                	push   $0x11
  jmp __alltraps
  1024c6:	e9 de 09 00 00       	jmp    102ea9 <__alltraps>

001024cb <vector18>:
.globl vector18
vector18:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $18
  1024cd:	6a 12                	push   $0x12
  jmp __alltraps
  1024cf:	e9 d5 09 00 00       	jmp    102ea9 <__alltraps>

001024d4 <vector19>:
.globl vector19
vector19:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $19
  1024d6:	6a 13                	push   $0x13
  jmp __alltraps
  1024d8:	e9 cc 09 00 00       	jmp    102ea9 <__alltraps>

001024dd <vector20>:
.globl vector20
vector20:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $20
  1024df:	6a 14                	push   $0x14
  jmp __alltraps
  1024e1:	e9 c3 09 00 00       	jmp    102ea9 <__alltraps>

001024e6 <vector21>:
.globl vector21
vector21:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $21
  1024e8:	6a 15                	push   $0x15
  jmp __alltraps
  1024ea:	e9 ba 09 00 00       	jmp    102ea9 <__alltraps>

001024ef <vector22>:
.globl vector22
vector22:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $22
  1024f1:	6a 16                	push   $0x16
  jmp __alltraps
  1024f3:	e9 b1 09 00 00       	jmp    102ea9 <__alltraps>

001024f8 <vector23>:
.globl vector23
vector23:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $23
  1024fa:	6a 17                	push   $0x17
  jmp __alltraps
  1024fc:	e9 a8 09 00 00       	jmp    102ea9 <__alltraps>

00102501 <vector24>:
.globl vector24
vector24:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $24
  102503:	6a 18                	push   $0x18
  jmp __alltraps
  102505:	e9 9f 09 00 00       	jmp    102ea9 <__alltraps>

0010250a <vector25>:
.globl vector25
vector25:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $25
  10250c:	6a 19                	push   $0x19
  jmp __alltraps
  10250e:	e9 96 09 00 00       	jmp    102ea9 <__alltraps>

00102513 <vector26>:
.globl vector26
vector26:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $26
  102515:	6a 1a                	push   $0x1a
  jmp __alltraps
  102517:	e9 8d 09 00 00       	jmp    102ea9 <__alltraps>

0010251c <vector27>:
.globl vector27
vector27:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $27
  10251e:	6a 1b                	push   $0x1b
  jmp __alltraps
  102520:	e9 84 09 00 00       	jmp    102ea9 <__alltraps>

00102525 <vector28>:
.globl vector28
vector28:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $28
  102527:	6a 1c                	push   $0x1c
  jmp __alltraps
  102529:	e9 7b 09 00 00       	jmp    102ea9 <__alltraps>

0010252e <vector29>:
.globl vector29
vector29:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $29
  102530:	6a 1d                	push   $0x1d
  jmp __alltraps
  102532:	e9 72 09 00 00       	jmp    102ea9 <__alltraps>

00102537 <vector30>:
.globl vector30
vector30:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $30
  102539:	6a 1e                	push   $0x1e
  jmp __alltraps
  10253b:	e9 69 09 00 00       	jmp    102ea9 <__alltraps>

00102540 <vector31>:
.globl vector31
vector31:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $31
  102542:	6a 1f                	push   $0x1f
  jmp __alltraps
  102544:	e9 60 09 00 00       	jmp    102ea9 <__alltraps>

00102549 <vector32>:
.globl vector32
vector32:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $32
  10254b:	6a 20                	push   $0x20
  jmp __alltraps
  10254d:	e9 57 09 00 00       	jmp    102ea9 <__alltraps>

00102552 <vector33>:
.globl vector33
vector33:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $33
  102554:	6a 21                	push   $0x21
  jmp __alltraps
  102556:	e9 4e 09 00 00       	jmp    102ea9 <__alltraps>

0010255b <vector34>:
.globl vector34
vector34:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $34
  10255d:	6a 22                	push   $0x22
  jmp __alltraps
  10255f:	e9 45 09 00 00       	jmp    102ea9 <__alltraps>

00102564 <vector35>:
.globl vector35
vector35:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $35
  102566:	6a 23                	push   $0x23
  jmp __alltraps
  102568:	e9 3c 09 00 00       	jmp    102ea9 <__alltraps>

0010256d <vector36>:
.globl vector36
vector36:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $36
  10256f:	6a 24                	push   $0x24
  jmp __alltraps
  102571:	e9 33 09 00 00       	jmp    102ea9 <__alltraps>

00102576 <vector37>:
.globl vector37
vector37:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $37
  102578:	6a 25                	push   $0x25
  jmp __alltraps
  10257a:	e9 2a 09 00 00       	jmp    102ea9 <__alltraps>

0010257f <vector38>:
.globl vector38
vector38:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $38
  102581:	6a 26                	push   $0x26
  jmp __alltraps
  102583:	e9 21 09 00 00       	jmp    102ea9 <__alltraps>

00102588 <vector39>:
.globl vector39
vector39:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $39
  10258a:	6a 27                	push   $0x27
  jmp __alltraps
  10258c:	e9 18 09 00 00       	jmp    102ea9 <__alltraps>

00102591 <vector40>:
.globl vector40
vector40:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $40
  102593:	6a 28                	push   $0x28
  jmp __alltraps
  102595:	e9 0f 09 00 00       	jmp    102ea9 <__alltraps>

0010259a <vector41>:
.globl vector41
vector41:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $41
  10259c:	6a 29                	push   $0x29
  jmp __alltraps
  10259e:	e9 06 09 00 00       	jmp    102ea9 <__alltraps>

001025a3 <vector42>:
.globl vector42
vector42:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $42
  1025a5:	6a 2a                	push   $0x2a
  jmp __alltraps
  1025a7:	e9 fd 08 00 00       	jmp    102ea9 <__alltraps>

001025ac <vector43>:
.globl vector43
vector43:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $43
  1025ae:	6a 2b                	push   $0x2b
  jmp __alltraps
  1025b0:	e9 f4 08 00 00       	jmp    102ea9 <__alltraps>

001025b5 <vector44>:
.globl vector44
vector44:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $44
  1025b7:	6a 2c                	push   $0x2c
  jmp __alltraps
  1025b9:	e9 eb 08 00 00       	jmp    102ea9 <__alltraps>

001025be <vector45>:
.globl vector45
vector45:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $45
  1025c0:	6a 2d                	push   $0x2d
  jmp __alltraps
  1025c2:	e9 e2 08 00 00       	jmp    102ea9 <__alltraps>

001025c7 <vector46>:
.globl vector46
vector46:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $46
  1025c9:	6a 2e                	push   $0x2e
  jmp __alltraps
  1025cb:	e9 d9 08 00 00       	jmp    102ea9 <__alltraps>

001025d0 <vector47>:
.globl vector47
vector47:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $47
  1025d2:	6a 2f                	push   $0x2f
  jmp __alltraps
  1025d4:	e9 d0 08 00 00       	jmp    102ea9 <__alltraps>

001025d9 <vector48>:
.globl vector48
vector48:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $48
  1025db:	6a 30                	push   $0x30
  jmp __alltraps
  1025dd:	e9 c7 08 00 00       	jmp    102ea9 <__alltraps>

001025e2 <vector49>:
.globl vector49
vector49:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $49
  1025e4:	6a 31                	push   $0x31
  jmp __alltraps
  1025e6:	e9 be 08 00 00       	jmp    102ea9 <__alltraps>

001025eb <vector50>:
.globl vector50
vector50:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $50
  1025ed:	6a 32                	push   $0x32
  jmp __alltraps
  1025ef:	e9 b5 08 00 00       	jmp    102ea9 <__alltraps>

001025f4 <vector51>:
.globl vector51
vector51:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $51
  1025f6:	6a 33                	push   $0x33
  jmp __alltraps
  1025f8:	e9 ac 08 00 00       	jmp    102ea9 <__alltraps>

001025fd <vector52>:
.globl vector52
vector52:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $52
  1025ff:	6a 34                	push   $0x34
  jmp __alltraps
  102601:	e9 a3 08 00 00       	jmp    102ea9 <__alltraps>

00102606 <vector53>:
.globl vector53
vector53:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $53
  102608:	6a 35                	push   $0x35
  jmp __alltraps
  10260a:	e9 9a 08 00 00       	jmp    102ea9 <__alltraps>

0010260f <vector54>:
.globl vector54
vector54:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $54
  102611:	6a 36                	push   $0x36
  jmp __alltraps
  102613:	e9 91 08 00 00       	jmp    102ea9 <__alltraps>

00102618 <vector55>:
.globl vector55
vector55:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $55
  10261a:	6a 37                	push   $0x37
  jmp __alltraps
  10261c:	e9 88 08 00 00       	jmp    102ea9 <__alltraps>

00102621 <vector56>:
.globl vector56
vector56:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $56
  102623:	6a 38                	push   $0x38
  jmp __alltraps
  102625:	e9 7f 08 00 00       	jmp    102ea9 <__alltraps>

0010262a <vector57>:
.globl vector57
vector57:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $57
  10262c:	6a 39                	push   $0x39
  jmp __alltraps
  10262e:	e9 76 08 00 00       	jmp    102ea9 <__alltraps>

00102633 <vector58>:
.globl vector58
vector58:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $58
  102635:	6a 3a                	push   $0x3a
  jmp __alltraps
  102637:	e9 6d 08 00 00       	jmp    102ea9 <__alltraps>

0010263c <vector59>:
.globl vector59
vector59:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $59
  10263e:	6a 3b                	push   $0x3b
  jmp __alltraps
  102640:	e9 64 08 00 00       	jmp    102ea9 <__alltraps>

00102645 <vector60>:
.globl vector60
vector60:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $60
  102647:	6a 3c                	push   $0x3c
  jmp __alltraps
  102649:	e9 5b 08 00 00       	jmp    102ea9 <__alltraps>

0010264e <vector61>:
.globl vector61
vector61:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $61
  102650:	6a 3d                	push   $0x3d
  jmp __alltraps
  102652:	e9 52 08 00 00       	jmp    102ea9 <__alltraps>

00102657 <vector62>:
.globl vector62
vector62:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $62
  102659:	6a 3e                	push   $0x3e
  jmp __alltraps
  10265b:	e9 49 08 00 00       	jmp    102ea9 <__alltraps>

00102660 <vector63>:
.globl vector63
vector63:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $63
  102662:	6a 3f                	push   $0x3f
  jmp __alltraps
  102664:	e9 40 08 00 00       	jmp    102ea9 <__alltraps>

00102669 <vector64>:
.globl vector64
vector64:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $64
  10266b:	6a 40                	push   $0x40
  jmp __alltraps
  10266d:	e9 37 08 00 00       	jmp    102ea9 <__alltraps>

00102672 <vector65>:
.globl vector65
vector65:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $65
  102674:	6a 41                	push   $0x41
  jmp __alltraps
  102676:	e9 2e 08 00 00       	jmp    102ea9 <__alltraps>

0010267b <vector66>:
.globl vector66
vector66:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $66
  10267d:	6a 42                	push   $0x42
  jmp __alltraps
  10267f:	e9 25 08 00 00       	jmp    102ea9 <__alltraps>

00102684 <vector67>:
.globl vector67
vector67:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $67
  102686:	6a 43                	push   $0x43
  jmp __alltraps
  102688:	e9 1c 08 00 00       	jmp    102ea9 <__alltraps>

0010268d <vector68>:
.globl vector68
vector68:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $68
  10268f:	6a 44                	push   $0x44
  jmp __alltraps
  102691:	e9 13 08 00 00       	jmp    102ea9 <__alltraps>

00102696 <vector69>:
.globl vector69
vector69:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $69
  102698:	6a 45                	push   $0x45
  jmp __alltraps
  10269a:	e9 0a 08 00 00       	jmp    102ea9 <__alltraps>

0010269f <vector70>:
.globl vector70
vector70:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $70
  1026a1:	6a 46                	push   $0x46
  jmp __alltraps
  1026a3:	e9 01 08 00 00       	jmp    102ea9 <__alltraps>

001026a8 <vector71>:
.globl vector71
vector71:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $71
  1026aa:	6a 47                	push   $0x47
  jmp __alltraps
  1026ac:	e9 f8 07 00 00       	jmp    102ea9 <__alltraps>

001026b1 <vector72>:
.globl vector72
vector72:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $72
  1026b3:	6a 48                	push   $0x48
  jmp __alltraps
  1026b5:	e9 ef 07 00 00       	jmp    102ea9 <__alltraps>

001026ba <vector73>:
.globl vector73
vector73:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $73
  1026bc:	6a 49                	push   $0x49
  jmp __alltraps
  1026be:	e9 e6 07 00 00       	jmp    102ea9 <__alltraps>

001026c3 <vector74>:
.globl vector74
vector74:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $74
  1026c5:	6a 4a                	push   $0x4a
  jmp __alltraps
  1026c7:	e9 dd 07 00 00       	jmp    102ea9 <__alltraps>

001026cc <vector75>:
.globl vector75
vector75:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $75
  1026ce:	6a 4b                	push   $0x4b
  jmp __alltraps
  1026d0:	e9 d4 07 00 00       	jmp    102ea9 <__alltraps>

001026d5 <vector76>:
.globl vector76
vector76:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $76
  1026d7:	6a 4c                	push   $0x4c
  jmp __alltraps
  1026d9:	e9 cb 07 00 00       	jmp    102ea9 <__alltraps>

001026de <vector77>:
.globl vector77
vector77:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $77
  1026e0:	6a 4d                	push   $0x4d
  jmp __alltraps
  1026e2:	e9 c2 07 00 00       	jmp    102ea9 <__alltraps>

001026e7 <vector78>:
.globl vector78
vector78:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $78
  1026e9:	6a 4e                	push   $0x4e
  jmp __alltraps
  1026eb:	e9 b9 07 00 00       	jmp    102ea9 <__alltraps>

001026f0 <vector79>:
.globl vector79
vector79:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $79
  1026f2:	6a 4f                	push   $0x4f
  jmp __alltraps
  1026f4:	e9 b0 07 00 00       	jmp    102ea9 <__alltraps>

001026f9 <vector80>:
.globl vector80
vector80:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $80
  1026fb:	6a 50                	push   $0x50
  jmp __alltraps
  1026fd:	e9 a7 07 00 00       	jmp    102ea9 <__alltraps>

00102702 <vector81>:
.globl vector81
vector81:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $81
  102704:	6a 51                	push   $0x51
  jmp __alltraps
  102706:	e9 9e 07 00 00       	jmp    102ea9 <__alltraps>

0010270b <vector82>:
.globl vector82
vector82:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $82
  10270d:	6a 52                	push   $0x52
  jmp __alltraps
  10270f:	e9 95 07 00 00       	jmp    102ea9 <__alltraps>

00102714 <vector83>:
.globl vector83
vector83:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $83
  102716:	6a 53                	push   $0x53
  jmp __alltraps
  102718:	e9 8c 07 00 00       	jmp    102ea9 <__alltraps>

0010271d <vector84>:
.globl vector84
vector84:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $84
  10271f:	6a 54                	push   $0x54
  jmp __alltraps
  102721:	e9 83 07 00 00       	jmp    102ea9 <__alltraps>

00102726 <vector85>:
.globl vector85
vector85:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $85
  102728:	6a 55                	push   $0x55
  jmp __alltraps
  10272a:	e9 7a 07 00 00       	jmp    102ea9 <__alltraps>

0010272f <vector86>:
.globl vector86
vector86:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $86
  102731:	6a 56                	push   $0x56
  jmp __alltraps
  102733:	e9 71 07 00 00       	jmp    102ea9 <__alltraps>

00102738 <vector87>:
.globl vector87
vector87:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $87
  10273a:	6a 57                	push   $0x57
  jmp __alltraps
  10273c:	e9 68 07 00 00       	jmp    102ea9 <__alltraps>

00102741 <vector88>:
.globl vector88
vector88:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $88
  102743:	6a 58                	push   $0x58
  jmp __alltraps
  102745:	e9 5f 07 00 00       	jmp    102ea9 <__alltraps>

0010274a <vector89>:
.globl vector89
vector89:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $89
  10274c:	6a 59                	push   $0x59
  jmp __alltraps
  10274e:	e9 56 07 00 00       	jmp    102ea9 <__alltraps>

00102753 <vector90>:
.globl vector90
vector90:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $90
  102755:	6a 5a                	push   $0x5a
  jmp __alltraps
  102757:	e9 4d 07 00 00       	jmp    102ea9 <__alltraps>

0010275c <vector91>:
.globl vector91
vector91:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $91
  10275e:	6a 5b                	push   $0x5b
  jmp __alltraps
  102760:	e9 44 07 00 00       	jmp    102ea9 <__alltraps>

00102765 <vector92>:
.globl vector92
vector92:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $92
  102767:	6a 5c                	push   $0x5c
  jmp __alltraps
  102769:	e9 3b 07 00 00       	jmp    102ea9 <__alltraps>

0010276e <vector93>:
.globl vector93
vector93:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $93
  102770:	6a 5d                	push   $0x5d
  jmp __alltraps
  102772:	e9 32 07 00 00       	jmp    102ea9 <__alltraps>

00102777 <vector94>:
.globl vector94
vector94:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $94
  102779:	6a 5e                	push   $0x5e
  jmp __alltraps
  10277b:	e9 29 07 00 00       	jmp    102ea9 <__alltraps>

00102780 <vector95>:
.globl vector95
vector95:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $95
  102782:	6a 5f                	push   $0x5f
  jmp __alltraps
  102784:	e9 20 07 00 00       	jmp    102ea9 <__alltraps>

00102789 <vector96>:
.globl vector96
vector96:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $96
  10278b:	6a 60                	push   $0x60
  jmp __alltraps
  10278d:	e9 17 07 00 00       	jmp    102ea9 <__alltraps>

00102792 <vector97>:
.globl vector97
vector97:
  pushl $0
  102792:	6a 00                	push   $0x0
  pushl $97
  102794:	6a 61                	push   $0x61
  jmp __alltraps
  102796:	e9 0e 07 00 00       	jmp    102ea9 <__alltraps>

0010279b <vector98>:
.globl vector98
vector98:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $98
  10279d:	6a 62                	push   $0x62
  jmp __alltraps
  10279f:	e9 05 07 00 00       	jmp    102ea9 <__alltraps>

001027a4 <vector99>:
.globl vector99
vector99:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $99
  1027a6:	6a 63                	push   $0x63
  jmp __alltraps
  1027a8:	e9 fc 06 00 00       	jmp    102ea9 <__alltraps>

001027ad <vector100>:
.globl vector100
vector100:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $100
  1027af:	6a 64                	push   $0x64
  jmp __alltraps
  1027b1:	e9 f3 06 00 00       	jmp    102ea9 <__alltraps>

001027b6 <vector101>:
.globl vector101
vector101:
  pushl $0
  1027b6:	6a 00                	push   $0x0
  pushl $101
  1027b8:	6a 65                	push   $0x65
  jmp __alltraps
  1027ba:	e9 ea 06 00 00       	jmp    102ea9 <__alltraps>

001027bf <vector102>:
.globl vector102
vector102:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $102
  1027c1:	6a 66                	push   $0x66
  jmp __alltraps
  1027c3:	e9 e1 06 00 00       	jmp    102ea9 <__alltraps>

001027c8 <vector103>:
.globl vector103
vector103:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $103
  1027ca:	6a 67                	push   $0x67
  jmp __alltraps
  1027cc:	e9 d8 06 00 00       	jmp    102ea9 <__alltraps>

001027d1 <vector104>:
.globl vector104
vector104:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $104
  1027d3:	6a 68                	push   $0x68
  jmp __alltraps
  1027d5:	e9 cf 06 00 00       	jmp    102ea9 <__alltraps>

001027da <vector105>:
.globl vector105
vector105:
  pushl $0
  1027da:	6a 00                	push   $0x0
  pushl $105
  1027dc:	6a 69                	push   $0x69
  jmp __alltraps
  1027de:	e9 c6 06 00 00       	jmp    102ea9 <__alltraps>

001027e3 <vector106>:
.globl vector106
vector106:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $106
  1027e5:	6a 6a                	push   $0x6a
  jmp __alltraps
  1027e7:	e9 bd 06 00 00       	jmp    102ea9 <__alltraps>

001027ec <vector107>:
.globl vector107
vector107:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $107
  1027ee:	6a 6b                	push   $0x6b
  jmp __alltraps
  1027f0:	e9 b4 06 00 00       	jmp    102ea9 <__alltraps>

001027f5 <vector108>:
.globl vector108
vector108:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $108
  1027f7:	6a 6c                	push   $0x6c
  jmp __alltraps
  1027f9:	e9 ab 06 00 00       	jmp    102ea9 <__alltraps>

001027fe <vector109>:
.globl vector109
vector109:
  pushl $0
  1027fe:	6a 00                	push   $0x0
  pushl $109
  102800:	6a 6d                	push   $0x6d
  jmp __alltraps
  102802:	e9 a2 06 00 00       	jmp    102ea9 <__alltraps>

00102807 <vector110>:
.globl vector110
vector110:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $110
  102809:	6a 6e                	push   $0x6e
  jmp __alltraps
  10280b:	e9 99 06 00 00       	jmp    102ea9 <__alltraps>

00102810 <vector111>:
.globl vector111
vector111:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $111
  102812:	6a 6f                	push   $0x6f
  jmp __alltraps
  102814:	e9 90 06 00 00       	jmp    102ea9 <__alltraps>

00102819 <vector112>:
.globl vector112
vector112:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $112
  10281b:	6a 70                	push   $0x70
  jmp __alltraps
  10281d:	e9 87 06 00 00       	jmp    102ea9 <__alltraps>

00102822 <vector113>:
.globl vector113
vector113:
  pushl $0
  102822:	6a 00                	push   $0x0
  pushl $113
  102824:	6a 71                	push   $0x71
  jmp __alltraps
  102826:	e9 7e 06 00 00       	jmp    102ea9 <__alltraps>

0010282b <vector114>:
.globl vector114
vector114:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $114
  10282d:	6a 72                	push   $0x72
  jmp __alltraps
  10282f:	e9 75 06 00 00       	jmp    102ea9 <__alltraps>

00102834 <vector115>:
.globl vector115
vector115:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $115
  102836:	6a 73                	push   $0x73
  jmp __alltraps
  102838:	e9 6c 06 00 00       	jmp    102ea9 <__alltraps>

0010283d <vector116>:
.globl vector116
vector116:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $116
  10283f:	6a 74                	push   $0x74
  jmp __alltraps
  102841:	e9 63 06 00 00       	jmp    102ea9 <__alltraps>

00102846 <vector117>:
.globl vector117
vector117:
  pushl $0
  102846:	6a 00                	push   $0x0
  pushl $117
  102848:	6a 75                	push   $0x75
  jmp __alltraps
  10284a:	e9 5a 06 00 00       	jmp    102ea9 <__alltraps>

0010284f <vector118>:
.globl vector118
vector118:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $118
  102851:	6a 76                	push   $0x76
  jmp __alltraps
  102853:	e9 51 06 00 00       	jmp    102ea9 <__alltraps>

00102858 <vector119>:
.globl vector119
vector119:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $119
  10285a:	6a 77                	push   $0x77
  jmp __alltraps
  10285c:	e9 48 06 00 00       	jmp    102ea9 <__alltraps>

00102861 <vector120>:
.globl vector120
vector120:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $120
  102863:	6a 78                	push   $0x78
  jmp __alltraps
  102865:	e9 3f 06 00 00       	jmp    102ea9 <__alltraps>

0010286a <vector121>:
.globl vector121
vector121:
  pushl $0
  10286a:	6a 00                	push   $0x0
  pushl $121
  10286c:	6a 79                	push   $0x79
  jmp __alltraps
  10286e:	e9 36 06 00 00       	jmp    102ea9 <__alltraps>

00102873 <vector122>:
.globl vector122
vector122:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $122
  102875:	6a 7a                	push   $0x7a
  jmp __alltraps
  102877:	e9 2d 06 00 00       	jmp    102ea9 <__alltraps>

0010287c <vector123>:
.globl vector123
vector123:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $123
  10287e:	6a 7b                	push   $0x7b
  jmp __alltraps
  102880:	e9 24 06 00 00       	jmp    102ea9 <__alltraps>

00102885 <vector124>:
.globl vector124
vector124:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $124
  102887:	6a 7c                	push   $0x7c
  jmp __alltraps
  102889:	e9 1b 06 00 00       	jmp    102ea9 <__alltraps>

0010288e <vector125>:
.globl vector125
vector125:
  pushl $0
  10288e:	6a 00                	push   $0x0
  pushl $125
  102890:	6a 7d                	push   $0x7d
  jmp __alltraps
  102892:	e9 12 06 00 00       	jmp    102ea9 <__alltraps>

00102897 <vector126>:
.globl vector126
vector126:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $126
  102899:	6a 7e                	push   $0x7e
  jmp __alltraps
  10289b:	e9 09 06 00 00       	jmp    102ea9 <__alltraps>

001028a0 <vector127>:
.globl vector127
vector127:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $127
  1028a2:	6a 7f                	push   $0x7f
  jmp __alltraps
  1028a4:	e9 00 06 00 00       	jmp    102ea9 <__alltraps>

001028a9 <vector128>:
.globl vector128
vector128:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $128
  1028ab:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1028b0:	e9 f4 05 00 00       	jmp    102ea9 <__alltraps>

001028b5 <vector129>:
.globl vector129
vector129:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $129
  1028b7:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1028bc:	e9 e8 05 00 00       	jmp    102ea9 <__alltraps>

001028c1 <vector130>:
.globl vector130
vector130:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $130
  1028c3:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1028c8:	e9 dc 05 00 00       	jmp    102ea9 <__alltraps>

001028cd <vector131>:
.globl vector131
vector131:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $131
  1028cf:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1028d4:	e9 d0 05 00 00       	jmp    102ea9 <__alltraps>

001028d9 <vector132>:
.globl vector132
vector132:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $132
  1028db:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1028e0:	e9 c4 05 00 00       	jmp    102ea9 <__alltraps>

001028e5 <vector133>:
.globl vector133
vector133:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $133
  1028e7:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1028ec:	e9 b8 05 00 00       	jmp    102ea9 <__alltraps>

001028f1 <vector134>:
.globl vector134
vector134:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $134
  1028f3:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1028f8:	e9 ac 05 00 00       	jmp    102ea9 <__alltraps>

001028fd <vector135>:
.globl vector135
vector135:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $135
  1028ff:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102904:	e9 a0 05 00 00       	jmp    102ea9 <__alltraps>

00102909 <vector136>:
.globl vector136
vector136:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $136
  10290b:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102910:	e9 94 05 00 00       	jmp    102ea9 <__alltraps>

00102915 <vector137>:
.globl vector137
vector137:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $137
  102917:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10291c:	e9 88 05 00 00       	jmp    102ea9 <__alltraps>

00102921 <vector138>:
.globl vector138
vector138:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $138
  102923:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102928:	e9 7c 05 00 00       	jmp    102ea9 <__alltraps>

0010292d <vector139>:
.globl vector139
vector139:
  pushl $0
  10292d:	6a 00                	push   $0x0
  pushl $139
  10292f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102934:	e9 70 05 00 00       	jmp    102ea9 <__alltraps>

00102939 <vector140>:
.globl vector140
vector140:
  pushl $0
  102939:	6a 00                	push   $0x0
  pushl $140
  10293b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102940:	e9 64 05 00 00       	jmp    102ea9 <__alltraps>

00102945 <vector141>:
.globl vector141
vector141:
  pushl $0
  102945:	6a 00                	push   $0x0
  pushl $141
  102947:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10294c:	e9 58 05 00 00       	jmp    102ea9 <__alltraps>

00102951 <vector142>:
.globl vector142
vector142:
  pushl $0
  102951:	6a 00                	push   $0x0
  pushl $142
  102953:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102958:	e9 4c 05 00 00       	jmp    102ea9 <__alltraps>

0010295d <vector143>:
.globl vector143
vector143:
  pushl $0
  10295d:	6a 00                	push   $0x0
  pushl $143
  10295f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102964:	e9 40 05 00 00       	jmp    102ea9 <__alltraps>

00102969 <vector144>:
.globl vector144
vector144:
  pushl $0
  102969:	6a 00                	push   $0x0
  pushl $144
  10296b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102970:	e9 34 05 00 00       	jmp    102ea9 <__alltraps>

00102975 <vector145>:
.globl vector145
vector145:
  pushl $0
  102975:	6a 00                	push   $0x0
  pushl $145
  102977:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10297c:	e9 28 05 00 00       	jmp    102ea9 <__alltraps>

00102981 <vector146>:
.globl vector146
vector146:
  pushl $0
  102981:	6a 00                	push   $0x0
  pushl $146
  102983:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102988:	e9 1c 05 00 00       	jmp    102ea9 <__alltraps>

0010298d <vector147>:
.globl vector147
vector147:
  pushl $0
  10298d:	6a 00                	push   $0x0
  pushl $147
  10298f:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102994:	e9 10 05 00 00       	jmp    102ea9 <__alltraps>

00102999 <vector148>:
.globl vector148
vector148:
  pushl $0
  102999:	6a 00                	push   $0x0
  pushl $148
  10299b:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1029a0:	e9 04 05 00 00       	jmp    102ea9 <__alltraps>

001029a5 <vector149>:
.globl vector149
vector149:
  pushl $0
  1029a5:	6a 00                	push   $0x0
  pushl $149
  1029a7:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1029ac:	e9 f8 04 00 00       	jmp    102ea9 <__alltraps>

001029b1 <vector150>:
.globl vector150
vector150:
  pushl $0
  1029b1:	6a 00                	push   $0x0
  pushl $150
  1029b3:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1029b8:	e9 ec 04 00 00       	jmp    102ea9 <__alltraps>

001029bd <vector151>:
.globl vector151
vector151:
  pushl $0
  1029bd:	6a 00                	push   $0x0
  pushl $151
  1029bf:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1029c4:	e9 e0 04 00 00       	jmp    102ea9 <__alltraps>

001029c9 <vector152>:
.globl vector152
vector152:
  pushl $0
  1029c9:	6a 00                	push   $0x0
  pushl $152
  1029cb:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1029d0:	e9 d4 04 00 00       	jmp    102ea9 <__alltraps>

001029d5 <vector153>:
.globl vector153
vector153:
  pushl $0
  1029d5:	6a 00                	push   $0x0
  pushl $153
  1029d7:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1029dc:	e9 c8 04 00 00       	jmp    102ea9 <__alltraps>

001029e1 <vector154>:
.globl vector154
vector154:
  pushl $0
  1029e1:	6a 00                	push   $0x0
  pushl $154
  1029e3:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1029e8:	e9 bc 04 00 00       	jmp    102ea9 <__alltraps>

001029ed <vector155>:
.globl vector155
vector155:
  pushl $0
  1029ed:	6a 00                	push   $0x0
  pushl $155
  1029ef:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1029f4:	e9 b0 04 00 00       	jmp    102ea9 <__alltraps>

001029f9 <vector156>:
.globl vector156
vector156:
  pushl $0
  1029f9:	6a 00                	push   $0x0
  pushl $156
  1029fb:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102a00:	e9 a4 04 00 00       	jmp    102ea9 <__alltraps>

00102a05 <vector157>:
.globl vector157
vector157:
  pushl $0
  102a05:	6a 00                	push   $0x0
  pushl $157
  102a07:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102a0c:	e9 98 04 00 00       	jmp    102ea9 <__alltraps>

00102a11 <vector158>:
.globl vector158
vector158:
  pushl $0
  102a11:	6a 00                	push   $0x0
  pushl $158
  102a13:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102a18:	e9 8c 04 00 00       	jmp    102ea9 <__alltraps>

00102a1d <vector159>:
.globl vector159
vector159:
  pushl $0
  102a1d:	6a 00                	push   $0x0
  pushl $159
  102a1f:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102a24:	e9 80 04 00 00       	jmp    102ea9 <__alltraps>

00102a29 <vector160>:
.globl vector160
vector160:
  pushl $0
  102a29:	6a 00                	push   $0x0
  pushl $160
  102a2b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102a30:	e9 74 04 00 00       	jmp    102ea9 <__alltraps>

00102a35 <vector161>:
.globl vector161
vector161:
  pushl $0
  102a35:	6a 00                	push   $0x0
  pushl $161
  102a37:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102a3c:	e9 68 04 00 00       	jmp    102ea9 <__alltraps>

00102a41 <vector162>:
.globl vector162
vector162:
  pushl $0
  102a41:	6a 00                	push   $0x0
  pushl $162
  102a43:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102a48:	e9 5c 04 00 00       	jmp    102ea9 <__alltraps>

00102a4d <vector163>:
.globl vector163
vector163:
  pushl $0
  102a4d:	6a 00                	push   $0x0
  pushl $163
  102a4f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102a54:	e9 50 04 00 00       	jmp    102ea9 <__alltraps>

00102a59 <vector164>:
.globl vector164
vector164:
  pushl $0
  102a59:	6a 00                	push   $0x0
  pushl $164
  102a5b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102a60:	e9 44 04 00 00       	jmp    102ea9 <__alltraps>

00102a65 <vector165>:
.globl vector165
vector165:
  pushl $0
  102a65:	6a 00                	push   $0x0
  pushl $165
  102a67:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102a6c:	e9 38 04 00 00       	jmp    102ea9 <__alltraps>

00102a71 <vector166>:
.globl vector166
vector166:
  pushl $0
  102a71:	6a 00                	push   $0x0
  pushl $166
  102a73:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102a78:	e9 2c 04 00 00       	jmp    102ea9 <__alltraps>

00102a7d <vector167>:
.globl vector167
vector167:
  pushl $0
  102a7d:	6a 00                	push   $0x0
  pushl $167
  102a7f:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102a84:	e9 20 04 00 00       	jmp    102ea9 <__alltraps>

00102a89 <vector168>:
.globl vector168
vector168:
  pushl $0
  102a89:	6a 00                	push   $0x0
  pushl $168
  102a8b:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102a90:	e9 14 04 00 00       	jmp    102ea9 <__alltraps>

00102a95 <vector169>:
.globl vector169
vector169:
  pushl $0
  102a95:	6a 00                	push   $0x0
  pushl $169
  102a97:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102a9c:	e9 08 04 00 00       	jmp    102ea9 <__alltraps>

00102aa1 <vector170>:
.globl vector170
vector170:
  pushl $0
  102aa1:	6a 00                	push   $0x0
  pushl $170
  102aa3:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102aa8:	e9 fc 03 00 00       	jmp    102ea9 <__alltraps>

00102aad <vector171>:
.globl vector171
vector171:
  pushl $0
  102aad:	6a 00                	push   $0x0
  pushl $171
  102aaf:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102ab4:	e9 f0 03 00 00       	jmp    102ea9 <__alltraps>

00102ab9 <vector172>:
.globl vector172
vector172:
  pushl $0
  102ab9:	6a 00                	push   $0x0
  pushl $172
  102abb:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102ac0:	e9 e4 03 00 00       	jmp    102ea9 <__alltraps>

00102ac5 <vector173>:
.globl vector173
vector173:
  pushl $0
  102ac5:	6a 00                	push   $0x0
  pushl $173
  102ac7:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102acc:	e9 d8 03 00 00       	jmp    102ea9 <__alltraps>

00102ad1 <vector174>:
.globl vector174
vector174:
  pushl $0
  102ad1:	6a 00                	push   $0x0
  pushl $174
  102ad3:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102ad8:	e9 cc 03 00 00       	jmp    102ea9 <__alltraps>

00102add <vector175>:
.globl vector175
vector175:
  pushl $0
  102add:	6a 00                	push   $0x0
  pushl $175
  102adf:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102ae4:	e9 c0 03 00 00       	jmp    102ea9 <__alltraps>

00102ae9 <vector176>:
.globl vector176
vector176:
  pushl $0
  102ae9:	6a 00                	push   $0x0
  pushl $176
  102aeb:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102af0:	e9 b4 03 00 00       	jmp    102ea9 <__alltraps>

00102af5 <vector177>:
.globl vector177
vector177:
  pushl $0
  102af5:	6a 00                	push   $0x0
  pushl $177
  102af7:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102afc:	e9 a8 03 00 00       	jmp    102ea9 <__alltraps>

00102b01 <vector178>:
.globl vector178
vector178:
  pushl $0
  102b01:	6a 00                	push   $0x0
  pushl $178
  102b03:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102b08:	e9 9c 03 00 00       	jmp    102ea9 <__alltraps>

00102b0d <vector179>:
.globl vector179
vector179:
  pushl $0
  102b0d:	6a 00                	push   $0x0
  pushl $179
  102b0f:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102b14:	e9 90 03 00 00       	jmp    102ea9 <__alltraps>

00102b19 <vector180>:
.globl vector180
vector180:
  pushl $0
  102b19:	6a 00                	push   $0x0
  pushl $180
  102b1b:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102b20:	e9 84 03 00 00       	jmp    102ea9 <__alltraps>

00102b25 <vector181>:
.globl vector181
vector181:
  pushl $0
  102b25:	6a 00                	push   $0x0
  pushl $181
  102b27:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102b2c:	e9 78 03 00 00       	jmp    102ea9 <__alltraps>

00102b31 <vector182>:
.globl vector182
vector182:
  pushl $0
  102b31:	6a 00                	push   $0x0
  pushl $182
  102b33:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102b38:	e9 6c 03 00 00       	jmp    102ea9 <__alltraps>

00102b3d <vector183>:
.globl vector183
vector183:
  pushl $0
  102b3d:	6a 00                	push   $0x0
  pushl $183
  102b3f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102b44:	e9 60 03 00 00       	jmp    102ea9 <__alltraps>

00102b49 <vector184>:
.globl vector184
vector184:
  pushl $0
  102b49:	6a 00                	push   $0x0
  pushl $184
  102b4b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102b50:	e9 54 03 00 00       	jmp    102ea9 <__alltraps>

00102b55 <vector185>:
.globl vector185
vector185:
  pushl $0
  102b55:	6a 00                	push   $0x0
  pushl $185
  102b57:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102b5c:	e9 48 03 00 00       	jmp    102ea9 <__alltraps>

00102b61 <vector186>:
.globl vector186
vector186:
  pushl $0
  102b61:	6a 00                	push   $0x0
  pushl $186
  102b63:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102b68:	e9 3c 03 00 00       	jmp    102ea9 <__alltraps>

00102b6d <vector187>:
.globl vector187
vector187:
  pushl $0
  102b6d:	6a 00                	push   $0x0
  pushl $187
  102b6f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102b74:	e9 30 03 00 00       	jmp    102ea9 <__alltraps>

00102b79 <vector188>:
.globl vector188
vector188:
  pushl $0
  102b79:	6a 00                	push   $0x0
  pushl $188
  102b7b:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102b80:	e9 24 03 00 00       	jmp    102ea9 <__alltraps>

00102b85 <vector189>:
.globl vector189
vector189:
  pushl $0
  102b85:	6a 00                	push   $0x0
  pushl $189
  102b87:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102b8c:	e9 18 03 00 00       	jmp    102ea9 <__alltraps>

00102b91 <vector190>:
.globl vector190
vector190:
  pushl $0
  102b91:	6a 00                	push   $0x0
  pushl $190
  102b93:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102b98:	e9 0c 03 00 00       	jmp    102ea9 <__alltraps>

00102b9d <vector191>:
.globl vector191
vector191:
  pushl $0
  102b9d:	6a 00                	push   $0x0
  pushl $191
  102b9f:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102ba4:	e9 00 03 00 00       	jmp    102ea9 <__alltraps>

00102ba9 <vector192>:
.globl vector192
vector192:
  pushl $0
  102ba9:	6a 00                	push   $0x0
  pushl $192
  102bab:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102bb0:	e9 f4 02 00 00       	jmp    102ea9 <__alltraps>

00102bb5 <vector193>:
.globl vector193
vector193:
  pushl $0
  102bb5:	6a 00                	push   $0x0
  pushl $193
  102bb7:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102bbc:	e9 e8 02 00 00       	jmp    102ea9 <__alltraps>

00102bc1 <vector194>:
.globl vector194
vector194:
  pushl $0
  102bc1:	6a 00                	push   $0x0
  pushl $194
  102bc3:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102bc8:	e9 dc 02 00 00       	jmp    102ea9 <__alltraps>

00102bcd <vector195>:
.globl vector195
vector195:
  pushl $0
  102bcd:	6a 00                	push   $0x0
  pushl $195
  102bcf:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102bd4:	e9 d0 02 00 00       	jmp    102ea9 <__alltraps>

00102bd9 <vector196>:
.globl vector196
vector196:
  pushl $0
  102bd9:	6a 00                	push   $0x0
  pushl $196
  102bdb:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102be0:	e9 c4 02 00 00       	jmp    102ea9 <__alltraps>

00102be5 <vector197>:
.globl vector197
vector197:
  pushl $0
  102be5:	6a 00                	push   $0x0
  pushl $197
  102be7:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102bec:	e9 b8 02 00 00       	jmp    102ea9 <__alltraps>

00102bf1 <vector198>:
.globl vector198
vector198:
  pushl $0
  102bf1:	6a 00                	push   $0x0
  pushl $198
  102bf3:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102bf8:	e9 ac 02 00 00       	jmp    102ea9 <__alltraps>

00102bfd <vector199>:
.globl vector199
vector199:
  pushl $0
  102bfd:	6a 00                	push   $0x0
  pushl $199
  102bff:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102c04:	e9 a0 02 00 00       	jmp    102ea9 <__alltraps>

00102c09 <vector200>:
.globl vector200
vector200:
  pushl $0
  102c09:	6a 00                	push   $0x0
  pushl $200
  102c0b:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102c10:	e9 94 02 00 00       	jmp    102ea9 <__alltraps>

00102c15 <vector201>:
.globl vector201
vector201:
  pushl $0
  102c15:	6a 00                	push   $0x0
  pushl $201
  102c17:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102c1c:	e9 88 02 00 00       	jmp    102ea9 <__alltraps>

00102c21 <vector202>:
.globl vector202
vector202:
  pushl $0
  102c21:	6a 00                	push   $0x0
  pushl $202
  102c23:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102c28:	e9 7c 02 00 00       	jmp    102ea9 <__alltraps>

00102c2d <vector203>:
.globl vector203
vector203:
  pushl $0
  102c2d:	6a 00                	push   $0x0
  pushl $203
  102c2f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102c34:	e9 70 02 00 00       	jmp    102ea9 <__alltraps>

00102c39 <vector204>:
.globl vector204
vector204:
  pushl $0
  102c39:	6a 00                	push   $0x0
  pushl $204
  102c3b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102c40:	e9 64 02 00 00       	jmp    102ea9 <__alltraps>

00102c45 <vector205>:
.globl vector205
vector205:
  pushl $0
  102c45:	6a 00                	push   $0x0
  pushl $205
  102c47:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102c4c:	e9 58 02 00 00       	jmp    102ea9 <__alltraps>

00102c51 <vector206>:
.globl vector206
vector206:
  pushl $0
  102c51:	6a 00                	push   $0x0
  pushl $206
  102c53:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102c58:	e9 4c 02 00 00       	jmp    102ea9 <__alltraps>

00102c5d <vector207>:
.globl vector207
vector207:
  pushl $0
  102c5d:	6a 00                	push   $0x0
  pushl $207
  102c5f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102c64:	e9 40 02 00 00       	jmp    102ea9 <__alltraps>

00102c69 <vector208>:
.globl vector208
vector208:
  pushl $0
  102c69:	6a 00                	push   $0x0
  pushl $208
  102c6b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102c70:	e9 34 02 00 00       	jmp    102ea9 <__alltraps>

00102c75 <vector209>:
.globl vector209
vector209:
  pushl $0
  102c75:	6a 00                	push   $0x0
  pushl $209
  102c77:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102c7c:	e9 28 02 00 00       	jmp    102ea9 <__alltraps>

00102c81 <vector210>:
.globl vector210
vector210:
  pushl $0
  102c81:	6a 00                	push   $0x0
  pushl $210
  102c83:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102c88:	e9 1c 02 00 00       	jmp    102ea9 <__alltraps>

00102c8d <vector211>:
.globl vector211
vector211:
  pushl $0
  102c8d:	6a 00                	push   $0x0
  pushl $211
  102c8f:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102c94:	e9 10 02 00 00       	jmp    102ea9 <__alltraps>

00102c99 <vector212>:
.globl vector212
vector212:
  pushl $0
  102c99:	6a 00                	push   $0x0
  pushl $212
  102c9b:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102ca0:	e9 04 02 00 00       	jmp    102ea9 <__alltraps>

00102ca5 <vector213>:
.globl vector213
vector213:
  pushl $0
  102ca5:	6a 00                	push   $0x0
  pushl $213
  102ca7:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102cac:	e9 f8 01 00 00       	jmp    102ea9 <__alltraps>

00102cb1 <vector214>:
.globl vector214
vector214:
  pushl $0
  102cb1:	6a 00                	push   $0x0
  pushl $214
  102cb3:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102cb8:	e9 ec 01 00 00       	jmp    102ea9 <__alltraps>

00102cbd <vector215>:
.globl vector215
vector215:
  pushl $0
  102cbd:	6a 00                	push   $0x0
  pushl $215
  102cbf:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102cc4:	e9 e0 01 00 00       	jmp    102ea9 <__alltraps>

00102cc9 <vector216>:
.globl vector216
vector216:
  pushl $0
  102cc9:	6a 00                	push   $0x0
  pushl $216
  102ccb:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102cd0:	e9 d4 01 00 00       	jmp    102ea9 <__alltraps>

00102cd5 <vector217>:
.globl vector217
vector217:
  pushl $0
  102cd5:	6a 00                	push   $0x0
  pushl $217
  102cd7:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102cdc:	e9 c8 01 00 00       	jmp    102ea9 <__alltraps>

00102ce1 <vector218>:
.globl vector218
vector218:
  pushl $0
  102ce1:	6a 00                	push   $0x0
  pushl $218
  102ce3:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102ce8:	e9 bc 01 00 00       	jmp    102ea9 <__alltraps>

00102ced <vector219>:
.globl vector219
vector219:
  pushl $0
  102ced:	6a 00                	push   $0x0
  pushl $219
  102cef:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102cf4:	e9 b0 01 00 00       	jmp    102ea9 <__alltraps>

00102cf9 <vector220>:
.globl vector220
vector220:
  pushl $0
  102cf9:	6a 00                	push   $0x0
  pushl $220
  102cfb:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102d00:	e9 a4 01 00 00       	jmp    102ea9 <__alltraps>

00102d05 <vector221>:
.globl vector221
vector221:
  pushl $0
  102d05:	6a 00                	push   $0x0
  pushl $221
  102d07:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102d0c:	e9 98 01 00 00       	jmp    102ea9 <__alltraps>

00102d11 <vector222>:
.globl vector222
vector222:
  pushl $0
  102d11:	6a 00                	push   $0x0
  pushl $222
  102d13:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102d18:	e9 8c 01 00 00       	jmp    102ea9 <__alltraps>

00102d1d <vector223>:
.globl vector223
vector223:
  pushl $0
  102d1d:	6a 00                	push   $0x0
  pushl $223
  102d1f:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102d24:	e9 80 01 00 00       	jmp    102ea9 <__alltraps>

00102d29 <vector224>:
.globl vector224
vector224:
  pushl $0
  102d29:	6a 00                	push   $0x0
  pushl $224
  102d2b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102d30:	e9 74 01 00 00       	jmp    102ea9 <__alltraps>

00102d35 <vector225>:
.globl vector225
vector225:
  pushl $0
  102d35:	6a 00                	push   $0x0
  pushl $225
  102d37:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102d3c:	e9 68 01 00 00       	jmp    102ea9 <__alltraps>

00102d41 <vector226>:
.globl vector226
vector226:
  pushl $0
  102d41:	6a 00                	push   $0x0
  pushl $226
  102d43:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102d48:	e9 5c 01 00 00       	jmp    102ea9 <__alltraps>

00102d4d <vector227>:
.globl vector227
vector227:
  pushl $0
  102d4d:	6a 00                	push   $0x0
  pushl $227
  102d4f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102d54:	e9 50 01 00 00       	jmp    102ea9 <__alltraps>

00102d59 <vector228>:
.globl vector228
vector228:
  pushl $0
  102d59:	6a 00                	push   $0x0
  pushl $228
  102d5b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102d60:	e9 44 01 00 00       	jmp    102ea9 <__alltraps>

00102d65 <vector229>:
.globl vector229
vector229:
  pushl $0
  102d65:	6a 00                	push   $0x0
  pushl $229
  102d67:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102d6c:	e9 38 01 00 00       	jmp    102ea9 <__alltraps>

00102d71 <vector230>:
.globl vector230
vector230:
  pushl $0
  102d71:	6a 00                	push   $0x0
  pushl $230
  102d73:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102d78:	e9 2c 01 00 00       	jmp    102ea9 <__alltraps>

00102d7d <vector231>:
.globl vector231
vector231:
  pushl $0
  102d7d:	6a 00                	push   $0x0
  pushl $231
  102d7f:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102d84:	e9 20 01 00 00       	jmp    102ea9 <__alltraps>

00102d89 <vector232>:
.globl vector232
vector232:
  pushl $0
  102d89:	6a 00                	push   $0x0
  pushl $232
  102d8b:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102d90:	e9 14 01 00 00       	jmp    102ea9 <__alltraps>

00102d95 <vector233>:
.globl vector233
vector233:
  pushl $0
  102d95:	6a 00                	push   $0x0
  pushl $233
  102d97:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102d9c:	e9 08 01 00 00       	jmp    102ea9 <__alltraps>

00102da1 <vector234>:
.globl vector234
vector234:
  pushl $0
  102da1:	6a 00                	push   $0x0
  pushl $234
  102da3:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102da8:	e9 fc 00 00 00       	jmp    102ea9 <__alltraps>

00102dad <vector235>:
.globl vector235
vector235:
  pushl $0
  102dad:	6a 00                	push   $0x0
  pushl $235
  102daf:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102db4:	e9 f0 00 00 00       	jmp    102ea9 <__alltraps>

00102db9 <vector236>:
.globl vector236
vector236:
  pushl $0
  102db9:	6a 00                	push   $0x0
  pushl $236
  102dbb:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102dc0:	e9 e4 00 00 00       	jmp    102ea9 <__alltraps>

00102dc5 <vector237>:
.globl vector237
vector237:
  pushl $0
  102dc5:	6a 00                	push   $0x0
  pushl $237
  102dc7:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102dcc:	e9 d8 00 00 00       	jmp    102ea9 <__alltraps>

00102dd1 <vector238>:
.globl vector238
vector238:
  pushl $0
  102dd1:	6a 00                	push   $0x0
  pushl $238
  102dd3:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102dd8:	e9 cc 00 00 00       	jmp    102ea9 <__alltraps>

00102ddd <vector239>:
.globl vector239
vector239:
  pushl $0
  102ddd:	6a 00                	push   $0x0
  pushl $239
  102ddf:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102de4:	e9 c0 00 00 00       	jmp    102ea9 <__alltraps>

00102de9 <vector240>:
.globl vector240
vector240:
  pushl $0
  102de9:	6a 00                	push   $0x0
  pushl $240
  102deb:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102df0:	e9 b4 00 00 00       	jmp    102ea9 <__alltraps>

00102df5 <vector241>:
.globl vector241
vector241:
  pushl $0
  102df5:	6a 00                	push   $0x0
  pushl $241
  102df7:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102dfc:	e9 a8 00 00 00       	jmp    102ea9 <__alltraps>

00102e01 <vector242>:
.globl vector242
vector242:
  pushl $0
  102e01:	6a 00                	push   $0x0
  pushl $242
  102e03:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102e08:	e9 9c 00 00 00       	jmp    102ea9 <__alltraps>

00102e0d <vector243>:
.globl vector243
vector243:
  pushl $0
  102e0d:	6a 00                	push   $0x0
  pushl $243
  102e0f:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102e14:	e9 90 00 00 00       	jmp    102ea9 <__alltraps>

00102e19 <vector244>:
.globl vector244
vector244:
  pushl $0
  102e19:	6a 00                	push   $0x0
  pushl $244
  102e1b:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102e20:	e9 84 00 00 00       	jmp    102ea9 <__alltraps>

00102e25 <vector245>:
.globl vector245
vector245:
  pushl $0
  102e25:	6a 00                	push   $0x0
  pushl $245
  102e27:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102e2c:	e9 78 00 00 00       	jmp    102ea9 <__alltraps>

00102e31 <vector246>:
.globl vector246
vector246:
  pushl $0
  102e31:	6a 00                	push   $0x0
  pushl $246
  102e33:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102e38:	e9 6c 00 00 00       	jmp    102ea9 <__alltraps>

00102e3d <vector247>:
.globl vector247
vector247:
  pushl $0
  102e3d:	6a 00                	push   $0x0
  pushl $247
  102e3f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102e44:	e9 60 00 00 00       	jmp    102ea9 <__alltraps>

00102e49 <vector248>:
.globl vector248
vector248:
  pushl $0
  102e49:	6a 00                	push   $0x0
  pushl $248
  102e4b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102e50:	e9 54 00 00 00       	jmp    102ea9 <__alltraps>

00102e55 <vector249>:
.globl vector249
vector249:
  pushl $0
  102e55:	6a 00                	push   $0x0
  pushl $249
  102e57:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102e5c:	e9 48 00 00 00       	jmp    102ea9 <__alltraps>

00102e61 <vector250>:
.globl vector250
vector250:
  pushl $0
  102e61:	6a 00                	push   $0x0
  pushl $250
  102e63:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102e68:	e9 3c 00 00 00       	jmp    102ea9 <__alltraps>

00102e6d <vector251>:
.globl vector251
vector251:
  pushl $0
  102e6d:	6a 00                	push   $0x0
  pushl $251
  102e6f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102e74:	e9 30 00 00 00       	jmp    102ea9 <__alltraps>

00102e79 <vector252>:
.globl vector252
vector252:
  pushl $0
  102e79:	6a 00                	push   $0x0
  pushl $252
  102e7b:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102e80:	e9 24 00 00 00       	jmp    102ea9 <__alltraps>

00102e85 <vector253>:
.globl vector253
vector253:
  pushl $0
  102e85:	6a 00                	push   $0x0
  pushl $253
  102e87:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102e8c:	e9 18 00 00 00       	jmp    102ea9 <__alltraps>

00102e91 <vector254>:
.globl vector254
vector254:
  pushl $0
  102e91:	6a 00                	push   $0x0
  pushl $254
  102e93:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102e98:	e9 0c 00 00 00       	jmp    102ea9 <__alltraps>

00102e9d <vector255>:
.globl vector255
vector255:
  pushl $0
  102e9d:	6a 00                	push   $0x0
  pushl $255
  102e9f:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102ea4:	e9 00 00 00 00       	jmp    102ea9 <__alltraps>

00102ea9 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102ea9:	1e                   	push   %ds
    pushl %es
  102eaa:	06                   	push   %es
    pushl %fs
  102eab:	0f a0                	push   %fs
    pushl %gs
  102ead:	0f a8                	push   %gs
    pushal
  102eaf:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102eb0:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102eb5:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102eb7:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102eb9:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102eba:	e8 55 f5 ff ff       	call   102414 <trap>

    # pop the pushed stack pointer
    popl %esp
  102ebf:	5c                   	pop    %esp

00102ec0 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102ec0:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102ec1:	0f a9                	pop    %gs
    popl %fs
  102ec3:	0f a1                	pop    %fs
    popl %es
  102ec5:	07                   	pop    %es
    popl %ds
  102ec6:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102ec7:	83 c4 08             	add    $0x8,%esp
    iret
  102eca:	cf                   	iret   

00102ecb <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102ecb:	55                   	push   %ebp
  102ecc:	89 e5                	mov    %esp,%ebp
  102ece:	e8 dd d3 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  102ed3:	05 7d da 00 00       	add    $0xda7d,%eax
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  102edb:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102ede:	b8 23 00 00 00       	mov    $0x23,%eax
  102ee3:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102ee5:	b8 23 00 00 00       	mov    $0x23,%eax
  102eea:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102eec:	b8 10 00 00 00       	mov    $0x10,%eax
  102ef1:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102ef3:	b8 10 00 00 00       	mov    $0x10,%eax
  102ef8:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102efa:	b8 10 00 00 00       	mov    $0x10,%eax
  102eff:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102f01:	ea 08 2f 10 00 08 00 	ljmp   $0x8,$0x102f08
}
  102f08:	90                   	nop
  102f09:	5d                   	pop    %ebp
  102f0a:	c3                   	ret    

00102f0b <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102f0b:	f3 0f 1e fb          	endbr32 
  102f0f:	55                   	push   %ebp
  102f10:	89 e5                	mov    %esp,%ebp
  102f12:	83 ec 10             	sub    $0x10,%esp
  102f15:	e8 96 d3 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  102f1a:	05 36 da 00 00       	add    $0xda36,%eax
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102f1f:	c7 c2 20 1a 11 00    	mov    $0x111a20,%edx
  102f25:	81 c2 00 04 00 00    	add    $0x400,%edx
  102f2b:	89 90 f4 0f 00 00    	mov    %edx,0xff4(%eax)
    ts.ts_ss0 = KERNEL_DS;
  102f31:	66 c7 80 f8 0f 00 00 	movw   $0x10,0xff8(%eax)
  102f38:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102f3a:	66 c7 80 f8 ff ff ff 	movw   $0x68,-0x8(%eax)
  102f41:	68 00 
  102f43:	8d 90 f0 0f 00 00    	lea    0xff0(%eax),%edx
  102f49:	66 89 90 fa ff ff ff 	mov    %dx,-0x6(%eax)
  102f50:	8d 90 f0 0f 00 00    	lea    0xff0(%eax),%edx
  102f56:	c1 ea 10             	shr    $0x10,%edx
  102f59:	88 90 fc ff ff ff    	mov    %dl,-0x4(%eax)
  102f5f:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102f66:	83 e2 f0             	and    $0xfffffff0,%edx
  102f69:	83 ca 09             	or     $0x9,%edx
  102f6c:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102f72:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102f79:	83 ca 10             	or     $0x10,%edx
  102f7c:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102f82:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102f89:	83 e2 9f             	and    $0xffffff9f,%edx
  102f8c:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102f92:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102f99:	83 ca 80             	or     $0xffffff80,%edx
  102f9c:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102fa2:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102fa9:	83 e2 f0             	and    $0xfffffff0,%edx
  102fac:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102fb2:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102fb9:	83 e2 ef             	and    $0xffffffef,%edx
  102fbc:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102fc2:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102fc9:	83 e2 df             	and    $0xffffffdf,%edx
  102fcc:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102fd2:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102fd9:	83 ca 40             	or     $0x40,%edx
  102fdc:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102fe2:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102fe9:	83 e2 7f             	and    $0x7f,%edx
  102fec:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102ff2:	8d 90 f0 0f 00 00    	lea    0xff0(%eax),%edx
  102ff8:	c1 ea 18             	shr    $0x18,%edx
  102ffb:	88 90 ff ff ff ff    	mov    %dl,-0x1(%eax)
    gdt[SEG_TSS].sd_s = 0;
  103001:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  103008:	83 e2 ef             	and    $0xffffffef,%edx
  10300b:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)

    // reload all segment registers
    lgdt(&gdt_pd);
  103011:	8d 80 d0 00 00 00    	lea    0xd0(%eax),%eax
  103017:	50                   	push   %eax
  103018:	e8 ae fe ff ff       	call   102ecb <lgdt>
  10301d:	83 c4 04             	add    $0x4,%esp
  103020:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  103026:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10302a:	0f 00 d8             	ltr    %ax
}
  10302d:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  10302e:	90                   	nop
  10302f:	c9                   	leave  
  103030:	c3                   	ret    

00103031 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  103031:	f3 0f 1e fb          	endbr32 
  103035:	55                   	push   %ebp
  103036:	89 e5                	mov    %esp,%ebp
  103038:	e8 73 d2 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10303d:	05 13 d9 00 00       	add    $0xd913,%eax
    gdt_init();
  103042:	e8 c4 fe ff ff       	call   102f0b <gdt_init>
}
  103047:	90                   	nop
  103048:	5d                   	pop    %ebp
  103049:	c3                   	ret    

0010304a <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10304a:	f3 0f 1e fb          	endbr32 
  10304e:	55                   	push   %ebp
  10304f:	89 e5                	mov    %esp,%ebp
  103051:	83 ec 10             	sub    $0x10,%esp
  103054:	e8 57 d2 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103059:	05 f7 d8 00 00       	add    $0xd8f7,%eax
    size_t cnt = 0;
  10305e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  103065:	eb 04                	jmp    10306b <strlen+0x21>
        cnt ++;
  103067:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  10306b:	8b 45 08             	mov    0x8(%ebp),%eax
  10306e:	8d 50 01             	lea    0x1(%eax),%edx
  103071:	89 55 08             	mov    %edx,0x8(%ebp)
  103074:	0f b6 00             	movzbl (%eax),%eax
  103077:	84 c0                	test   %al,%al
  103079:	75 ec                	jne    103067 <strlen+0x1d>
    }
    return cnt;
  10307b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10307e:	c9                   	leave  
  10307f:	c3                   	ret    

00103080 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103080:	f3 0f 1e fb          	endbr32 
  103084:	55                   	push   %ebp
  103085:	89 e5                	mov    %esp,%ebp
  103087:	83 ec 10             	sub    $0x10,%esp
  10308a:	e8 21 d2 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10308f:	05 c1 d8 00 00       	add    $0xd8c1,%eax
    size_t cnt = 0;
  103094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10309b:	eb 04                	jmp    1030a1 <strnlen+0x21>
        cnt ++;
  10309d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1030a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1030a7:	73 10                	jae    1030b9 <strnlen+0x39>
  1030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ac:	8d 50 01             	lea    0x1(%eax),%edx
  1030af:	89 55 08             	mov    %edx,0x8(%ebp)
  1030b2:	0f b6 00             	movzbl (%eax),%eax
  1030b5:	84 c0                	test   %al,%al
  1030b7:	75 e4                	jne    10309d <strnlen+0x1d>
    }
    return cnt;
  1030b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1030bc:	c9                   	leave  
  1030bd:	c3                   	ret    

001030be <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1030be:	f3 0f 1e fb          	endbr32 
  1030c2:	55                   	push   %ebp
  1030c3:	89 e5                	mov    %esp,%ebp
  1030c5:	57                   	push   %edi
  1030c6:	56                   	push   %esi
  1030c7:	83 ec 20             	sub    $0x20,%esp
  1030ca:	e8 e1 d1 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1030cf:	05 81 d8 00 00       	add    $0xd881,%eax
  1030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1030e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030e6:	89 d1                	mov    %edx,%ecx
  1030e8:	89 c2                	mov    %eax,%edx
  1030ea:	89 ce                	mov    %ecx,%esi
  1030ec:	89 d7                	mov    %edx,%edi
  1030ee:	ac                   	lods   %ds:(%esi),%al
  1030ef:	aa                   	stos   %al,%es:(%edi)
  1030f0:	84 c0                	test   %al,%al
  1030f2:	75 fa                	jne    1030ee <strcpy+0x30>
  1030f4:	89 fa                	mov    %edi,%edx
  1030f6:	89 f1                	mov    %esi,%ecx
  1030f8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1030fb:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1030fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103101:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103104:	83 c4 20             	add    $0x20,%esp
  103107:	5e                   	pop    %esi
  103108:	5f                   	pop    %edi
  103109:	5d                   	pop    %ebp
  10310a:	c3                   	ret    

0010310b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10310b:	f3 0f 1e fb          	endbr32 
  10310f:	55                   	push   %ebp
  103110:	89 e5                	mov    %esp,%ebp
  103112:	83 ec 10             	sub    $0x10,%esp
  103115:	e8 96 d1 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10311a:	05 36 d8 00 00       	add    $0xd836,%eax
    char *p = dst;
  10311f:	8b 45 08             	mov    0x8(%ebp),%eax
  103122:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103125:	eb 21                	jmp    103148 <strncpy+0x3d>
        if ((*p = *src) != '\0') {
  103127:	8b 45 0c             	mov    0xc(%ebp),%eax
  10312a:	0f b6 10             	movzbl (%eax),%edx
  10312d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103130:	88 10                	mov    %dl,(%eax)
  103132:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103135:	0f b6 00             	movzbl (%eax),%eax
  103138:	84 c0                	test   %al,%al
  10313a:	74 04                	je     103140 <strncpy+0x35>
            src ++;
  10313c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103140:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103144:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  103148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10314c:	75 d9                	jne    103127 <strncpy+0x1c>
    }
    return dst;
  10314e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103151:	c9                   	leave  
  103152:	c3                   	ret    

00103153 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103153:	f3 0f 1e fb          	endbr32 
  103157:	55                   	push   %ebp
  103158:	89 e5                	mov    %esp,%ebp
  10315a:	57                   	push   %edi
  10315b:	56                   	push   %esi
  10315c:	83 ec 20             	sub    $0x20,%esp
  10315f:	e8 4c d1 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103164:	05 ec d7 00 00       	add    $0xd7ec,%eax
  103169:	8b 45 08             	mov    0x8(%ebp),%eax
  10316c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10316f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103172:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  103175:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10317b:	89 d1                	mov    %edx,%ecx
  10317d:	89 c2                	mov    %eax,%edx
  10317f:	89 ce                	mov    %ecx,%esi
  103181:	89 d7                	mov    %edx,%edi
  103183:	ac                   	lods   %ds:(%esi),%al
  103184:	ae                   	scas   %es:(%edi),%al
  103185:	75 08                	jne    10318f <strcmp+0x3c>
  103187:	84 c0                	test   %al,%al
  103189:	75 f8                	jne    103183 <strcmp+0x30>
  10318b:	31 c0                	xor    %eax,%eax
  10318d:	eb 04                	jmp    103193 <strcmp+0x40>
  10318f:	19 c0                	sbb    %eax,%eax
  103191:	0c 01                	or     $0x1,%al
  103193:	89 fa                	mov    %edi,%edx
  103195:	89 f1                	mov    %esi,%ecx
  103197:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10319a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10319d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1031a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1031a3:	83 c4 20             	add    $0x20,%esp
  1031a6:	5e                   	pop    %esi
  1031a7:	5f                   	pop    %edi
  1031a8:	5d                   	pop    %ebp
  1031a9:	c3                   	ret    

001031aa <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1031aa:	f3 0f 1e fb          	endbr32 
  1031ae:	55                   	push   %ebp
  1031af:	89 e5                	mov    %esp,%ebp
  1031b1:	e8 fa d0 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1031b6:	05 9a d7 00 00       	add    $0xd79a,%eax
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031bb:	eb 0c                	jmp    1031c9 <strncmp+0x1f>
        n --, s1 ++, s2 ++;
  1031bd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031cd:	74 1a                	je     1031e9 <strncmp+0x3f>
  1031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d2:	0f b6 00             	movzbl (%eax),%eax
  1031d5:	84 c0                	test   %al,%al
  1031d7:	74 10                	je     1031e9 <strncmp+0x3f>
  1031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031dc:	0f b6 10             	movzbl (%eax),%edx
  1031df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e2:	0f b6 00             	movzbl (%eax),%eax
  1031e5:	38 c2                	cmp    %al,%dl
  1031e7:	74 d4                	je     1031bd <strncmp+0x13>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1031e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031ed:	74 18                	je     103207 <strncmp+0x5d>
  1031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f2:	0f b6 00             	movzbl (%eax),%eax
  1031f5:	0f b6 d0             	movzbl %al,%edx
  1031f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031fb:	0f b6 00             	movzbl (%eax),%eax
  1031fe:	0f b6 c0             	movzbl %al,%eax
  103201:	29 c2                	sub    %eax,%edx
  103203:	89 d0                	mov    %edx,%eax
  103205:	eb 05                	jmp    10320c <strncmp+0x62>
  103207:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10320c:	5d                   	pop    %ebp
  10320d:	c3                   	ret    

0010320e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10320e:	f3 0f 1e fb          	endbr32 
  103212:	55                   	push   %ebp
  103213:	89 e5                	mov    %esp,%ebp
  103215:	83 ec 04             	sub    $0x4,%esp
  103218:	e8 93 d0 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10321d:	05 33 d7 00 00       	add    $0xd733,%eax
  103222:	8b 45 0c             	mov    0xc(%ebp),%eax
  103225:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103228:	eb 14                	jmp    10323e <strchr+0x30>
        if (*s == c) {
  10322a:	8b 45 08             	mov    0x8(%ebp),%eax
  10322d:	0f b6 00             	movzbl (%eax),%eax
  103230:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103233:	75 05                	jne    10323a <strchr+0x2c>
            return (char *)s;
  103235:	8b 45 08             	mov    0x8(%ebp),%eax
  103238:	eb 13                	jmp    10324d <strchr+0x3f>
        }
        s ++;
  10323a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  10323e:	8b 45 08             	mov    0x8(%ebp),%eax
  103241:	0f b6 00             	movzbl (%eax),%eax
  103244:	84 c0                	test   %al,%al
  103246:	75 e2                	jne    10322a <strchr+0x1c>
    }
    return NULL;
  103248:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10324d:	c9                   	leave  
  10324e:	c3                   	ret    

0010324f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10324f:	f3 0f 1e fb          	endbr32 
  103253:	55                   	push   %ebp
  103254:	89 e5                	mov    %esp,%ebp
  103256:	83 ec 04             	sub    $0x4,%esp
  103259:	e8 52 d0 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10325e:	05 f2 d6 00 00       	add    $0xd6f2,%eax
  103263:	8b 45 0c             	mov    0xc(%ebp),%eax
  103266:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103269:	eb 0f                	jmp    10327a <strfind+0x2b>
        if (*s == c) {
  10326b:	8b 45 08             	mov    0x8(%ebp),%eax
  10326e:	0f b6 00             	movzbl (%eax),%eax
  103271:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103274:	74 10                	je     103286 <strfind+0x37>
            break;
        }
        s ++;
  103276:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  10327a:	8b 45 08             	mov    0x8(%ebp),%eax
  10327d:	0f b6 00             	movzbl (%eax),%eax
  103280:	84 c0                	test   %al,%al
  103282:	75 e7                	jne    10326b <strfind+0x1c>
  103284:	eb 01                	jmp    103287 <strfind+0x38>
            break;
  103286:	90                   	nop
    }
    return (char *)s;
  103287:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10328a:	c9                   	leave  
  10328b:	c3                   	ret    

0010328c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10328c:	f3 0f 1e fb          	endbr32 
  103290:	55                   	push   %ebp
  103291:	89 e5                	mov    %esp,%ebp
  103293:	83 ec 10             	sub    $0x10,%esp
  103296:	e8 15 d0 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10329b:	05 b5 d6 00 00       	add    $0xd6b5,%eax
    int neg = 0;
  1032a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1032a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032ae:	eb 04                	jmp    1032b4 <strtol+0x28>
        s ++;
  1032b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b7:	0f b6 00             	movzbl (%eax),%eax
  1032ba:	3c 20                	cmp    $0x20,%al
  1032bc:	74 f2                	je     1032b0 <strtol+0x24>
  1032be:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c1:	0f b6 00             	movzbl (%eax),%eax
  1032c4:	3c 09                	cmp    $0x9,%al
  1032c6:	74 e8                	je     1032b0 <strtol+0x24>
    }

    // plus/minus sign
    if (*s == '+') {
  1032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1032cb:	0f b6 00             	movzbl (%eax),%eax
  1032ce:	3c 2b                	cmp    $0x2b,%al
  1032d0:	75 06                	jne    1032d8 <strtol+0x4c>
        s ++;
  1032d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032d6:	eb 15                	jmp    1032ed <strtol+0x61>
    }
    else if (*s == '-') {
  1032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1032db:	0f b6 00             	movzbl (%eax),%eax
  1032de:	3c 2d                	cmp    $0x2d,%al
  1032e0:	75 0b                	jne    1032ed <strtol+0x61>
        s ++, neg = 1;
  1032e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1032ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032f1:	74 06                	je     1032f9 <strtol+0x6d>
  1032f3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1032f7:	75 24                	jne    10331d <strtol+0x91>
  1032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032fc:	0f b6 00             	movzbl (%eax),%eax
  1032ff:	3c 30                	cmp    $0x30,%al
  103301:	75 1a                	jne    10331d <strtol+0x91>
  103303:	8b 45 08             	mov    0x8(%ebp),%eax
  103306:	83 c0 01             	add    $0x1,%eax
  103309:	0f b6 00             	movzbl (%eax),%eax
  10330c:	3c 78                	cmp    $0x78,%al
  10330e:	75 0d                	jne    10331d <strtol+0x91>
        s += 2, base = 16;
  103310:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103314:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10331b:	eb 2a                	jmp    103347 <strtol+0xbb>
    }
    else if (base == 0 && s[0] == '0') {
  10331d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103321:	75 17                	jne    10333a <strtol+0xae>
  103323:	8b 45 08             	mov    0x8(%ebp),%eax
  103326:	0f b6 00             	movzbl (%eax),%eax
  103329:	3c 30                	cmp    $0x30,%al
  10332b:	75 0d                	jne    10333a <strtol+0xae>
        s ++, base = 8;
  10332d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103331:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103338:	eb 0d                	jmp    103347 <strtol+0xbb>
    }
    else if (base == 0) {
  10333a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10333e:	75 07                	jne    103347 <strtol+0xbb>
        base = 10;
  103340:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103347:	8b 45 08             	mov    0x8(%ebp),%eax
  10334a:	0f b6 00             	movzbl (%eax),%eax
  10334d:	3c 2f                	cmp    $0x2f,%al
  10334f:	7e 1b                	jle    10336c <strtol+0xe0>
  103351:	8b 45 08             	mov    0x8(%ebp),%eax
  103354:	0f b6 00             	movzbl (%eax),%eax
  103357:	3c 39                	cmp    $0x39,%al
  103359:	7f 11                	jg     10336c <strtol+0xe0>
            dig = *s - '0';
  10335b:	8b 45 08             	mov    0x8(%ebp),%eax
  10335e:	0f b6 00             	movzbl (%eax),%eax
  103361:	0f be c0             	movsbl %al,%eax
  103364:	83 e8 30             	sub    $0x30,%eax
  103367:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10336a:	eb 48                	jmp    1033b4 <strtol+0x128>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10336c:	8b 45 08             	mov    0x8(%ebp),%eax
  10336f:	0f b6 00             	movzbl (%eax),%eax
  103372:	3c 60                	cmp    $0x60,%al
  103374:	7e 1b                	jle    103391 <strtol+0x105>
  103376:	8b 45 08             	mov    0x8(%ebp),%eax
  103379:	0f b6 00             	movzbl (%eax),%eax
  10337c:	3c 7a                	cmp    $0x7a,%al
  10337e:	7f 11                	jg     103391 <strtol+0x105>
            dig = *s - 'a' + 10;
  103380:	8b 45 08             	mov    0x8(%ebp),%eax
  103383:	0f b6 00             	movzbl (%eax),%eax
  103386:	0f be c0             	movsbl %al,%eax
  103389:	83 e8 57             	sub    $0x57,%eax
  10338c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10338f:	eb 23                	jmp    1033b4 <strtol+0x128>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103391:	8b 45 08             	mov    0x8(%ebp),%eax
  103394:	0f b6 00             	movzbl (%eax),%eax
  103397:	3c 40                	cmp    $0x40,%al
  103399:	7e 3c                	jle    1033d7 <strtol+0x14b>
  10339b:	8b 45 08             	mov    0x8(%ebp),%eax
  10339e:	0f b6 00             	movzbl (%eax),%eax
  1033a1:	3c 5a                	cmp    $0x5a,%al
  1033a3:	7f 32                	jg     1033d7 <strtol+0x14b>
            dig = *s - 'A' + 10;
  1033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a8:	0f b6 00             	movzbl (%eax),%eax
  1033ab:	0f be c0             	movsbl %al,%eax
  1033ae:	83 e8 37             	sub    $0x37,%eax
  1033b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033b7:	3b 45 10             	cmp    0x10(%ebp),%eax
  1033ba:	7d 1a                	jge    1033d6 <strtol+0x14a>
            break;
        }
        s ++, val = (val * base) + dig;
  1033bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033c3:	0f af 45 10          	imul   0x10(%ebp),%eax
  1033c7:	89 c2                	mov    %eax,%edx
  1033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033cc:	01 d0                	add    %edx,%eax
  1033ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1033d1:	e9 71 ff ff ff       	jmp    103347 <strtol+0xbb>
            break;
  1033d6:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1033d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1033db:	74 08                	je     1033e5 <strtol+0x159>
        *endptr = (char *) s;
  1033dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e0:	8b 55 08             	mov    0x8(%ebp),%edx
  1033e3:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1033e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1033e9:	74 07                	je     1033f2 <strtol+0x166>
  1033eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033ee:	f7 d8                	neg    %eax
  1033f0:	eb 03                	jmp    1033f5 <strtol+0x169>
  1033f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1033f5:	c9                   	leave  
  1033f6:	c3                   	ret    

001033f7 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1033f7:	f3 0f 1e fb          	endbr32 
  1033fb:	55                   	push   %ebp
  1033fc:	89 e5                	mov    %esp,%ebp
  1033fe:	57                   	push   %edi
  1033ff:	83 ec 24             	sub    $0x24,%esp
  103402:	e8 a9 ce ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103407:	05 49 d5 00 00       	add    $0xd549,%eax
  10340c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10340f:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103412:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103416:	8b 55 08             	mov    0x8(%ebp),%edx
  103419:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10341c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10341f:	8b 45 10             	mov    0x10(%ebp),%eax
  103422:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103425:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103428:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10342c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10342f:	89 d7                	mov    %edx,%edi
  103431:	f3 aa                	rep stos %al,%es:(%edi)
  103433:	89 fa                	mov    %edi,%edx
  103435:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103438:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10343b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10343e:	83 c4 24             	add    $0x24,%esp
  103441:	5f                   	pop    %edi
  103442:	5d                   	pop    %ebp
  103443:	c3                   	ret    

00103444 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103444:	f3 0f 1e fb          	endbr32 
  103448:	55                   	push   %ebp
  103449:	89 e5                	mov    %esp,%ebp
  10344b:	57                   	push   %edi
  10344c:	56                   	push   %esi
  10344d:	53                   	push   %ebx
  10344e:	83 ec 30             	sub    $0x30,%esp
  103451:	e8 5a ce ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103456:	05 fa d4 00 00       	add    $0xd4fa,%eax
  10345b:	8b 45 08             	mov    0x8(%ebp),%eax
  10345e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103461:	8b 45 0c             	mov    0xc(%ebp),%eax
  103464:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103467:	8b 45 10             	mov    0x10(%ebp),%eax
  10346a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10346d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103470:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103473:	73 42                	jae    1034b7 <memmove+0x73>
  103475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10347e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103484:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103487:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10348a:	c1 e8 02             	shr    $0x2,%eax
  10348d:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10348f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103495:	89 d7                	mov    %edx,%edi
  103497:	89 c6                	mov    %eax,%esi
  103499:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10349b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10349e:	83 e1 03             	and    $0x3,%ecx
  1034a1:	74 02                	je     1034a5 <memmove+0x61>
  1034a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034a5:	89 f0                	mov    %esi,%eax
  1034a7:	89 fa                	mov    %edi,%edx
  1034a9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1034ac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1034af:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  1034b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  1034b5:	eb 36                	jmp    1034ed <memmove+0xa9>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034c0:	01 c2                	add    %eax,%edx
  1034c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034c5:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1034c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034cb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1034ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034d1:	89 c1                	mov    %eax,%ecx
  1034d3:	89 d8                	mov    %ebx,%eax
  1034d5:	89 d6                	mov    %edx,%esi
  1034d7:	89 c7                	mov    %eax,%edi
  1034d9:	fd                   	std    
  1034da:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034dc:	fc                   	cld    
  1034dd:	89 f8                	mov    %edi,%eax
  1034df:	89 f2                	mov    %esi,%edx
  1034e1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1034e4:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1034e7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1034ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1034ed:	83 c4 30             	add    $0x30,%esp
  1034f0:	5b                   	pop    %ebx
  1034f1:	5e                   	pop    %esi
  1034f2:	5f                   	pop    %edi
  1034f3:	5d                   	pop    %ebp
  1034f4:	c3                   	ret    

001034f5 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1034f5:	f3 0f 1e fb          	endbr32 
  1034f9:	55                   	push   %ebp
  1034fa:	89 e5                	mov    %esp,%ebp
  1034fc:	57                   	push   %edi
  1034fd:	56                   	push   %esi
  1034fe:	83 ec 20             	sub    $0x20,%esp
  103501:	e8 aa cd ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103506:	05 4a d4 00 00       	add    $0xd44a,%eax
  10350b:	8b 45 08             	mov    0x8(%ebp),%eax
  10350e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103511:	8b 45 0c             	mov    0xc(%ebp),%eax
  103514:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103517:	8b 45 10             	mov    0x10(%ebp),%eax
  10351a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10351d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103520:	c1 e8 02             	shr    $0x2,%eax
  103523:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103525:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10352b:	89 d7                	mov    %edx,%edi
  10352d:	89 c6                	mov    %eax,%esi
  10352f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103531:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103534:	83 e1 03             	and    $0x3,%ecx
  103537:	74 02                	je     10353b <memcpy+0x46>
  103539:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10353b:	89 f0                	mov    %esi,%eax
  10353d:	89 fa                	mov    %edi,%edx
  10353f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103542:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103545:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103548:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10354b:	83 c4 20             	add    $0x20,%esp
  10354e:	5e                   	pop    %esi
  10354f:	5f                   	pop    %edi
  103550:	5d                   	pop    %ebp
  103551:	c3                   	ret    

00103552 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103552:	f3 0f 1e fb          	endbr32 
  103556:	55                   	push   %ebp
  103557:	89 e5                	mov    %esp,%ebp
  103559:	83 ec 10             	sub    $0x10,%esp
  10355c:	e8 4f cd ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103561:	05 ef d3 00 00       	add    $0xd3ef,%eax
    const char *s1 = (const char *)v1;
  103566:	8b 45 08             	mov    0x8(%ebp),%eax
  103569:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10356c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10356f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103572:	eb 30                	jmp    1035a4 <memcmp+0x52>
        if (*s1 != *s2) {
  103574:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103577:	0f b6 10             	movzbl (%eax),%edx
  10357a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10357d:	0f b6 00             	movzbl (%eax),%eax
  103580:	38 c2                	cmp    %al,%dl
  103582:	74 18                	je     10359c <memcmp+0x4a>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103584:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103587:	0f b6 00             	movzbl (%eax),%eax
  10358a:	0f b6 d0             	movzbl %al,%edx
  10358d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103590:	0f b6 00             	movzbl (%eax),%eax
  103593:	0f b6 c0             	movzbl %al,%eax
  103596:	29 c2                	sub    %eax,%edx
  103598:	89 d0                	mov    %edx,%eax
  10359a:	eb 1a                	jmp    1035b6 <memcmp+0x64>
        }
        s1 ++, s2 ++;
  10359c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1035a0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  1035a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1035a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035aa:	89 55 10             	mov    %edx,0x10(%ebp)
  1035ad:	85 c0                	test   %eax,%eax
  1035af:	75 c3                	jne    103574 <memcmp+0x22>
    }
    return 0;
  1035b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035b6:	c9                   	leave  
  1035b7:	c3                   	ret    

001035b8 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1035b8:	f3 0f 1e fb          	endbr32 
  1035bc:	55                   	push   %ebp
  1035bd:	89 e5                	mov    %esp,%ebp
  1035bf:	53                   	push   %ebx
  1035c0:	83 ec 34             	sub    $0x34,%esp
  1035c3:	e8 ec cc ff ff       	call   1002b4 <__x86.get_pc_thunk.bx>
  1035c8:	81 c3 88 d3 00 00    	add    $0xd388,%ebx
  1035ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1035d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1035d4:	8b 45 14             	mov    0x14(%ebp),%eax
  1035d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1035da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1035dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1035e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1035e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1035e6:	8b 45 18             	mov    0x18(%ebp),%eax
  1035e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1035ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1035f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1035f5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1035f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103602:	74 1c                	je     103620 <printnum+0x68>
  103604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103607:	ba 00 00 00 00       	mov    $0x0,%edx
  10360c:	f7 75 e4             	divl   -0x1c(%ebp)
  10360f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103615:	ba 00 00 00 00       	mov    $0x0,%edx
  10361a:	f7 75 e4             	divl   -0x1c(%ebp)
  10361d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103620:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103623:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103626:	f7 75 e4             	divl   -0x1c(%ebp)
  103629:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10362c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10362f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103632:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103635:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103638:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10363b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10363e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103641:	8b 45 18             	mov    0x18(%ebp),%eax
  103644:	ba 00 00 00 00       	mov    $0x0,%edx
  103649:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10364c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10364f:	19 d1                	sbb    %edx,%ecx
  103651:	72 37                	jb     10368a <printnum+0xd2>
        printnum(putch, putdat, result, base, width - 1, padc);
  103653:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103656:	83 e8 01             	sub    $0x1,%eax
  103659:	83 ec 04             	sub    $0x4,%esp
  10365c:	ff 75 20             	pushl  0x20(%ebp)
  10365f:	50                   	push   %eax
  103660:	ff 75 18             	pushl  0x18(%ebp)
  103663:	ff 75 ec             	pushl  -0x14(%ebp)
  103666:	ff 75 e8             	pushl  -0x18(%ebp)
  103669:	ff 75 0c             	pushl  0xc(%ebp)
  10366c:	ff 75 08             	pushl  0x8(%ebp)
  10366f:	e8 44 ff ff ff       	call   1035b8 <printnum>
  103674:	83 c4 20             	add    $0x20,%esp
  103677:	eb 1b                	jmp    103694 <printnum+0xdc>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103679:	83 ec 08             	sub    $0x8,%esp
  10367c:	ff 75 0c             	pushl  0xc(%ebp)
  10367f:	ff 75 20             	pushl  0x20(%ebp)
  103682:	8b 45 08             	mov    0x8(%ebp),%eax
  103685:	ff d0                	call   *%eax
  103687:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  10368a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10368e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103692:	7f e5                	jg     103679 <printnum+0xc1>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103694:	8d 93 ee 39 ff ff    	lea    -0xc612(%ebx),%edx
  10369a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10369d:	01 d0                	add    %edx,%eax
  10369f:	0f b6 00             	movzbl (%eax),%eax
  1036a2:	0f be c0             	movsbl %al,%eax
  1036a5:	83 ec 08             	sub    $0x8,%esp
  1036a8:	ff 75 0c             	pushl  0xc(%ebp)
  1036ab:	50                   	push   %eax
  1036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1036af:	ff d0                	call   *%eax
  1036b1:	83 c4 10             	add    $0x10,%esp
}
  1036b4:	90                   	nop
  1036b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1036b8:	c9                   	leave  
  1036b9:	c3                   	ret    

001036ba <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1036ba:	f3 0f 1e fb          	endbr32 
  1036be:	55                   	push   %ebp
  1036bf:	89 e5                	mov    %esp,%ebp
  1036c1:	e8 ea cb ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  1036c6:	05 8a d2 00 00       	add    $0xd28a,%eax
    if (lflag >= 2) {
  1036cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1036cf:	7e 14                	jle    1036e5 <getuint+0x2b>
        return va_arg(*ap, unsigned long long);
  1036d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1036d4:	8b 00                	mov    (%eax),%eax
  1036d6:	8d 48 08             	lea    0x8(%eax),%ecx
  1036d9:	8b 55 08             	mov    0x8(%ebp),%edx
  1036dc:	89 0a                	mov    %ecx,(%edx)
  1036de:	8b 50 04             	mov    0x4(%eax),%edx
  1036e1:	8b 00                	mov    (%eax),%eax
  1036e3:	eb 30                	jmp    103715 <getuint+0x5b>
    }
    else if (lflag) {
  1036e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1036e9:	74 16                	je     103701 <getuint+0x47>
        return va_arg(*ap, unsigned long);
  1036eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1036ee:	8b 00                	mov    (%eax),%eax
  1036f0:	8d 48 04             	lea    0x4(%eax),%ecx
  1036f3:	8b 55 08             	mov    0x8(%ebp),%edx
  1036f6:	89 0a                	mov    %ecx,(%edx)
  1036f8:	8b 00                	mov    (%eax),%eax
  1036fa:	ba 00 00 00 00       	mov    $0x0,%edx
  1036ff:	eb 14                	jmp    103715 <getuint+0x5b>
    }
    else {
        return va_arg(*ap, unsigned int);
  103701:	8b 45 08             	mov    0x8(%ebp),%eax
  103704:	8b 00                	mov    (%eax),%eax
  103706:	8d 48 04             	lea    0x4(%eax),%ecx
  103709:	8b 55 08             	mov    0x8(%ebp),%edx
  10370c:	89 0a                	mov    %ecx,(%edx)
  10370e:	8b 00                	mov    (%eax),%eax
  103710:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  103715:	5d                   	pop    %ebp
  103716:	c3                   	ret    

00103717 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103717:	f3 0f 1e fb          	endbr32 
  10371b:	55                   	push   %ebp
  10371c:	89 e5                	mov    %esp,%ebp
  10371e:	e8 8d cb ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103723:	05 2d d2 00 00       	add    $0xd22d,%eax
    if (lflag >= 2) {
  103728:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10372c:	7e 14                	jle    103742 <getint+0x2b>
        return va_arg(*ap, long long);
  10372e:	8b 45 08             	mov    0x8(%ebp),%eax
  103731:	8b 00                	mov    (%eax),%eax
  103733:	8d 48 08             	lea    0x8(%eax),%ecx
  103736:	8b 55 08             	mov    0x8(%ebp),%edx
  103739:	89 0a                	mov    %ecx,(%edx)
  10373b:	8b 50 04             	mov    0x4(%eax),%edx
  10373e:	8b 00                	mov    (%eax),%eax
  103740:	eb 28                	jmp    10376a <getint+0x53>
    }
    else if (lflag) {
  103742:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103746:	74 12                	je     10375a <getint+0x43>
        return va_arg(*ap, long);
  103748:	8b 45 08             	mov    0x8(%ebp),%eax
  10374b:	8b 00                	mov    (%eax),%eax
  10374d:	8d 48 04             	lea    0x4(%eax),%ecx
  103750:	8b 55 08             	mov    0x8(%ebp),%edx
  103753:	89 0a                	mov    %ecx,(%edx)
  103755:	8b 00                	mov    (%eax),%eax
  103757:	99                   	cltd   
  103758:	eb 10                	jmp    10376a <getint+0x53>
    }
    else {
        return va_arg(*ap, int);
  10375a:	8b 45 08             	mov    0x8(%ebp),%eax
  10375d:	8b 00                	mov    (%eax),%eax
  10375f:	8d 48 04             	lea    0x4(%eax),%ecx
  103762:	8b 55 08             	mov    0x8(%ebp),%edx
  103765:	89 0a                	mov    %ecx,(%edx)
  103767:	8b 00                	mov    (%eax),%eax
  103769:	99                   	cltd   
    }
}
  10376a:	5d                   	pop    %ebp
  10376b:	c3                   	ret    

0010376c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10376c:	f3 0f 1e fb          	endbr32 
  103770:	55                   	push   %ebp
  103771:	89 e5                	mov    %esp,%ebp
  103773:	83 ec 18             	sub    $0x18,%esp
  103776:	e8 35 cb ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  10377b:	05 d5 d1 00 00       	add    $0xd1d5,%eax
    va_list ap;

    va_start(ap, fmt);
  103780:	8d 45 14             	lea    0x14(%ebp),%eax
  103783:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103789:	50                   	push   %eax
  10378a:	ff 75 10             	pushl  0x10(%ebp)
  10378d:	ff 75 0c             	pushl  0xc(%ebp)
  103790:	ff 75 08             	pushl  0x8(%ebp)
  103793:	e8 06 00 00 00       	call   10379e <vprintfmt>
  103798:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10379b:	90                   	nop
  10379c:	c9                   	leave  
  10379d:	c3                   	ret    

0010379e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10379e:	f3 0f 1e fb          	endbr32 
  1037a2:	55                   	push   %ebp
  1037a3:	89 e5                	mov    %esp,%ebp
  1037a5:	57                   	push   %edi
  1037a6:	56                   	push   %esi
  1037a7:	53                   	push   %ebx
  1037a8:	83 ec 2c             	sub    $0x2c,%esp
  1037ab:	e8 99 04 00 00       	call   103c49 <__x86.get_pc_thunk.di>
  1037b0:	81 c7 a0 d1 00 00    	add    $0xd1a0,%edi
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1037b6:	eb 17                	jmp    1037cf <vprintfmt+0x31>
            if (ch == '\0') {
  1037b8:	85 db                	test   %ebx,%ebx
  1037ba:	0f 84 9b 03 00 00    	je     103b5b <.L22+0x2d>
                return;
            }
            putch(ch, putdat);
  1037c0:	83 ec 08             	sub    $0x8,%esp
  1037c3:	ff 75 0c             	pushl  0xc(%ebp)
  1037c6:	53                   	push   %ebx
  1037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1037ca:	ff d0                	call   *%eax
  1037cc:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1037cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1037d2:	8d 50 01             	lea    0x1(%eax),%edx
  1037d5:	89 55 10             	mov    %edx,0x10(%ebp)
  1037d8:	0f b6 00             	movzbl (%eax),%eax
  1037db:	0f b6 d8             	movzbl %al,%ebx
  1037de:	83 fb 25             	cmp    $0x25,%ebx
  1037e1:	75 d5                	jne    1037b8 <vprintfmt+0x1a>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1037e3:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
        width = precision = -1;
  1037e7:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  1037ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1037f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
        lflag = altflag = 0;
  1037f4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  1037fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1037fe:	89 45 d0             	mov    %eax,-0x30(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103801:	8b 45 10             	mov    0x10(%ebp),%eax
  103804:	8d 50 01             	lea    0x1(%eax),%edx
  103807:	89 55 10             	mov    %edx,0x10(%ebp)
  10380a:	0f b6 00             	movzbl (%eax),%eax
  10380d:	0f b6 d8             	movzbl %al,%ebx
  103810:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103813:	83 f8 55             	cmp    $0x55,%eax
  103816:	0f 87 12 03 00 00    	ja     103b2e <.L22>
  10381c:	c1 e0 02             	shl    $0x2,%eax
  10381f:	8b 84 38 14 3a ff ff 	mov    -0xc5ec(%eax,%edi,1),%eax
  103826:	01 f8                	add    %edi,%eax
  103828:	3e ff e0             	notrack jmp *%eax

0010382b <.L36>:

        // flag to pad on the right
        case '-':
            padc = '-';
  10382b:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
            goto reswitch;
  10382f:	eb d0                	jmp    103801 <vprintfmt+0x63>

00103831 <.L34>:

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103831:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
            goto reswitch;
  103835:	eb ca                	jmp    103801 <vprintfmt+0x63>

00103837 <.L33>:

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103837:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                precision = precision * 10 + ch - '0';
  10383e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103841:	89 d0                	mov    %edx,%eax
  103843:	c1 e0 02             	shl    $0x2,%eax
  103846:	01 d0                	add    %edx,%eax
  103848:	01 c0                	add    %eax,%eax
  10384a:	01 d8                	add    %ebx,%eax
  10384c:	83 e8 30             	sub    $0x30,%eax
  10384f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                ch = *fmt;
  103852:	8b 45 10             	mov    0x10(%ebp),%eax
  103855:	0f b6 00             	movzbl (%eax),%eax
  103858:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10385b:	83 fb 2f             	cmp    $0x2f,%ebx
  10385e:	7e 39                	jle    103899 <.L39+0xc>
  103860:	83 fb 39             	cmp    $0x39,%ebx
  103863:	7f 34                	jg     103899 <.L39+0xc>
            for (precision = 0; ; ++ fmt) {
  103865:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103869:	eb d3                	jmp    10383e <.L33+0x7>

0010386b <.L37>:
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10386b:	8b 45 14             	mov    0x14(%ebp),%eax
  10386e:	8d 50 04             	lea    0x4(%eax),%edx
  103871:	89 55 14             	mov    %edx,0x14(%ebp)
  103874:	8b 00                	mov    (%eax),%eax
  103876:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            goto process_precision;
  103879:	eb 1f                	jmp    10389a <.L39+0xd>

0010387b <.L35>:

        case '.':
            if (width < 0)
  10387b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10387f:	79 80                	jns    103801 <vprintfmt+0x63>
                width = 0;
  103881:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            goto reswitch;
  103888:	e9 74 ff ff ff       	jmp    103801 <vprintfmt+0x63>

0010388d <.L39>:

        case '#':
            altflag = 1;
  10388d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
            goto reswitch;
  103894:	e9 68 ff ff ff       	jmp    103801 <vprintfmt+0x63>
            goto process_precision;
  103899:	90                   	nop

        process_precision:
            if (width < 0)
  10389a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10389e:	0f 89 5d ff ff ff    	jns    103801 <vprintfmt+0x63>
                width = precision, precision = -1;
  1038a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1038a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1038aa:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
            goto reswitch;
  1038b1:	e9 4b ff ff ff       	jmp    103801 <vprintfmt+0x63>

001038b6 <.L29>:

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1038b6:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
            goto reswitch;
  1038ba:	e9 42 ff ff ff       	jmp    103801 <vprintfmt+0x63>

001038bf <.L32>:

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1038bf:	8b 45 14             	mov    0x14(%ebp),%eax
  1038c2:	8d 50 04             	lea    0x4(%eax),%edx
  1038c5:	89 55 14             	mov    %edx,0x14(%ebp)
  1038c8:	8b 00                	mov    (%eax),%eax
  1038ca:	83 ec 08             	sub    $0x8,%esp
  1038cd:	ff 75 0c             	pushl  0xc(%ebp)
  1038d0:	50                   	push   %eax
  1038d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1038d4:	ff d0                	call   *%eax
  1038d6:	83 c4 10             	add    $0x10,%esp
            break;
  1038d9:	e9 78 02 00 00       	jmp    103b56 <.L22+0x28>

001038de <.L30>:

        // error message
        case 'e':
            err = va_arg(ap, int);
  1038de:	8b 45 14             	mov    0x14(%ebp),%eax
  1038e1:	8d 50 04             	lea    0x4(%eax),%edx
  1038e4:	89 55 14             	mov    %edx,0x14(%ebp)
  1038e7:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1038e9:	85 db                	test   %ebx,%ebx
  1038eb:	79 02                	jns    1038ef <.L30+0x11>
                err = -err;
  1038ed:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1038ef:	83 fb 06             	cmp    $0x6,%ebx
  1038f2:	7f 0b                	jg     1038ff <.L30+0x21>
  1038f4:	8b b4 9f 40 01 00 00 	mov    0x140(%edi,%ebx,4),%esi
  1038fb:	85 f6                	test   %esi,%esi
  1038fd:	75 1b                	jne    10391a <.L30+0x3c>
                printfmt(putch, putdat, "error %d", err);
  1038ff:	53                   	push   %ebx
  103900:	8d 87 ff 39 ff ff    	lea    -0xc601(%edi),%eax
  103906:	50                   	push   %eax
  103907:	ff 75 0c             	pushl  0xc(%ebp)
  10390a:	ff 75 08             	pushl  0x8(%ebp)
  10390d:	e8 5a fe ff ff       	call   10376c <printfmt>
  103912:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103915:	e9 3c 02 00 00       	jmp    103b56 <.L22+0x28>
                printfmt(putch, putdat, "%s", p);
  10391a:	56                   	push   %esi
  10391b:	8d 87 08 3a ff ff    	lea    -0xc5f8(%edi),%eax
  103921:	50                   	push   %eax
  103922:	ff 75 0c             	pushl  0xc(%ebp)
  103925:	ff 75 08             	pushl  0x8(%ebp)
  103928:	e8 3f fe ff ff       	call   10376c <printfmt>
  10392d:	83 c4 10             	add    $0x10,%esp
            break;
  103930:	e9 21 02 00 00       	jmp    103b56 <.L22+0x28>

00103935 <.L26>:

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103935:	8b 45 14             	mov    0x14(%ebp),%eax
  103938:	8d 50 04             	lea    0x4(%eax),%edx
  10393b:	89 55 14             	mov    %edx,0x14(%ebp)
  10393e:	8b 30                	mov    (%eax),%esi
  103940:	85 f6                	test   %esi,%esi
  103942:	75 06                	jne    10394a <.L26+0x15>
                p = "(null)";
  103944:	8d b7 0b 3a ff ff    	lea    -0xc5f5(%edi),%esi
            }
            if (width > 0 && padc != '-') {
  10394a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10394e:	7e 78                	jle    1039c8 <.L26+0x93>
  103950:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  103954:	74 72                	je     1039c8 <.L26+0x93>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103956:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103959:	83 ec 08             	sub    $0x8,%esp
  10395c:	50                   	push   %eax
  10395d:	56                   	push   %esi
  10395e:	89 fb                	mov    %edi,%ebx
  103960:	e8 1b f7 ff ff       	call   103080 <strnlen>
  103965:	83 c4 10             	add    $0x10,%esp
  103968:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10396b:	29 c2                	sub    %eax,%edx
  10396d:	89 d0                	mov    %edx,%eax
  10396f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  103972:	eb 17                	jmp    10398b <.L26+0x56>
                    putch(padc, putdat);
  103974:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  103978:	83 ec 08             	sub    $0x8,%esp
  10397b:	ff 75 0c             	pushl  0xc(%ebp)
  10397e:	50                   	push   %eax
  10397f:	8b 45 08             	mov    0x8(%ebp),%eax
  103982:	ff d0                	call   *%eax
  103984:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  103987:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  10398b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10398f:	7f e3                	jg     103974 <.L26+0x3f>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103991:	eb 35                	jmp    1039c8 <.L26+0x93>
                if (altflag && (ch < ' ' || ch > '~')) {
  103993:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103997:	74 1c                	je     1039b5 <.L26+0x80>
  103999:	83 fb 1f             	cmp    $0x1f,%ebx
  10399c:	7e 05                	jle    1039a3 <.L26+0x6e>
  10399e:	83 fb 7e             	cmp    $0x7e,%ebx
  1039a1:	7e 12                	jle    1039b5 <.L26+0x80>
                    putch('?', putdat);
  1039a3:	83 ec 08             	sub    $0x8,%esp
  1039a6:	ff 75 0c             	pushl  0xc(%ebp)
  1039a9:	6a 3f                	push   $0x3f
  1039ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1039ae:	ff d0                	call   *%eax
  1039b0:	83 c4 10             	add    $0x10,%esp
  1039b3:	eb 0f                	jmp    1039c4 <.L26+0x8f>
                }
                else {
                    putch(ch, putdat);
  1039b5:	83 ec 08             	sub    $0x8,%esp
  1039b8:	ff 75 0c             	pushl  0xc(%ebp)
  1039bb:	53                   	push   %ebx
  1039bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1039bf:	ff d0                	call   *%eax
  1039c1:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1039c4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  1039c8:	89 f0                	mov    %esi,%eax
  1039ca:	8d 70 01             	lea    0x1(%eax),%esi
  1039cd:	0f b6 00             	movzbl (%eax),%eax
  1039d0:	0f be d8             	movsbl %al,%ebx
  1039d3:	85 db                	test   %ebx,%ebx
  1039d5:	74 26                	je     1039fd <.L26+0xc8>
  1039d7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  1039db:	78 b6                	js     103993 <.L26+0x5e>
  1039dd:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  1039e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  1039e5:	79 ac                	jns    103993 <.L26+0x5e>
                }
            }
            for (; width > 0; width --) {
  1039e7:	eb 14                	jmp    1039fd <.L26+0xc8>
                putch(' ', putdat);
  1039e9:	83 ec 08             	sub    $0x8,%esp
  1039ec:	ff 75 0c             	pushl  0xc(%ebp)
  1039ef:	6a 20                	push   $0x20
  1039f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1039f4:	ff d0                	call   *%eax
  1039f6:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  1039f9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  1039fd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  103a01:	7f e6                	jg     1039e9 <.L26+0xb4>
            }
            break;
  103a03:	e9 4e 01 00 00       	jmp    103b56 <.L22+0x28>

00103a08 <.L31>:

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103a08:	83 ec 08             	sub    $0x8,%esp
  103a0b:	ff 75 d0             	pushl  -0x30(%ebp)
  103a0e:	8d 45 14             	lea    0x14(%ebp),%eax
  103a11:	50                   	push   %eax
  103a12:	e8 00 fd ff ff       	call   103717 <getint>
  103a17:	83 c4 10             	add    $0x10,%esp
  103a1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103a1d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            if ((long long)num < 0) {
  103a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103a23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103a26:	85 d2                	test   %edx,%edx
  103a28:	79 23                	jns    103a4d <.L31+0x45>
                putch('-', putdat);
  103a2a:	83 ec 08             	sub    $0x8,%esp
  103a2d:	ff 75 0c             	pushl  0xc(%ebp)
  103a30:	6a 2d                	push   $0x2d
  103a32:	8b 45 08             	mov    0x8(%ebp),%eax
  103a35:	ff d0                	call   *%eax
  103a37:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  103a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103a3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103a40:	f7 d8                	neg    %eax
  103a42:	83 d2 00             	adc    $0x0,%edx
  103a45:	f7 da                	neg    %edx
  103a47:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103a4a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            }
            base = 10;
  103a4d:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  103a54:	e9 9f 00 00 00       	jmp    103af8 <.L23+0x1f>

00103a59 <.L25>:

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103a59:	83 ec 08             	sub    $0x8,%esp
  103a5c:	ff 75 d0             	pushl  -0x30(%ebp)
  103a5f:	8d 45 14             	lea    0x14(%ebp),%eax
  103a62:	50                   	push   %eax
  103a63:	e8 52 fc ff ff       	call   1036ba <getuint>
  103a68:	83 c4 10             	add    $0x10,%esp
  103a6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103a6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 10;
  103a71:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  103a78:	eb 7e                	jmp    103af8 <.L23+0x1f>

00103a7a <.L28>:

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103a7a:	83 ec 08             	sub    $0x8,%esp
  103a7d:	ff 75 d0             	pushl  -0x30(%ebp)
  103a80:	8d 45 14             	lea    0x14(%ebp),%eax
  103a83:	50                   	push   %eax
  103a84:	e8 31 fc ff ff       	call   1036ba <getuint>
  103a89:	83 c4 10             	add    $0x10,%esp
  103a8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103a8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 8;
  103a92:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
            goto number;
  103a99:	eb 5d                	jmp    103af8 <.L23+0x1f>

00103a9b <.L27>:

        // pointer
        case 'p':
            putch('0', putdat);
  103a9b:	83 ec 08             	sub    $0x8,%esp
  103a9e:	ff 75 0c             	pushl  0xc(%ebp)
  103aa1:	6a 30                	push   $0x30
  103aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  103aa6:	ff d0                	call   *%eax
  103aa8:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  103aab:	83 ec 08             	sub    $0x8,%esp
  103aae:	ff 75 0c             	pushl  0xc(%ebp)
  103ab1:	6a 78                	push   $0x78
  103ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ab6:	ff d0                	call   *%eax
  103ab8:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  103abb:	8b 45 14             	mov    0x14(%ebp),%eax
  103abe:	8d 50 04             	lea    0x4(%eax),%edx
  103ac1:	89 55 14             	mov    %edx,0x14(%ebp)
  103ac4:	8b 00                	mov    (%eax),%eax
  103ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ac9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            base = 16;
  103ad0:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
            goto number;
  103ad7:	eb 1f                	jmp    103af8 <.L23+0x1f>

00103ad9 <.L23>:

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103ad9:	83 ec 08             	sub    $0x8,%esp
  103adc:	ff 75 d0             	pushl  -0x30(%ebp)
  103adf:	8d 45 14             	lea    0x14(%ebp),%eax
  103ae2:	50                   	push   %eax
  103ae3:	e8 d2 fb ff ff       	call   1036ba <getuint>
  103ae8:	83 c4 10             	add    $0x10,%esp
  103aeb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103aee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 16;
  103af1:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103af8:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  103afc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103aff:	83 ec 04             	sub    $0x4,%esp
  103b02:	52                   	push   %edx
  103b03:	ff 75 d8             	pushl  -0x28(%ebp)
  103b06:	50                   	push   %eax
  103b07:	ff 75 e4             	pushl  -0x1c(%ebp)
  103b0a:	ff 75 e0             	pushl  -0x20(%ebp)
  103b0d:	ff 75 0c             	pushl  0xc(%ebp)
  103b10:	ff 75 08             	pushl  0x8(%ebp)
  103b13:	e8 a0 fa ff ff       	call   1035b8 <printnum>
  103b18:	83 c4 20             	add    $0x20,%esp
            break;
  103b1b:	eb 39                	jmp    103b56 <.L22+0x28>

00103b1d <.L38>:

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103b1d:	83 ec 08             	sub    $0x8,%esp
  103b20:	ff 75 0c             	pushl  0xc(%ebp)
  103b23:	53                   	push   %ebx
  103b24:	8b 45 08             	mov    0x8(%ebp),%eax
  103b27:	ff d0                	call   *%eax
  103b29:	83 c4 10             	add    $0x10,%esp
            break;
  103b2c:	eb 28                	jmp    103b56 <.L22+0x28>

00103b2e <.L22>:

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103b2e:	83 ec 08             	sub    $0x8,%esp
  103b31:	ff 75 0c             	pushl  0xc(%ebp)
  103b34:	6a 25                	push   $0x25
  103b36:	8b 45 08             	mov    0x8(%ebp),%eax
  103b39:	ff d0                	call   *%eax
  103b3b:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  103b3e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103b42:	eb 04                	jmp    103b48 <.L22+0x1a>
  103b44:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103b48:	8b 45 10             	mov    0x10(%ebp),%eax
  103b4b:	83 e8 01             	sub    $0x1,%eax
  103b4e:	0f b6 00             	movzbl (%eax),%eax
  103b51:	3c 25                	cmp    $0x25,%al
  103b53:	75 ef                	jne    103b44 <.L22+0x16>
                /* do nothing */;
            break;
  103b55:	90                   	nop
    while (1) {
  103b56:	e9 5b fc ff ff       	jmp    1037b6 <vprintfmt+0x18>
                return;
  103b5b:	90                   	nop
        }
    }
}
  103b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  103b5f:	5b                   	pop    %ebx
  103b60:	5e                   	pop    %esi
  103b61:	5f                   	pop    %edi
  103b62:	5d                   	pop    %ebp
  103b63:	c3                   	ret    

00103b64 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103b64:	f3 0f 1e fb          	endbr32 
  103b68:	55                   	push   %ebp
  103b69:	89 e5                	mov    %esp,%ebp
  103b6b:	e8 40 c7 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103b70:	05 e0 cd 00 00       	add    $0xcde0,%eax
    b->cnt ++;
  103b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b78:	8b 40 08             	mov    0x8(%eax),%eax
  103b7b:	8d 50 01             	lea    0x1(%eax),%edx
  103b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b81:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b87:	8b 10                	mov    (%eax),%edx
  103b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b8c:	8b 40 04             	mov    0x4(%eax),%eax
  103b8f:	39 c2                	cmp    %eax,%edx
  103b91:	73 12                	jae    103ba5 <sprintputch+0x41>
        *b->buf ++ = ch;
  103b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b96:	8b 00                	mov    (%eax),%eax
  103b98:	8d 48 01             	lea    0x1(%eax),%ecx
  103b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  103b9e:	89 0a                	mov    %ecx,(%edx)
  103ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  103ba3:	88 10                	mov    %dl,(%eax)
    }
}
  103ba5:	90                   	nop
  103ba6:	5d                   	pop    %ebp
  103ba7:	c3                   	ret    

00103ba8 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103ba8:	f3 0f 1e fb          	endbr32 
  103bac:	55                   	push   %ebp
  103bad:	89 e5                	mov    %esp,%ebp
  103baf:	83 ec 18             	sub    $0x18,%esp
  103bb2:	e8 f9 c6 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103bb7:	05 99 cd 00 00       	add    $0xcd99,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103bbc:	8d 45 14             	lea    0x14(%ebp),%eax
  103bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bc5:	50                   	push   %eax
  103bc6:	ff 75 10             	pushl  0x10(%ebp)
  103bc9:	ff 75 0c             	pushl  0xc(%ebp)
  103bcc:	ff 75 08             	pushl  0x8(%ebp)
  103bcf:	e8 0b 00 00 00       	call   103bdf <vsnprintf>
  103bd4:	83 c4 10             	add    $0x10,%esp
  103bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103bdd:	c9                   	leave  
  103bde:	c3                   	ret    

00103bdf <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103bdf:	f3 0f 1e fb          	endbr32 
  103be3:	55                   	push   %ebp
  103be4:	89 e5                	mov    %esp,%ebp
  103be6:	83 ec 18             	sub    $0x18,%esp
  103be9:	e8 c2 c6 ff ff       	call   1002b0 <__x86.get_pc_thunk.ax>
  103bee:	05 62 cd 00 00       	add    $0xcd62,%eax
    struct sprintbuf b = {str, str + size - 1, 0};
  103bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  103bf6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  103bfc:	8d 4a ff             	lea    -0x1(%edx),%ecx
  103bff:	8b 55 08             	mov    0x8(%ebp),%edx
  103c02:	01 ca                	add    %ecx,%edx
  103c04:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103c07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103c12:	74 0a                	je     103c1e <vsnprintf+0x3f>
  103c14:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103c17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103c1a:	39 d1                	cmp    %edx,%ecx
  103c1c:	76 07                	jbe    103c25 <vsnprintf+0x46>
        return -E_INVAL;
  103c1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103c23:	eb 22                	jmp    103c47 <vsnprintf+0x68>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103c25:	ff 75 14             	pushl  0x14(%ebp)
  103c28:	ff 75 10             	pushl  0x10(%ebp)
  103c2b:	8d 55 ec             	lea    -0x14(%ebp),%edx
  103c2e:	52                   	push   %edx
  103c2f:	8d 80 14 32 ff ff    	lea    -0xcdec(%eax),%eax
  103c35:	50                   	push   %eax
  103c36:	e8 63 fb ff ff       	call   10379e <vprintfmt>
  103c3b:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c41:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103c47:	c9                   	leave  
  103c48:	c3                   	ret    

00103c49 <__x86.get_pc_thunk.di>:
  103c49:	8b 3c 24             	mov    (%esp),%edi
  103c4c:	c3                   	ret    
