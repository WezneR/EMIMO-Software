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
static const char *ng0 = "D:/FPGA_project/MSTR111_Driver_4x16_BS1_upper_FBS/SPI_master.v";
static unsigned int ng1[] = {65535U, 0U};
static int ng2[] = {0, 0};
static int ng3[] = {1, 0};
static unsigned int ng4[] = {0U, 0U};
static unsigned int ng5[] = {1U, 0U};
static int ng6[] = {2, 0};
static int ng7[] = {3, 0};
static unsigned int ng8[] = {15U, 0U};
static unsigned int ng9[] = {2U, 0U};
static unsigned int ng10[] = {3U, 0U};
static unsigned int ng11[] = {4U, 0U};
static unsigned int ng12[] = {5U, 0U};
static unsigned int ng13[] = {6U, 0U};
static unsigned int ng14[] = {7U, 0U};
static unsigned int ng15[] = {8U, 0U};
static unsigned int ng16[] = {9U, 0U};
static unsigned int ng17[] = {10U, 0U};
static unsigned int ng18[] = {11U, 0U};
static unsigned int ng19[] = {12U, 0U};
static unsigned int ng20[] = {13U, 0U};
static unsigned int ng21[] = {14U, 0U};
static unsigned int ng22[] = {0U, 1U};



static void Always_161_0(char *t0)
{
    char t4[8];
    char t28[8];
    char t36[8];
    char t38[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    unsigned int t34;
    int t35;
    char *t37;
    char *t39;
    char *t40;
    char *t41;
    char *t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    int t47;
    int t48;
    int t49;
    char *t50;
    int t51;

LAB0:    t1 = (t0 + 6472U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(161, ng0);
    t2 = (t0 + 6792);
    *((int *)t2) = 1;
    t3 = (t0 + 6504);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(162, ng0);

LAB5:    xsi_set_current_line(163, ng0);
    t5 = (t0 + 2432U);
    t6 = *((char **)t5);
    memset(t4, 0, 8);
    t5 = (t6 + 4);
    t7 = *((unsigned int *)t5);
    t8 = (~(t7));
    t9 = *((unsigned int *)t6);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB9;

LAB7:    if (*((unsigned int *)t5) == 0)
        goto LAB6;

LAB8:    t12 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t12) = 1;

LAB9:    t13 = (t4 + 4);
    t14 = *((unsigned int *)t13);
    t15 = (~(t14));
    t16 = *((unsigned int *)t4);
    t17 = (t16 & t15);
    t18 = (t17 != 0);
    if (t18 > 0)
        goto LAB10;

LAB11:    xsi_set_current_line(173, ng0);
    t2 = (t0 + 4112);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t5 + 4);
    t7 = *((unsigned int *)t6);
    t8 = (~(t7));
    t9 = *((unsigned int *)t5);
    t10 = (t9 & t8);
    t11 = (t10 != 0);
    if (t11 > 0)
        goto LAB14;

LAB15:    xsi_set_current_line(190, ng0);

LAB31:    xsi_set_current_line(191, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4272);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(192, ng0);
    t2 = (t0 + 5392);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 472);
    t12 = *((char **)t6);
    t6 = ((char*)((ng3)));
    memset(t4, 0, 8);
    xsi_vlog_unsigned_minus(t4, 32, t12, 32, t6, 32);
    memset(t28, 0, 8);
    t13 = (t5 + 4);
    t19 = (t4 + 4);
    t7 = *((unsigned int *)t5);
    t8 = *((unsigned int *)t4);
    t9 = (t7 ^ t8);
    t10 = *((unsigned int *)t13);
    t11 = *((unsigned int *)t19);
    t14 = (t10 ^ t11);
    t15 = (t9 | t14);
    t16 = *((unsigned int *)t13);
    t17 = *((unsigned int *)t19);
    t18 = (t16 | t17);
    t21 = (~(t18));
    t22 = (t15 & t21);
    if (t22 != 0)
        goto LAB33;

LAB32:    if (t18 != 0)
        goto LAB34;

LAB35:    t29 = (t28 + 4);
    t23 = *((unsigned int *)t29);
    t24 = (~(t23));
    t25 = *((unsigned int *)t28);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB36;

LAB37:    xsi_set_current_line(195, ng0);

LAB39:    xsi_set_current_line(196, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5392);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 16, 0LL);
    xsi_set_current_line(197, ng0);
    t2 = (t0 + 5552);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);

LAB40:    t6 = (t0 + 1016);
    t12 = *((char **)t6);
    t35 = xsi_vlog_unsigned_case_compare(t5, 3, t12, 32);
    if (t35 == 1)
        goto LAB41;

