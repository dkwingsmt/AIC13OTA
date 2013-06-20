#!/usr/bin/python

import re
import sys
from subprocess import call

'''
Useage:
    format.py <IN_FILE> <OUT_FILE> [<KEY1> <VAL1> <KEY2> <VAL2> ...] [- <BOOL_TRUE1> <BOOL_TRUE2> ...]

    Every bool not mentioned in BOOL_TRUE* is set False.
'''

def get_config():
    params = sys.argv
    infile = params[1]
    outfile = params[2]
    sub_dic = {}
    sub_true = []
    now_read_dic = True
    now_key = None
    for par in params[3:]:
        if par == '-':
            if not now_key is None:
                raise Exception('Unpaired parameter %s' % now_key)
            now_read_dic = False
            continue
        if now_read_dic:
            if now_key is None:
                now_key = par
            else:
                sub_dic[now_key] = par
                now_key = None
        else:
            sub_true.append(par)

    return (infile, outfile, sub_dic, sub_true)

def sub(template, label, content):
    occurred = [False]
    def occur(matchobj):
        occurred[0] = True
        return content

    s = re.sub(r'\{\{%s\}\}' % label, occur, template)

    return s if occurred else None

def sub_bool(template, label, label_bool):
    occurred = [False]
    def occur_true(matchobj):
        occurred[0] = True
        return matchobj.group(1)

    def occur_false(matchobj):
        occurred[0] = True
        return ''

    s = template
    if label_bool:
        s = re.sub(r'\{\{\?%s\?(.*?)\}\}' % label, occur_true, s, flags=re.DOTALL)
        s = re.sub(r'\{\{\~%s\~(.*?)\}\}' % label, occur_false, s, flags=re.DOTALL)
    else:
        s = re.sub(r'\{\{\?%s\?(.*?)\}\}' % label, occur_false, s, flags=re.DOTALL)
        s = re.sub(r'\{\{\~%s\~(.*?)\}\}' % label, occur_true, s, flags=re.DOTALL)

    return s if occurred else None

def sub_clear(template):
    return re.sub(r'\{\{(.*?)\}\}', '', template, flags=re.DOTALL)

def subs(template, sub_contents, sub_bools = None):
    s = template
    if sub_contents:
        for k, v in sub_contents.items():
            sn = sub(s, k, v)
            if sn is None:
                print 'Parameter %s not occurred.' % k
            else:
                s = sn
    if sub_bools:
        for k in sub_bools:
            sn = sub_bool(s, k, True)
            if sn is None:
                print 'Parameter %s not occurred.' % k
            else:
                s = sn
    return sub_clear(s)

def main():

    (infile, outfile, sub_dic, sub_true) = get_config()
    
    with open(infile) as f:
        body = f.read()

    with open(outfile, 'w') as f:
        final = subs(body, sub_dic, sub_true)
        f.write(final)

    print 'Done.'

if __name__ == '__main__':
    main()
