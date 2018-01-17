
using UnityEngine;

public class ShowFPS : MonoBehaviour
{
    public bool ShowGUI = true;
    public GUIStyle Style = new GUIStyle();

    private float deltaTime = 0.0f;
    private float fps = 0.0f;

    private void Update()
    {
        deltaTime += (Time.unscaledDeltaTime - deltaTime) * 0.1f;
        fps = 1.0f / deltaTime;
    }

    private void OnGUI()
    {
        if (!ShowGUI) { return; }

        Rect rect = new Rect(0, 0, Screen.width, Screen.height * 2 / 100);
        string caption = string.Format("{0:0.} fps", fps);
        GUI.Label(rect, caption, Style);
    }
}
