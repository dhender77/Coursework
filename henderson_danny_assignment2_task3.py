#------Task 3------

#Subtask 1
height = int(input("Enter the height of the rectangle: "))
width = int(input("Enter the width of the rectangle: "))

for i in range(height):
    for j in range(width):
        print("*", end = "")
    print()
    

#Subtask 2
length = int(input("Enter the length (adjacent/opponent) of the triangle: "))

for i in range(length):
    for j in range(0,i+1):
        print("*", end = "")
    print()
        
#Subtask 3
adjacent = int(input("Enter the length (adjacent/opponent) of the triangle: "))

for i in range(adjacent):
    for j in range(0,adjacent-1-i):
        print(" ", end = "")
    for k in range(0,i+1):
        print("*", end = "")
    print()






