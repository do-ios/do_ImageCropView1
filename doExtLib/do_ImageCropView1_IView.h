//
//  do_ImageCropView1_UI.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol do_ImageCropView1_IView <NSObject>

@required
//属性方法
- (void)change_source:(NSString *)newValue;

//同步或异步方法
- (void)crop:(NSArray *)parms;


@end