//
//  CustomImage.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "CustomImage.h"

extern NSString *kDecodeKeyPrefix;

@implementation CustomImage
@synthesize imageResourceId;
@synthesize imageCaption;

- (id)initWithResourceID:(int)resourceID
                 caption:(NSString *)aImageCaption
{
    if (self = [super init]) {
        [self setImageResourceId:resourceID];
        [self setImageCaption:aImageCaption];
    }
    return self;
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[CustomImage alloc] init])
    {
        self.imageResourceId = [coder decodeIntForKey:[NSString stringWithFormat:@"%@CustomImageIDKey", kDecodeKeyPrefix]];
        self.imageCaption = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@CustomImageCaptionKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInt:imageResourceId forKey:[NSString stringWithFormat:@"%@CustomImageIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:imageCaption forKey:[NSString stringWithFormat:@"%@CustomImageCaptionKey", kDecodeKeyPrefix]];
}

-(NSString *) toString
{
    return self.imageCaption;
}

- (void)dealloc {
    [imageCaption release];
    [super dealloc];
}

@end
