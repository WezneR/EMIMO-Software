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
static const char *ng0 = "F:/ISE/UE_CTRL/srcs/tb_Top.v";
static int ng1[] = {0, 0};
static int ng2[] = {8, 0};
static int ng3[] = {1, 0};
static unsigned int ng4[] = {262656U, 0U, 21853U, 0U, 0U, 0U};
static int ng5[] = {6, 0};
static unsigned int ng6[] = {17039616U, 0U, 21853U, 0U, 0U, 0U};
static unsigned int ng7[] = {33816576U, 0U, 21853U, 0U, 0U, 0U};
static unsigned int ng8[] = {33817088U, 0U, 21853U, 0U, 0U, 0U};
static unsigned int ng9[] = {34210106U, 0U, 21853U, 0U, 0U, 0U};
static unsigned int ng10[] = {7995455U, 0U, 21853U, 0U, 0U, 0U};
static unsigned int ng11[] = {31064064U, 0U, 21853U, 0U, 0U, 0U};



static int sp_send_byte(char *t1, char *t2)
{
    char t8[8];
    char t18[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t17;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 984);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(183, ng0);

LAB5:    xsi_set_current_line(184, ng0);
    t5 = ((char*)((ng1)));
    t6 = (t1 + 6128);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 1);
    xsi_set_current_line(185, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 8680000LL);
    *((char **)t3) = &&LAB6;
    t0 = 1;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB6:    xsi_set_current_line(186, ng0);
    xsi_set_current_line(186, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t1 + 8208);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 32);

LAB7:    t4 = (t1 + 8208);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = ((char*)((ng2)));
    memset(t8, 0, 8);
    xsi_vlog_signed_less(t8, 32, t6, 32, t7, 32);
    t9 = (t8 + 4);
    t10 = *((unsigned int *)t9);
    t11 = (~(t10));
    t12 = *((unsigned int *)t8);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB8;

LAB9:    xsi_set_current_line(190, ng0);
    t4 = ((char*)((ng3)));
    t5 = (t1 + 6128);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(191, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 8680000LL);
    *((char **)t3) = &&LAB12;
    t0 = 1;
    goto LAB1;

LAB8:    xsi_set_current_line(186, ng0);

LAB10:    xsi_set_current_line(187, ng0);
    t15 = (t1 + 8048);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    t19 = (t1 + 8048);
    t20 = (t19 + 72U);
    t21 = *((char **)t20);
    t22 = (t1 + 8208);
    t23 = (t22 + 56U);
    t24 = *((char **)t23);
    xsi_vlog_generic_get_index_select_value(t18, 1, t17, t21, 2, t24, 32, 1);
    t25 = (t1 + 6128);
    xsi_vlogvar_assign_value(t25, t18, 0, 0, 1);
    xsi_set_current_line(188, ng0);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_process_wait(t5, 8680000LL);
    *((char **)t3) = &&LAB11;
    t0 = 1;
    goto LAB1;

LAB11:    xsi_set_current_line(186, ng0);
    t4 = (t1 + 8208);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = ((char*)((ng3)));
    memset(t8, 0, 8);
    xsi_vlog_signed_add(t8, 32, t6, 32, t7, 32);
    t9 = (t1 + 8208);
    xsi_vlogvar_assign_value(t9, t8, 0, 0, 32);
    goto LAB7;

LAB12:    goto LAB4;

}

static int sp_send_multiple_bytes(char *t1, char *t2)
{
    char t10[8];
    char t17[8];
    char t30[8];
    char t32[8];
    char t34[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t31;
    char *t33;
    char *t35;
    char *t36;
    int t37;
    char *t38;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 1416);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(201, ng0);

LAB5:    xsi_set_current_line(202, ng0);
    xsi_set_current_line(202, ng0);
    t5 = ((char*)((ng1)));
    t6 = (t1 + 8688);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 32);

LAB6:    t4 = (t1 + 8688);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t1 + 8528);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memset(t10, 0, 8);
    xsi_vlog_signed_less(t10, 32, t6, 32, t9, 32);
    t11 = (t10 + 4);
    t12 = *((unsigned int *)t11);
    t13 = (~(t12));
    t14 = *((unsigned int *)t10);
    t15 = (t14 & t13);
    t16 = (t15 != 0);
    if (t16 > 0)
        goto LAB7;

LAB8:
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB7:    xsi_set_current_line(202, ng0);

