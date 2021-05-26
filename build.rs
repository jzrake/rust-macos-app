fn main() {
    println!("cargo:rustc-link-lib=framework=CoreFoundation");
    println!("cargo:rustc-link-lib=framework=Cocoa");
    cc::Build::new().file("src/app.m").compile("app.a");
    cc::Build::new().file("src/core_graphics.m").compile("core_graphics.a");
    cc::Build::new().file("src/cf_string.m").compile("cf_string.a");
}