LAB42:    t2 = (t0 + 1152);
    t3 = *((char **)t2);
    t35 = xsi_vlog_unsigned_case_compare(t5, 3, t3, 32);
    if (t35 == 1)
        goto LAB43;

LAB44:    t2 = (t0 + 1288);
    t3 = *((char **)t2);
    t35 = xsi_vlog_unsigned_case_compare(t5, 3, t3, 32);
    if (t35 == 1)
        goto LAB45;

LAB46:    t2 = (t0 + 1424);
    t3 = *((char **)t2);
    t35 = xsi_vlog_unsigned_case_compare(t5, 3, t3, 32);
    if (t35 == 1)
        goto LAB47;

LAB48:    t2 = (t0 + 1560);
    t3 = *((char **)t2);
    t35 = xsi_vlog_unsigned_case_compare(t5, 3, t3, 32);
    if (t35 == 1)
        goto LAB49;

LAB50:
LAB51:
LAB38:
LAB16:
LAB12:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(164, ng0);

LAB13:    xsi_set_current_line(165, ng0);
    t19 = ((char*)((ng1)));
    t20 = (t0 + 4752);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 16, 0LL);
    xsi_set_current_line(166, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4432);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(167, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4592);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(168, ng0);
    t2 = (t0 + 1016);
    t3 = *((char **)t2);
    t2 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 3, 0LL);
    xsi_set_current_line(169, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4112);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(170, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4272);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(171, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5232);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 6, 0LL);
    goto LAB12;

LAB14:    xsi_set_current_line(174, ng0);

LAB17:    xsi_set_current_line(176, ng0);
    t12 = (t0 + 2592U);
    t13 = *((char **)t12);
    t12 = (t13 + 4);
    t14 = *((unsigned int *)t12);
    t15 = (~(t14));
    t16 = *((unsigned int *)t13);
    t17 = (t16 & t15);
    t18 = (t17 != 0);
    if (t18 > 0)
        goto LAB18;

LAB19:
LAB20:    goto LAB16;

LAB18:    xsi_set_current_line(177, ng0);

LAB21:    xsi_set_current_line(178, ng0);
    t19 = ((char*)((ng2)));
    t20 = (t0 + 4112);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 1, 0LL);
    xsi_set_current_line(180, ng0);
    t2 = (t0 + 3072U);
    t3 = *((char **)t2);
    t2 = ((char*)((ng2)));
    memset(t4, 0, 8);
    t5 = (t3 + 4);
    t6 = (t2 + 4);
    t7 = *((unsigned int *)t3);
    t8 = *((unsigned int *)t2);
    t9 = (t7 ^ t8);
    t10 = *((unsigned int *)t5);
    t11 = *((unsigned int *)t6);
    t14 = (t10 ^ t11);
    t15 = (t9 | t14);
    t16 = *((unsigned int *)t5);
    t17 = *((unsigned int *)t6);
    t18 = (t16 | t17);
    t21 = (~(t18));
    t22 = (t15 & t21);
    if (t22 != 0)
        goto LAB25;

LAB22:    if (t18 != 0)
        goto LAB24;

LAB23:    *((unsigned int *)t4) = 1;

LAB25:    t13 = (t4 + 4);
    t23 = *((unsigned int *)t13);
    t24 = (~(t23));
    t25 = *((unsigned int *)t4);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB26;

LAB27:    xsi_set_current_line(183, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4752);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 16, 0LL);

LAB28:    xsi_set_current_line(184, ng0);
    t2 = (t0 + 2752U);
    t3 = *((char **)t2);
    t2 = (t0 + 4912);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 1, 0LL);
    xsi_set_current_line(185, ng0);
    t2 = (t0 + 3552U);
    t3 = *((char **)t2);
    t2 = (t0 + 5072);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 48, 0LL);
    xsi_set_current_line(186, ng0);
    t2 = (t0 + 1152);
    t3 = *((char **)t2);
    t2 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 3, 0LL);
    goto LAB20;

LAB24:    t12 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t12) = 1;
    goto LAB25;

LAB26:    xsi_set_current_line(181, ng0);
    t19 = ((char*)((ng4)));
    t20 = (t0 + 4752);
    t29 = (t0 + 4752);
    t30 = (t29 + 72U);
    t31 = *((char **)t30);
    t32 = (t0 + 2912U);
    t33 = *((char **)t32);
    xsi_vlog_generic_convert_bit_index(t28, t31, 2, t33, 4, 2);
    t32 = (t28 + 4);
    t34 = *((unsigned int *)t32);
    t35 = (!(t34));
    if (t35 == 1)
        goto LAB29;

