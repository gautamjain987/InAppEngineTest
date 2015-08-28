//
//  InAppLayoutObject.m
//  InAppEngine
//
//  Created by Gautam on 24/06/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "InAppLayoutObject.h"

NSString *const ALIGN_RIGHT     = @"ap_r";
NSString *const ALIGN_LEFT      = @"ap_l";
NSString *const ALIGN_CENTER    = @"ap_c";


@implementation InAppLayoutObject

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.alignmentDictionary = [NSMutableDictionary dictionary];
        self.paddingDictionary = [NSMutableDictionary dictionary];
        self.propertiesDictionary = [dictionary objectForKey:@"properties"];
        
        self.layoutDictionary  = [_propertiesDictionary objectForKey:@"layout"];
        
        if([dictionary objectForKey:@"ap_r"]){
            [self.alignmentDictionary setObject:@1 forKey:ALIGN_RIGHT];
        }
        
        if([dictionary objectForKey:@"ap_l"]){
            [self.alignmentDictionary setObject:@1 forKey:ALIGN_LEFT];
        }
        
        if([dictionary objectForKey:@"ap_c"]){
            [self.alignmentDictionary setObject:@1 forKey:ALIGN_CENTER];
        }
        
        // and so on
        
        [self setGravityWithObject:[dictionary objectForKey:@"gravity"]];
        
        self.width = [[self.layoutDictionary objectForKey:@"width"]integerValue];
        self.height = [[self.layoutDictionary objectForKey:@"height"]integerValue];
        
        self.paddingDictionary  = [self.layoutDictionary objectForKey:@"padding"];
        self.paddingLeft        = [[self.paddingDictionary objectForKey:@"Left"]integerValue];
        self.paddingRight       = [[self.paddingDictionary objectForKey:@"Right"]integerValue];
        self.paddingTop         = [[self.paddingDictionary objectForKey:@"Top"]integerValue];
        self.paddingBottom      = [[self.paddingDictionary objectForKey:@"Bottom"]integerValue];
        
    }
    return self;
}

-(void)setGravityWithObject:(NSString *)gravity{
    if([gravity isEqualToString:@"center"]) {
        self.layoutGravity = kLayoutGravityCenter;
        
    }else if ([gravity isEqualToString:@"top"]) {
        self.layoutGravity = kLayoutGravityTop;
        
    }else if ([gravity isEqualToString:@"bottom"]) {
        self.layoutGravity = kLayoutGravityBottom;
        
    }else if ([gravity isEqualToString:@"left"]) {
        self.layoutGravity = kLayoutGravityLeft;
    }
}
@end
