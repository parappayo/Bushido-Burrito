
using UnityEngine;
using UnityEngine.Events;

namespace BushidoBurrito
{

public class TriggerEnterEvent : MonoBehaviour
{
	public string gameObjectTag;

	public UnityEvent onTriggerEnter;

	private void OnTriggerEnter(Collider other)
	{
		if (!string.IsNullOrEmpty(gameObjectTag) &&
			other.gameObject.CompareTag(gameObjectTag))
		{
			onTriggerEnter.Invoke();
		}
	}
}

} // namespace BushidoBurrito
