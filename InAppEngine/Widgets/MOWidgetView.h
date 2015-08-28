//
//  MOWidgetView.h
//  InAppEngine
//
//  Created by Gautam on 29/07/15.
//  Copyright © 2015 Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum widgetAlignment{
    
    ALIGN_CENTER,
    ALIGN_LEFT,
    ALIGN_RIGHT,
    ALIGN_NONE
    
}WidgetAlignment;

@interface MOWidgetView : UIView

@property(nonatomic, assign) WidgetAlignment widgetAlignment;

@end
