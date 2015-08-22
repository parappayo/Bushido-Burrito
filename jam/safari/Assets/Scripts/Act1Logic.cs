using UnityEngine;
using System.Collections;

public class Act1Logic : MonoBehaviour {

	public GameObject Act2;

	void OnEnable()
	{
		if (Act2 != null)
		{
			Act2.SetActive(false);
		}
	}

	void OnDisable()
	{
		if (Act2 != null)
		{
			Act2.SetActive(true);
		}
	}
}
