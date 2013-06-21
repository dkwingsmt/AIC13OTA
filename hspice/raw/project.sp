* EE214 Design Project
* Sun Zelei, Lv Ruochen, Mu Tong

.include params.sp

******************************************************
*Test parameters (will be used by testbench ota_test.sp
******************************************************

* input common mode
.param input_common=0.9

* differential input voltage step
.include 'input_diff.sp'
******************************************************


******************************************************
*Circuit description
******************************************************

.param kla=1.5
.subckt ota vip vim vop vom vdd

*param

*main amplifier
M0  vp  vg_cm 0   0    nch214                       l='ln' w='w0*1.6'
M1  vx  vim   vp  0    nch214                       l='ln' w='w1'
M2  vy  vip   vp  0    nch214                       l='ln' w='w2'
M1a vop vbb2  vx  0    nch214                       l='ln*1.5' w='w1a*1.5'
M2a vom vbb2  vy  0    nch214                       l='ln*1.5' w='w2a*1.5'
M3a vop vbb1  vm  vdd  pch214                       l='lp*1.5' w='w3a*kla'
M4a vom vbb1  vn  vdd  pch214                       l='lp*1.5' w='w4a*kla'
M3  vm  vbias vdd vdd  pch214                       l='lp' w='w3'
M4  vn  vbias vdd vdd  pch214                       l='lp' w='w4'

*vbb1
M5a vbb1_mid vbb1   vdd      vdd      pch214        l='lp' w='w5a'
M5b vbb1     vbb1   vbb1_mid vdd      pch214        l='lp' w='w5b'
M5c vbb1     vg_cm  0        0        nch214        l='ln' w='w5c'

*vbb2
M6a vbb2_up   vbias vdd       vdd        pch214     l='lp' w='w6a'
M6b vbb2      vbb1  vbb2_up   vdd        pch214     l='lp' w='w6b'
M6c vbb2      vbb2  vbb2_down 0          nch214     l='ln' w='w6c'
M6d vbb2_down vbb2  vp        0          nch214     l='ln' w='w6d'

*vbias
M7a vbias_mid vbias  vdd       vdd       pch214     l='lp' w='w7a'
M7b vbias     vbb1   vbias_mid vdd       pch214     l='lp' w='w7b'
M7c vbias     vg_cm  0         0         nch214     l='ln' w='w7c'

*current mirror
Ib  vdd   vg_cm 'ib'
Mb  vg_cm vg_cm 0  0  nch214                        l='ln' w='wb'

*cmfb
x1 vid voc vop vom diffsense
vcom vocdes 0 1.5
g1 vp 0 voc vocdes 10m
.ends ota
