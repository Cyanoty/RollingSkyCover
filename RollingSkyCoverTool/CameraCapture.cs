using UnityEngine;
using System.IO;

/// <summary>
/// 相机截图
/// <para>ZhangYu 2018-07-06</para>
/// </summary>
public class CameraCapture : MonoBehaviour {
    
    
    private bool m_IsEnableAlpha = true;
    
    private CameraClearFlags m_CameraClearFlags;
    
    
    // 截图尺寸
    public enum CaptureSize {
        CameraSize,
        ScreenResolution,
        FixedSize
    }

    // 目标摄像机
    public Camera targetCamera;
    // 截图尺寸
    public CaptureSize captureSize = CaptureSize.CameraSize;
    // 像素尺寸
    public Vector2 pixelSize;
    // 保存路径
    public string savePath = "StreamingAssets/";
    // 文件名称
    public string fileName = "cameraCapture.png";

    #if UNITY_EDITOR
    private void Reset() {
        targetCamera = GetComponent<Camera>();
        pixelSize = new Vector2(Screen.currentResolution.width, Screen.currentResolution.height);
    }
    #endif

    /// <summary> 保存截图 </summary>
    /// <param name="camera">目标摄像机</param>
    public void saveCapture() {
        m_CameraClearFlags =targetCamera.clearFlags;
        targetCamera.clearFlags = CameraClearFlags.Depth;
        Vector2 size = pixelSize;
        if (captureSize == CaptureSize.CameraSize) {
            size = new Vector2(targetCamera.pixelWidth, targetCamera.pixelHeight);
        } else if (captureSize == CaptureSize.ScreenResolution) {
            size = new Vector2(Screen.currentResolution.width, Screen.currentResolution.height);
        }
        string path = Application.dataPath + "/" + savePath + fileName;
        saveTexture(path, capture(targetCamera, (int)size.x, (int)size.y));
    }

    /// <summary> 相机截图 </summary>
    /// <param name="camera">目标相机</param>
    public static Texture2D capture(Camera camera) {
        return capture(camera, Screen.width, Screen.height);
    }

    /// <summary> 相机截图 </summary>
    /// <param name="camera">目标相机</param>
    /// <param name="width">宽度</param>
    /// <param name="height">高度</param>
    public static Texture2D capture(Camera camera, int width, int height) {
        RenderTexture rt = new RenderTexture(width, height, 0);
        rt.depth = 24;
        rt.antiAliasing = 8;
        camera.targetTexture = rt;
        camera.RenderDontRestore();
        RenderTexture.active = rt;
        Texture2D texture = new Texture2D(width, height, TextureFormat.ARGB32, false, true);
        Rect rect = new Rect(0, 0, width, height);
        texture.ReadPixels(rect, 0, 0);
        texture.filterMode = FilterMode.Point;
        texture.Apply();
        camera.targetTexture = null;
        RenderTexture.active = null;
        Destroy(rt);
        return texture;
    }

    /// <summary> 保存贴图 </summary>
    /// <param name="path">保存路径</param>
    /// <param name="texture">Texture2D</param>
    public static void saveTexture(string path, Texture2D texture) {
        File.WriteAllBytes(path, texture.EncodeToPNG());
        #if UNITY_EDITOR
        Debug.Log("已保存截图到:" + path);
        #endif
    }

}