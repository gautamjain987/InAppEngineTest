//
//  InAppParentView.m
//  InAppEngine
//
//  Created by Gautam on 28/08/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "InAppParentView.h"
#import "MOButtonWidget.h"
#import "MOLabelWidget.h"
#import "MOImageWidget.h"
#import "MOSwitchWidget.h"
#import "MOWidgetView.h"

@implementation InAppParentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(float)screenWidth{
    return [[UIScreen mainScreen]bounds].size.width;
}

-(float)screenHeight{
    return [[UIScreen mainScreen]bounds].size.height;
}

-(InAppType)inAppTypeFromString:(NSString *)type{
    if([type isEqualToString:@"full screen"]){
        return InAppTypeFullScreen;
    }else if([type isEqualToString:@"center"]){
        return InAppTypeCenter;
    }else if ([type isEqualToString:@"embedded"]){
        return InAppTypeEmbedded;
    }
    return InAppTypeCenter;
}


-(id)getViewForWidget:(NSDictionary *)widgetDict type:(WidgetType)widgetType{
    
    id widget;
    if(widgetType == kWidgetTypeButton){
        widget = [[MOButtonWidget alloc]initWithDictionary:widgetDict];
    }else if (widgetType == kWidgetTypeImage){
        widget = [[MOImageWidget alloc]initWithDictionary:widgetDict];
    }else if (widgetType == kWidgetTypeText){
        widget = [[MOLabelWidget alloc]initWithDictionary:widgetDict];
    }else if (widgetType == kWidgetTypeSwitch){
        widget = [[MOSwitchWidget alloc]initWithDictionary:widgetDict];
    }
    return widget;
}

-(WidgetType)widgetTypeForString:(NSString *)str{
    if([str isEqualToString:@"button"]){
        return kWidgetTypeButton;
    }else if ([str isEqualToString:@"image"]){
        return kWidgetTypeImage;
    }else if ([str isEqualToString:@"text"]){
        return kWidgetTypeText;
    }else if ([str isEqualToString:@"view"]){
        return kWidgetTypeView;
    }else{
        return kWidgetTypeView;
    }
    return kWidgetTypeView;
}

-(WidgetAlignment)getAlignmentForGravity:(NSString *)layoutGravity{
    if([layoutGravity isEqualToString:@"center"]){
        return ALIGN_CENTER;
    }else if ([layoutGravity isEqualToString:@"left"]){
        return ALIGN_LEFT;
    }else if ([layoutGravity isEqualToString:@"right"]){
        return ALIGN_RIGHT;
    }else{
        return ALIGN_NONE;
    }
}

@end
