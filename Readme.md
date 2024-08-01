### What is Makefile ?
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

### Four stages of compilation in the C Makefile

- Pre-compiling: 
	- Remove command
	- Expand (mở rộng) macros
	- Expand include files
	- Compile conditional statements (câu lệnh điều kiện)
	- The result obtained (thu được) is a ```.i``` file.
- Compilation: The source code will continue to compile from ```.i``` file and obtain a ```.s``` file (assembly)
- Assembly: Through the ```assembler```, the output we get is a ```.o``` file
- Linking: 
	- Each ```.o``` file obtained at the Assembly stage is part of the program.
	- The ```linking``` stage will link them to obtain a complete executable file

Code:
```
#include <stdio.h>

int main(){
    printf("Hello World");
}
```

Makefile:
```
.PHONY stage1 stage2 stage3 stage4 all clean

stage1: 
	gcc -E hello.c -o hello.i       #Pre-compiling

stage2:
	gcc -S hello.i -o hello.S       #Compiling

stage3:
	gcc -c hello.S -o hello.o       #Assembly

stage4: 
	gcc -o hello.exe hello.c        #Linking

all:
	gcc -o hello.exe hello.c
clean:
	rm hello.exe hello.i hello.S hello.o
```

Run code:
```
make -f test6.mk stage1                                                  
gcc -E hello.c -o hello.i

make -f test6.mk stage2                                                   
gcc -S hello.i -o hello.S

make -f test6.mk stage3                                                   
gcc -c hello.S -o hello.o

make -f test6.mk stage4                                                   
gcc -o hello.exe hello.c

./hello.exe                                                      
Hello World                             
```

### Folder structure

```
.
├── Inc
│   ├── hieu.h
│   └── tong.h
├── Makefile
├── Readme.md
├── Src
│   ├── hieu.c
│   └── tong.c
├── bin
│   └── out.exe
├── main.c
├── makefilerule-e1489805882799.png
└── obj
    ├── hieu.o
    ├── main.o
    └── tong.o
```

Code:
- hieu.h:
```
int tinh(int a, int b);
```
- tong.h:
```
int tinh(int a, int b);
```
- tong.c:
```
#include <stdio.h>
int tinh(int a, int b)
{
    return a + b;
}
```
- hieu.c:
```
#include <stdio.h>
int tinh(int a, int b)
{
    return a - b;
}
```
- main.c:
```
#include <stdio.h>
#include <hieu.h>
#include <tong.h>

int main()
{
    printf("%d",tinh(3,5));
}
```

Makefile:
```
.PHONY: all

CC := gcc
INC_FILE := ./Inc/tong.h
INC_FILE := ./Inc/hieu.h

%.o: $(INC_FILE)
	$(CC) -c Src/hieu.c -o obj/hieu.o -I./Inc
	$(CC) -c Src/tong.c -o obj/tong.o -I./Inc
	$(CC) -c main.c -o obj/main.o -I./Inc

tong: obj/tong.o obj/main.o 
	$(CC) -o bin/out.exe obj/tong.o obj/main.o

hieu: obj/hieu.o obj/main.o 
	$(CC) -o bin/out.exe obj/hieu.o obj/main.o

run:
	./bin/out.exe
clean:
	rm ./obj/*.o
```

- Variable:
	- The ```CC``` variable is defined to use ```gcc``` as the compiler
	- Define ```INC_FILE``` variable with path.
- Implicit rules: ```%.o: $(INC_FILE)```
	- This line defined the implicit rule for creating ```%.o``` oject file. The target is which files have the ```.o``` extention
	- Any oject files depend on the path, if the path changes then the files need to be recompiled.
- Formula:
	- Each ```$(CC)``` command compiles a different source file (```Src/hieu.c``` ```Src/tong.c``` ```main.c```) into corresponding oject files (```obj/hieu.o``` ```obj/tong.o``` ```obj/main.o```).
	- The ```-I./Inc``` flag specifiles that the compiler should look for header files in the ```./Inc``` directory.

Run code:
- Tong:
```
make tong                                                     
gcc -c Src/hieu.c -o obj/hieu.o -I./Inc
gcc -c Src/tong.c -o obj/tong.o -I./Inc
gcc -c main.c -o obj/main.o -I./Inc
gcc -o bin/out.exe obj/tong.o obj/main.o

make run                                                      
./bin/out.exe
8

make clean                                                    
rm ./obj/*.o
```
- Hieu:
```
make hieu                                                     
gcc -c Src/hieu.c -o obj/hieu.o -I./Inc
gcc -c Src/tong.c -o obj/tong.o -I./Inc
gcc -c main.c -o obj/main.o -I./Inc
gcc -o bin/out.exe obj/hieu.o obj/main.o

make run                                                      
./bin/out.exe
-2     

make clean 
rm ./obj/*.o
```

