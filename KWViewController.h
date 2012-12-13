//
//  KWViewController.h
//  shapeRecognitionBeta
//
//  Created by Neo on 12/9/12.
//  Copyright (c) 2012 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureView.h"

@interface KWViewController : UIViewController <GestureViewDelegate>
{
    IBOutlet GestureView *gestureView;
    __weak IBOutlet UIBarButtonItem *btnClear;
}

@property (nonatomic, weak) IBOutlet GestureView *gestureView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionClear;

-(void)titleForGestureView:(NSString*)title;

@end
