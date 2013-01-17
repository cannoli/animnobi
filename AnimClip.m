//
//  AnimClip.m
//  animnobi
//
//  Created by Shu Chiun Cheah on 9/26/12.
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


#import "AnimClip.h"
#import "ImageManager.h"

static NSString* const kKeyIsLoop = @"loop";
static NSString* const kKeyFps = @"fps";
static NSString* const kKeyFrames = @"frames";

@implementation AnimClip
@synthesize framesPerSec = _framesPerSec;
@synthesize isLoop = _isLoop;

- (id) init
{
    NSAssert(false, @"must use initDictionary to create AnimClip");
    return nil;
}

- (id) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        NSNumber* loopNum = [dict objectForKey:kKeyIsLoop];
        if(loopNum)
        {
            _isLoop = [loopNum boolValue];
        }
        else
        {
            _isLoop = NO;
        }
        NSNumber* fpsNum = [dict objectForKey:kKeyFps];
        if(fpsNum)
        {
            _framesPerSec = [fpsNum floatValue];
        }
        else
        {
            _framesPerSec = 6.0f;
        }
        NSArray* frameNames = [dict objectForKey:kKeyFrames];
        if(frameNames && [frameNames count])
        {
            _frames = [NSMutableArray arrayWithCapacity:[frameNames count]];
            for(NSString* name in frameNames)
            {
                UIImage* image = [[ImageManager getInstance] getImage:name];
                if(!image)
                {
                    image = [[ImageManager getInstance] getImage:@"checkboard.png"];
                }
                [_frames addObject:image];
            }
        }
    }
    return self;
}

- (float) secondsPerLoop
{
    float result = 1.0f;
 
    if(_frames && [_frames count])
    {
        result = (1.0f / _framesPerSec) * [_frames count];
    }
    
    return result;
}

- (NSArray*) imagesArray
{
    return _frames;
}

@end
