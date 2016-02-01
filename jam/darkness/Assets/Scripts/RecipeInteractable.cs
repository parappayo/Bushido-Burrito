using UnityEngine;
using System.Collections;

public class RecipeInteractable : Interactable {
	public GameObject recipe;

	public override void Interact(GameObject player)
	{
		recipe.SetActive(true);
	}
}
