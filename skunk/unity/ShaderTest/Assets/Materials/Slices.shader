
// found here:
// https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html

Shader "Custom/Slices" {

	Properties {
		_MainTex("Texture", 2D) = "white" {}
	}

	SubShader {
		Tags{ "RenderType" = "Opaque" }
		Cull Off

		CGPROGRAM
		#pragma surface surf Lambert

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
			float4 screenPos;
	};

		sampler2D _MainTex;
		sampler2D _BumpMap;

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	Fallback "Diffuse"
}
