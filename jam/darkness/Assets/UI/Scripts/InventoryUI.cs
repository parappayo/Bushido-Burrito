
using System;
using UnityEngine;
using UnityEngine.EventSystems;

public class InventoryUI : MonoBehaviour
{
    public InventorySlot[] Slots;

    private int _NextSlotIndex = 0;

    public InventoryItem SelectedItem;

    public void HandleInventoryUpdated(Inventory inventory)
    {
        ClearSlots();

        var items = Enum.GetValues(typeof(Items));
        foreach (Items item in items)
        {
            if (inventory.HasItem(item))
            {
                AssignSlot(inventory.GetItemData(item));
            }
        }
    }

    public void HandleBeginDrag(InventorySlot slot)
    {
        SelectedItem = slot.Item;
    }

    private void ClearSlots()
    {
        foreach (InventorySlot slot in Slots)
        {
            slot.Item = null;
        }
        _NextSlotIndex = 0;
    }

    private void AssignSlot(InventoryItem item)
    {
        if (_NextSlotIndex >= Slots.Length)
        {
            return;
        }

        Slots[_NextSlotIndex].Item = item;
        _NextSlotIndex++;
    }
}
