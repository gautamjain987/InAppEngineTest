//
//  InAppManager.m
//  InAppEngine
//
//  Created by Gautam on 28/08/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "InAppManager.h"

@implementation InAppManager

+(InAppManager *)sharedInstance{
    static dispatch_once_t onceToken;
    static InAppManager *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [InAppManager new];
    });
    return instance;
}

@end
