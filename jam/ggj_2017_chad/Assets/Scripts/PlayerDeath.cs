
using UnityEngine;

public class PlayerDeath : MonoBehaviour
{
	public void OnHitByWave()
	{
		Debug.Log("player died!");
		var guiManager = GuiManager.Instance;
		if (guiManager != null) 
		{
			guiManager.EndGame();
		}
	}
}
