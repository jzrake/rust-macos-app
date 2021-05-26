#import "CoreFoundation/CoreFoundation.h"

void* cf_string_create(const void* data, unsigned long length)
{

}

void cf_string_delete(const void* cf_string)
{
	CFRelease(cf_string);
}
