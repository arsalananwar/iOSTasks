//
//  Constants.h
//  TestAnimation
//
//  Created by O16 Labs on 8/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enumerations.h"

NS_ASSUME_NONNULL_BEGIN

@interface Constants : NSObject
extern BOOL isEnabledDebugAnimatingViews;
extern BOOL isEnabledAllowsUserInteractionWhileHighlightingCard;
extern BOOL isEnabledWeirdTopInsetsFix;
extern CardVerticalExpandingStyle cardVerticalExpandingStyle;
extern CGFloat cardCornerRadius;
extern CGFloat cardHighlightedFactor;
extern CGFloat dismissalAnimationDuration;
@end

NS_ASSUME_NONNULL_END
