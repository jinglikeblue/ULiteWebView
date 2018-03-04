using Jing.ULiteWebView;
using UnityEngine;
using UnityEngine.UI;

public class Demo : MonoBehaviour {

    public InputField inputField;
    public Text msgContent;

    /// <summary>
    /// ULiteWebView Script Object
    /// </summary>
    public ULiteWebView ulite;

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
	}

	void Update () {
	}

    public void OpenWebView()
    {
        btnLoad.SetActive(false);
        btnClose.SetActive(true);
        btnLocalUrl.SetActive(false);
        btnCallJs.SetActive(false);

        ulite.Show();
        ulite.LoadUrl(inputField.text);
    }

    public void CloseWebView()
    {
        btnLoad.SetActive(true);
        btnClose.SetActive(false);
        btnLocalUrl.SetActive(true);
        btnCallJs.SetActive(false);

        ulite.Close();
    }

    void ShowMsg(string info)
    {
        msgContent.text = info;
    }

    public void CallJS()
    {
        ulite.CallJS("callJS", "unity is here");
    }

    public void LoadLocal(){
        btnLoad.SetActive(false);
        btnClose.SetActive(true);
        btnLocalUrl.SetActive(false);
        btnCallJs.SetActive(true);

        string localUrl = "/ulitewebview_test.html";
        ulite.RegistJsInterfaceAction("ShowMsg", ShowMsg);
        ulite.Show();
        ulite.LoadLocal(localUrl);
    }
}
