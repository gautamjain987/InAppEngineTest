//
//  MOButtonWidget.m
//  InAppEngine
//
//  Created by Gautam on 20/07/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "MOButtonWidget.h"
#import "InAppManager.h"

@implementation MOButtonWidget

-(UIButton *)initWithDictionary:(NSDictionary *)dict{
    InAppLayoutObject *layoutObject = [[InAppLayoutObject alloc]initWithDictionary:dict];
    
    NSDictionary *propertiesDict = layoutObject.propertiesDictionary;
    
    UIButton *button = [[UIButton alloc]init];
    
    if(layoutObject.width == -1){
        layoutObject.width = [InAppManager sharedInstance].inAppWidth;
    }
    
    if(layoutObject.paddingRight && layoutObject.paddingTop){
        button.frame = CGRectMake([InAppManager sharedInstance].inAppWidth-layoutObject.paddingRight-layoutObject.width, layoutObject.paddingTop, layoutObject.width, layoutObject.height);
        
    }else if (layoutObject.paddingRight && layoutObject.paddingBottom){
        button.frame = CGRectMake([InAppManager sharedInstance].inAppWidth-layoutObject.paddingRight-layoutObject.width, [InAppManager sharedInstance].inAppHeight - layoutObject.height - layoutObject.paddingBottom, layoutObject.width, layoutObject.height);
        
    }else if (layoutObject.paddingLeft && layoutObject.paddingTop){
        button.frame = CGRectMake(layoutObject.paddingLeft, layoutObject.paddingTop, layoutObject.width, layoutObject.height);
        
    }else if (layoutObject.paddingLeft && layoutObject.paddingBottom){
        button.frame = CGRectMake(layoutObject.paddingLeft, [InAppManager sharedInstance].inAppHeight-layoutObject.paddingBottom-layoutObject.height, layoutObject.width, layoutObject.height);
    }else{
        button.frame = CGRectMake(0, 0, layoutObject.width, layoutObject.height);
    }
    
    [button setBackgroundColor:[UIColor redColor]];
    
    if([propertiesDict objectForKey:@"backgroundColor"]){
#warning use the hex decoder util to set the right color
        [button setBackgroundColor:[UIColor redColor]];
    }
    
    // Set font
    if([propertiesDict objectForKey:@"font"]){
        [button.titleLabel setFont:[UIFont fontWithName:[propertiesDict objectForKey:@"font.type"] size:[[propertiesDict objectForKey:@"font.size"]integerValue]]];
    }
    
//    if([[propertiesDict objectForKey:@"shadow.x"]intValue]){
//        
//        int xShadow = [propertiesDict objectForKey:<#(id)#>]
//        button.layer.shadowOffset =
//    }
    
    return (MOButtonWidget *)button;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void)buttonTapped:(id)sender{
    NSLog(@"button tapped");
}

@end