### Why do we have to build the ```.o``` file first ?
Because after having the ```.o``` file, we can select the ```.o``` file to link with ```linker``` to create an executable program

Ex: link ```tong.o``` and ```main.o``` to create ```out.exe```

### Update Makefile with ```Vpath``` and ```Automatic variable```
#### Vpath
Use Vpath to specify search directories for source and header files, minimizing the need to specify full paths in the rules
#### Automatic variable
- ```$@```: the name of current target (Target)
- ```$<```: the name of the first prerequisite (first prerequisite)
- ```$^```: list of prerequisites (prerequisites)
- ```$?```: The list of new prerequisite is larger than the target (new prerequisite)

Use automatic variable avoids having to rewrite file names and makes the formula more flexible.

Update Makefile code:
```
.PHONY: all

CC := gcc
INC_DIR := ./Inc
SRC_DIR := ./Src
OBJ_DIR := ./obj
BIN_DIR := ./bin

vpath %.c $(SRC_DIR)
vpath %.h $(INC_DIR)

OBJ_FILES := $(OBJ_DIR)/hieu.o $(OBJ_DIR)/tong.o $(OBJ_DIR)/main.o

$(OBJ_DIR)/%.o: %.c $(INC_DIR)/tong.h $(INC_DIR)/hieu.h
	$(CC) -c $< -o $@ -I$(INC_DIR)

tong: $(OBJ_FILES)
	$(CC) -o $(BIN_DIR)/out.exe $(OBJ_DIR)/tong.o $(OBJ_DIR)/main.o

hieu: $(OBJ_FILES)
	$(CC) -o $(BIN_DIR)/out.exe $(OBJ_DIR)/hieu.o $(OBJ_DIR)/main.o

run:
	./$(BIN_DIR)/out.exe
clean:
	rm -f $(BIN_DIR)/*.o $(BIN_DIR)/out.exe
```
- Variable difinition:
	- ```INC_DIR```,```SRC_DIR```, ```OBJ_DIR```, ```BIN_DIR```: Difines directories for header files, source files, object files, and the directory containing the executable files.
- Vpath:
	- Vpath specifies the directory into which ```make``` will search for source (```%.c```) and header files (```%.h```). This eliminates the need to specify full paths in rules.
- General rules for object files:
	- To create ```.o``` file, ```make``` will look for the corresponding ```.c``` file and header file (```tong.h```, ```hieu.h```) in ```INC_DIR```
	- ```$<```: is an automatic variable representing the source file (```%.c```)
	- ```$@```: is an automatic variable representing the object file.
```
$(OBJ_DIR)/%.o: %.c $(INC_DIR)/tong.h $(INC_DIR)/hieu.h
	$(CC) -c $< -o $@ -I$(INC_DIR)
```
- Executable file creation rules:
	- These rules create the ```out.exe``` executable from the corresponding object files (```tong.o``` and ```main.o``` for ```tong```)

```
tong: $(OBJ_FILES)
	$(CC) -o $(BIN_DIR)/out.exe $(OBJ_DIR)/tong.o $(OBJ_DIR)/main.o
```
### Update Makefile with ```Wildcard```
Using ```Wildcard``` in a ```Makefile``` helps automate searching and listing files, making your ```Makefile``` more flexible and easier to maintain when adding or removing source files in your project.

Update Makefile code:
```
.PHONY: all

CC := gcc
INC_DIR := ./Inc
SRC_DIR := ./Src
OBJ_DIR := ./obj
BIN_DIR := ./bin

SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
INC_FILES := $(wildcard $(INC_DIR)/*.h)

OBJ_FILES := $(patsubst $(SRC_DIR)/*.c, $(OBJ_DIR)/*.o, $(SRC_FILES))

vpath %.c $(SRC_DIR)
vpath %.h $(INC_DIR)

$(OBJ_DIR)/%.o: %.c $(INC_FILES)
	$(CC) -c $< -o $@ -I$(INC_DIR)

tong: $(OBJ_DIR)/tong.o $(OBJ_DIR)/main.o 
	$(CC) -o $(BIN_DIR)/out.exe $(OBJ_DIR)/tong.o $(OBJ_DIR)/main.o

hieu: $(OBJ_DIR)/hieu.o $(OBJ_DIR)/main.o 
	$(CC) -o $(BIN_DIR)/out.exe $(OBJ_DIR)/hieu.o $(OBJ_DIR)/main.o

run:
	./$(BIN_DIR)/out.exe
clean:
	rm -f $(BIN_DIR)/*.o $(BIN_DIR)/out.exe
```
- Wildcard:
	- ```SRC_FILES := $(wildcard $(SRC_DIR)/*.c)```: find all ```.c``` files in ```Src``` directory.
	- ```INC_FILES := $(wildcard $(INC_DIR)/*.h)```: find all ```.h``` files in ```Inc``` directory.
