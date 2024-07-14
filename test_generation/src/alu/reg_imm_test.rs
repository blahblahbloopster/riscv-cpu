use super::AluFunct;
use super::AluInputs;
use super::AluState;
use super::ARITHMETIC_SHIFT_PROBABILITY;
use super::DISABLE_PROBABILITY;
use crate::cpu::Cpu;
use crate::instruction::i_type::IType;
use crate::instruction::InstructionType;
use crate::test_vector::TestVector;
use rand::Rng;

const ALU_REG_IMM_OPCODE: u8 = 0x13;

/// Test vector for ALU register-immediate operations
pub struct AluRegImmTestVector {
    instruction: IType,
    alu_state: AluState,
}

impl AluRegImmTestVector {
    /// Create new test vector
    pub fn new(instruction: IType, alu_state: AluState) -> AluRegImmTestVector {
        AluRegImmTestVector {
            instruction,
            alu_state,
        }
    }

    /// Get test vector instruction
    pub fn instruction(&self) -> &IType {
        &self.instruction
    }

    /// Get test vector ALU state
    pub fn alu_state(&self) -> &AluState {
        &self.alu_state
    }
}

fn sign_extend_u12(value: u16) -> u32 {
    if value & 0x800 == 0 {
        value as u32
    } else {
        value as u32 | 0xfffff000
    }
}

impl TestVector for AluRegImmTestVector {
    /// Generate test vector with random inputs
    fn random(cpu: &mut Cpu) -> AluRegImmTestVector {
        let rng = cpu.rng();
        let instruction = IType::new(
            ALU_REG_IMM_OPCODE,
            rng.gen(),
            rng.gen(),
            rng.gen(),
            rng.gen(),
        );

        let alu_inputs = AluInputs {
            enable_n: rng.gen_bool(DISABLE_PROBABILITY),
            funct3: instruction.funct3(),
            arithmetic_shift: {
                if AluFunct::from(instruction.funct3()) == AluFunct::SR {
                    rng.gen_bool(ARITHMETIC_SHIFT_PROBABILITY)
                } else {
                    false
                }
            },
            a: rng.gen(), // rs1 data
            b: sign_extend_u12(instruction.imm()),
        };

        AluRegImmTestVector {
            instruction,
            alu_state: cpu.alu().get_state(alu_inputs),
        }
    }

    /// Represent a test vector as a `String`. High impedance values are
    /// represented by "z".
    ///
    /// # Examples
    ///
    // ```
    // # use test_generation::alu::{
    // #     ALU_REG_IMM_OPCODE,
    // #     Alu,
    // #     AluFunct,
    // #     AluInputs,
    // #     AluRegImmTestVector,
    // # };
    // # use test_generation::instruction::IType;
    // # use test_generation::test_vector::TestVector;
    // #
    // let and_vector = AluRegImmTestVector::new(
    //     IType::new(
    //         ALU_REG_IMM_OPCODE,     // opcode
    //         14,                     // rd
    //         AluFunct::AND.into(),   // funct3
    //         28,                     // rs1
    //         0x555,                  // imm
    //     ),
    //     Alu::from(AluInputs::new(
    //         false,                  // enable_n
    //         AluFunct::AND.into(),   // funct3
    //         false,                  // arithmetic_shift
    //         0x33333333,             // a: *x28
    //         0x00000555,             // b: imm
    //     )),
    // );
    //
    // assert_eq!(
    //     and_vector.to_string(),
    //     "555e7713 0 33333333 00000555 7 0 00000111\n"
    // );
    // ```
    //
    // ```
    // # use test_generation::alu::{
    // #     ALU_REG_IMM_OPCODE,
    // #     Alu,
    // #     AluFunct,
    // #     AluInputs,
    // #     AluRegImmTestVector,
    // # };
    // # use test_generation::instruction::IType;
    // # use test_generation::test_vector::TestVector;
    // #
    // let hi_z_vector = AluRegImmTestVector::new(
    //     IType::new(
    //         ALU_REG_IMM_OPCODE,     // opcode
    //         18,                     // rd
    //         AluFunct::XOR.into(),   // funct3
    //         3,                      // rs1
    //         0x02a,                  // imm
    //     ),
    //     Alu::from(AluInputs::new(
    //         true,                   // enable_n
    //         AluFunct::XOR.into(),   // funct3
    //         false,                  // arithmetic_shift
    //         0x45454545,             // a: *x3
    //         0x0000002a,             // b: imm
    //     )),
    // );
    //
    // assert_eq!(
    //     hi_z_vector.to_string(),
    //     "02a1c913 1 45454545 0000002a 4 0 zzzzzzzz\n"
    // );
    // ```
    fn to_string(&self) -> String {
        format!(
            "{:08x} {:01x} {:08x} {:08x} {:01x} {:01x} {}\n",
            self.instruction.to_u32(),
            self.alu_state.inputs.enable_n as u8,
            self.alu_state.inputs.a,
            self.alu_state.inputs.b,
            self.alu_state.inputs.funct3,
            self.alu_state.inputs.arithmetic_shift as u8,
            match self.alu_state.result() {
                Some(n) => format!("{n:08x}"),
                None => "zzzzzzzz".to_string(),
            }
        )
    }
}
