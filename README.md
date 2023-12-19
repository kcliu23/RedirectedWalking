# Project: Redirected Walking

Part 1: Navigation

In this project, the steer to center algorithm was used.  This algorithm rotates the world around the user when they are walking away from the center of the room, attempting to have them walk towards the center of the room.  The amount of rotation scales depending on the angle between the player's movement and the vector to the center of the room, as well as being scaled with how close they are to the center of the room to prevent sudden rotation direction changes near the center.

A rotation gain was also implemented, where if the player is rotating towards the center of the room, the world is rotated less, while if they are rotating away from the center the world rotates more.  This is scaled so that when the player is looking near the center of the room, there is little effect from this gain.

Part 2: UI

In an experience that uses redirected walking, developers need to determine a proper way to allow for the player to reset themselves when they physically get too close to the room boundary, but they still need to go in the direction that would lead them past the VR boundary.  To address this, we added an adapted 2D menu that allows the user to switch between 3 navigation modes: redirected walking, disabled tracking, and snap turn.  The redirected walking more uses the navigation found in part 1.  The disabled tracking causes the player to not move in VR even when they do move in physical space; this allows for the player to move themselves somewhere else in the room in physical space and then continue on in virtual space.  The 3rd method implemented was a snap turning mode.  This mode would allow for the user to rotate the world around them using snap turning, and to then re-enable the redirected walking mode to continue moving in the environment.

When the user presses the ax button to toggle the menu, a 2D menu is projected that follows the tracking of the left controller.  The right controller becomes a pointer which allows for the user to select which mode they want to switch to.

Environment

Our project is done in WebXR, and makes use of Godot XR Tools for some of the XR functionality

## License

Material for [CSCI 5619 Fall 2023](https://canvas.umn.edu/courses/391288/assignments/syllabus) by [Evan Suma Rosenberg](https://illusioneering.umn.edu/) is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).
