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
static const char *ng0 = "D:/FPGA_project/MSTR111_Driver_4x16_BS1_upper_FBS/SPI_Listener.v";
static int ng1[] = {0, 0};
static unsigned int ng2[] = {1U, 0U};
static unsigned int ng3[] = {0U, 0U};
static int ng4[] = {1, 0};
static int ng5[] = {2, 0};



static void Always_18_0(char *t0)
{
    char t16[8];
    char t27[8];
    char t43[8];
    char t56[8];
    char t67[8];
    char t83[8];
    char t91[8];
    char t127[8];
    char t128[8];
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
    char *t17;
    char *t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    char *t28;
    char *t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;
    char *t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    char *t50;
    char *t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    char *t57;
    char *t58;
    char *t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    char *t66;
    char *t68;
    char *t69;
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
    char *t82;
    char *t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    unsigned int t88;
    unsigned int t89;
    char *t90;
    unsigned int t92;
    unsigned int t93;
    unsigned int t94;
    char *t95;
    char *t96;
    char *t97;
    unsigned int t98;
    unsigned int t99;
    unsigned int t100;
    unsigned int t101;
    unsigned int t102;
    unsigned int t103;
    unsigned int t104;
    char *t105;
    char *t106;
    unsigned int t107;
    unsigned int t108;
    unsigned int t109;
    int t110;
    unsigned int t111;
    unsigned int t112;
    unsigned int t113;
    int t114;
    unsigned int t115;
    unsigned int t116;
    unsigned int t117;
    unsigned int t118;
    char *t119;
    unsigned int t120;
    unsigned int t121;
    unsigned int t122;
    unsigned int t123;
    unsigned int t124;
    char *t125;
    char *t126;
    char *t129;
    char *t130;
    char *t131;
    char *t132;
    char *t133;
    char *t134;
    char *t135;
    char *t136;
    unsigned int t137;
    int t138;
    char *t139;
    unsigned int t140;
    int t141;
    int t142;
    unsigned int t143;
    unsigned int t144;
    int t145;
    int t146;

LAB0:    t1 = (t0 + 3760U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(18, ng0);
    t2 = (t0 + 4328);
    *((int *)t2) = 1;
    t3 = (t0 + 3792);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(19, ng0);

LAB5:    xsi_set_current_line(20, ng0);
    t4 = (t0 + 1480U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(47, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2200);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);

LAB8:    xsi_set_current_line(49, ng0);
    t2 = (t0 + 2360);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t16, 0, 8);
    t5 = (t4 + 4);
    t6 = *((unsigned int *)t5);
    t7 = (~(t6));
    t8 = *((unsigned int *)t4);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB51;

LAB52:    if (*((unsigned int *)t5) != 0)
        goto LAB53;

LAB54:    t12 = (t16 + 4);
    t20 = *((unsigned int *)t16);
    t21 = *((unsigned int *)t12);
    t22 = (t20 || t21);
    if (t22 > 0)
        goto LAB55;

LAB56:    memcpy(t56, t16, 8);

LAB57:    t66 = (t56 + 4);
    t81 = *((unsigned int *)t66);
    t85 = (~(t81));
    t86 = *((unsigned int *)t56);
    t87 = (t86 & t85);
    t88 = (t87 != 0);
    if (t88 > 0)
        goto LAB69;

LAB70:
LAB71:    goto LAB2;

LAB6:    xsi_set_current_line(21, ng0);

LAB9:    xsi_set_current_line(22, ng0);
    t11 = (t0 + 2680);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);

LAB10:    t14 = ((char*)((ng1)));
    t15 = xsi_vlog_unsigned_case_compare(t13, 2, t14, 32);
    if (t15 == 1)
        goto LAB11;

LAB12:    t2 = ((char*)((ng4)));
    t15 = xsi_vlog_unsigned_case_compare(t13, 2, t2, 32);
    if (t15 == 1)
        goto LAB13;

LAB14:    t2 = ((char*)((ng5)));
    t15 = xsi_vlog_unsigned_case_compare(t13, 2, t2, 32);
    if (t15 == 1)
        goto LAB15;

LAB16:
LAB17:    goto LAB8;

