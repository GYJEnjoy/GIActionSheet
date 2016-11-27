//
//  GIActionCell.h
//  GIActionSheet
//
//  Created by 高云杰 on 16/10/1.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIDefine.h"
@class GIAction;

@interface GIActionCell : UICollectionViewCell
/// 创建实例
- (nonnull instancetype)initWithFrame:(CGRect)frame style:(GIActionSheetStyle)style;
/// 分割线颜色
@property (nonatomic, copy, nullable) UIColor *seprateColor;
/// 样式定义
@property (nonatomic, assign) GIActionSheetStyle style;

/// 对齐方式.(style为ActionSheetStyleList时有效)
@property (nonatomic, assign) NSTextAlignment titleAlignment;

/// 设置动作元素
@property (nonatomic, strong, nonnull) GIAction *action;

@end
