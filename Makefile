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