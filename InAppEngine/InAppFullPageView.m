//
//  InAppFullPageView.m
//  InAppEngine
//
//  Created by Gautam on 27/08/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "InAppFullPageView.h"
#import "InAppLayoutObject.h"
#import "InAppManager.h"

@implementation InAppFullPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
        
        NSArray *widgets = [dict objectForKey:@"widgets"];
        [self createRowsOfWigets:widgets];
        
    }
    return self;
}


/**
 This method creates a row of the widgets, which internally creates colums.
 */
-(NSMutableArray *)createRowsOfWigets:(NSArray *)widgetsArray{
    
    float tempHeight = 0;
    float tempWidth  = 0;
    
    NSMutableArray *viewsArray = [NSMutableArray array];
    
    // This means there are i number of rows, which are widgets
    for (int i=0; i<[widgetsArray count]; i++) {
        NSDictionary *widgetDict = [widgetsArray objectAtIndex:i];
        
        NSArray *subWidgetsArray = [widgetDict objectForKey:@"subwidgets"];
        NSDictionary *subwidgetDict = [self getSubwidgetsInfoWithArray:subWidgetsArray];
        
        NSMutableArray *tempViewsArray = [[subwidgetDict objectForKey:@"widgetsArray"]mutableCopy];
        
        tempHeight = [[subwidgetDict objectForKey:@"widgetHeight"]floatValue];
        tempWidth  = [[subwidgetDict objectForKey:@"widgetWidth"]floatValue];
        
        // create row container for the subwidgets. do not call create container method twice
        [viewsArray addObject:[self createContainerRow:widgetDict withViews:tempViewsArray]];
        
        tempViewsArray = nil;
        
        if(tempWidth>self.currentWidth){
            self.currentWidth = tempWidth;
        }
        
        // Update current height for next row
        self.currentHeight = self.currentHeight + tempHeight;
        
        // Reset temp width for the next row
        tempWidth = 0;
        tempHeight = 0;
    }
    return viewsArray;
}

/**
 This method creates a container for the widgets array. i.e A row for the column widgets.
 */
-(MOWidgetView *)createContainerRow:(NSDictionary *)widgetDict withViews:(NSArray *)viewsArray{
    float width = 0;
    float height = 0;
    float tempWidth = 0;
    float originY = 0;
    
    // Loop for the number of views and draw their frames.
    for(int i=0; i<[viewsArray count];i++){
        UIView *view = [viewsArray objectAtIndex:i];
        
        float leftPadding = view.frame.origin.x - tempWidth;
        tempWidth = view.frame.origin.x + view.frame.size.width;
        
        width = width + view.frame.size.width + leftPadding;
        
        if(height < view.frame.size.height){
            height = view.frame.size.height;
        }
        
        if(self.currentHeight){
            if(originY == 0){
                //              originY = view.frame.origin.y;
            }else if (view.frame.origin.y < originY){
                originY = self.currentHeight;
            }
        }
        
        //        view.frame = CGRectMake(view.frame.origin.x, originY - self.currentHeight, view.frame.size.width, view.frame.size.height);
    }
    
    MOWidgetView *widgetView = [[MOWidgetView alloc]initWithFrame:CGRectMake(0, originY, width, height)];
    
#warning if multiple views, readjust frame according to gravity
    for (UIView *view in viewsArray) {
        [widgetView addSubview:view];
    }
    
#warning check valid key
    NSString *layoutGravity = [widgetDict valueForKeyPath:@"container.layout.gravity"];
    widgetView.widgetAlignment = [self getAlignmentForGravity:layoutGravity];
    
    return widgetView;
}



/**
 This method creates all the colums for the widgets
 */
-(NSMutableDictionary *)getSubwidgetsInfoWithArray:(NSArray *)subWidgetsArray{
    
    float currentYOrigin = 0;
    float currentXOrigin = 0;
    
    WidgetType widgetType;
    
    NSMutableArray *tempViewsArray = [NSMutableArray array];
    
    // Every row has j number of columns,, which are subwidgets
    for (int j=0; j<[subWidgetsArray count]; j++) {
        
        NSDictionary *widgetDict = [subWidgetsArray objectAtIndex:j];
        widgetType = [self widgetTypeForString:[widgetDict objectForKey:@"type"]];
        
        // Get view for the respective widget
        UIView *view = (UIView *)[self getViewForWidget:widgetDict type:widgetType];
        
        InAppLayoutObject *layoutObject = [[InAppLayoutObject alloc]initWithDictionary:widgetDict];
        NSDictionary *propertiesDict = layoutObject.propertiesDictionary;
        
        if(layoutObject.paddingRight){
            currentXOrigin = [InAppManager sharedInstance].inAppHeight - layoutObject.paddingRight - view.frame.size.width;
        }
        
        
        
        // Draw the frame with respect to the previous element
        view.frame = CGRectMake(currentXOrigin + view.frame.origin.x, self.currentHeight + view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        
        // Update current width
        currentXOrigin = view.frame.size.width + view.frame.origin.x; // here origin.x already adds up previous currentXOrigin
        
        // Update current height. currentYOrigin here, is nothing but the height.
        if(view.frame.size.height > currentYOrigin){
            
            if(view.frame.origin.y > currentYOrigin){
                
                // To accomodate top padding
                int padding = view.frame.origin.y - self.currentHeight;
                currentYOrigin = view.frame.size.height;
                currentYOrigin = currentYOrigin + padding;
            }else{
                currentYOrigin = view.frame.size.height;
            }
        }
        
        // Add subview
        [tempViewsArray addObject:view];
    }
    
    NSMutableDictionary *subWidgetDict = [NSMutableDictionary dictionary];
    [subWidgetDict setObject:tempViewsArray forKey:@"widgetsArray"];
    [subWidgetDict setObject:[NSNumber numberWithFloat:currentYOrigin] forKey:@"widgetHeight"];
    [subWidgetDict setObject:[NSNumber numberWithFloat:currentXOrigin] forKey:@"widgetWidth"];
    
    return subWidgetDict;
}

@end
