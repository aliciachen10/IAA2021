#!/usr/bin/env python
# coding: utf-8

# In[10]:


#Sarah Ocampo
#Tic Tac Toe Python Assignment 2
#Blue Cohort , Fall 1 - 2020

#Create the board
theBoard = {'A1': ' ' , 'B1': ' ' , 'C1': ' ' ,
            'A2': ' ' , 'B2': ' ' , 'C2': ' ' ,
            'A3': ' ' , 'B3': ' ' , 'C3': ' ' }
#Define the board
def printBoard(theBoard):
    print(theBoard['A1'] + ' |' + theBoard['B1'] + ' |' + theBoard['C1'])
    print('--+--+--')
    print(theBoard['A2'] + ' |' + theBoard['B2'] + ' |' + theBoard['C2'])
    print('--+--+--')
    print(theBoard['A3'] + ' |' + theBoard['B3'] + ' |' + theBoard['C3'])

#Define game variables
gamekeys = []
for key in theBoard:
    gamekeys.append(key)
player = 1
Win = 1
Draw = -1
Happening = 0
Piece = 'X'
Round = Happening

# Return game status condition (globally)
def gameConditions():
    if (theBoard['A1'] == theBoard['B1'] == theBoard['C1'] != ' '):
        return Win
    elif (theBoard['A2']==theBoard['B2']==theBoard['C2'] != ' '):
        return Win
    elif (theBoard['A3']==theBoard['B3']==theBoard['C3'] != ' '):
        return Win
    elif (theBoard['A1'] == theBoard['A2'] == theBoard['A3'] != ' '):
        return Win
    elif (theBoard['B1']==theBoard['B2']==theBoard['B3'] != ' '):
        return Win
    elif (theBoard['C1']==theBoard['C2']==theBoard['C3'] != ' '):
        return Win
    elif (theBoard['A1']==theBoard['B2']==theBoard['C3'] != ' '):
        return Win
    elif (theBoard['A3']==theBoard['B2'] == theBoard['C1'] != ' '):
        return Win

    elif (theBoard['A1']!=' ' and theBoard['A2'] != ' ' and theBoard['A3'] != ' ' and theBoard['B1'] != ' ' and theBoard['B2'] != ' ' and theBoard['B3'] != ' ' and theBoard['C1'] != ' ' and theBoard['C2'] != ' ' and theBoard['C3'] != ' '):
        return Draw

    return Happening #base case, returns if it is not win or draw

# Check if position is open
def OpenSpot(turn):
    if (theBoard[turn] == ' '):
        return True
    else:
        return False
    
#The game while happening
while Round == Happening:
    printBoard(theBoard)
    if(player % 2 != 0):
        print("Player X's turn")
        Piece = 'X'
    else:
        print("Player O's turn")
        Piece = 'O'
    turn = input("Where would you like to move next?").capitalize() #Can use a1 or A1 for input
    if (OpenSpot(turn)):
        theBoard[turn] = Piece
        Round = gameConditions()
        player += 1
    else:
        print("Pick an empty spot!!!")


# If game is a draw / win 
printBoard(theBoard)
if(Round == Draw):
    print("Fortunately, this is a draw - you are both smart people")
if(Round==Win):
    player-=1
    if(player%2!=0):
        print("Player X Won... WOOOHOOOO!")
    else:
        print("Player O Won... WOOOHOOOO!")


# In[ ]:




