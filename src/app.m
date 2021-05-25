#import "Cocoa/Cocoa.h"

@interface Delegate: NSObject<NSApplicationDelegate> {
}
@end

@implementation Delegate {
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

    id topMenu = [NSMenu new];
    id appMenu = [NSMenu new];
    id appItem = [NSMenuItem new];
    id quitMenuItem = [[NSMenuItem alloc]
        initWithTitle:[@"Quit " stringByAppendingString:appName]
        action:@selector(terminate:)
        keyEquivalent:@"q"];

    [NSApp setMainMenu:topMenu];
    [appMenu addItem:quitMenuItem];
    [topMenu addItem:appItem];
    [appItem setSubmenu:appMenu];
    [appMenu setTitle:appName];

    id window = [[NSWindow alloc]
        initWithContentRect:NSMakeRect(0, 0, 200, 200)
        styleMask:NSWindowStyleMaskTitled|NSWindowStyleMaskResizable|NSWindowStyleMaskClosable
        backing:NSBackingStoreBuffered
        defer:YES
    ];
    [window setTitle:appName];
    [window cascadeTopLeftFromPoint:NSMakePoint(20, 20)];
    [window makeKeyAndOrderFront:nil];
}

- (void) applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"Will terminate");
}

@end

void app_launch()
{
    NSApplication* app = [NSApplication sharedApplication];
    [app setDelegate:[Delegate new]];
    [app run];
}
