```mermaid

flowchart TD
Start([Start])
Start --> A[Generate a random number 1-100]
A --> B[Player makes an input]
B --> C[Is input a number]
C --> D[No]
D --> E[Please enter an integer]
E --> B
C --> F[Yes]
F --> G[Check input number against random number]
G --> H[Is input equal to random number?]
H --> I[Yes]
I -->Correct[Congratulations You Guessed Correctly!]
Correct -->End[Game Over]
H --> J[No]
J --> K[Is input number higher than random number?]
K -->L[Yes]
L -->M[Your input is higher than the random number]
M -->End
K -->N[No]
N -->O[Your input is lower than the random number]
O -->End


```
# Documentation

The first actions are to generate a number and pompt the user to select a number. Store both of these inputs. <p/>
Check to see if the user inputed a integer, If they didn't and input something else like a character, prompt them again to input a number<p/>
Once it is checked that the input is an integer, check to see if it is the same number as the randomly generated number<p/>
If they are the same, game over they won. <p/>
If not we have to check if it is higher or lower. I decided to just check if it is higher leaving the last option be lower.<p/>
Output a response accordingly, either way end of game.
