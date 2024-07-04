use crate::instruction::{IType, RType};
use crate::test_vector::TestVector;

use rand::{rngs::StdRng, Rng};

pub const ALU_REG_IMM_OPCODE: u8 = 0x13;
pub const ALU_REG_REG_OPCODE: u8 = 0x33;

const DISABLE_PROBABILITY: f64 = 0.20;
const ARITHMETIC_SHIFT_PROBABILITY: f64 = 0.50;

/// ALU state containing inputs and output.
pub struct Alu {
    inputs: AluInputs,
    result: Option<u32>,
}

impl Alu {
    /// Create `Alu` state with inputs and outputs given inputs
    pub fn from(inputs: AluInputs) -> Alu {
        let result = inputs.compute_output();
        Alu { inputs, result }
    }

    /// Get inputs to `Alu`
    pub fn inputs(&self) -> &AluInputs {
        &self.inputs
    }

    /// Get result of `Alu` computation
    /// If result is `Some(value)`, then `value` will be set on ALU output bus.
    /// If result is `None`, then ALU output will be high impedance.
    pub fn result(&self) -> Option<u32> {
        self.result
    }
}

/// Inputs to ALU
pub struct AluInputs {
    enable_n: bool,
    funct3: u8,
    arithmetic_shift: bool,
    a: u32,
    b: u32,
}

impl AluInputs {
    /// Create new `AluInputs` struct
    pub fn new(
        enable_n: bool,
        funct3: u8,
        arithmetic_shift: bool,
        a: u32,
        b: u32,
    ) -> AluInputs {
        // only allow arithmetic shift on right shift funct
        if arithmetic_shift {
            assert_eq!(funct3, AluFunct::SR.into());
        }

        AluInputs {
            enable_n,
            funct3,
            arithmetic_shift,
            a,
            b,
        }
    }

    /// Computes output of alu from inputs. Returns `Some(u32)` if enabled and
    /// `None` if disabled.
    ///
    /// # Examples
    ///
    /// ```
    /// # use test_generation::alu::{AluFunct, AluInputs};
    /// let or_inputs = AluInputs::new(
    ///     false,                  // enable_n
    ///     AluFunct::OR.into(),    // funct3
    ///     false,                  // arithmetic_shift
    ///     0x55555555,             // a
    ///     0x66666666,             // b
    /// );
    /// let or_output = or_inputs.compute_output();
    /// assert_eq!(or_output, Some(0x77777777));
    /// ```
    ///
    /// ```
    /// # use test_generation::alu::{AluFunct, AluInputs};
    /// let sra_inputs = AluInputs::new(
    ///     false,                  // enable_n
    ///     AluFunct::SR.into(),    // funct3
    ///     true,                   // arithmetic_shift
    ///     0x12345678,             // a
    ///     0x00000008,             // shamt; only lowest 5 bits are used
    /// );
    /// let sra_output = sra_inputs.compute_output();
    /// assert_eq!(sra_output, Some(0x00123456));
    /// ```
    ///
    /// ```
    /// # use test_generation::alu::{AluFunct, AluInputs};
    /// let hi_z_inputs = AluInputs::new(
    ///     true,                   // enable_n
    ///     AluFunct::AND.into(),   // funct3
    ///     false,                  // arithmetic_shift
    ///     0x76543210,             // a
    ///     0x01234567,             // b
    /// );
    /// let hi_z_output = hi_z_inputs.compute_output();
    /// assert_eq!(hi_z_output, None);
    /// ```
    pub fn compute_output(&self) -> Option<u32> {
        if self.enable_n {
            return None;
        }

        let shamt = self.b & 0x1f;
        Some(match AluFunct::from(self.funct3) {
            AluFunct::ADD => match self.a.overflowing_add(self.b) {
                (value, _overflow) => value,
            },
            AluFunct::SLL => match self.a.overflowing_shl(shamt) {
                (value, _overflow) => value,
            },
            AluFunct::SLT => ((self.a as i32) < (self.b as i32)) as u32,
            AluFunct::SLTU => (self.a < self.b) as u32,
            AluFunct::XOR => self.a ^ self.b,
            AluFunct::SR => {
                if self.arithmetic_shift {
                    (self.a as i32 >> shamt) as u32
                } else {
                    self.a >> shamt
                }
            },
            AluFunct::OR => self.a | self.b,
            AluFunct::AND => self.a & self.b,
        })
    }
}

/// Functions ALU can compute
#[derive(Debug, PartialEq)]
pub enum AluFunct {
    ADD = 0,
    SLL = 1,
    SLT = 2,
    SLTU = 3,
    XOR = 4,
    SR = 5,
    OR = 6,
    AND = 7,
}

