
#!/usr/bin/env python3

import sys
sys.setrecursionlimit(10000000)

def fairmaze(i, j, rooms, status, rows, columns):
    if (status[i][j] == 'F'):
        status[i][j] = 'F'
        return 'F'
    elif (status[i][j] == 'U'):
        status[i][j] = 'U'
        return 'U'
    elif (status[i][j] == 'V'):
        status[i][j] = 'U'
        return 'U'
    else:
        if ((rooms[i][j] == 'U') and (i == 0)):
            status[i][j] = 'F'
            return 'F'
        elif ((rooms[i][j] == 'D') and (i == int(rows)-1)):
            status[i][j] = 'F'
            return 'F'
        elif ((rooms[i][j] == 'L') and (j == 0)):
            status[i][j] = 'F'
            return 'F'
        elif ((rooms[i][j] == 'R') and (j == int(columns)-1)):
            status[i][j] = 'F'
            return 'F'
        elif (rooms[i][j] == 'U'):
            status[i][j] = 'V'
            status[i][j] = fairmaze(i-1, j, rooms, status, rows, columns)
            return status[i][j]
        elif (rooms[i][j] == 'D'):
            status[i][j] = 'V'
            status[i][j] = fairmaze(i+1, j, rooms, status, rows, columns)
            return status[i][j]
        elif (rooms[i][j] == 'L'):
            status[i][j] = 'V'
            status[i][j] = fairmaze(i, j-1, rooms, status, rows, columns)
            return status[i][j]
        elif (rooms[i][j] == 'R'):
            status[i][j] = 'V'
            status[i][j] = fairmaze(i, j+1, rooms, status, rows, columns)
            return status[i][j]
        else:
            return 42


def loop_rooms():
    
    # file opening
    fp = open(sys.argv[1],'r')
    rows, columns = fp.readline().split()
    # Next-room array
    rooms = []
    # Status-of-the-cell array
    status = []
    # print(rows, columns)

    for i in range(int(rows)):
        g = fp.readline()
        temp1 = []
        temp2 = []
        for j in range(int(columns)):
            temp1.append(g[j])
            temp2.append('X')
        rooms.append(temp1)
        status.append(temp2)

    counter = 0

    for i in range(int(rows)):
        for j in range(int(columns)):
            if (fairmaze(i, j, rooms, status, rows, columns) == 'U'):
                counter = counter + 1
            
    print(counter)
    # print(rooms[1][1])
    # print(rooms)
    # print(status) 
    

    
    
if __name__ == '__main__':
    loop_rooms()