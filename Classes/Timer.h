//
//  Timer.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/08.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Timer : NSObject {
	NSDate *startDate;
}

@property(retain) NSDate *startDate;

-(NSTimeInterval)start;
-(NSTimeInterval)stop;
-(NSTimeInterval)span;

-(void)printSpan;

@end
