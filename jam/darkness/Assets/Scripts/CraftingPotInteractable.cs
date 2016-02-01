using UnityEngine;
using System.Collections;

public class CraftingPotInteractable : Interactable {

	public GameObject CraftingUI;
	public override void Interact(GameObject player)
	{
		Debug.Log("Crafting UI enabled");
		CraftingUI.SetActive( true );
	}
}
