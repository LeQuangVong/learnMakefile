.PHONY: build run clean

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