//
//  CardPresentationController.m
//  TestAnimation
//
//  Created by O16Labs on 12/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "CardPresentationController.h"

@interface CardPresentationController ()
@property (nonatomic, strong) UIVisualEffectView *blurView;
@end

@implementation CardPresentationController

- (UIVisualEffectView *)blurView {
	if (_blurView == nil) {
		_blurView = [[UIVisualEffectView alloc] initWithEffect:nil];
	}
	return _blurView;
}

- (BOOL)shouldRemovePresentersView {
	return NO;
}


- (void)presentationTransitionWillBegin {
	UIView *container = self.containerView;
	[container addSubview:self.blurView];
	self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.blurView edges:container top:0 left:0 right:0 bottom:0];
	self.blurView.alpha = 0;
	
	[self.presentingViewController beginAppearanceTransition:NO animated:NO];
	[self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
		[UIView animateWithDuration:0.5 animations:^{
			self.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			self.blurView.alpha = 1;
		}];
	} completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
		
	}];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
	[self.presentingViewController endAppearanceTransition];
}

- (void)dismissalTransitionWillBegin {
	[self.presentingViewController beginAppearanceTransition:YES animated:YES];
	[self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
		self.blurView.alpha = 0;
	} completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
	[self.presentingViewController endAppearanceTransition];
	if (completed) {
		[self.blurView removeFromSuperview];
	}
}
@end
