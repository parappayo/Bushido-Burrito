using UnityEngine;
using System.Collections;

public class Act2Logic : MonoBehaviour {

	public GameObject Act1;
	public Player ThePlayer;

	void OnEnable()
	{
		if (Act1 != null)
		{
			Act1.SetActive(false);
		}

		if (ThePlayer != null)
		{
			ThePlayer.StartAct2();
		}
	}
	
	void OnDisable()
	{
		if (Act1 != null)
		{
			Act1.SetActive(true);
		}
	}
}
