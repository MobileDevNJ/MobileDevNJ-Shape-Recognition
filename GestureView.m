//
//  GestureView.m
//  Gestures
//

#import "GestureView.h"
#import "GLGestureRecognizer.h"
#import "GLGestureRecognizer+JSONTemplates.h"
#import "UIBezierPath+Smoothing.h"
#import "ShapeView.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )
const float kRedColor[] = { 1.0, 0.0, 0.0, 1.0};
void Rotate(CGPoint *samples, int samplePoints, float radians);

@interface GestureView () {
	GLGestureRecognizer *recognizer;
	CGPoint center;
	float score, angle;
    BOOL drawEnabled;
    CGPoint firstPoint;
    
}
@property (nonatomic, strong) UIBezierPath *myPath;
@property (nonatomic, retain) NSDictionary *shapeDictionary;
@property (nonatomic, retain) NSString *gestureName;
//@property (nonatomic, strong) UIBezierPath *smoothPath;


@end

@implementation GestureView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    
    // GLGestureRecognizer is the shapeRecognition engine, we need that
	recognizer = [[GLGestureRecognizer alloc] init];
    
    // describes the shapes we are able to recognize (e.g. circles, squares, etc), load from file system
	NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Gestures" ofType:@"json"]];
	NSError *error;
	if (![recognizer loadTemplatesFromJsonData:jsonData error:&error])
	{
            NSLog(@"Error: loading template shapes: %@", error);
            [_delegate titleForGestureView:@"Error templates"];
		return;
	}
    
    // init myPath to hold points drawn on screen with finger
    self.myPath = [[UIBezierPath alloc]init];
    self.myPath.lineCapStyle = kCGLineCapRound;
    self.myPath.miterLimit = 0;
    self.myPath.lineWidth = 10;
    
    // index shapes defined in JSON templates
    _shapeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@1, @"circle", @2, @"circleReverse", @3, @"square", @4, @"triangle", @5, @"dome", nil];
}


-(void)createImage
{
    // create image, draw in new shapeView (UIView) and add to GestureView (self)
    
    // size is bounds of drawn object on screen    
    CGRect size = [_myPath bounds];
    
    // draw into ImageContext, then add UIImage to GestureView
	UIGraphicsBeginImageContext(size.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // CoreGraphic defaults
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor purpleColor].CGColor);
    CGContextSetShadowWithColor(ctx, CGSizeMake(1,1), 6, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 8.0);

    // which shape to draw?
    switch ([_shapeDictionary[_gestureName] integerValue]) {
        case 1:
            // Draw circle (circle)
        {
            CGRect rectangle = CGRectMake(4.0,4.0,size.size.width-10.0,size.size.height-10.0);
            CGContextAddEllipseInRect(ctx, rectangle);
            CGContextStrokePath(ctx);
            
            break;
        }
    
        case 2:
            // Draw circle (circleReverse)
        {
            CGRect rectangle = CGRectMake(5.0,5.0,size.size.width-10,size.size.height-10);
            CGContextAddEllipseInRect(ctx, rectangle);
            CGContextDrawPath(ctx,kCGPathFillStroke);

            break;
        }
            
        case 3:
            // Draw rectangle
        {
            CGContextStrokeRect(ctx, CGRectMake(0, 0, size.size.width, size.size.height));
            CGContextStrokeRectWithWidth(ctx, CGRectMake(0, 0, size.size.width, size.size.height), 16.0);
            CGContextClip (ctx);

            break;
        }
            
        case 4:
            // Draw triangle
        {
            int lineWidth = 4;
            int w = size.size.width;
            int h = size.size.height - lineWidth;
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGPoint top = CGPointMake((w/2), 0);
            CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);

            CGContextMoveToPoint(ctx, top.x, top.y);
            CGContextAddLineToPoint(ctx, top.x + (w/2), top.y + h  );
            CGContextAddLineToPoint(ctx, top.x - (w/2), top.y + h   );
            CGContextClosePath(ctx);
            CGContextDrawPath(ctx,kCGPathStroke);

            break;
        }
        case 5:
            // Dome
        {
            CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
            CGContextAddArc(ctx, size.size.width/2, size.size.height*.75, size.size.height/2, degreesToRadians(180), 0, NO);
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextClip (ctx);

        }
    }
    
    // create UIView (shapeView), and add to screen with calculated size
    ShapeView *viewImage = [[ShapeView alloc] initWithFrame:size];
    viewImage.backgroundColor = [UIColor clearColor];
	viewImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

    // add shape UIView to current View
    [self addSubview:viewImage];
    
}


- (void)drawRect:(CGRect)rect
{
    if (!drawEnabled)
    {
        [_delegate titleForGestureView:@""];
        
        // Drawing code, get context
        CGContextRef ctx = UIGraphicsGetCurrentContext();
    
        // settings
        CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
        [_myPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        
        // convert raw path to smooth path - NOT USED
        // self.smoothPath = [self.myPath smoothedPathWithGranularity:10];
        // [self.smoothPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];

    } else {
        
        // if we have something to draw, draw it on screen
        if (!_myPath.isEmpty)[self createImage];
        
    }
    
}

-(IBAction)clearScreen
{
    // clear paths
    [self.myPath removeAllPoints];
    
    // remove shapeViews
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // clear title
    [_delegate titleForGestureView:@""];

    // update screen
	[self setNeedsDisplay];

}

- (void)processGestureData
{
    // main routine, process raw points after trace and convert into shape
	self.gestureName = [recognizer findBestMatchCenter:&center angle:&angle score:&score];
    
    // matched image, set title
    [_delegate titleForGestureView:[NSString stringWithFormat:@"%@", _gestureName]];

    // extra info
    //    [_delegate titleForGestureView:[NSString stringWithFormat:@"%@ (%0.2f, %d)", _gestureName, score, (int)(360.0f*angle/(2.0f*M_PI))]];
}


// capture gestures
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[recognizer resetTouches];
	[recognizer addTouches:touches fromView:self];
    [self.myPath removeAllPoints];
    drawEnabled = NO;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    firstPoint = point;
    [self.myPath moveToPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[recognizer addTouches:touches fromView:self];
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.myPath addLineToPoint:point];
	[self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[recognizer addTouches:touches fromView:self];
	drawEnabled = YES;
	[self processGestureData];
	[self setNeedsDisplay];
}


@end


// Example code only, has nothing to do with program
//        CGFloat zFillColor[4]    = {0.08,0.92,0.88,1.0};
//        CGContextSetFillColor (ctx,zFillColor);
//        CGContextFillRect (ctx, CGRectMake (0.0, 0.0, rect.size.width, rect.size.height ));
//        // Examples
//
//        CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
//        CGContextBeginPath(ctx);
//        CGContextSetLineWidth(ctx,3.0);
//        CGContextAddArc (ctx, 150.0, 50.0, 30.0, 0.0, 2.0 * 3.142,YES);
//        CGContextStrokePath(ctx); // one or the other
//        //CGContextDrawPath(ctx,kCGPathFillStroke);
//
//        CGContextSetLineWidth(ctx, 8.0);
//        CGRect rectangle = CGRectMake(250, 50, 100, 100);
//        CGContextAddEllipseInRect(ctx, rectangle);
//        //CGContextStrokePath(ctx);
//
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathAddArc(path, NULL, 400.0, 75.0, 20.0, 0.0, 2.0 * 3.142,YES);
//        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
//        CGContextAddPath(ctx, path);
//        CGContextFillPath(ctx);
//        CGPathRelease(path);