LAB30:    goto LAB28;

LAB29:    xsi_vlogvar_wait_assign_value(t20, t19, 0, *((unsigned int *)t28), 1, 0LL);
    goto LAB30;

LAB33:    *((unsigned int *)t28) = 1;
    goto LAB35;

LAB34:    t20 = (t28 + 4);
    *((unsigned int *)t28) = 1;
    *((unsigned int *)t20) = 1;
    goto LAB35;

LAB36:    xsi_set_current_line(193, ng0);
    t30 = (t0 + 5392);
    t31 = (t30 + 56U);
    t32 = *((char **)t31);
    t33 = ((char*)((ng5)));
    memset(t36, 0, 8);
    xsi_vlog_unsigned_add(t36, 16, t32, 16, t33, 16);
    t37 = (t0 + 5392);
    xsi_vlogvar_wait_assign_value(t37, t36, 0, 0, 16, 0LL);
    goto LAB38;

LAB41:    xsi_set_current_line(199, ng0);

LAB52:    xsi_set_current_line(200, ng0);
    t6 = ((char*)((ng3)));
    t13 = (t0 + 4112);
    xsi_vlogvar_wait_assign_value(t13, t6, 0, 0, 1, 0LL);
    xsi_set_current_line(201, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4752);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 16, 0LL);
    xsi_set_current_line(202, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 5232);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 6, 0LL);
    xsi_set_current_line(203, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4432);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(204, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4592);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(205, ng0);
    t2 = (t0 + 1016);
    t3 = *((char **)t2);
    t2 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 3, 0LL);
    goto LAB51;

LAB43:    xsi_set_current_line(208, ng0);

LAB53:    xsi_set_current_line(209, ng0);
    t2 = ((char*)((ng2)));
    t6 = (t0 + 4432);
    xsi_vlogvar_wait_assign_value(t6, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(211, ng0);
    t2 = (t0 + 5072);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = (t0 + 5072);
    t13 = (t12 + 72U);
    t19 = *((char **)t13);
    t20 = (t0 + 3232U);
    t29 = *((char **)t20);
    t20 = (t0 + 5232);
    t30 = (t20 + 56U);
    t31 = *((char **)t30);
    memset(t28, 0, 8);
    xsi_vlog_unsigned_minus(t28, 32, t29, 6, t31, 6);
    t32 = ((char*)((ng3)));
    memset(t36, 0, 8);
    xsi_vlog_unsigned_minus(t36, 32, t28, 32, t32, 32);
    xsi_vlog_generic_get_index_select_value(t4, 1, t6, t19, 2, t36, 32, 2);
    t33 = (t0 + 4592);
    t37 = (t0 + 4592);
    t39 = (t37 + 72U);
    t40 = *((char **)t39);
    t41 = ((char*)((ng2)));
    xsi_vlog_generic_convert_bit_index(t38, t40, 2, t41, 32, 1);
    t42 = (t38 + 4);
    t7 = *((unsigned int *)t42);
    t35 = (!(t7));
    if (t35 == 1)
        goto LAB54;

LAB55:    xsi_set_current_line(212, ng0);
    t2 = (t0 + 5072);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = (t0 + 5072);
    t13 = (t12 + 72U);
    t19 = *((char **)t13);
    t20 = (t0 + 3232U);
    t29 = *((char **)t20);
    t20 = (t0 + 5232);
    t30 = (t20 + 56U);
    t31 = *((char **)t30);
    memset(t28, 0, 8);
    xsi_vlog_unsigned_minus(t28, 32, t29, 6, t31, 6);
    t32 = ((char*)((ng3)));
    memset(t36, 0, 8);
    xsi_vlog_unsigned_minus(t36, 32, t28, 32, t32, 32);
    xsi_vlog_generic_get_index_select_value(t4, 1, t6, t19, 2, t36, 32, 2);
    t33 = (t0 + 4592);
    t37 = (t0 + 4592);
    t39 = (t37 + 72U);
    t40 = *((char **)t39);
    t41 = ((char*)((ng3)));
    xsi_vlog_generic_convert_bit_index(t38, t40, 2, t41, 32, 1);
    t42 = (t38 + 4);
    t7 = *((unsigned int *)t42);
    t35 = (!(t7));
    if (t35 == 1)
        goto LAB56;

LAB57:    xsi_set_current_line(213, ng0);
    t2 = (t0 + 5072);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = (t0 + 5072);
    t13 = (t12 + 72U);
    t19 = *((char **)t13);
    t20 = (t0 + 3232U);
    t29 = *((char **)t20);
    t20 = (t0 + 5232);
    t30 = (t20 + 56U);
    t31 = *((char **)t30);
    memset(t28, 0, 8);
    xsi_vlog_unsigned_minus(t28, 32, t29, 6, t31, 6);
    t32 = ((char*)((ng3)));
    memset(t36, 0, 8);
    xsi_vlog_unsigned_minus(t36, 32, t28, 32, t32, 32);
    xsi_vlog_generic_get_index_select_value(t4, 1, t6, t19, 2, t36, 32, 2);
    t33 = (t0 + 4592);
    t37 = (t0 + 4592);
    t39 = (t37 + 72U);
    t40 = *((char **)t39);
    t41 = ((char*)((ng6)));
    xsi_vlog_generic_convert_bit_index(t38, t40, 2, t41, 32, 1);
    t42 = (t38 + 4);
    t7 = *((unsigned int *)t42);
    t35 = (!(t7));
    if (t35 == 1)
        goto LAB58;

LAB59:    xsi_set_current_line(214, ng0);
    t2 = (t0 + 5072);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = (t0 + 5072);
    t13 = (t12 + 72U);
    t19 = *((char **)t13);
    t20 = (t0 + 3232U);
    t29 = *((char **)t20);
    t20 = (t0 + 5232);
    t30 = (t20 + 56U);
    t31 = *((char **)t30);
    memset(t28, 0, 8);
    xsi_vlog_unsigned_minus(t28, 32, t29, 6, t31, 6);
    t32 = ((char*)((ng3)));
    memset(t36, 0, 8);
    xsi_vlog_unsigned_minus(t36, 32, t28, 32, t32, 32);
    xsi_vlog_generic_get_index_select_value(t4, 1, t6, t19, 2, t36, 32, 2);
    t33 = (t0 + 4592);
    t37 = (t0 + 4592);
    t39 = (t37 + 72U);
    t40 = *((char **)t39);
    t41 = ((char*)((ng7)));
    xsi_vlog_generic_convert_bit_index(t38, t40, 2, t41, 32, 1);
    t42 = (t38 + 4);
    t7 = *((unsigned int *)t42);
    t35 = (!(t7));
    if (t35 == 1)
        goto LAB60;

LAB61:    xsi_set_current_line(215, ng0);
    t2 = (t0 + 1288);
    t3 = *((char **)t2);
    t2 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 3, 0LL);
    goto LAB51;

