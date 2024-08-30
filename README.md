# EE244 Final Project: FootPong
An FPGA implementation of the iconic game Pong, with slight changes made to the gameplay. This project was built as a final project for the EE244 class at Boğaziçi University in Spring 2022, together with my buddy Hakan Ak.

Here is the main diagram of the game:

![Main Diagram](https://github.com/arkiolok/ee244-FootPong/blob/main/main.jpg?raw=true)


a. Pixel Generator 

For constant objects, such as the middle line and goals, we specified five main constant values for each object. These values include their size, their left and right points on the x-axis, and their top and bottom points on the y-axis. Generally, these points are specified using underscores, such as object_Y_T for the top point on the y-axis.

For dynamic objects, such as the ball and players, we specified a constant size (width and length) value, along with signals for their positions, left and right points on the x-axis, and top and bottom points on the y-axis. These objects follow the same naming conventions, but their values are represented by signals rather than constants, as they are subject to change.

For all objects, we created signals to display them on the screen. These signals are enabled when the pixel_x and pixel_y signals from the VGA driver are at the declared position of the objects (these signals are named as object_on).

For the scoreboard, we used two 7-segment displays for each player. Their enables are dependent on signals that correspond to the scores.

Finally, we created a process that changes the color of the relevant pixel from black to a specified color if the object_on signal is set to logic 1.


b. Core 

This component is where the game logic runs. It controls player positions, ball movement, scoring, and game resets.

To move the players, we used signals from the IO Expansion component. Based on these signals, a direction vector is established for each player. If the up button is pressed, the direction is upward; if the down button is pressed, the direction is downward. If neither or both are pressed, the direction is set to 0.

Based on the direction vector, a process updates the player's position with a 200 Hz frequency by adding the direction vector to the position vector and setting this sum as the new position. (The direction vectors are called playerN_dir and the position vectors are called playerN_pos. Each player only has a single position value since they can only move along the y-axis.)

The movement of the ball is similar to that of the players, except it is not user-controlled. The ball has direction and position vectors for both the x and y axes. Its direction vector is initially set to move right and downward. When the ball collides with a player or the screen edges, its direction vector is reversed along the relevant axis. (The direction vectors are named ball_dirx and ball_diry, and the positions are named ball_posx and ball_posy.) If a goal is scored, the ball moves toward the player who did not score.

Scoring is determined as follows: if the ball enters a goal, the player who scored gains one point. This is detected when the ball's position overlaps with the goal's position using pixel_x and pixel_y. The score is maintained and sent to the Pixel Generator to be displayed on the screen. If either player reaches five points, the points reset to zero, and the game restarts.




c. VGA Driver 

We used the same code as in Lab 7 with a slight modification. Instead of using a counter for the RGB output, we now use the pixel generator to determine the RGB value for each pixel.

We output the vval and hval values as they pass through the front and back porches, pulse width, and display time. By naming these values pixel_x and pixel_y, we used them to determine the RGB value to be displayed at that specific point.



d. IO Expansion 

We followed the video uploaded on Moodle to use this module. The four leftmost buttons were used as controls. In the code, they are referred to as Btn1(15), Btn1(7), Btn1(14), and Btn1(6).
