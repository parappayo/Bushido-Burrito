
public class ProgressCalculator03 : ProgressCalculator
{
    public override float Cooldown
    {
        get
        {
            return 10f;
        }
    }

    public override float AwardAmount
    {
        get
        {
            return 250f * UpgradeLevel * UpgradeLevel * UpgradeLevel;
        }
    }

    public override float UpgradeCost
    {
        get
        {
            return 1200f * UpgradeLevel * UpgradeLevel;
        }
    }
}
