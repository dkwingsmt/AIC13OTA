function [] = ota_test_dc(do_plot)

if nargin == 0
    do_plot = 1;
end

m = loadsig('ota_test_dc.sw0');
%lssig(m)
vod = evalsig(m, 'vod');
vsd = evalsig(m, 'vsd');

if do_plot ~= 0
    figure(3);
    plot(vod, vod./vsd, 'linewidth', 2);
    set(gca,'FontSize',14);
    set(gca,'FontName','Arial');
    set(gca,'LineWidth',1.5);
    axis([-3 3 0 1500]);
    grid;
    xlabel('V_o_d [V]');
    ylabel('V_o_d/V_s_d [V/V]');
end

end

