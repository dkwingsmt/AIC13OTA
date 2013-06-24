.title Derivate the gm--L relationship
.option list node 
.option post
.lib "ee214_hspice.txt" nominal

.param L=0.35u
.param f_low=1
.param dcl=1
.param ddcl='-dcl'
*vdrefn  vdrefn  0   dc  3
*linftyn vdrefn  dn  l=100g
vdn     dn 0   dc=dcl
vgn     gn  0   dc  'vth(mn)+0.2'   ac 0.1
mn      dn  gn  0   0   nch214  w=1u   l='L'

*vdrefp  vdrefp  0   dc  -3
*linftyp vdrefp  dp  l=100g
vdp     dp 0   dc=ddcl
vgp     gp  0   dc  '-vth(mp)-0.2'   ac 0.1
mp      dp  gp  0   0   pch214  w=1u   l='L'

.op
.dc dcl poi 1 1v sweep L lin 100 0.3u 1.0u 
.probe dc gmron = par('lx7(mn)/lx8(mn)')
.probe dc gmrop = par('lx7(mp)/lx8(mp)')

.end
