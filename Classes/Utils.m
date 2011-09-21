//
//  Utils.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/08/27.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "Utils.h"


@implementation Utils

+(void)alert: (NSString *)string {
	UIAlertView *alertView = [[UIAlertView alloc]  initWithTitle:@"Alerta" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alertView show];
	[alertView release];
}

+(void)log: (NSString *)str {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docsDirectory = [paths objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"log.txt"];
	
	NSData *dataToWrite = nil;
	if (path != nil) {
		dataToWrite = [[NSString stringWithFormat:@"%@\n%@", [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL], str] dataUsingEncoding:NSUTF8StringEncoding];
	} else {
		dataToWrite = [str dataUsingEncoding:NSUTF8StringEncoding];
	}
	
	// Write the file
	[dataToWrite writeToFile:path atomically:YES];

}


+(void)showAlertLog {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docsDirectory = [paths objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"log.txt"];

	NSString *s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
		[Utils alert:s];
	
}

+(void)reset {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docsDirectory = [paths objectAtIndex:0];
	NSString *path = [docsDirectory stringByAppendingPathComponent:@"log.txt"];
	
	NSData *dataToWrite = nil;
		dataToWrite = [[NSString stringWithString:@" "] dataUsingEncoding:NSUTF8StringEncoding];

	
	// Write the file
	[dataToWrite writeToFile:path atomically:YES];
}

@end
