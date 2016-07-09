
public class ProgressCalculator04 : ProgressCalculator
{
    public override float Cooldown
    {
        get
        {
            return 20f;
        }
    }

    public override float AwardAmount
    {
        get
        {
            return 2000f * UpgradeLevel * UpgradeLevel;
        }
    }

    public override float UpgradeCost
    {
        get
        {
            return 5000f * UpgradeLevel * UpgradeLevel * UpgradeLevel;
        }
    }
}
