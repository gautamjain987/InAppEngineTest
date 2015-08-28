//
//  InAppViewCreator.h
//  InAppEngine
//
//  Created by Gautam on 20/07/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppParentView.h"


@interface InAppViewCreator : InAppParentView

// This is the current view, in whose respect to the next view has to be drawn. For 1st widget, it will be self or the container
@property(nonatomic, strong) UIView *currentView;

@property(nonatomic, assign) NSInteger numberOfWidgets;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
