#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_clock.h>
#include <list.h>

//主要修改_clock_map_swappable  _clock_swap_out_victim两个函数

list_entry_t pra_list_head;

static int
_clock_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}

static int
_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head -> prev, entry);// 新插入的页dirty bit标记为0.
    struct Page *ptr = le2page(entry, pra_page_link);
    pte_t *pte = get_pte(mm -> pgdir, ptr -> pra_vaddr, 0);
    *pte &= ~PTE_A;
    *pte &= ~PTE_D;
    return 0;
}
/*
 *  (4)_clock_swap_out_victim: 
 *                           
 */
static int
_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    assert(head != NULL);
    assert(in_tick==0);
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
    list_entry_t *p = head;
    /*未优化的算法
    while (1) {
        p = list_next(p);
        if (p == head) {
             p = list_next(p);
         }
        struct Page *ptr = le2page(p, pra_page_link);
        pte_t *pte = get_pte(mm -> pgdir, ptr -> pra_vaddr, 0);
         //获取页表项
        if ((*pte & PTE_A) == 1) {// 如果访问位为1，改为0
             *pte &= ~PTE_A;
         } 
        else 
        {// 如果访问位为0，则标记为换出页
             *ptr_page = ptr;
             list_del(p);
             break;
        }
     }         
    */
   //优化后的算法
    list_entry_t *start =p;
    int c=0;   
    bool find=0;
    while(find==0)
    {
        while(find==0){
            p = list_next(p);             
            if (p == head) {
                p = list_next(p);
            }
            if(p==start->next)
            {
                c++;
            }
            if(c==2)break;
            struct Page *ptr = le2page(p, pra_page_link);
            pte_t *pte = get_pte(mm -> pgdir, ptr -> pra_vaddr, 0);
            //获取页表项
            if ((*pte & PTE_D) == 1||(*pte & PTE_A) == 1) {

                //*pte &= ~PTE_D;
            } 
            else{//将修改位为0 使用位为0的页置换
                *ptr_page = ptr;
                list_del(p);
                find=1;
                break;

            }
        }
        c=0;
        while (find==0)
        {
            p = list_next(p);             
            if (p == head) {
                p = list_next(p);
            }
            if(p==start->next)
            {
                c++;
            }
            if(c==2)break;
            struct Page *ptr = le2page(p, pra_page_link);
            pte_t *pte = get_pte(mm -> pgdir, ptr -> pra_vaddr, 0);
            //获取页表项
            if ((*pte & PTE_A) == 1) {  //将所有的修改位 置0
                *pte &= ~PTE_A;
            } 
            else//将遇到的第一个修改位为1，使用位为0的页置换
            {
                *ptr_page = ptr;
                list_del(p);
                find=1;
                break;
            }  
        }    
    }
    return 0;
}

static int
_clock_check_swap(void) {
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==4);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==5);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==6);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==7);
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==8);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==9);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==10);
    cprintf("write Virt Page a in fifo_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==11);
    return 0;
}


static int
_clock_init(void)
{
    return 0;
}

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_clock_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_clock =
{
     .name            = "clock swap manager",
     .init            = &_clock_init,
     .init_mm         = &_clock_init_mm,
     .tick_event      = &_clock_tick_event,
     .map_swappable   = &_clock_map_swappable,
     .set_unswappable = &_clock_set_unswappable,
     .swap_out_victim = &_clock_swap_out_victim,
     .check_swap      = &_clock_check_swap,
};
