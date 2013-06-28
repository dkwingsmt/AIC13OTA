* EE214 Design Project
* Testbench

.include utils.sp
.include project.sp

*.lib 'ee214_hspice.txt' nominal

* slow corner
.lib 'ee214_hspice_slowfast.txt' slow
.temp 125

* fast corner
*.lib 'ee214_hspice_slowfast.txt' fast
*.temp 0

******************************************************
*Circuit description
******************************************************
vdd vdd  0   3
vsc vsc  0   'input_common'

cl1 vop  0  'cl'
cl2 vom  0  'cl'
cs1 vsp yp  'cs'
cs2 vsm ym  'cs'
rs1 vsp yp  10gig
rs2 vsm ym  10gig
cf1 yp  vom '0.5*cs'
cf2 ym  vop '0.5*cs'

x1  xp xm vopp vomm vdd ota
vmp vopp vop 0
vmm vomm vom 0

xd  vsp vsm vsd vsc diffdrive
xs  vod voc vop vom diffsense
xt  xp  xm  yp  ym  difflooptest ai='ai' av='av'
.param ai=1 av=0

******************************************************
*Stimulus and analyses (uncomment respective statements)
******************************************************
.options post brief
.options runlvl=6

.op








* dc
vsd vsd  0  0
.dc vsd -10.005m 10m 10u
 

.end