LAB45:    xsi_set_current_line(218, ng0);

LAB62:    xsi_set_current_line(219, ng0);
    t2 = (t0 + 5232);
    t6 = (t2 + 56U);
    t12 = *((char **)t6);
    t13 = ((char*)((ng5)));
    memset(t4, 0, 8);
    xsi_vlog_unsigned_add(t4, 6, t12, 6, t13, 6);
    t19 = (t0 + 5232);
    xsi_vlogvar_wait_assign_value(t19, t4, 0, 0, 6, 0LL);
    xsi_set_current_line(221, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 4432);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(223, ng0);
    t2 = (t0 + 4912);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = (t6 + 4);
    t7 = *((unsigned int *)t12);
    t8 = (~(t7));
    t9 = *((unsigned int *)t6);
    t10 = (t9 & t8);
    t11 = (t10 != 0);
    if (t11 > 0)
        goto LAB63;

LAB64:    xsi_set_current_line(229, ng0);
    t2 = (t0 + 5232);
    t3 = (t2 + 56U);
    t6 = *((char **)t3);
    t12 = (t0 + 3232U);
    t13 = *((char **)t12);
    t12 = ((char*)((ng3)));
    memset(t4, 0, 8);
    xsi_vlog_unsigned_minus(t4, 32, t13, 6, t12, 32);
    memset(t28, 0, 8);
    t19 = (t6 + 4);
    t20 = (t4 + 4);
    t7 = *((unsigned int *)t6);
    t8 = *((unsigned int *)t4);
    t9 = (t7 ^ t8);
    t10 = *((unsigned int *)t19);
    t11 = *((unsigned int *)t20);
    t14 = (t10 ^ t11);
    t15 = (t9 | t14);
    t16 = *((unsigned int *)t19);
    t17 = *((unsigned int *)t20);
    t18 = (t16 | t17);
    t21 = (~(t18));
    t22 = (t15 & t21);
    if (t22 != 0)
        goto LAB76;

LAB73:    if (t18 != 0)
        goto LAB75;

LAB74:    *((unsigned int *)t28) = 1;

LAB76:    t30 = (t28 + 4);
    t23 = *((unsigned int *)t30);
    t24 = (~(t23));
    t25 = *((unsigned int *)t28);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB77;

