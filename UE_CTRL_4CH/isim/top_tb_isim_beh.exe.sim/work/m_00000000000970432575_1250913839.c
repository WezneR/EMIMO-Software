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
static const char *ng0 = "F:/ISE/UE_CTRL_4CH/srcs/UART_Listener.v";
static int ng1[] = {0, 0};
static int ng2[] = {6, 0};
static int ng3[] = {79, 0};
static int ng4[] = {16, 0};
static unsigned int ng5[] = {21853U, 0U};
static int ng6[] = {63, 0};
static int ng7[] = {32, 0};



static void Always_20_0(char *t0)
{
    char t4[8];
    char t21[8];
    char t26[8];
    char t34[8];
    char t75[8];
    char t87[8];
    char t95[8];
    char t111[8];
    char t119[8];
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
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    char *t25;
    char *t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    char *t33;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    char *t38;
    char *t39;
    char *t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    char *t48;
    char *t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    int t58;
    int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    char *t66;
    char *t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    char *t76;
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
    char *t88;
    char *t89;
    char *t90;
    char *t91;
    char *t92;
    char *t93;
    char *t94;
    char *t96;
    char *t97;
    unsigned int t98;
    unsigned int t99;
    unsigned int t100;
    unsigned int t101;
    unsigned int t102;
    unsigned int t103;
    unsigned int t104;
    unsigned int t105;
    unsigned int t106;
    unsigned int t107;
    unsigned int t108;
    unsigned int t109;
    char *t110;
    char *t112;
    unsigned int t113;
    unsigned int t114;
    unsigned int t115;
    unsigned int t116;
    unsigned int t117;
    char *t118;
    unsigned int t120;
    unsigned int t121;
    unsigned int t122;
    char *t123;
    char *t124;
    char *t125;
    unsigned int t126;
    unsigned int t127;
    unsigned int t128;
    unsigned int t129;
    unsigned int t130;
    unsigned int t131;
    unsigned int t132;
    char *t133;
    char *t134;
    unsigned int t135;
    unsigned int t136;
    unsigned int t137;
    unsigned int t138;
    unsigned int t139;
    unsigned int t140;
    unsigned int t141;
    unsigned int t142;
    int t143;
    int t144;
    unsigned int t145;
    unsigned int t146;
    unsigned int t147;
    unsigned int t148;
    unsigned int t149;
    unsigned int t150;
    char *t151;

LAB0:    t1 = (t0 + 3784U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(20, ng0);
    t2 = (t0 + 4104);
    *((int *)t2) = 1;
    t3 = (t0 + 3816);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(20, ng0);

LAB5:    xsi_set_current_line(21, ng0);
    t5 = (t0 + 1344U);
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

LAB11:    xsi_set_current_line(27, ng0);

LAB14:    xsi_set_current_line(29, ng0);
    t2 = (t0 + 1504U);
    t3 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t3 + 4);
    t7 = *((unsigned int *)t2);
    t8 = (~(t7));
    t9 = *((unsigned int *)t3);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB15;

LAB16:    if (*((unsigned int *)t2) != 0)
        goto LAB17;

LAB18:    t6 = (t4 + 4);
    t14 = *((unsigned int *)t4);
    t15 = *((unsigned int *)t6);
    t16 = (t14 || t15);
    if (t16 > 0)
        goto LAB19;

LAB20:    memcpy(t34, t4, 8);

LAB21:    t66 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t66, t34, 0, 0, 1, 0LL);
    xsi_set_current_line(30, ng0);
    t2 = (t0 + 2704);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t4, 0, 8);
    t6 = (t5 + 4);
    t7 = *((unsigned int *)t6);
    t8 = (~(t7));
    t9 = *((unsigned int *)t5);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB33;

LAB34:    if (*((unsigned int *)t6) != 0)
        goto LAB35;

LAB36:    t13 = (t4 + 4);
    t14 = *((unsigned int *)t4);
    t15 = *((unsigned int *)t13);
    t16 = (t14 || t15);
    if (t16 > 0)
        goto LAB37;

LAB38:    memcpy(t34, t4, 8);

LAB39:    memset(t75, 0, 8);
    t76 = (t34 + 4);
    t77 = *((unsigned int *)t76);
    t78 = (~(t77));
    t79 = *((unsigned int *)t34);
    t80 = (t79 & t78);
    t81 = (t80 & 1U);
    if (t81 != 0)
        goto LAB51;

