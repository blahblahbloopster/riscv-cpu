#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define VECTOR_FILE "program_counter_tests.tv"
#define NUM_TESTS 100000
#define CODE_START 0x80000000
#define PC_STEP 4

int main(void) {
    srand(0);

    FILE* vector_file = fopen(VECTOR_FILE, "w");
    assert(vector_file);

    uint32_t pc = CODE_START;
    bool high_impedance = false;

    for (int test_num = 0; test_num < NUM_TESTS; ++test_num) {
        const uint8_t reset_n = (test_num == 0) ? 0 : random() % 32 != 0;
        const uint8_t enable_n = random() % 4 == 0;
        const uint8_t load = random() % 8 == 0;
        const uint32_t new_address = (random() << 2) | 0x80000000;

        high_impedance = false;
        if (enable_n) {
            high_impedance = true;
        } else if (!reset_n) {
            pc = CODE_START;
        } else if (load) {
            pc = new_address;
        } else {
            pc += PC_STEP;
        }

        char address[9];
        if (high_impedance) {
            sprintf(address, "zzzzzzzz");
        } else {
            sprintf(address, "%08x", pc);
        }

        fprintf(vector_file, "%x %x %x %08x %s\n", reset_n, enable_n, load,
                new_address, address);
    }

    fclose(vector_file);

    return EXIT_SUCCESS;
}


