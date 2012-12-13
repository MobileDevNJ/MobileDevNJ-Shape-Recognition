//
//  KWViewController.m
//  shapeRecognitionBeta
//
//  Created by Neo on 12/9/12.
//  Copyright (c) 2012 Neo. All rights reserved.
//

#import "KWViewController.h"

@interface KWViewController ()

@end

@implementation KWViewController

@synthesize gestureView = _gestureView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _gestureView.delegate = self;
    
}
- (IBAction)actionClear:(id)sender
{
    [_gestureView clearScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)titleForGestureView:(NSString*)title;
{
    self.title=title;
}

@end
