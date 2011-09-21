//
//  UIImage+Combine.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/28.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Combine)
+(UIImage *)imageFromImage: (UIImage *)backgroundImage 
		 andOverlayedImage: (UIImage *)overlayImage;
+(UIImage *)imageFromImageNamed: (NSString *)backgroundImageFilename 
		   andOverlayImageNamed: (NSString *)overlayImageFilename;
@end
