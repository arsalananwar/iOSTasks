//
//  Transition.h
//  TestAnimation
//
//  Created by O16Labs on 09/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../Controller/View/CardTableCell.h"

NS_ASSUME_NONNULL_BEGIN

struct Params {
	CGRect fromCardFrame;
	CGRect fromCardFrameWithoutTransform;
	CardTableCell *fromCell;
};

@interface Transition : NSObject <UIViewControllerTransitioningDelegate>
- (instancetype)init:(struct Params)params;
@end

NS_ASSUME_NONNULL_END
