
using UnityEngine;

public enum Items
{
    //Collectables
    NightShade = 1,
    Flower = 1 << 1,
    Root = 1 << 2,
    Charcoal = 1 << 3,
    Bark = 1 << 4,
    Bone = 1 << 5,
    Moss = 1 << 6,
    FourLeafClover = 1 << 7,
    RabitsFoot = 1 << 8,

    //Craftables
    ElixerOfLight = 1 << 9,
    SoulSnatcher = 1 << 10,
    TinctureOfPain = 1 << 11,
    SoundOfMadness = 1 << 12,
    InfusionOfDarkness = 1 << 13,
}

public class Inventory : MonoBehaviour
{
    public Items inventory;

    public int PlayerInventoryLimit = 5;

    public GameObject[] Listeners;
    public InventoryItem[] ItemData;

    public bool HasItem(Items item)
    {
        return (item & inventory) == item;
    }

    public bool IsFull()
    {
        return SparseBitcount((int)inventory) >= PlayerInventoryLimit;
    }

    public void AddItem(Items item)
    {
        inventory |= item;

        foreach (GameObject listener in Listeners)
        {
            listener.SendMessage("HandleInventoryUpdated", this);
        }
    }

    public void RemoveItem(Items item)
    {
        inventory ^= item;

        foreach (GameObject listener in Listeners)
        {
            listener.SendMessage("HandleInventoryUpdated", this);
        }
    }

    public InventoryItem GetItemData(Items ID)
    {
        foreach (InventoryItem item in ItemData)
        {
            if (item.ID == ID)
            {
                return item;
            }
        }
        Debug.LogWarning("inventory item data (character inventory component) not found for " + ID);
        return null;
    }

    // http://www.dotnetperls.com/bitcount
    private static int SparseBitcount(int n)
    {
        int count = 0;
        while (n != 0)
        {
            count++;
            n &= (n - 1);
        }
        return count;
    }
}
