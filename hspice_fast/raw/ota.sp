* EE214 Design Project
* Name 1: Joe Example
* Name 2: John Doe

******************************************************
*Test parameters (will be used by testbench ota_test.sp
******************************************************
* capacitor sizes
.param cs=4p
.param cl=2p

* input common mode
.param input_common=1

* differential input voltage step
.param input_diff=1
******************************************************


******************************************************
*Circuit description
******************************************************
.subckt ota vip vim vop vom vdd

ib  vdd vbn  20u

M1a v1m vip  vx  vx  pch214 W=15u  L=0.55u
M1b v1p vim  vx  vx  pch214 W=15u  L=0.55u
cna v1m vim  7.5f
cnb v1p vip  7.5f

M2a vom v1p  0   0 nch214 W=20u  L=0.4u
M2b vop v1m  0   0 nch214 W=20u  L=0.4u

M3d vbn vbn  0   0 nch214 W=2.5u  L=0.4u
M3c vbp vbn  0   0 nch214 W=2.5u  L=0.4u  M=3
M3b v1m vbn  0   0 nch214 W=2.5u  L=0.4u  M=6
M3a v1p vbn  0   0 nch214 W=2.5u  L=0.4u  M=6

M4d vbp vbp  vdd  vdd  pch214 W=5u  L=0.55u
M4c vx  vbp  vdd  vdd  pch214 W=5u  L=0.55u M=4
M4b vom vbp  vdd  vdd  pch214 W=5u  L=0.55u M=4
M4a vop vbp  vdd  vdd  pch214 W=5u  L=0.55u M=4

cca vzp v1m  120f
ccb vzm v1p  120f

.param gm2=2.1918m
rza vzp vop  '1/gm2'
rzb vzm vom  '1/gm2'

x1 vid voc vop vom diffsense
v1 vocdes 0 1.5
g1 0 vx   voc vocdes 1m

.ends
