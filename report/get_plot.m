%% ac
m = loadsig('../hspice/workspace/ota_test_ac.ac0');
ti = (evalsig(m, 'I_xt_vyp')-evalsig(m, 'I_xt_vym'))./(evalsig(m, 'I_xt_vxp')-evalsig(m, 'I_xt_vxm'));
m = loadsig('../hspice/workspace/ota_test_ac.ac1');
tv = -(evalsig(m, 'yp')-evalsig(m, 'ym'))./(evalsig(m, 'xp')-evalsig(m, 'xm'));
t  = (tv.*ti-1)./(2+tv+ti);
f = 1e-6 * evalsig(m, 'HERTZ');
mt = 20*log10(abs(t));
pt = 180/pi*unwrap(angle(t));
fc=interp1(mt, f, 0);   
pm=180+interp1(f, pt, fc);
t0=10^(mt(1)/20);
figure(1);
subplot(2,1,1)
semilogx(f, mt, 'linewidth', 2);
title(sprintf('f_c=%0.2fMHz, PM=%0.2fdeg, T_0=%0.0f', fc, pm, t0))
set(gca,'FontSize',14);
set(gca,'FontName','Arial');
set(gca,'LineWidth',1.5);
xlabel('f [MHz]');
ylabel('Magnitude [dB]');
grid;
axis([1e-2 1e4 -40 80]);
h=line([1e-2 1e4], [0 0]);
set(h, 'Linewidth', 2, 'Color', 'k');

subplot(2,1,2)
semilogx(f, pt, 'linewidth', 2);
set(gca,'FontSize',14);
set(gca,'FontName','Arial');
set(gca,'LineWidth',1.5);
set(gca,'ytick',[-180,-90,0])
xlabel('f [MHz]');
ylabel('Phase [degrees]');
axis([1e-2 1e4 -180 0]);
grid;
%print_pdf('t.pdf', 20, 26)
%% transient

m = loadsig('../hspice/workspace/ota_test_tr.tr0');
% list available signals
%lssig(m)

% read into matlab variables
t    = 1e9*evalsig(m, 'TIME');
vsd  = 1e3*evalsig(m, 'vsd');
vid  = 1e3*evalsig(m, 'xp-xm');
vod  = 1e3*evalsig(m, 'vod');
voc  = 0.5*1e3*(evalsig(m, 'vop')+evalsig(m, 'vom'));

vodend = 2*vsd(end);
err  = 100*(vod-vodend)/vodend;
iod  = 1e3*( evalsig(m, 'I_vmp') - evalsig(m, 'I_vmm') );
vxd  = 1e3*( evalsig(m, 'xp') - evalsig(m, 'xm') );


% find settling time
err_dyn_spec = 0.1;
static_plus = err(end)+err_dyn_spec;
static_minus = err(end)-err_dyn_spec;
t_plus_array = find(err>=static_plus);
t_minus_array = find(err<=static_minus);

if(length(t_minus_array)>1)
	t_plus=0;
	if(length(t_plus_array)>1)
		t_plus = t_plus_array(length(t_plus_array));
	end
	t_minus = t_minus_array(length(t_minus_array));
	if(t_plus>t_minus)
		ts = t(t_plus);
	else
		ts = t(t_minus);
	end
else
    disp('This is garbage data!');
    ts = inf;
end
es = err(end);


figure(4);
subplot(2,1,1)
plot(t, vod, [t(1) t(end)], [1 1]*vodend, 'linewidth', 2);
set(gca,'FontSize',14);
set(gca,'FontName','Arial');
set(gca,'LineWidth',1);
xlabel('Time  [ns]');
ylabel('V_o_d [mV]');
axis([0 15 0 2200]);
grid;
string = sprintf('e_s=%2.2f%%, t_s=%2.2fns\n', es, ts);
subplot(2,1,2)
plot(t, err, 'linewidth', 2);
title(string);
set(gca,'FontSize',14);
set(gca,'FontName','Arial');
set(gca,'LineWidth',1);
xlabel('Time  [ns]');
ylabel('Error [%]');
axis([0 100 -5 5]);
grid;
line([0 t(end)], [static_plus static_plus]);
line([0 t(end)], [static_minus static_minus]);

figure(5)
subplot(3,1,1)
plot(t, voc, 'linewidth', 2);
set(gca,'FontSize',14);
set(gca,'FontName','Arial');
set(gca,'LineWidth',1);
xlabel('Time  [ns]');
ylabel('V_o_c [mV]');
axis([0 10 1000 2000]);
grid;
subplot(3,1,2)
plot(t, vid, 'linewidth', 2);
set(gca,'FontSize',14);
set(gca,'FontName','Arial');
set(gca,'LineWidth',1);
xlabel('Time  [ns]');
ylabel('V_i_d [mV]');
axis([0 10 -100 800]);
grid;
subplot(3,1,3)
plot(t, iod, 'linewidth', 2);
set(gca,'FontSize',14);
set(gca,'FontName','Arial');
set(gca,'LineWidth',1);
xlabel('Time  [ns]');
ylabel('I_o_d [mA]');
axis([0 10 -0.1 0.5]);
grid;

%% noise
m = loadsig('../hspice/workspace/ota_test_noise.ac0');


f     = evalsig(m, 'HERTZ');
no    = evalsig(m, 'outnoise');
ni    = evalsig(m, 'innoise');
integ = cumtrapz(f, no);
integ_sqrt = 1e6*sqrt(integ);
integ_final = integ_sqrt(end);
vodpeak = 2;
DR = 10*log10(0.5*vodpeak^2/integ(end));

figure(2);
subplot(2,1,1)
loglog(f, no, 'linewidth', 2);
set(gca,'FontSize',14);
set(gca,'FontName','Arial');
set(gca,'LineWidth',1.5);
xlabel('f [Hz]');
ylabel('PSD [V^2/Hz]');
axis([min(f) max(f) min(no)/10 10*max(no)]);
grid;
subplot(2,1,2)
semilogx(f, integ_sqrt,'linewidth', 2);
set(gca,'FontSize',14);
set(gca,'FontName','Arial');
set(gca,'LineWidth',1.5);
xlabel('f [Hz]');
ylabel('Sqrt(Integral) [\muVrms]');
axis([min(f) max(f) 0 1.2*integ_final]);
string=sprintf('Integral=%2.2fuVrms, DR=%2.2fdB (for V_o_d_m_a_x=%2.2fV)', integ_final, DR, vodpeak);
title(string);
grid;