LAB11:    xsi_set_current_line(24, ng0);

LAB18:    xsi_set_current_line(25, ng0);
    t17 = (t0 + 1640U);
    t18 = *((char **)t17);
    memset(t16, 0, 8);
    t17 = (t16 + 4);
    t19 = (t18 + 4);
    t20 = *((unsigned int *)t18);
    t21 = (t20 >> 5);
    *((unsigned int *)t16) = t21;
    t22 = *((unsigned int *)t19);
    t23 = (t22 >> 5);
    *((unsigned int *)t17) = t23;
    t24 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t24 & 7U);
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 & 7U);
    t26 = ((char*)((ng2)));
    memset(t27, 0, 8);
    t28 = (t16 + 4);
    t29 = (t26 + 4);
    t30 = *((unsigned int *)t16);
    t31 = *((unsigned int *)t26);
    t32 = (t30 ^ t31);
    t33 = *((unsigned int *)t28);
    t34 = *((unsigned int *)t29);
    t35 = (t33 ^ t34);
    t36 = (t32 | t35);
    t37 = *((unsigned int *)t28);
    t38 = *((unsigned int *)t29);
    t39 = (t37 | t38);
    t40 = (~(t39));
    t41 = (t36 & t40);
    if (t41 != 0)
        goto LAB22;

LAB19:    if (t39 != 0)
        goto LAB21;

LAB20:    *((unsigned int *)t27) = 1;

LAB22:    memset(t43, 0, 8);
    t44 = (t27 + 4);
    t45 = *((unsigned int *)t44);
    t46 = (~(t45));
    t47 = *((unsigned int *)t27);
    t48 = (t47 & t46);
    t49 = (t48 & 1U);
    if (t49 != 0)
        goto LAB23;

LAB24:    if (*((unsigned int *)t44) != 0)
        goto LAB25;

LAB26:    t51 = (t43 + 4);
    t52 = *((unsigned int *)t43);
    t53 = (!(t52));
    t54 = *((unsigned int *)t51);
    t55 = (t53 || t54);
    if (t55 > 0)
        goto LAB27;

LAB28:    memcpy(t91, t43, 8);

LAB29:    t119 = (t91 + 4);
    t120 = *((unsigned int *)t119);
    t121 = (~(t120));
    t122 = *((unsigned int *)t91);
    t123 = (t122 & t121);
    t124 = (t123 != 0);
    if (t124 > 0)
        goto LAB41;

LAB42:    xsi_set_current_line(31, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2680);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 2, 0LL);

LAB43:    goto LAB17;

LAB13:    xsi_set_current_line(34, ng0);

LAB47:    xsi_set_current_line(35, ng0);
    t3 = (t0 + 1640U);
    t4 = *((char **)t3);
    t3 = (t0 + 2840);
    t5 = (t0 + 2840);
    t11 = (t5 + 72U);
    t12 = *((char **)t11);
    t14 = (t0 + 2840);
    t17 = (t14 + 64U);
    t18 = *((char **)t17);
    t19 = ((char*)((ng4)));
    xsi_vlog_generic_convert_array_indices(t16, t27, t12, t18, 2, 1, t19, 32, 1);
    t26 = (t16 + 4);
    t6 = *((unsigned int *)t26);
    t110 = (!(t6));
    t28 = (t27 + 4);
    t7 = *((unsigned int *)t28);
    t114 = (!(t7));
    t138 = (t110 && t114);
    if (t138 == 1)
        goto LAB48;

LAB49:    xsi_set_current_line(36, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 2680);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 2, 0LL);
    goto LAB17;

LAB15:    xsi_set_current_line(39, ng0);

