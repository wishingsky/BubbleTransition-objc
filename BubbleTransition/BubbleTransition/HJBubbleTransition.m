//
//  HJBubbleTransition.h
//  BubbleTransition
//
//  Created by weixiaoyun on 15/7/12.
//  Copyright (c) 2015年 weixiaoyun. All rights reserved.
//


#import "HJBubbleTransition.h"

typedef void(^animatorCompletionBlock)();

@interface Animator()
{
    animatorCompletionBlock completitionBlock;
    CALayer * animLayer;
    CAAnimation * caAnimation;
}

@end

@implementation Animator

-(void)startAnimation:(void(^)())complBlock
{
    completitionBlock=complBlock;
    [animLayer addAnimation:caAnimation forKey:@"animator"];
}

-(instancetype)initWithLayer:(CALayer*)layer andAnimation:(CAAnimation*)anim
{
    if (self = [super init]) {
        animLayer = layer;
        caAnimation = anim;
        anim.delegate = self;
    }
    return self;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    completitionBlock();
    
}

@end


@interface HJBubbleTransition ()

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation HJBubbleTransition

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [[CAShapeLayer alloc] init];
    }
    return _maskLayer;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.startRect = CGRectZero;
        self.duration = 0.5f;
        self.transitionMode = BubbleTransitionModePresent;
        self.bubbleColor = [UIColor grayColor];
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning protocol

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    if (self.transitionMode == BubbleTransitionModePresent) {
        UIViewController *presentedController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        presentedController.view.backgroundColor = self.bubbleColor;
        
        UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        [containerView insertSubview:presentedController.view aboveSubview:fromViewController.view];
        
        [self bubblePresentView:presentedController.view fromRect:self.startRect andComplitBLock:^{
            [transitionContext completeTransition:YES];
        }];
    } else if (self.transitionMode == BubbleTransitionModeDismiss) {
        UIViewController *returningController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        [self bubbleDismissView:returningController.view toRect:self.startRect andComplitBLock:^{
            [returningController.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    } else {
        
    }
}

#pragma mark - private mathod

-(void)bubblePresentView:(UIView *)view
                fromRect:(CGRect)fromRect
         andComplitBLock:(void(^)())complBlock
{
    
    CGPathRef fromPath = CGPathCreateWithEllipseInRect(fromRect, NULL);
    self.maskLayer.path = fromPath;
    view.layer.mask = self.maskLayer;

    float d = sqrtf(powf(view.frame.size.width, 2) + powf(view.frame.size.height, 2));
    d *= 2;
    
    CGRect toRect=  CGRectMake(view.frame.size.width/2-d/2 ,fromRect.origin.y-d/2, d, d);
    CGPathRef toPath = CGPathCreateWithEllipseInRect(toRect, NULL);
    
    [self bubbleAnimationFromValue:fromPath toValue:toPath completeBLock:^{
        complBlock();
    }];
}

-(void)bubbleDismissView:(UIView *)view
                  toRect:(CGRect)toRect
         andComplitBLock:(void (^)())complBlock
{
    
    float d = sqrtf(powf(view.frame.size.width, 2) + powf(view.frame.size.height, 2));
    d *= 2;
    
    CGRect fromRect = CGRectMake(view.frame.size.width/2-d/2 ,toRect.origin.y-d/2, d, d);
    CGPathRef fromPath = CGPathCreateWithEllipseInRect(fromRect, NULL);
    self.maskLayer.path = fromPath;
    view.layer.mask = self.maskLayer;
    
    CGPathRef toPath = CGPathCreateWithEllipseInRect(toRect, NULL);
    
    [self bubbleAnimationFromValue:fromPath toValue:toPath completeBLock:^{
        complBlock();
    }];
}

- (void)bubbleAnimationFromValue:(CGPathRef)fromValue
                         toValue:(CGPathRef)toVaule
                   completeBLock:(void (^)())completeBlock

{
    CABasicAnimation* bubbleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    bubbleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    bubbleAnimation.fromValue = (__bridge id)(fromValue);
    bubbleAnimation.toValue = (__bridge id)(toVaule);
    bubbleAnimation.duration = self.duration;
    self.maskLayer.path = toVaule;
    CGPathRelease(fromValue);
    CGPathRelease(toVaule);
    
    Animator * animator=[[Animator alloc] initWithLayer:self.maskLayer andAnimation:bubbleAnimation];
    
    [animator startAnimation:^{
        [self.maskLayer removeFromSuperlayer];
        completeBlock();
    }];
}

@end
