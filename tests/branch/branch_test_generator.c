#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define VECTOR_FILE "branch_tests.tv"
#define NUM_TESTS 500

typedef struct {
    bool enable_n;
    uint32_t instruction;
    uint32_t program_counter;
    uint32_t register_data_1;
    uint32_t register_data_2;
    uint32_t alu_out;
} Inputs;

typedef struct {
    uint8_t register_1;  // 5 bits
    uint8_t register_2;  // 5 bits
    uint32_t alu_a;
    uint32_t alu_b;
    uint8_t alu_op;  // 3 bits
    bool load_new_pc;
    uint32_t new_pc;
} Outputs;

typedef struct {
    Inputs inputs;
    Outputs expected;
} TestVector;

typedef struct {
    char register_1[3];
    char register_2[3];
    char alu_a[9];
    char alu_b[9];
    char alu_op[2];
    char load_new_pc[2];
    char new_pc[9];
} OutputStrings;

int main(void) {
    srand(0);

    FILE* vector_file = fopen(VECTOR_FILE, "w");
    assert(vector_file);

    bool high_impedance = false;
    TestVector tv;
    OutputStrings output_strings;

    for (int test_num = 0; test_num < NUM_TESTS; ++test_num) {
        tv.inputs.enable_n = random() % 4 == 0;
        tv.inputs.program_counter = random();
        tv.inputs.register_data_1 = random();
        tv.inputs.register_data_2
                = __builtin_popcount(tv.inputs.register_data_1) % 4 == 0
                        ? tv.inputs.register_data_1
                        : random();
        tv.inputs.alu_out = random();

        tv.expected.register_1 = random() & 0x1f;
        tv.expected.register_2 = random() & 0x1f;
        tv.expected.alu_op = random() % 3 + 2;
        if (tv.expected.alu_op & 0x04) {
            tv.inputs.alu_out &= 0x00000001;
        }

        const uint16_t offset = random() & 0x0fff;  // 12 bits
        tv.inputs.instruction
                = (0x00000063)  // branch opcode
                | (tv.expected.alu_op << 11) | ((offset & 0x0400) << 6)
                | ((offset & 0x000f) << 7) | ((offset & 0x03f0) << 24)
                | ((offset & 0x0800) << 30) | (tv.expected.register_1 << 14)
                | (tv.expected.register_2 << 19);

        tv.expected.alu_a = tv.inputs.register_data_1;
        tv.expected.alu_b = tv.inputs.register_data_2;

        high_impedance = tv.inputs.enable_n;
        if (!high_impedance) {
            tv.expected.load_new_pc = tv.inputs.alu_out;
            tv.expected.new_pc = tv.inputs.program_counter + offset;

            sprintf(output_strings.register_1, "%02x", tv.expected.register_1);
            sprintf(output_strings.register_2, "%02x", tv.expected.register_2);
            sprintf(output_strings.alu_a, "%08x", tv.expected.alu_a);
            sprintf(output_strings.alu_b, "%08x", tv.expected.alu_b);
            sprintf(output_strings.alu_op, "%01x", tv.expected.alu_op);
            sprintf(output_strings.load_new_pc, "%01x",
                    tv.expected.load_new_pc);
            sprintf(output_strings.new_pc, "%08x", tv.expected.new_pc);
        } else {
            strncpy(output_strings.register_1, "zz", 2);
            strncpy(output_strings.register_2, "zz", 2);
            strncpy(output_strings.alu_a, "zzzzzzzz", 8);
            strncpy(output_strings.alu_b, "zzzzzzzz", 8);
            strncpy(output_strings.alu_op, "z", 1);
            strncpy(output_strings.load_new_pc, "z", 1);
            strncpy(output_strings.new_pc, "zzzzzzzz", 8);
        }

        fprintf(vector_file,
                "%x %08x %08x %s %s %08x %08x %s %s %s %08x %s %s\n",
                tv.inputs.enable_n, tv.inputs.instruction,
                tv.inputs.program_counter, output_strings.register_1,
                output_strings.register_2, tv.inputs.register_data_1,
                tv.inputs.register_data_2, output_strings.alu_a,
                output_strings.alu_b, output_strings.alu_op, tv.inputs.alu_out,
                output_strings.load_new_pc, output_strings.new_pc);
    }

    fclose(vector_file);

    return EXIT_SUCCESS;
}


