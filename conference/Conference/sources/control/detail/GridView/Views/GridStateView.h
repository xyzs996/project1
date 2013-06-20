/**
 * 我是一个UIView，在下拉刷新与上拖加载更多时用到我，我可以显示加载状态，上次刷新（加载）时间。
 **/
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    GridStateViewStateNormal,
    GridStateViewStatePullDown,
    GridStateViewStateLoading,
    GridStateViewStateDragUp,
    GridStateViewStateEnd
}GridStateViewState;

typedef enum {
    GridStateViewReturnTypeDoNothing,
    GridStateViewReturnTypePullDown,
    GridStateViewReturnTypeDragUp
}GridStateViewReturnType;

typedef enum {
    GridStateViewTypeHeader,
    GridStateViewTypeFooter
}GridStateViewType;

#define k_STATE_VIEW_HEIGHT         40    //  视图窗体：视图高度
#define k_STATE_VIEW_INDICATE_WIDTH 60    //  视图窗体：视图箭头指示器宽度

@class GridStateView;

@protocol GridStateViewPullDownDelegate <NSObject>

@required

/**
 * 下拉刷新代理方法
 **/
- (void)gridStateViewPullDown:(GridStateView *)p_view;

@end

@protocol GridStateViewDragUpDelegate <NSObject>

@required

/**
 * 上拖家在更多代理方法
 **/
- (void)gridStateViewDragUp:(GridStateView *)p_view;

@end

@interface GridStateView : UIView {
    UIActivityIndicatorView *_indicatorView;
    UIImageView *_arrowView;
    UILabel *_stateLabel;
    UILabel *_timeLabel;
    GridStateViewType _viewType;
}

@property (nonatomic, assign) GridStateViewState currentState;

/**
 * 确定类型的构造方法
 **/
- (id)initWithViewType:(GridStateViewType)p_type;

/**
 * 启动GridStateView
 **/
- (void)loadView;

/**
 * 改变GridStateView当前的状态
 **/
- (void)changeState:(GridStateViewState)p_state;

/**
 * 更新当前时间
 **/
- (void)updateTimeLabel;

@end
