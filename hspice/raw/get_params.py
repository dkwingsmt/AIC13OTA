import re
import sys


def read_lis(filename):
    start = False
    whole_lib = []
    this_lib = None
    with open(filename) as f:
        for line in f:
            if re.match(r'.*\*\*\*\* mosfets.*', line):
                start = True
                continue
            if re.match(r'.*\*\*\*\*\* job concluded.*', line):
                break
            if not start:
                continue

            line_vec = [word.strip() for word in line.split('  ') 
                    if len(word.strip())]

            # End of a block
            if (len(line_vec) == 0):
                if not this_lib is None:
                    whole_lib.extend(this_lib)
                    this_lib = None
                continue

            # Start of a block
            if (this_lib is None) and (len(line_vec) != 0):
                this_lib = [{} for i in range(1, len(line_vec))]

            name = line_vec[0]
            for device, content in zip(this_lib, line_vec[1:]):
                match_result = re.match('^([0-9.]+)([a-zA-Z]?)$', content)
                if match_result:
                    num_str, exp_str = match_result.groups()
                    if len(exp_str):
                        try:
                            exp_table = {
                                    'M': 1e6,
                                    'k': 1e3,
                                    'm': 1e-3,
                                    'u': 1e-6,
                                    'n': 1e-9,
                                    'p': 1e-12,
                                    'f': 1e-15,
                                    'a': 1e-18,
                                    }
                            exp = exp_table[exp_str]
                        except KeyError:
                            print 'Postfix not found: %s' % exp_str
                            exp = 1
                        try:
                            num = float(num_str)
                        except ValueError:
                            print 'Invalid float: %s' % num_str
                            num = 1
                        content = num * exp
                    else:
                        content = 1

                device[name] = content

    processed_lib = {}

    for device in whole_lib:
        device_name = device['element'].split(':')[1]
        processed_lib[device_name] = device

    return processed_lib

def write_file(lib, filename):
    with open(filename, 'w') as f:
        for name, device in lib.items():
            f.write(name + '\n')
            for k, v in device.items():
                k = ''.join([(c if c != ' ' else '_') for c in k])
                f.write(k + '\n')
                f.write(str(v) + '\n')
            f.write('\n')

                
if __name__ == '__main__':
    lib = read_lis(sys.argv[1])
    try:
        outfile = sys.argv[2]
    except IndexError:
        outfile = '.'.join(sys.argv[1].split('.')[0:-1] + ['param'])
    write_file(lib, outfile)

