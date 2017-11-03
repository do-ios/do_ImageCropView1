//
//  do_ImageCropView1_View.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_ImageCropView1_UIView.h"

#import "doInvokeResult.h"
#import "doUIModuleHelper.h"
#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doIOHelper.h"
#import "doIPage.h"
#import "doIDataFS.h"

#import "doImageCropView.h"

@interface do_ImageCropView1_UIView()

@property (nonatomic, strong) doImageCropView * imageView;

@end

@implementation do_ImageCropView1_UIView
#pragma mark - doIUIModuleView协议方法（必须）
//引用Model对象
- (void) LoadView: (doUIModule *) _doUIModule
{
    _model = (typeof(_model)) _doUIModule;
    
    [self setMultipleTouchEnabled:YES];
    [self setUserInteractionEnabled:YES];
}
//销毁所有的全局对象
- (void) OnDispose
{
    //自定义的全局属性,view-model(UIModel)类销毁时会递归调用<子view-model(UIModel)>的该方法，将上层的引用切断。所以如果self类有非原生扩展，需主动调用view-model(UIModel)的该方法。(App || Page)-->强引用-->view-model(UIModel)-->强引用-->view
}
//实现布局
- (void) OnRedraw
{
    //实现布局相关的修改,如果添加了非原生的view需要主动调用该view的OnRedraw，递归完成布局。view(OnRedraw)<显示布局>-->调用-->view-model(UIModel)<OnRedraw>
    
    //重新调整视图的x,y,w,h
    [doUIModuleHelper OnRedraw:_model];
}

#pragma mark - TYPEID_IView协议方法（必须）
#pragma mark - Changed_属性
/*
 如果在Model及父类中注册过 "属性"，可用这种方法获取
 NSString *属性名 = [(doUIModule *)_model GetPropertyValue:@"属性名"];
 
 获取属性最初的默认值
 NSString *属性名 = [(doUIModule *)_model GetProperty:@"属性名"].DefaultValue;
 */

- (void)setUpImageCropView
{
    //加载视图模型
    if (self.imageView) {
        [self.imageView removeFromSuperview];
    }
    _imageView = [[doImageCropView alloc] initWithFrame:CGRectMake(0, 0, _model.RealWidth, _model.RealHeight)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    _imageView.showMidLines = YES;
    _imageView.needScaleCrop = YES;
    _imageView.showCrossLines = YES;
    _imageView.cornerBorderInImage = NO;
    _imageView.cropAreaCornerWidth = 44;
    _imageView.cropAreaCornerHeight = 44;
    _imageView.minSpace = 30;
    _imageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _imageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _imageView.cropAreaCornerLineWidth = 6;
    _imageView.cropAreaBorderLineWidth = 4;
    _imageView.cropAreaMidLineWidth = 20;
    _imageView.cropAreaMidLineHeight = 6;
    _imageView.cropAreaMidLineColor = [UIColor whiteColor];
    _imageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _imageView.cropAreaCrossLineWidth = 4;
    _imageView.initialScaleFactor = .8f;
    
    //设置纵横比; 0为自由
    _imageView.cropAspectRatio = 0;
}

- (void)change_source:(NSString *)newValue
{
    //自己的代码实现
    NSString * imgPath = [doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :newValue];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
        
        [self setUpImageCropView];
        UIImage * image = [UIImage imageWithContentsOfFile:imgPath];
        _imageView.toCropImage = image;
    }
}



#pragma mark -
#pragma mark - 同步异步方法的实现
//异步
- (void)crop:(NSArray *)parms
{
    //异步耗时操作，但是不需要启动线程，框架会自动加载一个后台线程处理这个函数
    //参数字典_dictParas
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    NSString *_callbackName = [parms objectAtIndex:2];
    //回调函数名_callbackName
    
    //得到裁剪图片
    UIImage * cutImage = [_imageView currentCroppedImage];
    _imageView.toCropImage = cutImage;
    
    NSString *_fileFullName = [_scritEngine CurrentApp].DataFS.PathPrivateTemp;
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[doUIModuleHelper stringWithUUID]];
    NSString *filePath = [NSString stringWithFormat:@"%@/do_ImageCropView1/%@",_fileFullName,fileName];
    NSString *tempPath = [NSString stringWithFormat:@"%@/do_ImageCropView1",_fileFullName];
    if (![doIOHelper ExistDirectory:tempPath]) {
        [doIOHelper CreateDirectory:tempPath];
    }
    
    [self writeImage:cutImage toFileAtPath:filePath];
    
    NSString *invokeStr = [NSString stringWithFormat:@"data://tmp/do_ImageCropView1/%@",fileName];
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
    //_invokeResult设置返回值
    [_invokeResult SetResultText:invokeStr];
    [_scritEngine Callback:_callbackName :_invokeResult];
}

#pragma mark -
#pragma mark - 私有方法
//写入文件
- (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
    {
        return NO;
    }
    @try
    {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"])
        {
            imageData = UIImagePNGRepresentation(image);
        }
        else
        {
            // the rest, we write to jpeg
            
            // 0. best, 1. lost. about compress.
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        
        
        if ((imageData == nil) || ([imageData length] <= 0))
        {
            return NO;
        }
        [imageData writeToFile:aPath atomically:YES];
        return YES;
    }
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }
    return NO;
}


#pragma mark - doIUIModuleView协议方法（必须）<大部分情况不需修改>
- (BOOL) OnPropertiesChanging: (NSMutableDictionary *) _changedValues
{
    //属性改变时,返回NO，将不会执行Changed方法
    return YES;
}
- (void) OnPropertiesChanged: (NSMutableDictionary*) _changedValues
{
    //_model的属性进行修改，同时调用self的对应的属性方法，修改视图
    [doUIModuleHelper HandleViewProperChanged: self :_model : _changedValues ];
}
- (BOOL) InvokeSyncMethod: (NSString *) _methodName : (NSDictionary *)_dicParas :(id<doIScriptEngine>)_scriptEngine : (doInvokeResult *) _invokeResult
{
    //同步消息
    return [doScriptEngineHelper InvokeSyncSelector:self : _methodName :_dicParas :_scriptEngine :_invokeResult];
}
- (BOOL) InvokeAsyncMethod: (NSString *) _methodName : (NSDictionary *) _dicParas :(id<doIScriptEngine>) _scriptEngine : (NSString *) _callbackFuncName
{
    //异步消息
    return [doScriptEngineHelper InvokeASyncSelector:self : _methodName :_dicParas :_scriptEngine: _callbackFuncName];
}
- (doUIModule *) GetModel
{
    //获取model对象
    return _model;
}

@end
