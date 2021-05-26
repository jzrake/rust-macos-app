#import "CoreFoundation/CoreFoundation.h"

CFStringRef cf_string_create(const char* data, unsigned long length)
{
    return CFStringCreateWithBytesNoCopy(
        NULL,
        (const UInt8*) data,
        length,
        kCFStringEncodingUTF8,
        NO,
        kCFAllocatorNull);
}

unsigned long cf_string_length(void* cf_string)
{
    return CFStringGetLength(cf_string);
}

void cf_string_delete(const void* cf_string)
{
    CFRelease(cf_string);
}
