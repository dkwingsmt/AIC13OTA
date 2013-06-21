function ota_sumup(do_plot)

if nargin == 0
    do_plot = 0;
end

cd raw

f = fopen('../workspace/input_diff.sp');
if f == -1
    fprintf('## Invalid file workspace/input_diff.sp ##');
    input_diff_read = NaN;
else
    line = fgetl(f);
    if ischar(line)
        s = regexp(line, '=', 'split');
        input_diff_read = str2double(s{2});
        fclose(f);
    else
        input_diff_read = NaN;
    end
end

fprintf('[Read from file] input_diff = %f\n', input_diff_read);
[fc, pm, t0] = ota_test_ac(do_plot);
[DR] = ota_test_noise(do_plot);
[vswing] = ota_test_dc(do_plot, input_diff_read);
[es, ts] = ota_test_tran(do_plot);

fprintf('fc = %0.2fMHz, PM = %0.2fdeg, T0 = %0.0f\n', fc, pm, t0)
fprintf('DR = %2.2fdB\n', DR)
fprintf('Vswing = %2.3fV\n', vswing)
fprintf('es = %2.2f%%, ts = %2.2fns\n', es, ts)

cd ..

end