impl From<u8> for AluFunct {
    /// Convert lowest 3 bits of a `u8` to `AluFunct`
    ///
    /// # Example
    ///
    /// ```
    /// # use test_generation::alu::AluFunct;
    /// let xor_code = 4;
    /// let alu_xor: AluFunct = xor_code.into();
    ///
    /// assert_eq!(alu_xor, AluFunct::XOR);
    /// ```
    fn from(funct3: u8) -> AluFunct {
        match funct3 & 0x07 {
            0 => AluFunct::ADD,
            1 => AluFunct::SLL,
            2 => AluFunct::SLT,
            3 => AluFunct::SLTU,
            4 => AluFunct::XOR,
            5 => AluFunct::SR,
            6 => AluFunct::OR,
            7 => AluFunct::AND,
            _ => unreachable!(),
        }
    }
}

impl From<AluFunct> for u8 {
    /// Convert `AluFunct` to u8
    ///
    /// # Example
    ///
    /// ```
    /// # use test_generation::alu::AluFunct;
    /// let alu_and = AluFunct::AND;
    /// let and_code: u8 = alu_and.into();
    ///
    /// assert_eq!(and_code, 7);
    /// ```
    fn from(alu_funct: AluFunct) -> Self {
        alu_funct as u8
    }
}

/// Test vector for ALU register-immediate operations
pub struct AluRegImmTestVector {
    instruction: IType,
    alu: Alu,
}

impl AluRegImmTestVector {
    /// Create new test vector
    pub fn new(instruction: IType, alu: Alu) -> AluRegImmTestVector {
        AluRegImmTestVector { instruction, alu }
    }

    /// Get test vector instruction
    pub fn instruction(&self) -> &IType {
        &self.instruction
    }

    /// Get test vector ALU state
    pub fn alu(&self) -> &Alu {
        &self.alu
    }
}

impl TestVector for AluRegImmTestVector {
    /// Generate test vector with random inputs
    fn random(rng: &mut StdRng) -> AluRegImmTestVector {
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
            a: rng.gen(), // *rs1
            b: instruction.imm() as u32,
        };

        AluRegImmTestVector {
            instruction,
            alu: Alu::from(alu_inputs),
        }
    }

    /// Represent a test vector as a `String`. High impedance values are
    /// represented by "z".
    ///
    /// # Examples
    ///
    /// ```
    /// # use test_generation::alu::{
    /// #     ALU_REG_IMM_OPCODE,
    /// #     Alu,
    /// #     AluFunct,
    /// #     AluInputs,
    /// #     AluRegImmTestVector,
    /// # };
    /// # use test_generation::instruction::IType;
    /// # use test_generation::test_vector::TestVector;
    /// #
    /// let and_vector = AluRegImmTestVector::new(
    ///     IType::new(
    ///         ALU_REG_IMM_OPCODE,     // opcode
    ///         14,                     // rd
    ///         AluFunct::AND.into(),   // funct3
    ///         28,                     // rs1
    ///         0x555,                  // imm
    ///     ),
    ///     Alu::from(AluInputs::new(
    ///         false,                  // enable_n
    ///         AluFunct::AND.into(),   // funct3
    ///         false,                  // arithmetic_shift
    ///         0x33333333,             // a: *x28
    ///         0x00000555,             // b: imm
    ///     )),
    /// );
    ///
    /// assert_eq!(
    ///     and_vector.to_string(),
    ///     "555e7713 0 33333333 00000555 7 0 00000111\n"
    /// );
    /// ```
    ///
    /// ```
    /// # use test_generation::alu::{
    /// #     ALU_REG_IMM_OPCODE,
    /// #     Alu,
    /// #     AluFunct,
    /// #     AluInputs,
    /// #     AluRegImmTestVector,
    /// # };
    /// # use test_generation::instruction::IType;
    /// # use test_generation::test_vector::TestVector;
    /// #
    /// let hi_z_vector = AluRegImmTestVector::new(
    ///     IType::new(
    ///         ALU_REG_IMM_OPCODE,     // opcode
    ///         18,                     // rd
    ///         AluFunct::XOR.into(),   // funct3
    ///         3,                      // rs1
    ///         0x02a,                  // imm
    ///     ),
    ///     Alu::from(AluInputs::new(
    ///         true,                   // enable_n
    ///         AluFunct::XOR.into(),   // funct3
    ///         false,                  // arithmetic_shift
    ///         0x45454545,             // a: *x3
    ///         0x0000002a,             // b: imm
    ///     )),
    /// );
    ///
    /// assert_eq!(
    ///     hi_z_vector.to_string(),
    ///     "02a1c913 1 45454545 0000002a 4 0 zzzzzzzz\n"
    /// );
    /// ```
    fn to_string(&self) -> String {
        format!(
            "{:08x} {:01x} {:08x} {:08x} {:01x} {:01x} {}\n",
            self.instruction.to_instruction(),
            self.alu().inputs().enable_n as u8,
            self.alu().inputs().a,
            self.alu().inputs().b,
            self.alu().inputs().funct3,
            self.alu().inputs().arithmetic_shift as u8,
            match self.alu.result {
                Some(n) => format!("{n:08x}"),
                None => "zzzzzzzz".to_string(),
            }
        )
    }
}

