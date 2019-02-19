
using UnityEngine;

// cleaned up from the Unity examples found at
// https://docs.unity3d.com/Manual/Example-CreatingaBillboardPlane.html
[RequireComponent(typeof(MeshFilter))]
public class QuadMesh : MonoBehaviour
{
	private MeshFilter _meshFilter;

	private void Start()
	{
		_meshFilter = GetComponent<MeshFilter>();

		float width = transform.localScale.x;
		float height = transform.localScale.y;

		_meshFilter.mesh = Create(width, height);
	}

	private void Update()
	{
		float width = transform.localScale.x;
		float height = transform.localScale.y;

		_meshFilter.mesh.vertices = new Vector3[4]
		{
			new Vector3(0, 0, 0),
			new Vector3(width, 0, 0),
			new Vector3(0, height, 0),
			new Vector3(width, height, 0),
		};
	}

	public static Mesh Create(float width, float height)
	{
		var mesh = new Mesh();

		mesh.vertices = new Vector3[4]
		{
			new Vector3(0, 0, 0),
			new Vector3(width, 0, 0),
			new Vector3(0, height, 0),
			new Vector3(width, height, 0),
		};

		mesh.triangles = new int[6]
		{
			0, 2, 1,
			2, 3, 1,
		};

		mesh.normals = new Vector3[4]
		{
			-Vector3.forward,
			-Vector3.forward,
			-Vector3.forward,
			-Vector3.forward,
		};

		mesh.uv = new Vector2[4]
		{
			new Vector2(0, 0),
			new Vector2(1, 0),
			new Vector2(0, 1),
			new Vector2(1, 1),
		};

		return mesh;
	}
}
