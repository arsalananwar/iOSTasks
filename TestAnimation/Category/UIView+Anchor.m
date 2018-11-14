//
//  UIView+Anchor.m
//  TestAnimation
//
//  Created by O16Labs on 12/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "UIView+Anchor.h"

@implementation UIView (Anchor)
- (void)edges:(UIView *)toView top:(CGFloat)top left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom {
	self.translatesAutoresizingMaskIntoConstraints = NO;
	NSArray<NSLayoutConstraint *> *constaints = @[
												  [self.topAnchor constraintEqualToAnchor:toView.topAnchor constant:top],
												  [self.bottomAnchor constraintEqualToAnchor:toView.bottomAnchor constant:bottom],
												  [self.leftAnchor constraintEqualToAnchor:toView.leftAnchor constant:left],
												  [self.rightAnchor constraintEqualToAnchor:toView.rightAnchor constant:right]
												  ];
	[NSLayoutConstraint activateConstraints:constaints];
}
@end