LAB50:    xsi_set_current_line(40, ng0);
    t3 = (t0 + 1640U);
    t4 = *((char **)t3);
    t3 = (t0 + 2840);
    t5 = (t3 + 56U);
    t11 = *((char **)t5);
    t12 = (t0 + 2840);
    t14 = (t12 + 72U);
    t17 = *((char **)t14);
    t18 = (t0 + 2840);
    t19 = (t18 + 64U);
    t26 = *((char **)t19);
    t28 = ((char*)((ng4)));
    xsi_vlog_generic_get_array_select_value(t27, 8, t11, t17, t26, 2, 1, t28, 32, 1);
    t29 = (t0 + 2840);
    t42 = (t29 + 56U);
    t44 = *((char **)t42);
    t50 = (t0 + 2840);
    t51 = (t50 + 72U);
    t57 = *((char **)t51);
    t58 = (t0 + 2840);
    t59 = (t58 + 64U);
    t66 = *((char **)t59);
    t68 = ((char*)((ng1)));
    xsi_vlog_generic_get_array_select_value(t43, 8, t44, t57, t66, 2, 1, t68, 32, 1);
    xsi_vlogtype_concat(t16, 24, 24, 3U, t43, 8, t27, 8, t4, 8);
    t69 = (t0 + 2040);
    xsi_vlogvar_wait_assign_value(t69, t16, 0, 0, 24, 0LL);
    xsi_set_current_line(41, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 2200);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(42, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2680);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 2, 0LL);
    goto LAB17;

LAB21:    t42 = (t27 + 4);
    *((unsigned int *)t27) = 1;
    *((unsigned int *)t42) = 1;
    goto LAB22;

LAB23:    *((unsigned int *)t43) = 1;
    goto LAB26;

LAB25:    t50 = (t43 + 4);
    *((unsigned int *)t43) = 1;
    *((unsigned int *)t50) = 1;
    goto LAB26;

LAB27:    t57 = (t0 + 1640U);
    t58 = *((char **)t57);
    memset(t56, 0, 8);
    t57 = (t56 + 4);
    t59 = (t58 + 4);
    t60 = *((unsigned int *)t58);
    t61 = (t60 >> 0);
    *((unsigned int *)t56) = t61;
    t62 = *((unsigned int *)t59);
    t63 = (t62 >> 0);
    *((unsigned int *)t57) = t63;
    t64 = *((unsigned int *)t56);
    *((unsigned int *)t56) = (t64 & 31U);
    t65 = *((unsigned int *)t57);
    *((unsigned int *)t57) = (t65 & 31U);
    t66 = ((char*)((ng3)));
    memset(t67, 0, 8);
    t68 = (t56 + 4);
    t69 = (t66 + 4);
    t70 = *((unsigned int *)t56);
    t71 = *((unsigned int *)t66);
    t72 = (t70 ^ t71);
    t73 = *((unsigned int *)t68);
    t74 = *((unsigned int *)t69);
    t75 = (t73 ^ t74);
    t76 = (t72 | t75);
    t77 = *((unsigned int *)t68);
    t78 = *((unsigned int *)t69);
    t79 = (t77 | t78);
    t80 = (~(t79));
    t81 = (t76 & t80);
    if (t81 != 0)
        goto LAB33;

LAB30:    if (t79 != 0)
        goto LAB32;

LAB31:    *((unsigned int *)t67) = 1;

LAB33:    memset(t83, 0, 8);
    t84 = (t67 + 4);
    t85 = *((unsigned int *)t84);
    t86 = (~(t85));
    t87 = *((unsigned int *)t67);
    t88 = (t87 & t86);
    t89 = (t88 & 1U);
    if (t89 != 0)
        goto LAB34;

LAB35:    if (*((unsigned int *)t84) != 0)
        goto LAB36;

LAB37:    t92 = *((unsigned int *)t43);
    t93 = *((unsigned int *)t83);
    t94 = (t92 | t93);
    *((unsigned int *)t91) = t94;
    t95 = (t43 + 4);
    t96 = (t83 + 4);
    t97 = (t91 + 4);
    t98 = *((unsigned int *)t95);
    t99 = *((unsigned int *)t96);
    t100 = (t98 | t99);
    *((unsigned int *)t97) = t100;
    t101 = *((unsigned int *)t97);
    t102 = (t101 != 0);
    if (t102 == 1)
        goto LAB38;

LAB39:
LAB40:    goto LAB29;

LAB32:    t82 = (t67 + 4);
    *((unsigned int *)t67) = 1;
    *((unsigned int *)t82) = 1;
    goto LAB33;

LAB34:    *((unsigned int *)t83) = 1;
    goto LAB37;

