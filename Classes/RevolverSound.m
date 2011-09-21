#import "RevolverSound.h"
#import "Sound.h"

@implementation RevolverSound

@synthesize gain, interval;
@synthesize soundPlayerThread;

- (id) initWithFile: (NSString*) file rounds: (int) max
{
    [super init];
	
	// Added by Tiago
	interval = 0.1;
	
    sounds = [[NSMutableArray alloc] init];
    for (int i=0; i<max; i++)
    {
        Sound *const sample = [[Sound alloc] initWithFile:file];
        if (!sample)
            return nil;
        [sounds addObject:sample];
        [sample release];
    }
	
	// Added by Tiago
	current = 0;
	
    return self;
}

- (id) initWithFiles: (NSMutableArray *)files andInterval: (float)anInterval {
	[super init];
	
	// Added by Tiago
	interval = anInterval;
	
	sounds = [[NSMutableArray alloc] init];
    for (int i=0; i<[files count]; i++)
    {
        Sound *const sample = [[Sound alloc] initWithFile:RSRC([files objectAtIndex:i])];
        if (!sample) {
			NSLog(@"Sample not loaded. File: %@", [files objectAtIndex:i]);
			//return nil;
		}
        [sounds addObject:sample];
        [sample release];
    }
	
	// Added by Tiago
	current = 0;
	
    return self;
}

- (void) dealloc
{
	[s1 release];
	[s2 release];
	[s3 release];
	[s4 release];
	[s5 release];
	[s6 release];
    [sounds release];
    [super dealloc];
}

- (void) play
{
    [[sounds objectAtIndex:current] play];
    //current = (current + 1) % [sounds count];
	
	// Added by Tiago
	current++;
	
	if (current >= [sounds count]) {
		current = 0;
	}
}

-(void)myPlay {
	[[sounds objectAtIndex:current] play];
    //current = (current + 1) % [sounds count];
	
	// Added by Tiago
	current++;
}

- (void) stop
{
    [[sounds objectAtIndex:current] stop];
}
static ALuint sourceID = 0;

- (void)playAllWithInterval {
	[NSThread setThreadPriority:1.0];
	ALint state;
    alGetSourcei(sourceID, AL_SOURCE_STATE, &state);
	int n=[sounds count];
	 ALuint *buffers = malloc(sizeof(int) * n);
	
	if (state == AL_PLAYING) {
		 alSourceStop(sourceID);
		alSourceQueueBuffers(sourceID, n, buffers);
		
		return;
	}
	
	
	
	if (sourceID == 0) {
		alGenSources(1, &sourceID);
	}
	
	
	for (int i=0; i<n; i++) {
		buffers[i] = [[sounds objectAtIndex:i] buffer];
		
	}
	
	alSourceQueueBuffers(sourceID, n, buffers);
	free(buffers);
	
	alSourcePlay(sourceID);
	
	while (TRUE) {
		alGetSourcei(sourceID, AL_SOURCE_STATE, &state);
		
		if (state == AL_PLAYING) {
			[NSThread sleepForTimeInterval:0.2];
		} else {
			break;
		}

	}
	
	/*
	 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	 
	 // Give the sound thread high priority to keep the timing steady.
	 [NSThread setThreadPriority:1.0];
	 BOOL continuePlaying = YES;
	 current = 0;
	 int n = [sounds count];
	 while (continuePlaying && (current < n)) {  // Loop until cancelled.
	 // An autorelease pool to prevent the build-up of temporary objects.
	 NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init]; 
	 
	 [self myPlay];
	 //[self performSelectorOnMainThread:@selector(animateArmToOppositeExtreme) withObject:nil waitUntilDone:NO];
	 NSDate *curtainTime = [[NSDate alloc] initWithTimeIntervalSinceNow:0.02];
	 NSDate *currentTime = [[NSDate alloc] init];
	 
	 // Wake up periodically to see if we've been cancelled.
	 while (continuePlaying && ([currentTime compare:curtainTime] != NSOrderedDescending)) { 
	 if ([soundPlayerThread isCancelled] == YES) {
	 continuePlaying = NO;
	 }
	 [NSThread sleepForTimeInterval:0.01];
	 [currentTime release];
	 currentTime = [[NSDate alloc] init];
	 }
	 [curtainTime release];		
	 [currentTime release];		
	 [loopPool drain];
	 }
	 [pool drain];*/
	/*
	 float n = (float)[sounds count];
	 if (current < n) {
	 [[sounds objectAtIndex:current] setGain: ((n - current) / n)];
	 [self myPlay];
	 [NSTimer scheduledTimerWithTimeInterval:0.1
	 target:self 
	 selector:@selector(playAllWithInterval) 
	 userInfo:nil 
	 repeats:NO];
	 //[self playAllWithInterval];
	 } else {
	 current = 0;
	 }
	 
	 */
	
}

- (void)startDriverThread {
    if (soundPlayerThread != nil) {
        [soundPlayerThread cancel];
        [self waitForSoundDriverThreadToFinish];
    }
    
    NSThread *driverThread = [[NSThread alloc] initWithTarget:self selector:@selector(playAllWithInterval) object:nil];
    self.soundPlayerThread = driverThread;
    [driverThread release];
    
    [self.soundPlayerThread start];
}

- (void)waitForSoundDriverThreadToFinish {
    while (soundPlayerThread && ![soundPlayerThread isFinished]) { // Wait for the thread to finish.
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)playS1 {
	[NSThread setThreadPriority:1.0];
	[s1 play];
}

- (void)playS2 {
	[NSThread setThreadPriority:1.0];
	[s2 play];
}

- (void)playS3 {
	[NSThread setThreadPriority:1.0];
	[s3 play];
}

- (void)playS4 {
	[NSThread setThreadPriority:1.0];
	[s4 play];
}

- (void)playS5 {
	[NSThread setThreadPriority:1.0];
	[s5 play];
}

- (void)playS6 {
	[NSThread setThreadPriority:1.0];
	[s1 play];
	
	
}

- (void) setGain: (float) val
{
    for (Sound *sound in sounds)
        [sound setGain:val];
}

- (float) gain
{
    return [[sounds lastObject] gain];
}

@end
