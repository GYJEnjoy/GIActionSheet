//
//  GIActionCell.m
//  GIActionSheet
//
//  Created by 高云杰 on 16/10/1.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import "GIActionCell.h"
#import "GIAction.h"

/// 内边距－Grid模式
#define DEFAULT_GRID_PADDING   (8)
/// 图标与文本间的间隙－Grid模式
#define DEFAULT_GRID_SPACE     (4)

/// 内边距－List模式
#define DEFAULT_LIST_PADDING   (8)
/// 图标与文本间的间隙－Grid模式
#define DEFAULT_LIST_SPACE     (4)

@interface GIActionCell () {
    // 图标
    UIImageView *_iconView;
    // 标题
    UILabel *_titleLabel;
    
    // 分割线
    CALayer *_seprateLine;
}

@end

@implementation GIActionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleAlignment = NSTextAlignmentCenter;
        _seprateColor = DEFAULT_SEPRATE_COLOR;
        _seprateLine = [[CALayer alloc] init];
        _seprateLine.backgroundColor = _seprateColor.CGColor;
        [self.layer addSublayer:_seprateLine];
        self.style = GIActionSheetStyleList;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(GIActionSheetStyle)style {
    if (self = [self initWithFrame:frame]) {
        self.style = style;
    }
    return self;
}

/// 设置样式，并更新视图
- (void)setStyle:(GIActionSheetStyle)style {
    if (_style != style) {
        _style = style;
        if (_style == GIActionSheetStyleList) {
            if (!_seprateLine) {
                _seprateLine = [[CALayer alloc] init];
                _seprateLine.backgroundColor = _seprateColor.CGColor;
                [self.layer addSublayer:_seprateLine];
            }
            
            self.selectedBackgroundView = [[UIView alloc] init];
            self.selectedBackgroundView.backgroundColor = _seprateColor;
        } else {
            self.selectedBackgroundView = nil;

            [_seprateLine removeFromSuperlayer];
            _seprateLine = nil;
        }
        [self setNeedsLayout];
    }
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    _titleAlignment = titleAlignment;
    _titleLabel.textAlignment = titleAlignment;
}

- (void)setSeprateColor:(UIColor *)seprateColor {
    _seprateColor = seprateColor;
    _seprateLine.backgroundColor = _seprateColor.CGColor;
}

- (void)setAction:(GIAction *)action {
    _action = action;
    
    // 设置title的显示
    if (_action.title.length == 0) {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    } else {
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] init];
            [self addSubview:_titleLabel];
        }
        _titleLabel.font = _action.titleFont;
        _titleLabel.textAlignment = _titleAlignment;
        _titleLabel.text = _action.title;
        _titleLabel.textColor = _action.enabled ? _action.normalTitleColor : _action.disableTitleColor;
    }
    
    // 设置icon的显示
    if (_action.icon == nil) {
        [_iconView removeFromSuperview];
        _iconView = nil;
    } else {
        if (!_iconView) {
            _iconView = [[UIImageView alloc] init];
            _iconView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:_iconView];
        }
        _iconView.image = _action.icon;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    if (_style == GIActionSheetStyleGrid) {
        // Grid方式显示
        if (_iconView && _titleLabel) {
            [_titleLabel sizeToFit];
            _titleLabel.frame = CGRectMake(DEFAULT_GRID_PADDING, height - DEFAULT_GRID_PADDING - CGRectGetHeight(_titleLabel.frame), width - 2 * DEFAULT_GRID_PADDING, CGRectGetHeight(_titleLabel.frame));
            _iconView.frame = CGRectMake(DEFAULT_GRID_PADDING, DEFAULT_GRID_PADDING, width - 2 * DEFAULT_GRID_PADDING, CGRectGetMinY(_titleLabel.frame) - 2 * DEFAULT_GRID_PADDING - DEFAULT_GRID_SPACE);
        } else if (_iconView) {
            _iconView.frame = CGRectMake(DEFAULT_GRID_PADDING, DEFAULT_GRID_PADDING, width - 2 * DEFAULT_GRID_PADDING, height - 2 * DEFAULT_GRID_PADDING);
        } else if (_titleLabel) {
            _titleLabel.frame = CGRectMake(DEFAULT_GRID_PADDING, DEFAULT_GRID_PADDING, width - 2 * DEFAULT_GRID_PADDING, height - 2 * DEFAULT_GRID_PADDING);
        }
    } else {
        // 默认List方式
        if (_iconView) {
            _iconView.frame = CGRectMake(DEFAULT_LIST_PADDING, DEFAULT_LIST_PADDING, height - 2 * DEFAULT_LIST_PADDING, height - 2 * DEFAULT_LIST_PADDING);
        }
        if (_titleLabel) {
            _titleLabel.frame = CGRectMake((_iconView ? CGRectGetMaxX(_iconView.frame) : 0) + DEFAULT_LIST_SPACE,
                                           DEFAULT_LIST_PADDING,
                                           width - (_iconView ? DEFAULT_LIST_PADDING + CGRectGetMaxX(_iconView.frame) : 0) - DEFAULT_LIST_SPACE,
                                           height - 2 * DEFAULT_LIST_PADDING);
        }
        _seprateLine.frame = CGRectMake(0, height - 0.5f, width, .5f);
    }
}
@end
