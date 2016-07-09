
public class ProgressCalculator02 : ProgressCalculator
{
    public override float Cooldown
    {
        get
        {
            return 5f;
        }
    }

    public override float AwardAmount
    {
        get
        {
            return 50f * UpgradeLevel * UpgradeLevel;
        }
    }

    public override float UpgradeCost
    {
        get
        {
            return 200f * UpgradeLevel * UpgradeLevel;
        }
    }
}
