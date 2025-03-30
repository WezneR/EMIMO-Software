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
static const char *ng0 = "F:/ISE/UE_CTRL_4CH/srcs/process.v";
static int ng1[] = {0, 0};
static unsigned int ng2[] = {0U, 0U};
static unsigned int ng3[] = {4U, 0U};
static unsigned int ng4[] = {6U, 0U};
static unsigned int ng5[] = {7U, 0U};
static unsigned int ng6[] = {10U, 0U};
static unsigned int ng7[] = {11U, 0U};
static int ng8[] = {4, 0};
static unsigned int ng9[] = {1U, 0U};
static unsigned int ng10[] = {2U, 0U};
static unsigned int ng11[] = {3U, 0U};
static int ng12[] = {1, 0};
static unsigned int ng13[] = {15U, 0U};



static void NetDecl_78_0(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    char *t25;

LAB0:    t1 = (t0 + 6768U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(78, ng0);
    t2 = (t0 + 2728U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 24);
    *((unsigned int *)t3) = t7;
    t8 = *((unsigned int *)t5);
    t9 = (t8 >> 24);
    *((unsigned int *)t2) = t9;
    t10 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t10 & 255U);
    t11 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t11 & 255U);
    t12 = (t0 + 8224);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memset(t16, 0, 8);
    t17 = 255U;
    t18 = t17;
    t19 = (t3 + 4);
    t20 = *((unsigned int *)t3);
    t17 = (t17 & t20);
    t21 = *((unsigned int *)t19);
    t18 = (t18 & t21);
    t22 = (t16 + 4);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t23 | t17);
    t24 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t24 | t18);
    xsi_driver_vfirst_trans(t12, 0, 7U);
    t25 = (t0 + 8080);
    *((int *)t25) = 1;

LAB1:    return;
}

static void NetDecl_79_1(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    char *t25;

LAB0:    t1 = (t0 + 7016U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(79, ng0);
    t2 = (t0 + 2728U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 20);
    *((unsigned int *)t3) = t7;
    t8 = *((unsigned int *)t5);
    t9 = (t8 >> 20);
    *((unsigned int *)t2) = t9;
    t10 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t10 & 7U);
    t11 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t11 & 7U);
    t12 = (t0 + 8288);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memset(t16, 0, 8);
    t17 = 7U;
    t18 = t17;
    t19 = (t3 + 4);
    t20 = *((unsigned int *)t3);
    t17 = (t17 & t20);
    t21 = *((unsigned int *)t19);
    t18 = (t18 & t21);
    t22 = (t16 + 4);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t23 | t17);
    t24 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t24 | t18);
    xsi_driver_vfirst_trans(t12, 0, 2U);
    t25 = (t0 + 8096);
    *((int *)t25) = 1;

LAB1:    return;
}

static void NetDecl_80_2(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    char *t25;

LAB0:    t1 = (t0 + 7264U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(80, ng0);
    t2 = (t0 + 2728U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 16);
    *((unsigned int *)t3) = t7;
    t8 = *((unsigned int *)t5);
    t9 = (t8 >> 16);
    *((unsigned int *)t2) = t9;
    t10 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t10 & 15U);
    t11 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t11 & 15U);
    t12 = (t0 + 8352);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memset(t16, 0, 8);
    t17 = 15U;
    t18 = t17;
    t19 = (t3 + 4);
    t20 = *((unsigned int *)t3);
    t17 = (t17 & t20);
    t21 = *((unsigned int *)t19);
    t18 = (t18 & t21);
    t22 = (t16 + 4);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t23 | t17);
    t24 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t24 | t18);
    xsi_driver_vfirst_trans(t12, 0, 3U);
    t25 = (t0 + 8112);
    *((int *)t25) = 1;

LAB1:    return;
}

static void NetDecl_81_3(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    char *t25;

LAB0:    t1 = (t0 + 7512U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(81, ng0);
    t2 = (t0 + 2728U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (t6 >> 0);
    *((unsigned int *)t3) = t7;
    t8 = *((unsigned int *)t5);
    t9 = (t8 >> 0);
    *((unsigned int *)t2) = t9;
    t10 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t10 & 65535U);
    t11 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t11 & 65535U);
    t12 = (t0 + 8416);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memset(t16, 0, 8);
    t17 = 65535U;
    t18 = t17;
    t19 = (t3 + 4);
    t20 = *((unsigned int *)t3);
    t17 = (t17 & t20);
    t21 = *((unsigned int *)t19);
    t18 = (t18 & t21);
    t22 = (t16 + 4);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t23 | t17);
    t24 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t24 | t18);
    xsi_driver_vfirst_trans(t12, 0, 15U);
    t25 = (t0 + 8128);
    *((int *)t25) = 1;

LAB1:    return;
}

