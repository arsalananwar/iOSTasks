//
//  SecondViewController.m
//  TestAnimation
//
//  Created by O16Labs on 09/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dismisalPanGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *dismisalScreenEdge;
@property (nonatomic, assign) BOOL draggingDownToDismiss;
@property (nonatomic, strong) UIViewPropertyAnimator *dismissalAnimator;
@property (nonatomic, assign) CGPoint interactiveStartingPoint;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setProperties];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
}

- (void)setProperties {
	if (isEnabledDebugAnimatingViews) {
		self.scrollView.layer.borderColor = UIColor.greenColor.CGColor;
		self.scrollView.layer.borderWidth = 3;
		
		self.scrollView.subviews.firstObject.layer.borderWidth = 3;
		self.scrollView.subviews.firstObject.layer.borderColor = UIColor.purpleColor.CGColor;
	}
	
	self.draggingDownToDismiss = NO;
	
	[self.scrollView setDelegate:self];
	[self.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
	
	self.dismisalPanGesture = UIPanGestureRecognizer.new;
	[self.dismisalPanGesture setMaximumNumberOfTouches:1];
	[self.dismisalPanGesture setDelegate:self];
	[self.dismisalPanGesture addTarget:self action:@selector(handleDismissalPanGesture:)];
	
	
	self.dismisalScreenEdge = UIScreenEdgePanGestureRecognizer.new;
	[self.dismisalScreenEdge setEdges:UIRectEdgeLeft];
	[self.dismisalScreenEdge setDelegate:self];
	[self.dismisalScreenEdge addTarget:self action:@selector(handleDismissalPanGesture:)];
	
	[self.dismisalPanGesture requireGestureRecognizerToFail:self.dismisalScreenEdge];
	[self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.dismisalScreenEdge];
	
	[self loadViewIfNeeded];
	
	[self.view addGestureRecognizer:self.dismisalScreenEdge];
	[self.view addGestureRecognizer:self.dismisalPanGesture];
	
}

- (void)handleDismissalPanGesture:(UIPanGestureRecognizer *)gesture {
	BOOL isScreenEdgePan = [gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
	BOOL canStartDragDownToDismissPan = !isScreenEdgePan && !self.draggingDownToDismiss;
	
	if (canStartDragDownToDismissPan) {
		return;
	}
	
	UIView *targetAnimatedView = gesture.view;
	CGPoint startingPoint;
	if (!CGPointEqualToPoint(self.interactiveStartingPoint, CGPointZero)) {
		startingPoint = self.interactiveStartingPoint;
	}else {
		startingPoint = [gesture locationInView:nil];
		self.interactiveStartingPoint = startingPoint;
	}
	
	CGPoint currentLocation = [gesture locationInView:nil];
	CGFloat progress = isScreenEdgePan ? ([gesture translationInView:targetAnimatedView].x / 100) : (currentLocation.y - startingPoint.y) / 100;
	
	switch (gesture.state) {
		case UIGestureRecognizerStateBegan: {
			self.dismissalAnimator = [self createInteractiveDismissalAnimatorIfNeeded:targetAnimatedView progress:progress];
			break;
		}
		case UIGestureRecognizerStateChanged: {
			self.dismissalAnimator = [self createInteractiveDismissalAnimatorIfNeeded:targetAnimatedView progress:progress];
			BOOL isDismissalSuccess = progress >= 1;
			
			[self.dismissalAnimator setFractionComplete:progress];
			
			if (isDismissalSuccess) {
				[self.dismissalAnimator stopAnimation:NO];
				__weak typeof(self) weakSelf = self;
				[self.dismissalAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
					switch (finalPosition) {
						case UIViewAnimatingPositionEnd:
							[weakSelf dismissViewControllerAnimated:YES completion:nil];
							break;
						default:
							break;
					}
				}];
				[self.dismissalAnimator finishAnimationAtPosition:UIViewAnimatingPositionEnd];
			}
			
			break;
		}
		case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled: {
			if (self.dismissalAnimator == nil) {
				[self didCancelDismisalTransition];
				return;
			}
			
			[self.dismissalAnimator pauseAnimation];
			[self.dismissalAnimator setReversed:YES];
			
			[gesture setEnabled:NO];
			__weak typeof(self) weakSelf = self;
			[self.dismissalAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
				[weakSelf didCancelDismisalTransition];
				[gesture setEnabled:YES];
			}];
			[self.dismissalAnimator startAnimation];
			break;
		}
		default:
			break;
	}
	
}

- (UIViewPropertyAnimator *)createInteractiveDismissalAnimatorIfNeeded:(UIView *)targetView progress:(CGFloat)progress {
	CGFloat targetSkrinkScale = 0.86;
	CGFloat targetCornerRadius = cardCornerRadius;
	if (self.dismissalAnimator) {
		return self.dismissalAnimator;
	}else {
		self.dismissalAnimator = [UIViewPropertyAnimator.new initWithDuration:0 curve:UIViewAnimationCurveLinear animations:^{
			targetView.transform = CGAffineTransformMakeScale(targetSkrinkScale, targetSkrinkScale);
			targetView.layer.cornerRadius = targetCornerRadius;
		}];
		[self.dismissalAnimator setReversed:NO];
		[self.dismissalAnimator pauseAnimation];
		[self.dismissalAnimator setFractionComplete:progress];
		return self.dismissalAnimator;
	}
}

- (void)didCancelDismisalTransition {
	self.dismissalAnimator = nil;
	self.draggingDownToDismiss = NO;
	self.interactiveStartingPoint = CGPointZero;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.draggingDownToDismiss || (scrollView.isTracking && scrollView.contentOffset.y < 0)) {
		self.draggingDownToDismiss = true;
		scrollView.contentOffset = CGPointZero;
	}
	
	scrollView.showsVerticalScrollIndicator = !self.draggingDownToDismiss;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	if (velocity.y > 0 && scrollView.contentOffset.y <= 0) {
		scrollView.contentOffset = CGPointZero;
	}
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

@end
