#!/usr/bin/env python3

from collections import deque

init = frozenset({'man', 'wolf', 'goat', 'cabbage'}), frozenset()
forbidden = [frozenset({'wolf', 'goat'}), frozenset({'goat', 'cabbage'})]

def next(s):
    edge = 0 if "man" in s[0] else 1
    for x in s[edge]:
        source = s[edge] - frozenset({"man", x})
        target = s[1-edge] | frozenset({"man", x})
        if any(bad <= source for bad in forbidden): continue
        yield (source, target) if edge == 0 else (target, source)

Q = deque([init])
prev = {init: None}
solved = False
while Q:
    s = Q.popleft()
    if not s[0]:
        solved = True
        break
    print('Possible moves from', s, ' are:', tuple(next(s)))
    for t in next(s):
        if t not in prev:
            Q.append(t)
            prev[t] = s

# if solved:
#     while s:
#         print(s)
#         s = prev[s]