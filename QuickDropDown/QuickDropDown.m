//
//  QuickDropDown.m
//  QuickDropDown
//
//  Created by pcjbird on 2018/1/6.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickDropDown.h"
#import "QuickDropDownDefines.h"


@interface QuickDropDown()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic, assign) BOOL isShown;
@property (nonatomic, weak) UIView* target;
@property (nonatomic, assign) CGRect targetRect;

@property (nonatomic, assign) QuickDropDownPattern pattern;
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIView * tableViewContainerView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) CGFloat heightForRow;
@property (nonatomic, assign) NSUInteger numberOfRowsToDisplay;

@property (nonatomic, strong) NSArray * itemArray;

@property (nonatomic, copy) QuickDropDownSelectBlock selectBlock;
@property (nonatomic, copy) QuickDropDownDismissBlock dismissBlock;

@end

@implementation QuickDropDown

- (NSArray *)itemArray
{
    if (![_itemArray isKindOfClass:[NSArray class]])
    {
        _itemArray = [NSArray array];
    }
    return _itemArray;
}

-(void)setDatasource:(id<QuickDropDownDataSource>)datasource
{
    _datasource = datasource;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    self.tableView.backgroundColor = _backgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.tableViewContainerView.layer.cornerRadius = _cornerRadius;
    self.tableView.layer.cornerRadius = _cornerRadius;
}

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
{
    _separatorStyle = separatorStyle;
    self.tableView.separatorStyle = _separatorStyle;
}

- (instancetype)initWithPattern:(QuickDropDownPattern)pattern
{
    if(self = [super init])
    {
        [self initVariables];
        _pattern = pattern;
        [self setupUI];
    }
    return self;
}

-(void) initVariables
{
    _isShown = NO;
    _pattern = QuickDropDownPatternDefault;
    _numberOfRowsToDisplay = 6;
    _heightForRow = 44.f;
    _shadowOpacity = 0.5f;
    _cornerRadius = 0.f;
    _backgroundColor = QDDTaupe3;
    _itemTextColor = QDDBlack;
    _itemTextFont = [UIFont systemFontOfSize:17.f];
    _itemTextAlignment = NSTextAlignmentLeft;
    _itemTextNumberOfLines = 1;
    _separatorStyle = UITableViewCellSeparatorStyleNone;
    _orientation = QuickDropDownOrientationDown;
    _selectBlock = nil;
    _dismissBlock = nil;
    _target = nil;
    _targetRect = CGRectZero;
}

-(void) setupUI
{
    self.tableViewContainerView = [[UIView alloc] init];
    self.tableViewContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_tableViewContainerView.bounds].CGPath;
    self.tableViewContainerView.hidden = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableViewContainerView.frame), CGRectGetHeight(self.tableViewContainerView.frame)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = _backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableViewContainerView addSubview:self.tableView];
}

- (UIWindow *)backgroundWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if (window == nil && [delegate respondsToSelector:@selector(window)]){
        window = [delegate performSelector:@selector(window)];
    }
    return window;
}

-(UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc ]initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTapped:)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    return YES;
}

#pragma mark - onBackgroundViewTapped

-(void)onBackgroundViewTapped:(UIGestureRecognizer *)gesture
{
    [self dismiss];
}

-(void) showAtTargetView:(UIView*)target
{
    [self showAtTargetView:target selectedBlock:nil dismissBlock:nil];
}

-(void) showAtTargetView:(UIView*)target selectedBlock:(QuickDropDownSelectBlock)selectedBlock dismissBlock:(QuickDropDownDismissBlock)dismissBlock
{
    if(![target isKindOfClass:[UIView class]])
    {
        SDK_LOG(@"请输入需要显示位置的视图(target view)。");
        return;
    }
    if (self.datasource && [self.datasource respondsToSelector:@selector(itemArrayInDropDown:)]) {
        self.itemArray = [NSArray arrayWithArray:[self.datasource itemArrayInDropDown:self]];
    }
    
    if (self.datasource && [self.datasource respondsToSelector:@selector(numberOfRowsToDisplayIndropDown:itemArrayCount:)]) {
        _numberOfRowsToDisplay = [self.datasource numberOfRowsToDisplayIndropDown:self itemArrayCount:self.itemArray.count];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _selectBlock = selectedBlock;
        _dismissBlock = dismissBlock;
        [self.backgroundView addSubview:self.tableViewContainerView];
        [[self backgroundWindow] addSubview:self.backgroundView];
        self.target = target;
        [self adjustDropDown];
    });
}

