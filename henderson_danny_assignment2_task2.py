#------Task 2------

#Subtask 1
special_character = input("input special character @, $, * or poundsign :")
for var in range(0,int(input("input number : "))):
    print(special_character)
    
    
#Subtask 2
num = int(input("Enter a multiple of 5: "))
sum = 0
i = 0

if num % 5 == 0:
    for i in range(0,num+1,5):
        sum = sum + i
        print (i, " + ", sum-i, " = ", sum)

    
else:
    print("Enter a multiple of 5")
    
    
#Subtask 3
my_list = [2,4,6,8,10,11,13,15,17,19,22,24,26,26,28]
print(my_list)
cur_num = int(input("enter the number you are looking for in the list: "))
flag_found = False
for val in my_list:
    if (val ==cur_num):
        flag_found = True
        
if(flag_found):
    print("FOUND")
else:
    print("NOT FOUND")
    
#Subtask 4
new_list= [1, 1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7,7, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9]
print(new_list)
count = int(input("Choose a number from the list: "))
found = False
for i in new_list:
    if (i == count):
        found = True
if(found):
    print(count, "appears",new_list.count(count),"times in the list")
else:
    print("number not in list")




#Subtask 5
print(my_list)
number = int(input("Choose a number from my_list: "))
found1 = False
for val in my_list:
    if (val ==number):
        found1 = True
        
if(found1):
    location = my_list.index(number)
    print(number, "appears at location",location)
else:
    print("number not found in list")

    


#Subtask 6
my_list3 = [10,3,15,-7,90,11]
print(my_list3)
maximum = my_list3[0]
minimum = my_list3[0]
for i in my_list3:
    if i > maximum:
        maximum = i
print("Maximum number is", maximum)
for i in my_list3:
    if i < minimum:
        minimum = i
print("Minimum number is", minimum)
    
    
    
    
    
    
    