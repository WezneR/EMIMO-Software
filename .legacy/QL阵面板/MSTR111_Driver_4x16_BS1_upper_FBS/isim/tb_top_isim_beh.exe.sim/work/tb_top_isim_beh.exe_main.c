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

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000002991943128_2295114385_init();
    work_m_00000000000594579566_0292583109_init();
    work_m_00000000002061420875_1980515485_init();
    work_m_00000000000682537708_1712034939_init();
    work_m_00000000002223192111_1408452736_init();
    work_m_00000000001484811709_1349843420_init();
    unisims_ver_m_00000000003003270080_2649278825_init();
    work_m_00000000002636089909_1335952598_init();
    work_m_00000000000788679286_3622719947_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000000788679286_3622719947");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
