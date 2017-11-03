//
//  doImageCropView.h
//  Do_Test
//
//  Created by wtc on 2017/6/19.
//  Copyright © 2017年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface doImageCropView : UIView

@property (nonatomic, strong) UIImage * toCropImage;
@property (nonatomic, assign) BOOL needScaleCrop;
@property (nonatomic, assign) BOOL showMidLines;
@property (nonatomic, assign) BOOL showCrossLines;
@property (nonatomic, assign) CGFloat cropAspectRatio;
@property (nonatomic, strong) UIColor * cropAreaBorderLineColor;
@property (assign, nonatomic) CGFloat cropAreaBorderLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCornerLineColor;
@property (assign, nonatomic) CGFloat cropAreaCornerLineWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerHeight;
@property (assign, nonatomic) CGFloat minSpace;
@property (assign, nonatomic) CGFloat cropAreaCrossLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCrossLineColor;
@property (assign, nonatomic) CGFloat cropAreaMidLineWidth;
@property (assign, nonatomic) CGFloat cropAreaMidLineHeight;
@property (strong, nonatomic) UIColor *cropAreaMidLineColor;
@property (strong, nonatomic) UIColor *maskColor;
@property (assign, nonatomic) BOOL cornerBorderInImage;
@property (assign, nonatomic) CGFloat initialScaleFactor;
- (UIImage *)currentCroppedImage;

@end
