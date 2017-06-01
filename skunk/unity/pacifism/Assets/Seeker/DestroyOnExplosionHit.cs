
using UnityEngine;

public class DestroyOnExplosionHit : MonoBehaviour
{
	public void ExplosionHit(GameObject source)
	{
		Poolable.Destroy(this.gameObject);
	}
}