-(void)adjustDropDown
{
    [self.backgroundView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    CGRect targetRect;
    if (self.target)
    {
        targetRect = [self.target.superview convertRect:self.target.frame toView:self.backgroundView];
        _targetRect = targetRect;
    }
    else
    {
        targetRect = self.targetRect;
    }
    
    if(self.orientation == QuickDropDownOrientationDown)
    {
        self.tableViewContainerView.frame = CGRectMake(CGRectGetMinX(_targetRect), CGRectGetMaxY(_targetRect) + 1, CGRectGetWidth(_targetRect), _numberOfRowsToDisplay * _heightForRow);
    }
    else
    {
        self.tableViewContainerView.frame = CGRectMake(CGRectGetMinX(_targetRect), CGRectGetMinY(_targetRect) - _numberOfRowsToDisplay * _heightForRow - 1, CGRectGetWidth(_targetRect), _numberOfRowsToDisplay * _heightForRow);
    }
    self.tableViewContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_tableViewContainerView.bounds].CGPath;
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableViewContainerView.frame), CGRectGetHeight(self.tableViewContainerView.frame));
    
    self.tableViewContainerView.alpha = 1.f;
    self.tableViewContainerView.hidden = NO;
    self.tableViewContainerView.layer.shadowColor = QDDDarkGray.CGColor;
    self.tableViewContainerView.layer.shadowOpacity = _shadowOpacity;
    self.tableViewContainerView.layer.shadowOffset = CGSizeZero;
    self.tableViewContainerView.layer.shadowRadius = 8.f;
    CGAffineTransform originTransform = self.tableViewContainerView.transform;
    CGAffineTransform scaleTransform = CGAffineTransformScale(self.tableViewContainerView.transform, 0.9, 0.9);
    self.tableViewContainerView.transform = scaleTransform;
    
    [UIView animateWithDuration:0.15f delay:0.f options:UIViewAnimationOptionAllowUserInteraction &UIViewAnimationOptionCurveEaseOut animations:^{
        self.tableViewContainerView.transform = originTransform;
        
    } completion:^(BOOL finished) {
        _isShown = YES;
    }];
}

-(void) dismiss
{
    [self dismiss:YES];
}

-(void) dismiss:(BOOL)bCancelAction
{
    [UIView animateKeyframesWithDuration:0.1f delay:0.f options:UIViewAnimationOptionAllowUserInteraction &UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableViewContainerView.alpha = 0.95f;
    } completion:^(BOOL finished) {
        self.tableViewContainerView.layer.shadowColor = QDDClear.CGColor;
        self.tableViewContainerView.layer.shadowOpacity = 0.f;
        self.tableViewContainerView.layer.shadowOffset = CGSizeZero;
        self.tableViewContainerView.layer.shadowRadius = 0.f;
        self.tableViewContainerView.hidden = YES;
        [self.backgroundView removeFromSuperview];
        _isShown = NO;
        if(bCancelAction)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownDidDismiss:)]) {
                [self.delegate dropDownDidDismiss:self];
            }
            if(self.dismissBlock)self.dismissBlock();
        }
    }];
}

-(void)reloadData
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(itemArrayInDropDown:)]) {
        self.itemArray = [NSArray arrayWithArray:[self.datasource itemArrayInDropDown:self]];
    }
    
    if (self.datasource && [self.datasource respondsToSelector:@selector(numberOfRowsToDisplayIndropDown:itemArrayCount:)]) {
        _numberOfRowsToDisplay = [self.datasource numberOfRowsToDisplayIndropDown:self itemArrayCount:self.itemArray.count];
    }
    [self.tableView reloadData];
    if(self.orientation == QuickDropDownOrientationDown)
    {
        self.tableViewContainerView.frame = CGRectMake(CGRectGetMinX(_targetRect), CGRectGetMaxY(_targetRect) + 1, CGRectGetWidth(_targetRect), _numberOfRowsToDisplay * _heightForRow);
    }
    else
    {
        self.tableViewContainerView.frame = CGRectMake(CGRectGetMinX(_targetRect), CGRectGetMinY(_targetRect) - _numberOfRowsToDisplay * _heightForRow - 1, CGRectGetWidth(_targetRect), _numberOfRowsToDisplay * _heightForRow);
    }
    self.tableViewContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_tableViewContainerView.bounds].CGPath;
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableViewContainerView.frame), CGRectGetHeight(self.tableViewContainerView.frame));
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([_itemArray isKindOfClass:[NSArray class]])
    {
        return [_itemArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_pattern == QuickDropDownPatternDefault)
    {
        static NSString * cellIdentifier = @"DefaultCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        NSString * text = nil;
        if ([self.itemArray[indexPath.row] isKindOfClass:[NSString class]])
        {
            text = self.itemArray[indexPath.row];
        }
        else
        {
            SDK_LOG(@"当前dropDown样式为QuickDropDownPatternDefault, 请替换为QuickDropDownPatternCustom");
            return [[UITableViewCell alloc] init];
        }
        
        cell.textLabel.text = text;
        cell.textLabel.textColor = _itemTextColor;
        cell.textLabel.font = _itemTextFont;
        cell.textLabel.textAlignment = _itemTextAlignment;
        cell.textLabel.numberOfLines = _itemTextNumberOfLines;
        cell.backgroundColor = QDDClear;
        return cell;
    }
    else if (_pattern == QuickDropDownPatternCustom)
    {
        if (self.datasource && [self.datasource respondsToSelector:@selector(dropDown:tableView:cellForRowAtIndexPath:)]) {
            return [self.datasource dropDown:self tableView:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    
    return [[UITableViewCell alloc] init];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.datasource && [self.datasource respondsToSelector:@selector(dropDown:heightForRowAtIndexPath:)]) {
        _heightForRow = [self.datasource dropDown:self heightForRowAtIndexPath:indexPath];
    }
    
    return _heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDown:didSelectRowAtIndexPath:)]) {
        [self.delegate dropDown:self didSelectRowAtIndexPath:indexPath];
    }
    if(self.selectBlock)self.selectBlock(indexPath.row, [self.itemArray objectAtIndex:indexPath.row]);
    [self dismiss:NO];
}

@end
