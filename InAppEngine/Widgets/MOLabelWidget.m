//
//  MOLabelWidget.m
//  InAppEngine
//
//  Created by Gautam on 20/07/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "MOLabelWidget.h"
#import "InAppLayoutObject.h"

@implementation MOLabelWidget

-(UILabel *)initWithDictionary:(NSDictionary *)dict{
    InAppLayoutObject *layoutObject = [[InAppLayoutObject alloc]initWithDictionary:dict];
    
    UILabel *label = [[UILabel alloc]init];
    float width;
    
    if(!layoutObject.width){
        width = [self screenWidth]-60;
    }else{
        width = layoutObject.width;
    }
    
    float height = [MOLabelWidget findHeightForText:[dict objectForKey:@"text"] havingWidth:width andFont:[UIFont systemFontOfSize:15]];
    height = height + 5;
    
    label.frame = CGRectMake(layoutObject.paddingLeft, layoutObject.paddingTop, width, height);
    label.text = [dict objectForKey:@"text"];
    label.textAlignment = NSTextAlignmentLeft;
    
    [label setFont:[UIFont systemFontOfSize:15]];
    label.numberOfLines = 0;
#warning hard coded
    label.textColor = [UIColor blackColor];
    
    label.userInteractionEnabled = YES;
    
    return (MOLabelWidget *)label;
}

-(float)screenWidth{
    return [[UIScreen mainScreen]bounds].size.width;
}

+ (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height);
    }
    return size.height;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

@end
