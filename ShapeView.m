//
//  ShapeView.m
//  GesturesDemo
//

#import "ShapeView.h"

@implementation ShapeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;

        
        // add pan UIGestureRecognizer
        UIPanGestureRecognizer *panGestureRecognizer =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [self addGestureRecognizer:panGestureRecognizer];
        
        
        // add double tap UIGestureRecognizer
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delete:)];
        doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGestureRecognizer];
        
        
        // add tap UIGestureRecognizer
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(front:)];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTapGestureRecognizer];
    }
    return self;
}

// respond to hit on shape
-(void)move:(UIPanGestureRecognizer *)panRecognizer{
    CGPoint translation = [panRecognizer translationInView:self];
    CGPoint imageViewPosition = self.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    self.center = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:self];
    [panRecognizer cancelsTouchesInView];
}

-(void)front:(UITapGestureRecognizer *)tapRecognizer
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.superview bringSubviewToFront:self];
        self.transform = CGAffineTransformIdentity;
        
    }];
    [tapRecognizer cancelsTouchesInView];
}

-(void)delete:(UITapGestureRecognizer *)tapRecognizer
{
    [UIView animateWithDuration:0.25 animations:^{
        self.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-960);
        self.transform = CGAffineTransformIdentity;
        [super removeFromSuperview];
    }];
    [tapRecognizer cancelsTouchesInView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
