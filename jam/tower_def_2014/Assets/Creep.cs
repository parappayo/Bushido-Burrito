using UnityEngine;
using System.Collections;

public class Creep : MonoBehaviour
{
	public float Health = 100;
	
	public void Die()
	{
		Destroy(gameObject);
	}
	
	public void TakeDamage(float damage)
	{
		Health -= damage;
		if (Health < 1.0f) { Die(); }
	}
}
