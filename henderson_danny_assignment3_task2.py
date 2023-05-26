#------Task 2------

#Subtask 1

my_dict1 = {'Roman': 10, 'DJ': 10, 'Tucker': 14,'Sturtz': 11}
my_dict2 = {'Brodie': 6, 'Sardaar': 8, 'Conor': 4, 'Eric': 5}

def concat_dictionary(my_dict1,my_dict2):
    my_dict1.update(my_dict2)
    print(my_dict1)
    
concat_dictionary(my_dict1,my_dict2)

def toggle_key_value_pair(my_dict):
    new_dict = {}
    for key, val in my_dict.items():
        new_dict[val] = key
    print(new_dict)
    return None

toggle_key_value_pair(my_dict1)

#Subtask 2
alphabet = ['a','b','c','d','e','f']
print(alphabet)

def create_caesar_cipher_mapping(my_vocab, shift_amount):
    newdictionary = {}
    for key in my_vocab:
        alphaindex = my_vocab.index(key) + shift_amount
        if alphaindex < len(my_vocab):
            val = my_vocab[alphaindex]
            newset = {key:val}
            newdictionary.update(newset)
        if alphaindex >= len(my_vocab):
            val = my_vocab[len(my_vocab) - my_vocab.index(key)]
            newset = {key:val}
            newdictionary.update(newset)
        

    print("Alphabet in my_vocab1 = ", my_vocab)
    print("Caesar cipher mapping:")
    print("----------------------")
    return newdictionary
    print(newdictionary)

create_caesar_cipher_mapping(alphabet, 3)
    


#Subtask 3
list1 = ['a','b','c','d', 'e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
list2 = ['A','B','C', 'D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']

my_dict3 = create_caesar_cipher_mapping(list1, 3)
my_dict4 = create_caesar_cipher_mapping(list2, 3)

concat_dictionary(my_dict3, my_dict4)
print(my_dict3)

original_message = "hello world! HELLO WORLD!"

def encrypt_message(my_dict, my_string):
    encrypted_message = ""
    for val in my_string:
        if val == "!" or val == "." or val == "," or val == ";":
            encrypted_message += val
        elif val == " ":
            encrypted_message += " "
        else:
            key = my_dict[val]
            encrypted_message += key
            
    print("Original message:", my_string)
    print("Encrypted message:" , encrypted_message)

encrypt_message(my_dict3, original_message)
