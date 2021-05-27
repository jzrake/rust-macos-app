#import "Cocoa/Cocoa.h"




struct ForeignView {
    void (*draw)(const void*);
    void (*handle)(void*);
    void *state;
};




@interface View: NSView {
    struct ForeignView foreignView;
}
@end

@implementation View
- (void)setForeignView:(struct ForeignView)view {
    self->foreignView = view;
}
- (void)drawRect:(NSRect)dirtyRect {
    self->foreignView.draw(self->foreignView.state);
}
- (void)mouseDown:(NSEvent *)event {
    self->foreignView.handle(self->foreignView.state);
    self.needsDisplay = true;
}
@end




@interface Delegate: NSObject<NSApplicationDelegate> {
    struct ForeignView foreignView;
}
@end

@implementation Delegate

-(id)initWithForeignView:(struct ForeignView)view
{
    if (self = [super init]) {
        self->foreignView = view;
    }
    return self;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    NSLog(@"Will finish launching");
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSLog(@"Did finish launching");

    id appName = @"Rust App";
    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [NSApp activateIgnoringOtherApps:YES];

    id appMenu = [NSMenu new];
    id topMenu = [NSMenu new];
    id topItem = [NSMenuItem new];
    id quitMenuItem = [[NSMenuItem alloc]
        initWithTitle:[@"Quit " stringByAppendingString:appName]
        action:@selector(terminate:)
        keyEquivalent:@"q"];

    [NSApp setMainMenu:topMenu];
    [appMenu addItem:quitMenuItem];
    [topMenu addItem:topItem];
    [topItem setSubmenu:appMenu];
    [appMenu setTitle:appName];

    View* view = [View new];
    [view setForeignView:self->foreignView];
    [view setWantsLayer:YES];
    [view.layer setDrawsAsynchronously:YES];

    id window = [[NSWindow alloc]
        initWithContentRect:NSMakeRect(0, 0, 600, 600)
        styleMask:NSWindowStyleMaskTitled|NSWindowStyleMaskResizable|NSWindowStyleMaskClosable
        backing:NSBackingStoreBuffered
        defer:YES
    ];
    [window setTitle:appName];
    [window cascadeTopLeftFromPoint:NSMakePoint(20, 20)];
    [window makeKeyAndOrderFront:nil];
    [window setContentView:view];
}

- (void) applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"Will terminate");
}
@end




void liquid_launch_app(struct ForeignView view)
{
    NSApplication* app = [NSApplication sharedApplication];
    [app setDelegate:[[Delegate alloc] initWithForeignView:view]];
    [app run];
}




void liquid_draw_text(void* text, unsigned long length)
{
    NSString *string = [[NSString alloc]
        initWithBytesNoCopy:text
        length:length
        encoding:NSUTF8StringEncoding
        freeWhenDone:NO];
    [string drawAtPoint:NSMakePoint(0, 0) withAttributes:nil];
}




CGContextRef liquid_get_current_context()
{
    return NSGraphicsContext.currentContext.CGContext;
}
