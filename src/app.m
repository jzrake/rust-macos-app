#import "Cocoa/Cocoa.h"



struct ForeignView {
    void (*draw)(void*);
    void* state;
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
@end


@interface Delegate: NSObject<NSApplicationDelegate> {
    struct ForeignView foreignView;
}
@end

@implementation Delegate {
}

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
        initWithContentRect:NSMakeRect(0, 0, 200, 200)
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

void app_launch(struct ForeignView view)
{
    NSApplication* app = [NSApplication sharedApplication];
    [app setDelegate:[[Delegate alloc] initWithForeignView:view]];
    [app run];
}

void ct_draw_text(const char* text)
{
    id string = [NSString stringWithUTF8String:text];
    [string drawAtPoint:NSMakePoint(0, 0) withAttributes:nil];
}
