package com.jing.unity.base;

import android.app.Activity;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * Created by Jing on 2018/3/1 0001.
 */
public class Unity {

    /**
     * 对象单例
     */
    public static Unity ins = new Unity();

    private Unity(){
        //单例模式
    }

    /**
     * Unity使用的上下文
     */
    public Activity activity;

    /**
     * 获取Unity使用的上下文
     * @return
     */
    public Activity getActivity(){
        if(null == activity) {
            try {
                Class<?> classtype = Class.forName("com.unity3d.player.UnityPlayer");
                Activity curActivity = (Activity) classtype.getDeclaredField("currentActivity").get(classtype);
                activity = curActivity;
            } catch (ClassNotFoundException e) {

            } catch (IllegalAccessException e) {

            } catch (NoSuchFieldException e) {

            }
        }
        return activity;
    }

    /**
     * 调用Unity项目中的方法
     * @param gameObjectName    调用的GameObject的名称
     * @param functionName      方法名
     * @param args              参数
     * @return                  调用是否成功
     */
    public boolean call(String gameObjectName, String functionName, String args){
        try {
            Class<?> classtype = Class.forName("com.unity3d.player.UnityPlayer");
            Method method =classtype.getMethod("UnitySendMessage", String.class,String.class,String.class);
            method.invoke(classtype,gameObjectName,functionName,args);
            return true;
        } catch (ClassNotFoundException e) {

        } catch (NoSuchMethodException e) {

        } catch (IllegalAccessException e) {

        } catch (InvocationTargetException e) {

        }
        return false;
    }
}
