//
//  GIAction.m
//  GIActionSheet
//
//  Created by 高云杰 on 16/9/29.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import "GIAction.h"

@implementation GIAction
/**
 * 创建实例
 * @param title 标题
 * @param onClick 点击回调
 * @return 实例
 */
+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title action:(nonnull GIOnActionClick)onClick {
    return [self actionWithTitle:title icon:nil action:onClick];
}

/**
 * 创建实例
 * @param title 标题
 * @param icon 图标
 * @param onClick 点击回调
 * @return 实例
 */
+ (nonnull instancetype)actionWithTitle:(nonnull NSString *)title icon:(nullable UIImage *)icon action:(nonnull GIOnActionClick)onClick {
    GIAction *action = [[self alloc] init];
    action.title = title;
    action.icon = icon;
    action.onClick = onClick;
    return action;
}

- (void)dealloc {
    _onClick = NULL;
}
@end
