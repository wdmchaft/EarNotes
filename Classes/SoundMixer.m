//
//  SoundMixer.m
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/01.
//  Copyright 2010 Unknow. All rights reserved.
//

#import "SoundMixer.h"


@implementation SoundMixer

@synthesize sounds;

- (id) initWithFiles: (NSMutableArray *)files andInterval: (float)anInterval {
	[super init];
	
	int num = 0;
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	self.sounds = array;
	
	[array release];
	
    for (int i=0; i<[files count]; i++)
    {
        Sound *const sample = [[Sound alloc] initWithFile:RSRC([files objectAtIndex:i])];
        if (!sample)
            return nil;
        [sounds addObject:sample];
        [sample release];
    }
	
    return self;
}
static ALuint sourceID = 0;

-(void)play {
	ALuint source[6];
	
	if (sourceID == 0) {
		alGenSources(1, &sourceID);
	}
	
	
	for (int i=0; i<6; i++) {
		alSourceQueueBuffers(sourceID, 1, [[sounds objectAtIndex:i] getBufferPointer]);
	}
	
	alSourcePlay(source);
}

-(void)dealloc {
	[sounds release];
	[super release];
}

@end