LAB9:    xsi_set_current_line(203, ng0);
    t18 = (t1 + 8368);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    t21 = (t1 + 8368);
    t22 = (t21 + 72U);
    t23 = *((char **)t22);
    t24 = (t1 + 8528);
    t25 = (t24 + 56U);
    t26 = *((char **)t25);
    t27 = (t1 + 8688);
    t28 = (t27 + 56U);
    t29 = *((char **)t28);
    memset(t30, 0, 8);
    xsi_vlog_signed_minus(t30, 32, t26, 32, t29, 32);
    t31 = ((char*)((ng3)));
    memset(t32, 0, 8);
    xsi_vlog_signed_minus(t32, 32, t30, 32, t31, 32);
    t33 = ((char*)((ng2)));
    memset(t34, 0, 8);
    xsi_vlog_signed_multiply(t34, 32, t32, 32, t33, 32);
    t35 = ((char*)((ng2)));
    xsi_vlog_get_indexed_partselect(t17, 8, t20, ((int*)(t23)), 2, t34, 32, 1, t35, 32, 1, 1);
    t36 = (t1 + 8848);
    xsi_vlogvar_assign_value(t36, t17, 0, 0, 8);
    xsi_set_current_line(204, ng0);
    t4 = (t1 + 8848);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t2 + 56U);
    t8 = *((char **)t7);
    t9 = (t2 + 56U);
    t11 = *((char **)t9);
    xsi_vlog_subprograminvocation_setJumpstate(t2, t11, &&LAB10);
    t18 = (t2 + 56U);
    t19 = *((char **)t18);
    t20 = (t1 + 984);
    t21 = xsi_create_subprogram_invocation(t19, 0, t1, t20, 0, t2);
    xsi_vlog_subprogram_pushinvocation(t20, t21);
    t22 = (t1 + 8048);
    xsi_vlogvar_assign_value(t22, t6, 0, 0, 8);

LAB12:    t23 = (t2 + 64U);
    t24 = *((char **)t23);
    t25 = (t24 + 80U);
    t26 = *((char **)t25);
    t27 = (t26 + 272U);
    t28 = *((char **)t27);
    t29 = (t28 + 0U);
    t31 = *((char **)t29);
    t37 = ((int  (*)(char *, char *))t31)(t1, t24);
    if (t37 == -1)
        goto LAB13;

LAB14:    if (t37 != 0)
        goto LAB15;

LAB10:    t24 = (t1 + 984);
    xsi_vlog_subprogram_popinvocation(t24);

LAB11:    t33 = (t2 + 64U);
    t35 = *((char **)t33);
    t33 = (t1 + 984);
    t36 = (t2 + 56U);
    t38 = *((char **)t36);
    xsi_delete_subprogram_invocation(t33, t35, t1, t38, t2);
    xsi_set_current_line(202, ng0);
    t4 = (t1 + 8688);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = ((char*)((ng3)));
    memset(t10, 0, 8);
    xsi_vlog_signed_add(t10, 32, t6, 32, t7, 32);
    t8 = (t1 + 8688);
    xsi_vlogvar_assign_value(t8, t10, 0, 0, 32);
    goto LAB6;

LAB13:    t0 = -1;
    goto LAB1;

LAB15:    t23 = (t2 + 48U);
    *((char **)t23) = &&LAB12;
    goto LAB1;

}

static void Initial_112_0(char *t0)
{
    char t4[8];
    char *t1;
    char *t2;
    char *t3;
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

LAB0:    t1 = (t0 + 9768U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(112, ng0);

LAB4:    xsi_set_current_line(113, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4688);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(114, ng0);

LAB5:    xsi_set_current_line(114, ng0);

LAB6:    xsi_set_current_line(116, ng0);
    t2 = (t0 + 9576);
    xsi_process_wait(t2, 5000LL);
    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB7:    xsi_set_current_line(116, ng0);
    t3 = (t0 + 4688);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    memset(t4, 0, 8);
    t7 = (t6 + 4);
    t8 = *((unsigned int *)t7);
    t9 = (~(t8));
    t10 = *((unsigned int *)t6);
    t11 = (t10 & t9);
    t12 = (t11 & 1U);
    if (t12 != 0)
        goto LAB11;

LAB9:    if (*((unsigned int *)t7) == 0)
        goto LAB8;

LAB10:    t13 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t13) = 1;

LAB11:    t14 = (t4 + 4);
    t15 = (t6 + 4);
    t16 = *((unsigned int *)t6);
    t17 = (~(t16));
    *((unsigned int *)t4) = t17;
    *((unsigned int *)t14) = 0;
    if (*((unsigned int *)t15) != 0)
        goto LAB13;

LAB12:    t22 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t22 & 1U);
    t23 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t23 & 1U);
    t24 = (t0 + 4688);
    xsi_vlogvar_assign_value(t24, t4, 0, 0, 1);
    goto LAB5;

