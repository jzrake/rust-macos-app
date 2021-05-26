use std::ffi;

extern "C" {
	pub fn CGContextSaveGState(context: *mut ffi::c_void);
	pub fn CGContextRestoreGState(context: *mut ffi::c_void);
	pub fn CGContextGetCurrent() -> *mut ffi::c_void;
}
