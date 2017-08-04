
using UnityEngine;

public class QuadBatch : MonoBehaviour
{
	public Texture Texture;

	public float QuadSize = 1f;

	public Vector2 Pivot = new Vector2(0.5f, 0.5f);

	public Vector2[] Positions;

	private void DrawQuad(Vector2 pos, Vector2 pivot)
	{
		var rect = new Rect(pos - pivot, new Vector2(this.QuadSize, this.QuadSize));
		Graphics.DrawTexture(rect, this.Texture);
	}

	private void OnRenderObject()
	{
		GL.PushMatrix();
		GL.MultMatrix(transform.localToWorldMatrix);

		var pivot = this.Pivot * this.QuadSize;

		foreach (var pos in this.Positions) {
			DrawQuad(pos, pivot);
		}

		GL.PopMatrix();
	}
}	
