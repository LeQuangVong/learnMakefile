## What is Makefile ?
Makefile is a script containing (bao gồm) the following information:
- File structure (file, dependence)
- Commands to create files

The files created are called ```Target```
Dependent files called ```Dependence```
The command used to compile source code called ```Action```
A syntax that includes Target, Dependence, Action called a ```Rule```

![](./makefilerule-e1489805882799.png)

- ```Rule```: Rules need to be implemented (thực hiện) when compiling.
- ```Dependency```: are the neccessary files to create ```Target```
- ```Action```: is the compile command to create ```Target``` from ```Dependency```, the ```Action``` is indented (lùi) 1 Tab compared (so) to the ```Target```
- ```Target```: is the destination (đích đến) file, meaning the file to be executed (hình thành) after the make process is performed.

### Create Makefile
```
.PHONY: all clean

all: test.c
	gcc -o app.exe test.c
clean:
	rm app.exe
```
- ```.PHONY```: Use the ```.PHONY``` variable to avoid the name of the rule from overlapping with the name of the files you create.

Code:
```
#include <stdio.h>
int main()
{
    printf("Hello World\n");
    return 1;
}
```
Run make:
```
make                                                     
gcc -o app.exe test.c
./app.exe                                                      
Hello World
make clean                                                    
rm app.exe
```
- Use ``` make <rule name>``` command to run the rule you want to run
- If you use the ```make``` command, it will run the first rule
- If there is an additional Makefile, use this command to run that Makefile:
```
make -f <Makefile name>
```
### Variable 
Code:
```
.PHONY: rule1 rule2 rule3

var := "1"
var3 := "3"

var1 = $(var)   #Recursive assignment (phép gán đệ quy)
var2 := $(var)  #Normal assignment (phép gán bình thường)
var3 ?= $(var)  #Test assignment (phép gán kiểm tra)

var := "2"

rule3: 
	@echo "$(var1)"
	@echo "$(var2)"
	@echo "$(var3)"

rule1:
	echo "123"

rule2:
	@echo "123"
```

Run code:
```
make -f test1.mk rule3                                                    
2
1
3
```

- Recursive assignment: When the value of ```var``` changes, the value of ```var1``` also changes
- Normal assignment: The value of ```var2``` is equal to the value of original ```var```
- Test assignment: Check if the value of ```var3``` already exists (tồn tại), if it exists, then equal it value.

Difference between ```@echo``` and ```echo```:
- echo:
```
make -f test1.mk rule1                                                    
echo "123"
123
```
- @echo:
```
make -f test1.mk rule2                                                    
123
```
### Special variables and ```echo``` in Makefile
Code:
```
.PHONY: test

test: test.c test.h abc.h
	@echo $@
	@echo $<
	@echo $^
```

Run code:
```
make -f test4.mk test

test
test.c
test.c test.h abc.h
```

- ```$@```: is the value before ```:``` (test)
- ```$<```: is the first value after ```:``` (test.c)
- ```$^```: is all values after ```:``` (test.c test.h abc.h)

### Include
Code:
- test.h
```
#include <stdio.h>
void printfHello();
```
- test.c
```
#include <test.h>
void printfHello()
{
    printf("Hello World\n");
}
```
- main.c
```
#include <test.h>
int main()
{
    printfHello();
    return 1;
}
```

Makefile:
```
.PHONY: all build clean

all: main.c test.c
	gcc -c main.c -o main.o -I.
	gcc -c test.c -o test.o -I.

build: main.o test.o
	gcc -o app.exe main.o test.o

clean:
	rm *.o app.exe
```
- ```-I.```: used when ```.h``` file is in the same folder
- If it's in a different folder, use ```-I./<folder name>```

Run code:
```
make -f test5.mk all                                                      
gcc -c main.c -o main.o -I.
gcc -c test.c -o test.o -I.

make -f test5.mk build                                                    
gcc -o app.exe main.o test.o

./app.exe                                                      
Hello World

make clean                                                    
rm app.exe
```


