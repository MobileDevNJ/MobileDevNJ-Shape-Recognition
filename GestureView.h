//
//  GestureView.h
//  Gestures
//
//  Portion of code from Adam Preble


#import <UIKit/UIKit.h>

@protocol GestureViewDelegate <NSObject>
@optional
-(void)titleForGestureView:(NSString*)title;
@end

@interface GestureView : UIView
{
    id <GestureViewDelegate> delegate;
}
@property (nonatomic, weak) id <GestureViewDelegate> delegate;
-(IBAction)clearScreen;

@end