/// Test vector for ALU register-register operations
pub struct AluRegRegTestVector {
    instruction: RType,
    alu: Alu,
}

impl AluRegRegTestVector {
    /// Create new test vector
    pub fn new(instruction: RType, alu: Alu) -> AluRegRegTestVector {
        AluRegRegTestVector { instruction, alu }
    }

    /// Get test vector instruction
    pub fn instruction(&self) -> &RType {
        &self.instruction
    }

    /// Get test vector ALU state
    pub fn alu(&self) -> &Alu {
        &self.alu
    }
}

impl TestVector for AluRegRegTestVector {
    /// Generate test vector with random inputs
    fn random(rng: &mut StdRng) -> AluRegRegTestVector {
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
            alu: Alu::from(alu_inputs),
        }
    }

    /// Represent a test vector as a `String`. High impedance values are
    /// represented by "z".
    ///
    /// # Examples
    ///
    /// ```
    /// # use test_generation::alu::{
    /// #     ALU_REG_REG_OPCODE,
    /// #     Alu,
    /// #     AluFunct,
    /// #     AluInputs,
    /// #     AluRegRegTestVector,
    /// # };
    /// # use test_generation::instruction::RType;
    /// # use test_generation::test_vector::TestVector;
    /// #
    /// let and_vector = AluRegRegTestVector::new(
    ///     RType::new(
    ///         ALU_REG_REG_OPCODE,     // opcode
    ///         14,                     // rd
    ///         AluFunct::AND.into(),   // funct3
    ///         28,                     // rs1
    ///         2,                      // rs2
    ///         0x00,                   // funct7
    ///     ),
    ///     Alu::from(AluInputs::new(
    ///         false,                  // enable_n
    ///         AluFunct::AND.into(),   // funct3
    ///         false,                  // arithmetic_shift
    ///         0x33333333,             // a: *x28
    ///         0x55555555,             // b: *x2
    ///     )),
    /// );
    ///
    /// assert_eq!(
    ///     and_vector.to_string(),
    ///     "002e7733 0 33333333 55555555 7 0 11111111\n"
    /// );
    /// ```
    ///
    /// ```
    /// # use test_generation::alu::{
    /// #     ALU_REG_REG_OPCODE,
    /// #     Alu,
    /// #     AluFunct,
    /// #     AluInputs,
    /// #     AluRegRegTestVector,
    /// # };
    /// # use test_generation::instruction::RType;
    /// # use test_generation::test_vector::TestVector;
    /// #
    /// let hi_z_vector = AluRegRegTestVector::new(
    ///     RType::new(
    ///         ALU_REG_REG_OPCODE,     // opcode
    ///         18,                     // rd
    ///         AluFunct::XOR.into(),   // funct3
    ///         3,                      // rs1
    ///         31,                     // rs2
    ///         0x00,                   // funct7
    ///     ),
    ///     Alu::from(AluInputs::new(
    ///         true,                   // enable_n
    ///         AluFunct::XOR.into(),   // funct3
    ///         false,                  // arithmetic_shift
    ///         0x45454545,             // a: *x3
    ///         0x2a2a2a2a,             // b: *x31
    ///     )),
    /// );
    ///
    /// assert_eq!(
    ///     hi_z_vector.to_string(),
    ///     "01f1c933 1 45454545 2a2a2a2a 4 0 zzzzzzzz\n"
    /// );
    /// ```
    fn to_string(&self) -> String {
        format!(
            "{:08x} {:01x} {:08x} {:08x} {:01x} {:01x} {}\n",
            self.instruction.to_instruction(),
            self.alu().inputs().enable_n as u8,
            self.alu().inputs().a,
            self.alu().inputs().b,
            self.alu().inputs().funct3,
            self.alu().inputs().arithmetic_shift as u8,
            match self.alu.result {
                Some(n) => format!("{n:08x}"),
                None => "zzzzzzzz".to_string(),
            }
        )
    }
}
