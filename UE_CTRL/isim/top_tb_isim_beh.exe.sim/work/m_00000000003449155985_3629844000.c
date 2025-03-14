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
static const char *ng0 = "F:/ISE/UE_CTRL/srcs/SPI_Listener.v";
static int ng1[] = {0, 0};
static int ng2[] = {1, 0};
static int ng3[] = {2, 0};
static int ng4[] = {3, 0};



static void Always_45_0(char *t0)
{
    char t18[8];
    char t19[8];
    char t38[8];
    char t46[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    int t15;
    char *t16;
    char *t17;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    unsigned int t28;
    int t29;
    char *t30;
    unsigned int t31;
    int t32;
    int t33;
    unsigned int t34;
    unsigned int t35;
    int t36;
    int t37;
    char *t39;
    char *t40;
    char *t41;
    char *t42;
    char *t43;
    char *t44;
    char *t45;
    char *t47;
    char *t48;
    char *t49;
    char *t50;
    char *t51;
    char *t52;
    char *t53;
    char *t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    unsigned int t75;
    unsigned int t76;
    unsigned int t77;
    unsigned int t78;
    unsigned int t79;
    unsigned int t80;
    unsigned int t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    unsigned int t88;
    unsigned int t89;
    unsigned int t90;
    unsigned int t91;
    unsigned int t92;
    unsigned int t93;
    unsigned int t94;
    unsigned int t95;
    unsigned int t96;
    unsigned int t97;
    unsigned int t98;
    unsigned int t99;

LAB0:    t1 = (t0 + 3624U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(45, ng0);
    t2 = (t0 + 4192);
    *((int *)t2) = 1;
    t3 = (t0 + 3656);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(46, ng0);

LAB5:    xsi_set_current_line(47, ng0);
    t4 = (t0 + 1344U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(74, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2064);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);

LAB8:    xsi_set_current_line(76, ng0);
    t2 = (t0 + 2224);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t18, 0, 8);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t4);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB30;

LAB31:    if (*((unsigned int *)t5) != 0)
        goto LAB32;

LAB33:    t12 = (t18 + 4);
    t28 = *((unsigned int *)t18);
    t31 = *((unsigned int *)t12);
    t34 = (t28 || t31);
    if (t34 > 0)
        goto LAB34;

LAB35:    memcpy(t46, t18, 8);

LAB36:    t41 = (t46 + 4);
    t95 = *((unsigned int *)t41);
    t96 = (~(t95));
    t97 = *((unsigned int *)t46);
    t98 = (t97 & t96);
    t99 = (t98 != 0);
    if (t99 > 0)
        goto LAB48;

LAB49:
LAB50:    goto LAB2;

LAB6:    xsi_set_current_line(48, ng0);

LAB9:    xsi_set_current_line(49, ng0);
    t11 = (t0 + 2544);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);

LAB10:    t14 = ((char*)((ng1)));
    t15 = xsi_vlog_unsigned_case_compare(t13, 2, t14, 32);
    if (t15 == 1)
        goto LAB11;

LAB12:    t2 = ((char*)((ng2)));
    t15 = xsi_vlog_unsigned_case_compare(t13, 2, t2, 32);
    if (t15 == 1)
        goto LAB13;

LAB14:    t2 = ((char*)((ng3)));
    t15 = xsi_vlog_unsigned_case_compare(t13, 2, t2, 32);
    if (t15 == 1)
        goto LAB15;

LAB16:    t2 = ((char*)((ng4)));
    t15 = xsi_vlog_unsigned_case_compare(t13, 2, t2, 32);
    if (t15 == 1)
        goto LAB17;

LAB18:
LAB19:    goto LAB8;

LAB11:    xsi_set_current_line(51, ng0);

