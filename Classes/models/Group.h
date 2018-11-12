//
//  Group.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Friend;

@interface Group : NSObject {
    NSString *_id;
	NSString *groupName;
	NSString *userID;

	NSMutableArray<Friend *> *friends;
	int isDeleted;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSMutableArray<Friend *> *friends;
@property (nonatomic) int isDeleted;

- (id)initWithName:(NSString *)aGroupName
              uid:(NSString *)aUserID
     friendlist:(NSMutableArray<Friend *> *)friendList
        isDelete:(int) aDeleted;

@end