LAB78:    xsi_set_current_line(235, ng0);
    t2 = (t0 + 1152);
    t3 = *((char **)t2);
    t2 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 3, 0LL);

LAB79:
LAB65:    goto LAB51;

LAB47:    xsi_set_current_line(238, ng0);

LAB81:    xsi_set_current_line(239, ng0);
    t2 = ((char*)((ng2)));
    t6 = (t0 + 4432);
    xsi_vlogvar_wait_assign_value(t6, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(240, ng0);
    t2 = (t0 + 1560);
    t3 = *((char **)t2);
    t2 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 3, 0LL);
    goto LAB51;

LAB49:    xsi_set_current_line(243, ng0);

LAB82:    xsi_set_current_line(244, ng0);
    t2 = (t0 + 5232);
    t6 = (t2 + 56U);
    t12 = *((char **)t6);
    t13 = ((char*)((ng5)));
    memset(t4, 0, 8);
    xsi_vlog_unsigned_add(t4, 6, t12, 6, t13, 6);
    t19 = (t0 + 5232);
    xsi_vlogvar_wait_assign_value(t19, t4, 0, 0, 6, 0LL);
    xsi_set_current_line(246, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 4432);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(248, ng0);
    t2 = (t0 + 2912U);
    t3 = *((char **)t2);

LAB83:    t2 = ((char*)((ng4)));
    t35 = xsi_vlog_unsigned_case_compare(t3, 4, t2, 4);
    if (t35 == 1)
        goto LAB84;

LAB85:    t2 = ((char*)((ng5)));
    t35 = xsi_vlog_unsigned_case_compare(t3, 4, t2, 4);
    if (t35 == 1)
        goto LAB86;

LAB87:    t6 = ((char*)((ng9)));
    t47 = xsi_vlog_unsigned_case_compare(t3, 4, t6, 4);
    if (t47 == 1)
        goto LAB88;

LAB89:    t12 = ((char*)((ng10)));
    t48 = xsi_vlog_unsigned_case_compare(t3, 4, t12, 4);
    if (t48 == 1)
        goto LAB90;

LAB91:    t13 = ((char*)((ng11)));
    t49 = xsi_vlog_unsigned_case_compare(t3, 4, t13, 4);
    if (t49 == 1)
        goto LAB92;

LAB93:    t2 = ((char*)((ng12)));
    t35 = xsi_vlog_unsigned_case_compare(t3, 4, t2, 4);
    if (t35 == 1)
        goto LAB94;

LAB95:    t6 = ((char*)((ng13)));
    t47 = xsi_vlog_unsigned_case_compare(t3, 4, t6, 4);
    if (t47 == 1)
        goto LAB96;

LAB97:    t12 = ((char*)((ng14)));
    t48 = xsi_vlog_unsigned_case_compare(t3, 4, t12, 4);
    if (t48 == 1)
        goto LAB98;

LAB99:    t13 = ((char*)((ng15)));
    t49 = xsi_vlog_unsigned_case_compare(t3, 4, t13, 4);
    if (t49 == 1)
        goto LAB100;

LAB101:    t2 = ((char*)((ng16)));
    t35 = xsi_vlog_unsigned_case_compare(t3, 4, t2, 4);
    if (t35 == 1)
        goto LAB102;

LAB103:    t6 = ((char*)((ng17)));
    t47 = xsi_vlog_unsigned_case_compare(t3, 4, t6, 4);
    if (t47 == 1)
        goto LAB104;

LAB105:    t12 = ((char*)((ng18)));
    t48 = xsi_vlog_unsigned_case_compare(t3, 4, t12, 4);
    if (t48 == 1)
        goto LAB106;

LAB107:    t13 = ((char*)((ng19)));
    t49 = xsi_vlog_unsigned_case_compare(t3, 4, t13, 4);
    if (t49 == 1)
        goto LAB108;

LAB109:    t2 = ((char*)((ng20)));
    t35 = xsi_vlog_unsigned_case_compare(t3, 4, t2, 4);
    if (t35 == 1)
        goto LAB110;

LAB111:    t6 = ((char*)((ng21)));
    t47 = xsi_vlog_unsigned_case_compare(t3, 4, t6, 4);
    if (t47 == 1)
        goto LAB112;

LAB113:    t12 = ((char*)((ng8)));
    t48 = xsi_vlog_unsigned_case_compare(t3, 4, t12, 4);
    if (t48 == 1)
        goto LAB114;

