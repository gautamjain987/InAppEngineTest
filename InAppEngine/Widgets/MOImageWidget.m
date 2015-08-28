//
//  MOImageWidget.m
//  InAppEngine
//
//  Created by Gautam on 20/07/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "MOImageWidget.h"

@implementation MOImageWidget

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if(self){
        
        self.frame = CGRectMake(0, 0, 280, 450);
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

/*
-(CGSize)getOptmisedImageSizeFromImage:(UIImage *)imageFromServer{
    
    float imageWidth    = imageFromServer.size.width;
    float imageHeight   = imageFromServer.size.height;
    float newHeight     = 0;
    float newWidth      = 0;
    float ratio;
    // Case 1. Image width greater than total space allowed inside in app view
    if(imageWidth > [MOInAppView getMaxWidth]){
        
        if(imageHeight < imageWidth){
            ratio       = imageHeight/imageWidth; // less than 1
            newWidth    = [MOInAppView getMaxWidth];
            newHeight   = newWidth * ratio;
        }else{
            ratio       = imageWidth/imageHeight; // less than 1
            newHeight   = [MOInAppView getMaxWidth];
            newWidth    = newHeight * ratio;
        }
    }else{
        
        // Case 2 - image width less than the total space allowed (very small image)
        if(imageWidth > imageHeight){
            newHeight = imageHeight;
            newWidth  = imageWidth;
        }else{
            if(imageHeight > [MOInAppView getMaxWidth]){
                newHeight   = [MOInAppView getMaxWidth];
                ratio       = imageWidth/imageHeight; // less than one
                newWidth    = newHeight * ratio;
            }
        }
    }
    return CGSizeMake(newWidth, newHeight);
}
 */

@end
