pub mod reg_imm_test;
pub mod reg_reg_test;
mod tests;

/// Probability ALU module is disabled during testing
const DISABLE_PROBABILITY: f64 = 0.20;

/// Probability ALU right shift is arithmetic vs logical
const ARITHMETIC_SHIFT_PROBABILITY: f64 = 0.50;

/// Functions ALU can compute
#[derive(Debug, PartialEq)]
enum AluFunct {
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
}

/// ALU state containing inputs and output.
pub struct AluState {
    inputs: AluInputs,
    result: Option<u32>,
}

impl AluState {
    pub fn new(inputs: AluInputs) -> Self {
        Self {
            result: AluState::compute_result(&inputs),
            inputs,
        }
    }

    pub fn inputs(&self) -> &AluInputs {
        &self.inputs
    }

    pub fn result(&self) -> &Option<u32> {
        &self.result
    }

    /// Computes output of alu from inputs. Returns `Some(u32)` if enabled and
    /// `None` if disabled.
    // ```
    // # use test_generation::alu::{AluFunct, AluInputs};
    // let sra_inputs = AluInputs::new(
    //     false,                  // enable_n
    //     AluFunct::SR.into(),    // funct3
    //     true,                   // arithmetic_shift
    //     0x12345678,             // a
    //     0x00000008,             // shamt; only lowest 5 bits are used
    // );
    // let sra_output = sra_inputs.compute_result();
    // assert_eq!(sra_output, Some(0x00123456));
    // ```
    //
    // ```
    // # use test_generation::alu::{AluFunct, AluInputs};
    // let hi_z_inputs = AluInputs::new(
    //     true,                   // enable_n
    //     AluFunct::AND.into(),   // funct3
    //     false,                  // arithmetic_shift
    //     0x76543210,             // a
    //     0x01234567,             // b
    // );
    // let hi_z_output = hi_z_inputs.compute_result();
    // assert_eq!(hi_z_output, None);
    // ```
    fn compute_result(inputs: &AluInputs) -> Option<u32> {
        if inputs.enable_n {
            return None;
        }

        let shamt = inputs.b & 0x1f;
        Some(match AluFunct::from(inputs.funct3) {
            AluFunct::ADD => match inputs.a.overflowing_add(inputs.b) {
                (value, _overflow) => value,
            },
            AluFunct::SLL => match inputs.a.overflowing_shl(shamt) {
                (value, _overflow) => value,
            },
            AluFunct::SLT => ((inputs.a as i32) < (inputs.b as i32)) as u32,
            AluFunct::SLTU => (inputs.a < inputs.b) as u32,
            AluFunct::XOR => inputs.a ^ inputs.b,
            AluFunct::SR => {
                if inputs.arithmetic_shift {
                    (inputs.a as i32 >> shamt) as u32
                } else {
                    inputs.a >> shamt
                }
            },
            AluFunct::OR => inputs.a | inputs.b,
            AluFunct::AND => inputs.a & inputs.b,
        })
    }
}

pub struct Alu {}

impl Alu {
    pub fn new() -> Alu {
        Self {}
    }

    pub fn get_state(&self, alu_inputs: AluInputs) -> AluState {
        AluState::new(alu_inputs)
    }
}
