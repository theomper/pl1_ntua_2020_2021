#!/usr/bin/env python3

import sys
from collections import deque
from typing import final

# File Opening
fp = open(sys.argv[1],'r')
N = int(fp.readline())

# Queue Initialization
queue = list(map(int, fp.readline().split()))

valid = ['Q', 'S']
move = 'S'
initial_conf = queue, [], ""
sorted_queue = sorted(queue)
final_conf = sorted_queue, [], move

# print(N, initial_conf, final_conf)

def next(s):
    global valid
    if not s[1]:
        s[1].append(s[0].pop(0)) #Q Move
        s[2].append("Q")
    elif not s[0]:
        s[0].append(s[1].pop())  #S Move
        s[2].append("S")
    else :
        for i in valid:
            if i == 'Q':
                s[1].append(s[0].pop(0)) #Q Move
                s[2].append("Q")
            else :
                s[0].append(s[1].pop())  #S Move
                s[2].append("S")
        yield s[0], s[1], s[2]


Q = deque([initial_conf])
previous = {initial_conf: None}
solved = False


while Q:
    s = Q.popleft()
    if (s[0] == final_conf):
        solved
        break
    for t in next(s):
        if t not in previous: 
            Q.append(t)
            previous[t] = s


if solved:
    while s:
        print(s)
        s = prev[s]