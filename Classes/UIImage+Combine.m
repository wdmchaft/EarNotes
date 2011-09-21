//
//  UIImage+Combine.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/28.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "UIImage+Combine.h"

@implementation UIImage (Combine)

+(UIImage *)imageFromImage: (UIImage *)backgroundImage andOverlayedImage: (UIImage*)overlayImage {
	
	// size is taken from the background image
	UIGraphicsBeginImageContext(backgroundImage.size);
	
	[backgroundImage drawAtPoint:CGPointZero];
	[overlayImage drawAtPoint:CGPointZero];
	
	/*
	 // If Image Artifacts appear, replace the "overlayImage drawAtPoint" , method with the following
	 // Yes, it's a workaround, yes I filed a bug report
	 CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
	 [overlayImage drawInRect:imageRect blendMode:kCGBlendModeOverlay alpha:0.999999999];
	 */
	
	UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return combinedImage;
}

+(UIImage *)imageFromImageNamed: (NSString *)backgroundImageFilename andOverlayImageNamed: (NSString*)overlayImageFilename {
	UIImage *backgroundImage = [UIImage imageNamed:backgroundImageFilename];
	UIImage *overlayImage = [UIImage imageNamed:overlayImageFilename];
	
	return [UIImage imageFromImage:backgroundImage andOverlayedImage:overlayImage];
}

@end
