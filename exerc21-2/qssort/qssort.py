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

#print(initial_conf, final_conf)

def next(s):
    global valid
    if not s[1]:
        stack = list(s[1])
        queue = list(s[0])
        ret = queue.pop(0)
        stack.append(ret)
        move = 'Q'
        #print(s[0], s[1], 'Q move to empty stack', tuple(queue), tuple(stack))
        yield tuple(queue), tuple(stack), move
    elif not s[0]:
        stack = list(s[1])
        queue = list(s[0])
        ret = stack.pop()
        queue.append(ret)
        move = 'S'
        #print(s[0], s[1], 'S move to non-empty queue', tuple(queue), tuple(stack))
        yield tuple(queue), tuple(stack), move
    else :
        for i in valid:
            if i == 'Q':
                stack = list(s[1])
                queue = list(s[0])
                ret = queue.pop(0)
                stack.append(ret)
                move = 'Q'
                #print(s[0], s[1], 'Q move to non-empty stack', tuple(queue), tuple(stack))
                yield tuple(queue), tuple(stack), move
            else :
                stack = list(s[1])
                queue = list(s[0])
                ret = stack.pop()
                queue.append(ret)
                move = 'S'
                #print(s[0], s[1], 'S move to non-empty queue', tuple(queue), tuple(stack))
                yield tuple(queue), tuple(stack), move


Q = deque([initial_conf])
previous = {initial_conf: None}
solved = False
moves = [(initial_conf, tuple(next(initial_conf)))]

# for pair in moves:
#     print('Previous:',pair[0], 'Possible:', pair[1])
#     if pair[0] == final_conf[0]:
#         solved
#         break
#     for s in pair[1]:
#         if s not in previous:
#             t = tuple(next(s))
#             moves.append((s,t))
#             previous[s] = pair[0]

    

while Q:
    s = Q.popleft()
    if (s[0] == final_conf[0]):
        # print('Ending!')
        solved = True
        break
    #print('Possible moves from', s, ' are:', tuple(next(s)))
    for t in next(s):
        #print('State :', t)
        if t not in previous:
            #print('State added!')
            Q.append(t)
            previous[t] = s

Answer = []
if solved:
    while s:
        ret = s[2]
        Answer.append(ret)
        s = previous[s]
Answer.pop()
Answer = Answer[::-1]
output = ''
for i in Answer :
    output += i
if (output):
    print(output)
else :
    print('empty')