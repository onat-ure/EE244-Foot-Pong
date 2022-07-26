# EE244 Final Project: FootPong
FPGA Implementation of the iconic game Pong, with little changes made in gameplay. Build as final project for EE244 Lecture in Bogazici University in Spring 2022. Build together with my buddy Onat Üre.

Here is the main diagram of the game.

![Main Diagram](https://github.com/arkiolok/ee244-FootPong/blob/main/main.jpg?raw=true)


a. Pixel Generator 

For constant objects, such as middle line, goals we specified 5 main constant values 
for each object. Including, their size, their left and right points on x axis and their top 
and bottom points on the y axis. (Generally, they are specified by underscores like 
object_Y_T for the top point on the y axis.)

For dynamic objects, such as ball and players, we specified a constant size (width 
and length) value for them with signals for the position, left and right points on x 
axis and top and bottom points on y axis. They also obey the same naming, but they 
are not constant but signals since they are subject to change.

For all objects we created on signals to print them on the screen. This signal is 
enabled when the pixel_x and pixel_y signals coming from the VGA 
driver is at the declared position of the objects. (Those are named 
as object_on)

For scoreboard, we wrote two 7 segment displays for each player. 
Their enables are dependent to signals that we for the scores.

Finally, we created a process, which changes the color of the relevant pixel, if the 
object_on is logic 1 from black to color specified.


b. Core 

This component is where the game run. It moves the player positions, ball, counts 
the scores and reset the game. 

To move the players, we used the signal coming from the IO Expansion component, 
depending on this signal, a direction vector for each player is established. If up 
button is pressed, the direction is towards up, and if down button is pressed, the 
direction is towards downwards. If none or both are pressed, it is just 0. 

Depending on the vector, a process changes the position of the players with 200 Hz 
frequency by summing the direction vector with position vector and equaling it to 
the position vector. (The direction vectors are called playerN_dir and the position 
vectors are called as playerN_pos. They only have one position because they are 
only able to move in y axis.) 

Movement of the ball is like those of players. Instead, it is not controlled by the user. 
It also has direction and position vectors in x and y. Its direction vector is initialized 
as moving to right&bottom at the beginning. As it colludes to players or the edges, 
its direction vector is reversed in the relevant axis. (The direction vector is called 
ball_dirx, ball_diry and the positions are called as ball_posx and ball_posy) If scored, 
the ball moves towards the player who didn’t get the score. 

Scoring is done as following: If the ball enters the goal, it gains 1 point to the player 
who scored. It is detected as if the position of ball is inside the goal with pixel_x and 
pixel_y positions. Score is held and outputs to Pixel Generator to be displayed on the 
screen. If any of the players reach 5 points. The points reset to 0 and game starts 
again. 


c. VGA Driver 

We used the same code for what have we done in Lab 7 with a little change. Instead 
of using a counter as RGB output, we now use pixel generator for the RGB value of 
each pixel. 

We outputted the vval and hval values that are going through front, back porchs, 
pulse width and display time. After naming this values as pixel_x and pixel_y, we 
used them to decide the RGB value to be printed at that point. 


d. IO Expansion 

We followed the video uploaded on the Moodle to 
use this module. We used the most left 4 buttons as 
controls. In the code they are stated as Btn1(15), 
Btn1(7), Btn1(14), Btn1(6).
