//
//  Transition.m
//  TestAnimation
//
//  Created by O16Labs on 09/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "Transition.h"

@interface Transition ()
@property struct Params params;
@end

@implementation Transition

- (instancetype)init:(struct Params)params
{
	self.params = params;
	return [super init];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
	return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
	return nil;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
	CardPresentationController *controller = [[CardPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
	return controller;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	struct Params param = [self frame:self.params.fromCardFrame tableCell:self.params.fromCell frameWithoutTranform:self.params.fromCardFrameWithoutTransform];
	DismissCardAnimator *animator = [DismissCardAnimator.new init:param];
	return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	struct ParamsPresent param = [self frame:self.params.fromCardFrame tableCell:self.params.fromCell];
	PresentCardAnimator *animator = [PresentCardAnimator.new init:param];
	return animator;
}

- (struct ParamsPresent)frame:(CGRect)frame tableCell:(CardTableCell *)cell {
	struct ParamsPresent param;
	param.fromCardFrame = frame;
	param.fromCell = cell;
	return param;
}

- (struct Params)frame:(CGRect)frame tableCell:(CardTableCell *)cell frameWithoutTranform:(CGRect)frameTransform {
	struct Params param;
	param.fromCell = cell;
	param.fromCardFrameWithoutTransform = frameTransform;
	param.fromCardFrame = frame;
	return param;
}

@end