LAB36:    t90 = (t83 + 4);
    *((unsigned int *)t83) = 1;
    *((unsigned int *)t90) = 1;
    goto LAB37;

LAB38:    t103 = *((unsigned int *)t91);
    t104 = *((unsigned int *)t97);
    *((unsigned int *)t91) = (t103 | t104);
    t105 = (t43 + 4);
    t106 = (t83 + 4);
    t107 = *((unsigned int *)t105);
    t108 = (~(t107));
    t109 = *((unsigned int *)t43);
    t110 = (t109 & t108);
    t111 = *((unsigned int *)t106);
    t112 = (~(t111));
    t113 = *((unsigned int *)t83);
    t114 = (t113 & t112);
    t115 = (~(t110));
    t116 = (~(t114));
    t117 = *((unsigned int *)t97);
    *((unsigned int *)t97) = (t117 & t115);
    t118 = *((unsigned int *)t97);
    *((unsigned int *)t97) = (t118 & t116);
    goto LAB40;

LAB41:    xsi_set_current_line(26, ng0);

LAB44:    xsi_set_current_line(27, ng0);
    t125 = (t0 + 1640U);
    t126 = *((char **)t125);
    t125 = (t0 + 2840);
    t129 = (t0 + 2840);
    t130 = (t129 + 72U);
    t131 = *((char **)t130);
    t132 = (t0 + 2840);
    t133 = (t132 + 64U);
    t134 = *((char **)t133);
    t135 = ((char*)((ng1)));
    xsi_vlog_generic_convert_array_indices(t127, t128, t131, t134, 2, 1, t135, 32, 1);
    t136 = (t127 + 4);
    t137 = *((unsigned int *)t136);
    t138 = (!(t137));
    t139 = (t128 + 4);
    t140 = *((unsigned int *)t139);
    t141 = (!(t140));
    t142 = (t138 && t141);
    if (t142 == 1)
        goto LAB45;

LAB46:    xsi_set_current_line(28, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 2680);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 2, 0LL);
    goto LAB43;

LAB45:    t143 = *((unsigned int *)t127);
    t144 = *((unsigned int *)t128);
    t145 = (t143 - t144);
    t146 = (t145 + 1);
    xsi_vlogvar_wait_assign_value(t125, t126, 0, *((unsigned int *)t128), t146, 0LL);
    goto LAB46;

LAB48:    t8 = *((unsigned int *)t16);
    t9 = *((unsigned int *)t27);
    t141 = (t8 - t9);
    t142 = (t141 + 1);
    xsi_vlogvar_wait_assign_value(t3, t4, 0, *((unsigned int *)t27), t142, 0LL);
    goto LAB49;

LAB51:    *((unsigned int *)t16) = 1;
    goto LAB54;

LAB53:    t11 = (t16 + 4);
    *((unsigned int *)t16) = 1;
    *((unsigned int *)t11) = 1;
    goto LAB54;

LAB55:    t14 = (t0 + 2680);
    t17 = (t14 + 56U);
    t18 = *((char **)t17);
    t19 = ((char*)((ng1)));
    memset(t27, 0, 8);
    t26 = (t18 + 4);
    t28 = (t19 + 4);
    t23 = *((unsigned int *)t18);
    t24 = *((unsigned int *)t19);
    t25 = (t23 ^ t24);
    t30 = *((unsigned int *)t26);
    t31 = *((unsigned int *)t28);
    t32 = (t30 ^ t31);
    t33 = (t25 | t32);
    t34 = *((unsigned int *)t26);
    t35 = *((unsigned int *)t28);
    t36 = (t34 | t35);
    t37 = (~(t36));
    t38 = (t33 & t37);
    if (t38 != 0)
        goto LAB59;

LAB58:    if (t36 != 0)
        goto LAB60;

LAB61:    memset(t43, 0, 8);
    t42 = (t27 + 4);
    t39 = *((unsigned int *)t42);
    t40 = (~(t39));
    t41 = *((unsigned int *)t27);
    t45 = (t41 & t40);
    t46 = (t45 & 1U);
    if (t46 != 0)
        goto LAB62;

LAB63:    if (*((unsigned int *)t42) != 0)
        goto LAB64;

