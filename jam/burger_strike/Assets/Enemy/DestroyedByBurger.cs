using UnityEngine;
using System.Collections;

public class DestroyedByBurger : MonoBehaviour {

	void OnCollisionEnter(Collision collision)
	{
		if (collision.gameObject.CompareTag("Burger"))
		{
			Destroy(gameObject);
		}
	}
}
