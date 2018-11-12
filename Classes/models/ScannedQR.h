//
//  ScannedQR.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScannedQR : NSObject {
    NSString *userId;
    NSString *transactionId;
    int type;
}

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *transactionId;
@property (nonatomic) int type;

-(NSString *) getId;
@end
