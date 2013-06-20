/**
 * 我是UIView，我是GridView的主程序，用来配置、绘制数据表格。实现的功能有
 * 一、基本的以表格的形式显示数据
    * 内容超出数据表格时，可以选择是否减小字体来适应，同时可以设定最小允许字体
 * 二、动态控制是否有标题Header和总结Footer
    * 如果实现对应代理方法，则显示。否则不显示
 * 三、实现GridRowView的复用，提高性能，节省资源
 * 四、实现可控制的下拉刷新与上拖加载更多数据
    * 有对应的开关做判断
    * 可设定是释放拖动后执行，还是立即执行
 * 五、动态控制锁定列
    * 长按Header，出现弹出框
 * 六、删除行操作
    * 有对应的开关做判断
 **/
#import <UIKit/UIKit.h>
#import "GridRowView.h"
#import "GridColumnModel.h"
#import "GridStateView.h"

@class GridView;

@protocol GridViewDelegate <NSObject>

/**
 * 返回Content中对应行的高度
 **/
- (CGFloat)gridView:(GridView *)p_view heightForContentAtRow:(NSInteger)p_row;

@optional
/**
 * 点击事件
 **/
- (void)gridView:(GridView *)p_view didSelectAtPosition:(GridPosition)p_p;

/**
 * 删除行
 **/
- (void)gridView:(GridView *)p_view deleteWithRow:(NSInteger)p_row;

/**
 * 返回Header的高度
 **/
- (CGFloat)heightForHeader:(GridView *)p_view;

/**
 * 返回Footer的高度
 **/
- (CGFloat)heightForFooter:(GridView *)p_view;

@end

@protocol GridViewDataSource <NSObject>

/**
 * 返回Content中有多少行数据
 **/
- (NSInteger)numberOfContentRowsInGridView:(GridView *)p_view;

/**
 * 返回GridView中有多少列数据
 **/
- (NSInteger)numberOfColumnsInGridView:(GridView *)p_view;

/**
 * 返回对应列的参数设置
 **/
- (GridColumnModel *)gridView:(GridView *)p_view modelForColumnAtColumn:(NSInteger)p_column;

/**
 * 返回Content中对应位置的显示文本
 **/
- (NSString *)gridView:(GridView *)p_view textForContentAtPosition:(GridPosition)p_p;

@optional

/**
 * 返回Header中对应列的显示文本
 **/
- (NSString *)gridView:(GridView *)p_view textForHeaderAtColumn:(NSInteger)p_column;

/**
 * 返回Footer中对应列的显示文本
 **/
- (NSString *)gridView:(GridView *)p_view textForFooterAtColumn:(NSInteger)p_column;

@end

@interface GridView : UIView
    <UIScrollViewDelegate,
    GridRowViewDelegate> {
            // 可滑动载体
        UIScrollView *_upAndDownScrollView;
        UIScrollView *_leftAndRightScrollView;
        BOOL _isScrollAble;
            // 数据容器相关
        UIView *_upAndDownContentView;
        UIView *_leftAndRightContentView;
        UIView *_leftHeaderContentView;
        UIView *_rightHeaderContentView;
        UIView *_leftFooterContentView;
        UIView *_rightFooterContentView;
        
        CGFloat _leftContentWidth;// 锁定区域的宽度
        CGFloat _rightContentWidth;// 可滑动区域的宽度
        CGFloat _contentHeight;// 可滑动区域的高度
        CGFloat _headerHeight;// 头的行高
        CGFloat _footerHeight;// 尾的行高
            // 列锁定相关
        NSMutableArray *_lockedColumnMArr;// 默认第一列锁定
        NSInteger _selectedColumnIndex;
            // 复用相关
        NSInteger _rangeFrom;
        NSInteger _rangeTo;
        NSInteger _range;
        CGFloat _contentOffsetPreY;
        NSMutableArray *_leftContentQueue;
        NSMutableArray *_rightContentQueue;
            // 下拉刷新与上拖加载更多相关
        GridStateView *_headerStateView;
        GridStateView *_footerStateView;
}

@property (nonatomic, assign) id<GridViewDelegate> delegate;
@property (nonatomic, assign) id<GridViewDataSource> dataSource;
    // 是否支持下拉刷新，默认NO
@property (nonatomic, assign, getter = isPullDownAble) BOOL isPullDownAble;
    // 是否是释放后执行刷新数据，默认YES
@property (nonatomic, assign, getter = isPerformAfterFreeForPullDown) BOOL isPerformAfterFreeForPullDown;
@property (nonatomic, assign) id<GridStateViewPullDownDelegate> delegatePullDown;
    // 是否支持上拖加载更多，默认NO
@property (nonatomic, assign, getter = isDragUpAble) BOOL isDragUpAble;
    // 是否是释放后执行加载更多数据，默认NO
@property (nonatomic, assign, getter = isPerformAfterFreeForDragUp) BOOL isPerformAfterFreeForDragUp;
@property (nonatomic, assign) id<GridStateViewDragUpDelegate> delegateDragUp;
    // 是否支持边界跳跃，默认YES
@property (nonatomic, assign, getter = isBouncesAble) BOOL isBouncesAble;
    // 是否可以删除行，默认NO
@property (nonatomic, assign, getter = isDeleteRowAble) BOOL isDeleteRowAble;
    // 当数据内容超出宽度时，是否自动缩小字体，默认NO
@property (nonatomic, assign, getter = isDecForFontSizeAble) BOOL isDecForFontSizeAble;
    // 当缩小字体时可以允许的最小字体，如果允许，那么默认是12号
@property (nonatomic, assign) CGFloat minimumFontSize;

/**
 * 在配置完GridView相关参数后调用此方法，实现绘制数据表格，并且填充数据
 **/
- (void)loadView:(CGRect)p_frame;

/**
 * 重新加载数据，例如在下拉刷新与上拖加载更多时用到
 **/
- (void)reloadData;

@end
