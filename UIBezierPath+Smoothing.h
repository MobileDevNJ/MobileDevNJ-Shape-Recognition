//
//  UIBezierPath+Smoothing.h
//  GesturesDemo
//
//  Created by Neo on 11/24/12.
//
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (smoothing)

- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity;


@end
