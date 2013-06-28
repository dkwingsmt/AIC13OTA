import re

params = {}
with open('../hspice/raw/params.sp') as f:
    for line in f:
        matched = re.match(r"\.param (.*)=(.*)", line)
        if matched:
            params[matched.group(1)] = matched.group(2)

data = {}
with open('../hspice/raw/project.sp') as f:
    for line in f:
        matched = re.match(r"M([0-9a-z]+).*l='(.*)'.*w='(.*)'.*", line)
        if matched:
            name = matched.group(1).strip()
            if name[0].isdigit():
                name = ''.join([chr(ord(name[0]) + ord('A') - ord('0')), name[1:]])
            data[matched.group(1)] = {
                    'name': name,
                    'l': float(params[matched.group(2).strip()])*1e6, 
                    'w': float(params[matched.group(3).strip()])*1e6, 
                    }

with open('mos_sizes.tex', 'w') as f:
    for name, sizes in data.items():
        f.write('\\newcommand{{\size{name:s}}}{{{w:2.2f}/{l:2.3f}}}\n'.format(**sizes))
