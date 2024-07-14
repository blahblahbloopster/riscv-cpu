use crate::instruction::InstructionType;

/// R-type instruction
pub struct RType {
    opcode: u8,
    rd: u8,
    funct3: u8,
    rs1: u8,
    rs2: u8,
    funct7: u8,
}

impl RType {
    /// Create an R-type instruction. Input values are trimmed to size.
    pub fn new(
        opcode: u8,
        rd: u8,
        funct3: u8,
        rs1: u8,
        rs2: u8,
        funct7: u8,
    ) -> RType {
        RType {
            opcode: opcode & 0x3f,
            rd: rd & 0x1f,
            funct3: funct3 & 0x07,
            rs1: rs1 & 0x1f,
            rs2: rs2 & 0x1f,
            funct7: funct7 & 0x7f,
        }
    }

    /// Get instruction opcode
    pub fn opcode(&self) -> u8 {
        self.opcode
    }

    /// Get instruction destination register
    pub fn rd(&self) -> u8 {
        self.rd
    }

    /// Get instruction 3-bit function
    pub fn funct3(&self) -> u8 {
        self.funct3
    }

    /// Get instruction source register 1
    pub fn rs1(&self) -> u8 {
        self.rs1
    }

    /// Get instruction source register 2
    pub fn rs2(&self) -> u8 {
        self.rs2
    }

    /// Get instruction 7-bit function
    pub fn funct7(&self) -> u8 {
        self.funct7
    }
}

impl InstructionType for RType {
    /// Generate 32 bit instruction from field values
    fn to_u32(&self) -> u32 {
        (self.opcode as u32)
            | (self.rd as u32) << 7
            | (self.funct3 as u32) << 12
            | (self.rs1 as u32) << 15
            | (self.rs2 as u32) << 20
            | (self.funct7 as u32) << 25
    }

    /// Decode RType fields from instruction
    fn decode(instruction: u32) -> Self {
        Self {
            opcode: ((instruction >> 00) & 0x3f) as u8,
            rd:     ((instruction >> 07) & 0x1f) as u8,
            funct3: ((instruction >> 12) & 0x07) as u8,
            rs1:    ((instruction >> 15) & 0x1f) as u8,
            rs2:    ((instruction >> 20) & 0x1f) as u8,
            funct7: ((instruction >> 25) & 0x7f) as u8,
        }
    }
}

