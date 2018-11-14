//
//  PresentCardTransitionDriver.h
//  TestAnimation
//
//  Created by O16Labs on 12/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PresentCardTransitionDriver : NSObject
@property (nonatomic, strong) UIViewPropertyAnimator *animator;

- (instancetype)init:(struct ParamsPresent)params transitionContext:(id<UIViewControllerContextTransitioning>)context baseAnimator:(UIViewPropertyAnimator*)animator;
@end

NS_ASSUME_NONNULL_END
