//
//  InAppManager.h
//  InAppEngine
//
//  Created by Gautam on 28/08/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppManager : NSObject

+(InAppManager *)sharedInstance;

@property(nonatomic, assign) int inAppHeight;
@property(nonatomic, assign) int inAppWidth;

@end
