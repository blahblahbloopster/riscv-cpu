use crate::cpu::Cpu;
use crate::instruction::InstructionType;
use crate::instruction::r_type::RType;
use crate::test_vector::TestVector;
use super::AluFunct;
use super::AluInputs;
use super::AluState;
use super::ARITHMETIC_SHIFT_PROBABILITY;
use super::DISABLE_PROBABILITY;
use rand::Rng;

pub const ALU_REG_REG_OPCODE: u8 = 0x33;

/// Test vector for ALU register-register operations
pub struct AluRegRegTestVector {
    instruction: RType,
    alu_state: AluState,
}

impl AluRegRegTestVector {
    /// Create new test vector
    pub fn new(instruction: RType, alu_state: AluState) -> AluRegRegTestVector {
        AluRegRegTestVector {
            instruction,
            alu_state,
        }
    }

    /// Get test vector instruction
    pub fn instruction(&self) -> &RType {
        &self.instruction
    }

    /// Get test vector ALU state
    pub fn alu_state(&self) -> &AluState {
        &self.alu_state
    }
}

impl TestVector for AluRegRegTestVector {
    /// Generate test vector with random inputs
    fn random(cpu: &mut Cpu) -> AluRegRegTestVector {
        let rng = cpu.rng();
        let instruction = RType::new(
            ALU_REG_REG_OPCODE,
            rng.gen(),
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
            a: rng.gen(), // *rs1
            b: rng.gen(), // *rs2
        };

        AluRegRegTestVector {
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
    // #     ALU_REG_REG_OPCODE,
    // #     Alu,
    // #     AluFunct,
    // #     AluInputs,
    // #     AluRegRegTestVector,
    // # };
    // # use test_generation::instruction::RType;
    // # use test_generation::test_vector::TestVector;
    // #
    // let and_vector = AluRegRegTestVector::new(
    //     RType::new(
    //         ALU_REG_REG_OPCODE,     // opcode
    //         14,                     // rd
    //         AluFunct::AND.into(),   // funct3
    //         28,                     // rs1
    //         2,                      // rs2
    //         0x00,                   // funct7
    //     ),
    //     Alu::from(AluInputs::new(
    //         false,                  // enable_n
    //         AluFunct::AND.into(),   // funct3
    //         false,                  // arithmetic_shift
    //         0x33333333,             // a: *x28
    //         0x55555555,             // b: *x2
    //     )),
    // );
    //
    // assert_eq!(
    //     and_vector.to_string(),
    //     "002e7733 0 33333333 55555555 7 0 11111111\n"
    // );
    // ```
    //
    // ```
    // # use test_generation::alu::{
    // #     ALU_REG_REG_OPCODE,
    // #     Alu,
    // #     AluFunct,
    // #     AluInputs,
    // #     AluRegRegTestVector,
    // # };
    // # use test_generation::instruction::RType;
    // # use test_generation::test_vector::TestVector;
    // #
    // let hi_z_vector = AluRegRegTestVector::new(
    //     RType::new(
    //         ALU_REG_REG_OPCODE,     // opcode
    //         18,                     // rd
    //         AluFunct::XOR.into(),   // funct3
    //         3,                      // rs1
    //         31,                     // rs2
    //         0x00,                   // funct7
    //     ),
    //     Alu::from(AluInputs::new(
    //         true,                   // enable_n
    //         AluFunct::XOR.into(),   // funct3
    //         false,                  // arithmetic_shift
    //         0x45454545,             // a: *x3
    //         0x2a2a2a2a,             // b: *x31
    //     )),
    // );
    //
    // assert_eq!(
    //     hi_z_vector.to_string(),
    //     "01f1c933 1 45454545 2a2a2a2a 4 0 zzzzzzzz\n"
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
            match self.alu_state.result {
                Some(n) => format!("{n:08x}"),
                None => "zzzzzzzz".to_string(),
            }
        )
    }
}
