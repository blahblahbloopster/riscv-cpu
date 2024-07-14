use crate::cpu::Cpu;
use std::error::Error;
use std::fs::File;
use std::io;
use std::io::Write;
use std::path::PathBuf;

/// Generic test vector. Should contain inputs and expected outputs.
pub trait TestVector {
    /// Generate test vector with random inputs.
    fn random(cpu: &mut Cpu) -> Self;

    /// Convert test vector to string representation. Used to write test vector
    /// to file.
    fn to_string(&self) -> String;
}

/// Randomly generate test vectors and write their string representation to the
/// provided file path.
pub fn generate_vectors<T: TestVector>(
    vector_file_path: PathBuf,
    num_vectors: usize,
    cpu: &mut Cpu,
) -> Result<(), Box<dyn Error>> {
    let mut vector_file = match File::create(&vector_file_path) {
        Ok(file) => file,
        Err(msg) => {
            return Err(format!(
                "Could not create file {}\n{}",
                path_to_str(&vector_file_path)?,
                msg,
            )
            .into());
        },
    };

    for _ in 0..num_vectors {
        let vector: T = T::random(cpu);
        vector_file.write(vector.to_string().as_bytes())?;
    }

    Ok(())
}

// Convert `PathBuf` to string
fn path_to_str(path: &PathBuf) -> Result<&str, io::Error> {
    match path.to_str() {
        Some(string) => Ok(string),
        None => {
            return Err(
                io::Error::new(io::ErrorKind::NotFound, "Invlid path").into(),
            );
        },
    }
}
