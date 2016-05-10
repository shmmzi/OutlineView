//
//  UIView+Extension.h
//  OA
//
//  Created by  shenfeng on 16/3/22.
//  Copyright © 2016年 UGU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;


- (void)removeAllSubviews;

- (UIViewController *)viewController;

@end
