use clap::{Parser, Subcommand};
use image::{imageops::FilterType, GenericImageView, ImageReader};
use log::{debug, info};
use material_colors::{
    color::Argb,
    hct::Hct,
    score::Score,
    quantize::{Quantizer, QuantizerCelebi},
};
use rayon::prelude::*;
use std::error::Error;
use std::path::PathBuf;

#[derive(Parser)]
#[command(version, about = "HCT Calculator", long_about = None)]
struct Cli {
    #[command(subcommand)]
    output_type: OutputType,

    #[arg(long, default_value_t = 128)]
    size: u32,

    #[arg(required = true)]
    image_path: PathBuf,
}

#[derive(Subcommand, Debug)]
enum OutputType {
    Hue,
    Chroma,
    Tone,
}

fn main() -> Result<(), Box<dyn Error>> {
    env_logger::init();
    let (image_path, output_type, size) = parse_args()?;

    info!("Processing image: {}", image_path);
    let (hue, chroma, tone) = get_image_hct(&image_path, size)?;

    debug!(
        "Final HCT values - Hue: {:.2}, Chroma: {:.2}, Tone: {:.2}",
        hue, chroma, tone
    );

    match output_type {
        OutputType::Hue => println!("{:.0}", hue),
        OutputType::Chroma => println!("{:.0}", chroma),
        OutputType::Tone => println!("{:.0}", tone),
    }
    Ok(())
}

fn calculate_optimal_size(width: u32, height: u32, bitmap_size: u32) -> (u32, u32) {
    let image_area = f64::from(width * height);
    let bitmap_area = f64::from(bitmap_size.pow(2));
    let scale = (bitmap_area / image_area).sqrt().min(1.0);

    let new_width = (f64::from(width) * scale).round().max(1.0) as u32;
    let new_height = (f64::from(height) * scale).round().max(1.0) as u32;

    debug!(
        "Resizing from {}x{} to {}x{} (scale: {:.2})",
        width, height, new_width, new_height, scale
    );

    (new_width, new_height)
}

fn get_image_hct(path: &str, bitmap_size: u32) -> Result<(f64, f64, f64), Box<dyn Error>> {
    let mut img = ImageReader::open(path)
        .map_err(|e| format!("Failed to open image: {e}"))?
        .with_guessed_format()
        .map_err(|e| format!("Failed to detect image format: {e}"))?
        .decode()
        .map_err(|e| format!("Failed to decode image: {e}"))?;

    let (width, height) = img.dimensions();
    let (new_width, new_height) = calculate_optimal_size(width, height, bitmap_size);

    if new_width != width || new_height != height {
        info!(
            "Resizing image to {}x{} for processing",
            new_width, new_height
        );
        img = img.resize_exact(new_width, new_height, FilterType::CatmullRom);
    }

    let img = img.into_rgb8();
    debug!("Processing image with {} pixels", img.pixels().len());

    let argb_pixels: Vec<Argb> = img
        .par_pixels()
        .map(|p| Argb::from_u32(u32::from_be_bytes([255, p[0], p[1], p[2]])))
        .collect();

    info!(
        "Quantizing {} pixels into {} colors",
        argb_pixels.len(),
        bitmap_size
    );
    let mut quantizer = QuantizerCelebi::default();
    let quant_result = Quantizer::quantize(
        &mut quantizer,
        &argb_pixels,
        bitmap_size as usize,
        Some(true),
    );

    debug!(
        "Quantization produced {} colors",
        quant_result.color_to_count.len()
    );

    let scored_colors = Score::score(&quant_result.color_to_count, Some(1), None, Some(false));
    let main_scored_color = scored_colors.first().unwrap();
    debug!("Top scored color: {:?}", main_scored_color);

    let hct = Hct::new(*main_scored_color);

    info!(
        "Calculated HCT values: H{:.1} C{:.1} T{:.1}",
        hct.get_hue(),
        hct.get_chroma(),
        hct.get_tone()
    );

    Ok((hct.get_hue(), hct.get_chroma(), hct.get_tone()))
}

fn parse_args() -> Result<(String, OutputType, u32), Box<dyn std::error::Error>> {
    let cli = Cli::parse();
    Ok((
        cli.image_path.to_string_lossy().into_owned(),
        cli.output_type,
        cli.size,
    ))
}
