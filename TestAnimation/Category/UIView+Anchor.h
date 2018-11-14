//
//  UIView+Anchor.h
//  TestAnimation
//
//  Created by O16Labs on 12/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Anchor)
-(void) edges:(UIView *)toView top:(CGFloat)top left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom;
@end

NS_ASSUME_NONNULL_END
