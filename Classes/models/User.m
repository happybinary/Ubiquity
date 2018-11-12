//
//  User.m
//  InformationPages Library
//
//  Created by Steve Ma on 06/01/2010.
//  Copyright 2009 InformationPages.com, Inc.. All rights reserved.
//

#import "User.h"

#import "Bank.h"
#import "CreditCard.h"
#import "Group.h"
#import "Friend.h"
#import "Notification.h"
#import "Transaction.h"
#import "UserSettings.h"

extern NSString *kDecodeKeyPrefix;

static User *STATIC_USER = nil;

@implementation User
@synthesize _id;
@synthesize name, balance, firstName, lastName, email, mobile, driversLicense, username, facebookId;
@synthesize bank;
@synthesize creditCards, groups, friendMap;
@synthesize personalTransactions, incomingTransactions, outgoingTransactions, friendsTransactions, publicTransactions, groupTransactions, notifications;
@synthesize imageDefaultIndex;
@synthesize userSettings;

- (id)init {
    if (self = [super init]) {
        
        self.creditCards = [NSMutableArray<CreditCard *> new];
        self.groups = [NSMutableArray<Group *> new];
        self.friendMap = [NSMutableDictionary<NSString *,Friend *> new];
        self.personalTransactions = [NSMutableArray<Transaction *> new];
        self.incomingTransactions = [NSMutableArray<Transaction *> new];
        self.outgoingTransactions = [NSMutableArray<Transaction *> new];
        self.friendsTransactions = [NSMutableArray<Transaction *> new];
        self.publicTransactions = [NSMutableArray<Transaction *> new];
        self.groupTransactions = [NSMutableDictionary<NSString *,NSMutableArray<Transaction *> *> new];
        self.notifications = [NSMutableArray<Notification *> new];
    }
    
    return self;
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [[User alloc] init])
    {
        self._id = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserIDKey", kDecodeKeyPrefix]];
		self.name = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserNameKey", kDecodeKeyPrefix]];
        self.balance = [coder decodeDoubleForKey:[NSString stringWithFormat:@"%@UserBalanceKey", kDecodeKeyPrefix]];
        self.firstName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserFirstNameKey", kDecodeKeyPrefix]];
        self.lastName = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserLastNameKey", kDecodeKeyPrefix]];
        self.email = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserEmailKey", kDecodeKeyPrefix]];
        self.mobile = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserMobileKey", kDecodeKeyPrefix]];
        self.driversLicense = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserLicenseKey", kDecodeKeyPrefix]];
        self.username = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserSelfNameKey", kDecodeKeyPrefix]];
        self.facebookId = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserFacebookKey", kDecodeKeyPrefix]];
        self.bank = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserBankKey", kDecodeKeyPrefix]];
        self.creditCards = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserCreditCardsKey", kDecodeKeyPrefix]];
        self.groups = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserGroupsKey", kDecodeKeyPrefix]];
        self.friendMap = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserFriendMapKey", kDecodeKeyPrefix]];
        self.personalTransactions = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserPersonalKey", kDecodeKeyPrefix]];
        self.incomingTransactions = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserIncomingKey", kDecodeKeyPrefix]];
        self.outgoingTransactions = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserOutgoingKey", kDecodeKeyPrefix]];
        self.friendsTransactions = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserFriendsTransKey", kDecodeKeyPrefix]];
        self.publicTransactions = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserPublicTransKey", kDecodeKeyPrefix]];
        self.groupTransactions = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserGroupTransKey", kDecodeKeyPrefix]];
        self.notifications = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserNotificationsKey", kDecodeKeyPrefix]];
        self.imageDefaultIndex = [coder decodeIntForKey:[NSString stringWithFormat:@"%@UserImageIndexKey", kDecodeKeyPrefix]];
        self.userSettings = [coder decodeObjectForKey:[NSString stringWithFormat:@"%@UserSettingsKey", kDecodeKeyPrefix]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_id forKey:[NSString stringWithFormat:@"%@UserIDKey", kDecodeKeyPrefix]];
	[coder encodeObject:name forKey:[NSString stringWithFormat:@"%@UserNameKey", kDecodeKeyPrefix]];
    [coder encodeDouble:balance forKey:[NSString stringWithFormat:@"%@UserBalanceKey", kDecodeKeyPrefix]];
    [coder encodeObject:firstName forKey:[NSString stringWithFormat:@"%@UserFirstNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:lastName forKey:[NSString stringWithFormat:@"%@UserLastNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:email forKey:[NSString stringWithFormat:@"%@UserEmailKey", kDecodeKeyPrefix]];
    [coder encodeObject:mobile forKey:[NSString stringWithFormat:@"%@UserMobileKey", kDecodeKeyPrefix]];
    [coder encodeObject:driversLicense forKey:[NSString stringWithFormat:@"%@UserLicenseKey", kDecodeKeyPrefix]];
    [coder encodeObject:username forKey:[NSString stringWithFormat:@"%@UserSelfNameKey", kDecodeKeyPrefix]];
    [coder encodeObject:facebookId forKey:[NSString stringWithFormat:@"%@UserFacebookKey", kDecodeKeyPrefix]];
    [coder encodeObject:bank forKey:[NSString stringWithFormat:@"%@UserBankKey", kDecodeKeyPrefix]];
    [coder encodeObject:creditCards forKey:[NSString stringWithFormat:@"%@UserCreditCardsKey", kDecodeKeyPrefix]];
    [coder encodeObject:groups forKey:[NSString stringWithFormat:@"%@UserGroupsKey", kDecodeKeyPrefix]];
    [coder encodeObject:friendMap forKey:[NSString stringWithFormat:@"%@UserFriendMapKey", kDecodeKeyPrefix]];
    [coder encodeObject:personalTransactions forKey:[NSString stringWithFormat:@"%@UserPersonalKey", kDecodeKeyPrefix]];
    [coder encodeObject:incomingTransactions forKey:[NSString stringWithFormat:@"%@UserIncomingKey", kDecodeKeyPrefix]];
    [coder encodeObject:outgoingTransactions forKey:[NSString stringWithFormat:@"%@UserOutgoingKey", kDecodeKeyPrefix]];
    [coder encodeObject:friendsTransactions forKey:[NSString stringWithFormat:@"%@UserFriendsTransKey", kDecodeKeyPrefix]];
    [coder encodeObject:publicTransactions forKey:[NSString stringWithFormat:@"%@UserPublicTransKey", kDecodeKeyPrefix]];
    [coder encodeObject:groupTransactions forKey:[NSString stringWithFormat:@"%@UserGroupTransKey", kDecodeKeyPrefix]];
    [coder encodeObject:notifications forKey:[NSString stringWithFormat:@"%@UserNotificationsKey", kDecodeKeyPrefix]];
    [coder encodeInt:imageDefaultIndex forKey:[NSString stringWithFormat:@"%@UserImageIndexKey", kDecodeKeyPrefix]];
    [coder encodeObject:userSettings forKey:[NSString stringWithFormat:@"%@UserSettingsKey", kDecodeKeyPrefix]];
    
}

- (void)dealloc {
    [_id release];
	[name release];
    [firstName release];
    [lastName release];
    [email release];
    [mobile release];
    [driversLicense release];
    [username release];
    [facebookId release];
    [bank release];
    [creditCards release];
    [groups release];
    [friendMap release];
    [personalTransactions release];
    [incomingTransactions release];
    [outgoingTransactions release];
    [friendsTransactions release];
    [publicTransactions release];
    [groupTransactions release];
    [notifications release];
    [userSettings release];
    [super dealloc];
}

- (NSMutableArray<Friend *> *)getFriends
{
    NSMutableArray<Friend *> *friendValues =
    [NSMutableArray<Friend *> arrayWithArray:self.friendMap.allValues];
    
    [friendValues sortUsingComparator:
     ^NSComparisonResult(id obj1, id obj2){
         int deltae =  (int)[((Friend*)obj1).firstName.uppercaseString characterAtIndex:0] -
         (int)[((Friend*)obj2).firstName.uppercaseString characterAtIndex:0];
         
         if (deltae > 0) {
             return (NSComparisonResult)NSOrderedDescending;
         }

         if (deltae < 0) {
             return (NSComparisonResult)NSOrderedAscending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }
     ];
    return nil;
}
- (BOOL)isCurrentFriend:(NSString *)fKey
{
    return [self.friendMap.allKeys containsObject:fKey];
}
- (void)setFriends:(NSMutableArray<Friend *> *)friends
{
    self.friendMap = [NSMutableDictionary<NSString *,Friend *> new];
    for (Friend * aFriend in friends) {
        [self.friendMap setObject:aFriend forKey:aFriend._id];
    }
}

- (void)updateNotifications:(NSMutableArray<Notification *> *)newNotifications
{
    NSMutableArray<Notification *> *notificationsUpdated = [NSMutableArray<Notification *> new];
    int index = 0;
    // updates existing tx
    for (Notification * currentNotification in self.notifications) {
        for (Notification * newNotification in newNotifications) {
            if([currentNotification._id isEqualToString:newNotification._id])
            {
                [self.notifications replaceObjectAtIndex:index withObject:newNotification];
                [notificationsUpdated addObject:newNotification];
            }
        }
        index++;
    }
    
    [newNotifications removeObjectsInArray:notificationsUpdated];
    [newNotifications addObjectsFromArray:self.notifications];
    self.notifications = newNotifications;
}
- (void)updatePersonalTransactions:(NSMutableArray<Transaction *> *)personalTransactions
{
    self.personalTransactions = [self getNewListAfterUpdatingTransactions:self.personalTransactions withUpdate:personalTransactions];
}
- (void)updateGroupTransactions:(NSMutableDictionary<NSString *,NSMutableArray<Transaction *> *> *)groupTransactions
{
    [self.groupTransactions setDictionary:groupTransactions];
}
- (void)updateIncomingTransactions:(NSMutableArray<Transaction *> *)incomingTransactions
{
    self.incomingTransactions = [self getNewListAfterUpdatingTransactions:self.incomingTransactions withUpdate:incomingTransactions];
}
- (void)updateOutgoingTransactions:(NSMutableArray<Transaction *> *)outgoingTransactions
{
    self.outgoingTransactions = [self getNewListAfterUpdatingTransactions:self.outgoingTransactions withUpdate:outgoingTransactions];
}
- (void)updateFriendsTransactions:(NSMutableArray<Transaction *> *)transactions
{
    self.friendsTransactions = [self getNewListAfterUpdatingTransactions:self.friendsTransactions withUpdate:transactions];
}
- (void)updatePublicTransactions:(NSMutableArray<Transaction *> *)transactions
{
    self.publicTransactions = [self getNewListAfterUpdatingTransactions:self.publicTransactions withUpdate:transactions];
}

- (NSMutableArray<Transaction *> *)getNewListAfterUpdatingTransactions:(NSMutableArray<Transaction *> *)currentList withUpdate:(NSMutableArray<Transaction *> *)updatedEntries
{
    NSMutableArray<Transaction *> *updatedTxList = [NSMutableArray<Transaction *> new];
    int index = 0;
    // updates existing tx
    for (Transaction * currentTransaction in currentList) {
        for (Transaction * updatedTransaction in updatedEntries) {
            if([currentTransaction._id isEqualToString:updatedTransaction._id])
            {
                [currentList replaceObjectAtIndex:index withObject:updatedTransaction];
                [updatedTxList addObject:updatedTransaction];
            }
        }
        index++;
    }
    
    [updatedEntries removeObjectsInArray:updatedTxList];
    [updatedEntries addObjectsFromArray:currentList];
    return updatedEntries;
}

- (NSString *)getBalance
{
    return [NSString stringWithFormat:@"$%.2f", [User getUser].balance];
}

- (NSString *)getName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];

}
- (NSString *)getUsername
{
    return [NSString stringWithFormat:@"@%@", self.username];
}

- (void)addFriend:(Friend*)aFriend
{
    [self.friendMap setObject:aFriend forKey:aFriend._id];
}
+(User *) getUser
{
    if(STATIC_USER == nil)
    {
        STATIC_USER = [User new];
    }
    
    return STATIC_USER;
}

+(void) loadUser:(User *)aUser
{
    if(STATIC_USER != aUser) {
        [STATIC_USER release];
        STATIC_USER = [aUser retain];
    }
    
    return;
}
@end
