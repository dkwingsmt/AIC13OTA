* EE214 Design Project
* Sun Zelei, Lv Ruochen, Mu Tong

.include params.sp

******************************************************
*Test parameters (will be used by testbench ota_test.sp
******************************************************

* input common mode
.param input_common=1.1

* differential input voltage step
.include 'input_diff.sp'
******************************************************


******************************************************
*Circuit description
******************************************************

.subckt ota vip vim vop vom vdd

*param
*.param vbb1_val=1.9
*.param vbb2_val=1.3
*.param vbias_val=2.1
.param m12al=1.5
.param m12aw=1.4
.param m34al=1.5
.param m34aw=1.4
.param m34l=1.3
.param m34w=1.2
.param m12l=1.1
.param m12w=1
.param sizeba=0.8
.param sizeb1=0.8

*main amplifier
M0  vp  vg_cm 0   0    nch214                       l='ln' w='w0'
M1  vx  vim   vp  0    nch214                       l='l12' w='w1'
M2  vy  vip   vp  0    nch214                       l='l12' w='w2'
M1a vop vbb2  vx  0    nch214                       l='l1a' w='w1a'
M2a vom vbb2  vy  0    nch214                       l='l1a' w='w2a'
M3a vop vbb1  vm  vdd  pch214                       l='l3a' w='w3a'
M4a vom vbb1  vn  vdd  pch214                       l='l3a' w='w4a'
M3  vm  vbias vdd vdd  pch214                       l='l3' w='w3'
M4  vn  vbias vdd vdd  pch214                       l='l3' w='w4'

*vbb1source vbb1 0 'vbb1_val'
*vbb2source vbb2 0 'vbb2_val'
*vbiassource vbias 0 'vbias_val'

*vbb1
M5a vbb1_mid vbb1   vdd      vdd      pch214        l='lbb1p' w='w5a'
M5b vbb1     vbb1   vbb1_mid vdd      pch214        l='lbb1p' w='w5b'
M5c vbb1     vg_cm  0        0        nch214        l='ln' w='w5c'

*vbb2
M6a vbb2_up   vbias vdd       vdd        pch214     l='lbb2p1' w='w6a'
M6b vbb2      vbb1  vbb2_up   vdd        pch214     l='lbb2p2' w='w6b'
M6c vbb2      vbb2  vbb2_down 0          nch214     l='lbb2n' w='w6c'
M6d vbb2_down vbb2  vp        0          nch214     l='lbb2n' w='w6d'

*vbias
M7a vbias_mid vbias  vdd       vdd       pch214     l='lbiasp' w='w7a'
M7b vbias     vbb1   vbias_mid vdd       pch214     l='lbiasp' w='w7b'
M7c vbias     vg_cm  0         0         nch214     l='ln' w='w7c'

*current mirror
Ib  vdd   vg_cm 'ib'
Mb  vg_cm vg_cm 0  0  nch214                        l='ln' w='wb'

*cmfb
x1 vid voc vop vom diffsense
vcom vocdes 0 1.6
g1 vp 0 voc vocdes 10m
.ends ota
