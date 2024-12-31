/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/FPGA_project/MSTR111_Driver_4x16_BS1_upper_FBS/tb_Top.v";
static int ng1[] = {24, 0};
static int ng2[] = {0, 0};
static int ng3[] = {1, 0};
static unsigned int ng4[] = {10U, 0U};
static unsigned int ng5[] = {2097163U, 0U};



static int sp_spi_send_bytes(char *t1, char *t2)
{
    char t5[8];
    char t20[8];
    char t22[8];
    int t0;
    char *t3;
    char *t4;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t21;
    char *t23;
    char *t24;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    char *t34;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 984);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(137, ng0);

LAB5:    xsi_set_current_line(138, ng0);
    t6 = (t1 + 4576);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    xsi_vlogtype_concat(t5, 24, 24, 1U, t8, 24);
    t9 = (t1 + 4896);
    xsi_vlogvar_assign_value(t9, t5, 0, 0, 24);
    xsi_set_current_line(139, ng0);
    xsi_set_current_line(139, ng0);
    t4 = ((char*)((ng1)));
    t6 = (t1 + 4736);
    xsi_vlogvar_assign_value(t6, t4, 0, 0, 32);

LAB6:    t4 = (t1 + 4736);
    t6 = (t4 + 56U);
    t7 = *((char **)t6);
    t8 = ((char*)((ng2)));
    memset(t5, 0, 8);
    xsi_vlog_signed_greater(t5, 32, t7, 32, t8, 32);
    t9 = (t5 + 4);
    t10 = *((unsigned int *)t9);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB7;

LAB8:
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB7:    xsi_set_current_line(139, ng0);

LAB9:    xsi_set_current_line(140, ng0);
    t15 = ((char*)((ng2)));
    t16 = (t1 + 3456);
    xsi_vlogvar_wait_assign_value(t16, t15, 0, 0, 1, 0LL);
    xsi_set_current_line(141, ng0);
    t4 = (t1 + 4896);
    t6 = (t4 + 56U);
    t7 = *((char **)t6);
    t8 = (t1 + 4896);
    t9 = (t8 + 72U);
    t15 = *((char **)t9);
    t16 = (t1 + 4736);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    t19 = ((char*)((ng3)));
    memset(t20, 0, 8);
    xsi_vlog_signed_minus(t20, 32, t18, 32, t19, 32);
    xsi_vlog_generic_get_index_select_value(t5, 1, t7, t15, 2, t20, 32, 1);
    t21 = (t1 + 3616);
    xsi_vlogvar_wait_assign_value(t21, t5, 0, 0, 1, 0LL);
    xsi_set_current_line(142, ng0);
    t4 = (t1 + 4896);
    t6 = (t4 + 56U);
    t7 = *((char **)t6);
    t8 = (t1 + 4896);
    t9 = (t8 + 72U);
    t15 = *((char **)t9);
    t16 = (t1 + 4736);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    t19 = ((char*)((ng3)));
    memset(t22, 0, 8);
    xsi_vlog_signed_minus(t22, 32, t18, 32, t19, 32);
    xsi_vlog_generic_get_index_select_value(t20, 1, t7, t15, 2, t22, 32, 1);
    memset(t5, 0, 8);
    t21 = (t20 + 4);
    t10 = *((unsigned int *)t21);
    t11 = (~(t10));
    t12 = *((unsigned int *)t20);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB13;

LAB11:    if (*((unsigned int *)t21) == 0)
        goto LAB10;

LAB12:    t23 = (t5 + 4);
    *((unsigned int *)t5) = 1;
    *((unsigned int *)t23) = 1;

LAB13:    t24 = (t5 + 4);
    t25 = (t20 + 4);
    t26 = *((unsigned int *)t20);
    t27 = (~(t26));
    *((unsigned int *)t5) = t27;
    *((unsigned int *)t24) = 0;
    if (*((unsigned int *)t25) != 0)
        goto LAB15;

