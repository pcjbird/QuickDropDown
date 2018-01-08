//
//  QuickDropDown.h
//  QuickDropDown
//
//  Created by pcjbird on 2018/1/6.
//  Copyright © 2018年 Zero Status. All rights reserved.
//
//  框架名称:QuickDropDown
//  框架功能:一款简洁大方的下拉列表框控件。
//  修改记录:
//     pcjbird    2018-01-08  Version:1.0.1 Build:201801080001
//                            1.优化，新增注释
//
//     pcjbird    2018-01-07  Version:1.0.0 Build:201801070001
//                            1.首次发布SDK版本

#import <UIKit/UIKit.h>

//! Project version number for QuickDropDown.
FOUNDATION_EXPORT double QuickDropDownVersionNumber;

//! Project version string for QuickDropDown.
FOUNDATION_EXPORT const unsigned char QuickDropDownVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <QuickDropDown/PublicHeader.h>


#define QDDColor(r, g, b, a)    [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]
#define QDDRandomColor    QDDColor(arc4random() % 256, arc4random() % 256, arc4random() % 256, 1)

#define QDDBlack         [UIColor blackColor]
#define QDDDarkGray      [UIColor darkGrayColor]
#define QDDLightGray     [UIColor lightGrayColor]
#define QDDWhite         [UIColor whiteColor]
#define QDDGray          [UIColor grayColor]
#define QDDRed           [UIColor redColor]
#define QDDGreen         [UIColor greenColor]
#define QDDBlue          [UIColor blueColor]
#define QDDCyan          [UIColor cyanColor]
#define QDDYellow        [UIColor yellowColor]
#define QDDMagenta       [UIColor magentaColor]
#define QDDOrange        [UIColor orangeColor]
#define QDDPurple        [UIColor purpleColor]
#define QDDBrown         [UIColor brownColor]
#define QDDClear         [UIColor clearColor]
#define QDDSkyBlue       QDDColor(0, 173.4, 255, 1)
#define QDDLightBlue     QDDColor(125, 231, 255, 1)
#define QDDSystemBlue    QDDColor(10, 96, 254, 1)
#define QDDFicelle       QDDColor(247, 247, 247, 1)
#define QDDTaupe         QDDColor(238, 239, 241, 1)
#define QDDTaupe2        QDDColor(237, 236, 236, 1)
#define QDDTaupe3        QDDColor(236, 236, 236, 1)
#define QDDGrassGreen    QDDColor(254, 200, 122, 1)
#define QDDGold          QDDColor(255, 215, 0, 1)
#define QDDDeepPink      QDDColor(238, 18, 137, 1)

typedef void (^QuickDropDownSelectBlock)(NSInteger selectedIndex, id selectedItem);
typedef void (^QuickDropDownDismissBlock)(void);

/**
 *  @brief dropDown样式
 */
typedef enum{
    QuickDropDownPatternDefault = 0,//默认
    QuickDropDownPatternCustom = 1, //自定义
}QuickDropDownPattern;

/**
 *  @brief 显示位置
 */
typedef enum{
    QuickDropDownOrientationUp = 0, //上方显示
    QuickDropDownOrientationDown = 1//下方显示(默认)
}QuickDropDownOrientation;

@class QuickDropDown;
/**
 *  @brief 数据源
 */
@protocol QuickDropDownDataSource <NSObject>

@required

/**
 * @brief 数据源
 *
 *  remark: ①当dropDown为QuickDropDownPatternDefault时, NSArray必须存储NSString类型: @[@"1", @"2", @"3"];
            ②当dropDown为QuickDropDownPatternCustom时, NSArray可存储任意元素类型，但所有元素的类型必须一致
 *
 *  @return NSArray
 */
- (NSArray *)itemArrayInDropDown:(QuickDropDown *)dropDown;

@optional

/**
 *  @brief 设置cell高度(默认为44.f)
 *
 *  @param dropDown 当前dropDown
 *  @param indexPath 当前cell的下标
 */
