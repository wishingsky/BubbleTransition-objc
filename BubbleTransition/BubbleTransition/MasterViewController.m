//
//  MasterViewController.m
//  BubbleTransition
//
//  Created by weixiaoyun on 15/7/12.
//  Copyright (c) 2015年 weixiaoyun. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "HJBubbleTransition.h"

@interface MasterViewController ()
<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) HJBubbleTransition *transition;

@property (nonatomic, strong) UIButton *button;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(260, self.view.frame.size.height - 50, 50, 50)];
    self.button.backgroundColor = [UIColor grayColor];
    [self.button setTitle:@"+" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(animationPresentedViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.button.layer.cornerRadius = self.button.frame.size.width/2.0f;
}

- (void)animationPresentedViewController:(id)sender
{
    DetailViewController *viewController = [[DetailViewController alloc] init];
    viewController.transitioningDelegate = self;
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transition.transitionMode = BubbleTransitionModePresent;
    self.transition.startRect = self.button.frame;
    self.transition.bubbleColor = self.button.backgroundColor;
    return self.transition;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transition.transitionMode = BubbleTransitionModeDismiss;
    self.transition.startRect = self.button.frame;
    self.transition.bubbleColor = self.button.backgroundColor;
    return self.transition;
}

-(HJBubbleTransition *)transition
{
    if (!_transition) {
        _transition = [[HJBubbleTransition alloc] init];
    }
    return _transition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
