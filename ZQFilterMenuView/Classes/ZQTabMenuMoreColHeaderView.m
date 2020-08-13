//
//  ZQTabMenuMoreSectionHeaderView.m
//  house591
//
//  Created by zhengzeqin on 2019/11/14.
//

#import "ZQTabMenuMoreColHeaderView.h"
#import <Masonry/Masonry.h>
#import <ZQFoundationKit/ZQFoundationKit.h>
@interface ZQTabMenuMoreColHeaderView()

@end

@implementation ZQTabMenuMoreColHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@20);
        make.height.equalTo(@16);
    }];
}

@end
