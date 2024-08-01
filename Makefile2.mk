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