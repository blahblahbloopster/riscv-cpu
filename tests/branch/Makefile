CC = clang
CFLAGS = -Wall -Wextra -Wpedantic -O3

SRC = ./branch_test_generator.c
EXE = ./branch_test_generator

all: $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(EXE)

clean:
	rm $(EXE)
