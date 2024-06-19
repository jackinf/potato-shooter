use bevy::prelude::Resource;
use clap::Parser;

#[derive(Parser, Resource, Debug, Clone)] // changed
pub struct Args {
    /// runs the game in synctest mode
    #[clap(long, default_value = "false")]
    pub synctest: bool,

    /// sets a custom input delay
    #[clap(long, default_value = "2")] // new
    pub input_delay: usize,
}
