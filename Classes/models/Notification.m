//
//  Notification.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "Notification.h"

extern NSString *kDecodeKeyPrefix;

@implementation Notification
@synthesize _id, originatingUserFirstName, originatingUserLastName, message;
@synthesize userId, sourceEventId;
@synthesize originatingUserId;
@synthesize state, type, date, amount;
@synthesize imageDefaultIndex;

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[Notification alloc] init])
    {
        self._id = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@NotificationIDKey", kDecodeKeyPrefix]];
        self.userId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@NotificationUserIDKey", kDecodeKeyPrefix]];
        self.state = [coder decodeIntForKey:[NSString stringWithFormat:@"%@NotificationStateKey", kDecodeKeyPrefix]];
        self.date = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@NotificationDateUpdatedKey", kDecodeKeyPrefix]];
        self.type = [coder decodeIntForKey:[NSString stringWithFormat:@"%@NotificationTypeKey", kDecodeKeyPrefix]];
        self.amount = [coder decodeDoubleForKey:[NSString stringWithFormat:@"%@NotificationAmountKey", kDecodeKeyPrefix]];

        self.sourceEventId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@NotificationEventKey", kDecodeKeyPrefix]];
        self.originatingUserId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@NotificationOrigUserIDKey", kDecodeKeyPrefix]];
		self.originatingUserFirstName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@NotificationFirstNameKey", kDecodeKeyPrefix]];
        self.originatingUserLastName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@NotificationLastNameKey", kDecodeKeyPrefix]];
        self.message = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@NotificationMessageKey", kDecodeKeyPrefix]];
        self.imageDefaultIndex = [coder decodeIntForKey:[NSString stringWithFormat:@"%@NotificationIamgeIndexKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_id forKey:[NSString stringWithFormat:@"%@NotificationIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:userId forKey:[NSString stringWithFormat:@"%@NotificationUserIDKey", kDecodeKeyPrefix]];
    [coder encodeInt:state forKey:[NSString stringWithFormat:@"%@NotificationStateKey", kDecodeKeyPrefix]];
    [coder encodeObject:date forKey:[NSString stringWithFormat:@"%@NotificationDateUpdatedKey", kDecodeKeyPrefix]];
    [coder encodeInt:type forKey:[NSString stringWithFormat:@"%@NotificationTypeKey", kDecodeKeyPrefix]];
    [coder encodeDouble:amount forKey:[NSString stringWithFormat:@"%@NotificationAmountKey", kDecodeKeyPrefix]];
    [coder encodeObject:sourceEventId forKey:[NSString stringWithFormat:@"%@NotificationEventKey", kDecodeKeyPrefix]];
    [coder encodeObject:originatingUserId forKey:[NSString stringWithFormat:@"%@NotificationOrigUserIDKey", kDecodeKeyPrefix]];
	[coder encodeObject:originatingUserFirstName forKey:[NSString stringWithFormat:@"%@NotificationFirstNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:originatingUserLastName forKey:[NSString stringWithFormat:@"%@NotificationLastNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:message forKey:[NSString stringWithFormat:@"%@NotificationMessageKey", kDecodeKeyPrefix]];
    
    [coder encodeInt:imageDefaultIndex forKey:[NSString stringWithFormat:@"%@NotificationIamgeIndexKey", kDecodeKeyPrefix]];
}

-(NSString *) toString
{
    return _id;

}

-(BOOL) equals:(id)object
{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [((Notification *)object)._id isEqualToString:self._id];
}

- (void)dealloc {
    [_id release];
    [userId release];
    [date release];
    [sourceEventId release];
    [originatingUserId release];
	[originatingUserFirstName release];
    [originatingUserLastName release];
    [message release];
    
    [super dealloc];
}

@end
