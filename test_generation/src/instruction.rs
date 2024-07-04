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

    /// Generate 32 bit instruction from field values
    pub fn to_instruction(&self) -> u32 {
        (self.opcode as u32)
            | (self.rd as u32) << 7
            | (self.funct3 as u32) << 12
            | (self.rs1 as u32) << 15
            | (self.rs2 as u32) << 20
            | (self.funct7 as u32) << 25
    }
}

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

    /// Generate 32 bit instruction from field values
    pub fn to_instruction(&self) -> u32 {
        (self.opcode as u32)
            | (self.rd as u32) << 7
            | (self.funct3 as u32) << 12
            | (self.rs1 as u32) << 15
            | (self.imm as u32) << 20
    }
}
