pub mod core_graphics;

#[repr(C)]
pub struct ForeignView {
    draw: extern fn(*const std::ffi::c_void),
    handle: extern fn(*mut std::ffi::c_void),
    state: *mut std::ffi::c_void,
}

extern "C" {
    pub fn liquid_launch_app(view: ForeignView);
    pub fn liquid_draw_text(text: *const u8, length: usize);
    pub fn liquid_get_current_context() -> *const std::ffi::c_void;
}

pub fn draw_text(text: &str) {
    unsafe {
        liquid_draw_text(text.as_ptr(), text.len())
    }
}

extern "C" fn render_view<V: App>(data: *const std::ffi::c_void) {
    let view: &V = unsafe {
         &*(data as *const V)
    };
    view.render();
}

extern "C" fn handle_event<V: App>(data: *mut std::ffi::c_void) {
    let view: &mut V = unsafe {
         &mut *(data as *mut V)
    };
    view.handle();
}

trait App {
    fn render(&self);
    fn handle(&mut self);
}

fn run<V: App>(mut view: V) {
    let view = ForeignView {
        draw: render_view::<V>,
        handle: handle_event::<V>,
        state: &mut view as *mut V as *mut std::ffi::c_void,
    };
    unsafe {
        liquid_launch_app(view)
    }
}


struct MyApp {
    text: String
}

impl App for MyApp {
    fn render(&self) {
        draw_text(&self.text);
    }
    fn handle(&mut self) {
        self.text += "o";
    }
}

fn main() {
    let state = MyApp{text: "hello".into()};
    run(state);
}
