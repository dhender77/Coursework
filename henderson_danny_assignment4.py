
# -------------- Student class definition -------------------------
class Student:
    
    def __init__(self, first_name, last_name, std_id, scores_dict):
        # initialize the Student class attributes
        self.first_name = first_name
        self.last_name = last_name
        self.std_id = std_id
        self.scores_dict = scores_dict

    def __str__(self):
        # return the string representation of the Student 
        str_var = "Student ("+self.first_name + ", " + self.last_name + ", " + self.std_id + ", " + self.scores_dict + ")"
        return str_var
        
        
    def get_first_name(self):
        # this function should return the first name attribute
        first_name = self.first_name
        return first_name
    
    def get_last_name(self):
        # this function should return the last name attribute
        last_name = self.last_name
        return last_name
    
    def get_std_id(self):
        # this function should return the return the student id attribute
        std_id = self.std_id
        return std_id
        
    def get_scores_dict(self):
        # this function should return the dictionary of scores attribute
        scores_dict = self.scores_dict
        return scores_dict
        
# -------------- DrakeCourse class definition -------------------------
class DrakeCourse:
    
    def __init__(self, course_name, credit, student_list):
        # initialize the DrakeCourse class attributes
        self.course_name = course_name
        self.credit = credit
        self.student_list = student_list
            
    def add_student(self, student):
        # add the student object into the list attribute of DrakeCourse
        self.student_list.append(student)
        return self.student_list
    
    def show_student_details(self):
        # this function should run iterate through the list of students and
        # print each object store in the list
        for i in self.student_list:
            print(i)
            
            
    def calculate_grade(self, exam_weights, output_file=None):
        
        # step 1: add different header information using proper string formatting
        # your code here
        self.exam_weights = exam_weights
        self.output_file = output_file
        x = 0
        print("---------------------|-------------------|---------------|----------------------|---------------------|")
        print("     first-name      |    last-name      |     std-id    |    letter-grade      |   weighted-score    |")
        print("---------------------|-------------------|---------------|----------------------|---------------------|")

        
        for std in self.student_list:
            
            # step 2: get different attributes from the object 'std' and save them in the following variables
            
            std_first_name = self.student_list[x]
            std_last_name  = self.student_list[x+1]
            std_std_id  = self.student_list[x+2]
            scores_dict  = self.student_list[x+3]
            x = x + 4

            # step 3:  -------- find the average of three assignments ----------
            assignment_avg = (round(int(scores_dict["a1"])) + round(int(scores_dict["a2"])) + round(int(scores_dict["a3"])))/3
            
            # step 4:  -------- find the average of three labs -----------------
            lab_avg = (round(int(scores_dict["l1"])) + round(int(scores_dict["l2"])) + round(int(scores_dict["l3"])))/3
            
            # step 5:  -------- find the average of three quizzes --------------
            quiz_avg = (round(int(scores_dict["q1"])) + round(int(scores_dict["q2"])) + round(int(scores_dict["q3"])))/3
            
            
            # step 6: compute the weighted average of the three exam-avg scores
            weighted_score = assignment_avg*.4 + lab_avg*.3 + quiz_avg*.3
            
            letter_grade = ""       
            # convert to letter grade based on the given rubric
            if   weighted_score > 95:
                letter_grade = "A+"
            elif weighted_score >= 90 and weighted_score < 95:
                letter_grade = "A"
            elif weighted_score >= 80 and weighted_score < 90:
                letter_grade = "B"
            elif weighted_score >= 70 and weighted_score < 80:
                letter_grade = "C"
            elif weighted_score >= 60 and weighted_score < 70:
                letter_grade = "D"
            else:
                letter_grade = "F"
            
            
            # step 7: show the student information and final letter grade using proper string formatting
            print("       , {0},        |       , {1},        |       , {2},        |       , {3},        |       , {4},        |".format(str(std_first_name), str(std_last_name), str(std_std_id), str(letter_grade), str(weighted_score)))
            print("---------------------|---------------------|---------------------|---------------------|---------------------|")
        return None
            
# -------------- other user defined functions -------------------------

