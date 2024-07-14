use crate::instruction::InstructionType;

/// I-type instruction
pub struct IType {
    opcode: u8,
    rd: u8,
    funct3: u8,
    rs1: u8,
    imm: u16,
}

impl IType {
    /// Create an I-type instruction. Input values are trimmed to size.
    pub fn new(opcode: u8, rd: u8, funct3: u8, rs1: u8, imm: u16) -> IType {
        IType {
            opcode: opcode & 0x3f,
            rd: rd & 0x1f,
            funct3: funct3 & 0x07,
            rs1: rs1 & 0x1f,
            imm: imm & 0x0fff,
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

    /// Get instruction immediate value
    pub fn imm(&self) -> u16 {
        self.imm
    }
}

impl InstructionType for IType {
    /// Generate 32 bit instruction from field values
    fn to_u32(&self) -> u32 {
        (self.opcode as u32)
            | (self.rd as u32) << 7
            | (self.funct3 as u32) << 12
            | (self.rs1 as u32) << 15
            | (self.imm as u32) << 20
    }

    /// Decode IType fields from instruction
    fn decode(instruction: u32) -> Self {
        Self {
            opcode: ((instruction >> 00) & 0x3f) as u8,
            rd:     ((instruction >> 07) & 0x1f) as u8,
            funct3: ((instruction >> 12) & 0x07) as u8,
            rs1:    ((instruction >> 15) & 0x1f) as u8,
            imm:    ((instruction >> 20) & 0xfff) as u16,
        }
    }
}
