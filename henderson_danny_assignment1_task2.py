#-----Task 2----------

#this user defined function adds two numbers
def add_numbers(num1,num2):
    sum = num1+num2
    return sum

#this user defined function adds subtracts second number from first
def sub_numbers(num1,num2):
    difference = num1 - num2
    return difference

#this user defined function multiplies two numbers
def mul_numbers(num1,num2):
    product= num1 * num2
    return product

#this user defined function divides the first number by the second
def div_numbers(num1,num2):
    quotient = num1 / num2
    return quotient

#this user defined function computes the power of the first number by the second number
def power_numbers(num1, num2):
    power = num1 ** num2
    return power
#this user defined function computes the remainder of the first number by the second
def modulus_numbers(num1,num2):
    remainder = num1 % num2
    return remainder

def print_menu():
    print("------------------------------------------------------------------------------------------------")
    print("                 Menu: Revisiting simple arithmetic operations                                  ")
    print("------------------------------------------------------------------------------------------------")
    print("1) Enter 'add'      or 'ADD'      to find the summation between two numbers:")
    print("2) Enter 'subtract' or 'SUBTRACT' to find the summation between two numbers:")
    print("3) Enter 'multiply' or 'MULTIPLY' to find the product of two numbers:")
    print("4) Enter 'divide'   or 'DIVIDE'   to find the division of a number by the second one:")
    print("5) Enter 'power'    or 'POWER'    to find the result of the 1st number to the power of the 2nd number:")
    print("6) Enter 'modulus'  or 'MODULUS   to find the remainder of the 1st number by the 2nd number:")
    print("------------------------------------------------------------------------------------------------") 

#sets up function to be selected and performed
def main():
    print_menu()
    user_choice = input("Enter your choice from the list above: ")
    num_1 = float(input("Enter the first number :"))
    num_2 = float(input("Enter the second number :"))
    if user_choice == "add" or user_choice == "ADD":
        print("Result of addition operation", add_numbers(num_1,num_2))
    elif user_choice == "subtract" or user_choice == "SUBTRACT":
        print("Result of subtraction operation", sub_numbers(num_1,num_2))
    elif user_choice == "multiply" or user_choice == "MULTIPLY":
        print("Result of multiplication operation", mul_numbers(num_1,num_2))
    elif user_choice == "divide" or user_choice == "DIVIDE":
        print("Result of division operation", div_numbers(num_1,num_2))
    elif user_choice == "power" or user_choice == "POWER":
        print("Result of power operation", power_numbers(num_1,num_2))
    elif user_choice == "modulus" or user_choice == "MODULUS":
        print("Result of modulus operation", modulus_numbers(num_1,num_2))
    else:
        print("Choice not listed...")

main()