- (CGFloat)dropDown:(QuickDropDown *)dropDown heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief tableView展示行数(默认展示6行)
 *
 *  @param dropDown 当前dropDown
 *  @param count 可拿到数据源的个数进行特殊情况行数展示设置
 eg: 例如当有多个dropDown时，某个dropDown数据源的个数不够n个，则可以用此方法拿到count进行判断，当count < n，则返回当前数据源的个数，否则则返回n个
 *
 *  @return 返回NSUInteger
 */
- (NSUInteger)numberOfRowsToDisplayIndropDown:(QuickDropDown *)dropDown itemArrayCount:(NSUInteger)count;



/**
 *  @brief 返回自定义cell(当dropDown为QuickDropDownPatternDefault时，该方法无效)
 
 *  @param dropDown 当前dropDown
 *  @param tableView tableView
 *  @param indexPath indexPath
 *  @return UITableViewCell
 */
- (UITableViewCell *)dropDown:(QuickDropDown *)dropDown tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 *  @brief 代理
 */
@protocol QuickDropDownDelegate <NSObject>

@optional
/**
 *  @brief 选中下拉项
 *  @param dropDown 当前dropDown
 *  @param indexPath 数据所在数组的位置下标
 */
- (void)dropDown:(QuickDropDown *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  @brief 取消选择（dismiss）
 *  @param dropDown 当前dropDown
 */
- (void)dropDownDidDismiss:(QuickDropDown *)dropDown;

@end



/**
 *  @brief QuickDropDown
 */
@interface QuickDropDown : NSObject

/**
 *  @brief 是否显示(展开)
 */
@property(nonatomic, readonly) BOOL isShown;

/**
 *  @brief 数据源
 */
@property (nonatomic, weak) id<QuickDropDownDataSource> datasource;

/**
 *  @brief 代理
 */
@property (nonatomic, weak) id<QuickDropDownDelegate> delegate;

/**
 *  @brief 背景颜色, 默认QDDTaupe3
 */
@property (nonatomic, strong) UIColor * backgroundColor;
/**
 * @brief 下拉项 文本颜色
 */
@property (nonatomic, strong) UIColor * itemTextColor;
/**
 * @brief 下拉项 文本字体
 */
@property (nonatomic, strong) UIFont * itemTextFont;
/**
 * @brief 下拉项 文本对齐方式
 */
@property (nonatomic, assign) NSTextAlignment itemTextAlignment;
/**
 * @brief 下拉项 文本显示行数，默认 1
 */
@property (nonatomic, assign) NSInteger itemTextNumberOfLines;
/**
 * @brief 展示方向， 默认为QuickDropDownOrientationDown
 */
@property (nonatomic, assign) QuickDropDownOrientation orientation;
/**
 * @brief 阴影透明度(默认为0.5, 范围0~1)
 */
@property (nonatomic, assign) CGFloat shadowOpacity;
/**
 * @brief cornerRadius
 */
@property (nonatomic, assign) CGFloat cornerRadius;
/**
 * @brief 分割线样式(默认为UITableViewCellSeparatorStyleNone)
 */
@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;

/**
 *@brief 初始化
 *@param pattern 样式
 *@return QuickDropDown
 */
- (instancetype)initWithPattern:(QuickDropDownPattern)pattern;

/**
 *@brief 在target视图处显示，下拉框与target同宽，具体位置根据orientation属性而定，当该属性为QuickDropDownOrientationDown时，dropdown显示在target视图的下方
 *@param target 目标视图
 */
-(void) showAtTargetView:(UIView*)target;

/**
 *@brief 在target视图处显示，下拉框与target同宽，具体位置根据orientation属性而定，当该属性为QuickDropDownOrientationDown时，dropdown显示在target视图的下方
 *@param target 目标视图
 *@param selectedBlock 选中回调
 *@param dismissBlock dismiss回调
 */
-(void) showAtTargetView:(UIView*)target selectedBlock:(QuickDropDownSelectBlock)selectedBlock dismissBlock:(QuickDropDownDismissBlock)dismissBlock;

/**
 *@brief dismiss
 */
-(void) dismiss;

/**
 *@brief 重新加载
 */
- (void)reloadData;

@end
