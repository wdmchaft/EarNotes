//
//  MyAppDelegate.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/27.
//  Copyright Unknow 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Finch.h"

@interface MyAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	Finch *soundEngine;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