LAB14:    t32 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t32 & 1U);
    t33 = *((unsigned int *)t24);
    *((unsigned int *)t24) = (t33 & 1U);
    t34 = (t1 + 3776);
    xsi_vlogvar_wait_assign_value(t34, t5, 0, 0, 1, 0LL);
    xsi_set_current_line(143, ng0);
    t4 = ((char*)((ng2)));
    t6 = (t1 + 3936);
    xsi_vlogvar_wait_assign_value(t6, t4, 0, 0, 1, 0LL);
    xsi_set_current_line(144, ng0);
    t4 = ((char*)((ng3)));
    t6 = (t1 + 4096);
    xsi_vlogvar_wait_assign_value(t6, t4, 0, 0, 1, 0LL);
    xsi_set_current_line(145, ng0);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    xsi_process_wait(t6, 20000LL);
    *((char **)t3) = &&LAB16;
    t0 = 1;
    goto LAB1;

LAB10:    *((unsigned int *)t5) = 1;
    goto LAB13;

LAB15:    t28 = *((unsigned int *)t5);
    t29 = *((unsigned int *)t25);
    *((unsigned int *)t5) = (t28 | t29);
    t30 = *((unsigned int *)t24);
    t31 = *((unsigned int *)t25);
    *((unsigned int *)t24) = (t30 | t31);
    goto LAB14;

LAB16:    xsi_set_current_line(146, ng0);
    t4 = ((char*)((ng3)));
    t6 = (t1 + 3936);
    xsi_vlogvar_wait_assign_value(t6, t4, 0, 0, 1, 0LL);
    xsi_set_current_line(147, ng0);
    t4 = ((char*)((ng2)));
    t6 = (t1 + 4096);
    xsi_vlogvar_wait_assign_value(t6, t4, 0, 0, 1, 0LL);
    xsi_set_current_line(148, ng0);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    xsi_process_wait(t6, 20000LL);
    *((char **)t3) = &&LAB17;
    t0 = 1;
    goto LAB1;

LAB17:    xsi_set_current_line(139, ng0);
    t4 = (t1 + 4736);
    t6 = (t4 + 56U);
    t7 = *((char **)t6);
    t8 = ((char*)((ng3)));
    memset(t5, 0, 8);
    xsi_vlog_signed_minus(t5, 32, t7, 32, t8, 32);
    t9 = (t1 + 4736);
    xsi_vlogvar_assign_value(t9, t5, 0, 0, 32);
    goto LAB6;

}

static void Always_94_0(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;

LAB0:    t1 = (t0 + 5816U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(94, ng0);
    t2 = (t0 + 5624);
    xsi_process_wait(t2, 5000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(94, ng0);
    t4 = (t0 + 2976);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memset(t3, 0, 8);
    t7 = (t6 + 4);
    t8 = *((unsigned int *)t7);
    t9 = (~(t8));
    t10 = *((unsigned int *)t6);
    t11 = (t10 & t9);
    t12 = (t11 & 1U);
    if (t12 != 0)
        goto LAB8;

LAB6:    if (*((unsigned int *)t7) == 0)
        goto LAB5;

LAB7:    t13 = (t3 + 4);
    *((unsigned int *)t3) = 1;
    *((unsigned int *)t13) = 1;

LAB8:    t14 = (t3 + 4);
    t15 = (t6 + 4);
    t16 = *((unsigned int *)t6);
    t17 = (~(t16));
    *((unsigned int *)t3) = t17;
    *((unsigned int *)t14) = 0;
    if (*((unsigned int *)t15) != 0)
        goto LAB10;

LAB9:    t22 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t22 & 1U);
    t23 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t23 & 1U);
    t24 = (t0 + 2976);
    xsi_vlogvar_assign_value(t24, t3, 0, 0, 1);
    goto LAB2;

LAB5:    *((unsigned int *)t3) = 1;
    goto LAB8;

LAB10:    t18 = *((unsigned int *)t3);
    t19 = *((unsigned int *)t15);
    *((unsigned int *)t3) = (t18 | t19);
    t20 = *((unsigned int *)t14);
    t21 = *((unsigned int *)t15);
    *((unsigned int *)t14) = (t20 | t21);
    goto LAB9;

}

