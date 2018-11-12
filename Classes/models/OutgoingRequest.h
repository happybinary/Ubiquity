//
//  OutgoingRequest.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Transaction.h"

@interface OutgoingRequest : NSObject {
    NSString *groupId;
    NSString *splitCorrelationId;
    BOOL isGroupRequest;

    NSMutableArray<Transaction *> *transactions;
}
@property (nonatomic, retain) NSString *groupId;
@property (nonatomic, retain) NSString *splitCorrelationId;
@property (nonatomic) BOOL isGroupRequest;

@property (nonatomic, retain) NSMutableArray<Transaction *> *transactions;

+(OutgoingRequest *) createGroupOutgoingRequest:(Transaction *)trans;
+(OutgoingRequest *) createRegularOutgoingRequest:(Transaction *)trans;

-(void) addToTransactionList:(Transaction *)trans;

@end
