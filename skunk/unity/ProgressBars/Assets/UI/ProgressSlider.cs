
using System;

using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class ProgressSlider : MonoBehaviour, IPointerDownHandler
{
    public Slider Slider;
    public Text CaptionText;
    public Text UpgradeCaptionText;
    public Button UpgradeButton;

    public Action OnClick;
    public Action OnUpgradeClick;

    public float Progress
    {
        set { Slider.value = value; }
    }

    public string Caption
    {
        set { CaptionText.text = value; }
    }

    public string UpgradeCaption
    {
        set { UpgradeCaptionText.text = value; }
    }

    public bool UpgradeEnabled
    {
        set { UpgradeButton.interactable = value; }
    }

    private void Start()
    {
        UpgradeButton.onClick.AddListener(HandleUpgradeClick);
    }

    public void OnPointerDown(PointerEventData e)
    {
        OnClick();
    }

    private void HandleUpgradeClick()
    {
        OnUpgradeClick();
    }
}
