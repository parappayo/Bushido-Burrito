
using UnityEngine;

public class DestroyOnExplosionHit : MonoBehaviour
{
	public void ExplosionHit(GameObject source)
	{
		Destroy(gameObject);
	}
}
