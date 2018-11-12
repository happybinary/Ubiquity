//
//  TransactionReactions.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionReactions : NSObject {
    int myReactionId;
	NSMutableArray *reactionList;
}

@property (nonatomic) int myReactionId;
@property (nonatomic, retain) NSMutableArray *reactionList;

@end
