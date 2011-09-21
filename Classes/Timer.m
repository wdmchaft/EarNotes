//
//  Timer.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/08.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "Timer.h"


@implementation Timer

@synthesize startDate;

-(id)init {
	if (self = [super init]) {
		
	}
	
	return self;
}

-(NSTimeInterval)start {
	if (startDate == nil) {
		self.startDate = [NSDate date];
		
		return 0.0;
	} else {
		NSDate *date = [NSDate date];
		
		NSTimeInterval interval = [date timeIntervalSinceDate:startDate];
		
		self.startDate = date;
		
		return interval;
	}
}

-(NSTimeInterval)stop {
	if (startDate == nil) {
		return 0.0;
	} else {
		NSDate *date = [NSDate date];
		
		NSTimeInterval interval = [date timeIntervalSinceDate: startDate];
	
		self.startDate = nil;
		
		return interval;
	}
}

-(NSTimeInterval)span {
	if (startDate == nil) {
		return 0.0;
	} else {
		return [[NSDate date] timeIntervalSinceDate: startDate];
	}
}

-(void)printSpan {
	NSLog(@"Time passed: %.3f seconds.", [self span]);
}

-(void)dealloc {
	[startDate release];
	[super dealloc];
}

@end
