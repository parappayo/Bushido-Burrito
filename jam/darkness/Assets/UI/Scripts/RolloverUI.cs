
using UnityEngine;
using UnityEngine.UI;

public class RolloverUI : MonoBehaviour
{
    public GameObject WidgetRoot;
    public Text Caption;
    public Vector3 DisplayOffset = Vector3.zero;
    public float MouseAwaySquared = 1600;

    private RectTransform _RectTransform;

    public void ShowCaption(string caption)
    {
        if (caption.Length < 1)
        {
            WidgetRoot.gameObject.SetActive(false);
            return;
        }

        WidgetRoot.gameObject.SetActive(true);
        Caption.text = caption;
        _RectTransform.anchoredPosition = Input.mousePosition + DisplayOffset;
    }

    private void Start()
    {
        _RectTransform = WidgetRoot.GetComponent<RectTransform>();
    }

    private void Update()
    {
        Vector3 mousePos = Input.mousePosition + DisplayOffset;
        Vector2 mouseDiff = new Vector2(mousePos.x, mousePos.y) - _RectTransform.anchoredPosition;
        if (mouseDiff.sqrMagnitude > MouseAwaySquared)
        {
            WidgetRoot.gameObject.SetActive(false);
        }
    }
}