static void Always_98_4(char *t0)
{
    char t4[8];
    char t29[8];
    char t44[8];
    char t60[8];
    char t68[8];
    char t107[8];
    char t117[8];
    char t125[8];
    char t149[8];
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
    char *t28;
    char *t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    char *t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;
    char *t43;
    char *t45;
    char *t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    char *t59;
    char *t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    char *t67;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    char *t72;
    char *t73;
    char *t74;
    unsigned int t75;
    unsigned int t76;
    unsigned int t77;
    unsigned int t78;
    unsigned int t79;
    unsigned int t80;
    unsigned int t81;
    char *t82;
    char *t83;
    unsigned int t84;
    unsigned int t85;
    unsigned int t86;
    int t87;
    unsigned int t88;
    unsigned int t89;
    unsigned int t90;
    int t91;
    unsigned int t92;
    unsigned int t93;
    unsigned int t94;
    unsigned int t95;
    char *t96;
    unsigned int t97;
    unsigned int t98;
    unsigned int t99;
    unsigned int t100;
    unsigned int t101;
    char *t102;
    char *t103;
    int t104;
    char *t105;
    char *t106;
    char *t108;
    unsigned int t109;
    unsigned int t110;
    unsigned int t111;
    unsigned int t112;
    unsigned int t113;
    unsigned int t114;
    char *t115;
    char *t116;
    char *t118;
    unsigned int t119;
    unsigned int t120;
    unsigned int t121;
    unsigned int t122;
    unsigned int t123;
    unsigned int t124;
    char *t126;
    char *t127;
    unsigned int t128;
    unsigned int t129;
    unsigned int t130;
    unsigned int t131;
    unsigned int t132;
    unsigned int t133;
    unsigned int t134;
    unsigned int t135;
    unsigned int t136;
    unsigned int t137;
    unsigned int t138;
    unsigned int t139;
    char *t140;
    char *t141;
    unsigned int t142;
    unsigned int t143;
    unsigned int t144;
    unsigned int t145;
    unsigned int t146;
    char *t147;
    char *t148;
    char *t150;
    unsigned int t151;
    unsigned int t152;
    unsigned int t153;
    unsigned int t154;
    unsigned int t155;
    unsigned int t156;
    char *t157;

LAB0:    t1 = (t0 + 7760U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(98, ng0);
    t2 = (t0 + 8144);
    *((int *)t2) = 1;
    t3 = (t0 + 7792);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(98, ng0);

LAB5:    xsi_set_current_line(99, ng0);
    t5 = (t0 + 2568U);
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

LAB11:    xsi_set_current_line(111, ng0);

LAB14:    xsi_set_current_line(112, ng0);
    t2 = (t0 + 2888U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t7 = *((unsigned int *)t2);
    t8 = (~(t7));
    t9 = *((unsigned int *)t3);
    t10 = (t9 & t8);
    t11 = (t10 != 0);
    if (t11 > 0)
        goto LAB15;

LAB16:
LAB17:    xsi_set_current_line(160, ng0);
    t2 = (t0 + 5688);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 1424);
    t12 = *((char **)t6);
    memset(t4, 0, 8);
    t6 = (t5 + 4);
    t13 = (t12 + 4);
    t7 = *((unsigned int *)t5);
    t8 = *((unsigned int *)t12);
    t9 = (t7 ^ t8);
    t10 = *((unsigned int *)t6);
    t11 = *((unsigned int *)t13);
    t14 = (t10 ^ t11);
    t15 = (t9 | t14);
    t16 = *((unsigned int *)t6);
    t17 = *((unsigned int *)t13);
    t18 = (t16 | t17);
    t21 = (~(t18));
    t22 = (t15 & t21);
    if (t22 != 0)
        goto LAB84;

LAB81:    if (t18 != 0)
        goto LAB83;

LAB82:    *((unsigned int *)t4) = 1;

LAB84:    t20 = (t4 + 4);
    t23 = *((unsigned int *)t20);
    t24 = (~(t23));
    t25 = *((unsigned int *)t4);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB85;

LAB86:
LAB87:    xsi_set_current_line(188, ng0);
    t2 = (t0 + 5688);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 1560);
    t12 = *((char **)t6);
    memset(t4, 0, 8);
    t6 = (t5 + 4);
    t13 = (t12 + 4);
    t7 = *((unsigned int *)t5);
    t8 = *((unsigned int *)t12);
    t9 = (t7 ^ t8);
    t10 = *((unsigned int *)t6);
    t11 = *((unsigned int *)t13);
    t14 = (t10 ^ t11);
    t15 = (t9 | t14);
    t16 = *((unsigned int *)t6);
    t17 = *((unsigned int *)t13);
    t18 = (t16 | t17);
    t21 = (~(t18));
    t22 = (t15 & t21);
    if (t22 != 0)
        goto LAB119;

LAB116:    if (t18 != 0)
        goto LAB118;

LAB117:    *((unsigned int *)t4) = 1;

LAB119:    t20 = (t4 + 4);
    t23 = *((unsigned int *)t20);
    t24 = (~(t23));
    t25 = *((unsigned int *)t4);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB120;

LAB121:
LAB122:    xsi_set_current_line(216, ng0);
    t2 = (t0 + 5688);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 1696);
    t12 = *((char **)t6);
    memset(t4, 0, 8);
    t6 = (t5 + 4);
    t13 = (t12 + 4);
    t7 = *((unsigned int *)t5);
    t8 = *((unsigned int *)t12);
    t9 = (t7 ^ t8);
    t10 = *((unsigned int *)t6);
    t11 = *((unsigned int *)t13);
    t14 = (t10 ^ t11);
    t15 = (t9 | t14);
    t16 = *((unsigned int *)t6);
    t17 = *((unsigned int *)t13);
    t18 = (t16 | t17);
    t21 = (~(t18));
    t22 = (t15 & t21);
    if (t22 != 0)
        goto LAB158;

