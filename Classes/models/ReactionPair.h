//
//  ReactionPair.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReactionPair : NSObject {
    int reaction;
    int count;

}

@property (nonatomic) int reaction;
@property (nonatomic) int count;
@end
