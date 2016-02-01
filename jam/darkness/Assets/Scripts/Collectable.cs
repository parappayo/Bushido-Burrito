using UnityEngine;
using System.Collections;

public class Collectable : Interactable
{
    public Items m_ItemType;

    private bool HasItem(Inventory inventory, Items item)
    {
        return (m_ItemType & inventory.inventory) == 0;
    }

    public override void Interact(GameObject player)
    {
        Inventory inventory = player.GetComponent<Inventory>();
        if (!inventory.HasItem(m_ItemType) &&
            !inventory.IsFull())
        {
            Debug.Log("Object Collected: " + m_ItemType);

            inventory.AddItem(m_ItemType);
            Destroy(this.gameObject);
        }
    }
}