LAB115:
LAB117:
LAB116:    xsi_set_current_line(257, ng0);
    t13 = ((char*)((ng22)));
    t19 = (t0 + 3952);
    t20 = (t0 + 3952);
    t29 = (t20 + 72U);
    t30 = *((char **)t29);
    t31 = (t0 + 3232U);
    t32 = *((char **)t31);
    t31 = (t0 + 5232);
    t33 = (t31 + 56U);
    t37 = *((char **)t33);
    memset(t28, 0, 8);
    xsi_vlog_unsigned_minus(t28, 32, t32, 6, t37, 6);
    t39 = ((char*)((ng3)));
    memset(t36, 0, 8);
    xsi_vlog_unsigned_minus(t36, 32, t28, 32, t39, 32);
    xsi_vlog_generic_convert_bit_index(t4, t30, 2, t36, 32, 2);
    t40 = (t4 + 4);
    t7 = *((unsigned int *)t40);
    t49 = (!(t7));
    if (t49 == 1)
        goto LAB127;

LAB128:
LAB118:    xsi_set_current_line(259, ng0);
    t2 = (t0 + 5232);
    t6 = (t2 + 56U);
    t12 = *((char **)t6);
    t13 = (t0 + 3232U);
    t19 = *((char **)t13);
    t13 = ((char*)((ng3)));
    memset(t4, 0, 8);
    xsi_vlog_unsigned_minus(t4, 32, t19, 6, t13, 32);
    memset(t28, 0, 8);
    t20 = (t12 + 4);
    t29 = (t4 + 4);
    t7 = *((unsigned int *)t12);
    t8 = *((unsigned int *)t4);
    t9 = (t7 ^ t8);
    t10 = *((unsigned int *)t20);
    t11 = *((unsigned int *)t29);
    t14 = (t10 ^ t11);
    t15 = (t9 | t14);
    t16 = *((unsigned int *)t20);
    t17 = *((unsigned int *)t29);
    t18 = (t16 | t17);
    t21 = (~(t18));
    t22 = (t15 & t21);
    if (t22 != 0)
        goto LAB132;

LAB129:    if (t18 != 0)
        goto LAB131;

LAB130:    *((unsigned int *)t28) = 1;

LAB132:    t31 = (t28 + 4);
    t23 = *((unsigned int *)t31);
    t24 = (~(t23));
    t25 = *((unsigned int *)t28);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB133;

LAB134:    xsi_set_current_line(265, ng0);
    t2 = (t0 + 1424);
    t6 = *((char **)t2);
    t2 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t2, t6, 0, 0, 3, 0LL);

LAB135:    goto LAB51;

LAB54:    xsi_vlogvar_wait_assign_value(t33, t4, 0, *((unsigned int *)t38), 1, 0LL);
    goto LAB55;

LAB56:    xsi_vlogvar_wait_assign_value(t33, t4, 0, *((unsigned int *)t38), 1, 0LL);
    goto LAB57;

LAB58:    xsi_vlogvar_wait_assign_value(t33, t4, 0, *((unsigned int *)t38), 1, 0LL);
    goto LAB59;

LAB60:    xsi_vlogvar_wait_assign_value(t33, t4, 0, *((unsigned int *)t38), 1, 0LL);
    goto LAB61;

LAB63:    xsi_set_current_line(224, ng0);
    t13 = (t0 + 5232);
    t19 = (t13 + 56U);
    t20 = *((char **)t19);
    t29 = (t0 + 744);
    t30 = *((char **)t29);
    t29 = ((char*)((ng3)));
    memset(t4, 0, 8);
    xsi_vlog_unsigned_minus(t4, 32, t30, 32, t29, 32);
    memset(t28, 0, 8);
    t31 = (t20 + 4);
    t32 = (t4 + 4);
    t14 = *((unsigned int *)t20);
    t15 = *((unsigned int *)t4);
    t16 = (t14 ^ t15);
    t17 = *((unsigned int *)t31);
    t18 = *((unsigned int *)t32);
    t21 = (t17 ^ t18);
    t22 = (t16 | t21);
    t23 = *((unsigned int *)t31);
    t24 = *((unsigned int *)t32);
    t25 = (t23 | t24);
    t26 = (~(t25));
    t27 = (t22 & t26);
    if (t27 != 0)
        goto LAB69;

LAB66:    if (t25 != 0)
        goto LAB68;

LAB67:    *((unsigned int *)t28) = 1;

LAB69:    t37 = (t28 + 4);
    t34 = *((unsigned int *)t37);
    t43 = (~(t34));
    t44 = *((unsigned int *)t28);
    t45 = (t44 & t43);
    t46 = (t45 != 0);
    if (t46 > 0)
        goto LAB70;

