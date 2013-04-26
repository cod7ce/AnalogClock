//
//  BasicAnimationFatory.m
//  AnalogClock
//
//  Created by cipiglio on 4/23/13.
//  Copyright (c) 2013 cod7ce. All rights reserved.
//

#import "BasicAnimationFatory.h"

@implementation BasicAnimationFatory

// 永久闪烁的动画
+(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.0];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

// 有闪烁次数的动画
+(CABasicAnimation *)opacityTimes_Animation:(float)repeatTimes duration:(float)time
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.6];
    animation.repeatCount=repeatTimes;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] ;
    animation.autoreverses=YES;
    return  animation;
}

// 有逐渐展现的动画
+(CABasicAnimation *)fadeInAnimationDuration:(float)time
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:0.0];
    animation.toValue=[NSNumber numberWithFloat:1.0];
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] ;
    return  animation;
}

// 有逐渐消失的动画
+(CABasicAnimation *)fadeOutAnimationDuration:(float)time BeginTime:(float)bt
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    //animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.0];
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.beginTime = CACurrentMediaTime() + bt;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] ;
    return  animation;
}

// 横向移动
+(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x 
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue=x;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

// 纵向移动
+(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.toValue=y;
    animation.duration=time;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

// 缩放
+(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple duration:(float)time Rep:(float)repeatTimes 
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=orginMultiple;
    animation.toValue=Multiple;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=YES;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

// 组合动画
+(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry duration:(float)time Rep:(float)repeatTimes
{
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations=animationAry;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

// 路径动画
+(CAKeyframeAnimation *)keyframeAniamtion:(CGMutablePathRef)path duration:(float)time Rep:(float)repeatTimes
{
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path=path;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=NO;
    animation.duration=time;
    animation.repeatCount=repeatTimes;
    return animation;
}

// 点移动
+(CABasicAnimation *)movepoint:(CGPoint )point
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation"];
    animation.toValue=[NSValue valueWithPoint:point];
    animation.removedOnCompletion=YES;
    animation.fillMode=kCAFillModeForwards;
    animation.duration=8.0f;
    return animation;
}

// 旋转
+(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,direction);
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration= dur;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= repeatCount;
    animation.delegate= self;
    
    return animation;
}
@end
