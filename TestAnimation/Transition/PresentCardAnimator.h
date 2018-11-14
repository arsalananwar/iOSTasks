//
//  PresentCardAnimator.h
//  TestAnimation
//
//  Created by O16Labs on 12/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct ParamsPresent {
	CGRect fromCardFrame;
	CardTableCell *fromCell;
};

@interface PresentCardAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)init:(struct ParamsPresent)params;

@end

NS_ASSUME_NONNULL_END
