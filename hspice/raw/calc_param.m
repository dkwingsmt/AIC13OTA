k_cg12_cs = 0.5;
vswing = 2;

T=25+273;
kb=1.38e-23;
kbT=kb*T;
PM=80;
%noise_gamma=1;
noise_gamma=2/3;    % Long channel

st_err=0.1/100;
dy_err=0.05/100;
dy_time=5e-9;
DR=87;
cs=4e-12;
cf=0.5*cs;
cg12=k_cg12_cs*cs;

%%%%% Read external files %%%%%
gmr0_struct=loadsigstruct('findgmr0.sw0');
gmr0_l=gmr0_struct.sw_l;
gmr0_p=gmr0_struct.gmrop;
gmr0_n=gmr0_struct.gmron;

gmid_ft_struct=loadsigstruct('findgmid_ft.sw0');
gmid_ft_gmidn=abs(gmid_ft_struct.gm_idn);
gmid_ft_ftn=abs(gmid_ft_struct.ftn);
%gmid_ft_gmidp=abs(gmid_ft_struct.gm_idp);
%gmid_ft_ftp=abs(gmid_ft_struct.ftp);

gmid_idw_struct=loadsigstruct('findgmid_idw.sw0');
gmid_idw_gmidn=gmid_idw_struct.gm_idn;
gmid_idw_idwn=gmid_idw_struct.id_wn;
gmid_idw_gmidp=gmid_idw_struct.gm_idp;
gmid_idw_idwp=gmid_idw_struct.id_wp;

%%%%% Calculate %%%%%
beta=cf/(cf+cs+cg12);  % P282,335
ntot=0.5*vswing^2/10^(DR/10);   %7-110

cltot=(2*kbT*noise_gamma/beta)/ntot;    %8-12
cl=cltot-(1-beta)*cf;   % Below 8-9
fprintf('C_L is %.3fpF\n', cl*1e12);
if cl < 2e-12
    fprintf('##### CL Error ####')
end

av0=1/st_err/beta;    %7-102
gmr0=sqrt(2*av0);   %7-103
%fprintf('Intrinsic gain is %.3f\n', gmr0);

ln=interp1(gmr0_n, gmr0_l, gmr0);
lp=interp1(gmr0_p, gmr0_l, gmr0);
%fprintf('Length of NMOS is %.3fum\n', ln*1e6);
%fprintf('Length of PMOS is %.3fum\n', lp*1e6);

dy_tau=dy_time/log(1/dy_err);
omega_c=1/dy_tau;
gm1=omega_c/beta*cltot;    %8-10
ft1=gm1/2/pi/cg12;
% TODO: plug in lp ln
gmid1=interp1(gmid_ft_ftn, gmid_ft_gmidn, ft1);
fprintf('Transconductance efficiency of M1,2 is %.3f/V\n', gmid1);
id12=gm1/gmid1;
fprintf('I_D1,2 is %.3fA\n', id12);
% TODO: plug in ln
idw12=interp1(gmid_idw_gmidn, gmid_idw_idwn, gmid1);
w12=id12/idw12;
%fprintf('W1,2 is %.3fum\n', w12);

% M1A
p2=omega_c/tan((90-PM)/180*pi);
ft1a=p2/2/pi*1.5*3;   % 1.3=cgtot/cgs|any_mos
gmid1a=interp1(gmid_ft_ftn, gmid_ft_gmidn, ft1a);
%fprintf('Transconductance efficiency of M1a is %.3f/V\n', gmid1a);
idw1a=interp1(gmid_idw_gmidn, gmid_idw_idwn, gmid1a);
w1a=id12/idw1a;       % id1a = id12
%fprintf('W1a is %.3fum\n', w1a);

% Current source load MOS
vov3=0.2;
gmid3=2/vov3;
gm3=gmid3*id12;       % id3 = id12
idw3=interp1(gmid_idw_gmidp, gmid_idw_idwp, gmid3);
w3=id12/idw3;       % id3 = id12
%fprintf('W3 is %.3fum\n', w3);


m12al=1.6;
m12aw=2;
m34al=1.4;
m34aw=1.2;
m12l=1;
m12w=1;
m34l=1;
m34w=1.2;

w12=w12*m12w;
l12=ln*m12l;
w1a=w1a*m12aw;
l1a=ln*m12al;
w3a=w3*m34aw;
l3a=lp*m34al;
w3=w3*m34w;
l3=lp*m34w;
lbb1p=lp*m34al;
lbiasp=lp*m34l;
lbb2p1=lp*m34l;
lbb2p2=lp*m34al;
lbb2n=ln*m12al;


%Ratio
k_0_b=20;
k_5_b=1;
k_7_b=1;
k_6_1=0.1;
k_5b_5a=1/5;

k_1_b=k_0_b/(k_6_1+2);


% Tail MOS
id0=id12/k_1_b*k_0_b    % And gm0=gm3...
gmid0=gmid3;
idw0=interp1(gmid_idw_gmidn, gmid_idw_idwn, gmid0);
w0=id0/idw0;
wb=w0/k_0_b;
w7c=wb*k_7_b;
w5c=wb*k_5_b;

w5b=w3a*k_5_b/k_1_b;       % I3 = I1
w7a=w3*k_7_b/k_1_b;
w6a=w3*k_6_1;
w5a=w5b/5;
w7b=w7a;
w6b=w3a*k_6_1;

w6c=w1a*k_6_1;
w6d=w1a*k_6_1/5;
ib=id0/k_0_b;


vars = {...
    {'ib', ib},...
    {'cl', cl},...
    {'cs', cs},...
    {'cf', cf},...
    {'ln', ln},...
    {'lp', lp},...
    {'wb', wb},...
    {'w0', w0},...
    {'w1', w12},...
    {'w2', w12},...
    {'w1a', w1a},...
    {'w2a', w1a},...
    {'w3', w3},...
    {'w3a', w3a},...
    {'w4', w3},...
    {'w4a', w3a},...
    {'w5a', w5a},...
    {'w5b', w5b},...
    {'w5c', w5c},...
    {'w6a', w6a},...
    {'w6b', w6b},...
    {'w6c', w6c},...
    {'w6d', w6d}...
    {'w7a', w7a},...
    {'w7b', w7b},...
    {'w7c', w7c},...
    {'l12', l12},...
    {'l1a', l1a},...
    {'l3a', l3a},...
    {'l3', l3},...
    {'lbb1p', lbb1p},...
    {'lbiasp', lbiasp},... 
    {'lbb2p1', lbb2p1},...
    {'lbb2p2', lbb2p2},...
    {'lbb2n', lbb2n},...
    };
varstr='';
for varcell=vars
    varstr=[varstr, sprintf('.param %s=%.4e\n',varcell{1}{1},varcell{1}{2})];
end
varstr
fid = fopen('params.sp','w');
if fid ~= -1
  fprintf(fid,varstr); 
  fclose(fid);   
end
fprintf('Saved to file.\n')


