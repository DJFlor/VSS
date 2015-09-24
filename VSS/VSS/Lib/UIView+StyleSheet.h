//
//  UIView+StyleSheet.h
//  VSS
//
//  Created by Flor, Daniel J on 9/23/15.
//  Copyright © 2015 ObiDan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol styleable

@property NSString *style;

@end

@interface UIView (StyleSheet)

- (void)applyStyles;
- (void)oldLayoutSubviews;
+ (void)swizzleLayoutSubviews;

@end
