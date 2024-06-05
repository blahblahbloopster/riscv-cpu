CC = clang
CFLAGS = -Wall -Wextra -Wpedantic -O3

SRC = ./program_counter_test_generator.c
EXE = ./program_counter_test_generator

all: $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(EXE)

clean:
	rm $(EXE)