LAB155:    if (t18 != 0)
        goto LAB157;

LAB156:    *((unsigned int *)t4) = 1;

LAB158:    t20 = (t4 + 4);
    t23 = *((unsigned int *)t20);
    t24 = (~(t23));
    t25 = *((unsigned int *)t4);
    t26 = (t25 & t24);
    t27 = (t26 != 0);
    if (t27 > 0)
        goto LAB159;

LAB160:
LAB161:
LAB12:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(99, ng0);

LAB13:    xsi_set_current_line(101, ng0);
    t19 = (t0 + 1288);
    t20 = *((char **)t19);
    t19 = (t0 + 5688);
    xsi_vlogvar_wait_assign_value(t19, t20, 0, 0, 2, 0LL);
    xsi_set_current_line(103, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4568);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(104, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4728);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(105, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3928);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 6, 0LL);
    xsi_set_current_line(106, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4088);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(107, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4248);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 6, 0LL);
    xsi_set_current_line(108, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4408);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(109, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4888);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    goto LAB12;

LAB15:    xsi_set_current_line(112, ng0);

LAB18:    xsi_set_current_line(114, ng0);
    t5 = (t0 + 3048U);
    t6 = *((char **)t5);
    t5 = (t0 + 5048);
    t12 = (t5 + 56U);
    t13 = *((char **)t12);
    memset(t4, 0, 8);
    t19 = (t6 + 4);
    t20 = (t13 + 4);
    t14 = *((unsigned int *)t6);
    t15 = *((unsigned int *)t13);
    t16 = (t14 ^ t15);
    t17 = *((unsigned int *)t19);
    t18 = *((unsigned int *)t20);
    t21 = (t17 ^ t18);
    t22 = (t16 | t21);
    t23 = *((unsigned int *)t19);
    t24 = *((unsigned int *)t20);
    t25 = (t23 | t24);
    t26 = (~(t25));
    t27 = (t22 & t26);
    if (t27 != 0)
        goto LAB22;

LAB19:    if (t25 != 0)
        goto LAB21;

LAB20:    *((unsigned int *)t4) = 1;

LAB22:    memset(t29, 0, 8);
    t30 = (t4 + 4);
    t31 = *((unsigned int *)t30);
    t32 = (~(t31));
    t33 = *((unsigned int *)t4);
    t34 = (t33 & t32);
    t35 = (t34 & 1U);
    if (t35 != 0)
        goto LAB23;

LAB24:    if (*((unsigned int *)t30) != 0)
        goto LAB25;

LAB26:    t37 = (t29 + 4);
    t38 = *((unsigned int *)t29);
    t39 = (!(t38));
    t40 = *((unsigned int *)t37);
    t41 = (t39 || t40);
    if (t41 > 0)
        goto LAB27;

LAB28:    memcpy(t68, t29, 8);

LAB29:    t96 = (t68 + 4);
    t97 = *((unsigned int *)t96);
    t98 = (~(t97));
    t99 = *((unsigned int *)t68);
    t100 = (t99 & t98);
    t101 = (t100 != 0);
    if (t101 > 0)
        goto LAB41;

LAB42:
LAB43:    goto LAB17;

LAB21:    t28 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t28) = 1;
    goto LAB22;

LAB23:    *((unsigned int *)t29) = 1;
    goto LAB26;

LAB25:    t36 = (t29 + 4);
    *((unsigned int *)t29) = 1;
    *((unsigned int *)t36) = 1;
    goto LAB26;

LAB27:    t42 = (t0 + 3048U);
    t43 = *((char **)t42);
    t42 = ((char*)((ng2)));
    memset(t44, 0, 8);
    t45 = (t43 + 4);
    t46 = (t42 + 4);
    t47 = *((unsigned int *)t43);
    t48 = *((unsigned int *)t42);
    t49 = (t47 ^ t48);
    t50 = *((unsigned int *)t45);
    t51 = *((unsigned int *)t46);
    t52 = (t50 ^ t51);
    t53 = (t49 | t52);
    t54 = *((unsigned int *)t45);
    t55 = *((unsigned int *)t46);
    t56 = (t54 | t55);
    t57 = (~(t56));
    t58 = (t53 & t57);
    if (t58 != 0)
        goto LAB33;

LAB30:    if (t56 != 0)
        goto LAB32;

LAB31:    *((unsigned int *)t44) = 1;

LAB33:    memset(t60, 0, 8);
    t61 = (t44 + 4);
    t62 = *((unsigned int *)t61);
    t63 = (~(t62));
    t64 = *((unsigned int *)t44);
    t65 = (t64 & t63);
    t66 = (t65 & 1U);
    if (t66 != 0)
        goto LAB34;

LAB35:    if (*((unsigned int *)t61) != 0)
        goto LAB36;

