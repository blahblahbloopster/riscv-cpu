pub mod reg_imm_test;
pub mod reg_reg_test;

#[cfg(test)]
mod tests;

/// Probability ALU module is disabled during testing
const PROB_DISABLE: f64 = 0.20;

/// Probability of changing ADD to SUB or SRL to SRA
const PROB_ALTERNATE_FUNC: f64 = 0.50;

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
    fn from(alu_funct: AluFunct) -> Self {
        alu_funct as u8
    }
}

/// Inputs to ALU
pub struct AluInputs {
    enable_n: bool,
    funct3: u8,
    alt_func: bool,
    a: u32,
    b: u32,
}

impl AluInputs {
    /// Create new `AluInputs` struct
    pub fn new(
        enable_n: bool,
        funct3: u8,
        alt_func: bool,
        a: u32,
        b: u32,
    ) -> AluInputs {
        // only allow changing ADD to SUB or SRL to SRA
        if alt_func {
            assert!(
                funct3 == AluFunct::SR.into() || funct3 == AluFunct::ADD.into()
            );
        }

        AluInputs {
            enable_n,
            funct3,
            alt_func,
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
    fn compute_result(inputs: &AluInputs) -> Option<u32> {
        if inputs.enable_n {
            return None;
        }

        let shamt = inputs.b & 0x1f;
        Some(match AluFunct::from(inputs.funct3) {
            AluFunct::ADD => {
                if inputs.alt_func {
                    match inputs.a.overflowing_sub(inputs.b) {
                        (value, _overflow) => value,
                    }
                } else {
                    match inputs.a.overflowing_add(inputs.b) {
                        (value, _overflow) => value,
                    }
                }
            },
            AluFunct::SLL => match inputs.a.overflowing_shl(shamt) {
                (value, _overflow) => value,
            },
            AluFunct::SLT => ((inputs.a as i32) < (inputs.b as i32)) as u32,
            AluFunct::SLTU => (inputs.a < inputs.b) as u32,
            AluFunct::XOR => inputs.a ^ inputs.b,
            AluFunct::SR => {
                if inputs.alt_func {
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
