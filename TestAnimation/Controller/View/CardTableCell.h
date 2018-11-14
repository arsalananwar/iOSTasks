//
//  CardTableCell.h
//  TestAnimation
//
//  Created by O16Labs on 09/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (void)resetTransform;
- (void)freezeAnimations;
- (void)unFreezeAnimations;

@end

NS_ASSUME_NONNULL_END
