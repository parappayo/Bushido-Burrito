
using UnityEngine;

public class PlayerShoot : MonoBehaviour {
	
	public GameObject ShotTakenMessageReciever;
	public ParticleSystem ShotFX;
	public float ShootRefreshTime = 0.2f;
	public float Range = 200f;
	public string EnemyTag = "Enemy";

	private float _ShootElapsed = 0f;

	void Update()
	{
		if (!CanShoot)
		{
			_ShootElapsed += Time.deltaTime;
			return;
		}

		if (CanShoot && IsShotInputActive)
		{
			TakeShot();
		}
	}

	private bool CanShoot
	{
		get
		{
			return _ShootElapsed >= ShootRefreshTime;
		}
	}

	private bool IsShotInputActive
	{
		get
		{
			return  Input.GetButtonDown("Fire1") ||
					Input.GetButtonDown("Fire2") ||
					Input.GetButtonDown("Fire3") ||
					Input.GetButtonDown("Jump");
		}
	}

	private void TakeShot()
	{
		_ShootElapsed = 0f;

		PlayShotFX();

		RaycastHit hit;
		if (Raycast(out hit))
		{
			GameObject hitObject = hit.transform.gameObject;
			if (hitObject.CompareTag(EnemyTag))
			{
				hitObject.SendMessage("OnShotByPlayer", hit);
			}
		}

		if (ShotTakenMessageReciever != null)
		{
			ShotTakenMessageReciever.SendMessage("ShotTaken");
		}
	}

	private void PlayShotFX()
	{
		if (ShotFX == null) { return; }

		ParticleSystem.EmissionModule emission = ShotFX.emission;
		emission.enabled = false;
		ShotFX.Simulate(0f, true, true);
		emission.enabled = true;

		ShotFX.Play();
	}

	private bool Raycast(out RaycastHit hit)
	{
		Transform source = Camera.main.transform;
		return Physics.Raycast(source.position, source.forward, out hit, Range);
	}

} // class
