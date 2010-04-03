#
#  demo.py
#
#  A demonstration of 2D vector graphics using PyGame and xform.py.
#

import sys, random, pygame, xform, config

def rotate_about_center_matrix(angle, center):
    A = xform.translation(-center[0], -center[1])
    B = xform.rotation(angle)
    C = xform.translation(center[0], center[1])
    return (C.mult(B)).mult(A)

def line_center(point1, point2):
    return ((point1[0] + point2[0]) / 2, (point1[1] + point2[1]) / 2)

def rand_points(num_points):
    points = []
    for i in range(num_points):
        x = center[0] - 150 + random.random() * 300
        y = center[1] - 150 + random.random() * 300
        points.append((x,y))
    return points

pygame.init()

screen = pygame.display.set_mode((config.screen_width, config.screen_height))

center = line_center([0,0], [config.screen_width, config.screen_height])

my_matrix = rotate_about_center_matrix(config.animation_step_angle, center)

def my_rotate(point):
    temp = xform.point(point[0], point[1])
    temp = my_matrix.xform(temp)
    return (temp.v[0], temp.v[1])

def main():
    points = rand_points(config.num_points)
    total_ticks = 0
    frame_count = 0
    print "frame 00",
    sys.stdout.flush()    
    while 1:
        for event in pygame.event.get():
            if event.type in (pygame.QUIT, pygame.KEYDOWN):
                exit()

        start_ticks = pygame.time.get_ticks()
        points = map(my_rotate, points)
        total_ticks += pygame.time.get_ticks() - start_ticks
        frame_count += 1
        if frame_count == 100:
            print "\n100 frames transformed in %s ticks" % (total_ticks)
            sys.stdout.flush()
        elif frame_count < 100:
            print "\b\b\b%2s" % (frame_count),
            sys.stdout.flush()

        screen.fill(config.background_color)
        pygame.draw.lines(screen, config.foreground_color, True, points)
        pygame.display.update()
        pygame.time.wait(config.animation_frame_wait)

if __name__ == "__main__":
    main()

