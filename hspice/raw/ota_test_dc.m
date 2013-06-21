function [vswing] = ota_test_dc(do_plot, input_diff_read)

if nargin == 0
    do_plot = 1;
end

m = loadsig('../workspace/ota_test_dc.sw0');
%lssig(m)
vod = evalsig(m, 'vod');
vsd = evalsig(m, 'vsd');

t = vod./vsd;
a=max(t)*0.7;
c=find(t>=a);
vswing = (vod(c(end))-vod(c(1)));
input_diff = vswing/4;

input_diff_err = abs((input_diff_read - input_diff)/vswing);
if input_diff_err < 0.01
    fprintf('## input_diff correct! Error %f\n', input_diff_err);
else
    fprintf('## Please re-run make. Error %f\n', input_diff_err);
    % Write to local input_diff.sp, while read the workspace version
    f=fopen('input_diff.sp', 'w');
    fprintf(f, '.param input_diff=%f', input_diff);
    fclose(f);
    fprintf('[Written to file] input_diff = %f\n', input_diff);
end
if do_plot ~= 0
    figure(3);
    plot(vod, vod./vsd, 'linewidth', 2);
    set(gca,'FontSize',14);
    set(gca,'FontName','Arial');
    set(gca,'LineWidth',1.5);
    axis([-3 3 0 7000]);
    grid;
    xlabel('V_o_d [V]');
    ylabel('V_o_d/V_s_d [V/V]');
end

end

