
using UnityEngine;

public class Craftable : MonoBehaviour
{
    public Items m_ItemType;

    [SerializeField]
    Items[] m_RequiredItemsList;

    public Items m_RequiredItems { get; private set; }

    public bool Craft(Inventory inventory)
    {
        if (inventory.HasItem(m_RequiredItems))
        {
            inventory.AddItem(m_ItemType);
            return true;
        }
        return false; //not all mats are owned
    }

    public void Start()
    {
        m_RequiredItems = 0;
        foreach (Items item in m_RequiredItemsList)
        {
            m_RequiredItems |= item;
        }
    }
}
