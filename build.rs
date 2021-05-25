fn main() {
    println!("cargo:rustc-link-lib=framework=CoreFoundation");
    println!("cargo:rustc-link-lib=framework=Cocoa");
    cc::Build::new().file("src/app.m").compile("app.a");
}
