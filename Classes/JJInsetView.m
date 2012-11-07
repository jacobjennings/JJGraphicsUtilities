/*
Copyright (c) 2012 Jacob Jennings

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "JJInsetView.h"
#import <QuartzCore/QuartzCore.h>
#import "JJShapeView.h"

@interface JJInsetView ()

@property (nonatomic, strong) CAShapeLayer *mask;
@property (nonatomic, strong) JJShapeView *maskedShapeView;
@property (nonatomic, strong) UIView *inverseShapeView;
@property (nonatomic, strong) CAShapeLayer *highlightMask;
@property (nonatomic, strong) JJShapeView *highlightShapeView;

@end

@implementation JJInsetView
@synthesize path = _path;
@synthesize contentView = _contentView;
@synthesize highlightColor = _highlightColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowRadius = _shadowRadius;
@synthesize shadowOpacity = _shadowOpacity;
@synthesize shadowColor = _shadowColor;

@synthesize mask = _mask;
@synthesize maskedShapeView = _maskedShapeView;
@synthesize inverseShapeView = _inverseShapeView;
@synthesize highlightMask = _highlightMask;
@synthesize highlightShapeView = _highlightShapeView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.highlightMask = [CAShapeLayer layer];
        self.highlightShapeView = [JJShapeView shapeView];
        self.highlightShapeView.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.highlightShapeView.layer.mask = self.highlightMask;
        [self addSubview:self.highlightShapeView];
        
        self.mask = [CAShapeLayer layer];
        self.maskedShapeView = [JJShapeView shapeView];
        self.maskedShapeView.layer.opaque = YES;
        self.maskedShapeView.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.maskedShapeView.layer.mask = self.mask;
        [self addSubview:self.maskedShapeView];
    
        self.inverseShapeView = [[UIView alloc] init];
        self.inverseShapeView.userInteractionEnabled = NO;
        [self.maskedShapeView addSubview:self.inverseShapeView];
        
        //defaults
        self.highlightColor = [UIColor colorWithWhite:1 alpha:0.5];
        self.shadowOffset = CGSizeMake(0, 2);
        self.shadowRadius = 1;
        self.shadowOpacity = 0.55;
        
		self.layer.shouldRasterize = YES;
		self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.maskedShapeView.frame = self.bounds;
    self.mask.frame = self.bounds;
    self.inverseShapeView.frame = self.bounds;
    self.highlightShapeView.frame = CGRectOffset(self.bounds, 0, 1);
    self.highlightMask.frame = CGRectOffset(self.bounds, 0, -1);
    
    UIBezierPath *path = [self expandedBoundsCounterClockwiseBezierPath];
    [path appendPath:self.path];
    
    self.highlightMask.path = path.CGPath;
    self.inverseShapeView.layer.shadowPath = path.CGPath;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.contentView ? [self.contentView sizeThatFits:size] : CGSizeZero;
}

- (UIBezierPath *)expandedBoundsCounterClockwiseBezierPath {
	UIBezierPath *path = [[UIBezierPath alloc] init];
    CGRect expandedBounds = CGRectInset(self.bounds, -50, -50);
	
	[path moveToPoint:expandedBounds.origin];
	[path addLineToPoint:CGPointMake(CGRectGetMinX(expandedBounds), CGRectGetMaxY(expandedBounds))];
	[path addLineToPoint:CGPointMake(CGRectGetMaxX(expandedBounds), CGRectGetMaxY(expandedBounds))];
	[path addLineToPoint:CGPointMake(CGRectGetMaxX(expandedBounds), CGRectGetMinY(expandedBounds))];
	[path closePath];
	
	return path;
}

- (void)setPath:(UIBezierPath *)path {
    _path = path;
    self.highlightShapeView.shapeLayer.path = path.CGPath;
    self.mask.path = path.CGPath;
}

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self.maskedShapeView insertSubview:contentView belowSubview:self.inverseShapeView];
}

- (void)setHighlightColor:(UIColor *)highlightColor {
	_highlightColor = highlightColor;
	self.highlightShapeView.shapeLayer.fillColor = highlightColor.CGColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    self.inverseShapeView.layer.shadowOffset = shadowOffset;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    _shadowRadius = shadowRadius;
    self.inverseShapeView.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    _shadowOpacity = shadowOpacity;
    self.inverseShapeView.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.inverseShapeView.layer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)backgroundColor { return self.maskedShapeView.backgroundColor; }
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.maskedShapeView.backgroundColor = backgroundColor;
}

@end
