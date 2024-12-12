# Python Project 1: Python Fundamental

## Project outcome:
- Knowing how to apply suitable data type in real world practice
- Knowing how to use and define a function, loop
- Apply the Computational Thinking mindset in real world practice.
<br>
<details> <summary><strong>Practice 1: Create a function to find which word occurs the most in the given paragraph.</strong></summary>
<br>
Paragraph:
<br>
"Friendship is one of the most important things in life. Probably everybody has a few close friends who you met at school or university. Nevertheless, I think that our life does consists of more significant things even than friendship. For example, family and self-realisation are vital necessities of life at all times. Firstly, a family has a significant influence on both upbringing and education of a child since early age."
<br>
<br>
  
```python
 def word_occurs_the_most(paragraph) : 
    #Clean the paragraph
    paragraph_remove_comma = paragraph.replace(",","")
    paragraph_remove_dot = paragraph_remove_comma.replace(".","")
    paragraph_remove_lowercase = paragraph_remove_dot.lower()
    paragraph_split = paragraph_remove_lowercase.split()
    #Get the dictionary of frequency
    Frequency = {}
    for value in paragraph_split :
        if value in Frequency : 
            Frequency[value] += 1
        else :
            Frequency[value]  = 1
    print(Frequency)
    #Get the list of words with highest frequency
    highest_frequency = max(Frequency.values())
    for Key, value in Frequency.items() :
        if value == highest_frequency :
            print(Key, value)

paragraph = "Friendship is one of the most important things in life. Probably everybody has a few close friends who you met at school or university. \
            Nevertheless, I think that our life does consists of more significant things even than friendship. For example, family and self-realisation are vital necessities of life at all times. \
            Firstly, a family has a significant influence on both upbringing and education of a child since early age."
word_occurs_the_most(paragraph)
```
Output
```
{'friendship': 2, 'is': 1, 'one': 1, 'of': 4, 'the': 1, 'most': 1, 'important': 1, 'things': 2, 'in': 1, 'life': 3, 'probably': 1, 'everybody': 1, 'has': 2, 'a': 4, 'few': 1, 'close': 1, 'friends': 1, 'who': 1, 'you': 1, 'met': 1, 'at': 2, 'school': 1, 'or': 1, 'university': 1, 'nevertheless': 1, 'i': 1, 'think': 1, 'that': 1, 'our': 1, 'does': 1, 'consists': 1, 'more': 1, 'significant': 2, 'even': 1, 'than': 1, 'for': 1, 'example': 1, 'family': 2, 'and': 2, 'self-realisation': 1, 'are': 1, 'vital': 1, 'necessities': 1, 'all': 1, 'times': 1, 'firstly': 1, 'influence': 1, 'on': 1, 'both': 1, 'upbringing': 1, 'education': 1, 'child': 1, 'since': 1, 'early': 1, 'age': 1}
of 4
a 4
```
</details>

<details> <summary><strong>Practice 2: Count the unique words of the following text</strong></summary>
<br>
Paragraph:
<br> 
"Friendship is one of the greatest bonds anyone can ever wish for. Lucky are those who have friends they can trust. Friendship is a devoted relationship between two individuals. They both feel immense care and love for each other. Usually, a friendship is shared by two people who have similar interests and feelings"
<br>
<br>
  
```python
paragraph_2 = "Friendship is one of the greatest bonds anyone can ever wish for. Lucky are those who have friends they can trust. \
               Friendship is a devoted relationship between two individuals. They both feel immense care and love for each other. \
               Usually, a friendship is shared by two people who have similar interests and feelings"
#Clean the paragraph
paragraph_remove_comma_2 = paragraph_2.replace(",","")
paragraph_remove_dot_2 = paragraph_remove_comma_2.replace(".","")
paragraph_remove_lowercase_2 = paragraph_remove_dot_2.lower()
paragraph_split_2 = paragraph_remove_lowercase_2.split()
#Get the dictionary of frequency
Frequency_2 = {}
for value in paragraph_split_2 :
    if value in Frequency_2 : 
        Frequency_2[value] += 1
    else :
        Frequency_2[value]  = 1
print(Frequency_2)
#Count the unique words
count = 0
for key, value in Frequency_2.items() :
    if value == 1 :
        count += 1
print(count)
```
Output
```
{'friendship': 3, 'is': 3, 'one': 1, 'of': 1, 'the': 1, 'greatest': 1, 'bonds': 1, 'anyone': 1, 'can': 2, 'ever': 1, 'wish': 1, 'for': 2, 'lucky': 1, 'are': 1, 'those': 1, 'who': 2, 'have': 2, 'friends': 1, 'they': 2, 'trust': 1, 'a': 2, 'devoted': 1, 'relationship': 1, 'between': 1, 'two': 2, 'individuals': 1, 'both': 1, 'feel': 1, 'immense': 1, 'care': 1, 'and': 2, 'love': 1, 'each': 1, 'other': 1, 'usually': 1, 'shared': 1, 'by': 1, 'people': 1, 'similar': 1, 'interests': 1, 'feelings': 1}
31
```
</details>

