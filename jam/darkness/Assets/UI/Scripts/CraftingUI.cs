
using UnityEngine;
using UnityEngine.EventSystems;

public class CraftingUI : MonoBehaviour
{
    public InventoryUI Inventory;
    public CraftingPot m_CraftingPot;

    public InventorySlot[] Slots;

    public void Clear()
    {
        foreach (InventorySlot slot in Slots)
        {
            slot.Item = null;
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
            Debug.LogError("CraftingUI has no Inventory reference");
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

    public void Craft()
    {
        m_CraftingPot.Clear();

        foreach (InventorySlot slot in Slots)
        {
            if (slot != null &&
                slot.Item != null)
            {
                m_CraftingPot.AddIngredient(slot.Item.ID);
            }
        }

        if (m_CraftingPot.Craft())
        {
            Clear();
        }
    }
}
