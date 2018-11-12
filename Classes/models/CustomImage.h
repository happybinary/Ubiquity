//
//  CustomImage.h
//
//  Created by Steve Ma on 11/01/2018.
//  Copyright 2018 InformationPages.com, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomImage : NSObject {
    int imageResourceId;
    NSString *imageCaption;

}

@property (nonatomic) int imageResourceId;
@property (nonatomic, retain) NSString *imageCaption;

- (id)initWithResourceID:(int)resourceID
              caption:(NSString *)aImageCaption;

-(NSString *) toString;
@end
