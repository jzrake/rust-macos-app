#import "Cocoa/Cocoa.h"

void* CGContextGetCurrent() {
    return NSGraphicsContext.currentContext.CGContext;
}
