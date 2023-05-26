#-----Task 1------
from graphics import *
import random

#generates a random integer number between 1 and 400
rand_x = random.randint(1,400)
rand_y = random.randint(1,400)
rand_x2 = random.randint(1,400)
rand_y2 = random.randint(1,400)
rand_x3 = random.randint(1,400)
rand_y3 = random.randint(1,400)
rand_number = Point(rand_x, rand_y)
rand_number2 = Point(rand_x2, rand_y2)
rand_number3 = Point(rand_x3, rand_y3)
print(rand_number)
print(rand_number2)
print(rand_number3)

#creates circle function
def draw_circle(window):
    my_cir = Circle(rand_number, 100)
    my_cir.setFill("blue")
    my_cir.draw(window)
    
    return None

#creates rectangle function
def draw_rectangle(window):
    rect = Rectangle(rand_number,rand_number2)
    rect.setFill("green")
    rect.draw(window)
    
    return None

#creates triangle function
def draw_triangle(window):
    tri = Polygon(rand_number,rand_number2,rand_number3)
    tri.setFill("pink")
    tri.draw(window)
    
    return None  
    
def print_menu():
    print("-------------------------------------------------------------------------------------------")
    print("              Menu: Revisiting circle, rectangle, and triangle drawing                     ")
    print("-------------------------------------------------------------------------------------------")
    print("1) Enter 'circle' or 'Circle' or 'CIRCLE' to draw a circle at a random location")
    print("2) Enter 'rectangle' or 'Rectangle' or 'RECTANGLE' to draw a rectangle at a random location")
    print("3) Enter 'triangle' or 'Triangle' or 'TRIANGLE' to draw a triangle at a random location")
    print("-------------------------------------------------------------------------------------------") 

#sets up boolean expressions to print final shape
def main():
    print_menu()
    window = GraphWin("New window", 400,400)
    user_choice = input("Enter the name of your shape from the list above: ")
    if user_choice == "circle" or user_choice == "Circle" or user_choice == "CIRCLE":
        draw_circle(window)
    elif user_choice == "rectangle" or user_choice == "Rectangle" or user_choice == "RECTANGLE":
        draw_rectangle(window)
    elif user_choice == "triangle" or user_choice == "Triangle" or user_choice == "TRIANGLE":
        draw_triangle(window)
    else:
        print("Choice not listed above...")
    return None
     
main()
        
        
        
        
        
        
        
        