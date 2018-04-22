//
//  DTCircularActivityIndicator.m
//  DTCircularActivityIndicator
//
//  Created by Thinh Vo on 23/04/2018.
//

#import "DTCircularActivityIndicator.h"

static NSString *const kAnimationGroupKey = @"AnimationGroupKey";
static NSString *const kRotateAnimationKey = @"RotatingAnimationKey";
static NSString *const kStrokeColorAnimationKey = @"StrokeColorAnimationKey";

@interface DTCircularActivityIndicator()
@property(nonatomic, readwrite) BOOL isAnimating;
@end

@implementation DTCircularActivityIndicator
{
    CAShapeLayer *_shapeLayer;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(30, 30);
}

#pragma mark - Internal methods
- (void)setUp
{
    self.clipsToBounds = YES;
    
    self.isAnimating = NO;
    self.shouldHideWhenStop = YES;
    self.shouldShowWhenStart = YES;
    self.lineWidth = 3.0;
    self.strokeStartDuration = 1.0;
    self.strokeEndDuration = 2.0;
    self.spinDuration = 10.0;
    self.colors = @[[UIColor grayColor]];
    self.backgroundColor = [UIColor clearColor];
    
    _shapeLayer = [[CAShapeLayer alloc] init];
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = ((UIColor *)self.colors[0]).CGColor;
    _shapeLayer.lineWidth = self.lineWidth;
    _shapeLayer.frame = self.bounds;
    _shapeLayer.strokeStart = 0;
    _shapeLayer.strokeEnd = 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateShapeLayerPath];
    [self.layer addSublayer:_shapeLayer];
}

- (void)updateShapeLayerPath
{
    _shapeLayer.frame = self.bounds;
    
    CGFloat shorterSide = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width;
    CGPoint centerPoint = CGPointMake(shorterSide / 2, shorterSide / 2);
    CGFloat radius = shorterSide / 2 - self.lineWidth / 2 - 3; // Avoid cutting edge
    
    UIBezierPath *circularPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:(CGFloat)(-M_PI_2) endAngle:(CGFloat)(3 * M_PI_2) clockwise:YES];
    
    _shapeLayer.path = circularPath.CGPath;
}

- (NSArray *)strokeColorAnimationKeyTimes
{
    NSUInteger numberOfColors = [self.colors count];
    if (numberOfColors == 0) { return @[]; }
    if (numberOfColors == 1) { return @[@0]; }
    
    NSMutableArray *keyTimes = [NSMutableArray new];
    
    CGFloat step = 1.0 / (numberOfColors - 1);
    
    for (int i = 0; i < numberOfColors; i++) {
        [keyTimes addObject:@(step * (CGFloat)i)];
    }
    
    return keyTimes;
}

- (NSArray *)cgColorForColors:(NSArray *)colors
{
    NSMutableArray *cgColors = [NSMutableArray new];
    for (UIColor *color in colors) {
        [cgColors addObject:(id)color.CGColor];
    }
    
    return cgColors;
}

#pragma mark - Accessor methods
- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self updateShapeLayerPath];
}


#pragma mark - Public methods
- (void)startAnimating
{
    if (self.isAnimating) { return; }
    
    if (self.shouldShowWhenStart) self.hidden = NO;
    
    self.isAnimating = YES;
    
    [_shapeLayer removeAllAnimations];
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    //strokeStartAnimation.fromValue = @0.0;
    strokeStartAnimation.toValue = @1.0;
    strokeStartAnimation.duration = self.strokeStartDuration;
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeStartAnimation.beginTime = self.strokeEndDuration;
    strokeStartAnimation.fillMode = kCAFillModeBoth;
    strokeStartAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //strokeEndAnimation.fromValue = @0.0;
    strokeEndAnimation.toValue = @1.0;
    strokeEndAnimation.duration = self.strokeEndDuration;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeEndAnimation.beginTime = 0;
    strokeEndAnimation.fillMode = kCAFillModeBoth;
    strokeEndAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0.0;
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 10.0;
    rotationAnimation.beginTime = CACurrentMediaTime();
    rotationAnimation.fillMode = kCAFillModeBoth;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    rotationAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:strokeEndAnimation, strokeStartAnimation,nil];
    animationGroup.fillMode = kCAFillModeBoth;
    animationGroup.removedOnCompletion = NO;
    animationGroup.duration = self.strokeStartDuration + self.strokeEndDuration;
    animationGroup.repeatCount = CGFLOAT_MAX;
    
    CAKeyframeAnimation *strokeColorAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    strokeColorAnimation.duration = (self.strokeEndDuration + self.strokeStartDuration) * [self.colors count];
    strokeColorAnimation.fillMode = kCAFillModeForwards;
    strokeColorAnimation.keyTimes = [self strokeColorAnimationKeyTimes];
    strokeColorAnimation.repeatCount = CGFLOAT_MAX;
    strokeColorAnimation.removedOnCompletion = NO;
    strokeColorAnimation.values = [self cgColorForColors:self.colors];
    
    [_shapeLayer addAnimation:animationGroup forKey:kAnimationGroupKey];
    [_shapeLayer addAnimation:rotationAnimation forKey:kRotateAnimationKey];
    [_shapeLayer addAnimation:strokeColorAnimation forKey:kStrokeColorAnimationKey];
}

- (void)stopAnimating
{
    if (!self.isAnimating) return;
    
    if (self.shouldHideWhenStop) self.hidden = YES;
    
    self.isAnimating = NO;
    
    [_shapeLayer removeAllAnimations];
}

@end