LAB37:    t69 = *((unsigned int *)t29);
    t70 = *((unsigned int *)t60);
    t71 = (t69 | t70);
    *((unsigned int *)t68) = t71;
    t72 = (t29 + 4);
    t73 = (t60 + 4);
    t74 = (t68 + 4);
    t75 = *((unsigned int *)t72);
    t76 = *((unsigned int *)t73);
    t77 = (t75 | t76);
    *((unsigned int *)t74) = t77;
    t78 = *((unsigned int *)t74);
    t79 = (t78 != 0);
    if (t79 == 1)
        goto LAB38;

LAB39:
LAB40:    goto LAB29;

LAB32:    t59 = (t44 + 4);
    *((unsigned int *)t44) = 1;
    *((unsigned int *)t59) = 1;
    goto LAB33;

LAB34:    *((unsigned int *)t60) = 1;
    goto LAB37;

LAB36:    t67 = (t60 + 4);
    *((unsigned int *)t60) = 1;
    *((unsigned int *)t67) = 1;
    goto LAB37;

LAB38:    t80 = *((unsigned int *)t68);
    t81 = *((unsigned int *)t74);
    *((unsigned int *)t68) = (t80 | t81);
    t82 = (t29 + 4);
    t83 = (t60 + 4);
    t84 = *((unsigned int *)t82);
    t85 = (~(t84));
    t86 = *((unsigned int *)t29);
    t87 = (t86 & t85);
    t88 = *((unsigned int *)t83);
    t89 = (~(t88));
    t90 = *((unsigned int *)t60);
    t91 = (t90 & t89);
    t92 = (~(t87));
    t93 = (~(t91));
    t94 = *((unsigned int *)t74);
    *((unsigned int *)t74) = (t94 & t92);
    t95 = *((unsigned int *)t74);
    *((unsigned int *)t74) = (t95 & t93);
    goto LAB40;

LAB41:    xsi_set_current_line(114, ng0);

LAB44:    xsi_set_current_line(116, ng0);
    t102 = (t0 + 3368U);
    t103 = *((char **)t102);

LAB45:    t102 = ((char*)((ng3)));
    t104 = xsi_vlog_unsigned_case_compare(t103, 4, t102, 4);
    if (t104 == 1)
        goto LAB46;

LAB47:    t2 = ((char*)((ng4)));
    t87 = xsi_vlog_unsigned_case_compare(t103, 4, t2, 4);
    if (t87 == 1)
        goto LAB48;

LAB49:    t2 = ((char*)((ng5)));
    t87 = xsi_vlog_unsigned_case_compare(t103, 4, t2, 4);
    if (t87 == 1)
        goto LAB50;

LAB51:    t2 = ((char*)((ng6)));
    t87 = xsi_vlog_unsigned_case_compare(t103, 4, t2, 4);
    if (t87 == 1)
        goto LAB52;

LAB53:    t2 = ((char*)((ng7)));
    t87 = xsi_vlog_unsigned_case_compare(t103, 4, t2, 4);
    if (t87 == 1)
        goto LAB54;

LAB55:
LAB57:
LAB56:    xsi_set_current_line(152, ng0);

LAB80:
LAB58:    goto LAB43;

LAB46:    xsi_set_current_line(117, ng0);

LAB59:    xsi_set_current_line(119, ng0);
    t105 = (t0 + 3528U);
    t106 = *((char **)t105);
    memset(t107, 0, 8);
    t105 = (t107 + 4);
    t108 = (t106 + 4);
    t109 = *((unsigned int *)t106);
    t110 = (t109 >> 9);
    t111 = (t110 & 1);
    *((unsigned int *)t107) = t111;
    t112 = *((unsigned int *)t108);
    t113 = (t112 >> 9);
    t114 = (t113 & 1);
    *((unsigned int *)t105) = t114;
    t115 = (t0 + 3528U);
    t116 = *((char **)t115);
    memset(t117, 0, 8);
    t115 = (t117 + 4);
    t118 = (t116 + 4);
    t119 = *((unsigned int *)t116);
    t120 = (t119 >> 8);
    t121 = (t120 & 1);
    *((unsigned int *)t117) = t121;
    t122 = *((unsigned int *)t118);
    t123 = (t122 >> 8);
    t124 = (t123 & 1);
    *((unsigned int *)t115) = t124;
    memset(t125, 0, 8);
    t126 = (t107 + 4);
    t127 = (t117 + 4);
    t128 = *((unsigned int *)t107);
    t129 = *((unsigned int *)t117);
    t130 = (t128 ^ t129);
    t131 = *((unsigned int *)t126);
    t132 = *((unsigned int *)t127);
    t133 = (t131 ^ t132);
    t134 = (t130 | t133);
    t135 = *((unsigned int *)t126);
    t136 = *((unsigned int *)t127);
    t137 = (t135 | t136);
    t138 = (~(t137));
    t139 = (t134 & t138);
    if (t139 != 0)
        goto LAB61;

LAB60:    if (t137 != 0)
        goto LAB62;

LAB63:    t141 = (t125 + 4);
    t142 = *((unsigned int *)t141);
    t143 = (~(t142));
    t144 = *((unsigned int *)t125);
    t145 = (t144 & t143);
    t146 = (t145 != 0);
    if (t146 > 0)
        goto LAB64;

LAB65:    xsi_set_current_line(123, ng0);

LAB68:    xsi_set_current_line(124, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4568);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(125, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4728);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);

LAB66:    goto LAB58;

LAB48:    xsi_set_current_line(128, ng0);

