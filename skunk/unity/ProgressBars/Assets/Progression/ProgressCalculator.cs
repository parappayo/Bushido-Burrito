
using UnityEngine;

public class ProgressCalculator : MonoBehaviour, IProgressCalculator
{
    // TODO: be able to save out this state data
    private int _UpgradeLevel = 1;

    public int UpgradeLevel
    {
        get
        {
            return _UpgradeLevel;
        }
    }

    public void Upgrade()
    {
        _UpgradeLevel += 1;
    }

    public virtual float Cooldown
    {
        get
        {
            return float.MaxValue;
        }
    }

    public virtual float AwardAmount
    {
        get
        {
            return 0f;
        }
    }

    public virtual float UpgradeCost
    {
        get
        {
            return float.MaxValue;
        }
    }
}
