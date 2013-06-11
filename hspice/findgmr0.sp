.title Derivate the gm--L relationship
.option list node 
.option post
.lib "ee214_hspice.txt" nominal

.param L=0.35u
.param f_low=1

vdrefn  vdrefn  0   dc  3
linftyn vdrefn  dn  l=100g
vgn     gn  0   dc  'vth(mn)+0.2'   ac 0.1
mn      dn  gn  0   0   nch214  w=10u   l='L'

vdrefp  vdrefp  0   dc  -3
linftyp vdrefp  dp  l=100g
vgp     gp  0   dc  '-vth(mp)-0.2'   ac 0.1
mp      dp  gp  0   0   pch214  w=10u   l='L'

.op
.ac dec 1 f_low f_low sweep L lin 10 0.3u 0.8u
.probe dc vthp =par('vth(mp)')
.probe dc vdsp =par('v(dp)')
.probe dc vgsp =par('v(gp)')
.probe ac gmr0n =par('v(dn)/v(gn)')
.probe ac gmr0p =par('v(dp)/v(gp)')

.end
