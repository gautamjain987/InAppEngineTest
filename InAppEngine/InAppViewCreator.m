//
//  InAppViewCreator.m
//  InAppEngine
//
//  Created by Gautam on 20/07/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "InAppViewCreator.h"
#import "MOButtonWidget.h"
#import "MOImageWidget.h"
#import "MOLabelWidget.h"
#import "MOWidgetView.h"
#import "MOSwitchWidget.h"

#import "InAppManager.h"

@interface InAppViewCreator()

@end

@implementation InAppViewCreator

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        
        NSMutableDictionary *inAppDictionary = [self getInAppDictionary];
        dict = inAppDictionary;
        
// 1. Check the inapp type
        self.inAppType = [self inAppTypeFromString:[inAppDictionary objectForKey:@"type"]];
//        if(!self.inAppType){
//            // Go home sucker. Y u return nil. Y!
//            return nil;
//        }
        
        if(self.inAppType == InAppTypeFullScreen){
            
        }else if (self.inAppType == InAppTypeEmbedded){
            
        }else if (self.inAppType == InAppTypeCenter){
            
        }
        
        
        NSArray *widgetsArray = [dict objectForKey:@"widgets"];
        self.numberOfWidgets = [widgetsArray count];
        
//      1. Get the container for the in-app.
        NSDictionary *containerDict = [dict objectForKey:@"container"];
        
        if(self.inAppType == InAppTypeFullScreen){
            [InAppManager sharedInstance].inAppHeight   = [self screenHeight];
            [InAppManager sharedInstance].inAppWidth    = [self screenWidth];
        }
        
//      2. Create the rows for the widgets.
        NSMutableArray *viewsArray = [self createRowsOfWigets:widgetsArray];
        
//      3. Create the container with the container dict
        UIView *containerView = [self createContainerForInAppWithContainerDict:containerDict andViews:viewsArray];
        
//      3. Add gestures for all the subviews.
        [self addSubview:containerView];
    }
    
    self.userInteractionEnabled = YES;
    
    return self;
}

