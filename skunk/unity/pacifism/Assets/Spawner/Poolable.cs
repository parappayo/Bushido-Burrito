
using UnityEngine;

public class Poolable : MonoBehaviour
{
	public Poolable Previous;

	public PooledSpawner Spawner;

	public void Free()
	{
		this.Spawner.Free(this.gameObject);
	}

	public static void Destroy(GameObject gameObject)
	{
		var poolable = gameObject.GetComponent<Poolable>();
		if (poolable != null)
		{
			poolable.Free();
		}
		else
		{
			Destroy(gameObject);
		}
	}
}
