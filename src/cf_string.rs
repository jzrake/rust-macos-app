use std::os::raw::c_void;

extern "C" {
    pub fn cf_string_create(data: *const u8, length: usize) -> *const c_void;
    pub fn cf_string_length(data: *const c_void) -> usize;
    pub fn cf_string_delete(cf_string: *const c_void);
}

pub struct CFString {
    _r: String,
    cf: *const c_void,
}

impl CFString {
    pub fn len(&self) -> usize {
        unsafe {
            cf_string_length(self.cf)
        }
    }
}

impl<T> From<T> for CFString where T: Into<String> {
    fn from(t: T) -> Self {
        unsafe {
            let rs: String = t.into();
            let cf = cf_string_create(rs.as_ptr(), rs.len());
            Self { _r: rs, cf }
        }
    }
}

impl Drop for CFString {
    fn drop(&mut self) {
        unsafe {
            cf_string_delete(self.cf);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn can_create_and_drop_cf_string() {
        let s = CFString::from("Hello!");
        assert_eq!(s.len(), s._r.len());
    }
}
