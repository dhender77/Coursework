#Black Jack

import random

class Card:
    def __init__(self,suit, number, value):
        self.suit = suit
        self.number = number
        self.value = value
        
        
suits = ["Spades", "Hearts", "Diamonds", "Clubs"]
numbers = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
value = {"A":11,"2":2, "3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"J":10,"Q":10,"K":10}
#Make a rule when creating how game works that Ace can be worth 1 if over 21


deck = []

for i in suits:
    for j in numbers:
        deck.append(Card([i], j, value[j]))

    
  


