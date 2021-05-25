extern "C" {
    fn app_launch();
}

fn main() {
    unsafe {
        app_launch()
    }
}
