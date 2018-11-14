//
//  PresentCardTransitionDriver.m
//  TestAnimation
//
//  Created by O16Labs on 12/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "PresentCardTransitionDriver.h"

@implementation PresentCardTransitionDriver
- (instancetype)init:(struct ParamsPresent)params transitionContext:(id<UIViewControllerContextTransitioning>)context baseAnimator:(UIViewPropertyAnimator *)baseAnimator {
	UIView *container = context.containerView;
	SecondViewController *cardController = [context viewControllerForKey:UITransitionContextToViewControllerKey];
	
	UIView *cardDetailView = [context viewForKey:UITransitionContextToViewKey];
	CGRect fromCardFrame = params.fromCardFrame;
	
	UIView *animatedContainerView = UIView.new;
	animatedContainerView.translatesAutoresizingMaskIntoConstraints = NO;
	
	if (isEnabledDebugAnimatingViews) {
		animatedContainerView.layer.borderColor = UIColor.yellowColor.CGColor;
		animatedContainerView.layer.borderWidth = 4;
		cardDetailView.layer.borderWidth = 2;
		cardDetailView.layer.borderColor = UIColor.redColor.CGColor;
	}
	
	[container addSubview:animatedContainerView];
	[animatedContainerView addSubview:cardDetailView];
	cardDetailView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSArray<NSLayoutConstraint *> *constraint = @[
												  [animatedContainerView.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
												  [animatedContainerView.widthAnchor constraintEqualToConstant:container.bounds.size.width],
												  [animatedContainerView.heightAnchor constraintEqualToConstant:container.bounds.size.height]
												  ];
	
	NSArray<NSLayoutConstraint *> *cardConstraints = @[
													   [cardDetailView.centerXAnchor constraintEqualToAnchor:animatedContainerView.centerXAnchor]
													   ];
	
	NSLayoutConstraint *remainingConstraint;
	NSLayoutConstraint *cardRemainingConstraint;
	
	NSLayoutConstraint *cardWidthConstraint = [cardDetailView.widthAnchor constraintEqualToConstant:fromCardFrame.size.width];
	[cardWidthConstraint setActive:YES];
	NSLayoutConstraint *cardHeightConstraint = [cardDetailView.heightAnchor constraintEqualToConstant:fromCardFrame.size.height];
	[cardHeightConstraint setActive:YES];
	
	switch (cardVerticalExpandingStyle) {
		case CardVerticalExpandingStyleTop:
			remainingConstraint = [animatedContainerView.topAnchor constraintEqualToAnchor:container.topAnchor constant:CGRectGetMinY(fromCardFrame)];
			cardRemainingConstraint = [cardDetailView.topAnchor constraintEqualToAnchor:animatedContainerView.topAnchor constant:-1];
			break;
		case CardVerticalExpandingStyleCenter:
			remainingConstraint = [animatedContainerView.centerYAnchor constraintEqualToAnchor:container.centerYAnchor constant:(fromCardFrame.size.height / 2 + CGRectGetMinY(fromCardFrame)) - (container.bounds.size.height / 2)];
			cardRemainingConstraint = [cardDetailView.centerYAnchor constraintEqualToAnchor:animatedContainerView.centerYAnchor];
			break;
	}
	
	[NSLayoutConstraint activateConstraints:constraint];
	[NSLayoutConstraint activateConstraints:cardConstraints];
	
	[remainingConstraint setActive:YES];
	[cardRemainingConstraint setActive:YES];
	
	cardDetailView.layer.cornerRadius = cardCornerRadius;
	
	[params.fromCell setHidden:YES];
	[params.fromCell resetTransform];
	
	NSLayoutConstraint *topTemporaryConstraint = [cardController.cardContentView.topAnchor constraintEqualToAnchor:cardDetailView.topAnchor constant:0];
	[topTemporaryConstraint setActive:YES];
	
	[container layoutIfNeeded];
	
	[baseAnimator addAnimations:^{
		[remainingConstraint setConstant:0];
		[container layoutIfNeeded];
		
		UIViewPropertyAnimator *animator = [UIViewPropertyAnimator.new initWithDuration:baseAnimator.duration * 0.6 curve:UIViewAnimationCurveLinear animations:^{
			[cardHeightConstraint setConstant:animatedContainerView.bounds.size.height];
			[cardHeightConstraint setConstant:animatedContainerView.bounds.size.width];
			cardDetailView.layer.cornerRadius = 0;
			[cardDetailView layoutIfNeeded];
		}];
		
		[animator startAnimation];
	}];
	
	[baseAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
		[animatedContainerView removeConstraints:animatedContainerView.constraints];
		[animatedContainerView removeFromSuperview];
		
		[container addSubview:cardDetailView];
		
		[cardDetailView removeConstraints:@[topTemporaryConstraint, cardWidthConstraint, cardHeightConstraint]];
		
		[cardDetailView edges:container top:-1 left:0 right:0 bottom:0];
		
		[cardController.cardBottomToRootBottomConstraint setActive:NO];
		[cardController.scrollView setScrollEnabled:YES];
		
		BOOL success = !context.transitionWasCancelled;
		[context completeTransition:success];
	}];
	
	self.animator = baseAnimator;
	
	return [super init];
}
@end
