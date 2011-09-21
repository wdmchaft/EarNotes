#import "Sound.h"

/*
    When you send the “play” message to a regular sound
    (instance of Sound.m), the sound rewinds and plays from
    the start. This is not always desirable, a lot of times
    you would like to play many instances of the same sound
    simultaneously (think machinegun). This is what this
    class is for.
*/
@interface RevolverSound : NSObject
{
    NSMutableArray *sounds;
    int current;
	float interval;
	
	 NSThread *soundPlayerThread;
	Sound *s1, *s2, *s3, *s4, *s5, *s6;
}

@property(assign) float gain;
@property(assign) float interval;

@property(nonatomic, retain)NSThread *soundPlayerThread;

- (id) initWithFile: (NSString*) file rounds: (int) max;
- (id) initWithFiles: (NSMutableArray *)files andInterval: (float)anInterval;

- (void) play;
- (void) stop;

- (void)playAllWithInterval;

@end
