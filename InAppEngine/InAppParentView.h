//
//  InAppParentView.h
//  InAppEngine
//
//  Created by Gautam on 28/08/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOWidgetView.h"


typedef enum WidgetType{
    kWidgetTypeButton,
    kWidgetTypeText,
    kWidgetTypeImage,
    kWidgetTypeView,
    kWidgetTypeSwitch,
    kWidgetTypeScrollView,
    kWidgetTypeLabel,
    kWidgetTypeNone,
    
} WidgetType;

typedef enum{
    InAppTypeCenter,
    InAppTypeEmbedded,
    InAppTypeFullScreen,
    
}InAppType;


@interface InAppParentView : UIView

@property(nonatomic, assign) InAppType inAppType;
@property(nonatomic, assign) NSInteger currentHeight;
@property(nonatomic, assign) NSInteger currentWidth;

-(float)screenWidth;
-(float)screenHeight;

-(id)getViewForWidget:(NSDictionary *)widgetDict type:(WidgetType)widgetType;
-(InAppType)inAppTypeFromString:(NSString *)type;
-(WidgetType)widgetTypeForString:(NSString *)str;

-(WidgetAlignment)getAlignmentForGravity:(NSString *)layoutGravity;

@end