LAB65:    t47 = *((unsigned int *)t16);
    t48 = *((unsigned int *)t43);
    t49 = (t47 & t48);
    *((unsigned int *)t56) = t49;
    t50 = (t16 + 4);
    t51 = (t43 + 4);
    t57 = (t56 + 4);
    t52 = *((unsigned int *)t50);
    t53 = *((unsigned int *)t51);
    t54 = (t52 | t53);
    *((unsigned int *)t57) = t54;
    t55 = *((unsigned int *)t57);
    t60 = (t55 != 0);
    if (t60 == 1)
        goto LAB66;

LAB67:
LAB68:    goto LAB57;

LAB59:    *((unsigned int *)t27) = 1;
    goto LAB61;

LAB60:    t29 = (t27 + 4);
    *((unsigned int *)t27) = 1;
    *((unsigned int *)t29) = 1;
    goto LAB61;

LAB62:    *((unsigned int *)t43) = 1;
    goto LAB65;

LAB64:    t44 = (t43 + 4);
    *((unsigned int *)t43) = 1;
    *((unsigned int *)t44) = 1;
    goto LAB65;

LAB66:    t61 = *((unsigned int *)t56);
    t62 = *((unsigned int *)t57);
    *((unsigned int *)t56) = (t61 | t62);
    t58 = (t16 + 4);
    t59 = (t43 + 4);
    t63 = *((unsigned int *)t16);
    t64 = (~(t63));
    t65 = *((unsigned int *)t58);
    t70 = (~(t65));
    t71 = *((unsigned int *)t43);
    t72 = (~(t71));
    t73 = *((unsigned int *)t59);
    t74 = (~(t73));
    t15 = (t64 & t70);
    t110 = (t72 & t74);
    t75 = (~(t15));
    t76 = (~(t110));
    t77 = *((unsigned int *)t57);
    *((unsigned int *)t57) = (t77 & t75);
    t78 = *((unsigned int *)t57);
    *((unsigned int *)t57) = (t78 & t76);
    t79 = *((unsigned int *)t56);
    *((unsigned int *)t56) = (t79 & t75);
    t80 = *((unsigned int *)t56);
    *((unsigned int *)t56) = (t80 & t76);
    goto LAB68;

LAB69:    xsi_set_current_line(50, ng0);
    t68 = ((char*)((ng1)));
    t69 = (t0 + 2680);
    xsi_vlogvar_wait_assign_value(t69, t68, 0, 0, 2, 0LL);
    goto LAB71;

}

static void Always_53_1(char *t0)
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

LAB0:    t1 = (t0 + 4008U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(53, ng0);
    t2 = (t0 + 4344);
    *((int *)t2) = 1;
    t3 = (t0 + 4040);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(54, ng0);

LAB5:    xsi_set_current_line(55, ng0);
    t4 = (t0 + 1480U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(60, ng0);
    t2 = (t0 + 2520);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 608);
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

LAB15:    xsi_set_current_line(63, ng0);
    t2 = (t0 + 2520);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng4)));
    memset(t13, 0, 8);
    xsi_vlog_unsigned_add(t13, 32, t4, 16, t5, 32);
    t11 = (t0 + 2520);
    xsi_vlogvar_wait_assign_value(t11, t13, 0, 0, 16, 0LL);

LAB16:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(56, ng0);

LAB9:    xsi_set_current_line(57, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2360);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 1, 0LL);
    xsi_set_current_line(58, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2520);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 16, 0LL);
    goto LAB8;

LAB12:    t21 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB13;

LAB14:    xsi_set_current_line(61, ng0);
    t28 = ((char*)((ng4)));
    t29 = (t0 + 2360);
    xsi_vlogvar_wait_assign_value(t29, t28, 0, 0, 1, 0LL);
    goto LAB16;

}


extern void work_m_00000000000594579566_0292583109_init()
{
	static char *pe[] = {(void *)Always_18_0,(void *)Always_53_1};
	xsi_register_didat("work_m_00000000000594579566_0292583109", "isim/tb_top_isim_beh.exe.sim/work/m_00000000000594579566_0292583109.didat");
	xsi_register_executes(pe);
}