# This function accepts three inputs i) major, ii) serial_number, iii) year
# The major could be 'CS' or 'MATH' or "ENG", "PSY", "ACC" etc
# The second parameter is serial_number which is an integer number. Its value should be within 0 to 9999.
# The third parameter is a string representing the incoming year eg, "2021"
# This function should make a student unique identification number of the format: major-serial_number-year.
# For example,
# input:
#    major = "CS", serial_num = 12, year = "2021"
# output:
#    std_id = "CS-0012-2021"
# HINT: you should use string formatting, either % or .format()

def make_student_id(major, serial_num, year):

    std_id = "{m}, -, {s}, -, {y}".format(m = major, s = serial_num, y = year)
    
    return std_id



# this function should receive a string containing sequence of exam_name, score pairs
# (separated by comma). It should create a dictionary out of this string. The key of
# the dictionary should be 'exam_name' eg, 'a1' or 'l1', 'q1' etc. The value of the
# dictionary should be the corresponding score of the exam.

# input:
#       scores_str  =  "a1, 9.5, a2, 10, a3, 10, l1, 9.5, l2, 9.5, l3, 10, q1, 8, q2, 9, q3, 10"
# output:
#       scores_dict =  {'a1': 9.5, ' a2': 10.0, ' a3': 10.0, ' l1': 9.5, ' l2': 9.5, ' l3': 10.0, ' q1': 8.0, ' q2': 9.0, ' q3': 10.0}

# HINT: you might find some of the string methods useful eg, .split(), .replace(), etc

def make_score_dictionary(scores_str):
    
    scores_dict = {}
     
        split_scores = list(scores_str.split(", "))
   
    for i in split_scores:
        if split_scores.index(i)%2 == 0:
            key_list.append(i)
        elif split_scores.index(i)%2 != 0:
            value_list.append(i)    
   
    for j in range(0, round(len(key_list)) - 1):
        scores_dict[key_list[j]] = value_list[j]
    
    return scores_dict


def read_student_records(file_name):
    
    # ------------- creating an object of DrakeCourse class -------
    drake_course = DrakeCourse("CS65", 3.00, [])
    
    # ------------- read from text file -----------------------   
    # Step 1: open the text file using appropriate built-in function
        file_handler = open('student_scores.txt','r')
      
        # Step 2: read all the lines
        all_lines = file_handler.readlines()
        for each_line in all_lines:
            print(each_line)
            studentlist.append(each_line)
        
        # Step 3: run a for loop to process 6 lines consisting of a student record

        for i in range(0, len(my_str),6):
            
            # Step 4: remove the newline and prepare following six variables
            
            first_name = studentlist[i]
            last_name = studentlist[i+1]
            std_major = studentlist[i+2]
            std_serial = studentlist[i+3]
            std_year = studentlist[i+4]
            scores_str = studentlist[i+5]
            
            # ------------- make student identification number ----------------
            # Step 5: make the student identification with  std_major, std_serial, and std_year
            student_id  = make_student_id(std_major, int(std_serial), std_year)
            
            
            # -------------  make the dictionary of exam and score ------------
            # Step 6: Create a dictionary out of string variable scores_str. 
            scores_dict = make_score_dictionary(scores_str)
            
            
            # ------------- creating student object -----------
            # Step 7: Create a Student class and then create an object of Student as follows
            student_obj = Student(first_name, last_name, student_id, scores_dict)
            
            
            # ------------- add student object into the DrakeCourse object -----------
            # Step 8: Finish the DrakeCourse class as provided. An instance of this class -- drake_course -- has been
            # created at the begining of this function. Call add_student() method as follows.
            drake_course.add_student(student_obj)
    
    
    return drake_course


def main():
    
    is_write_file = False
    exam_weights = {'assignment':0.4, 'lab':0.3, 'quiz':0.3}
    
    # ------------- read and save student info from the given text file --------------
    drake_course = read_student_records("student_scores.txt")
    
    # ------------- show the student info ---------------------
    drake_course.show_student_details()
    
    # ------------- calculate student final grade ---------------------
    output_file = None
    if (is_write_file == True):
        output_file = open("student_grade.txt", 'w')
        
    drake_course.calculate_grade(exam_weights, output_file=output_file)
    
    
    
main()

