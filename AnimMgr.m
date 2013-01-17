//
//  AnimMgr.m
//  animnobi
//
//  Created by Shu Chiun Cheah on 9/6/12.
//  Copyright (c) 2012 Shunobi. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
//  NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "AnimMgr.h"
#import "AnimClip.h"

@implementation AnimMgr

- (id) init
{
    self = [super init];
    if(self)
    {
        _animObjects = [NSMutableArray arrayWithCapacity:10];
        _clipReg = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (void) addAnimObject:(NSObject<AnimDelegate>*)animObject
{
    [_animObjects addObject:animObject];
}

- (void) removeAnimObject:(NSObject<AnimDelegate>*)animObject
{
    [_animObjects removeObject:animObject];
}

- (void) update:(NSTimeInterval)elapsed
{
    for(NSObject<AnimDelegate>* cur in _animObjects)
    {
        [cur animUpdate:elapsed];
    }
}

#pragma mark - clips anim

// returns an array with names of loaded clips
- (NSArray*) addClipsFromPlistFile:(NSString *)filename
{
    NSMutableArray* loadedNames = [NSMutableArray arrayWithCapacity:10];
    NSString* filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSDictionary* newClips = [NSDictionary dictionaryWithContentsOfFile:filepath];
    for(NSString* key in newClips)
    {
        if(![_clipReg objectForKey:key])
        {
            NSDictionary* clipDict = [newClips objectForKey:key];
            AnimClip* clip = [[AnimClip alloc] initWithDictionary:clipDict];
            [_clipReg setObject:clip forKey:key];
            [loadedNames addObject:key];
        }
        else
        {
            NSLog(@"Warning: clip %@ from file %@ not added; same name already exists", key, filename);
        }
    }
    return loadedNames;
}

- (void) removeClipsInNameArray:(NSArray *)nameArray
{
    for(NSString* name in nameArray)
    {
        [_clipReg removeObjectForKey:name];
    }
}

- (AnimClip*) getClipWithName:(NSString *)clipname
{
    return [_clipReg objectForKey:clipname];
}

#pragma mark - Singleton
static AnimMgr* singleton = nil;
+ (AnimMgr*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
			singleton = [[AnimMgr alloc] init];
		}
	}
	return singleton;
}

+ (void) destroyInstance
{
	@synchronized(self)
	{
		singleton = nil;
	}
}

@end