LAB52:    if (*((unsigned int *)t76) != 0)
        goto LAB53;

LAB54:    t83 = (t75 + 4);
    t84 = *((unsigned int *)t75);
    t85 = *((unsigned int *)t83);
    t86 = (t84 || t85);
    if (t86 > 0)
        goto LAB55;

LAB56:    memcpy(t119, t75, 8);

LAB57:    t151 = (t0 + 2864);
    xsi_vlogvar_wait_assign_value(t151, t119, 0, 0, 1, 0LL);
    xsi_set_current_line(33, ng0);
    t2 = (t0 + 2864);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t5 + 4);
    t7 = *((unsigned int *)t6);
    t8 = (~(t7));
    t9 = *((unsigned int *)t5);
    t10 = (t9 & t8);
    t11 = (t10 != 0);
    if (t11 > 0)
        goto LAB69;

LAB70:
LAB71:    xsi_set_current_line(37, ng0);
    t2 = (t0 + 2704);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 2224);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 1, 0LL);
    xsi_set_current_line(38, ng0);
    t2 = (t0 + 2864);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 2384);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 1, 0LL);

LAB12:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB10:    xsi_set_current_line(21, ng0);

LAB13:    xsi_set_current_line(22, ng0);
    t19 = ((char*)((ng1)));
    t20 = (t0 + 2224);
    xsi_vlogvar_wait_assign_value(t20, t19, 0, 0, 1, 0LL);
    xsi_set_current_line(23, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2384);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(24, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 32, 0LL);
    xsi_set_current_line(25, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2704);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(26, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2864);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB12;

LAB15:    *((unsigned int *)t4) = 1;
    goto LAB18;

LAB17:    t5 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t5) = 1;
    goto LAB18;

LAB19:    t12 = (t0 + 2704);
    t13 = (t12 + 56U);
    t19 = *((char **)t13);
    memset(t21, 0, 8);
    t20 = (t19 + 4);
    t17 = *((unsigned int *)t20);
    t18 = (~(t17));
    t22 = *((unsigned int *)t19);
    t23 = (t22 & t18);
    t24 = (t23 & 1U);
    if (t24 != 0)
        goto LAB25;

LAB23:    if (*((unsigned int *)t20) == 0)
        goto LAB22;

LAB24:    t25 = (t21 + 4);
    *((unsigned int *)t21) = 1;
    *((unsigned int *)t25) = 1;

LAB25:    memset(t26, 0, 8);
    t27 = (t21 + 4);
    t28 = *((unsigned int *)t27);
    t29 = (~(t28));
    t30 = *((unsigned int *)t21);
    t31 = (t30 & t29);
    t32 = (t31 & 1U);
    if (t32 != 0)
        goto LAB26;

LAB27:    if (*((unsigned int *)t27) != 0)
        goto LAB28;

LAB29:    t35 = *((unsigned int *)t4);
    t36 = *((unsigned int *)t26);
    t37 = (t35 & t36);
    *((unsigned int *)t34) = t37;
    t38 = (t4 + 4);
    t39 = (t26 + 4);
    t40 = (t34 + 4);
    t41 = *((unsigned int *)t38);
    t42 = *((unsigned int *)t39);
    t43 = (t41 | t42);
    *((unsigned int *)t40) = t43;
    t44 = *((unsigned int *)t40);
    t45 = (t44 != 0);
    if (t45 == 1)
        goto LAB30;

LAB31:
LAB32:    goto LAB21;

LAB22:    *((unsigned int *)t21) = 1;
    goto LAB25;

LAB26:    *((unsigned int *)t26) = 1;
    goto LAB29;

LAB28:    t33 = (t26 + 4);
    *((unsigned int *)t26) = 1;
    *((unsigned int *)t33) = 1;
    goto LAB29;

LAB30:    t46 = *((unsigned int *)t34);
    t47 = *((unsigned int *)t40);
    *((unsigned int *)t34) = (t46 | t47);
    t48 = (t4 + 4);
    t49 = (t26 + 4);
    t50 = *((unsigned int *)t4);
    t51 = (~(t50));
    t52 = *((unsigned int *)t48);
    t53 = (~(t52));
    t54 = *((unsigned int *)t26);
    t55 = (~(t54));
    t56 = *((unsigned int *)t49);
    t57 = (~(t56));
    t58 = (t51 & t53);
    t59 = (t55 & t57);
    t60 = (~(t58));
    t61 = (~(t59));
    t62 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t62 & t60);
    t63 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t63 & t61);
    t64 = *((unsigned int *)t34);
    *((unsigned int *)t34) = (t64 & t60);
    t65 = *((unsigned int *)t34);
    *((unsigned int *)t34) = (t65 & t61);
    goto LAB32;

