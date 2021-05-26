#import "CoreFoundation/CoreFoundation.h"
#import "CoreText/CoreText.h"

CFMutableAttributedStringRef cf_attributed_string_create(const void* cfString)
{
    CFAttributedStringRef attrString = CFAttributedStringCreate(NULL, cfString, NULL);
    CFMutableAttributedStringRef mutAttrString = CFAttributedStringCreateMutableCopy(NULL, 0, attrString);
    return mutAttrString;
}

void cf_attributed_string_delete(const void* mutAttrString)
{
    CFRelease(mutAttrString);
}
