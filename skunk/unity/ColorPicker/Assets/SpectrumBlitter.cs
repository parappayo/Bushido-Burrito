
using UnityEngine;
using System.Collections;

public class SpectrumBlitter : MonoBehaviour
{
	private void Start()
	{
		Texture2D texture = new Texture2D(128, 128);
		GetComponent<Renderer>().material.mainTexture = texture;

		BlitSpectrum(texture);
		texture.Apply();
	}

	private Color ColorFromWavelength(float wavelength)
	{
		Color result = Color.black;

		if (wavelength < 380f) {
			result.r = 1f;
			result.g = 0f;
			result.b = 1f;

		} else if (wavelength < 440f) {
			result.r = -(wavelength - 440f) / (440f - 380f);
			result.g = 0f;
			result.b = 1f;

		} else if (wavelength < 490f) {
			result.r = 0f;
			result.g = (wavelength - 440f) / (490f - 440f);
			result.b = 1f;

		} else if (wavelength < 510f) {
			result.r = 0f;
			result.g = 1f;
			result.b = -(wavelength - 510f) / (510f - 490f);

		} else if (wavelength < 580f) {
			result.r = (wavelength - 510f) / (580f - 510f);
			result.g = 1f;
			result.b = 0f;

		} else if (wavelength < 645f) {
			result.r = 1f;
			result.g = -(wavelength - 645f) / (645f - 580f);
			result.b = 0f;

		} else {
			result.r = 1f;
			result.g = 0f;
			result.b = 0f;
		}

		return result;
	}

	private void BlitSpectrum(Texture2D texture, float startWavelength = 380f, float endWavelength = 645f)
	{
		float wavelengthStep = (endWavelength - startWavelength) / (float)texture.width;

		for (int y = 0; y < texture.height; y++) {
			for (int x = 0; x < texture.width; x++) {
				Color color = ColorFromWavelength(startWavelength + wavelengthStep * x);
				texture.SetPixel(x, y, color);
			}
		}
	}

	private void BlitSierpinski(Texture2D texture)
	{
		for (int y = 0; y < texture.height; y++) {
			for (int x = 0; x < texture.width; x++) {
				Color color = ((x & y) != 0 ? Color.white : Color.gray);
				texture.SetPixel(x, y, color);
			}
		}
	}
}