LAB69:    xsi_set_current_line(130, ng0);
    t3 = ((char*)((ng1)));
    t5 = (t0 + 4568);
    xsi_vlogvar_wait_assign_value(t5, t3, 0, 0, 1, 0LL);
    xsi_set_current_line(131, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4728);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB58;

LAB50:    xsi_set_current_line(133, ng0);

LAB70:    xsi_set_current_line(135, ng0);
    t3 = (t0 + 3528U);
    t5 = *((char **)t3);
    memset(t4, 0, 8);
    t3 = (t4 + 4);
    t6 = (t5 + 4);
    t7 = *((unsigned int *)t5);
    t8 = (t7 >> 0);
    *((unsigned int *)t4) = t8;
    t9 = *((unsigned int *)t6);
    t10 = (t9 >> 0);
    *((unsigned int *)t3) = t10;
    t11 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t11 & 15U);
    t14 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t14 & 15U);
    t12 = (t0 + 5048);
    xsi_vlogvar_wait_assign_value(t12, t4, 0, 0, 8, 0LL);
    goto LAB58;

LAB52:    xsi_set_current_line(137, ng0);

LAB71:    xsi_set_current_line(139, ng0);
    t3 = (t0 + 3528U);
    t5 = *((char **)t3);
    memset(t4, 0, 8);
    t3 = (t4 + 4);
    t6 = (t5 + 4);
    t7 = *((unsigned int *)t5);
    t8 = (t7 >> 0);
    *((unsigned int *)t4) = t8;
    t9 = *((unsigned int *)t6);
    t10 = (t9 >> 0);
    *((unsigned int *)t3) = t10;
    t11 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t11 & 63U);
    t14 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t14 & 63U);
    t12 = (t0 + 5208);
    xsi_vlogvar_wait_assign_value(t12, t4, 0, 0, 6, 0LL);
    xsi_set_current_line(140, ng0);
    t2 = (t0 + 3528U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4);
    t5 = (t3 + 4);
    t7 = *((unsigned int *)t3);
    t8 = (t7 >> 8);
    *((unsigned int *)t4) = t8;
    t9 = *((unsigned int *)t5);
    t10 = (t9 >> 8);
    *((unsigned int *)t2) = t10;
    t11 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t11 & 3U);
    t14 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t14 & 3U);
    t6 = (t0 + 5528);
    xsi_vlogvar_wait_assign_value(t6, t4, 0, 0, 2, 0LL);
    xsi_set_current_line(141, ng0);
    t2 = (t0 + 3208U);
    t3 = *((char **)t2);
    t2 = (t0 + 5368);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 3, 0LL);
    xsi_set_current_line(142, ng0);
    t2 = (t0 + 1424);
    t3 = *((char **)t2);
    t2 = (t0 + 5688);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);
    goto LAB58;

LAB54:    xsi_set_current_line(144, ng0);

LAB72:    xsi_set_current_line(145, ng0);
    t3 = (t0 + 3528U);
    t5 = *((char **)t3);
    memset(t4, 0, 8);
    t3 = (t4 + 4);
    t6 = (t5 + 4);
    t7 = *((unsigned int *)t5);
    t8 = (t7 >> 8);
    t9 = (t8 & 1);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t6);
    t11 = (t10 >> 8);
    t14 = (t11 & 1);
    *((unsigned int *)t3) = t14;
    t12 = (t4 + 4);
    t15 = *((unsigned int *)t12);
    t16 = (~(t15));
    t17 = *((unsigned int *)t4);
    t18 = (t17 & t16);
    t21 = (t18 != 0);
    if (t21 > 0)
        goto LAB73;

LAB74:    xsi_set_current_line(148, ng0);

LAB77:    xsi_set_current_line(149, ng0);
    t2 = (t0 + 3528U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4);
    t5 = (t3 + 4);
    t7 = *((unsigned int *)t3);
    t8 = (t7 >> 0);
    t9 = (t8 & 1);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t5);
    t11 = (t10 >> 0);
    t14 = (t11 & 1);
    *((unsigned int *)t2) = t14;
    t6 = (t0 + 4888);
    t12 = (t0 + 4888);
    t13 = (t12 + 72U);
    t19 = *((char **)t13);
    t20 = (t0 + 3208U);
    t28 = *((char **)t20);
    memset(t44, 0, 8);
    t20 = (t44 + 4);
    t30 = (t28 + 4);
    t15 = *((unsigned int *)t28);
    t16 = (t15 >> 0);
    *((unsigned int *)t44) = t16;
    t17 = *((unsigned int *)t30);
    t18 = (t17 >> 0);
    *((unsigned int *)t20) = t18;
    t21 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t21 & 3U);
    t22 = *((unsigned int *)t20);
    *((unsigned int *)t20) = (t22 & 3U);
    xsi_vlog_generic_convert_bit_index(t29, t19, 2, t44, 2, 2);
    t36 = (t29 + 4);
    t23 = *((unsigned int *)t36);
    t87 = (!(t23));
    if (t87 == 1)
        goto LAB78;

LAB79:
LAB75:    goto LAB58;

LAB61:    *((unsigned int *)t125) = 1;
    goto LAB63;

