
using UnityEngine;
using UnityEngine.UI;

public class InventorySlot : MonoBehaviour
{
    public Text Caption;
    public Image Icon;
    public string EmptyCaption = "Empty";

    public RolloverUI Rollover;

    private InventoryItem _Item;
    public InventoryItem Item
    {
        get { return _Item; }

        set
        {
            _Item = value;

            if (Caption != null)
            {
                Caption.enabled = true;

                if (_Item != null)
                {
                    Caption.text = _Item.Caption;
                }
                else
                {
                    Caption.text = EmptyCaption;
                }
            }

            if (Icon != null)
            {
                if (_Item != null &&
                    _Item.Icon != null)
                {
                    Icon.overrideSprite = _Item.Icon;
                    Icon.enabled = true;

                    if (Caption != null)
                    {
                        Caption.enabled = false;
                    }
                }
                else
                {
                    Icon.overrideSprite = null;
                    Icon.enabled = false;
                }
            }
        }
    }

    public void HandlePointerEnter()
    {
        if (Rollover != null &&
            Item != null)
        {
            Rollover.ShowCaption(Item.RolloverCaption);
        }
    }
}
