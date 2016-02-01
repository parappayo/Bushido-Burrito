using UnityEngine;
using System.Collections;

public class InputManager : MonoBehaviour 
{

	public float MouseSensitivityX;
	public float MouseSensitivityY;
	public float jumpSpeed;
	public float moveSpeed;

	private CharacterController controller;
	private Transform charTransform;
	private Camera charCam;
	private  Outliner outliner;
    //private Rigidbody rb;

    public float CameraMinTilt = -45f;
    public float CameraMaxTilt = 45f;
    private float cameraRotateX = 0f;

	private float movementY = 0;

	private void Start()
	{
		controller = GetComponent<CharacterController> ();
		charTransform = GetComponent<Transform> ();
		charCam = GetComponentInChildren<Camera> ();
		outliner = GetComponent<Outliner> ();
		//rb = GetComponent<Rigidbody> ();
	}
	
	private void Update()
	{
		Vector3 movement = new Vector3();
		movement *= 0;


		movement = new Vector3 (Input.GetAxis ("Horizontal"), 0, Input.GetAxis ("Vertical"));
		movement = transform.TransformDirection (movement);
		movement *= moveSpeed;

		if (controller.isGrounded ) 
		{
			if (Input.GetButtonDown ("Jump"))
				movementY = jumpSpeed ;
		}

		movementY += Physics.gravity.y * Time.deltaTime*2;
		movement.y = movementY;

		controller.Move(movement * Time.deltaTime);

		if (Input.GetKeyDown(KeyCode.Escape) )
		{
			Application.Quit();
		}

		if (Input.GetKeyDown(KeyCode.E) ||
            Input.GetMouseButtonDown(0) )
		{
			if(outliner)
				outliner.Interact(); 
		}

		//rb.MovePosition (movement);
		float rotX = Input.GetAxis ("Mouse Y") * Time.deltaTime*100 * MouseSensitivityY;
		float rotY = Input.GetAxis ("Mouse X") * Time.deltaTime*100 * MouseSensitivityX;
		cameraRotateX = Mathf.Clamp(cameraRotateX + rotX, CameraMinTilt, CameraMaxTilt);
		charCam.transform.localEulerAngles = new Vector3 (-cameraRotateX, 0, 0);
		charTransform.transform.Rotate (new Vector3 (0, rotY, 0));
	}
}