LAB62:    t140 = (t125 + 4);
    *((unsigned int *)t125) = 1;
    *((unsigned int *)t140) = 1;
    goto LAB63;

LAB64:    xsi_set_current_line(119, ng0);

LAB67:    xsi_set_current_line(120, ng0);
    t147 = (t0 + 3528U);
    t148 = *((char **)t147);
    memset(t149, 0, 8);
    t147 = (t149 + 4);
    t150 = (t148 + 4);
    t151 = *((unsigned int *)t148);
    t152 = (t151 >> 9);
    t153 = (t152 & 1);
    *((unsigned int *)t149) = t153;
    t154 = *((unsigned int *)t150);
    t155 = (t154 >> 9);
    t156 = (t155 & 1);
    *((unsigned int *)t147) = t156;
    t157 = (t0 + 4568);
    xsi_vlogvar_wait_assign_value(t157, t149, 0, 0, 1, 0LL);
    xsi_set_current_line(121, ng0);
    t2 = (t0 + 3528U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4);
    t5 = (t3 + 4);
    t7 = *((unsigned int *)t3);
    t8 = (t7 >> 8);
    t9 = (t8 & 1);
    *((unsigned int *)t4) = t9;
    t10 = *((unsigned int *)t5);
    t11 = (t10 >> 8);
    t14 = (t11 & 1);
    *((unsigned int *)t2) = t14;
    t6 = (t0 + 4728);
    xsi_vlogvar_wait_assign_value(t6, t4, 0, 0, 1, 0LL);
    goto LAB66;

LAB73:    xsi_set_current_line(145, ng0);

LAB76:    xsi_set_current_line(146, ng0);
    t13 = ((char*)((ng8)));
    t19 = (t0 + 3528U);
    t20 = *((char **)t19);
    memset(t44, 0, 8);
    t19 = (t44 + 4);
    t28 = (t20 + 4);
    t22 = *((unsigned int *)t20);
    t23 = (t22 >> 0);
    t24 = (t23 & 1);
    *((unsigned int *)t44) = t24;
    t25 = *((unsigned int *)t28);
    t26 = (t25 >> 0);
    t27 = (t26 & 1);
    *((unsigned int *)t19) = t27;
    xsi_vlog_mul_concat(t29, 4, 1, t13, 1U, t44, 1);
    t30 = (t0 + 4888);
    xsi_vlogvar_wait_assign_value(t30, t29, 0, 0, 4, 0LL);
    goto LAB75;

LAB78:    xsi_vlogvar_wait_assign_value(t6, t4, 0, *((unsigned int *)t29), 1, 0LL);
    goto LAB79;

LAB83:    t19 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t19) = 1;
    goto LAB84;

LAB85:    xsi_set_current_line(160, ng0);

LAB88:    xsi_set_current_line(161, ng0);
    t28 = (t0 + 5528);
    t30 = (t28 + 56U);
    t36 = *((char **)t30);

LAB89:    t37 = ((char*)((ng2)));
    t87 = xsi_vlog_unsigned_case_compare(t36, 2, t37, 2);
    if (t87 == 1)
        goto LAB90;

LAB91:    t2 = ((char*)((ng9)));
    t87 = xsi_vlog_unsigned_case_compare(t36, 2, t2, 2);
    if (t87 == 1)
        goto LAB92;

LAB93:    t2 = ((char*)((ng10)));
    t87 = xsi_vlog_unsigned_case_compare(t36, 2, t2, 2);
    if (t87 == 1)
        goto LAB94;

LAB95:    t2 = ((char*)((ng11)));
    t87 = xsi_vlog_unsigned_case_compare(t36, 2, t2, 2);
    if (t87 == 1)
        goto LAB96;

LAB97:
LAB99:
LAB98:    xsi_set_current_line(180, ng0);

LAB115:
LAB100:    xsi_set_current_line(184, ng0);
    t2 = (t0 + 1560);
    t3 = *((char **)t2);
    t2 = (t0 + 5688);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);
    goto LAB87;

LAB90:    xsi_set_current_line(162, ng0);

LAB101:    xsi_set_current_line(163, ng0);
    t42 = (t0 + 5368);
    t43 = (t42 + 56U);
    t45 = *((char **)t43);
    t46 = ((char*)((ng8)));
    memset(t29, 0, 8);
    t59 = (t45 + 4);
    if (*((unsigned int *)t59) != 0)
        goto LAB103;

LAB102:    t61 = (t46 + 4);
    if (*((unsigned int *)t61) != 0)
        goto LAB103;

LAB106:    if (*((unsigned int *)t45) < *((unsigned int *)t46))
        goto LAB104;

LAB105:    t72 = (t29 + 4);
    t31 = *((unsigned int *)t72);
    t32 = (~(t31));
    t33 = *((unsigned int *)t29);
    t34 = (t33 & t32);
    t35 = (t34 != 0);
    if (t35 > 0)
        goto LAB107;

LAB108:    xsi_set_current_line(166, ng0);

LAB111:    xsi_set_current_line(167, ng0);
    t2 = (t0 + 5208);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 4248);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 6, 0LL);

LAB109:    goto LAB100;

LAB92:    xsi_set_current_line(170, ng0);

