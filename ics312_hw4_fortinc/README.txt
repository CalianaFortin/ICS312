Caliana Fortin 
ICS 312 
3/1/2021 


****************************************************************************************************************
ICS 312: Homework 4
**************************************************************************************************************** 
**************************************************************************************************************** 

Exercise #1 [40pts]: Overflow
For each of the following hex additions: 


2-byte quantities: 8FE0 + B036
1-byte quantities: E5 + 0E
2-byte quantities: 5243 + 7DBC
1-byte quantities: E5 + 3A


Answer these 3 questions:
say whether the carry bit is set;
say whether the overflow bit is set and explain your reasoning;
say what would be printed by print_int if the result were sign-extended 
(i.e., via movsx) into the EAX register (Remember that this macro prints signed numbers in decimal representation).


 
****************************************************************************************************************
========================================================================== 
2-byte quantities: 8FE0 + B036
========================================================================== 
	  8FE0h 
	+ B036h 
	——————— 
          14016h
          14016h → 4016h


1. The carry bit is set. 

2. The overflow bit is set. 8FE0 is a negative number, since it starts with a 1 bit, and B036 is a negative number also, since it starts with a 1 bit. When adding a negative with a negative it should be negative, but the answer here results in a positive number, since it begins with a 0 bit. Therefore, the overflow bit is set.
  
3. 4h in binary is 100, which is a positive number, so this means that 4016h is a positive number. Performing a movsx operation on 4016h would lead to 00004016h. This result would print 16406 (which is the decimal from 2’s complement).


========================================================================== 
1-byte quantities: E5 + 0E
========================================================================== 
	   0Eh 
	+  E5h 
	——————— 
	   F3h


1. The carry bit is not set. 

2. The overflow bit is not set. 0E is a positive number, since it starts with a 0 bit, and E5 is a negative, since it starts with a 1 bit. When adding a positive with a negative it will never cause overflow, Therefore, the overflow bit is not set.   

3. Fh in binary is 1111, which is a negative number, so this means that F4h is a negative number. Performing a movsx operation on F4h would lead to FFFFFFF3h. This result would print -13 (which is the decimal from 2’s complement).
 
========================================================================== 
2-byte quantities: 5243 + 7DBC
========================================================================== 
          5243h 
	+ 7DBCh 
	——————— 
	CFFFh


1. The carry bit is not set. 

2. The overflow bit is set. 5243 is a positive number, since it starts with a 0 bit, and 7DBC is a positive number also, since it starts with a 0 bit. When adding a positive with a positive it should be positive, but the answer here results in a negative number, since it begins with a 1 bit. Thus, the overflow bit is set.  

3. Ch in binary is 1100, which is a negative number, so this means that CFFFh is a negative number. Performing a movsx operation on CFFFh would lead to FFFFCFFFh. This result would print -12289 (which is the decimal from 2’s complement).


========================================================================== 
1-byte quantities: E5 + 3A
========================================================================== 
           E5h 
	+  3Ah 
	——————— 
          11Fh → 1Fh


1. The carry bit is set. 

2. The overflow bit is not set. 0E is a negative number, since it starts with a 1 bit, and F8 is a positive number, since it starts with a 0 bit. When adding a negative with a positive it will never cause overflow. Thus, the overflow bit is not set.   

3. 1h in binary is 0001, which is a positive number, so this means that 1Fh is a positive number. Performing a movsx operation on 1Fh would lead to 0000001Fh. This result would print 31 (which is the decimal from 2’s complement).
