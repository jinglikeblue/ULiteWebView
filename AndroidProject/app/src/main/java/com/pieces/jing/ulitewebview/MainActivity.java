package com.pieces.jing.ulitewebview;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.jing.unity.base.Unity;
import com.jing.unity.ulitewebview.ULiteWebView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Unity.ins.activity = this;
        ULiteWebView uWebView = new ULiteWebView();
        uWebView.show(50,50,50,50);
        uWebView.loadUrl("http://www.baidu.com");

    }
}
