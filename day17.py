"""The probe's x,y position starts at 0,0. Then, it will follow some trajectory by moving in steps. On each step, these changes occur in the following order:

The probe's x position increases by its x velocity.
The probe's y position increases by its y velocity.
Due to drag, the probe's x velocity changes by 1 toward the value 0; that is, it decreases by 1 if it is greater than 0, increases by 1 if it is less than 0, or does not change if it is already 0.
Due to gravity, the probe's y velocity decreases by 1.
For the probe to successfully make it into the trench, the probe must be on some trajectory that causes it to be within a target area after any step. The submarine computer has already calculated this target area (your puzzle input). For example:

target area: x=20..30, y=-10..-5"""

testin = "target area: x=20..30, y=-10..-5"
input  = "target area: x=150..171, y=-129..-70"
test = True
if test:
    xmin = 20
    xmax = 30
    ymin = -5
    ymax = 10
else:
    xmin = 150
    xmax = 171
    ymin = -70
    ymax = 129

def makeTarget(): # xmin,xmax,ymin,ymax
    return([[x,y] for x in range(xmin,xmax+1) for y in range(ymin, ymax + 1)])

# print(makeTarget()[-1])

def runIteration(xvel, yvel):
    points = [[0,0]]
    [x,y] = points[0]
    target = makeTarget()
    found = False
    while (x >=0 and x <= xmax and y >= ymin and not found):
        last_point = points[-1]
        # print(last_point)
        [x,y] = last_point
        newX = x + xvel
        if xvel > 0:
            xvel = xvel - 1
        newY = y + yvel
        yvel = yvel - 1
        new_point = [newX, newY]
        points.append(new_point)
        if new_point in target:
            found = True
            ys = [i[1] for i in points]
            return(max(ys))
    return(False)

a = runIteration(6,9)
print(a)

to_try = [[x,y] for x in range(100) for y in range(100)]
print(to_try)
maxy = [runIteration(x,y) for [x,y] in to_try]
highest = next(obj for obj in maxy if obj.val == max(maxy))
print(highest)
