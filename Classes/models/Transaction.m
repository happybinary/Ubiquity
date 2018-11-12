//
//  Transaction.m
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import "Transaction.h"
#import "TransactionReactions.h"
#import "User.h"
#import "AppGlobalData.h"

extern NSString *kDecodeKeyPrefix;

@implementation Transaction
@synthesize _id, fromFirstName, fromLastName, dateCreated;
@synthesize description, fromUserId;
@synthesize toUserId, fromUsername, fromImageDefaultIndex;
@synthesize dateClosed, dateUpdated;
@synthesize requestDescription;
@synthesize amount, complete, visibility, type;
@synthesize toFirstName, toLastName, toUsername, toImageDefaultIndex;
@synthesize groupId;
@synthesize splitCorrelationId;
@synthesize reactions;

- (id)initWithRecipientId:(NSString *)recipientId
                     desc:(NSString *)aDescription
                    total:(double)aAmount
                  visible:(int)aVisibility
                transType:(TransactionStatus) aType
{
    if (self = [super init]) {
        if (aType == TRANSACTION_COMPLETE) {
            self.fromUserId =  [User getUser]._id;
            self.toUserId = recipientId;
        } else {
            self.fromUserId = recipientId;
            self.toUserId =  [User getUser]._id;
        }
        self.complete = aType;
        self.description = description;
        self.amount = amount;
        self.visibility = visibility;
        self.dateCreated = [AppGlobalData GetCurrentNZTimeString];
        self.dateUpdated = self.dateCreated;
    }
    
    return self;
}

