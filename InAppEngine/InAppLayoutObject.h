//
//  InAppLayoutObject.h
//  InAppEngine
//
//  Created by Gautam on 24/06/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kLayoutGravityCenter,
    kLayoutGravityTop,
    kLayoutGravityBottom,
    kLayoutGravityLeft,
} LayoutGravity;

@interface InAppLayoutObject : NSObject

@property(nonatomic, strong) NSMutableDictionary *alignmentDictionary;
@property(nonatomic, strong) NSDictionary        *propertiesDictionary;
@property(nonatomic, strong) NSMutableDictionary *paddingDictionary;
@property(nonatomic, strong) NSMutableDictionary *layoutDictionary;

@property(nonatomic) NSInteger width;
@property(nonatomic) NSInteger height;

@property(nonatomic) NSInteger paddingLeft;
@property(nonatomic) NSInteger paddingTop;
@property(nonatomic) NSInteger paddingRight;
@property(nonatomic) NSInteger paddingBottom;

@property(nonatomic) NSInteger marginLeft;
@property(nonatomic) NSInteger marginTop;
@property(nonatomic) NSInteger marginRight;
@property(nonatomic) NSInteger marginBottom;

@property(nonatomic) LayoutGravity layoutGravity;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
