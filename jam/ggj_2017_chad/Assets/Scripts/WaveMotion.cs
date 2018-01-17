
using UnityEngine;

public class WaveMotion : MonoBehaviour
{
	public float Rise = 4f;
	public float Duration = 3f;

	private Vector3 StartPosition;
	private float _Timer = 0f;

	private void Start()
	{
		StartPosition = transform.position;
		_Timer = Duration;
	}

	private void Update()
	{
		if (_Timer >= Duration)
		{
			transform.position = StartPosition;
			return;
		}

		_Timer += Time.deltaTime;
		float tween = 2f * _Timer / Duration;
		if (tween > 1f) {
			tween = 2f - tween;
		}

		var newPosition = StartPosition;
		newPosition.y += Rise * tween;
		transform.position = newPosition;
	}

	public void Trigger()
	{
        PlayWaveSplashSound();
        _Timer = 0f;
	}

    private void PlayWaveSplashSound()
    {
		var soundManager = SoundManager.Instance;
		if (soundManager != null)
		{
			soundManager.PlayWaveSplash();
		}
    }

	public bool IsPlaying
	{
		get
		{
			return _Timer < Duration;
		}
	}
}