LAB20:    xsi_set_current_line(52, ng0);
    t16 = (t0 + 1504U);
    t17 = *((char **)t16);
    t16 = (t0 + 2704);
    t20 = (t0 + 2704);
    t21 = (t20 + 72U);
    t22 = *((char **)t21);
    t23 = (t0 + 2704);
    t24 = (t23 + 64U);
    t25 = *((char **)t24);
    t26 = ((char*)((ng1)));
    xsi_vlog_generic_convert_array_indices(t18, t19, t22, t25, 2, 1, t26, 32, 1);
    t27 = (t18 + 4);
    t28 = *((unsigned int *)t27);
    t29 = (!(t28));
    t30 = (t19 + 4);
    t31 = *((unsigned int *)t30);
    t32 = (!(t31));
    t33 = (t29 && t32);
    if (t33 == 1)
        goto LAB21;

LAB22:    xsi_set_current_line(53, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 2, 0LL);
    goto LAB19;

LAB13:    xsi_set_current_line(56, ng0);

LAB23:    xsi_set_current_line(57, ng0);
    t3 = (t0 + 1504U);
    t4 = *((char **)t3);
    t3 = (t0 + 2704);
    t5 = (t0 + 2704);
    t11 = (t5 + 72U);
    t12 = *((char **)t11);
    t14 = (t0 + 2704);
    t16 = (t14 + 64U);
    t17 = *((char **)t16);
    t20 = ((char*)((ng2)));
    xsi_vlog_generic_convert_array_indices(t18, t19, t12, t17, 2, 1, t20, 32, 1);
    t21 = (t18 + 4);
    t6 = *((unsigned int *)t21);
    t29 = (!(t6));
    t22 = (t19 + 4);
    t7 = *((unsigned int *)t22);
    t32 = (!(t7));
    t33 = (t29 && t32);
    if (t33 == 1)
        goto LAB24;

LAB25:    xsi_set_current_line(58, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 2, 0LL);
    goto LAB19;

LAB15:    xsi_set_current_line(61, ng0);

LAB26:    xsi_set_current_line(62, ng0);
    t3 = (t0 + 1504U);
    t4 = *((char **)t3);
    t3 = (t0 + 2704);
    t5 = (t0 + 2704);
    t11 = (t5 + 72U);
    t12 = *((char **)t11);
    t14 = (t0 + 2704);
    t16 = (t14 + 64U);
    t17 = *((char **)t16);
    t20 = ((char*)((ng3)));
    xsi_vlog_generic_convert_array_indices(t18, t19, t12, t17, 2, 1, t20, 32, 1);
    t21 = (t18 + 4);
    t6 = *((unsigned int *)t21);
    t29 = (!(t6));
    t22 = (t19 + 4);
    t7 = *((unsigned int *)t22);
    t32 = (!(t7));
    t33 = (t29 && t32);
    if (t33 == 1)
        goto LAB27;

LAB28:    xsi_set_current_line(63, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 2, 0LL);
    goto LAB19;

LAB17:    xsi_set_current_line(66, ng0);

LAB29:    xsi_set_current_line(67, ng0);
    t3 = (t0 + 1504U);
    t4 = *((char **)t3);
    t3 = (t0 + 2704);
    t5 = (t3 + 56U);
    t11 = *((char **)t5);
    t12 = (t0 + 2704);
    t14 = (t12 + 72U);
    t16 = *((char **)t14);
    t17 = (t0 + 2704);
    t20 = (t17 + 64U);
    t21 = *((char **)t20);
    t22 = ((char*)((ng3)));
    xsi_vlog_generic_get_array_select_value(t19, 8, t11, t16, t21, 2, 1, t22, 32, 1);
    t23 = (t0 + 2704);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    t26 = (t0 + 2704);
    t27 = (t26 + 72U);
    t30 = *((char **)t27);
    t39 = (t0 + 2704);
    t40 = (t39 + 64U);
    t41 = *((char **)t40);
    t42 = ((char*)((ng2)));
    xsi_vlog_generic_get_array_select_value(t38, 8, t25, t30, t41, 2, 1, t42, 32, 1);
    t43 = (t0 + 2704);
    t44 = (t43 + 56U);
    t45 = *((char **)t44);
    t47 = (t0 + 2704);
    t48 = (t47 + 72U);
    t49 = *((char **)t48);
    t50 = (t0 + 2704);
    t51 = (t50 + 64U);
    t52 = *((char **)t51);
    t53 = ((char*)((ng1)));
    xsi_vlog_generic_get_array_select_value(t46, 8, t45, t49, t52, 2, 1, t53, 32, 1);
    xsi_vlogtype_concat(t18, 32, 32, 4U, t46, 8, t38, 8, t19, 8, t4, 8);
    t54 = (t0 + 1904);
    xsi_vlogvar_wait_assign_value(t54, t18, 0, 0, 32, 0LL);
    xsi_set_current_line(68, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2064);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(69, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 2, 0LL);
    goto LAB19;

