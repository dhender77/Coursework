#------Task 1------

#Subtask 1
num = int(input("Enter an integer: "))
sum = 0
i = 0

while i <= num:
    sum = sum + i
    print(i, " + ", sum-i, " = ", sum)
    i= i + 1
    
#Subtask 2
num = int(input("Enter an odd number: "))
sum = 0
i = 1

if num % 2 == 1:
    while i <= num:
        sum = sum + i
        print (i, " + ", sum-i, " = ", sum)
        i= i + 2
    
else:
    print("Enter an odd number")
    

#Subtask 3
eastern = ["DE","NC","NJ","VA"]
print(eastern)
midwestern = ["IA","IN","KS","WI"]
print(midwestern)
southern = ["TX","LA","AL","AK"]
print(southern)
western = ["CA","OR","WA","NV"]
print(western)

while True:
    state = input("Enter a state from the list: ")
    if state == "DE" or state == "NC" or state == "NJ" or state == "VA":
        print("Eastern")
    elif state == "IA" or state == "IN" or state == "KS" or state == "WI":
        print("Midwestern")
    elif state == "TX" or state == "LA" or state == "AL" or state == "AK":
        print("Southern")
    elif state == "CA" or state == "OR" or state == "WA" or state == "NV":
        print("Western")
    elif state == "END":
       break
    else:
        print("State not found in list")
        










