
using UnityEngine;

public class ProgressController : MonoBehaviour
{
    public GameState Game;
    public ProgressCalculator Calculator;
    public ProgressSlider Slider;

    public float TimeScale = 1f;

    // TODO: be able to save out this state data
    private float Timer;

    private void Start()
    {
        Slider.OnClick = OnSliderClick;
        Slider.OnUpgradeClick = OnSliderUpgradeClick;
    }

    private void Update()
    {
        Timer += Time.deltaTime * TimeScale;

        Slider.Caption = Calculator.AwardAmount.ToString();
        Slider.Progress = (Timer / Calculator.Cooldown);

        Slider.UpgradeEnabled = CanUpgrade;
        Slider.UpgradeCaption = CanUpgrade ? "Upgrade" : Calculator.UpgradeCost.ToString();
    }

    private void OnSliderClick()
    {
        if (Timer >= Calculator.Cooldown)
        {
            Timer = 0f;

            Game.Currency += Calculator.AwardAmount;
        }
    }

    private void OnSliderUpgradeClick()
    {
        if (CanUpgrade)
        {
            Game.Currency -= Calculator.UpgradeCost;
            Calculator.Upgrade();
        }
    }

    private bool CanUpgrade
    {
        get
        {
            return (Game.Currency >= Calculator.UpgradeCost);
        }
    }
}
