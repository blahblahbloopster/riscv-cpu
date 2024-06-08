#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define VECTOR_FILE "alu_imm_tests.tv"
#define NUM_TESTS 10

typedef struct {
    bool enable_n;
    uint32_t instruction;
    uint32_t register_src_data;
    uint32_t alu_out;
} Inputs;

typedef struct {
    uint8_t register_src;  // 5 bits
    uint32_t alu_a;
    uint32_t alu_b;
    uint8_t alu_op;  // 3 bits
    bool alu_signal;
    uint8_t register_dest;  // 5 bits
    uint32_t register_dest_data;
} Outputs;

typedef struct {
    Inputs inputs;
    Outputs expected;
} TestVector;

typedef struct {
    char register_src[3];
    char alu_a[9];
    char alu_b[9];
    char alu_op[2];
    char alu_signal[2];
    char register_dest[3];
    char register_dest_data[9];
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
        tv.inputs.register_src_data = random();
        tv.expected.alu_a = random();
        tv.expected.alu_b = random();
        tv.expected.alu_op = random() & 0x07;
        uint32_t immediate;
        uint8_t shamt;
        if (tv.expected.alu_op == 1) {  // left shift
            immediate = 0;
            shamt = random() & 0x1f;  // 5 bits
        } else if (tv.expected.alu_op == 5) {  // right shift
            immediate = random() & 0x00000020;
            shamt = random() & 0x1f;  // 5 bits
        } else {
            shamt = 0;
            immediate = random() & 0x00000fff;  // 12 bits
            if (immediate &  0x00000800 && tv.expected.alu_op != 3) {
                immediate |= 0xfffff000;   // sign extend
            }
        }
        switch (tv.expected.alu_op) {
            case 0:
                tv.inputs.alu_out = tv.inputs.register_src_data + immediate;
                break;
            case 1:
                tv.inputs.alu_out = tv.inputs.register_src_data << shamt;
                break;
            case 2:
                tv.inputs.alu_out = (tv.inputs.register_src_data < immediate)
                                  ? 0x00000001 : 0x00000000;
                break;
            case 3:
                tv.inputs.alu_out = (tv.inputs.register_src_data < immediate)
                                  ? 0x00000001 : 0x00000000;
                break;
            case 4:
                tv.inputs.alu_out = tv.inputs.register_src_data ^ immediate;
                break;
            case 5:
                tv.inputs.alu_out = tv.inputs.register_src_data & immediate;
                break;
            case 6:
                tv.inputs.alu_out = tv.inputs.register_src_data | immediate;
                break;
            case 7:
                tv.inputs.alu_out = tv.inputs.register_src_data >> shamt;
                if (immediate & 0x20 && tv.inputs.alu_out & 0x00000800) {
                    tv.inputs.alu_out |= 0xfffff000;
                }
                break;
        }
        tv.expected.alu_signal = tv.expected.alu_op == 5 && immediate & 0x20;
        tv.expected.register_src = random() & 0x1f;   // 5 bits
        tv.expected.register_dest = random() & 0x1f;  // 5 bits
        tv.inputs.instruction = (0x00000013)
                              | (tv.expected.register_dest << 7)
                              | (tv.expected.alu_op << 12)
                              | (tv.expected.register_src << 15)
                              | ((immediate | shamt) << 20);

        high_impedance = tv.inputs.enable_n;
        if (!high_impedance) {
            sprintf(output_strings.register_src, "%02x", tv.expected.register_src);
            sprintf(output_strings.alu_a, "%08x", tv.expected.alu_a);
            sprintf(output_strings.alu_b, "%08x", tv.expected.alu_b);
            sprintf(output_strings.alu_op, "%01x", tv.expected.alu_op);
            sprintf(output_strings.alu_signal, "%01x", tv.expected.alu_signal);
            sprintf(output_strings.register_dest, "%02x", tv.expected.register_dest);
            sprintf(output_strings.register_dest_data, "%08x", tv.expected.register_dest_data);
        } else {
            strncpy(output_strings.register_src, "zz", 2);
            strncpy(output_strings.alu_a, "zzzzzzzz", 8);
            strncpy(output_strings.alu_b, "zzzzzzzz", 8);
            strncpy(output_strings.alu_op, "z", 1);
            strncpy(output_strings.alu_signal, "z", 1);
            strncpy(output_strings.register_dest, "zz", 2);
            strncpy(output_strings.register_dest_data, "zzzzzzzz", 8);
        }

        printf(
               "   alu op: %01x\n"
               "immediate: %03x\n"
               "    shamt: %02x\n"
               "\n",
               tv.expected.alu_op,
               immediate,
               shamt
        );

        fprintf(vector_file,
                "%x %08x %s %08x %s %s %s %s %08x %s %s\n",
                tv.inputs.enable_n,
                tv.inputs.instruction,
                output_strings.register_src,
                tv.inputs.register_src_data,
                output_strings.alu_a,
                output_strings.alu_b,
                output_strings.alu_op,
                output_strings.alu_signal,
                tv.inputs.alu_out,
                output_strings.register_dest,
                output_strings.register_dest_data
        );
    }

    fclose(vector_file);
    return EXIT_SUCCESS;
}