static void Initial_95_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    int t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    t1 = (t0 + 6064U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(95, ng0);

LAB4:    xsi_set_current_line(97, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2976);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(98, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3136);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(99, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3296);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(100, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4256);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 4);
    xsi_set_current_line(101, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3456);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(102, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3616);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(103, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3776);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(104, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3936);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(107, ng0);
    t2 = (t0 + 5872);
    xsi_process_wait(t2, 40000000000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(112, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 5872);
    t4 = (t0 + 984);
    t5 = xsi_create_subprogram_invocation(t3, 0, t0, t4, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t4, t5);
    t6 = (t0 + 4576);
    xsi_vlogvar_assign_value(t6, t2, 0, 0, 24);

LAB8:    t7 = (t0 + 5968);
    t8 = *((char **)t7);
    t9 = (t8 + 80U);
    t10 = *((char **)t9);
    t11 = (t10 + 272U);
    t12 = *((char **)t11);
    t13 = (t12 + 0U);
    t14 = *((char **)t13);
    t15 = ((int  (*)(char *, char *))t14)(t0, t8);

LAB10:    if (t15 != 0)
        goto LAB11;

LAB6:    t8 = (t0 + 984);
    xsi_vlog_subprogram_popinvocation(t8);

LAB7:    t16 = (t0 + 5968);
    t17 = *((char **)t16);
    t16 = (t0 + 984);
    t18 = (t0 + 5872);
    t19 = 0;
    xsi_delete_subprogram_invocation(t16, t17, t0, t18, t19);
    xsi_set_current_line(113, ng0);
    t2 = (t0 + 5872);
    xsi_process_wait(t2, 4000000LL);
    *((char **)t1) = &&LAB12;
    goto LAB1;

LAB9:;
LAB11:    t7 = (t0 + 6064U);
    *((char **)t7) = &&LAB8;
    goto LAB1;

LAB12:    xsi_set_current_line(116, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 5872);
    t4 = (t0 + 984);
    t5 = xsi_create_subprogram_invocation(t3, 0, t0, t4, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t4, t5);
    t6 = (t0 + 4576);
    xsi_vlogvar_assign_value(t6, t2, 0, 0, 24);

LAB15:    t7 = (t0 + 5968);
    t8 = *((char **)t7);
    t9 = (t8 + 80U);
    t10 = *((char **)t9);
    t11 = (t10 + 272U);
    t12 = *((char **)t11);
    t13 = (t12 + 0U);
    t14 = *((char **)t13);
    t15 = ((int  (*)(char *, char *))t14)(t0, t8);

LAB17:    if (t15 != 0)
        goto LAB18;

LAB13:    t8 = (t0 + 984);
    xsi_vlog_subprogram_popinvocation(t8);

LAB14:    t16 = (t0 + 5968);
    t17 = *((char **)t16);
    t16 = (t0 + 984);
    t18 = (t0 + 5872);
    t19 = 0;
    xsi_delete_subprogram_invocation(t16, t17, t0, t18, t19);
    xsi_set_current_line(117, ng0);
    t2 = (t0 + 5872);
    xsi_process_wait(t2, 2000000LL);
    *((char **)t1) = &&LAB19;
    goto LAB1;

LAB16:;
LAB18:    t7 = (t0 + 6064U);
    *((char **)t7) = &&LAB15;
    goto LAB1;

LAB19:    xsi_set_current_line(119, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3456);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(120, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3616);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(121, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3776);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(122, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3936);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(123, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4096);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(124, ng0);
    t2 = (t0 + 5872);
    xsi_process_wait(t2, 4000000LL);
    *((char **)t1) = &&LAB20;
    goto LAB1;

LAB20:    xsi_set_current_line(126, ng0);
    xsi_vlog_stop(1);
    goto LAB1;

}


extern void work_m_00000000000788679286_3622719947_init()
{
	static char *pe[] = {(void *)Always_94_0,(void *)Initial_95_1};
	static char *se[] = {(void *)sp_spi_send_bytes};
	xsi_register_didat("work_m_00000000000788679286_3622719947", "isim/tb_top_isim_beh.exe.sim/work/m_00000000000788679286_3622719947.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
