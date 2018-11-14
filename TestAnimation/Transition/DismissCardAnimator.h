//
//  DismissCardAnimator.h
//  TestAnimation
//
//  Created by O16 Labs on 8/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DismissCardAnimator : NSObject <UIViewControllerAnimatedTransitioning>
- (instancetype)init:(struct Params)params;
@end

NS_ASSUME_NONNULL_END
