
public class ProgressCalculator01 : ProgressCalculator
{
    public override float Cooldown
    {
        get
        {
            return 1f;
        }
    }

    public override float AwardAmount
    {
        get
        {
            return 20f * UpgradeLevel;
        }
    }

    public override float UpgradeCost
    {
        get
        {
            return 20f * UpgradeLevel * UpgradeLevel;
        }
    }
}