LAB71:    xsi_set_current_line(227, ng0);
    t2 = (t0 + 1152);
    t3 = *((char **)t2);
    t2 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 3, 0LL);

LAB72:    goto LAB65;

LAB68:    t33 = (t28 + 4);
    *((unsigned int *)t28) = 1;
    *((unsigned int *)t33) = 1;
    goto LAB69;

LAB70:    xsi_set_current_line(225, ng0);
    t39 = (t0 + 1424);
    t40 = *((char **)t39);
    t39 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t39, t40, 0, 0, 3, 0LL);
    goto LAB72;

LAB75:    t29 = (t28 + 4);
    *((unsigned int *)t28) = 1;
    *((unsigned int *)t29) = 1;
    goto LAB76;

LAB77:    xsi_set_current_line(230, ng0);

LAB80:    xsi_set_current_line(231, ng0);
    t31 = ((char*)((ng3)));
    t32 = (t0 + 4272);
    xsi_vlogvar_wait_assign_value(t32, t31, 0, 0, 1, 0LL);
    xsi_set_current_line(232, ng0);
    t2 = (t0 + 1016);
    t3 = *((char **)t2);
    t2 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 3, 0LL);
    goto LAB79;

LAB84:    xsi_set_current_line(250, ng0);
    t6 = (t0 + 3392U);
    t12 = *((char **)t6);
    memset(t4, 0, 8);
    t6 = (t4 + 4);
    t13 = (t12 + 4);
    t7 = *((unsigned int *)t12);
    t8 = (t7 >> 0);
    t9 = (t8 & 1);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t13);
    t11 = (t10 >> 0);
    t14 = (t11 & 1);
    *((unsigned int *)t6) = t14;
    t19 = (t0 + 3952);
    t20 = (t0 + 3952);
    t29 = (t20 + 72U);
    t30 = *((char **)t29);
    t31 = (t0 + 3232U);
    t32 = *((char **)t31);
    t31 = (t0 + 5232);
    t33 = (t31 + 56U);
    t37 = *((char **)t33);
    memset(t36, 0, 8);
    xsi_vlog_unsigned_minus(t36, 32, t32, 6, t37, 6);
    t39 = ((char*)((ng3)));
    memset(t38, 0, 8);
    xsi_vlog_unsigned_minus(t38, 32, t36, 32, t39, 32);
    xsi_vlog_generic_convert_bit_index(t28, t30, 2, t38, 32, 2);
    t40 = (t28 + 4);
    t15 = *((unsigned int *)t40);
    t47 = (!(t15));
    if (t47 == 1)
        goto LAB119;

LAB120:    goto LAB118;

LAB86:    goto LAB84;

LAB88:    goto LAB84;

LAB90:    goto LAB84;

LAB92:    xsi_set_current_line(252, ng0);
    t19 = (t0 + 3392U);
    t20 = *((char **)t19);
    memset(t4, 0, 8);
    t19 = (t4 + 4);
    t29 = (t20 + 4);
    t7 = *((unsigned int *)t20);
    t8 = (t7 >> 1);
    t9 = (t8 & 1);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t29);
    t11 = (t10 >> 1);
    t14 = (t11 & 1);
    *((unsigned int *)t19) = t14;
    t30 = (t0 + 3952);
    t31 = (t0 + 3952);
    t32 = (t31 + 72U);
    t33 = *((char **)t32);
    t37 = (t0 + 3232U);
    t39 = *((char **)t37);
    t37 = (t0 + 5232);
    t40 = (t37 + 56U);
    t41 = *((char **)t40);
    memset(t36, 0, 8);
    xsi_vlog_unsigned_minus(t36, 32, t39, 6, t41, 6);
    t42 = ((char*)((ng3)));
    memset(t38, 0, 8);
    xsi_vlog_unsigned_minus(t38, 32, t36, 32, t42, 32);
    xsi_vlog_generic_convert_bit_index(t28, t33, 2, t38, 32, 2);
    t50 = (t28 + 4);
    t15 = *((unsigned int *)t50);
    t51 = (!(t15));
    if (t51 == 1)
        goto LAB121;

LAB122:    goto LAB118;

LAB94:    goto LAB92;

LAB96:    goto LAB92;

LAB98:    goto LAB92;

