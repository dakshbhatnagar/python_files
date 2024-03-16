#Define the list of names / categorical values
names = ['Alice', 'Bob', 'Charlie', 'Alice', 'Eve', 'Frank', 'Grace', 'Hannah', 'Frank', 'Frank']
nums = [1,1,3,3,3,3,2,2,4,4,4,4,4,5,5,6]

## FUNCTION TO GET THE MAX OCCURENCE OF AN ELEMENT IN A LIST

def get_max(input_list: list):
    #Initiate an empty dictionary
    names_dict = {}

    #Loop over the names
    for i in input_list:
        #If the key in the dictionary exists, 
        if i in names_dict:
            #increae the value by 1
            names_dict[i] += 1

        #if the key doesnt exist create it
        else:
            #set the value to 1
            names_dict[i] = 1

    '''
    Get the Name with max value, we use key argument to get the max value and since we get tuple of name and 
    count, we get the value at the first index since its going to be the name that occured the 
    most in our list.
    '''
    #we use zero inde to fetch the name
    max_occ = max(names_dict.items(), key= lambda x: x[-1])[0]

    return [max_occ, names_dict]

#print(get_max(names))
#print(get_max(nums))

## FUNCTION TO SWAP THE FIRST AND LAST ELEMENTS IN A LIST
def swap_nums(nums_list: list):
    last = nums_list[-1]
    first =  nums_list[0]

    nums_list[0]=last
    nums_list[-1]=first

    return nums_list

#print(swap_nums(names)) 
##print(swap_nums(nums))


## FUNCTION TO PRINT THE FACTORIAL OF AN INTEGER
def factorial(num: int):
    result = 1

    if num<=0:
        return 1
    else:
        for i in range(1, num+1,1):
            result = result * i
    
    return result

# print(factorial(-5))
# print(factorial(5))


## HOW TO REVERSE A LIST
nums = [1,2,3,4,5,6,7]
# Initialize a new list
new_nums= []
#Run the loop backwards, range function syntax is start, stop and step, stop is -1 
# to include the first index, and step is -1 to tell python the loop should run decrementally
for i in range(len(nums)-1,-1,-1):
    new_nums.append(nums[i])
print(new_nums)
