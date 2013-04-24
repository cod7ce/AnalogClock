//
//  BasicAnimationFatory.h
//  AnalogClock
//
//  Created by cipiglio on 4/23/13.
//  Copyright (c) 2013 cod7ce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BasicAnimationFatory : NSObject

+(CABasicAnimation *)opacityForever_Animation:(float)time;
+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes duration:(float)time;
+(CABasicAnimation *)fadeInAnimationDuration:(float)time;
+(CABasicAnimation *)fadeOutAnimationDuration:(float)time BeginTime:(float)bt;
+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x;
+(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y;
+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple duration:(float)time Rep:(float)repeatTimes;
+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry duration:(float)time Rep:(float)repeatTimes;
+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path duration:(float)time Rep:(float)repeatTimes;
+(CABasicAnimation *)movepoint:(CGPoint )point;
+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount;

@end
