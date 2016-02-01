
using UnityEngine;
using UnityEngine.UI;

public class AlchemyCircleUI : MonoBehaviour
{
    public InventoryUI Inventory;

    public InventorySlot[] Slots;

    private void Start()
    {
        foreach (InventorySlot slot in Slots)
        {
            slot.EmptyCaption = "";
            slot.Item = null; // force caption refresh
        }
    }

    private bool HasItem(Items item)
    {
        foreach (InventorySlot slot in Slots)
        {
            if (slot.Item != null &&
                slot.Item.ID == item)
            {
                return true;
            }
        }
        return false;
    }

    public void HandleDrop(InventorySlot slot)
    {
        if (Inventory == null)
        {
            Debug.LogError("AlchemyCircleUI has no Inventory reference");
            return;
        }

        if (Inventory.SelectedItem != null &&
            !HasItem(Inventory.SelectedItem.ID))
        {
            slot.Item = Inventory.SelectedItem;
            Inventory.SelectedItem = null;
        }
    }

    public void HandleClick(InventorySlot slot)
    {
        slot.Item = null;
    }
}
