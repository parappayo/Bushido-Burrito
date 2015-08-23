using UnityEngine;
using System.Collections;

public class PlayerShotTargetHelper : MonoBehaviour {

	public Lion TheLion;

	public void OnShotByPlayer(RaycastHit hit)
	{
		if (TheLion != null)
		{
			TheLion.OnShotByPlayer(hit);
		}
	}
}