<details> <summary><strong>Practice 3: Find the number or prime number from the following list</strong></summary>
[1, 7, 6, 9, 13, 21, 27]
  
```python  
Number = [1, 7, 6, 9, 13, 21, 27]
#Create loop to find number can only divide to 1 and itself
for value in Number : 
    if value > 1 : #becasue prime number is not == to 1 
        for x in range(2, int(value **0.5) + 1) :# loop in range from 2 to square root of each number in the list to find which number in the list can't divide to number in range => prime number
            if value % x == 0: 
                break
        else :
            print(value)
```
Output
```
7
13
```
</details>

<details><summary><strong>Practice 4: Check if these two couples of sentences (Sentence 1 & 2, Sentence 3 & 4) are anagrams or not</strong></summary>
<br>
Sentence 1 = "listen to the silent whispers"
<br>
Sentence 2 = "silent whispers to the listen"
<br>
Sentence 3 = "listen to the silent night"
<br>
Sentence 4 = "silent whispers to the listen"

```python
Sentence_1 = "listen to the silent whispers"
Sentence_2 = "silent whispers to the listen"
Sentence_3 = "listen to the silent night"
Sentence_4 = "silent whispers to the listen"
#clean sentences
# Sentence_1 = Sentence_1.replace(" ","")
# Sentence_2 = Sentence_2.replace(" ","")
# Sentence_3 = Sentence_3.replace(" ","")
# Sentence_4 = Sentence_4.replace(" ","")
Sentence_1 = Sentence_1.split()
Sentence_2 = Sentence_2.split()
Sentence_3 = Sentence_3.split()
Sentence_4 = Sentence_4.split()
print(sorted(Sentence_1))
print(sorted(Sentence_2))

#compare len of sentence 1 vs 2, after that compare the sorted list of 2 sentence
if len(Sentence_1) == len(Sentence_2) :
    if sorted(Sentence_1) == sorted(Sentence_2) : 
        print("sentence 1 vs 2 are " + "anagrams")
    else :
        print("sentence 1 vs 2 are " + "not anagrams")
else :
    print("sentence 1 vs 2 not match")
#compare len of sentence 3 vs 4, after that compare the sorted list of 2 sentence
if len(Sentence_3) == len(Sentence_4) :
    if sorted(Sentence_3) == sorted(Sentence_4) : 
         print("sentence 3 vs 4 are " + "anagrams")
    else :
         print("sentence 3 vs 4 are " + "not anagrams")
else :
    print("sentence 3 vs 4 not match")
```
Output
```
['listen', 'silent', 'the', 'to', 'whispers']
['listen', 'silent', 'the', 'to', 'whispers']
sentence 1 vs 2 are anagrams
sentence 3 vs 4 are not anagrams
```
</details>

<details>
<summary><strong>Practice 5: Anna is submitting a requirement on a platform. However, there are limitations about the number of words and number of characters for the submission. Particularly, the number of words should be under 50 words, and the number of characters should be under 200 characters.
Please help Anna create a function to do this and check this function with the following submissions!</strong></summary>

<br>

Submission 1: "I am very excited about the opportunity to work with your company. My skills in data analysis and programming make me confident that I would be a valuable addition to your team. I look forward to the chance to contribute and grow with your company."

<br>
Submission 2: "I recently bought this product, and I must say, I'm really impressed. The quality is exceptional, and it works just as advertised. I especially appreciate the ease of use, which makes it perfect for both beginners and experts. I would definitely recommend it to others who are looking for something similar."
<br>
<br>

```python
def submission_check(Submission) :
    #Clean the submission
    Submission_remove_comma = Submission.replace(",","")
    Submission_remove_dot = Submission_remove_comma.replace(".","")
    Submission_remove_lowercase = Submission_remove_dot.lower()
    Submission_split = Submission_remove_lowercase.split()
    #Set Words and characters condition
    if len(Submission_split) < 50 and len(list(Submission)) < 200 :
        print("Submission word and character qualified")
    elif len(Submission_split) >= 50 and len(list(Submission)) < 200 :
        print("Please adjust the text length under 50 words. Current text length is " + str(len(Submission_split)))
    elif len(Submission_split) < 50 and len(list(Submission)) >= 200 :
        print("Please adjust the character length under 200 characters. Current character length is " + str(len(list(Submission))))
    else :
        print("Please adjust the text length and characters contained in the paragraph.")


Submission= "I am very excited about the opportunity to work with your company. My skills in data analysis and programming make me confident that I would be a valuable addition to your team. I look forward to the chance to contribute and grow with your company."
submission_check(Submission)
```
Output
```
Please adjust the character length under 200 characters. Current character length is 248
```
</details>







































