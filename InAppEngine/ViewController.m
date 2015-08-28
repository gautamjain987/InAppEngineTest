//
//  ViewController.m
//  InAppEngine
//
//  Created by Gautam on 03/06/15.
//  Copyright (c) 2015 Gautam. All rights reserved.
//

#import "ViewController.h"
#import "InAppViewCreator.h"

@import AdSupport;
@import QuartzCore;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ad id is %@",[ViewController advertiserID]);
//    self.view.backgroundColor = [UIColor blueColor];
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [backgroundView setImage:[UIImage imageNamed:@"uber.png"]];
//    [self.view addSubview:backgroundView];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0){
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *bluredView = [[UIVisualEffectView alloc] initWithEffect:effect];
        bluredView.frame = self.view.bounds;
//        [self.view addSubview:bluredView];
    }
    
    UIView *inappView = [[InAppViewCreator alloc]initWithDictionary:nil];
    [self.view addSubview:inappView];
    return;
    
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"A",@"B",@"C", @"D", @"E", nil];
//    [array removeObjectAtIndex:0];
//    [array removeObjectAtIndex:0];
//    
//    NSLog(@"object at index 0 is %@", array[0]);
//    
//    NSLog(@"explored description is %@", [array description]);
//    
//    [array insertObject:@"B" atIndex:0];
//    
//    [array insertObject:@"A" atIndex:0];
    
/*
    UIView *superview = self.view;
    
    UILabel *mylabel = [[UILabel alloc]init];
    mylabel.numberOfLines = 0;
    [mylabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    mylabel.text = @"MyLabel is awesomeness. bldskfsdlkfjsdlkfjdlskf";
    
    UIButton *mybutton = [UIButton
                          buttonWithType:UIButtonTypeRoundedRect];
    [mybutton setTitle:@"My Button"
              forState:UIControlStateNormal];
    [mybutton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [superview addSubview:mylabel];
    [superview addSubview:mybutton];
    
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                       constraintWithItem:mylabel
                                       attribute:NSLayoutAttributeCenterY
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:superview
                                       attribute:NSLayoutAttributeCenterY
                                       multiplier:1.0
                                       constant:0];
    
//    [superview addConstraint:myConstraint];
    
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:mylabel
//                   attribute:NSLayoutAttributeCenterX
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:superview
//                   attribute:NSLayoutAttributeCenterX
//                   multiplier:1.0
//                   constant:0];
//    
    
    myConstraint = [NSLayoutConstraint constraintWithItem:mylabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:70.f];
    
//    [self.view addConstraint:constraint];
    
    
    [superview addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint constraintWithItem:mybutton
                                               attribute:NSLayoutAttributeTrailing
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:mylabel
                                               attribute:NSLayoutAttributeLeading
                                              multiplier:1
                                                constant:-10];
    
    [superview addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint constraintWithItem:mybutton
                                               attribute:NSLayoutAttributeTop
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:mylabel
                                               attribute:NSLayoutAttributeTop
                                              multiplier:1
                                                constant:0];
    
    [superview addConstraint:myConstraint];
    
    
    // Label width constraints
    
    myConstraint = [NSLayoutConstraint constraintWithItem:mylabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:120];
    
    [superview addConstraint:myConstraint];
    
    
    
//    [self drawViewWithJson:];

*/
    [self setViewsWithoutAutoLayout];

//    [self setViewsWithAutoLayout];
}

+(NSString *)advertiserID{
    NSString *advertiserID = nil;
    if ([ASIdentifierManager class]) {
        ASIdentifierManager *manager = [ASIdentifierManager sharedManager];
        if([manager isAdvertisingTrackingEnabled]){
            advertiserID = [[manager advertisingIdentifier] UUIDString];
        }
    }
    return advertiserID;
}

-(void)setViewsWithoutAutoLayout{
    
    UIView *superView = self.view;
    
    //    3 widgets
    // 1. text - top 20, center X, padding left - 20, padding right - 20
    
    // 2. text - top - 20, center - X, padding left - 20, padding right - 20
    
    // 3. button - top 20, center - x, width 100.
    
    int top = 20;
    int left = 20;
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(superView.frame.origin.x + left  , 80, superView.frame.size.width - left*2, 20)];
    textLabel.text = @"hello whow kada you";
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *aboveView = (UIView *)textLabel;
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(superView.frame.origin.x + left, aboveView.frame.origin.y + aboveView.frame.size.height + top, superView.frame.size.width - left*2 , 46)];
    descLabel.text = @"lots of offers running today. hurry. offer valid till stock lasts";
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;
    
    aboveView = (UIView *)descLabel;
    
    BOOL buttonCenterAligned = YES;
    UIButton *button;
    
    if(buttonCenterAligned){
        button = [[UIButton alloc]initWithFrame:CGRectMake(superView.frame.size.width/2-80/2, aboveView.frame.origin.y + aboveView.frame.size.height + top, 80, 40)];
        [button setTitle:@"wohooo" forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor grayColor];
    }
    button.backgroundColor = [UIColor redColor];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, top, superView.frame.size.width, superView.frame.size.height)];
    
    UIView *papaView = [[UIView alloc]initWithFrame:CGRectMake(0, top + 50, superView.frame.size.width, 200)];
    [scrollView addSubview:papaView];
    
    [papaView addSubview:textLabel];
    [papaView addSubview:descLabel];
    [papaView addSubview:button];
    papaView.backgroundColor = [UIColor purpleColor];
    
    scrollView.contentSize = CGSizeMake(2000, 2000);
    
    [scrollView setTag:101];
    scrollView.scrollEnabled = YES;
    
//    [superView addSubview:scrollView];
    
    [scrollView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
        [superView addSubview:textLabel];
        [superView addSubview:descLabel];
        [superView addSubview:button];
}

-(void)setViewsWithAutoLayout{
    UIView *superView = self.view;
    
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor orangeColor];
    [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [superView addSubview:containerView];
    
//    
//    NSLayoutConstraint *myConstraint = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];
//    [superView addConstraint:myConstraint];
    
    NSLayoutConstraint *myConstraint = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20];
    [superView addConstraint:myConstraint];
    
    
    myConstraint = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:40];
    [superView addConstraint:myConstraint];
    
    myConstraint = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:superView.frame.size.width-200];
    [superView addConstraint:myConstraint];

    myConstraint = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:superView.frame.size.height-340];
    [superView addConstraint:myConstraint];
    
    
    
    
}


-(void)viewDidLayoutSubviews{
//    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
//    [scrollView setContentSize:CGSizeMake(2000, 2000)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
