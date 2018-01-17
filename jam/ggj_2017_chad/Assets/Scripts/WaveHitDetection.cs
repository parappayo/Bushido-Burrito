
using UnityEngine;

public class WaveHitDetection : MonoBehaviour
{
	public GameObject Player;

	private void OnTriggerEnter(Collider other)
	{
		if (Player)
		{
			if (other.gameObject == Player)
			{
				Player.SendMessage("OnHitByWave", null, SendMessageOptions.RequireReceiver);
			}
		}
		else
		{
			Debug.Log("wave prefab has no player set");
		}
	}
}
