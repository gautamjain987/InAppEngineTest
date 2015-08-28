//
//  MOSwitchWidget.m
//  InAppEngine
//
//  Created by Gautam on 24/08/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "MOSwitchWidget.h"
#import "InAppLayoutObject.h"

@implementation MOSwitchWidget

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UISwitch *)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if(self){
        InAppLayoutObject *layoutObject = [[InAppLayoutObject alloc]initWithDictionary:dict];
        
        self.frame = CGRectMake(layoutObject.paddingLeft, layoutObject.paddingTop, layoutObject.width, layoutObject.height);
        [self addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)switchValueChanged:(UISwitch *)sender{
#warning can add delegate for action
}

@end
