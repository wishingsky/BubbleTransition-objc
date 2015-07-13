//
//  HJBubbleTransition.h
//  BubbleTransition
//
//  Created by weixiaoyun on 15/7/12.
//  Copyright (c) 2015年 weixiaoyun. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BubbleTransitionMode) {
    BubbleTransitionModePresent,
    BubbleTransitionModeDismiss,
};

@interface Animator: NSObject

-(void)startAnimation:(void(^)())complBlock;
-(instancetype)initWithLayer:(CALayer*)layer andAnimation:(CAAnimation*)anim;

@end;

@interface HJBubbleTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect startRect;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BubbleTransitionMode transitionMode;
@property (nonatomic, strong) UIColor *bubbleColor;

@end
