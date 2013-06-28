cd ../hspice
calc_param
cd ../report
ac_struct=loadsigstruct('../hspice/workspace/ota_test_ac.ac0')
dc_struct=loadsigstruct('../hspice/workspace/ota_test_dc.sw0')

f = fopen('gmid_i.tex', 'w');

all_ms = {'b', '0','1','2','3','4','1a','2a','3a','4a', ...
    '5a','5b','5c','6a','6b','6c','6d','7a','7b','7c'};
all_is = {'b', '0','3a','4a','5a','6a','7a'};

for m = all_ms
    shortname = m{1};
    texname = shortname;
    if '0' <= texname(1) && '9' >= texname(1)
        texname(1) = texname(1) + 'A' - '0';
    end
    gm = getfield(ac_struct, sprintf('n1_gm%s', shortname));
    id = getfield(dc_struct, sprintf('n1_id%s', shortname));
    gmid = abs(gm(1)/id(1));
    fwrite(f, sprintf('\\newcommand{\\gmid%s}{%3.2f\\uPV}\n', texname, gmid));
end

for mi = all_is
    shortname = mi{1};
    texname = shortname;
    if '0' <= texname(1) && '9' >= texname(1)
        texname(1) = texname(1) + 'A' - '0';
    end
    id = getfield(dc_struct, sprintf('n1_id%s', shortname));
    fwrite(f, sprintf('\\newcommand{\\id%s}{%3.3f\\umA}\n', texname, abs(id(1)*1e3)));
end

fclose(f);