LAB112:    xsi_set_current_line(171, ng0);
    t3 = (t0 + 5208);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t12 = (t0 + 4248);
    xsi_vlogvar_wait_assign_value(t12, t6, 0, 0, 6, 0LL);
    goto LAB100;

LAB94:    xsi_set_current_line(173, ng0);

LAB113:    xsi_set_current_line(174, ng0);
    t3 = (t0 + 5208);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t12 = (t0 + 3928);
    xsi_vlogvar_wait_assign_value(t12, t6, 0, 0, 6, 0LL);
    goto LAB100;

LAB96:    xsi_set_current_line(176, ng0);

LAB114:    xsi_set_current_line(177, ng0);
    t3 = (t0 + 5208);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t12 = (t0 + 3928);
    xsi_vlogvar_wait_assign_value(t12, t6, 0, 0, 6, 0LL);
    xsi_set_current_line(178, ng0);
    t2 = (t0 + 5208);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 4248);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 6, 0LL);
    goto LAB100;

LAB103:    t67 = (t29 + 4);
    *((unsigned int *)t29) = 1;
    *((unsigned int *)t67) = 1;
    goto LAB105;

LAB104:    *((unsigned int *)t29) = 1;
    goto LAB105;

LAB107:    xsi_set_current_line(163, ng0);

LAB110:    xsi_set_current_line(164, ng0);
    t73 = (t0 + 5208);
    t74 = (t73 + 56U);
    t82 = *((char **)t74);
    t83 = (t0 + 3928);
    xsi_vlogvar_wait_assign_value(t83, t82, 0, 0, 6, 0LL);
    goto LAB109;

LAB118:    t19 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t19) = 1;
    goto LAB119;

LAB120:    xsi_set_current_line(188, ng0);

LAB123:    xsi_set_current_line(189, ng0);
    t28 = (t0 + 5528);
    t30 = (t28 + 56U);
    t37 = *((char **)t30);

LAB124:    t42 = ((char*)((ng2)));
    t87 = xsi_vlog_unsigned_case_compare(t37, 2, t42, 2);
    if (t87 == 1)
        goto LAB125;

LAB126:    t2 = ((char*)((ng9)));
    t87 = xsi_vlog_unsigned_case_compare(t37, 2, t2, 2);
    if (t87 == 1)
        goto LAB127;

LAB128:    t2 = ((char*)((ng10)));
    t87 = xsi_vlog_unsigned_case_compare(t37, 2, t2, 2);
    if (t87 == 1)
        goto LAB129;

LAB130:    t2 = ((char*)((ng11)));
    t87 = xsi_vlog_unsigned_case_compare(t37, 2, t2, 2);
    if (t87 == 1)
        goto LAB131;

LAB132:
LAB134:
LAB133:    xsi_set_current_line(208, ng0);

LAB154:
LAB135:    xsi_set_current_line(212, ng0);
    t2 = (t0 + 1696);
    t3 = *((char **)t2);
    t2 = (t0 + 5688);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);
    goto LAB122;

LAB125:    xsi_set_current_line(190, ng0);

LAB136:    xsi_set_current_line(191, ng0);
    t43 = (t0 + 5368);
    t45 = (t43 + 56U);
    t46 = *((char **)t45);
    t59 = ((char*)((ng8)));
    memset(t29, 0, 8);
    t61 = (t46 + 4);
    if (*((unsigned int *)t61) != 0)
        goto LAB138;

LAB137:    t67 = (t59 + 4);
    if (*((unsigned int *)t67) != 0)
        goto LAB138;

LAB141:    if (*((unsigned int *)t46) < *((unsigned int *)t59))
        goto LAB139;

LAB140:    t73 = (t29 + 4);
    t31 = *((unsigned int *)t73);
    t32 = (~(t31));
    t33 = *((unsigned int *)t29);
    t34 = (t33 & t32);
    t35 = (t34 != 0);
    if (t35 > 0)
        goto LAB142;

LAB143:    xsi_set_current_line(194, ng0);

LAB148:    xsi_set_current_line(195, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 4408);
    t5 = (t0 + 4408);
    t6 = (t5 + 72U);
    t12 = *((char **)t6);
    t13 = (t0 + 5368);
    t19 = (t13 + 56U);
    t20 = *((char **)t19);
    memset(t29, 0, 8);
    t28 = (t29 + 4);
    t30 = (t20 + 4);
    t7 = *((unsigned int *)t20);
    t8 = (t7 >> 0);
    *((unsigned int *)t29) = t8;
    t9 = *((unsigned int *)t30);
    t10 = (t9 >> 0);
    *((unsigned int *)t28) = t10;
    t11 = *((unsigned int *)t29);
    *((unsigned int *)t29) = (t11 & 3U);
    t14 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t14 & 3U);
    xsi_vlog_generic_convert_bit_index(t4, t12, 2, t29, 2, 2);
    t42 = (t4 + 4);
    t15 = *((unsigned int *)t42);
    t87 = (!(t15));
    if (t87 == 1)
        goto LAB149;

LAB150:
LAB144:    goto LAB135;

LAB127:    xsi_set_current_line(198, ng0);

LAB151:    xsi_set_current_line(199, ng0);
    t3 = ((char*)((ng13)));
    t5 = (t0 + 4408);
    xsi_vlogvar_wait_assign_value(t5, t3, 0, 0, 4, 0LL);
    goto LAB135;