- Convert source file to object file:
	- ```OBJ_FILES := $(patsubst $(SRC_DIR)/*.c, $(OBJ_DIR)/*.o, $(SRC_FILES))```: using ```patsubst``` to convert ```.c``` files in ```SRC_FILES``` to ```.o``` files in ```OBJ_DIR```.
### Create Makefile with ```Foreach```, ```notdir```
#### Foreach
Use ```foreach``` allows iterating through a list of values and performing an action on each value in that list.
```
$(foreach var, list, text)
```
- ```var```: iterative variable, representing each element in the list.
- ```list```: List of values to iterate through
- ```text```: Text or action to be performed for each value in the list.
#### Notdir
Using ```notdir``` eliminates the path of the filename, keeping only the filename and extention.
```
$(notdir names...)  #names...: list of filenames or full paths
```

Makefile:
```
.PHONY: build clean

CC := gcc
INC_DIR := ./Inc
SRC_DIR := ./Src
OBJ_DIR := ./obj
BIN_DIR := ./bin

SRC_FILES := $(foreach SRC_DIR, $(SRC_DIR), $(wildcard $(SRC_DIR)/*.c))
INC_FILES := $(foreach INC_DIR, $(INC_DIR), $(wildcard $(INC_DIR)/*.h))

OBJ_FILES := $(notdir $(SRC_FILES))
OBJ_FILES := $(subst .c,.o, $(OBJ_FILES))
PATH_OBJS := $(foreach OBJ_FILES, $(OBJ_FILES), $(OBJ_DIR)/$(OBJ_FILES))

vpath %.c $(SRC_DIR)
vpath %.h $(INC_DIR)

build: $(OBJ_FILES)
	$(CC) $(PATH_OBJS) -o $(BIN_DIR)/app.exe
	./$(BIN_DIR)/app.exe

%.o: %.c $(INC_FILES)
	$(CC) -I$(INC_DIR) -c $< -o $(OBJ_DIR)/$@
clean:
	rm -rf $(BIN_DIR)/* $(OBJ_DIR)/*
```
- Declare variables and folders:
	```
	CC := gcc
	INC_DIR := ./Inc
	SRC_DIR := ./Src
	OBJ_DIR := ./obj
	BIN_DIR := ./bin
	```
	- ```CC```: variable to specify the compiler
	- ```INC_DIR```: Directory containing header files (.h)
	- ```SRC_DIR```: Directory containing source files (.c)
	- ```OBJ_DIR```: Directory containing object files (.o)
	- ```BIN_DIR```: Directory containing executable files (.exe)
- Declare source and header files:
	```
	SRC_FILES := $(foreach SRC_DIR, $(SRC_DIR), $(wildcard $(SRC_DIR)/*.c))
	INC_FILES := $(foreach INC_DIR, $(INC_DIR), $(wildcard $(INC_DIR)/*.h))
	```
	- ```SRC_FILES```: Use ```foreach``` and ```wildcard``` to list all ```.c``` files in ```SRC_DIR```.
	- ```INC_FILES```: Use ```foreach``` and ```wildcard``` to list all ```.h``` files in ```INC_DIR```.
- Declare object files:
	```
	OBJ_FILES := $(notdir $(SRC_FILES))
	OBJ_FILES := $(subst .c,.o, $(OBJ_FILES))
	PATH_OBJS := $(foreach OBJ_FILES, $(OBJ_FILES), $(OBJ_DIR)/$(OBJ_FILES))
	```
	- ```OBJ_FILES```: use ```notdir``` to remove file path and keep only to file name.
	- Use ```subst``` to replace ```.c``` with ```.o```, convert source files to corresponding (tương ứng) object files.
	- ```PATH_OBJS```: Use ```foreach``` to add ```OBJ_DIR``` directory path to each object files.
- File search rules:
	```
	vpath %.c $(SRC_DIR)
	vpath %.h $(INC_DIR)
	```
	- ```vpath```: specifies where to search for source and header files.
- Build rule:
	```
	build: $(OBJ_FILES)
	$(CC) $(PATH_OBJS) -o $(BIN_DIR)/app.exe
	./$(BIN_DIR)/app.exe
	```
	- ```build```: This target will compile the object files and link them into an executable.
	- ```$(CC) $(PATH_OBJS) -o $(BIN_DIR)/app.exe```: Link object files into an excutable.