LAB100:    xsi_set_current_line(254, ng0);
    t19 = (t0 + 3392U);
    t20 = *((char **)t19);
    memset(t4, 0, 8);
    t19 = (t4 + 4);
    t29 = (t20 + 4);
    t7 = *((unsigned int *)t20);
    t8 = (t7 >> 2);
    t9 = (t8 & 1);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t29);
    t11 = (t10 >> 2);
    t14 = (t11 & 1);
    *((unsigned int *)t19) = t14;
    t30 = (t0 + 3952);
    t31 = (t0 + 3952);
    t32 = (t31 + 72U);
    t33 = *((char **)t32);
    t37 = (t0 + 3232U);
    t39 = *((char **)t37);
    t37 = (t0 + 5232);
    t40 = (t37 + 56U);
    t41 = *((char **)t40);
    memset(t36, 0, 8);
    xsi_vlog_unsigned_minus(t36, 32, t39, 6, t41, 6);
    t42 = ((char*)((ng3)));
    memset(t38, 0, 8);
    xsi_vlog_unsigned_minus(t38, 32, t36, 32, t42, 32);
    xsi_vlog_generic_convert_bit_index(t28, t33, 2, t38, 32, 2);
    t50 = (t28 + 4);
    t15 = *((unsigned int *)t50);
    t51 = (!(t15));
    if (t51 == 1)
        goto LAB123;

LAB124:    goto LAB118;

LAB102:    goto LAB100;

LAB104:    goto LAB100;

LAB106:    goto LAB100;

LAB108:    xsi_set_current_line(256, ng0);
    t19 = (t0 + 3392U);
    t20 = *((char **)t19);
    memset(t4, 0, 8);
    t19 = (t4 + 4);
    t29 = (t20 + 4);
    t7 = *((unsigned int *)t20);
    t8 = (t7 >> 3);
    t9 = (t8 & 1);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t29);
    t11 = (t10 >> 3);
    t14 = (t11 & 1);
    *((unsigned int *)t19) = t14;
    t30 = (t0 + 3952);
    t31 = (t0 + 3952);
    t32 = (t31 + 72U);
    t33 = *((char **)t32);
    t37 = (t0 + 3232U);
    t39 = *((char **)t37);
    t37 = (t0 + 5232);
    t40 = (t37 + 56U);
    t41 = *((char **)t40);
    memset(t36, 0, 8);
    xsi_vlog_unsigned_minus(t36, 32, t39, 6, t41, 6);
    t42 = ((char*)((ng3)));
    memset(t38, 0, 8);
    xsi_vlog_unsigned_minus(t38, 32, t36, 32, t42, 32);
    xsi_vlog_generic_convert_bit_index(t28, t33, 2, t38, 32, 2);
    t50 = (t28 + 4);
    t15 = *((unsigned int *)t50);
    t51 = (!(t15));
    if (t51 == 1)
        goto LAB125;

LAB126:    goto LAB118;

LAB110:    goto LAB108;

LAB112:    goto LAB108;

LAB114:    goto LAB108;

LAB119:    xsi_vlogvar_wait_assign_value(t19, t4, 0, *((unsigned int *)t28), 1, 0LL);
    goto LAB120;

LAB121:    xsi_vlogvar_wait_assign_value(t30, t4, 0, *((unsigned int *)t28), 1, 0LL);
    goto LAB122;

LAB123:    xsi_vlogvar_wait_assign_value(t30, t4, 0, *((unsigned int *)t28), 1, 0LL);
    goto LAB124;

LAB125:    xsi_vlogvar_wait_assign_value(t30, t4, 0, *((unsigned int *)t28), 1, 0LL);
    goto LAB126;

LAB127:    xsi_vlogvar_wait_assign_value(t19, t13, 0, *((unsigned int *)t4), 1, 0LL);
    goto LAB128;

LAB131:    t30 = (t28 + 4);
    *((unsigned int *)t28) = 1;
    *((unsigned int *)t30) = 1;
    goto LAB132;

LAB133:    xsi_set_current_line(260, ng0);

LAB136:    xsi_set_current_line(261, ng0);
    t32 = (t0 + 1016);
    t33 = *((char **)t32);
    t32 = (t0 + 5552);
    xsi_vlogvar_wait_assign_value(t32, t33, 0, 0, 3, 0LL);
    xsi_set_current_line(262, ng0);
    t2 = ((char*)((ng3)));
    t6 = (t0 + 4272);
    xsi_vlogvar_wait_assign_value(t6, t2, 0, 0, 1, 0LL);
    goto LAB135;

}


extern void work_m_00000000002223192111_1408452736_init()
{
	static char *pe[] = {(void *)Always_161_0};
	xsi_register_didat("work_m_00000000002223192111_1408452736", "isim/tb_top_isim_beh.exe.sim/work/m_00000000002223192111_1408452736.didat");
	xsi_register_executes(pe);
}