LAB33:    *((unsigned int *)t4) = 1;
    goto LAB36;

LAB35:    t12 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t12) = 1;
    goto LAB36;

LAB37:    t19 = (t0 + 1664U);
    t20 = *((char **)t19);
    t19 = ((char*)((ng2)));
    memset(t21, 0, 8);
    t25 = (t20 + 4);
    t27 = (t19 + 4);
    t17 = *((unsigned int *)t20);
    t18 = *((unsigned int *)t19);
    t22 = (t17 ^ t18);
    t23 = *((unsigned int *)t25);
    t24 = *((unsigned int *)t27);
    t28 = (t23 ^ t24);
    t29 = (t22 | t28);
    t30 = *((unsigned int *)t25);
    t31 = *((unsigned int *)t27);
    t32 = (t30 | t31);
    t35 = (~(t32));
    t36 = (t29 & t35);
    if (t36 != 0)
        goto LAB43;

LAB40:    if (t32 != 0)
        goto LAB42;

LAB41:    *((unsigned int *)t21) = 1;

LAB43:    memset(t26, 0, 8);
    t38 = (t21 + 4);
    t37 = *((unsigned int *)t38);
    t41 = (~(t37));
    t42 = *((unsigned int *)t21);
    t43 = (t42 & t41);
    t44 = (t43 & 1U);
    if (t44 != 0)
        goto LAB44;

LAB45:    if (*((unsigned int *)t38) != 0)
        goto LAB46;

LAB47:    t45 = *((unsigned int *)t4);
    t46 = *((unsigned int *)t26);
    t47 = (t45 & t46);
    *((unsigned int *)t34) = t47;
    t40 = (t4 + 4);
    t48 = (t26 + 4);
    t49 = (t34 + 4);
    t50 = *((unsigned int *)t40);
    t51 = *((unsigned int *)t48);
    t52 = (t50 | t51);
    *((unsigned int *)t49) = t52;
    t53 = *((unsigned int *)t49);
    t54 = (t53 != 0);
    if (t54 == 1)
        goto LAB48;

LAB49:
LAB50:    goto LAB39;

LAB42:    t33 = (t21 + 4);
    *((unsigned int *)t21) = 1;
    *((unsigned int *)t33) = 1;
    goto LAB43;

LAB44:    *((unsigned int *)t26) = 1;
    goto LAB47;

LAB46:    t39 = (t26 + 4);
    *((unsigned int *)t26) = 1;
    *((unsigned int *)t39) = 1;
    goto LAB47;

LAB48:    t55 = *((unsigned int *)t34);
    t56 = *((unsigned int *)t49);
    *((unsigned int *)t34) = (t55 | t56);
    t66 = (t4 + 4);
    t67 = (t26 + 4);
    t57 = *((unsigned int *)t4);
    t60 = (~(t57));
    t61 = *((unsigned int *)t66);
    t62 = (~(t61));
    t63 = *((unsigned int *)t26);
    t64 = (~(t63));
    t65 = *((unsigned int *)t67);
    t68 = (~(t65));
    t58 = (t60 & t62);
    t59 = (t64 & t68);
    t69 = (~(t58));
    t70 = (~(t59));
    t71 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t71 & t69);
    t72 = *((unsigned int *)t49);
    *((unsigned int *)t49) = (t72 & t70);
    t73 = *((unsigned int *)t34);
    *((unsigned int *)t34) = (t73 & t69);
    t74 = *((unsigned int *)t34);
    *((unsigned int *)t34) = (t74 & t70);
    goto LAB50;

LAB51:    *((unsigned int *)t75) = 1;
    goto LAB54;

LAB53:    t82 = (t75 + 4);
    *((unsigned int *)t75) = 1;
    *((unsigned int *)t82) = 1;
    goto LAB54;