LAB21:    t34 = *((unsigned int *)t18);
    t35 = *((unsigned int *)t19);
    t36 = (t34 - t35);
    t37 = (t36 + 1);
    xsi_vlogvar_wait_assign_value(t16, t17, 0, *((unsigned int *)t19), t37, 0LL);
    goto LAB22;

LAB24:    t8 = *((unsigned int *)t18);
    t9 = *((unsigned int *)t19);
    t36 = (t8 - t9);
    t37 = (t36 + 1);
    xsi_vlogvar_wait_assign_value(t3, t4, 0, *((unsigned int *)t19), t37, 0LL);
    goto LAB25;

LAB27:    t8 = *((unsigned int *)t18);
    t9 = *((unsigned int *)t19);
    t36 = (t8 - t9);
    t37 = (t36 + 1);
    xsi_vlogvar_wait_assign_value(t3, t4, 0, *((unsigned int *)t19), t37, 0LL);
    goto LAB28;

LAB30:    *((unsigned int *)t18) = 1;
    goto LAB33;

LAB32:    t11 = (t18 + 4);
    *((unsigned int *)t18) = 1;
    *((unsigned int *)t11) = 1;
    goto LAB33;

LAB34:    t14 = (t0 + 2544);
    t16 = (t14 + 56U);
    t17 = *((char **)t16);
    t20 = ((char*)((ng1)));
    memset(t19, 0, 8);
    t21 = (t17 + 4);
    t22 = (t20 + 4);
    t35 = *((unsigned int *)t17);
    t55 = *((unsigned int *)t20);
    t56 = (t35 ^ t55);
    t57 = *((unsigned int *)t21);
    t58 = *((unsigned int *)t22);
    t59 = (t57 ^ t58);
    t60 = (t56 | t59);
    t61 = *((unsigned int *)t21);
    t62 = *((unsigned int *)t22);
    t63 = (t61 | t62);
    t64 = (~(t63));
    t65 = (t60 & t64);
    if (t65 != 0)
        goto LAB38;

LAB37:    if (t63 != 0)
        goto LAB39;

LAB40:    memset(t38, 0, 8);
    t24 = (t19 + 4);
    t66 = *((unsigned int *)t24);
    t67 = (~(t66));
    t68 = *((unsigned int *)t19);
    t69 = (t68 & t67);
    t70 = (t69 & 1U);
    if (t70 != 0)
        goto LAB41;

LAB42:    if (*((unsigned int *)t24) != 0)
        goto LAB43;

LAB44:    t71 = *((unsigned int *)t18);
    t72 = *((unsigned int *)t38);
    t73 = (t71 & t72);
    *((unsigned int *)t46) = t73;
    t26 = (t18 + 4);
    t27 = (t38 + 4);
    t30 = (t46 + 4);
    t74 = *((unsigned int *)t26);
    t75 = *((unsigned int *)t27);
    t76 = (t74 | t75);
    *((unsigned int *)t30) = t76;
    t77 = *((unsigned int *)t30);
    t78 = (t77 != 0);
    if (t78 == 1)
        goto LAB45;

LAB46:
LAB47:    goto LAB36;

LAB38:    *((unsigned int *)t19) = 1;
    goto LAB40;

LAB39:    t23 = (t19 + 4);
    *((unsigned int *)t19) = 1;
    *((unsigned int *)t23) = 1;
    goto LAB40;

