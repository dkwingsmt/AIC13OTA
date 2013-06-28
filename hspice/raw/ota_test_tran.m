function [es, ts] = ota_test_tran(do_plot)

if nargin == 0
    do_plot = 1;
end

% load hspice output
m = loadsig('../workspace/ota_test_tr.tr0');
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


if do_plot ~= 0
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
    print_pdf('../../report/common/tran1.pdf',20,26);

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
    print_pdf('../../report/common/tran2.pdf',20,39);
end


end
