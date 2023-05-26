#------Task 1-------

#Subtask 1
Divisors = int(input("enter an integer: "))
divisor_list = []
for i in range(2,Divisors):
    if (Divisors % i == 0): 
        divisor_list.append(i)
print(divisor_list)
        
#Subtask 2
test_list = []
test_divisor_list = []
while True:
    num1 = int(input("enter an integer, end -1 to end: "))
    if num1 != -1:
        test_list.append(num1)
    elif num1 == -1:
        break
        
Div = int(input("enter a final integer: "))
for num in test_list:
    if (Div % num == 0):
        test_divisor_list.append(num)
print("List of candidate divisors are: ",test_list) 
print("List of divisors are: ",test_divisor_list)
    
#Subtask 3
def get_invalid_colors(colorlists):
    invalidcolorslist = []
    for inner_list in colorlists:
        for val in inner_list:
            if val > 255 or val < 0:
                invalidindex = inner_list.index(val)
                invalidcolorslist.append(invalidindex)
    print("Invalid colors are located at :", invalidcolorslist)
    
def correct_invalid_colors(colorlists):
    for inner_list in colorlists:
        for val in inner_list:
            if val > 255:
                inner_list[inner_list.index(val)] = 255
            elif val < 0:
                inner_list[inner_list.index(val)] = 0
    print("The new list is", colorlists)

def discard_invalid_colors(colorlists):
    for inner_list in colorlists:
        inner_list_index = colorlists.index(inner_list)
        for val in inner_list:
            if val > 255:
                del colorlists[inner_list_index]
            elif val < 0:
                del colorlists[inner_list_index]
    print("The new list is", colorlists)
    
print("Type 'Get Invalid Colors' to recieve the location of invalid colors")
print("Type 'Correct Invalid Colors' to correct all invalid colors")
print("Type 'Discard Invalid Colors' to discard all invalid colors")
print(" ")
my_function = input("Please input one of the functions as shown above. ")
if my_function == "Get Invalid Colors":
    get_invalid_colors(colorlists)
elif my_function == "Correct Invalid Colors":
    correct_invalid_colors(colorlists)
elif my_function == "Discard Invalid Colors":
    discard_invalid_colors(colorlists)
else:
    print("Please enter a given function.")
                



