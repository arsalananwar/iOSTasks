//
//  PresentCardAnimator.m
//  TestAnimation
//
//  Created by O16Labs on 12/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "PresentCardAnimator.h"
#import "PresentCardTransitionDriver.h"

@interface PresentCardAnimator ()
@property (nonatomic) struct ParamsPresent params;
@property (nonatomic, assign) NSTimeInterval presentAnimationDuration;
@property (nonatomic, strong) UIViewPropertyAnimator *springAnimator;
@property (nonatomic, strong) PresentCardTransitionDriver *transitionDriver;


//private var transitionDriver: PresentCardTransitionDriver?
@end

@implementation PresentCardAnimator
- (instancetype)init:(struct ParamsPresent)params
{
	self.params = params;
	self.springAnimator = [PresentCardAnimator createBaseSpringAnimator:params];
	self.presentAnimationDuration = self.springAnimator.duration;
	return [super init];
}

+(UIViewPropertyAnimator *)createBaseSpringAnimator:(struct ParamsPresent)params {
	CGFloat cardPositionY = CGRectGetMinY(params.fromCardFrame);
	CGFloat distanceToBounce = fabs(CGRectGetMinY(params.fromCardFrame));
	CGFloat extentToBounce = cardPositionY < 0 ? params.fromCardFrame.size.height : [UIScreen mainScreen].bounds.size.height;
	CGFloat dampFactorInterval = 0.3;
	CGFloat damping = 1 - dampFactorInterval * (distanceToBounce / extentToBounce);
	NSTimeInterval baselineDuration = 0.5;
	NSTimeInterval maxDuration = 0.9;
	NSTimeInterval computedValue = MAX(0, distanceToBounce) / [UIScreen mainScreen].bounds.size.height;
	NSTimeInterval duration = baselineDuration + (maxDuration - baselineDuration) * computedValue;
	UISpringTimingParameters *springTiming = [UISpringTimingParameters.new initWithDampingRatio:damping initialVelocity:CGVectorMake(0, 0)];
	UIViewPropertyAnimator *animator = [UIViewPropertyAnimator.new initWithDuration:duration timingParameters:springTiming];
	return animator;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return self.presentAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	self.transitionDriver = [[PresentCardTransitionDriver alloc] init:self.params transitionContext:transitionContext baseAnimator:self.springAnimator];
	[[self interruptibleAnimator:transitionContext] startAnimation];
}

- (void)animationEnded:(BOOL)transitionCompleted {
	self.transitionDriver = nil;
}

- (id<UIViewImplicitlyAnimating>)interruptibleAnimator:(id<UIViewControllerContextTransitioning>)context {
	return self.transitionDriver.animator;
}

@end
