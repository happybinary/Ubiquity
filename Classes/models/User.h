//
//  User.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bank;
@class CreditCard;
@class Group;
@class Friend;
@class Notification;
@class Transaction;
@class UserSettings;

@interface User : NSObject {
    NSString *_id;
	NSString *name;
    double balance;
    NSString *firstName;
	NSString *lastName;
    NSString *email;
    NSString *mobile;
    NSString *driversLicense;
    NSString *username;
    NSString *facebookId;
    Bank *bank;
    NSMutableArray<CreditCard *> *creditCards;
    NSMutableArray<Group *> *groups;
    NSMutableDictionary<NSString *,Friend *> *friendMap;
    NSMutableArray<Transaction *> *personalTransactions;
    NSMutableArray<Transaction *> *incomingTransactions;
    NSMutableArray<Transaction *> *outgoingTransactions;
    NSMutableArray<Transaction *> *friendsTransactions;
    NSMutableArray<Transaction *> *publicTransactions;
    NSMutableDictionary<NSString *,NSMutableArray<Transaction *> *> *groupTransactions;
    NSMutableArray<Notification *> *notifications;

    int imageDefaultIndex;
    UserSettings *userSettings;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) double balance;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *driversLicense;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *facebookId;
@property (nonatomic, retain) Bank *bank;
@property (nonatomic, retain) NSMutableArray<CreditCard *> *creditCards;
@property (nonatomic, retain) NSMutableArray<Group *> *groups;
@property (nonatomic, retain) NSMutableDictionary<NSString *,Friend *> *friendMap;
@property (nonatomic, retain) NSMutableArray<Transaction *> *personalTransactions;
@property (nonatomic, retain) NSMutableArray<Transaction *> *incomingTransactions;
@property (nonatomic, retain) NSMutableArray<Transaction *> *outgoingTransactions;
@property (nonatomic, retain) NSMutableArray<Transaction *> *friendsTransactions;
@property (nonatomic, retain) NSMutableArray<Transaction *> *publicTransactions;
@property (nonatomic, retain) NSMutableDictionary<NSString *,NSMutableArray<Transaction *> *> *groupTransactions;
@property (nonatomic, retain) NSMutableArray<Notification *> *notifications;

@property (nonatomic) int imageDefaultIndex;
@property (nonatomic, retain) UserSettings *userSettings;

- (NSMutableArray<Friend *> *)getFriends;
- (BOOL)isCurrentFriend:(NSString *)fKey;
- (void)setFriends:(NSMutableArray<Friend *> *)friends;

- (void)updateNotifications:(NSMutableArray<Notification *> *)newNotifications;
- (void)updatePersonalTransactions:(NSMutableArray<Transaction *> *)personalTransactions;
- (void)updateGroupTransactions:(NSMutableDictionary<NSString *,NSMutableArray<Transaction *> *> *)groupTransactions;
- (void)updateIncomingTransactions:(NSMutableArray<Transaction *> *)incomingTransactions;
- (void)updateOutgoingTransactions:(NSMutableArray<Transaction *> *)outgoingTransactions;
- (void)updateFriendsTransactions:(NSMutableArray<Transaction *> *)transactions;
- (void)updatePublicTransactions:(NSMutableArray<Transaction *> *)transactions;

- (NSMutableArray<Transaction *> *)getNewListAfterUpdatingTransactions:(NSMutableArray<Transaction *> *)currentList withUpdate:(NSMutableArray<Transaction *> *)updatedEntries;

- (NSString *)getBalance;

- (NSString *)getName;
- (NSString *)getUsername;

- (void)addFriend:(Friend*)aFriend;

+(User *) getUser;
+(void) loadUser:(User *)aUser;

@end
