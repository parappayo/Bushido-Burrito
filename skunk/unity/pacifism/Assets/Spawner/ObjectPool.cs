
using UnityEngine;

public class ObjectPool : MonoBehaviour
{
	public GameObject PrototypeObject;

	public GameObject ParentObject;

	public int PoolSize = 50;

	private Poolable LastFree;

	private void Start()
	{
		if (this.PrototypeObject == null || this.PoolSize < 1) { return; }

		Poolable prevSpawnObject = null;

		for (int count = 0; count < this.PoolSize; count++)
		{
			GameObject spawnObject = Instantiate(this.PrototypeObject);

			Poolable poolable = spawnObject.GetComponent<Poolable>();

			if (poolable == null)
			{
				Debug.LogWarning("could not populate object pool with non-poolable game object");
				return;
			}

			poolable.Previous = prevSpawnObject;

			if (ParentObject != null)
			{
				spawnObject.transform.parent = ParentObject.transform;
			}

			prevSpawnObject = poolable;
		}

		this.LastFree = prevSpawnObject;
	}

	public GameObject Get()
	{
		var lastFree = this.LastFree;
		LastFree = this.LastFree != null ? this.LastFree.Previous : null;
		return lastFree != null ? lastFree.gameObject : null;
	}

	public void Free(GameObject gameObject)
	{
		var poolable = gameObject.GetComponent<Poolable>();
		if (poolable != null)
		{
			poolable.Previous = this.LastFree;
			this.LastFree = poolable;
		}
	}

} // class
