//
//  AnalogClockBackground.h
//  desktopclocklit
//
//  Created by cod7ce on 12/13/11.
//  Copyright (c) 2011 纸房子. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "BasicAnimationFatory.h"

@interface AnalogClockBackground : CALayer
{
    NSMutableArray *imgArray;
    NSFileManager *fileManager;
    NSTimer *timer;
}

@property (retain, nonatomic) NSMutableArray *imgArray;

- (id)initWithPath:(NSString *)path;
- (void)getImagesByPath:(NSString *)dir WeatherRecursion:(Boolean) recursion;
- (void)start;
@end
