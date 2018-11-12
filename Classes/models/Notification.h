//
//  Notification.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Notification : NSObject {
    NSString *_id;
    NSString *userId;
    int state;
    int type;
    NSString *date;
    double amount;
    
    NSString *sourceEventId;
    NSString *originatingUserId;
	NSString *originatingUserFirstName;
    NSString *originatingUserLastName;
	NSString *message;
	
    int imageDefaultIndex;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic) int state;
@property (nonatomic) int type;
@property (nonatomic, retain) NSString *date;
@property (nonatomic) double amount;
@property (nonatomic, retain) NSString *sourceEventId;
@property (nonatomic, retain) NSString *originatingUserId;
@property (nonatomic, retain) NSString *originatingUserFirstName;
@property (nonatomic, retain) NSString *originatingUserLastName;
@property (nonatomic, retain) NSString *message;
@property (nonatomic) int imageDefaultIndex;

-(NSString *) toString;
-(BOOL) equals:(id)object;

@end