- Rules for creating object files:
	```
	%.o: %.c $(INC_FILES)
	$(CC) -I$(INC_DIR) -c $< -o $(OBJ_DIR)/$@
	```
	- ```%.o: %.c $(INC_FILES)```: Sample rule to compile ```.c``` file to ```.o``` file.
	- ```$(CC) -I$(INC_DIR) -c $< -o $(OBJ_DIR)/$@```: The command compiles ```.c``` file into ```.o``` file, including the header directory.
#### Basename 
Using ```basename``` removes the filename extention, leaving only the filename.
```
$(basename names...)   #names...: list of filenames or full paths
```
#### Using ```define```, ```call``` create a rule template definition
- ```Define```: Defines a block of code, similar to defining a function or macro.
- ```Call```: Calls and evaluates (đánh giá) the defined block of code with specific parameters
```
define name
text ...
endef
```
- ```name```: The name of definition
- ```text```: the content of the definition, which may include parameters such as ```$(1)```, ```$(2)```,vv
```
$(call name, param1, param2,...)
```
- ```name```: the name of definition
- ```param1```, ```param2```: Parameters passed (truyền) to definition

#### Eval
Helps scale and evaluate dynamic text content, allowing for efficient and flexible creation of rules and variations
```
$(eval test)
```
### Makefile use automatic variable
```
.PHONY: build clean

CC := gcc
INC_DIR := ./Inc
SRC_DIR := ./Src
OBJ_DIR := ./obj
BIN_DIR := ./bin

SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
INC_FILES := $(wildcard $(INC_DIR)/*.h)

OBJ_FILES := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC_FILES))

vpath %.c $(SRC_DIR)
vpath %.h $(INC_DIR)

build: $(OBJ_FILES)
	$(CC) $(OBJ_FILES) -o $(BIN_DIR)/app.exe
	./$(BIN_DIR)/app.exe

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(INC_FILES)
	$(CC) -I$(INC_DIR) -c $< -o $@

clean:
	rm -f $(OBJ_DIR)/*.o $(BIN_DIR)/app.exe
```
- Declare variables and folders:
	```
	CC := gcc
	INC_DIR := ./Inc
	SRC_DIR := ./Src
	OBJ_DIR := ./obj
	BIN_DIR := ./bin
	```
	- ```CC```: variable to specify the compiler
	- ```INC_DIR```: Directory containing header files (.h)
	- ```SRC_DIR```: Directory containing source files (.c)
	- ```OBJ_DIR```: Directory containing object files (.o)
	- ```BIN_DIR```: Directory containing executable files (.exe)
- Declare source and header files:
	```
	SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
	INC_FILES := $(wildcard $(INC_DIR)/*.h)
	```
	- ```SRC_FILES```: Use ```wildcard``` to search all ```.c``` files in ```SRC_DIR``` and save into ```SRC_FILES```
	- ```INC_FILES```: Use ```wildcard``` to search all ```.h``` files in ```INC_DIR``` and save into ```INC_FILES```.
- Declare object file:
	```
	OBJ_FILES := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRC_FILES))
	```
	- ```OBJ_FILES```: use ```patsubst``` to convert ```.c``` file in ```SRC_DIR``` to corresponing ```.o``` file in ```OBJ_DIR```

- File search rules:
	```
	vpath %.c $(SRC_DIR)
	vpath %.h $(INC_DIR)
	```
	- ```vpath```: specifies where to search for source and header files.
- Build rule:
	```
	build: $(OBJ_FILES)
	$(CC) $(OBJ_FILES) -o $(BIN_DIR)/app.exe
	./$(BIN_DIR)/app.exe
	```
	- ```build```: This target will compile the object files and link them into an executable.
	- ```$(CC) $(OBJ_FILES) -o $(BIN_DIR)/app.exe```: Link object files into an excutable.
- Rules for creating object files:
	```
	$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(INC_FILES)
		$(CC) -I$(INC_DIR) -c $< -o $@
	```
	- ```$(OBJ_DIR)/%.o: %.c $(INC_FILES)```: Sample rule to compile ```.c``` file to ```.o``` file. ```.o``` file will be saved in ```OBJ_DIR``` directory.
	- ```$(CC) -I$(INC_DIR) -c $< -o $@```: The command compiles ```.c``` file into ```.o``` file, including the header directory.
	- ```$<``` represents the source file and ```$@``` represents the object file.

- ```%```: Represents a portion of the filename that the makefile can change dynamically, allows you to define rules for multiple files without having to list them one by one.
Ex:
```
$(OBJ_DIR)/file.o = $(OBJ_DIR)/%.o
$(OBJ_DIR)/file.c = $(OBJ_DIR)/%.c
```
- ```*```: used to list files in directories that have a certain extention.
Ex:
```
SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
INC_FILES := $(wildcard $(INC_DIR)/*.h)
```