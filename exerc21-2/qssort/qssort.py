#!/usr/bin/env python3

import sys
from collections import deque
# from typing import final

# File Opening
fp = open(sys.argv[1],'r')
N = int(fp.readline())

# Queue Initialization
queue = tuple(map(int, fp.readline().split()))

valid = ['Q', 'S']
initial_conf = queue, (), ''
sorted_queue = tuple(sorted(queue))
final_conf = sorted_queue, (), 'S'

def next(s):
    global valid
    if not s[1]:
        stack = list(s[1])
        queue = list(s[0])
        ret = queue.pop(0)
        stack.append(ret)
        move = 'Q'
        yield tuple(queue), tuple(stack), move
    elif not s[0]:
        stack = list(s[1])
        queue = list(s[0])
        ret = stack.pop()
        queue.append(ret)
        move = 'S'
        yield tuple(queue), tuple(stack), move
    else :
        for i in valid:
            if i == 'Q':
                stack = list(s[1])
                queue = list(s[0])
                ret = queue.pop(0)
                stack.append(ret)
                move = 'Q'
                yield tuple(queue), tuple(stack), move
            else :
                stack = list(s[1])
                queue = list(s[0])
                ret = stack.pop()
                queue.append(ret)
                move = 'S'
                yield tuple(queue), tuple(stack), move


Q = deque([initial_conf])
previous = {initial_conf: None}
solved = False
moves = [(initial_conf, tuple(next(initial_conf)))]

while Q:
    s = Q.popleft()
    if (s[0] == final_conf[0]):
        solved = True
        break
    for t in next(s):
        if t not in previous:
            Q.append(t)
            previous[t] = s

Answer = ''
if solved:
    while s:
        ret = s[2]
        Answer = ret + Answer
        s = previous[s]

if (Answer):
    print(Answer)
else :
    print('empty')