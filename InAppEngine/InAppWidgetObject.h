//
//  InAppWidgetObject.h
//  InAppEngine
//
//  Created by Gautam on 24/06/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
typedef enum {
    kWidgetTypeContainer,
    kWidgetTypeButton,
    kWidgetTypeText,
    kWidgetTypeImage,
    kWidgetTypeScrollView
    
} WidgetType;

*/

@interface InAppWidgetObject : NSObject

@property(nonatomic) NSInteger identifer;
@property(nonatomic) NSInteger parentIdentifier;

//@property(nonatomic) WidgetType widgetType;

@end
