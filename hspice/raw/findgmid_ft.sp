.title Derive gmid--ft
.option list node 
.option post
.option dccap
.lib "ee214_hspice.txt" nominal

.param wm=0.35u
.param vgs=1

vdn     dn  0   dc  3
vgn     gn  0   dc  'vgs'
mn      dn  gn  0   0   nch214  w='wm'  l=0.42u 

vdp     dp  0   dc  -3
vgp     gp  0   dc  '-vgs'
mp      dp  gp  0   0   pch214  w='wm'  l=0.61u 

.op
.dc vgs 0.1 3 0.01

.probe gm_idn   = par('gmo(mn)/i(mn)')
.probe ftn      = par('1/2/3.142*gmo(mn)/(cggbo(mn))')
.probe gm_idp   = par('-gmo(mp)/i(mp)')
.probe ftp      = par('1/2/3.142*gmo(mp)/cggbo(mp)')

.end
