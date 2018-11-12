//
//  CompanyTransaction.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CompanyTransaction : NSObject {
    NSString *_id;
    NSString *companyId;
    NSString *companyName;
    NSString *userId;
    NSString *description;
    double amount;
    int complete;
    int visibility;
	
    NSString *dateUpdated;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *companyId;
@property (nonatomic, retain) NSString *companyName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *description;
@property (nonatomic) double amount;
@property (nonatomic) int complete;
@property (nonatomic) int visibility;
@property (nonatomic, retain) NSString *dateUpdated;

@end
