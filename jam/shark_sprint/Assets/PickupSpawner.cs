

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PickupSpawner : MonoBehaviour
{
	public GameObject Pickup;
	public Vector3 StartingPosition;
	
	void Start()
	{
		Spawn();
	}
	
	public void Reset()
	{
		Unspawn();
		Spawn();
	}
	
	private void Unspawn()
	{
		List<GameObject> children = new List<GameObject>();
		
		for (int i = 0; i < gameObject.transform.childCount; i++)
		{
			// this is to avoid destroying while looping over them
			children.Add(gameObject.transform.GetChild(i).gameObject);
		}
			
		foreach (GameObject child in children)
		{
			Destroy(child);
		}
	}
	
	private void Spawn()
	{
		for (float t = 0; t < 80.0f; t += 1.0f)
		{
			GameObject pickup = (GameObject) Instantiate(Pickup);
			pickup.transform.parent = gameObject.transform;
			
			float x = Mathf.Sin(t * 0.5f) * 2.0f;
			float y = Mathf.Sin(t * 0.2f) * 1.6f;
			float z = t * 2.0f;
			
			pickup.transform.position = StartingPosition + new Vector3(x, y, z);
		}
	}
	
} // class
