using System;
using Jing.ULiteWebView;
using UnityEngine;
using UnityEngine.UI;

public class Demo : MonoBehaviour {

    [Header("距离屏幕上边缘距离")]
    public int top = 0;
    [Header("距离屏幕下边缘距离")]
    public int bottom = 0;
    [Header("距离屏幕左边缘距离")]
    public int left = 0;
    [Header("距离屏幕右边缘距离")]
    public int right = 0;

    [Space(50)]

    public InputField inputField;
    public Text msgContent;

    [Space(50)]
    public GameObject btnLoad;
    public GameObject btnClose;
    public GameObject btnLocalUrl;
    public GameObject btnCallJs;

	void Start () {
        btnLoad.SetActive(true);
        btnClose.SetActive(false);
        btnLocalUrl.SetActive(true);
        btnCallJs.SetActive(false);

        ULiteWebView.Ins.onLoadingUrl += OnLoadingUrl;
    }

    private void OnLoadingUrl(string url)
    {
        msgContent.text = url;
    }

    void ShowMsg(string info)
    {
        msgContent.text = info;
    }



    public void Load()
    {
        btnLoad.SetActive(false);
        btnClose.SetActive(true);
        btnLocalUrl.SetActive(false);
        btnCallJs.SetActive(false);

        ULiteWebView.Ins.Show(top, bottom, left, right);
        ULiteWebView.Ins.LoadUrl(inputField.text);
    }

    public void Close()
    {
        btnLoad.SetActive(true);
        btnClose.SetActive(false);
        btnLocalUrl.SetActive(true);
        btnCallJs.SetActive(false);

        ULiteWebView.Ins.Close();
    }

    public void LocalHtml(){
        btnLoad.SetActive(false);
        btnClose.SetActive(true);
        btnLocalUrl.SetActive(false);
        btnCallJs.SetActive(true);

        string localUrl = "/ulitewebview_test.html";
        ULiteWebView.Ins.RegistJsInterfaceAction("ShowMsg", ShowMsg);
        ULiteWebView.Ins.Show(top, bottom, left, right);
        ULiteWebView.Ins.LoadLocal(localUrl);
    }

    public void CallJS()
    {
        ULiteWebView.Ins.CallJS("callJS", "unity is here");
    }
}
