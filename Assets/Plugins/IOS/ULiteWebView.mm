
#import <WebKit/WKWebView.h>
#import <WebKit/WKNavigationDelegate.h>
#import <WebKit/WKNavigationAction.h>
#import <WebKit/WKNavigationResponse.h>
#import <WebKit/WKNavigation.h>
#import <WebKit/WKUserContentController.h>
#import <WebKit/WKScriptMessage.h>
#import <WebKit/WKWebViewConfiguration.h>
#import <WebKit/WKPreferences.h>
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WKUIDelegate.h>

@interface ULiteWebView : NSObject<WKNavigationDelegate,WKScriptMessageHandler>
{
    WKWebView* _webView;
    NSString* _gameObjectName;
}
@end

@implementation ULiteWebView
//注册webview
- (void)init:(const char*)gameObjectName{
    _gameObjectName = [NSString stringWithUTF8String:gameObjectName];
}

- (void)createWebView{
    if(_webView == nil){
        UIView* view = UnityGetGLViewController().view;
        _webView = [[WKWebView alloc] initWithFrame:view.frame];
        _webView.hidden = YES;
        _webView.navigationDelegate = self;
//        _webView.UIDelegate = self;
        [[_webView configuration].userContentController addScriptMessageHandler:self name:@"ULiteWebView"];
        
        //        //创建网页配置对象
        //         WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //
        //         // 创建设置对象
        //         WKPreferences *preference = [[WKPreferences alloc]init];
        //         //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        //         preference.minimumFontSize = 0;
        //         //设置是否支持javaScript 默认是支持的
        //         preference.javaScriptEnabled = YES;
        //         // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        //         preference.javaScriptCanOpenWindowsAutomatically = YES;
        //         config.preferences = preference;
        //
        //         // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        //         config.allowsInlineMediaPlayback = YES;
        //         //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        //         config.requiresUserActionForMediaPlayback = YES;
        //         //设置是否允许画中画技术 在特定设备上有效
        //         config.allowsPictureInPictureMediaPlayback = YES;
        //         //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        //         config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        //
        //         //这个类主要用来做native与JavaScript的交互管理
        //         WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //         //注册一个name为jsToOcNoPrams的js方法
        //         [wkUController addScriptMessageHandler:self  name:@"ULiteWebView"];
        //        config.userContentController = wkUController;
        
        
        
        [view addSubview:_webView];
    }
}

- (void)disposeWebView{
    if(_webView != nil){
        [_webView removeFromSuperview];
        [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"ULiteWebView"];
        _webView.navigationDelegate = nil;
        _webView.UIDelegate = nil;
        _webView = nil;
    }
}

//显示webview
- (void)show:(int)top bottom:(int)bottom left:(int)left right:(int)right {
    [self createWebView];
    UIView *view = UnityGetGLViewController().view;
    _webView.hidden = NO;
    CGRect frame = view.frame;
    CGFloat scale = view.contentScaleFactor;
    frame.size.width -= (left + right) / scale;
    frame.size.height -= (top + bottom) / scale;
    frame.origin.x += left / scale;
    frame.origin.y += top / scale;
    _webView.frame = frame;
}

//加载页面
- (void)loadUrl:(const char*)url{
    [self createWebView];
    NSString *urlStr = [NSString stringWithUTF8String:url];
    NSURL *nsurl = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsurl];
    [_webView loadRequest:request];
    [_webView reload];
}

//关闭webview窗口
- (void)close{
    if(_webView == nil){
        return;
    }
    _webView.hidden = YES;
    [self disposeWebView];
}

//调用JS
- (void)callJS:(const char*)funName msg:(const char*)msg{
    if(_webView == nil){
        return;
    }
    
    //OC调用JS  completionHandler是异步回调block
    NSString *jsStr= [NSString stringWithFormat:@"%s(\"%s\")",funName,msg];
    [_webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        NSLog(@"调用JS：%@", jsStr);
    }];
}

//被JS调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"方法名:%@", message.name);
    NSString* content = message.body;
    NSLog(@"参数:%@", content);
    
    
    UnitySendMessage([_gameObjectName UTF8String], "OnJsCall", [content UTF8String]);
}

//捕获链接请求
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSString *url = [[request URL] absoluteString];
//
//    UnitySendMessage([_gameObjectName UTF8String], "OnLoadingUrl", [url UTF8String]);
//
//    NSRange range = [url rangeOfString:@"ulitewebview://"];
//    if(range.location != NSNotFound){
//        NSString *msg = [url substringFromIndex:range.length];
//        UnitySendMessage([_gameObjectName UTF8String], "OnJsCall", [msg UTF8String]);
//        return YES;
//    }
//    return YES;
//}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"页面开始加载: %@", webView.URL.absoluteString);
    UnitySendMessage([_gameObjectName UTF8String], "OnLoadingUrl", [webView.URL.absoluteString UTF8String]);
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"页面加载失败");
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"页面内容开始加载");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"页面内容加载完成");
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"提交发生错误时调用");
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    //自己定义的协议头
    //    NSString *htmlHeadString = @"github://";
    //    if([urlStr hasPrefix:htmlHeadString]){
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
    //        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //        }])];
    //        [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"github://callName_?" withString:@""]];
    //            [[UIApplication sharedApplication] openURL:url];
    //        }])];
    //
    //        decisionHandler(WKNavigationActionPolicyCancel);
    //    }else{
    //        decisionHandler(WKNavigationActionPolicyAllow);
    //    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //    decisionHandler(WKNavigationResponsePolicyCancel);
}

//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//
//}
//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"进程终止了");
}

@end


extern "C"
{
void _registResponseGameObject(const char* gameObjectName);
void _show(int top, int bottom, int left, int right);
void _loadUrl(const char* url);
void _close();
void _callJS(const char* funName, const char* msg);


static ULiteWebView *ulite;
const char* gameObjectName;

void _registCallBackGameObjectName(const char* gameObjectName){
    if(ulite != nil){
        return;
    }
    
    ulite = [ULiteWebView alloc];
    [ulite init:gameObjectName];
    //        NSLog(@"_registResponseGameObject");
}

void _show(int top, int bottom, int left, int right){
    if(ulite == nil){
        return;
    }
    
    [ulite show:top bottom:bottom left:left right:right];
    //        NSLog(@"_show");
    
}

void _loadUrl(const char* url){
    if(ulite == nil){
        return;
    }
    
    [ulite loadUrl:url];
    //        NSLog(@"_loadUrl");
}

void _close(){
    if(ulite == nil){
        return;
    }
    
    [ulite close];
    //        NSLog(@"_close");
}

void _callJS(const char* funName, const char* msg){
    if(ulite == nil){
        return;
    }
    
    [ulite callJS:funName msg:msg];
    //        NSLog(@"_callJS");
}
}

