#[repr(C)]
pub struct ForeignView {
    draw: extern fn(*mut std::ffi::c_void),
    state: *mut std::ffi::c_void,
}

extern "C" {
    fn app_launch(view: ForeignView);
    fn ct_draw_text(text: *const u8);
}

pub fn draw_text(text: &str) {
    unsafe {
        ct_draw_text(text.as_ptr())
    }
}

struct State {
    text: String
}

fn main() {

    let mut state = State{text: "things".into()};
    let state_ptr = &mut state as *mut _ as *mut std::ffi::c_void;

    pub extern "C" fn render_view(data: *mut std::ffi::c_void) {
        let state: &mut State = unsafe {
             &mut *(data as *mut State)
        };
        draw_text(&state.text);
    }

    let view = ForeignView {
        draw: render_view,
        state: state_ptr,
    };

    unsafe {
        app_launch(view)
    }
}
