//
//  IReRenderable
//
//  Created by Steve Ma on 11/01/18.
//  Copyright (c) 2018 InfoPages. All rights reserved.
//
#ifndef InfoPagesCommonLibrary_IReRenderable_h
#define InfoPagesCommonLibrary_IReRenderable_h

//#import <UIKit/UIKit.h>

@protocol IReRenderable<NSObject>
@optional

- (void)doReRender;
- (BOOL)isActive;
@end

#endif
