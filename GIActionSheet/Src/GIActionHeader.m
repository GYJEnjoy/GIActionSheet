//
//  GIActionHeader.m
//  GIActionSheet
//
//  Created by 高云杰 on 16/10/3.
//  Copyright © 2016年 gyj. All rights reserved.
//

#import "GIActionHeader.h"
#import "GIDefine.h"

#define CONTENT_HOR_PADDING  (10)
#define CONTENT_VER_PADDING  (18)

@interface GIActionHeader () {
    // 分割线
    CALayer *_seprateLine;
}
@end

@implementation GIActionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        _seprateLine = [[CALayer alloc] init];
        _seprateLine.backgroundColor = DEFAULT_SEPRATE_COLOR.CGColor;
        [self.layer addSublayer:_seprateLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    _titleLabel.frame =CGRectMake(CONTENT_HOR_PADDING, CONTENT_VER_PADDING, width - 2 * CONTENT_HOR_PADDING , height - 2 * CONTENT_VER_PADDING);
    _seprateLine.frame = CGRectMake(0, height - 0.5f, width, .5f);
}

- (void)sizeToFit {
    CGSize size = [self sizeThatFits:self.bounds.size];
    CGRect rect = self.bounds;
    rect.size = size;
    self.bounds = rect;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat labelWidth = size.width - 2 * CONTENT_HOR_PADDING;
    CGFloat labelHeight = size.height - 2 * CONTENT_VER_PADDING;
    
    CGSize suitableSize = [_titleLabel sizeThatFits:CGSizeMake(labelWidth, labelHeight)];
    suitableSize.width = size.width;
    suitableSize.height += 2 * CONTENT_VER_PADDING;
    return suitableSize;
}
@end
