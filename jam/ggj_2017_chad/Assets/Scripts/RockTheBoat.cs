
using UnityEngine;

public class RockTheBoat : MonoBehaviour
{
    private bool RockUpDirection = false;
    private WaveDef _WaveDef;

    public void SetRocking(WaveDef waveDef)
    {
        this._WaveDef = waveDef;
    }

    void Update()
    {
        if (this._WaveDef == null)
        {
            return;
        }

        if (RockUpDirection)
        {
            if (transform.rotation.z < this._WaveDef.boatMaxAngle)
            {
                transform.RotateAround(Vector3.zero, new Vector3(0, 0, 1), this._WaveDef.boatRockingSpeed * Time.deltaTime);
            }
            else
            {
                this.RockUpDirection = !this.RockUpDirection;
            }
        }
        else // rock down
        {
            if (transform.rotation.z > -this._WaveDef.boatMaxAngle)
            {
                transform.RotateAround(Vector3.zero, new Vector3(0, 0, -1), this._WaveDef.boatRockingSpeed * Time.deltaTime);
            }
            else
            {
                this.RockUpDirection = !this.RockUpDirection;
            }
        }
    }
}
