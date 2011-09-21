//
//  SoundMixer.h
//  TFC-iEarNotes
//
//  Created by Tiago Bras on 10/10/01.
//  Copyright 2010 Unknow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sound.h"

@interface SoundMixer : NSObject {
	NSMutableArray *sounds;
}

@property(retain, nonatomic) NSMutableArray *sounds;

@end
