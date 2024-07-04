use rand::rngs::StdRng;
use std::error::Error;
use std::fs::File;
use std::io;
use std::io::Write;
use std::path::PathBuf;

pub trait TestVector {
    fn random(rng: &mut StdRng) -> Self;
    fn to_string(&self) -> String;
}

pub fn generate_vectors<T: TestVector>(
    vector_file_path: PathBuf,
    num_vectors: usize,
    rng: &mut StdRng,
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
        let vector: T = T::random(rng);
        vector_file.write(vector.to_string().as_bytes())?;
    }

    Ok(())
}

fn path_to_str(path: &PathBuf) -> Result<&str, io::Error> {
    match path.to_str() {
        Some(string) => Ok(string),
        None => {
            return Err(io::Error::new(
                io::ErrorKind::NotFound,
                "Could not determine crate root directory.",
            )
            .into());
        },
    }
}