-(NSString *) toString
{
    if (self.complete == TRANSACTION_COMPLETE) {
       
        if ( [[User getUser]._id isEqualToString:self.toUserId]) {
            return [NSString stringWithFormat:@"Received $%.2f from %@", self.amount, self.fromUserId];
        } else {
            return [NSString stringWithFormat:@"Paid $%.2f to %@", self.amount, self.toUserId];
        }
    } else {
        if ( [[User getUser]._id isEqualToString:self.toUserId]) {
            return [NSString stringWithFormat:@"Requesting $%.2f from %@", self.amount, self.fromUserId];
        } else {
            return [NSString stringWithFormat:@"Requested $%.2f to %@", self.amount, self.toUserId];
        }
    }

}
-(BOOL) isIncomingTransaction
{
    if (self.complete == TRANSACTION_INCOMPLETE &&  [[User getUser]._id isEqualToString:self.fromUserId]) {
        return YES;
    }
    return NO;
}
-(BOOL) isOutgoingTransaction
{
    if (self.complete == TRANSACTION_INCOMPLETE &&  [[User getUser]._id isEqualToString:self.toUserId]) {
        return YES;
    }
    return NO;
}
-(BOOL) isPaid
{
    if (self.complete == TRANSACTION_COMPLETE &&  [[User getUser]._id isEqualToString:self.toUserId]) {
        return YES;
    }
    return NO;
}
-(BOOL) isReceived
{
    if (self.complete == TRANSACTION_COMPLETE &&  [[User getUser]._id isEqualToString:self.toUserId]) {
        return YES;
    }
    return NO;
}
-(NSString *) getAmountString
{
    return [NSString stringWithFormat:@"$%.2f", self.amount];
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[Transaction alloc] init])
    {
        self._id = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionIDKey", kDecodeKeyPrefix]];
        self.description = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionDescriptionKey", kDecodeKeyPrefix]];
        self.amount = [coder decodeDoubleForKey:[NSString stringWithFormat:@"%@TransactionAmountKey", kDecodeKeyPrefix]];
        self.complete = [coder decodeIntForKey:[NSString stringWithFormat:@"%@TransactionCompleteKey", kDecodeKeyPrefix]];
        self.visibility = [coder decodeIntForKey:[NSString stringWithFormat:@"%@TransactionVisibilityKey", kDecodeKeyPrefix]];
        self.type = [coder decodeIntForKey:[NSString stringWithFormat:@"%@TransactionTypeKey", kDecodeKeyPrefix]];
        
        self.fromUserId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionFromUserIDKey", kDecodeKeyPrefix]];
        self.toUserId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionToUserIDKey", kDecodeKeyPrefix]];
        self.fromFirstName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionFromFirstNameKey", kDecodeKeyPrefix]];
        self.fromLastName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionFromLastNameKey", kDecodeKeyPrefix]];
        self.fromUsername = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionFromUserNameKey", kDecodeKeyPrefix]];
        self.fromImageDefaultIndex = [coder decodeIntForKey:[NSString stringWithFormat:@"%@TransactionFromIamgeIndexKey", kDecodeKeyPrefix]];
		
        self.toFirstName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionToFirstNameKey", kDecodeKeyPrefix]];
        self.toLastName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionToLastNameKey", kDecodeKeyPrefix]];
        self.toUsername = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionToUserNameKey", kDecodeKeyPrefix]];
        self.toImageDefaultIndex = [coder decodeIntForKey:[NSString stringWithFormat:@"%@TransactionToIamgeIndexKey", kDecodeKeyPrefix]];
        
        self.dateCreated = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionPhoneKey", kDecodeKeyPrefix]];
		self.dateClosed = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionEmailKey", kDecodeKeyPrefix]];
        self.dateUpdated = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionDateUpdatedKey", kDecodeKeyPrefix]];
        self.requestDescription = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionRequestDescriptionKey", kDecodeKeyPrefix]];
        self.groupId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionGroupIDKey", kDecodeKeyPrefix]];
        self.splitCorrelationId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionCorrelationKey", kDecodeKeyPrefix]];
        self.reactions = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@TransactionRectionListKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_id forKey:[NSString stringWithFormat:@"%@TransactionIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:description forKey:[NSString stringWithFormat:@"%@TransactionDescriptionKey", kDecodeKeyPrefix]];
    [coder encodeDouble:amount forKey:[NSString stringWithFormat:@"%@TransactionAmountKey", kDecodeKeyPrefix]];
    [coder encodeInt:complete forKey:[NSString stringWithFormat:@"%@TransactionCompleteKey", kDecodeKeyPrefix]];
    [coder encodeInt:visibility forKey:[NSString stringWithFormat:@"%@TransactionVisibilityKey", kDecodeKeyPrefix]];
     [coder encodeInt:type forKey:[NSString stringWithFormat:@"%@TransactionTypeKey", kDecodeKeyPrefix]];

    [coder encodeObject:fromUserId forKey:[NSString stringWithFormat:@"%@TransactionFromUserIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:toUserId forKey:[NSString stringWithFormat:@"%@TransactionToUserIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:fromFirstName forKey:[NSString stringWithFormat:@"%@TransactionFromFirstNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:fromLastName forKey:[NSString stringWithFormat:@"%@TransactionFromLastNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:fromUsername forKey:[NSString stringWithFormat:@"%@TransactionFromUserNameKey", kDecodeKeyPrefix]];
    [coder encodeInt:fromImageDefaultIndex forKey:[NSString stringWithFormat:@"%@TransactionFromIamgeIndexKey", kDecodeKeyPrefix]];
	
    [coder encodeObject:toFirstName forKey:[NSString stringWithFormat:@"%@TransactionToFirstNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:toLastName forKey:[NSString stringWithFormat:@"%@TransactionToLastNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:toUsername forKey:[NSString stringWithFormat:@"%@TransactionToUserNameKey", kDecodeKeyPrefix]];
    [coder encodeInt:toImageDefaultIndex forKey:[NSString stringWithFormat:@"%@TransactionToIamgeIndexKey", kDecodeKeyPrefix]];
    
    [coder encodeObject:dateCreated forKey:[NSString stringWithFormat:@"%@TransactionPhoneKey", kDecodeKeyPrefix]];
	[coder encodeObject:dateClosed forKey:[NSString stringWithFormat:@"%@TransactionEmailKey", kDecodeKeyPrefix]];
    [coder encodeObject:dateUpdated forKey:[NSString stringWithFormat:@"%@TransactionDateUpdatedKey", kDecodeKeyPrefix]];
    
    [coder encodeObject:requestDescription forKey:[NSString stringWithFormat:@"%@TransactionRequestDescriptionKey", kDecodeKeyPrefix]];
    [coder encodeObject:groupId forKey:[NSString stringWithFormat:@"%@TransactionGroupIDKey", kDecodeKeyPrefix]];
    [coder encodeObject:splitCorrelationId forKey:[NSString stringWithFormat:@"%@TransactionCorrelationKey", kDecodeKeyPrefix]];
    [coder encodeObject:reactions forKey:[NSString stringWithFormat:@"%@TransactionRectionListKey", kDecodeKeyPrefix]];
}

- (void)dealloc {
    [description release];
    [fromUserId release];
    [toUserId release];
    [fromUsername release];
	[fromFirstName release];
    [fromLastName release];
    [dateCreated release];
	[_id release];
    [toFirstName release];
    [toLastName release];
    [toUsername release];
	[dateClosed release];
    [dateUpdated release];
    [requestDescription release];
    [splitCorrelationId release];
    [groupId release];
    [reactions release];
    [super dealloc];
}

@end
