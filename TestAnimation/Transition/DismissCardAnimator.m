//
//  DismissCardAnimator.m
//  TestAnimation
//
//  Created by O16 Labs on 8/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "DismissCardAnimator.h"

const NSTimeInterval relativeDurationBeforeNonInteractive = 0.5;
const CGFloat minimumScaleBeforeNonInteractive = 0.8;

@interface DismissCardAnimator ()
@property (nonatomic) struct Params params;
@end

@implementation DismissCardAnimator

- (instancetype)init:(struct Params)params {
	self.params = params;
	return [super init];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return dismissalAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIView *container = transitionContext.containerView;
	SecondViewController *cardController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	
	UIView *cardDetailView = [transitionContext viewForKey:UITransitionContextFromViewKey];
	
	UIView *animatedContainerView = UIView.new;
	if (isEnabledDebugAnimatingViews) {
		animatedContainerView.layer.borderColor = UIColor.yellowColor.CGColor;
		animatedContainerView.layer.borderWidth = 4;
		cardDetailView.layer.borderWidth = 2;
		cardDetailView.layer.borderColor = UIColor.redColor.CGColor;
	}
	
	animatedContainerView.translatesAutoresizingMaskIntoConstraints = NO;
	cardDetailView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[container removeConstraints:container.constraints];
	
	[container addSubview:animatedContainerView];
	[animatedContainerView addSubview:cardDetailView];
	
	[cardDetailView edges:animatedContainerView top:0 left:0 right:0 bottom:0];
	
	[[animatedContainerView.centerXAnchor constraintEqualToAnchor:container.centerXAnchor] setActive:YES];
	
	NSLayoutConstraint *animatedContainerTopConstraint = [animatedContainerView.topAnchor constraintEqualToAnchor:container.topAnchor constant:0];
	NSLayoutConstraint *animatedContainerWidthConstraint = [animatedContainerView.widthAnchor constraintEqualToConstant:cardDetailView.frame.size.width];
	NSLayoutConstraint *animatedContainerHeightConstraint = [animatedContainerView.heightAnchor constraintEqualToConstant:cardDetailView.frame.size.height];
	
	[NSLayoutConstraint activateConstraints:@[animatedContainerTopConstraint, animatedContainerWidthConstraint, animatedContainerHeightConstraint]];
	
	NSLayoutConstraint *topTemporaryFix = [cardController.view.topAnchor constraintEqualToAnchor:cardDetailView.topAnchor];
	[topTemporaryFix setActive:isEnabledWeirdTopInsetsFix];
	
	[container layoutIfNeeded];
	
	NSLayoutConstraint *stretchCardToFillBottom = [cardController.cardContentView.bottomAnchor constraintEqualToAnchor:cardDetailView.bottomAnchor];
	
	[UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
		[stretchCardToFillBottom setActive:YES];
		cardDetailView.transform = CGAffineTransformIdentity;
		[animatedContainerTopConstraint setConstant:CGRectGetMinY(self.params.fromCardFrameWithoutTransform)];
		[animatedContainerWidthConstraint setConstant:self.params.fromCardFrameWithoutTransform.size.width];
		[animatedContainerHeightConstraint setConstant:self.params.fromCardFrameWithoutTransform.size.height];
		[container layoutIfNeeded];
	} completion:^(BOOL finished) {
		BOOL success = !transitionContext.transitionWasCancelled;
		[animatedContainerView removeConstraints:animatedContainerView.constraints];
		[animatedContainerView removeFromSuperview];
		if (success) {
			[cardDetailView removeFromSuperview];
			[self.params.fromCell setHidden:NO];
		}else {
			[topTemporaryFix setActive:NO];
			[cardDetailView removeConstraint:topTemporaryFix];
			[cardDetailView removeConstraint:stretchCardToFillBottom];
			
			[container removeConstraints:container.constraints];
			[container addSubview:cardDetailView];[cardDetailView edges:container top:0 left:0 right:0 bottom:0];
		}
		[transitionContext completeTransition:success];
	}];
	
	
	[UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
		cardController.scrollView.contentOffset = CGPointZero;
	}];
}

@end