-(UIView *)createContainerForInAppWithContainerDict:(NSDictionary *)containerDict andViews:(NSArray *)viewsArray{
    
    UIView * containerView;
    
    if([containerDict objectForKey:@"type"]){
        
        InAppLayoutObject *layoutObject = [[InAppLayoutObject alloc]initWithDictionary:containerDict];
        
        NSInteger containerWidth = self.currentWidth + layoutObject.paddingLeft + layoutObject.paddingRight;
        NSInteger containerHeight = self.currentHeight + layoutObject.paddingTop + layoutObject.paddingBottom;
        NSInteger containerOriginY;
        NSInteger containerOriginX;
        
        if(containerWidth > [self screenWidth]){
            if(self.currentWidth > [self screenWidth]){
                self.currentWidth = [self screenWidth];
            }
            containerWidth = self.currentWidth;
            layoutObject.paddingRight = 0;
            layoutObject.paddingLeft = 0;
        }
        
        containerOriginX = [self screenWidth]/2 - self.currentWidth/2 - layoutObject.paddingLeft/2 - layoutObject.paddingRight/2;
        
        if([[containerDict objectForKey:@"type"] isEqualToString:@"center"]){
            containerOriginY = [self screenHeight]/2 - containerHeight/2;
            containerView.layer.cornerRadius = 5.0f;
        }else if ([[containerDict objectForKey:@"type"] isEqualToString:@"top"]){
            containerOriginY = layoutObject.paddingTop;
        }else if ([[containerDict objectForKey:@"type"] isEqualToString:@"bottom"]){
            containerOriginY = [self screenHeight]-self.currentHeight-layoutObject.paddingBottom;
        }else if ([[containerDict objectForKey:@"type"]isEqualToString:@"embedded"]){
            
            // Adding 64 for embedded for nav bar + status bar
            
            containerOriginY = layoutObject.paddingTop + 64;
            containerOriginX = layoutObject.paddingLeft;
            containerWidth   = [self screenWidth];
            containerHeight  = containerHeight + layoutObject.paddingBottom;
        }else if([containerDict objectForKey:@"full"]){
            // Handle other types
            
            containerWidth = [self screenWidth];
            containerHeight = [self screenHeight];
            containerOriginX = 0;
            containerOriginY = 0;
            
        }else{
            return nil;
        }
        
        containerView = [[UIView alloc]initWithFrame:CGRectMake(containerOriginX, containerOriginY, containerWidth, containerHeight)];
        
        containerView.backgroundColor = [UIColor orangeColor];
        
        for (int i=0; i<[viewsArray count]; i++) {
            MOWidgetView *view = [viewsArray objectAtIndex:i];
            
            float newOriginY = 0;
            if(i==0){
                newOriginY = layoutObject.paddingTop;
            }
            float newOriginX = 0;
            
            switch (view.widgetAlignment) {
                case ALIGN_CENTER:
                    
#warning check if container view > self.view
                    newOriginX = view.frame.origin.x/2 + containerView.frame.size.width/2 - view.frame.size.width/2;
                    view.frame = CGRectMake(newOriginX, view.frame.origin.y+newOriginY, view.frame.size.width, view.frame.size.height);
                    break;
                    
                case ALIGN_LEFT:
                    newOriginX = layoutObject.paddingLeft;
                    view.frame = CGRectMake(newOriginX, view.frame.origin.y + newOriginY, view.frame.size.width, view.frame.size.height);
                    break;
                    
                case ALIGN_RIGHT:
                    newOriginX = containerView.frame.size.width - view.frame.size.width - layoutObject.paddingRight;
                    view.frame = CGRectMake(newOriginX, view.frame.origin.y + newOriginY, view.frame.size.width, view.frame.size.height);
                    break;
                    
                default:
                    break;
            }
            [containerView addSubview:view];
            [containerView setBackgroundColor:[UIColor purpleColor]];
        }
    }
    return containerView;
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


#pragma sample dicts

// Dummy dictionary
-(NSMutableDictionary *)getInAppDictionary{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // Add Container
    int paddingLeft = 20;
    int paddingTop = 20;
    int width = 100;
    int height = 50;

    NSMutableDictionary *containerDict = [NSMutableDictionary dictionary];
    [containerDict setObject:@"containter" forKey:@"type"];
    NSMutableDictionary *propertiesDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *paddingDict = [NSMutableDictionary dictionary];
    
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Top"];
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Left"];
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Right"];
    [paddingDict setObject:[NSString stringWithFormat:@"%d",20] forKey:@"Bottom"];
    
    [layoutDict setObject:paddingDict forKey:@"padding"];
    [propertiesDict setObject:layoutDict forKey:@"layout"];
    
    [containerDict setObject:propertiesDict forKey:@"properties"];
    [containerDict setObject:@"center" forKey:@"type"];  // possible types are center top bottom, intersetial/full, embed
    [dict setObject:containerDict forKey:@"container"];
    
    // Add widgets
    NSMutableArray *widgetsArray = [NSMutableArray array];
    
    NSString *text = @"hello what are you doing";

    NSMutableDictionary *widget1 = [NSMutableDictionary dictionary];
    
    // Reset stuff
    NSMutableDictionary *propertiesDictNew = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutDictNew = [NSMutableDictionary dictionary];
    NSMutableDictionary *paddingDictNew = [NSMutableDictionary dictionary];
    
    [widget1 setObject:@"text" forKey:@"type"];
    [widget1 setObject:text forKey:@"text"];
    
    
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",20] forKey:@"Top"];
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",20] forKey:@"Left"];
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Right"];
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Bottom"];
    
    [layoutDictNew setObject:[NSString stringWithFormat:@"%d", width] forKey:@"width"];
    [layoutDictNew setObject:[NSString stringWithFormat:@"%d",height] forKey:@"height"];
    
    [layoutDictNew setObject:paddingDictNew forKey:@"padding"];
    
    [propertiesDictNew setObject:layoutDictNew forKey:@"layout"];
    [widget1 setObject:propertiesDictNew forKey:@"properties"];
    
    NSMutableDictionary *widget2 = [NSMutableDictionary dictionary];
    
    // Reset stuff
    NSMutableDictionary *propertiesDictNew1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutDictNew1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *paddingDictNew1 = [NSMutableDictionary dictionary];
    
    [widget2 setObject:@"button" forKey:@"type"];
    [widget2 setObject:@"Hello" forKey:@"text"];
    
    [paddingDictNew1 setObject:[NSString stringWithFormat:@"%d",20] forKey:@"Top"];
    [paddingDictNew1 setObject:[NSString stringWithFormat:@"%d",paddingLeft] forKey:@"Left"];
    [paddingDictNew1 setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Right"];
    [paddingDictNew1 setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Bottom"];
    
    [layoutDictNew1 setObject:[NSString stringWithFormat:@"%d", 80] forKey:@"width"];
    [layoutDictNew1 setObject:[NSString stringWithFormat:@"%d", 40] forKey:@"height"];
    
    [layoutDictNew1 setObject:paddingDictNew1 forKey:@"padding"];
    
    [propertiesDictNew1 setObject:layoutDictNew1 forKey:@"layout"];
    [widget2 setObject:propertiesDictNew1 forKey:@"properties"];
    
    NSMutableArray *widget1Array = [NSMutableArray array];
    
    [widget1Array addObject:widget1];
    [widget1Array addObject:widget2];
    
    
    // Add container for the widget array
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];

    NSMutableDictionary *propertiesSubWidgetOneContainerDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutSubWidgetOneContainerDict = [NSMutableDictionary dictionary];
    [layoutSubWidgetOneContainerDict setObject:@"left" forKey:@"gravity"];
    
    [propertiesSubWidgetOneContainerDict setObject:layoutSubWidgetOneContainerDict forKey:@"layout"];
    
    [tempDict setObject:propertiesSubWidgetOneContainerDict forKey:@"properties"];
    [tempDict setObject:layoutSubWidgetOneContainerDict forKey:@"layout"];
    
//    NSMutableDictionary *subwidgetOneContainerDict = [NSMutableDictionary dictionary];
//    [subwidgetOneContainerDict setObject:tempDict forKey:@"container"];
    
    // Create the json for the widget collection
    NSMutableDictionary *subwidgetOneDict = [NSMutableDictionary dictionary];
    [subwidgetOneDict setObject:widget1Array forKey:@"subwidgets"];
    [subwidgetOneDict setObject:tempDict forKey:@"container"];
    
    [widgetsArray addObject:subwidgetOneDict];
    // New widget.
    
//    NSMutableDictionary *secondWidgetDict = [NSMutableDictionary dictionary];
    
    NSMutableArray *widget2Array = [NSMutableArray array];
    
    NSString *text1 = @"hello what are you doing. You must be doing good. Well let's see";
    
    NSMutableDictionary *widget3 = [NSMutableDictionary dictionary];
    
    // Reset stuff
    NSMutableDictionary *propertiesDictNew3 = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutDictNew3 = [NSMutableDictionary dictionary];
    NSMutableDictionary *paddingDictNew3 = [NSMutableDictionary dictionary];
    
    [widget3 setObject:@"text" forKey:@"type"];
    [widget3 setObject:text1 forKey:@"text"];
    
    [paddingDictNew3 setObject:[NSString stringWithFormat:@"%d",20] forKey:@"Top"];
    [paddingDictNew3 setObject:[NSString stringWithFormat:@"%d",20] forKey:@"Left"]; // text padding 0 from left. container will have 30
    [paddingDictNew3 setObject:[NSString stringWithFormat:@"%d",20] forKey:@"Right"];
    [paddingDictNew3 setObject:[NSString stringWithFormat:@"%d",20] forKey:@"Bottom"];
    
    [layoutDictNew3 setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"width"];
    
    // Here height does not matter and will be computed automatically
    [layoutDictNew3 setObject:[NSString stringWithFormat:@"%d",height] forKey:@"height"];
    
    [layoutDictNew3 setObject:paddingDictNew3 forKey:@"padding"];
    
    [propertiesDictNew3 setObject:layoutDictNew3 forKey:@"layout"];
    [widget3 setObject:propertiesDictNew3 forKey:@"properties"];
    
    [widget2Array addObject:widget3];
  
#warning add again
    
    
    // Add container for the widget array
    NSMutableDictionary *tempDict2 = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *propertiesSubWidgetOneContainerDict2 = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutSubWidgetOneContainerDict2 = [NSMutableDictionary dictionary];
    [layoutSubWidgetOneContainerDict2 setObject:@"left" forKey:@"gravity"];
    
    [propertiesSubWidgetOneContainerDict2 setObject:layoutSubWidgetOneContainerDict2 forKey:@"layout"];
    
    [tempDict2 setObject:propertiesSubWidgetOneContainerDict2 forKey:@"properties"];
    [tempDict2 setObject:layoutSubWidgetOneContainerDict2 forKey:@"layout"];

    
    // Create the json for the widget collection
    NSMutableDictionary *subwidgetOneDict2 = [NSMutableDictionary dictionary];
    [subwidgetOneDict2 setObject:widget2Array forKey:@"subwidgets"];
    [subwidgetOneDict2 setObject:tempDict2 forKey:@"container"];
    
    [widgetsArray addObject:subwidgetOneDict2];
    
    [dict setObject:@"center" forKey:@"align"];
    [dict setObject:widgetsArray forKey:@"widgets"];
    
    [dict setObject:@"center" forKey:@"type"];
    return dict;
}


-(NSDictionary *)getNudgeDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // Add Container
//    int paddingLeft = 20;
//    int paddingTop = 20;
//    int width = 0;
//    int height = 80;
    
    NSMutableDictionary *containerDict = [NSMutableDictionary dictionary];
    [containerDict setObject:@"containter" forKey:@"type"];
    NSMutableDictionary *propertiesDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *paddingDict = [NSMutableDictionary dictionary];
    
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Top"];
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Left"];
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Right"];
    [paddingDict setObject:[NSString stringWithFormat:@"%d",10] forKey:@"Bottom"];
    
    [layoutDict setObject:paddingDict forKey:@"padding"];
    [propertiesDict setObject:layoutDict forKey:@"layout"];
    
    [containerDict setObject:propertiesDict forKey:@"properties"];
    [containerDict setObject:@"embedded" forKey:@"type"];  // possible types are center top bottom, intersetial/full, embed
    [dict setObject:containerDict forKey:@"container"];
    
    // Add widgets
    NSMutableArray *widgetsArray = [NSMutableArray array];
    
    NSString *text = @"hello what are you doing. this is a nudge";
    
    NSMutableDictionary *widget1 = [NSMutableDictionary dictionary];
    
    // Reset stuff
    NSMutableDictionary *propertiesDictNew = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutDictNew = [NSMutableDictionary dictionary];
    NSMutableDictionary *paddingDictNew = [NSMutableDictionary dictionary];
    
    [widget1 setObject:@"text" forKey:@"type"];
    [widget1 setObject:text forKey:@"text"];
    
    
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",10] forKey:@"Top"];
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",15] forKey:@"Left"];
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Right"];
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Bottom"];
    
    [layoutDictNew setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"width"];
    [layoutDictNew setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"height"];
    
    [layoutDictNew setObject:paddingDictNew forKey:@"padding"];
    
    [propertiesDictNew setObject:layoutDictNew forKey:@"layout"];
    [widget1 setObject:propertiesDictNew forKey:@"properties"];
    
    NSMutableArray *widget1Array = [NSMutableArray array];
    
    [widget1Array addObject:widget1];
    
    
    // Add container for the widget array
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *propertiesSubWidgetOneContainerDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutSubWidgetOneContainerDict = [NSMutableDictionary dictionary];
    [layoutSubWidgetOneContainerDict setObject:@"center" forKey:@"gravity"];
    
    [propertiesSubWidgetOneContainerDict setObject:layoutSubWidgetOneContainerDict forKey:@"layout"];
    
    [tempDict setObject:propertiesSubWidgetOneContainerDict forKey:@"properties"];
    [tempDict setObject:layoutSubWidgetOneContainerDict forKey:@"layout"];
    
    //    NSMutableDictionary *subwidgetOneContainerDict = [NSMutableDictionary dictionary];
    //    [subwidgetOneContainerDict setObject:tempDict forKey:@"container"];
    
    // Create the json for the widget collection
    NSMutableDictionary *subwidgetOneDict = [NSMutableDictionary dictionary];
    [subwidgetOneDict setObject:widget1Array forKey:@"subwidgets"];
//    [subwidgetOneDict setObject:tempDict forKey:@"container"];
    
    [widgetsArray addObject:subwidgetOneDict];
    // New widget.
    
    //    NSMutableDictionary *secondWidgetDict = [NSMutableDictionary dictionary];
    
    
    // Create the json for the widget collection
    
    [dict setObject:@"top" forKey:@"align"];
    [dict setObject:widgetsArray forKey:@"widgets"];
    
    return dict;
}


-(NSDictionary *)getImageInAppDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // Add Container
    //    int paddingLeft = 20;
    //    int paddingTop = 20;
    //    int width = 0;
    //    int height = 80;
    
    NSMutableDictionary *containerDict = [NSMutableDictionary dictionary];
    [containerDict setObject:@"containter" forKey:@"type"];
    NSMutableDictionary *propertiesDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *paddingDict = [NSMutableDictionary dictionary];
    
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Top"];
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Left"];
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Right"];
    [paddingDict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Bottom"];
    
    [layoutDict setObject:paddingDict forKey:@"padding"];
    [propertiesDict setObject:layoutDict forKey:@"layout"];
    
    [containerDict setObject:propertiesDict forKey:@"properties"];
    [containerDict setObject:@"full" forKey:@"type"];  // possible types are center top bottom, intersetial/full, embed
    [dict setObject:containerDict forKey:@"container"];
    
    // Add widgets
    NSMutableArray *widgetsArray = [NSMutableArray array];
    
    UIImage *image;
    
//    NSString *text = @"hello what are you doing. this is a nudge";
    
    NSMutableDictionary *widget1 = [NSMutableDictionary dictionary];
    
    // Reset stuff
    NSMutableDictionary *propertiesDictNew = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutDictNew = [NSMutableDictionary dictionary];
    NSMutableDictionary *paddingDictNew = [NSMutableDictionary dictionary];
    
    [widget1 setObject:@"image" forKey:@"type"];
    [widget1 setObject:image forKey:@"image"];
    
    
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Top"];
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Left"];
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Right"];
    [paddingDictNew setObject:[NSString stringWithFormat:@"%d",0] forKey:@"Bottom"];
    
    [layoutDictNew setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"width"];
    [layoutDictNew setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"height"];
    
    [layoutDictNew setObject:paddingDictNew forKey:@"padding"];
    
    [propertiesDictNew setObject:layoutDictNew forKey:@"layout"];
    [widget1 setObject:propertiesDictNew forKey:@"properties"];
    
    NSMutableArray *widget1Array = [NSMutableArray array];
    
    [widget1Array addObject:widget1];
    
    
    // Add container for the widget array
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *propertiesSubWidgetOneContainerDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutSubWidgetOneContainerDict = [NSMutableDictionary dictionary];
    [layoutSubWidgetOneContainerDict setObject:@"center" forKey:@"gravity"];
    
    [propertiesSubWidgetOneContainerDict setObject:layoutSubWidgetOneContainerDict forKey:@"layout"];
    
    [tempDict setObject:propertiesSubWidgetOneContainerDict forKey:@"properties"];
    [tempDict setObject:layoutSubWidgetOneContainerDict forKey:@"layout"];
    
    //    NSMutableDictionary *subwidgetOneContainerDict = [NSMutableDictionary dictionary];
    //    [subwidgetOneContainerDict setObject:tempDict forKey:@"container"];
    
    // Create the json for the widget collection
    NSMutableDictionary *subwidgetOneDict = [NSMutableDictionary dictionary];
    [subwidgetOneDict setObject:widget1Array forKey:@"subwidgets"];
    //    [subwidgetOneDict setObject:tempDict forKey:@"container"];
    
    [widgetsArray addObject:subwidgetOneDict];
    // New widget.
    
    //    NSMutableDictionary *secondWidgetDict = [NSMutableDictionary dictionary];
    
    
    // Create the json for the widget collection
    
    [dict setObject:@"full" forKey:@"align"];
    
    [dict setObject:widgetsArray forKey:@"widgets"];
    
    return dict;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches are %@", touches);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInView:self];
    NSLog(@"touch location is x-%f, y-%f", touchLocation.x, touchLocation.y);
    return NO;
}
@end
