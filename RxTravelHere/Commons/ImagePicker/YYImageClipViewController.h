//
//  YYImageClipViewController.h
//  YYImageClipViewController
//
//  Created by 杨健 on 16/7/8.
//  Copyright © 2016年 成. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYImageClipViewController;

@protocol YYImageClipDelegate <NSObject>

@optional
- (void)imageCropper:(YYImageClipViewController *)clipViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(YYImageClipViewController *)clipViewController;

@end

@interface YYImageClipViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) id<YYImageClipDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (instancetype)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio isCycle:(BOOL)isCycle;

@end
