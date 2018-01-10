
using System.Reflection;
using System.Collections.Generic;
using System.Text;

using UnityEditor;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public static class FindAllReferencesTool
{
	public static List<string> GetHeirarchyNames(GameObject gameObject)
	{
		List<string> result = new List<string>();
		Transform transform = gameObject.transform;

		while (transform != null) {
			result.Add(transform.name);
			transform = transform.parent;
		}

		return result;
	}

	public static string GetHierarchyString(GameObject gameObject)
	{
		if (gameObject == null) { return string.Empty; }

		List<string> names = GetHeirarchyNames(gameObject);
		if (names.Count < 1) { return string.Empty; }

		StringBuilder result = new StringBuilder();
		result.Append(names[names.Count - 1]);

		for (int i = names.Count - 2; i >= 0; --i) {
			result.AppendFormat(" > {0}", names[i]);
		}

		return result.ToString();
	}

	public static void AddSceneBehavioursToList(Scene scene, List<MonoBehaviour> behaviours)
	{
		if (!scene.isLoaded) { return; }

		foreach (var root in scene.GetRootGameObjects()) {
			behaviours.AddRange(root.GetComponentsInChildren<MonoBehaviour>(true));
		}
	}

	public static List<MonoBehaviour> GetAllBehaviours()
	{
		List<MonoBehaviour> behaviours = new List<MonoBehaviour>();

		for (int i = 0; i < SceneManager.sceneCount; i++) {
			AddSceneBehavioursToList(SceneManager.GetSceneAt(i), behaviours);
		}

		return behaviours;
	}

	private static void CheckForReference(GameObject fieldValue, GameObject target, MonoBehaviour behaviour, List<GameObject> foundList)
	{
		if (fieldValue != target) { return; }

		Debug.Log("Reference Found: " + behaviour.gameObject + "\n" + GetHierarchyString(behaviour.gameObject));
		foundList.Add(behaviour.gameObject);
	}

	public static void CheckForReference(MonoBehaviour behaviour, GameObject gameObject, FieldInfo fieldInfo, List<GameObject> foundGameObjects)
	{
		if (fieldInfo.FieldType == typeof(GameObject)) {
			var fieldValue = fieldInfo.GetValue(behaviour) as GameObject;
			if (fieldValue == null) { return; }

			CheckForReference(fieldValue, gameObject, behaviour, foundGameObjects);

		} else if (fieldInfo.FieldType == typeof(Transform)) {
			var fieldValue = fieldInfo.GetValue(behaviour) as Transform;
			if (fieldValue == null) { return; }

			CheckForReference(fieldValue.gameObject, gameObject, behaviour, foundGameObjects);

		} else if (fieldInfo.FieldType == typeof(UnityEvent)) {
			var fieldValue = fieldInfo.GetValue(behaviour) as UnityEvent;
			if (fieldValue == null) { return; }

			for (int i = fieldValue.GetPersistentEventCount() - 1; i >= 0; i--) {
				var component = fieldValue.GetPersistentTarget(i) as Component;
				CheckForReference(component != null ? component.gameObject : null, gameObject, behaviour, foundGameObjects);
			}

		} else if (fieldInfo.FieldType == typeof(GameObject[])) {
			var fieldValue = fieldInfo.GetValue(behaviour) as GameObject[];
			if (fieldValue == null) { return; }

			foreach (var arrayMember in fieldValue) {
				CheckForReference(arrayMember, gameObject, behaviour, foundGameObjects);
			}

		} else if (fieldInfo.FieldType == typeof(List<GameObject>)) {
			var fieldValue = fieldInfo.GetValue(behaviour) as List<GameObject>;
			if (fieldValue == null) { return; }

			foreach (var listMember in fieldValue) {
				CheckForReference(listMember, gameObject, behaviour, foundGameObjects);
			}

		} else if (fieldInfo.FieldType == typeof(List<Transform>)) {
			var fieldValue = fieldInfo.GetValue(behaviour) as List<Transform>;
			if (fieldValue == null) { return; }

			foreach (var listMember in fieldValue) {
				CheckForReference(listMember != null ? listMember.gameObject : null, gameObject, behaviour, foundGameObjects);
			}
		}
	}

	public static List<GameObject> GetAllReferencesToGameObject(GameObject gameObject)
	{
		var foundGameObjects = new List<GameObject>();

		foreach (var behaviour in GetAllBehaviours())
		{
			if (behaviour == null) { continue; }

			var fields = behaviour.GetType().GetFields(BindingFlags.Public | BindingFlags.Instance);

			foreach (var field in fields) {
				CheckForReference(behaviour, gameObject, field, foundGameObjects);
			}
		}

		return foundGameObjects;
	}

	[MenuItem("Tools/Find All References")]
	public static void FindAllReferencesToActiveGameObject()
	{
		var gameObject = Selection.activeGameObject;

		if (gameObject == null) {
			Debug.LogWarning("Find All References: nothing selected");
			return;
		}

		var foundGameObjects = GetAllReferencesToGameObject(gameObject);

		if (foundGameObjects.Count > 0) {
			EditorGUIUtility.PingObject(gameObject);
			Selection.objects = foundGameObjects.ToArray();
		} else {
			Debug.LogWarning("Find All References: nothing found for " + gameObject);
		}
	}
}