LAB41:    *((unsigned int *)t38) = 1;
    goto LAB44;

LAB43:    t25 = (t38 + 4);
    *((unsigned int *)t38) = 1;
    *((unsigned int *)t25) = 1;
    goto LAB44;

LAB45:    t79 = *((unsigned int *)t46);
    t80 = *((unsigned int *)t30);
    *((unsigned int *)t46) = (t79 | t80);
    t39 = (t18 + 4);
    t40 = (t38 + 4);
    t81 = *((unsigned int *)t18);
    t82 = (~(t81));
    t83 = *((unsigned int *)t39);
    t84 = (~(t83));
    t85 = *((unsigned int *)t38);
    t86 = (~(t85));
    t87 = *((unsigned int *)t40);
    t88 = (~(t87));
    t15 = (t82 & t84);
    t29 = (t86 & t88);
    t89 = (~(t15));
    t90 = (~(t29));
    t91 = *((unsigned int *)t30);
    *((unsigned int *)t30) = (t91 & t89);
    t92 = *((unsigned int *)t30);
    *((unsigned int *)t30) = (t92 & t90);
    t93 = *((unsigned int *)t46);
    *((unsigned int *)t46) = (t93 & t89);
    t94 = *((unsigned int *)t46);
    *((unsigned int *)t46) = (t94 & t90);
    goto LAB47;

LAB48:    xsi_set_current_line(77, ng0);
    t42 = ((char*)((ng1)));
    t43 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t43, t42, 0, 0, 2, 0LL);
    goto LAB50;

}

static void Always_80_1(char *t0)
{
    char t13[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    char *t29;

LAB0:    t1 = (t0 + 3872U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(80, ng0);
    t2 = (t0 + 4208);
    *((int *)t2) = 1;
    t3 = (t0 + 3904);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(81, ng0);

LAB5:    xsi_set_current_line(82, ng0);
    t4 = (t0 + 1344U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(87, ng0);
    t2 = (t0 + 2384);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 472);
    t11 = *((char **)t5);
    memset(t13, 0, 8);
    t5 = (t4 + 4);
    t12 = (t11 + 4);
    t6 = *((unsigned int *)t4);
    t7 = *((unsigned int *)t11);
    t8 = (t6 ^ t7);
    t9 = *((unsigned int *)t5);
    t10 = *((unsigned int *)t12);
    t14 = (t9 ^ t10);
    t15 = (t8 | t14);
    t16 = *((unsigned int *)t5);
    t17 = *((unsigned int *)t12);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB13;

LAB10:    if (t18 != 0)
        goto LAB12;

LAB11:    *((unsigned int *)t13) = 1;

LAB13:    t22 = (t13 + 4);
    t23 = *((unsigned int *)t22);
    t24 = (~(t23));
    t25 = *((unsigned int *)t13);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB14;

LAB15:    xsi_set_current_line(90, ng0);
    t2 = (t0 + 2384);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng2)));
    memset(t13, 0, 8);
    xsi_vlog_unsigned_add(t13, 32, t4, 16, t5, 32);
    t11 = (t0 + 2384);
    xsi_vlogvar_wait_assign_value(t11, t13, 0, 0, 16, 0LL);

LAB16:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(83, ng0);

LAB9:    xsi_set_current_line(84, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2224);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 1, 0LL);
    xsi_set_current_line(85, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2384);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 16, 0LL);
    goto LAB8;

LAB12:    t21 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB13;

LAB14:    xsi_set_current_line(88, ng0);
    t28 = ((char*)((ng2)));
    t29 = (t0 + 2224);
    xsi_vlogvar_wait_assign_value(t29, t28, 0, 0, 1, 0LL);
    goto LAB16;

}


extern void work_m_00000000003449155985_3629844000_init()
{
	static char *pe[] = {(void *)Always_45_0,(void *)Always_80_1};
	xsi_register_didat("work_m_00000000003449155985_3629844000", "isim/top_tb_isim_beh.exe.sim/work/m_00000000003449155985_3629844000.didat");
	xsi_register_executes(pe);
}
