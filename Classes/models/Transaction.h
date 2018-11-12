//
//  Transaction.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionStatus.h"

@class TransactionReactions;

@interface Transaction : NSObject {
    NSString *_id;
    NSString *description;
    
    double amount;
    int complete;
    int visibility;
    int type;
    
    NSString *fromUserId;
    NSString *toUserId;
    
    NSString *fromFirstName;
    NSString *fromLastName;
    NSString *fromUsername;
    int fromImageDefaultIndex;
    
    NSString *toFirstName;
    NSString *toLastName;
    NSString *toUsername;
    int toImageDefaultIndex;
    
	NSString *dateCreated;
	NSString *dateClosed;
    NSString *dateUpdated;
    
    NSString *requestDescription;
    NSString *groupId;
    NSString *splitCorrelationId;
    
    TransactionReactions *reactions;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *description;

@property (nonatomic) double amount;
@property (nonatomic) int complete;
@property (nonatomic) int visibility;
@property (nonatomic) int type;

@property (nonatomic, retain) NSString *fromUserId;
@property (nonatomic, retain) NSString *toUserId;

@property (nonatomic, retain) NSString *fromFirstName;
@property (nonatomic, retain) NSString *fromLastName;
@property (nonatomic, retain) NSString *fromUsername;
@property (nonatomic) int fromImageDefaultIndex;

@property (nonatomic, retain) NSString *toFirstName;
@property (nonatomic, retain) NSString *toLastName;
@property (nonatomic, retain) NSString *toUsername;
@property (nonatomic) int toImageDefaultIndex;

@property (nonatomic, retain) NSString *dateCreated;
@property (nonatomic, retain) NSString *dateClosed;
@property (nonatomic, retain) NSString *dateUpdated;

@property (nonatomic, retain) NSString *requestDescription;
@property (nonatomic, retain) NSString *groupId;
@property (nonatomic, retain) NSString *splitCorrelationId;

@property (nonatomic, retain) TransactionReactions *reactions;

- (id)initWithRecipientId:(NSString *)recipientId
                     desc:(NSString *)aDescription
                    total:(double)aAmount
                  visible:(int)aVisibility
                transType:(TransactionStatus) aType;

-(NSString *) toString;
-(BOOL) isIncomingTransaction;
-(BOOL) isOutgoingTransaction;
-(BOOL) isPaid;
-(BOOL) isReceived;
-(NSString *) getAmountString;

@end
