/// ALU functionality, ALU register-immediate and register-register test vectors
pub mod alu;

/// Branch module logic
pub mod branch;

/// Contains all shared resources
pub mod cpu;

/// Instruction type definitions and respective functions
pub mod instruction;

/// Generation of test vectors
pub mod vector_generation;

/// Register and Register Array
pub mod register;

/// Program Counter interface
pub mod program_counter;

/// Generic test vector definitions
pub mod test_vector;
