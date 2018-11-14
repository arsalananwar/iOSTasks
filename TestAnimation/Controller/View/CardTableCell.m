//
//  CardTableCell.m
//  TestAnimation
//
//  Created by O16Labs on 09/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "CardTableCell.h"

@interface CardTableCell ()
@property (nonatomic, assign) BOOL disabledHighlightedAnimation;
@end

@implementation CardTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
	[self setupProperties];
}

- (void)setupProperties {
	self.containerView.layer.cornerRadius = 12;
	self.containerView.layer.masksToBounds = true;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)resetTransform {
	self.containerView.transform = CGAffineTransformIdentity;
}

- (void)freezeAnimations {
	self.disabledHighlightedAnimation = YES;
	[self.layer removeAllAnimations];
}

- (void)unFreezeAnimations {
	self.disabledHighlightedAnimation = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	[self animate:YES completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	[self animate:NO completion:nil];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	[self animate:NO completion:nil];
}

- (void)animate:(BOOL)isHighlight completion:(void (^ _Nullable)(BOOL finished))completion {
	if (self.disabledHighlightedAnimation) {
		completion(NO);
		return;
	}
	
	UIViewAnimationOptions options = isEnabledAllowsUserInteractionWhileHighlightingCard ? UIViewAnimationOptionAllowUserInteraction : UIViewAnimationOptionTransitionNone;
	if (isHighlight) {
		[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:options animations:^{
			self.containerView.transform = CGAffineTransformMakeScale(cardHighlightedFactor, cardHighlightedFactor);
		} completion:completion];
	}
    else {
		[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:options animations:^{
			[self resetTransform];
		} completion:completion];
	}
}

@end
