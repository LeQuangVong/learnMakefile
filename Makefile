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