//
//  UIImage+Extension.m
//  TestAnimation
//
//  Created by O16Labs on 12/11/2018.
//  Copyright © 2018 O16 Labs. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
- (UIImage *)resizeToWidth:(CGFloat)width {
	UIImage *image = self;
	CGFloat oldWidth = image.size.width;
	CGFloat scaleFactor = width / oldWidth;
	CGFloat newHeight = image.size.height * scaleFactor;
	CGFloat newWidth = oldWidth * scaleFactor;
	CGSize scaleSize = CGSizeMake(newWidth, newHeight);
	UIGraphicsBeginImageContextWithOptions(scaleSize, YES, image.scale);
	[image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
	UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaleImage;
}
@end

//let newHeight = image.size.height * scaleFactor
//let newWidth = oldWidth * scaleFactor
//
//let scaledSize = CGSize(width:newWidth, height:newHeight)
//UIGraphicsBeginImageContextWithOptions(scaledSize, true, image.scale)
//image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
//let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//UIGraphicsEndImageContext()
//return scaledImage!