LAB55:    t88 = (t0 + 1824U);
    t89 = *((char **)t88);
    t88 = (t0 + 1784U);
    t90 = (t88 + 72U);
    t91 = *((char **)t90);
    t92 = ((char*)((ng3)));
    t93 = ((char*)((ng4)));
    xsi_vlog_get_indexed_partselect(t87, 16, t89, ((int*)(t91)), 2, t92, 32, 1, t93, 32, 1, 0);
    t94 = ((char*)((ng5)));
    memset(t95, 0, 8);
    t96 = (t87 + 4);
    t97 = (t94 + 4);
    t98 = *((unsigned int *)t87);
    t99 = *((unsigned int *)t94);
    t100 = (t98 ^ t99);
    t101 = *((unsigned int *)t96);
    t102 = *((unsigned int *)t97);
    t103 = (t101 ^ t102);
    t104 = (t100 | t103);
    t105 = *((unsigned int *)t96);
    t106 = *((unsigned int *)t97);
    t107 = (t105 | t106);
    t108 = (~(t107));
    t109 = (t104 & t108);
    if (t109 != 0)
        goto LAB61;

LAB58:    if (t107 != 0)
        goto LAB60;

LAB59:    *((unsigned int *)t95) = 1;

LAB61:    memset(t111, 0, 8);
    t112 = (t95 + 4);
    t113 = *((unsigned int *)t112);
    t114 = (~(t113));
    t115 = *((unsigned int *)t95);
    t116 = (t115 & t114);
    t117 = (t116 & 1U);
    if (t117 != 0)
        goto LAB62;

LAB63:    if (*((unsigned int *)t112) != 0)
        goto LAB64;

LAB65:    t120 = *((unsigned int *)t75);
    t121 = *((unsigned int *)t111);
    t122 = (t120 & t121);
    *((unsigned int *)t119) = t122;
    t123 = (t75 + 4);
    t124 = (t111 + 4);
    t125 = (t119 + 4);
    t126 = *((unsigned int *)t123);
    t127 = *((unsigned int *)t124);
    t128 = (t126 | t127);
    *((unsigned int *)t125) = t128;
    t129 = *((unsigned int *)t125);
    t130 = (t129 != 0);
    if (t130 == 1)
        goto LAB66;

LAB67:
LAB68:    goto LAB57;

LAB60:    t110 = (t95 + 4);
    *((unsigned int *)t95) = 1;
    *((unsigned int *)t110) = 1;
    goto LAB61;

LAB62:    *((unsigned int *)t111) = 1;
    goto LAB65;

LAB64:    t118 = (t111 + 4);
    *((unsigned int *)t111) = 1;
    *((unsigned int *)t118) = 1;
    goto LAB65;

LAB66:    t131 = *((unsigned int *)t119);
    t132 = *((unsigned int *)t125);
    *((unsigned int *)t119) = (t131 | t132);
    t133 = (t75 + 4);
    t134 = (t111 + 4);
    t135 = *((unsigned int *)t75);
    t136 = (~(t135));
    t137 = *((unsigned int *)t133);
    t138 = (~(t137));
    t139 = *((unsigned int *)t111);
    t140 = (~(t139));
    t141 = *((unsigned int *)t134);
    t142 = (~(t141));
    t143 = (t136 & t138);
    t144 = (t140 & t142);
    t145 = (~(t143));
    t146 = (~(t144));
    t147 = *((unsigned int *)t125);
    *((unsigned int *)t125) = (t147 & t145);
    t148 = *((unsigned int *)t125);
    *((unsigned int *)t125) = (t148 & t146);
    t149 = *((unsigned int *)t119);
    *((unsigned int *)t119) = (t149 & t145);
    t150 = *((unsigned int *)t119);
    *((unsigned int *)t119) = (t150 & t146);
    goto LAB68;

LAB69:    xsi_set_current_line(34, ng0);
    t12 = (t0 + 1824U);
    t13 = *((char **)t12);
    t12 = (t0 + 1784U);
    t19 = (t12 + 72U);
    t20 = *((char **)t19);
    t25 = ((char*)((ng6)));
    t27 = ((char*)((ng7)));
    xsi_vlog_get_indexed_partselect(t4, 32, t13, ((int*)(t20)), 2, t25, 32, 1, t27, 32, 1, 0);
    t33 = (t0 + 2544);
    xsi_vlogvar_wait_assign_value(t33, t4, 0, 0, 32, 0LL);
    goto LAB71;

}


extern void work_m_00000000000970432575_1250913839_init()
{
	static char *pe[] = {(void *)Always_20_0};
	xsi_register_didat("work_m_00000000000970432575_1250913839", "isim/top_tb_isim_beh.exe.sim/work/m_00000000000970432575_1250913839.didat");
	xsi_register_executes(pe);
}