LAB129:    xsi_set_current_line(201, ng0);

LAB152:    xsi_set_current_line(202, ng0);
    t3 = ((char*)((ng13)));
    t5 = (t0 + 4088);
    xsi_vlogvar_wait_assign_value(t5, t3, 0, 0, 4, 0LL);
    goto LAB135;

LAB131:    xsi_set_current_line(204, ng0);

LAB153:    xsi_set_current_line(205, ng0);
    t3 = ((char*)((ng13)));
    t5 = (t0 + 4088);
    xsi_vlogvar_wait_assign_value(t5, t3, 0, 0, 4, 0LL);
    xsi_set_current_line(206, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 4408);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    goto LAB135;

LAB138:    t72 = (t29 + 4);
    *((unsigned int *)t29) = 1;
    *((unsigned int *)t72) = 1;
    goto LAB140;

LAB139:    *((unsigned int *)t29) = 1;
    goto LAB140;

LAB142:    xsi_set_current_line(191, ng0);

LAB145:    xsi_set_current_line(192, ng0);
    t74 = ((char*)((ng12)));
    t82 = (t0 + 4088);
    t83 = (t0 + 4088);
    t96 = (t83 + 72U);
    t102 = *((char **)t96);
    t105 = (t0 + 5368);
    t106 = (t105 + 56U);
    t108 = *((char **)t106);
    memset(t60, 0, 8);
    t115 = (t60 + 4);
    t116 = (t108 + 4);
    t38 = *((unsigned int *)t108);
    t39 = (t38 >> 0);
    *((unsigned int *)t60) = t39;
    t40 = *((unsigned int *)t116);
    t41 = (t40 >> 0);
    *((unsigned int *)t115) = t41;
    t47 = *((unsigned int *)t60);
    *((unsigned int *)t60) = (t47 & 3U);
    t48 = *((unsigned int *)t115);
    *((unsigned int *)t115) = (t48 & 3U);
    xsi_vlog_generic_convert_bit_index(t44, t102, 2, t60, 2, 2);
    t118 = (t44 + 4);
    t49 = *((unsigned int *)t118);
    t91 = (!(t49));
    if (t91 == 1)
        goto LAB146;

LAB147:    goto LAB144;

LAB146:    xsi_vlogvar_wait_assign_value(t82, t74, 0, *((unsigned int *)t44), 1, 0LL);
    goto LAB147;

LAB149:    xsi_vlogvar_wait_assign_value(t3, t2, 0, *((unsigned int *)t4), 1, 0LL);
    goto LAB150;

LAB157:    t19 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t19) = 1;
    goto LAB158;

LAB159:    xsi_set_current_line(216, ng0);

LAB162:    xsi_set_current_line(217, ng0);
    t28 = (t0 + 5848);
    t30 = (t28 + 56U);
    t42 = *((char **)t30);
    t43 = ((char*)((ng12)));
    memset(t29, 0, 8);
    xsi_vlog_unsigned_add(t29, 32, t42, 4, t43, 32);
    t45 = (t0 + 5848);
    xsi_vlogvar_wait_assign_value(t45, t29, 0, 0, 4, 0LL);
    xsi_set_current_line(218, ng0);
    t2 = (t0 + 5848);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = ((char*)((ng8)));
    memset(t4, 0, 8);
    t12 = (t5 + 4);
    if (*((unsigned int *)t12) != 0)
        goto LAB164;

LAB163:    t13 = (t6 + 4);
    if (*((unsigned int *)t13) != 0)
        goto LAB164;

LAB167:    if (*((unsigned int *)t5) > *((unsigned int *)t6))
        goto LAB165;

LAB166:    t20 = (t4 + 4);
    t7 = *((unsigned int *)t20);
    t8 = (~(t7));
    t9 = *((unsigned int *)t4);
    t10 = (t9 & t8);
    t11 = (t10 != 0);
    if (t11 > 0)
        goto LAB168;

LAB169:
LAB170:    goto LAB161;

LAB164:    t19 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t19) = 1;
    goto LAB166;

LAB165:    *((unsigned int *)t4) = 1;
    goto LAB166;

LAB168:    xsi_set_current_line(218, ng0);

LAB171:    xsi_set_current_line(219, ng0);
    t28 = ((char*)((ng1)));
    t30 = (t0 + 4088);
    xsi_vlogvar_wait_assign_value(t30, t28, 0, 0, 4, 0LL);
    xsi_set_current_line(220, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4408);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(221, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 5848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 4, 0LL);
    xsi_set_current_line(222, ng0);
    t2 = (t0 + 1288);
    t3 = *((char **)t2);
    t2 = (t0 + 5688);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, 0, 2, 0LL);
    goto LAB170;

}


extern void work_m_00000000000060210932_3416380319_init()
{
	static char *pe[] = {(void *)NetDecl_78_0,(void *)NetDecl_79_1,(void *)NetDecl_80_2,(void *)NetDecl_81_3,(void *)Always_98_4};
	xsi_register_didat("work_m_00000000000060210932_3416380319", "isim/top_tb_isim_beh.exe.sim/work/m_00000000000060210932_3416380319.didat");
	xsi_register_executes(pe);
}
