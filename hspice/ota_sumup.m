function ota_sumup(do_plot)

if nargin == 0
    do_plot = 0;
end

cd workspace

[fc, pm, t0] = ota_test_ac(do_plot);
[DR] = ota_test_noise(do_plot);
ota_test_dc(do_plot);
[es, ts] = ota_test_tran(do_plot);

fprintf('fc = %0.2fMHz, PM = %0.2fdeg, T0 = %0.0f\n', fc, pm, t0)
fprintf('DR = %2.2fdB\n', DR)
fprintf('es = %2.2f%%, ts = %2.2fns\n', es, ts)

cd ..

end