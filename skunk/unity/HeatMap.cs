
using System;
using UnityEngine;

namespace BushidoBurrito
{

public class HeatMap : MonoBehaviour
{
	public Vector3 MinWorldPosition = -Vector3.one;
	public Vector3 MaxWorldPosition = Vector3.one;

	public uint MapWidth = 128;
	public uint MapHeight = 128;

	public string GameObjectTag;

	public uint GameObjectMaxPerCell = 12;

	private uint[] MapData;

#if UNITY_EDITOR
	private Texture2D MapTexture;
#endif

	private void Start()
	{
		MapData = new uint[MapWidth * MapHeight];

#if UNITY_EDITOR
		MapTexture = new Texture2D((int)MapWidth, (int)MapHeight, TextureFormat.ARGB32, false);
		MapTexture.filterMode = FilterMode.Point;
#endif
	}

	private void Update()
	{
		Calculate();
	}

	private void OnGUI()
	{
#if UNITY_EDITOR
		GUI.DrawTexture(new Rect(10, 10, 300, 300), mapTexture, ScaleMode.StretchToFill, false);

		//if (GUI.Button(new Rect(10, 140, 140, 30), "Update Heat Map")) {
		//    Calculate();
		//}
#endif
	}

	public void Calculate()
	{
		ClearMapData(MapData);

		if (string.IsNullOrEmpty(GameObjectTag)) { return; }

		Vector2 mapCellSize = new Vector2(
				(MaxWorldPosition.x - MinWorldPosition.x) / MapWidth,
				(MaxWorldPosition.z - MinWorldPosition.z) / MapHeight
			);

		FillMapData(GameObject.FindGameObjectsWithTag(GameObjectTag), MapData, mapCellSize);

#if UNITY_EDITOR
		GenerateTexture(ref MapTexture, MapData, MapWidth, MapHeight, GameObjectMaxPerCell);
#endif
	}

	static private Vector2 GetCellPosition(Transform t, Vector3 origin, Vector2 cellSize)
	{
		return new Vector2(
			(t.position.x - origin.x) / cellSize.x,
			(t.position.z - origin.z) / cellSize.y);
	}

	static private void ClearMapData(uint[] mapData)
	{
		for (uint i = 0; i < mapData.Length; i++) {
			mapData[i] = 0;
		}
	}

	static private void FillMapData(GameObject[] gameObjects, uint[] mapData, Vector2 mapCellSize)
	{
		foreach (var gameObject in gameObjects) {
			Vector2 cellPosition = GetCellPosition(gameObject.transform, MinWorldPosition, mapCellSize);

			uint cellX = (uint)cellPosition.x;
			if (cellX >= MapWidth) { continue; }

			uint cellY = (uint)cellPosition.y;
			if (cellY >= MapHeight) { continue; }

			uint i = cellY * MapWidth + cellX;
			mapData[i] += 1;
		}
	}

	static private void GenerateTexture(ref Texture2D texture, uint[] mapData, uint mapWidth, uint mapHeight, uint maxMapValue)
	{
		if (maxMapValue == 0) { return; }

		int width = Math.Max(texture.width, (int)mapWidth);
		int height = Math.Max(texture.height, (int)mapHeight);

		for (int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				var i = (uint)(y * mapWidth + x);
				Color c = Color.black;
				c.r = mapData[i] / (float) maxMapValue;
				texture.SetPixel(x, y, c);
			}
		}

		texture.Apply();
	}
}

} // namespace BushidoBurrito
