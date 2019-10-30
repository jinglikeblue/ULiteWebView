# 「ULiteWebView」使用指南

## 1.简介  
ULiteWebView是一个极度轻量化的Unity内嵌WebView插件。 

支持的平台：安卓/苹果 

功能： 
* 网络浏览 
* 支持Html5 
* 支持Unity与JS自定义接口交互 
* 支持URL SCHEME 
* 可定制的显示窗体大小 

特点：   
* 接入简单，核心文件仅3个，且无需额外配置 
* 轻量化，增加代码量仅20KB左右 
* 使用简单，复杂的功能已封装为几个调用简单的API接口

## 2.项目官网

## 3.在项目中使用
### 接入
至官网下载.unitypackage文件后，双击即可导入到项目中。如果不需要DEMO文件，只需要导入下方3个核心文件，插件即可正常使用。  

    /Assets
        /Plugins
            /Android/ULiteWebView.aar
            /IOS/ULiteWebView.mm
        /ULiteWevView/ULiteWebView.cs

### 使用
在场景中任意位置创建GameObject对象，并添加「ULiteWebView.cs」脚本。即可通过API工作

## 4.API说明
### 显示WebView
    /// <summary>
    /// 显示ULiteWebView关联的WebView
    /// </summary>
    /// <param name="top">WebView距离屏幕上边缘的距离（单位：像素）</param>
    /// <param name="bottom">WebView距离屏幕下边缘的距离（单位：像素）</param>
    /// <param name="left">WebView距离屏幕左边缘的距离（单位：像素）</param>
    /// <param name="right">WebView距离屏幕右边缘的距离（单位：像素）</param>
    public void Show(int top, int bottom, int left, int right)

### 加载URL
    /// <summary>
    /// 使用WebView加载指定的URL，访问网页用Http://开头
    /// </summary>
    /// <param name="url">访问的URL地址</param>
    public void LoadUrl(string url)

### 加载本地资源
    /// <summary>
    /// 访问StreamingAssets文件夹中存放的资源
    /// </summary>
    /// <param name="filePath">相对于StreamingAssets目录的文件路径，以"/"开头</param>
    public void LoadLocal(string filePath)

### 关闭WebView
    /// <summary>
    /// 关闭ULiteWebView关联的WebView
    /// </summary>
    public void Close() 

### 调用JS
    /// <summary>
    /// 请求当前WebView页面中对应的JS方法
    /// </summary>
    /// <param name="funName">Fun name.</param>
    /// <param name="msg">Message.</param>
    public void CallJS(string funName, string msg)

### 注册供JS调用的Unity方法
    /// <summary>
    /// 注册供JS调用的方法
    /// </summary>
    /// <param name="funName">方法名：JS通过该方法名调用对应方法</param>
    /// <param name="fun">方法</param>
    public void RegistJsInterfaceAction(string interfaceName, Action<String> action)

### 注销供JS调用的Unity方法
    /// <summary>
    /// 注销供JS调用的方法
    /// </summary>
    /// <param name="interfaceName">方法名：JS通过该方法名调用对应方法</param>
    /// <param name="action">方法</param>
    public void UnregistJsInterfaceAction(string interfaceName, Action<String> action)
