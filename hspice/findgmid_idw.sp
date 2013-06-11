.title Derivate the gmid--idw relationship
.option list node 
.option post
.lib "ee214_hspice.txt" nominal

.param wm=2u
.param vgs=1
.param kl=1

vdn     dn  0   dc  3
vgn     gn  0   dc  'vgs'
mn      dn  gn  0   0   nch214  w='wm'  l='0.43u*kl'

vdp     dp  0   dc  -3
vgp     gp  0   dc  '-vgs'
mp      dp  gp  0   0   pch214  w='wm'  l='0.63u*kl'

.dc vgs 0.1 3 0.1 sweep kl 0.7 2.5 0.1

.probe gm_idn   = par('gmo(mn)/i(mn)')
.probe id_wn    = par('i(mn)/wm')
.probe gm_idp   = par('-gmo(mp)/i(mp)')
.probe id_wp    = par('-i(mp)/wm')
.probe ln       = par('l(mn)')
.probe lp       = par('l(mp)')

.end
