//
//  LoadingEffect.m
//  TVA2Go
//
//  Created by Eyolph on 02/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "LoadingEffect.h"

@implementation LoadingEffect




- (void)drawRect:(CGRect)rect
{
    
    CGRect bounds = CGRectMake(0, 0, 50, 50);
    CGPoint center;
    
    center.x = bounds.origin.x + bounds.size.width/2;
    center.y = bounds.origin.y + bounds.size.height/2;
    
    
    float radius = MIN(bounds.size.width, bounds.size.height) / 2;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI *2 clockwise:YES];
    
    path.lineWidth = 2;
    
    [[UIColor colorWithRed:0.18823 green:0.7215 blue:0.94117 alpha:1] setStroke];

     
    [path stroke];
    
    
}


- (void)animateCircle
{
    
    CGRect bounds = CGRectMake(0, 0, 50, 50);
    CGPoint center;
    
    center.x = bounds.origin.x + bounds.size.width/2;
    center.y = bounds.origin.y + bounds.size.height/2;
    
    
    float radius = MIN(bounds.size.width, bounds.size.height) / 2;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI *2 clockwise:YES];
    
    path.lineWidth = 2;
    
    [[UIColor redColor] setStroke];
    
    [UIView animateWithDuration:2 animations:^{
        [path strokeWithBlendMode:kCGBlendModeOverlay alpha:0.5];
    }];
    [path strokeWithBlendMode:kCGBlendModeOverlay alpha:0.5];

}


@end
