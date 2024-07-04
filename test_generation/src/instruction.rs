// enum Instruction {
//     RType(RType),
//     IType(IType),
//     SType(SType),
//     BType(BType),
//     UType(UType),
//     JType(JType),
// }

pub struct RType {
    opcode: u8,
    rd: u8,
    funct3: u8,
    rs1: u8,
    rs2: u8,
    funct7: u8,
}

impl RType {
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

    pub fn opcode(&self) -> u8 {
        self.opcode
    }

    pub fn rd(&self) -> u8 {
        self.rd
    }

    pub fn funct3(&self) -> u8 {
        self.funct3
    }

    pub fn rs1(&self) -> u8 {
        self.rs1
    }

    pub fn rs2(&self) -> u8 {
        self.rs2
    }

    pub fn funct7(&self) -> u8 {
        self.funct7
    }

    pub fn to_instruction(&self) -> u32 {
        (self.opcode as u32)
            | (self.rd as u32) << 7
            | (self.funct3 as u32) << 12
            | (self.rs1 as u32) << 15
            | (self.rs2 as u32) << 20
            | (self.funct7 as u32) << 25
    }
}

pub struct IType {
    opcode: u8,
    rd: u8,
    funct3: u8,
    rs1: u8,
    imm: u16,
}

impl IType {
    pub fn new(opcode: u8, rd: u8, funct3: u8, rs1: u8, imm: u16) -> IType {
        IType {
            opcode: opcode & 0x3f,
            rd: rd & 0x1f,
            funct3: funct3 & 0x07,
            rs1: rs1 & 0x1f,
            imm: imm & 0x0fff,
        }
    }

    pub fn opcode(&self) -> u8 {
        self.opcode
    }

    pub fn rd(&self) -> u8 {
        self.rd
    }

    pub fn funct3(&self) -> u8 {
        self.funct3
    }

    pub fn rs1(&self) -> u8 {
        self.rs1
    }

    pub fn imm(&self) -> u16 {
        self.imm
    }

    pub fn to_instruction(&self) -> u32 {
        (self.opcode as u32)
            | (self.rd as u32) << 7
            | (self.funct3 as u32) << 12
            | (self.rs1 as u32) << 15
            | (self.imm as u32) << 20
    }
}

// pub struct SType {
//     opcode: u8,
//     imm: u16,
//     funct3: u8,
//     rs1: u8,
//     rs2: u8,
// }

// impl SType {
//     fn new(opcode: u8, imm: u16, funct3: u8, rs1: u8, rs2: u8) -> SType {
//         SType {
//             opcode: opcode & 0x3f,
//             imm: imm & 0x0fff,
//             funct3: funct3 & 0x07,
//             rs1: rs1 & 0x1f,
//             rs2: rs2 & 0x1f,
//         }
//     }

//     fn to_instruction(&self) -> u32 {
//         (self.opcode as u32)
//             | (self.imm as u32 & 0x001f) << 7
//             | (self.funct3 as u32) << 12
//             | (self.rs1 as u32) << 15
//             | (self.rs2 as u32) << 15
//             | (self.imm as u32 & 0x0f70) << 25
//     }
// }

// pub struct BType {
//     opcode: u8,
//     imm: u16,
//     funct3: u8,
//     rs1: u8,
//     rs2: u8,
// }

// impl BType {
//     fn new(opcode: u8, imm: u16, funct3: u8, rs1: u8, rs2: u8) -> BType {
//         BType {
//             opcode: opcode & 0x3f,
//             imm: imm & 0x1ff7,
//             funct3: funct3 & 0x07,
//             rs1: rs1 & 0x1f,
//             rs2: rs2 & 0x1f,
//         }
//     }

//     fn to_instruction(&self) -> u32 {
//         (self.opcode as u32)
//             | (self.imm as u32 & 0x0400) << 7
//             | (self.imm as u32 & 0x0017) << 8
//             | (self.funct3 as u32) << 12
//             | (self.rs1 as u32) << 15
//             | (self.rs2 as u32) << 15
//             | (self.imm as u32 & 0x0370) << 25
//             | (self.imm as u32 & 0x0800) << 31
//     }
// }

// pub struct UType {
//     opcode: u8,
//     rd: u8,
//     imm: u32,
// }

// impl UType {
//     fn new(opcode: u8, rd: u8, imm: u32) -> UType {
//         UType {
//             opcode: opcode & 0x3f,
//             rd: rd & 0x1f,
//             imm: imm & 0x000fffff,
//         }
//     }

//     fn to_instruction(&self) -> u32 {
//         (self.opcode as u32) | (self.rd as u32) << 7 | self.imm << 12
//     }
// }

// pub struct JType {
//     opcode: u8,
//     rd: u8,
//     imm: u32,
// }

// impl JType {
//     fn new(opcode: u8, rd: u8, imm: u32) -> JType {
//         JType {
//             opcode: opcode & 0x3f,
//             rd: rd & 0x1f,
//             imm: imm & 0x001ffff7,
//         }
//     }

//     fn to_instruction(&self) -> u32 {
//         (self.opcode as u32)
//             | (self.rd as u32) << 7
//             | self.imm & 0x000ff000 << 12
//             | self.imm & 0x00000800 << 20
//             | self.imm & 0x000007f7 << 21
//             | self.imm & 0x00100000 << 31
//     }
// }
