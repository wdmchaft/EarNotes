//
//  MyAppDelegate.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/27.
//  Copyright Unknow 2010. All rights reserved.
//

#import "MyAppDelegate.h"
#import "NumericStats.h"
#import "QuizCreator.h"
#import "SharedAppData.h"
#import "QuizObject.h"
#import "QuizChord.h"
#import "Timer.h"

@implementation MyAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after application launch.
    soundEngine = [[Finch alloc] init];

	/*
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSError *error = nil;
	for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
		BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", directory, file] error:&error];
		if (!success || error) {
			// it failed.
		}
	}
	 */
	
	Timer *t = [[Timer alloc] init];
	[t start];
	//[[SharedAppData sharedInstance] deleteData];
	[[SharedAppData sharedInstance] loadData];
	[t printSpan];
	[t release];
	
    // Add the navigation controller's view to the window and display.
    [window addSubview: navigationController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	
	NSLog(@"App data saved.");
	[[SharedAppData sharedInstance] saveData];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	NSLog(@"App data loaded.");
	//[[SharedAppData sharedInstance] loadData]; 
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	
	[[SharedAppData sharedInstance] saveData];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[soundEngine release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

