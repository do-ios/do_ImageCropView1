//
//  do_ImageCropView1_View.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "do_ImageCropView1_IView.h"
#import "do_ImageCropView1_UIModel.h"
#import "doIUIModuleView.h"

@interface do_ImageCropView1_UIView : UIView<do_ImageCropView1_IView, doIUIModuleView>
//可根据具体实现替换UIView
{
	@private
		__weak do_ImageCropView1_UIModel *_model;
}

@end
