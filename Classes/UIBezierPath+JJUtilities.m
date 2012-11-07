/*
Copyright (c) 2012 Jacob Jennings

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "UIBezierPath+JJUtilities.h"

@implementation UIBezierPath (JJUtilities)

+ (UIBezierPath*)bezierPathBottomOfRect:(CGRect)rect roundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    if (corners & UIRectCornerBottomRight) {
        [path moveToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect) - radius)];
        [path addArcWithCenter:CGPointMake(CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    } else {
        [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
    }
    
    if (corners & UIRectCornerBottomLeft) {
        [path addLineToPoint:CGPointMake(rect.origin.x + radius, CGRectGetMaxY(rect))];
        [path addArcWithCenter:CGPointMake(rect.origin.x + radius, CGRectGetMaxY(rect) - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    } else {
        [path addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];
    }
    
    return path;    
}

+ (UIBezierPath*)bezierPathTopOfRect:(CGRect)rect roundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    if (corners & UIRectCornerTopLeft) {
        [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + radius)];
        [path addArcWithCenter:CGPointMake(rect.origin.x + radius, rect.origin.y + radius) radius:radius startAngle:M_PI endAngle:M_PI + M_PI_2 clockwise:YES];
    } else {
        [path moveToPoint:rect.origin];
    }
    
    if (corners & UIRectCornerTopRight) {
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - radius, rect.origin.y)];
        [path addArcWithCenter:CGPointMake(CGRectGetMaxX(rect) - radius, rect.origin.y + radius) radius:radius startAngle:M_PI + M_PI_2 endAngle:0 clockwise:YES];
    } else {
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];
    }
    
    return path;    
}

@end