LAB8:    *((unsigned int *)t4) = 1;
    goto LAB11;

LAB13:    t18 = *((unsigned int *)t4);
    t19 = *((unsigned int *)t15);
    *((unsigned int *)t4) = (t18 | t19);
    t20 = *((unsigned int *)t14);
    t21 = *((unsigned int *)t15);
    *((unsigned int *)t14) = (t20 | t21);
    goto LAB12;

LAB14:    goto LAB1;

}

static void Initial_121_1(char *t0)
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
    char *t15;
    char *t16;
    int t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;

LAB0:    t1 = (t0 + 10016U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(121, ng0);

LAB4:    xsi_set_current_line(125, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4848);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(126, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 5008);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(127, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 5168);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(129, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 6448);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(130, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 6608);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(131, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 6768);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(133, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 5328);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(134, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 5488);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(135, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 5648);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(137, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 6128);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(138, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 7888);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(143, ng0);
    t2 = (t0 + 9824);
    xsi_process_wait(t2, 500000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(146, ng0);
    t2 = ((char*)((ng4)));
    t3 = ((char*)((ng5)));
    t4 = (t0 + 9824);
    t5 = (t0 + 1416);
    t6 = xsi_create_subprogram_invocation(t4, 0, t0, t5, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t5, t6);
    t7 = (t0 + 8368);
    xsi_vlogvar_assign_value(t7, t2, 0, 0, 72);
    t8 = (t0 + 8528);
    xsi_vlogvar_assign_value(t8, t3, 0, 0, 32);

LAB8:    t9 = (t0 + 9920);
    t10 = *((char **)t9);
    t11 = (t10 + 80U);
    t12 = *((char **)t11);
    t13 = (t12 + 272U);
    t14 = *((char **)t13);
    t15 = (t14 + 0U);
    t16 = *((char **)t15);
    t17 = ((int  (*)(char *, char *))t16)(t0, t10);

LAB10:    if (t17 != 0)
        goto LAB11;

LAB6:    t10 = (t0 + 1416);
    xsi_vlog_subprogram_popinvocation(t10);

LAB7:    t18 = (t0 + 9920);
    t19 = *((char **)t18);
    t18 = (t0 + 1416);
    t20 = (t0 + 9824);
    t21 = 0;
    xsi_delete_subprogram_invocation(t18, t19, t0, t20, t21);
    xsi_set_current_line(147, ng0);
    t2 = (t0 + 9824);
    xsi_process_wait(t2, 100000000LL);
    *((char **)t1) = &&LAB12;
    goto LAB1;

LAB9:;
LAB11:    t9 = (t0 + 10016U);
    *((char **)t9) = &&LAB8;
    goto LAB1;

LAB12:    xsi_set_current_line(149, ng0);
    t2 = ((char*)((ng6)));
    t3 = ((char*)((ng5)));
    t4 = (t0 + 9824);
    t5 = (t0 + 1416);
    t6 = xsi_create_subprogram_invocation(t4, 0, t0, t5, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t5, t6);
    t7 = (t0 + 8368);
    xsi_vlogvar_assign_value(t7, t2, 0, 0, 72);
    t8 = (t0 + 8528);
    xsi_vlogvar_assign_value(t8, t3, 0, 0, 32);

LAB15:    t9 = (t0 + 9920);
    t10 = *((char **)t9);
    t11 = (t10 + 80U);
    t12 = *((char **)t11);
    t13 = (t12 + 272U);
    t14 = *((char **)t13);
    t15 = (t14 + 0U);
    t16 = *((char **)t15);
    t17 = ((int  (*)(char *, char *))t16)(t0, t10);

LAB17:    if (t17 != 0)
        goto LAB18;

LAB13:    t10 = (t0 + 1416);
    xsi_vlog_subprogram_popinvocation(t10);

LAB14:    t18 = (t0 + 9920);
    t19 = *((char **)t18);
    t18 = (t0 + 1416);
    t20 = (t0 + 9824);
    t21 = 0;
    xsi_delete_subprogram_invocation(t18, t19, t0, t20, t21);
    xsi_set_current_line(150, ng0);
    t2 = (t0 + 9824);
    xsi_process_wait(t2, 100000000LL);
    *((char **)t1) = &&LAB19;
    goto LAB1;

LAB16:;
LAB18:    t9 = (t0 + 10016U);
    *((char **)t9) = &&LAB15;
    goto LAB1;

LAB19:    xsi_set_current_line(153, ng0);
    t2 = ((char*)((ng7)));
    t3 = ((char*)((ng5)));
    t4 = (t0 + 9824);
    t5 = (t0 + 1416);
    t6 = xsi_create_subprogram_invocation(t4, 0, t0, t5, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t5, t6);
    t7 = (t0 + 8368);
    xsi_vlogvar_assign_value(t7, t2, 0, 0, 72);
    t8 = (t0 + 8528);
    xsi_vlogvar_assign_value(t8, t3, 0, 0, 32);

LAB22:    t9 = (t0 + 9920);
    t10 = *((char **)t9);
    t11 = (t10 + 80U);
    t12 = *((char **)t11);
    t13 = (t12 + 272U);
    t14 = *((char **)t13);
    t15 = (t14 + 0U);
    t16 = *((char **)t15);
    t17 = ((int  (*)(char *, char *))t16)(t0, t10);

LAB24:    if (t17 != 0)
        goto LAB25;

LAB20:    t10 = (t0 + 1416);
    xsi_vlog_subprogram_popinvocation(t10);

LAB21:    t18 = (t0 + 9920);
    t19 = *((char **)t18);
    t18 = (t0 + 1416);
    t20 = (t0 + 9824);
    t21 = 0;
    xsi_delete_subprogram_invocation(t18, t19, t0, t20, t21);
    xsi_set_current_line(154, ng0);
    t2 = (t0 + 9824);
    xsi_process_wait(t2, 100000000LL);
    *((char **)t1) = &&LAB26;
    goto LAB1;

LAB23:;
LAB25:    t9 = (t0 + 10016U);
    *((char **)t9) = &&LAB22;
    goto LAB1;

LAB26:    xsi_set_current_line(157, ng0);
    t2 = ((char*)((ng8)));
    t3 = ((char*)((ng5)));
    t4 = (t0 + 9824);
    t5 = (t0 + 1416);
    t6 = xsi_create_subprogram_invocation(t4, 0, t0, t5, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t5, t6);
    t7 = (t0 + 8368);
    xsi_vlogvar_assign_value(t7, t2, 0, 0, 72);
    t8 = (t0 + 8528);
    xsi_vlogvar_assign_value(t8, t3, 0, 0, 32);

LAB29:    t9 = (t0 + 9920);
    t10 = *((char **)t9);
    t11 = (t10 + 80U);
    t12 = *((char **)t11);
    t13 = (t12 + 272U);
    t14 = *((char **)t13);
    t15 = (t14 + 0U);
    t16 = *((char **)t15);
    t17 = ((int  (*)(char *, char *))t16)(t0, t10);

LAB31:    if (t17 != 0)
        goto LAB32;

LAB27:    t10 = (t0 + 1416);
    xsi_vlog_subprogram_popinvocation(t10);

LAB28:    t18 = (t0 + 9920);
    t19 = *((char **)t18);
    t18 = (t0 + 1416);
    t20 = (t0 + 9824);
    t21 = 0;
    xsi_delete_subprogram_invocation(t18, t19, t0, t20, t21);
    xsi_set_current_line(158, ng0);
    t2 = (t0 + 9824);
    xsi_process_wait(t2, 100000000LL);
    *((char **)t1) = &&LAB33;
    goto LAB1;

LAB30:;
LAB32:    t9 = (t0 + 10016U);
    *((char **)t9) = &&LAB29;
    goto LAB1;

LAB33:    xsi_set_current_line(161, ng0);
    t2 = ((char*)((ng9)));
    t3 = ((char*)((ng5)));
    t4 = (t0 + 9824);
    t5 = (t0 + 1416);
    t6 = xsi_create_subprogram_invocation(t4, 0, t0, t5, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t5, t6);
    t7 = (t0 + 8368);
    xsi_vlogvar_assign_value(t7, t2, 0, 0, 72);
    t8 = (t0 + 8528);
    xsi_vlogvar_assign_value(t8, t3, 0, 0, 32);

LAB36:    t9 = (t0 + 9920);
    t10 = *((char **)t9);
    t11 = (t10 + 80U);
    t12 = *((char **)t11);
    t13 = (t12 + 272U);
    t14 = *((char **)t13);
    t15 = (t14 + 0U);
    t16 = *((char **)t15);
    t17 = ((int  (*)(char *, char *))t16)(t0, t10);

LAB38:    if (t17 != 0)
        goto LAB39;

LAB34:    t10 = (t0 + 1416);
    xsi_vlog_subprogram_popinvocation(t10);

LAB35:    t18 = (t0 + 9920);
    t19 = *((char **)t18);
    t18 = (t0 + 1416);
    t20 = (t0 + 9824);
    t21 = 0;
    xsi_delete_subprogram_invocation(t18, t19, t0, t20, t21);
    xsi_set_current_line(162, ng0);
    t2 = (t0 + 9824);
    xsi_process_wait(t2, 100000000LL);
    *((char **)t1) = &&LAB40;
    goto LAB1;

LAB37:;
LAB39:    t9 = (t0 + 10016U);
    *((char **)t9) = &&LAB36;
    goto LAB1;

LAB40:    xsi_set_current_line(165, ng0);
    t2 = ((char*)((ng10)));
    t3 = ((char*)((ng5)));
    t4 = (t0 + 9824);
    t5 = (t0 + 1416);
    t6 = xsi_create_subprogram_invocation(t4, 0, t0, t5, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t5, t6);
    t7 = (t0 + 8368);
    xsi_vlogvar_assign_value(t7, t2, 0, 0, 72);
    t8 = (t0 + 8528);
    xsi_vlogvar_assign_value(t8, t3, 0, 0, 32);

LAB43:    t9 = (t0 + 9920);
    t10 = *((char **)t9);
    t11 = (t10 + 80U);
    t12 = *((char **)t11);
    t13 = (t12 + 272U);
    t14 = *((char **)t13);
    t15 = (t14 + 0U);
    t16 = *((char **)t15);
    t17 = ((int  (*)(char *, char *))t16)(t0, t10);

LAB45:    if (t17 != 0)
        goto LAB46;

LAB41:    t10 = (t0 + 1416);
    xsi_vlog_subprogram_popinvocation(t10);

LAB42:    t18 = (t0 + 9920);
    t19 = *((char **)t18);
    t18 = (t0 + 1416);
    t20 = (t0 + 9824);
    t21 = 0;
    xsi_delete_subprogram_invocation(t18, t19, t0, t20, t21);
    xsi_set_current_line(166, ng0);
    t2 = (t0 + 9824);
    xsi_process_wait(t2, 100000000LL);
    *((char **)t1) = &&LAB47;
    goto LAB1;

LAB44:;
LAB46:    t9 = (t0 + 10016U);
    *((char **)t9) = &&LAB43;
    goto LAB1;

LAB47:    xsi_set_current_line(169, ng0);
    t2 = ((char*)((ng11)));
    t3 = ((char*)((ng5)));
    t4 = (t0 + 9824);
    t5 = (t0 + 1416);
    t6 = xsi_create_subprogram_invocation(t4, 0, t0, t5, 0, 0);
    xsi_vlog_subprogram_pushinvocation(t5, t6);
    t7 = (t0 + 8368);
    xsi_vlogvar_assign_value(t7, t2, 0, 0, 72);
    t8 = (t0 + 8528);
    xsi_vlogvar_assign_value(t8, t3, 0, 0, 32);

LAB50:    t9 = (t0 + 9920);
    t10 = *((char **)t9);
    t11 = (t10 + 80U);
    t12 = *((char **)t11);
    t13 = (t12 + 272U);
    t14 = *((char **)t13);
    t15 = (t14 + 0U);
    t16 = *((char **)t15);
    t17 = ((int  (*)(char *, char *))t16)(t0, t10);

LAB52:    if (t17 != 0)
        goto LAB53;

LAB48:    t10 = (t0 + 1416);
    xsi_vlog_subprogram_popinvocation(t10);

LAB49:    t18 = (t0 + 9920);
    t19 = *((char **)t18);
    t18 = (t0 + 1416);
    t20 = (t0 + 9824);
    t21 = 0;
    xsi_delete_subprogram_invocation(t18, t19, t0, t20, t21);
    xsi_set_current_line(170, ng0);
    t2 = (t0 + 9824);
    xsi_process_wait(t2, 100000000LL);
    *((char **)t1) = &&LAB54;
    goto LAB1;

LAB51:;
LAB53:    t9 = (t0 + 10016U);
    *((char **)t9) = &&LAB50;
    goto LAB1;

LAB54:    xsi_set_current_line(174, ng0);
    t2 = (t0 + 9824);
    xsi_process_wait(t2, 5000000LL);
    *((char **)t1) = &&LAB55;
    goto LAB1;

LAB55:    xsi_set_current_line(175, ng0);
    xsi_vlog_stop(1);
    goto LAB1;

}


extern void work_m_00000000001459490879_3115858369_init()
{
	static char *pe[] = {(void *)Initial_112_0,(void *)Initial_121_1};
	static char *se[] = {(void *)sp_send_byte,(void *)sp_send_multiple_bytes};
	xsi_register_didat("work_m_00000000001459490879_3115858369", "isim/top_tb_isim_beh.exe.sim/work/m_00000000001459490879_3115858369.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
