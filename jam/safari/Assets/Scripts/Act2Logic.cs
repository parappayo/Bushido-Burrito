using UnityEngine;
using System.Collections;

public class Act2Logic : MonoBehaviour {

	public GameObject Act1;

	void OnEnable()
	{
		if (Act1 != null)
		{
			Act1.SetActive(false);
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
